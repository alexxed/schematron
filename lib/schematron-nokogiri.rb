require 'nokogiri'

module SchematronNokogiri

  class Schema

    # The location of the ISO schematron implemtation lives
    ISO_IMPL_DIR = File.join File.dirname(__FILE__), "..", 'iso-schematron-xslt1'

    # The file names of the compilation stages
    ISO_FILES = ['iso_dsdl_include.xsl',
                 'iso_abstract_expand.xsl',
                 'iso_svrl_for_xslt1.xsl']

    # Namespace prefix declarations for use in XPaths
    NS_PREFIXES = {
        'svrl' => 'http://purl.oclc.org/dsdl/svrl'
    }

    def initialize(doc)
      schema_doc = doc

      xforms = ISO_FILES.map do |file|

        Dir.chdir(ISO_IMPL_DIR) do
          Nokogiri::XSLT(File.open(file))
        end

      end

      # Compile schematron into xsl that maps to svrl
      @validator_doc = xforms.inject(schema_doc) {
          |xml, xsl| xsl.transform xml
      }
      @validator_xsl = Nokogiri::XSLT(@validator_doc.to_s)
    end

    def validate(instance_doc)

      # Validate the xml
      results_doc = @validator_xsl.transform instance_doc

      # compile the errors and log any messages
      rule_hits(results_doc, instance_doc, 'assert', '//svrl:failed-assert') +
          rule_hits(results_doc, instance_doc, 'report', '//svrl:successful-report')
    end

    def prefixes
      namespaces = {}

      @validator_doc.namespaces.each {
          |k, v| namespaces[k.gsub 'xmlns:', ''] = v
      }
      namespaces
    end

    # Look for reported or failed rules of a particular type in the instance doc
    def rule_hits(results_doc, instance_doc, rule_type, xpath)

      results = []

      results_doc.root.xpath(xpath, NS_PREFIXES).each do |hit|
        context_tag = hit
        context_path = nil
        while context_path.nil?
          context_tag = context_tag.previous_sibling
          context_path = context_tag['context']
        end

        context = instance_doc.root.xpath(
            context_path ? '/' + context_path : hit['location'],
            NS_PREFIXES.merge(prefixes)
        ).first

        hit.xpath('svrl:text/text()', NS_PREFIXES).each do |message|
          results << {
              :rule_type => rule_type,
              :type => node_type(context),
              :name => context.name,
              :line => context.line,
              :context_path => context_path,
              :message => message.content.strip}
        end
      end

      results

    end

    def node_type(node)
      case
        when node.cdata?
          'cdata'
        when node.comment?
          'comment'
        when node.element?
          'element'
        when node.fragment?
          'fragment'
      end
    end

  end
end

