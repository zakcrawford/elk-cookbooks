set[:logstash][:instance][:server][:elasticsearch_ip] = OpsWorksUtils::Helpers::layer_elb(node, 'elasticsearch')
set[:logstash][:instance][:server][:elasticsearch_cluster] = 'logstash'
set[:logstash][:instance][:server][:enable_embedded_es] = false
set[:logstash][:instance][:server][:config_templates_cookbook] = 'opsworks_logstash'
set[:logstash][:instance][:server][:config_templates] = {
    'server' => 'server.conf.erb',
}
