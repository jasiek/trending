# -*- coding: utf-8 -*-
module Trending
  module Algorithm
    class Frequent

      # Demaine, Erik, Alejandro López-Ortiz, and J. Munro.
      # "Frequency estimation of internet packet streams with limited space."
      # Algorithms—ESA 2002 (2002): 11-20.

      def initialize(capacity)
        raise ArgumentError.new("capacity must be >= 1") unless capacity.is_a?(Fixnum) && capacity > 0
        @capacity = capacity
        @storage = {}
      end

      def bump(element)
        if !@storage.has_key?(element) && @storage.size < @capacity
          @storage[element] = 0
        end
        if @storage.has_key?(element)
          @storage[element] += 1
        else
          @storage.each_key do |key|
            @storage.delete(key) if (@storage[key] -= 1) == 0
          end
        end
      end

      def top(n=@capacity)
        raise ArgumentError.new("#{n} is greater than capacity (#{@capacity})") unless n <= @capacity
        @storage.to_a.sort_by do |(key, value)|
          -value
        end.map(&:first).take(n)
      end
    end
  end
end
