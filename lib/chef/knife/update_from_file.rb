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
    COMPONENTS = [
      :default,
      :env_default,
      :role_default,
      :force_default,
      :normal,
      :override,
      :role_override,
      :env_override,
      :force_override,
      :automatic
    ].freeze

    deps do
      require 'chef/search/query'
      require 'chef/knife/core/object_loader'
    end

    banner "knife node update from file FILE (options)"

    def loader
      @loader ||= ::Chef::Knife::Core::ObjectLoader.new(Chef::Node, ui)
    end

    def merge(from, to)
      COMPONENTS.each do |component_ivar|
        from_value = from.send(component_ivar)
        to_value = to.send(component_ivar)
        Chef::Mixin::DeepMerge.merge(to_value, from_value)
      end
    end


    def run
      updated = loader.load_from("nodes", @name_args[0])
      @node_name = updated.name
      ui.info("Looking for #{@node_name}")

      searcher = Chef::Search::Query.new
      result = searcher.search(:node, "name:#{@node_name}")

      node = result.first.first
      if node.nil?
        ui.error("Could not find a node named #{@node_name}")
        exit 1
      end
      merge(updated, node)
      ui.info("Saving the updated node #{@node_name}")
      node.save
      ui.info("All done")
    end
  end
end
