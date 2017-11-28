class SSMCommand
  attr_reader :id

  def initialize(id, commands, config)
    @instance_id = id
    @client = Aws::SSM::Client.new
    @config = config
    @id = @client.send_command(parameters(id, commands)).command.command_id
  end

  def parameters(id, commands)
    {
        instance_ids: [id],
        document_name: "#{@config['script']}",
        parameters: {
            "commands" => commands
        }
    }
  end

  def get_invocation
    begin
      @client.get_command_invocation({instance_id: @instance_id, command_id: @id})
    rescue => e
      raise e
    end
  end

  def status
    get_invocation.status
  end

  def output
    get_invocation.standard_output_content
  end

end
