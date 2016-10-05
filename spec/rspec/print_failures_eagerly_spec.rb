require "rspec/print_failures_eagerly"
require "rspec/core/sandbox"
require "stringio"

RSpec.describe RSpec::PrintFailuresEagerly do
  around { |ex| RSpec::Core::Sandbox.sandboxed(&ex) }

  it "works with the default progress formatter" do
    expect(run_example_specs).to eq(unindent <<-EOS)
      F
        1) Group 1 fails
           Failure/Error: expect(1).to eq 2

             expected: 2
                  got: 1

             (compared using ==)

           # <truncated backtrace>

      .F
        2) Group 2 fails
           Failure/Error: expect(1).to eq 2

             expected: 2
                  got: 1

             (compared using ==)

           # <truncated backtrace>

      .

      Finished in n.nnnn seconds (files took n.nnnn seconds to load)
      4 examples, 2 failures

      Failed examples:

      rspec './spec/rspec/print_failures_eagerly_spec.rb[1:1]' # Group 1 fails
      rspec './spec/rspec/print_failures_eagerly_spec.rb[2:1]' # Group 2 fails
    EOS
  end

  it "works with the documentation formatter" do
    expect(run_example_specs { |c| c.formatter = 'doc' }).to eq(unindent <<-EOS)

      Group 1
        fails (FAILED - 1)

        1) Group 1 fails
           Failure/Error: expect(1).to eq 2

             expected: 2
                  got: 1

             (compared using ==)

           # <truncated backtrace>

        passes

      Group 2
        fails (FAILED - 2)

        2) Group 2 fails
           Failure/Error: expect(1).to eq 2

             expected: 2
                  got: 1

             (compared using ==)

           # <truncated backtrace>

        passes

      Finished in n.nnnn seconds (files took n.nnnn seconds to load)
      4 examples, 2 failures

      Failed examples:

      rspec './spec/rspec/print_failures_eagerly_spec.rb[1:1]' # Group 1 fails
      rspec './spec/rspec/print_failures_eagerly_spec.rb[2:1]' # Group 2 fails
    EOS
  end

  def build_group(number)
    RSpec.describe "Group #{number}" do
      it "fails" do
        expect(1).to eq 2
      end

      it "passes" do
        expect(1).to eq 1
      end
    end
  end

  def normalize_output(output)
    output.string.gsub(/^((\s+)# .+$)+/) do |match|
      "#{$2}# <truncated backtrace>"
    end.gsub(/\d+\.\d+/, "n.nnnn")
  end

  def run_example_specs
    output = StringIO.new

    RSpec.configure do |config|
      RSpec::PrintFailuresEagerly.lazily_add_formatter_to(config)

      config.output_stream = output
      config.error_stream = output

      yield config if block_given?
    end

    config_options = RSpec::Core::ConfigurationOptions.new([])
    runner = RSpec::Core::Runner.new(config_options)

    groups = Array.new(2) { |i| build_group(i + 1) }
    runner.run_specs(groups)

    normalize_output(output)
  end

  # Intended for use with indented heredocs.
  # taken from Ruby Tapas:
  # https://rubytapas.dpdcart.com/subscriber/post?id=616#files
  def unindent(s)
    s.gsub(/^#{s.scan(/^[ \t]+(?=\S)/).min}/, "")
  end
end
