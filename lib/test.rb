class Test
  def initialize(instance_id, config, test_line)
    @test_line = test_line
    @config = config
    @command = SSMCommand.new(instance_id, format_commands, @config)
    @reported = false
  end
  
  def format_commands
    [
      "cd #{@config['root']}",
      "cucumber '#{@test_line}' #{@config['command_options']}"
    ]
  end
  
  def run
    @command.send
  end
  
  def complete?
    return false unless @command.status == "Success" or @command.status == "Failed"
    report_results unless @reported
    @reported = true
  end
  
  def output
    @command.output
  end
  
  def report_results
    puts output
  end
end