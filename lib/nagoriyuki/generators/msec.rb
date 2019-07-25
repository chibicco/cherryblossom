require "nagoriyuki/generators/base"

class Nagoriyuki
  module Generators
    class Msec < Base
      class InvalidSystemClock < StandardError; end

      self.required_options += %w(offset_epoch)

      def generate
        subtract & bit_fill
      end

      alias_method :current, :generate

      def offset_epoch
        options["offset_epoch"]
      end

      def smallest(timestamp)
        ((timestamp.to_s + "000").to_i - offset_epoch) & bit_fill
      end

      def biggest(timestamp)
        ((timestamp.to_s + "999").to_i - offset_epoch) & bit_fill
      end

      private

      def subtract
        subtract = (Time.now.to_f * 1000).round - offset_epoch
        raise InvalidSystemClock, "Clock moved backwards" if subtract > bit_fill
        subtract
      end
    end
  end
end
