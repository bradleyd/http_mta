#!/usr/bin/ruby

require 'yaml'

module ParseConfig
  @config_file = "config.yml"
  def self.read_config
    config=YAML.load_file(@config_file)
    return config
  end

end

