require './mm.rb'
require 'minitest/autorun'
require 'minitest/benchmark'

class MMTest < Minitest::Benchmark
  def setup
    @m = NArray[1,5,12,2,9,6]
    @n = NArray[7,6,4,9,8,1]
  end
  
  def bench_magnitude
    assert_performance_constant 0.9999 do
      1000.times do
        MM.ocm.call(@m, @n, MM::DistConfig.new(:scale => :none))
      end
    end
  end
  
  def bench_contour
    assert_performance_constant 0.9999 do
      1000.times do
        MM.ocd.call(@m, @n, MM::DistConfig.new(:scale => :none))
      end
    end
  end
end