require_relative 'lib/node.rb'
require_relative 'lib/cluster.rb'
require_relative 'lib/suite_runner.rb'
require_relative 'lib/ssm_command.rb'
require_relative 'lib/test.rb'
require 'time'

sr = SuiteRunner.new('test_suite')
sr.run_suite