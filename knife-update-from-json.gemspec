$:.unshift(File.dirname(__FILE__) + '/lib')
require 'knife-update-from-json/version'

Gem::Specification.new do |s|
  s.name = 'knife-update-from-json'
  s.version = KnifeUpdateFromJSON::VERSION
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.md" ]
  s.summary = "Knife update from JSON"
  s.description = s.summary
  s.author = "Timur Batyrshin"
  s.email = "erthad@gmail.com"
  s.homepage = "http://wiki.opscode.com/display/chef"
  s.require_path = 'lib'
  s.files = %w(README.md) + Dir.glob("lib/**/*")
end
