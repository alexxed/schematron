Gem::Specification.new do |spec|
  spec.name = "schematron"
  spec.version = "1.1.3"   #SemVer.find.format '%M.%m.%p'
  spec.summary = "ISO Schematron Validation"
  spec.email = "flazzarino@gmail.com"
  spec.homepage = 'http://github.com/flazz/schematron'
  spec.authors = ["Francesco Lazzarino"]
  spec.executables << 'stron'

  spec.files = ["schematron.gemspec", "README.md", "LICENSE.txt", '.semver']
  spec.files += Dir['lib/*.rb']
  spec.files += Dir['spec/**/*']
  spec.files += Dir['iso-schematron-xslt1/*']
  spec.add_dependency 'nokogiri'
end
