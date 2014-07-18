include_recipe 'ohai' # work around missing node['ohai']['plugin_path']
include_recipe 'nginx' # required otherwise missing nginx user
include_recipe 'kibana::install'

template "#{node['nginx']['dir']}/sites-available/kibana" do
  source node['kibana']['nginx']['template']
  cookbook node['kibana']['nginx']['template_cookbook']
  notifies :reload, 'service[nginx]'
  variables(
    es_server: node['kibana']['es_server'],
    es_port: node['kibana']['es_port'],
    server_name: node['kibana']['webserver_hostname'],
    server_aliases: node['kibana']['webserver_aliases'],
    kibana_dir: "#{node['kibana']['install_dir']}/current",
    listen_address: node['kibana']['webserver_listen'],
    listen_port: node['kibana']['webserver_port'],
    es_scheme: node['kibana']['es_scheme']
  )
end
