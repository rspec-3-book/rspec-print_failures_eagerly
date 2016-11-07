require 'rspec/core'
require 'rspec/core/formatters/base_text_formatter'
require 'rspec/print_failures_eagerly/version'

module RSpec
  module PrintFailuresEagerly
    class Formatter
      RSpec::Core::Formatters.register self, :example_failed

      def initialize(output)
        @output = output
        @last_failure_index = 0
      end

      def example_failed(notification)
        @output.puts
        @output.puts notification.fully_formatted(@last_failure_index += 1)
        @output.puts
      end
    end

    module SilenceDumpFailures
      def dump_failures(_notification)
      end

      RSpec::Core::Formatters::BaseTextFormatter.prepend(self)
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    config.add_formatter RSpec::PrintFailuresEagerly::Formatter
  end
end
