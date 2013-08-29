require 'spec_helper'
require 'mm'
require 'minitest/autorun'

describe "nesting metrics" do
  it "should be able to nest" do
    skip
    x = NArray[ 
      [ 24, 16, 12 ], 
      [ 23, 17, 14 ], 
      [ 24, 16, 12 ], 
      [ 26, 14, 11 ], 
      [ 24, 16, 12 ] ] 

    y = NArray[ 
      [ 24, 24, 24 ], 
      [ 23, 23, 23 ], 
      [ 24, 24, 24 ], 
      [ 26, 26, 26 ], 
      [ 24, 24, 24 ] ] 
    
    intra_proc = ->(m, n, cfg = MM::DistConfig.new(:intra_delta => MM::DELTA_FUNCTIONS[:huron])) {
      MM.dist_ucm(m, n, cfg)
    }
    
    MM.dist_olm(x, y, MM::DistConfig.new(:intra_delta => intra_proc))
  end
  
  it "should allow nesting" do
    # Drawn from MM, p. 315
    q = NArray[5,3,7,6]
    r = NArray[2,1,2,1]
    s = NArray[8,3,5,4]
    # Setting up two different orderings of the intervals
    m = NArray[q, r, s]
    n = NArray[r, s, q]
    
    # Setting up the OCD intra_delta with hard-coded scaling
    ocd_proc = ->(a, b, config = MM::DistConfig.new(:scale => :relative)) {
      MM.dist_ocd(a, b, config)
    }
    # Expected results:
    # Using the OCD as intra_delta
    # m_combos = [0.5, 0.33, 0.33]
    # n_combos = [0.33, 0.5, 0.33]
    # 
    # (scaled over 0.5)
    # OCM diffs = [0, 0.3333, 0.3333]
    assert_in_delta(0.222, MM.dist_ocm(m, n, MM::DistConfig.new(:intra_delta => ocd_proc, :scale => :none)), 0.001)
    assert_in_delta(0.666, MM.dist_ocm(m, n, MM::DistConfig.new(:intra_delta => ocd_proc, :scale => :absolute)), 0.001)
  end
end