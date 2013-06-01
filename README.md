cloudify Cookbook
=================
This coookbook provides interop between Chef and Cloudify.

Requirements
------------
For the Ohai plugin, use the `ohai` cookbook, you can either add `recipe[cloudify]` or `recipe[ohai]` to your `run_list`.

Attributes
----------
`node['cloudify']['rest_management_url']` - The URL of Cloudify REST API. This is usually something like `http://management-machine-hostname:8100/`. At the moment there is no way to autodectect this (management IP is available from LOOKUPLOCATORS environment variable but the port is not) so just set it up front when launching Chef.

Usage
-----
The cookbook contains `cloudify_attribute` LWRP which can be used to set/unset attributes: 

    cloudify_attribute "foo" do
      value "bar" # not needed when using the unset action
      scope :instance
      action :set # default is set
    end

You can read attributes using the `cloudify_get_attribute` function which is available in recipes:

    # cloudify_get_attribute(scope, attribute, opts={})
    cloudify_get_attribute(:application, "mysql_address")

The `cloudify_get_attribute` function accepts keyword arguments `:application`, `:service` and `:instance`. Use them if you need to get attributes from different contexts.

License and Authors
-------------------
Authors: Avishai Ish-Shalom <avishai@fewbytes.com>

Distributed under the Apache v2 license.
