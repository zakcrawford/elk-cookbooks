name = 'server'

Chef::Application.fatal!("attribute hash node['logstash']['instance']['#{name}'] must exist.") if node['logstash']['instance'][name].nil?

execute 'allow java to bind on <1024 ports' do
  command 'setcap cap_net_raw+epi $(realpath $(which java))'
end

logstash_instance name do
  action :create
end

logstash_service name do
  action [:enable]
end

logstash_config name do
  variables node['logstash']['instance']['default'].merge(node['logstash']['instance'][name])
  action [:create]
end

logstash_plugins 'contrib' do
  instance name
  action [:create]
end

logstash_pattern name do
  action [:create]
end

logstash_service name do
  action [:start]
end

execute "make sure the logstash_#{name} service started" do
  command "service logstash_#{name} start"
end
