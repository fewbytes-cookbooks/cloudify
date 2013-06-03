include_recipe "ohai"

chef_handler "Cloudify::ChefHandlers::AttributesDumpHandler" do
  source "handlers/cloudify"
  action :enable
end

