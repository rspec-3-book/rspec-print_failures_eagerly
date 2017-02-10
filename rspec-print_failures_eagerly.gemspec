# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/print_failures_eagerly/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-print_failures_eagerly"
  spec.version       = RSpec::PrintFailuresEagerly::VERSION
  spec.authors       = ["Myron Marston"]
  spec.email         = ["myron.marston@gmail.com"]

  spec.summary       = %q{Tweaks the built-in RSpec formatters to cause failures to be printed immediately when they occur.}
  spec.homepage      = "https://pragprog.com/book/rspec3/effective-testing-with-rspec-3"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec-core", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "aruba", "~> 0.6.2"
end
