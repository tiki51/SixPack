class Test
  def initialize(id, command)
    @id = id
    @command = command
    @reported = false
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