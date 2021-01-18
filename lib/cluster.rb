require 'aws-sdk'
require 'cuke_slicer'

class Cluster
  def initialize(config, tests)
    @tests = tests

    print_foo()
  end


  def print_foo():
    print('foo')

  def spin_up_nodes
    puts "Brewing up a #{@config['node_count']} pack..."
    ec2 = Aws::EC2::Resource.new
    params = {
        image_id: @config['ami'],
        instance_type: @config['instance_type'],
        key_name: @config['key'],
        min_count: 1,
        max_count: @config['node_count'],
        iam_instance_profile: {
            arn: @config['ssm_profile']
        }
    }
    instances = ec2.create_instances(params)
    @nodes = instances.map do |instance|
      Node.new(instance.id, ec2, @config)
    end
  end

  def assign_tests
    @nodes.each do |node|
      node.run_test(@tests.pop) if !@tests.empty? and node.ready_for_assignment?
    end
  end

  def monitor_nodes
    assign_tests until @tests.empty?
    @nodes.reject! {|node| node.destroy} until @nodes.empty?
  end
  
  def terminate_all_nodes
    @nodes.each {|node| node.terminate}
  end

end
