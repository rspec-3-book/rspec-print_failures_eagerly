require "rspec/core"
require "rspec/core/formatters/base_text_formatter"
require "rspec/print_failures_eagerly/version"

module RSpec
  module PrintFailuresEagerly
    def self.lazily_add_formatter_to(config)
      config.before(:suite) { config.add_formatter Formatter }
    end

    class Formatter
      RSpec::Core::Formatters.register self, :example_failed

      def initialize(output)
        @output = output
        @failure_count = 0
      end

      def example_failed(notification)
        @output.puts
        @output.puts notification.fully_formatted(@failure_count += 1)
        @output.puts
      end

      def self.active?
        active_formatters = RSpec.configuration.formatters
        active_formatters.grep(self).any?
      end
    end

    module NeuterDumpFailures
      def dump_failures(_notification)
        super unless Formatter.active?
      end

      RSpec::Core::Formatters::BaseTextFormatter.prepend(self)
    end
  end
end

RSpec.configure do |config|
  RSpec::PrintFailuresEagerly.lazily_add_formatter_to(config)
end
