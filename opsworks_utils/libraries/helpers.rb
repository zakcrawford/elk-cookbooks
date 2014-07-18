module OpsWorksUtils
  class Helpers
    def self.layer_elb(node, layer)
      raise 'You need to pass a layer name' unless layer

      layer_layer_id = node[:opsworks][:layers][layer][:id]
      layer_elb_host = nil

      node[:opsworks][:stack]['elb-load-balancers'].each do |hash|
        if hash[:layer_id] == layer_layer_id
          layer_elb_host = hash[:dns_name]
        end
      end
      raise "Could not find #{layer} ELB" unless layer_elb_host

      layer_elb_host
    end
  end
end
