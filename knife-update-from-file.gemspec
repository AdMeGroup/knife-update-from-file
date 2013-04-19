$:.unshift(File.dirname(__FILE__) + '/lib')
require 'knife-update-from-file/version'

Gem::Specification.new do |s|
  s.name = 'knife-update-from-file'
  s.version = KnifeUpdateFromFile::VERSION
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = [ "LICENSE", "README.md" ]
  s.summary = "Knife Update From File"
  s.description = s.summary
  s.authors = [ "AdMe Group", "Timur Batyrshin" ]
  s.email = [ "tech.support@adme.ru", "erthad@gmail.com" ]
  s.homepage = "https://github.com/timurbatyrshin/knife-update-from-file"
  s.require_path = 'lib'
  s.files = [ "LICENSE" ] + Dir.glob("lib/**/*")
  s.licenses = ["Apache 2.0"]
end
