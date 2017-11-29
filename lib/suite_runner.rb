require 'yaml'
require 'pry'

class SuiteRunner

  def initialize(suite)
    @config = YAML.load_file('config/suites.yaml')[suite]
    @tests = get_tests
  end

  def run_suite
    cluster = Cluster.new(@config, @tests)
    begin
      cluster.assign_tests
      cluster.monitor_nodes
    rescue => e
      cluster.terminate_all_nodes
      raise e
    end
  end

  def get_tests
    file_lines = CukeSlicer::Slicer.new.slice(@config['local_file_source'], get_filters, :file_line)
    file_lines.map {|file_line| file_line.gsub(@config['local_file_source'], 'features')}    
  end
  
  def get_filters
    filters = Hash.new
    criterias = ['excluded_tags', 'included_tags', 'excluded_paths', 'included_paths'] 
    criterias.each { |criteria| filters[criteria.to_sym] = @config[criteria] if @config[criteria]}
    filters
  end

end
