require File.join(File.dirname(__FILE__), 'spec_helper')
require 'schematron'

describe Schematron::Schema do

  it "should load a schema from a libxml document" do
    file = File.join "spec", "schema", "pim.sch"
    doc = Nokogiri::XML(File.open(file))
    lambda { Schematron::Schema.new doc }.should_not raise_error
  end

  it "should validate a good instance doc" do
    schema_file = File.join 'spec', 'schema', 'fda_sip.sch'
    instance_file = File.join 'spec', 'instances', 'daitss-sip', 'Example1.xml'

    schema_doc = Nokogiri::XML(File.open(schema_file))
    instance_doc = Nokogiri::XML(File.open(instance_file))

    stron = Schematron::Schema.new schema_doc
    results = stron.validate instance_doc
    
    results.should be_empty
  end
  
  it "should detect errors for a bad document" do
    schema_file = File.join 'spec', 'schema', 'fda_sip.sch'
    instance_file = File.join 'spec', 'instances', 'daitss-sip', 'Example2.xml'

    schema_doc = Nokogiri::XML(File.open(schema_file))
    instance_doc = Nokogiri::XML(File.open(instance_file))

    stron = Schematron::Schema.new schema_doc
    results = stron.validate instance_doc
    
    results.should_not be_empty
  end
  
  it "should log report rules in the results" do
    schema_file = File.join 'spec', 'schema', 'pim.sch'
    instance_file = File.join 'spec', 'instances', 'daitss-sip', 'Example1.xml'
    
    schema_doc = Nokogiri::XML(File.open(schema_file))
    instance_doc = Nokogiri::XML(File.open(instance_file))
    
    stron = Schematron::Schema.new schema_doc
    results = stron.validate instance_doc
    
    results.length.should == 1
    results.first[:rule_type].should == 'report'
    
    
  end
  
end
