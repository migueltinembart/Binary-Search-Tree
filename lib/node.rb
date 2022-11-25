# frozen_string_literal: true

# This node holds can hold 3 values
class Node
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def to_s
    @data
  end

  def inspect
    @data
  end

  def ==(other)
    self.class == other.class && self.data == other.data
  end
end
