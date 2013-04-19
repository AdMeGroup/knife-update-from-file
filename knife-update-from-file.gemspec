$:.unshift(File.dirname(__FILE__) + '/lib')
require 'knife-update-from-file/version'

Gem::Specification.new do |s|
  s.name = 'knife-update-from-file'
  s.version = KnifeUpdateFromFile::VERSION
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = [ ]
  s.summary = "Knife Update From File"
  s.description = s.summary
  s.author = "Timur Batyrshin"
  s.email = "erthad@gmail.com"
  s.homepage = "http://wiki.opscode.com/display/chef"
  s.require_path = 'lib'
  s.files = Dir.glob("lib/**/*")
end
