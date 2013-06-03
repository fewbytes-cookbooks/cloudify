module Cloudify
  module ChefHandlers
    class AttributesDumpHandler << ::Chef::Handler
      include ::Cloudify::REST

      def report
        cloudify_rest(:instance,
                      node["cloudify"]["application_name"],
                      node["cloudify"]["service_name"],
                      node["cloudify"]["instance_id"],
                      "chef_node_attributes",
                      node.to_json
                     )
      end
    end
  end
end

