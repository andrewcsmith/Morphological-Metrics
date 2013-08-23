require 'spec_helper'
require 'mm'
require 'minitest/autorun'

describe MM do
  describe "euclidean methods" do
    let(:m) {NArray[1, 1]}
    let(:n) {NArray[0, 1]}
    describe ".angle_euclidean" do
      it "should find angle around the origin" do
        MM.angle_euclidean(m, n).must_be_close_to NMath::PI/4, 0.001
      end
      
      it "should find angle around a third point" do
        MM.angle_euclidean(m, n, NArray[0, 0.5]).must_be_close_to MM.angle_euclidean(NArray[1, 0.5], NArray[0, 0.5]), 0.001
      end
    end
    
    describe ".angle" do
      # this is complicated
    end
    
    describe ".length" do
      it "should find the euclidean magnitude" do
        MM.length(NArray[1,1]).must_be_close_to Math.sqrt(2), 0.001
      end
    end
    
    describe ".dot" do
      it "should find the dot product of two vectors" do
        MM.dot(m, n).must_equal 1
      end
    end
    
    describe ".deg2rad" do
      it "should convert degrees to radians" do
        MM.deg2rad(60).must_be_close_to NMath::PI / 3, 0.001
      end
    end
    
    describe ".rad2deg" do
      it "should convert radians to degrees" do
        MM.rad2deg(NMath::PI / 3).must_be_close_to 60, 0.001
      end
    end
    
    describe ".interpolate" do
      
    end
    
    describe ".interpolate_path" do
      
    end
    
    describe ".interpolate_steps" do
      
    end
    
    describe ".upsample" do
      
    end
  end
end