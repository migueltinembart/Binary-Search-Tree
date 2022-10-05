# frozen_string_literal: true

# This node holds can hold 3 values
class Node
  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end
end
