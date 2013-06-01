require 'net/http'
require 'uri'

# Ruby helper functions for interacting with the cloudify management machine
# At some point this should be rewritten as a more re-usable library
module Cloudify
  module REST
    #a wrapper for et::HTTP.start that yields a connection to REST interface
    def cloudify_rest(method, scope, key, value=nil)
        cloudify_uri = URI.parse(node['cloudify']['management_rest_url'])
        request = case method
        when :post
            r = ::Net::HTTP::Post.new(cloudify_resource_uri(scope))
            r.body = ::Chef::JSONCompat.to_json({new_resource.name => new_resource.value}) if value
            r
        when :delete
            ::Net::HTTP::Delete.new(cloudify_resource_uri(scope) + "/" + key)
        when :get
            ::Net::HTTP::Get.new(cloudify_resource_uri(scope))
        else
            raise RuntimeError, "Method #{method} not implemented for Cloudify REST"
        end

        request.content_type = 'application/json'     

        result = Net::HTTP.start(cloudify_uri.host, cloudify_uri.port) do |http|
            http.request(request)
        end

        case result
        when Net::HTTPSuccess, Net::HTTPRedirection
          # OK
        else
          raise RuntimeError.new "The REST request failed with code #{result.value}"
        end
    end

    #returns a resource url to be used in a REST request
    def cloudify_resource_uri(scope)
        application = node['cloudify']['application_name']
        service     = node['cloudify']['service_name']
        instance_id = node['cloudify']['instance_id']

        case scope
            when :global      then "/attributes/globals"
            when :application then "/attributes/applications/#{application}"
            when :service     then "/attributes/services/#{application}/#{service}"
            when :instance    then "/attributes/instances/#{application}/#{service}/#{instance_id}"
            else raise ArgumentError.new """Invalid attribute type '#{resource[:type]}'.
                                            Use one of: global/application/service/instance"""
        end
    end

    def cloudify_get_attribute(scope, attribute)
        cloudify_rest(:get, scope, attribute)
    end
  end
end

class Chef::Recipe; include ::Cloudify::REST; end
