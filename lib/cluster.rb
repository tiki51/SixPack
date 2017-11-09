require 'aws-sdk'

class Cluster
    def initialize(config)
        @config =config
        spin_up_nodes
    end
    
    def spin_up_nodes
       puts "Brewing up a #{@config['node_count']} pack..."
       ec2 = Aws::EC2::Resource.new
       params = {
           image_id: @config['ami'],
           instance_type: 't2.micro',
           key_name: @config['key'],
           min_count: 1,
           max_count: @config['node_count'],
           iam_instance_profile: {
                arn: @config['ssm_profile']
                }
           }
       instances = ec2.create_instances(params)
       @nodes = instances.map do |ins|
           Node.new(ec2, ins.id, @config)
       end
    end
    
    def assign_tests(tests = nil)
        @tests ||= tests
        @nodes.each do |node|
            test_started = node.run_test(@tests[-1]) if (node.status == 'READY') and !@tests.empty?
            @tests.pop if test_started
        end
    end
    
    def nodes_destroyed?
        #binding.pry
        @nodes.reject! {|node| node.destroyed?}
        @nodes == []
    end
    
    def monitor_nodes
        assign_tests until @tests.empty?
        @nodes.each {|node| node.destroy} until nodes_destroyed?
    end
    
end
