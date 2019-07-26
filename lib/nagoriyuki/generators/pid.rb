require "nagoriyuki/generators/base"

class Nagoriyuki
  module Generators
    class Pid < Base
      def generate
        Process.pid & bit_fill
      end

      alias_method :current, :generate

      def smallest(timestamp)
        0
      end

      def biggest(timestamp)
        bit_fill
      end
    end
  end
end
