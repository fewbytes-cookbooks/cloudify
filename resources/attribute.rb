attribute :key, :name_attribute => true
attribute :value, :default => nil
attribute :scope, :default => :instance, :equal_to => [:instance, :global, :application, :service]
attribute :identity, :default => :this, :callbacks => {
	:validate => proc{|v| 
		(v.is_a?(Symbol) and v == :this) or v.is_a?(String)
	}}

actions :set, :unset
default_action :set