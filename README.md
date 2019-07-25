# Nagoriyuki

[![Gem Version](https://badge.fury.io/rb/nagoriyuki.svg)](http://badge.fury.io/rb/nagoriyuki)
[![Coverage Status](https://img.shields.io/coveralls/chibicco/nagoriyuki.svg)](https://coveralls.io/r/chibicco/nagoriyuki)
[![Build Status](https://travis-ci.org/chibicco/nagoriyuki.svg)](https://travis-ci.org/chibicco/nagoriyuki)

Distributed ID generator(like twitter/snowflake)


This is the extraction of the minimum functionality with referred to the code of [drecom/barrage](https://github.com/drecom/barrage).

And there are only a few feature additions.

## Installation

Add this line to your application's Gemfile:

    gem 'nagoriyuki'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nagoriyuki

## Usage

### Example

```ruby
# 39bit: msec (17.4 years from offset_epoch)
# 16bit: pid
# 9bit:  sequence
require 'nagoriyuki'

nagoriyuki = Nagoriyuki.new(
  "generators" => [
    {"name" => "msec", "length" => 39, "offset_epoch" => 1546268400000},
    {"name" => "pid", "length" => 16},
    {"name" => "sequence", "length" => 9}
  ]
)

id = nagoriyuki.next
# => 596299014690041345
  
ts = nagoriyuki.timestamp(id)
# => 1564039495

Time.at(ts)
# => 2019-07-25 16:24:55 +0900
```

### Generators

#### msec

#### pid

#### sequence

### Creating your own generator

```ruby
module Nagoriyuki::Generators
  class YourOwnGenerator < Base
    self.required_options += %w(your_option_value)
    def generate
      # generated code
    end

    def your_option_value
      options["your_option_value"]
    end
  end
end

nagoriyuki = Nagoriyuki.new("generators" => [{"name"=>"your_own", "length" => 8, "your_option_value"=>"xxx"}])
```

## License

[Copyright (c) 2014 Drecom Co., Ltd.](https://github.com/drecom/barrage/blob/master/LICENSE.txt)
