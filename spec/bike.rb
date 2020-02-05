class Bike
  MIN_GEAR = 1
  MAX_GEAR = 11

  attr_reader :gear

  def initialize(gear: MIN_GEAR)
    @gear = gear
  end

  def shift_up
    @gear = [gear + 1, MAX_GEAR].min
  end

  def shift_down
    @gear = [gear - 1, MIN_GEAR].max
  end
end
