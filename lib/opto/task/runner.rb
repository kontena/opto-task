require_relative 'result'

module Opto
  module Task
    module Runner

      def errors
        wait_for_lock
        super.merge(runner_errors)
      end

      def valid?
        wait_for_lock
        runner_errors.clear
        validate if self.respond_to?(:validate)
        errors.empty? && super
      end

      def wait_for_lock
        sleep 0.001 until !mutex.locked? || mutex.owned?
      end

      def mutex
        @mutex ||= Mutex.new
      end

      def runner_errors
        wait_for_lock
        @runner_errors ||= {}
      end

      def add_error(field, classification, message)
        runner_errors[field] ||= {}
        runner_errors[field][classification] =
          case runner_errors[field][classification]
          when String
            runner_errors[field][classification] == message ? runner_errors[field][classification] : [runner_errors[field][classification], message]
          when Array
            runner_errors[field][classification].include?(message) ? runner_errors[field][classification] : (runner_errors[field][classification] + [message])
          else
            message
          end
      end

      def run
        mutex.synchronize do
          current_run = Opto::Task::Result.new(self)

          if valid?

            runner_errors.clear
            outcome = perform
            current_run.errors.merge!(runner_errors)
            if current_run.success?
              current_run.outcome = outcome
              after if self.respond_to?(:after)
            end
            runner_errors.clear
          else
            current_run.errors.merge!(errors)
          end
          return current_run
        end
      end
    end
  end
end
