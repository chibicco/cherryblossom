require "nagoriyuki/generators/base"

class Nagoriyuki
  module Generators
    class Sequence < Base
      def initialize(options)
        @sequence = 0
        super
      end

      def generate
        @sequence = (@sequence + 1) & bit_fill
      end

      def current
        @sequence
      end

      def smallest(timestamp)
        0
      end

      def biggest(timestamp)
        bit_fill
      end
    end
  end
end
