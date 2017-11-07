class Node
    attr_reader :id
    
    def initialize(client, id, config)
        @client = client
        @id = id
        @config = config
        @command = nil
        @destroyed = false
    end
    
    def status
        state = instance.state.code
        if state == 16
            test_status
        else
            state
        end
    end
    
    def instance
        @client.instance(id)
    end
    
    def run_test(test_id)
        return false if @client.client.describe_instance_status({instance_ids: [@id]}).instance_statuses[0].instance_status.details[0].status != 'passed'
        @command = SSMCommand.new(@id,["cd #{@config['root']}"," bundle exec cucumber -t #{test_id}"])
    end
    
    def test_status
        return "IN PROGRESS" if @command and @command.status != "Success" and @command.status != "Failed"
        puts @command.output if @command
        "READY"
    end
    
    def destroy
        #binding.pry
        if status == 'Success' or status == 'Failed' or status == 'READY'
            terminate
            @destroyed = true
        end
    end
    
    def terminate
        instance.terminate
    end
    
    def destroyed?
        @destroyed
    end
end









































