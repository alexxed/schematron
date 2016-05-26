Gem::Specification.new do |spec|
  spec.name = "schematron-nokogiri"
  spec.description = "Using this gem you can validate an XML document using a ISO Schematron validation file"
  spec.version = "0.0.1"   #SemVer.find.format '%M.%m.%p'
  spec.summary = "ISO Schematron Validation using Nokogiri"
  spec.email = "alexxed@gmail.com"
  spec.homepage = 'https://github.com/alexxed/schematron'
  spec.authors = ["Francesco Lazzarino", "Alexandru Szasz"]
  spec.executables << 'stron-nokogiri'
  spec.licenses = ["MIT"]

  spec.files = ["schematron-nokogiri.gemspec", "README.md", "LICENSE.txt", '.semver']
  spec.files += Dir['lib/*.rb']
  spec.files += Dir['spec/**/*']
  spec.files += Dir['iso-schematron-xslt1/*']
  spec.add_dependency 'nokogiri', '~> 1.6'
end
