require "aruba/api"

RSpec.describe "RSpec::PrintFailuresEagerly" do
  include Aruba::Api

  before do
    1.upto(2) do |i|
      write_file "spec/#{i}_spec.rb", "
        RSpec.describe 'Group #{i}' do
          it 'fails' do
            expect(1).to eq 2
          end

          it 'passes' do
            expect(1).to eq 1
          end
        end
      "
    end
  end

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

      rspec ./spec/1_spec.rb:3 # Group 1 fails
      rspec ./spec/2_spec.rb:3 # Group 2 fails

    EOS
  end

  it "works with the documentation formatter" do
    expect(run_example_specs("--format doc")).to eq(unindent <<-EOS)

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

      rspec ./spec/1_spec.rb:3 # Group 1 fails
      rspec ./spec/2_spec.rb:3 # Group 2 fails

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
    output.gsub(/^((\s+)# .+$)+/) do |match|
      "#{$2}# <truncated backtrace>"
    end.gsub(/\d+\.\d+/, "n.nnnn")
  end

  def run_example_specs(cli_options="")
    dir_for_this_lib = File.expand_path("../../../lib", __FILE__)

    write_file ".rspec", "
    -I#{dir_for_this_lib}
    --require rspec/print_failures_eagerly
    "

    run("rspec #{cli_options}")
    normalize_output(all_output)
  end

  # Intended for use with indented heredocs.
  # taken from Ruby Tapas:
  # https://rubytapas.dpdcart.com/subscriber/post?id=616#files
  def unindent(s)
    s.gsub(/^#{s.scan(/^[ \t]+(?=\S)/).min}/, "")
  end
end
