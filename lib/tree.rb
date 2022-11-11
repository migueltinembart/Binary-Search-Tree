# frozen_string_literal: true
require 'pry'
# Creates instance of binary search tree
class Tree
  require_relative 'node'
  attr_accessor :data, :root

  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
  end

  public

  def build_tree(array)
    return nil if array.empty?

    middle = (array.length - 1) / 2

    # root_node.left = build_tree(array[0...middle])
    # root_node.right = build_tree(array[(middle + 1)..])
    root_node = Node.new(array[middle])
    root_node.left = build_tree(array.slice(0, (array.length - 1) / 2))
    root_node.right = build_tree(array.slice((array.length - 1) / 2 + 1, array.last))

    root_node
  end

  ## Returns the node if of current value
  # if no node has passed value this functions returns nil
  def find(value, node = @root)
    return nil unless value.is_a? Integer

    return node if node.nil? || node.data == value

    return find(value, node.left) if value < node.data

    find(value, node.right)
  end

  def leaf?(value)
    x = find(value)
    if x.left.nil? && x.right.nil?
      false
    else
      true
    end
  end

  def insert(value, node = @root)
    node = Node.new(value) if node.nil?

    if value < node.data
      if node.left.nil?
        node.left = Node.new(value)
      else
        insert(value, node.left)
      end
    elsif value > node.data
      if node.right.nil?
        node.right = Node.new(value)
      else
        insert(value, node.right)
      end
    end
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def inorder(node = @root, array = [])
    return if node.nil?

    inorder(node.left, array)
    yield node.data if block_given?
    array.push(node.data) unless block_given?
    inorder(node.right, array)

    array unless block_given?
  end

  def preorder(node = @root, array = [])
    return if node.nil?

    yield node.data if block_given?
    array.push(node.data) unless block_given?
    preorder(node.left, array)
    preorder(node.right, array)

    array unless block_given?
  end

  def postorder(node = @root, array = [])
    return if node.nil?

    postorder(node.left, array)
    postorder(node.right, array)
    yield node.data if block_given?
    array.push(node.data) unless block_given?

    array unless block_given?
  end
end
