class Node
  attr_reader :id

  def initialize(id, resource, config)
    @id = id
    @resource = resource
    @config = config
    @test = nil
  end
  
  def ready_for_assignment?
    node_up? and (!@test or @test.complete?)
  end
  
  def node_up?
    status0 = @resource.client.describe_instance_status({instance_ids: [@id]}).instance_statuses[0]
    state == 16 and status0 and status0.instance_status.details[0].status == 'passed'
  end
  
  def state
    instance.state.code
  end
  
  def instance
    @resource.instance(id)
  end

  def run_test(test_line)
    @test = Test.new(id, @config, test_line) 
    @test.run 
  end

  def destroy
    if ready_for_assignment?
      terminate
      true
    else
      false
    end
  end
  
  def terminate
    instance.terminate
  end
end