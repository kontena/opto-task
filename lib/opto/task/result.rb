module Opto
  module Task
    class Result
      attr_reader :task, :errors
      attr_accessor :outcome

      def initialize(task = nil)
        @task = task
        @errors = {}
      end

      def success?
        errors.empty?
      end

      def failure?
        !success?
      end
    end
  end
end
