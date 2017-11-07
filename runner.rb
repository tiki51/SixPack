require_relative 'lib/node.rb'
require_relative 'lib/cluster.rb'
require_relative 'lib/suite_runner.rb'
require_relative 'lib/ssm_command.rb'
require 'time'

$t0 = Time.now
sr = SuiteRunner.new('test_suite')
sr.run_suite
