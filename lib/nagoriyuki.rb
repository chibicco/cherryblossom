require "nagoriyuki/version"
require "nagoriyuki/generators"
require "nagoriyuki/generators/base"
require "nagoriyuki/generators/msec"
require "nagoriyuki/generators/pid"
require "nagoriyuki/generators/sequence"
require "active_support/core_ext/string/inflections"

class Nagoriyuki
  class InvalidOption < StandardError; end
  attr_reader :generators

  #
  # generators:
  #   - name: msec
  #     length: 40 # (2 ** 40 - 1) / 1000 / 365 / 24 / 60 / 60.0
  #     start_at: 1546268400000 # 2019-01-01 00:00:00 +0900 (msec)
  #   - name: pid
  #     length: 16
  #   - name: sequence
  #     length: 8
  def initialize(options = {})
    @options = options
    @lock = Mutex.new
    @generators = @options["generators"].map do |h|
      generator_name = h["name"]
      "Nagoriyuki::Generators::#{generator_name.classify}".constantize.new(h)
    end
  end

  def generate
    @lock.synchronize do
      shift_size = length
      @generators.inject(0) do |result, generator|
        shift_size = shift_size - generator.length
        result += generator.generate << shift_size
      end
    end
  end
  alias_method :next, :generate

  def current
    @lock.synchronize do
      shift_size = length
      @generators.inject(0) do |result, generator|
        shift_size = shift_size - generator.length
        result += generator.current << shift_size
      end
    end
  end

  def timestamp(id)
    generator = @generators.detect {|g| g.name == "msec" }
    shift_size = length - generator.length
    ((id >> shift_size) + generator.offset_epoch) / 1000
  end

  def smallest(timestamp)
    @lock.synchronize do
      shift_size = length
      @generators.inject(0) do |result, generator|
        shift_size = shift_size - generator.length
        result += generator.smallest(timestamp) << shift_size
      end
    end
  end

  def biggest(timestamp)
    @lock.synchronize do
      shift_size = length
      @generators.inject(0) do |result, generator|
        shift_size = shift_size - generator.length
        result += generator.biggest(timestamp) << shift_size
      end
    end
  end

  def length
    @generators.inject(0) {|sum, g| sum += g.length }
  end
end
