#
# Author:: Timur Batyrshin (<erthad@gmail.com>)
# Copyright:: Copyright (c) 2013 AdMe Group
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
      require 'chef/knife/core/object_loader'
    end

    banner "knife node update from file FILE (options)"

    def loader
      @loader ||= ::Chef::Knife::Core::ObjectLoader.new(Chef::Node, ui)
    end

    def searcher
      @searcher ||= ::Chef::Search::Query.new
    end

    def update_node(node, updated)
      node.normal_attrs = Chef::Mixin::DeepMerge.merge(node.normal_attrs, updated.normal_attrs)
      node.override_attrs = Chef::Mixin::DeepMerge.merge(node.override_attrs, updated.override_attrs)
      node.run_list(updated.run_list)
      node.chef_environment(updated.chef_environment)
      node
    end

    def run
      file_path = @name_args[0]
      updated = loader.load_from("nodes", file_path)
      node_name = updated.name

      ui.info("Looking for #{node_name}")

      result = searcher.search(:node, "name:#{node_name}")

      node = result.first.first

      if node.nil?
        ui.warn("Could not find a node named #{node_name}")
        result = ui.ask_question("Create a new one? (Y/N)", :default => "y").upcase
        if ['Y', 'YES'].include?(result)
          system( *%W{knife node from file #{file_path}})
        else
          ui.info("Exiting to system")
          exit 1
        end

      else
        update_node(node, updated)

        ui.info("Saving the updated node #{@node_name}")
        node.save
      end
    end
  end
end
