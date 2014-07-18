set[:java][:install_flavor] = 'openjdk'
set[:java][:jdk_version] = '7'

set[:elasticsearch][:version] = '1.2.2'
set[:elasticsearch][:filename] = "elasticsearch-1.2.2.tar.gz"
set[:elasticsearch][:download_url] = [
    node[:elasticsearch][:host],
    node[:elasticsearch][:repository],
    node[:elasticsearch][:filename]
].join('/')

set[:elasticsearch][:cluster][:name] = 'logstash'

set[:elasticsearch][:plugins]['karmi/elasticsearch-paramedic'] = {}
set[:elasticsearch][:plugins]['royrusso/elasticsearch-HQ'] = {}
set[:elasticsearch][:plugins]['elasticsearch/elasticsearch-cloud-aws']['version'] = '2.2.0'

set[:elasticsearch][:discovery][:type] = 'ec2'
set[:elasticsearch][:discovery][:zen][:ping][:multicast][:enabled] = false
set[:elasticsearch][:discovery][:ec2][:tag]['opsworks:stack'] = node[:opsworks][:stack][:name]
set[:elasticsearch][:cloud][:aws][:region] = node[:opsworks][:instance][:region]

# Allocation awareness
# https://github.com/amazonwebservices/opsworks-elasticsearch-cookbook/blob/813e9cfbd7f7587a5cca885e92274e23d3f23772/layer-custom/recipes/allocation-awareness.rb
set[:elasticsearch][:custom_config] = {
    'node.rack_id' => "#{node[:opsworks][:instance][:availability_zone]}"
}
