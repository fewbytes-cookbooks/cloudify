include_recipe "ohai"

cookbook_file ::File.join(node["chef_handler"]["handler_path"], "handlers", "cloudify.rb") do
  source "handlers/cloudify.rb"
end

chef_handler "Cloudify::ChefHandlers::AttributesDumpHandler" do
  source ::File.join("handlers", "cloudify.rb")
  action :enable
end

