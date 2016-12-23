require "opto/task/version"
require "opto/task/runner"
require 'opto/model'

module Opto
  module Task
    def self.included(where)
      where.send(:include, Opto::Model)
      where.send(:include, Opto::Task::Runner)
    end
  end

  def self.task
    Task
  end
end
