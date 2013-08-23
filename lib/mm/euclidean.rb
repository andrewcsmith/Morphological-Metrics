module MM
  #
  # Provides the angle between two vectors with respect to the origin or 
  # another vector (v3).
  #
  def self.angle_euclidean(v1, v2, v3 = nil)
    if !v3.nil?
      v1 -= v3
      v2 -= v3
    end
    Math.acos(dot(v1, v2) / (length(v1) * length(v2)))
  end

  #
  # Get the angle between two vectors given a distance function, e.g. one of 
  # the metrics described above.
  #
  # This only makes sense for certain kinds of metrics. At a minimum, the 
  # metric should satisfy the triangle inequality (i.e. it should be a 
  # metric); beyond that, there are other requirements which I do not yet 
  # entirely understand.
  #
  # Question: Should scaling be turned off here by default?
  # Additional question: What does this even mean?
  #
  def self.angle(v1, v2, v3 = nil, dist_func = nil, config = self::DistConfig.new)
    v3 = NArray.int(v1.total).fill!(0) if v3.nil?
    return 0.0 if (v1 == v3 || v2 == v3)      # not sure if this is strictly kosher
    a = dist_func.call(v1, v3, config)
    b = dist_func.call(v2, v3, config)
    c = dist_func.call(v1, v2, config)
    cos_c = (a**2 + b**2 - c**2).to_f / (2 * a * b)
    Math.acos(cos_c)
  end

  # The Euclidean norm of the vector. Its magnitude.
  #--
  # TODO: This probably needs a less confusing name.
  def self.length(v)
    dot(v,v)**0.5
  end

  # The dot product of two vectors.
  def self.dot(v1, v2)
    (v1 * v2).sum
  end

  # Convert degrees to radians.
  def self.deg2rad(d)
    (d * PI) / 180
  end

  # Convert radians to degrees.
  def self.rad2deg(r)
    (180 * r).to_f / PI
  end

  # Simple linear interpolation in Euclidean space
  def self.interpolate(v1, v2, percent = 0.5)
    ((v2.to_f - v1.to_f) * percent.to_f) + v1.to_f
  end

  # Get an array of points along a continuous interpolation between v1 and v2
  # with a given sampling interval, specified as a decimal percentage value.
  # So with interval = 0.1, there'd be 11 samples. (0 and 1 are included.)
  def self.interpolate_path(v1, v2, interval)
    raise "Interval must be > 0 and < 1." if interval < 0.0 || interval > 1.0
    percent = 0.0
    path = []
    while percent < 1.0
      path << self.interpolate(v1, v2, percent)
      percent += interval
    end
    path
  end

  # Get an array of points along a continuous interpolation between v1 and v2
  # with a sampling interval determined by the total desired number of points.
  # This method will always include the starting and ending points.
  def self.interpolate_steps(v1, v2, num_steps)
    raise "Number of steps must be > 1" if num_steps <= 0.0
    return [v1, v2] if num_steps == 2
  
    interval = 1.0 / (num_steps - 1)
    current_percent = interval
    path = [v1]
  
    (num_steps - 2).times do |step|
      path << self.interpolate(v1, v2, current_percent)
      current_percent += interval
    end
  
    path << v2
    path
  end

  # Upsample a vector, adding members using linear interpolation.
  def self.upsample(v1, new_size)
    return v1 if v1.size == new_size
    raise "Upsample can't downsample" if new_size < v1.size

    samples_to_insert = new_size - v1.size
    possible_insertion_indexes = v1.size - 2
    samples_per_insertion_index = Rational(samples_to_insert, possible_insertion_indexes + 1.0)
  
    count      = Rational(0,1)
    prev_count = Rational(0,1)
    hits       = 0
    new_vector = []
  
    0.upto(possible_insertion_indexes) do |i|
      count += samples_per_insertion_index

      int_boundaries_crossed = count.floor - prev_count.floor
    
      if int_boundaries_crossed >= 1
        hits += int_boundaries_crossed
        # next line leaves off the last step of the interpolation
        # because it will be added during the next loop-through
        new_vector.concat(self.interpolate_steps(v1[i], v1[i + 1], 2 + int_boundaries_crossed)[0..-2])
      else
        new_vector << v1[i]
      end
      prev_count = count
    end
    NArray.to_na(new_vector << v1[-1])    # add the last member (which is not an insertion point)
  end
end
