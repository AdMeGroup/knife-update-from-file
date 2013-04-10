#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2009 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/knife'

module NodeUpdate
  class NodeUpdateFromFile < Chef::Knife

    deps do
      require 'chef/search/query'
      require 'chef/knife/search'
      require 'chef/knife/core/object_loader'
    end

    banner "knife node update from file FILE (options)"

    def loader
      @loader ||= ::Chef::Knife::Core::ObjectLoader.new(Chef::Node, ui)
    end

   def merge(from, to)
     Chef::Node::Attribute::COMPONENTS.inject(Mash.new) do |merged, component_ivar|
       component_value = node.send(component_ivar)
       Chef::Mixin::DeepMerge.merge(merged, component_value)
     end
   end


    def run
      updated = loader.load_from("nodes", @name_args[0])

      @node_name = updated.name
      puts "Looking for #{@node_name}"

      searcher = Chef::Search::Query.new
      result = searcher.search(:node, "name:#{@node_name}")

      knife_search = Chef::Knife::Search.new
      node = result.first.first
      if node.nil?
        puts "Could not find a node named #{@node_name}"
        exit 1
      end
p updated.attributes, node.attributes
#      puts "Setting attribute #{@attribute} to #{@value}"
#      rb_cmd = "node." + @attribute + "=" + '"' + @value + '"'
#      eval(rb_cmd)
#      node.save

#      knife_search = Chef::Knife::Search.new
#      knife_search.name_args = ['node', "name:#{@node_name}"]
#      knife_search.run

    end
  end
end
