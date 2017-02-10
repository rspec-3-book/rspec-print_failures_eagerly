# RSpec::PrintFailuresEagerly [![Gem Version](https://badge.fury.io/rb/rspec-print_failures_eagerly.svg)](https://badge.fury.io/rb/rspec-print_failures_eagerly)

This gem, featured in [Effective Testing with RSpec 3: Build Ruby Apps with
Confidence](https://pragprog.com/book/rspec3/effective-testing-with-rspec-3),
modifies the built-in `progress` and `documentation` formatters to make
them print failures _eagerly_, when they happen, rather than waiting
until the end to print them all. This can be handy for long-running spec
suites so you can begin digging into a failure while the rest of your
suite finishes running.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-print_failures_eagerly'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-print_failures_eagerly

## Usage

Just load it from `spec/spec_helper.rb`:

``` ruby
require 'rspec/print_failures_eagerly'
```

...or tell RSpec to require it by putting it in `.rspec`:

```
--require rspec/print_failures_eagerly
```

That's it!  The book also walks through how to set it up to
automatically apply to all projects on your machine, without
needing to add this gem to each.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
