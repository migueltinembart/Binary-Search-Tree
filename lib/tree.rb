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
    root_node = Node.new(array[middle])
    root_node.left = build_tree(array.slice(0, (array.length - 1) / 2))
    root_node.right = build_tree(array.slice((array.length - 1) / 2 + 1, array.last))

    root_node
  end

  ## Returns the node if of current value
  # if no node has passed value this functions returns nil
  def find(value, current = @root)
    return nil if current.nil?
    return current if current.data == value

    value > current ? find(value, current.right) : find(value, current.left)
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

  def inorder(node = @root, array = [], &block)
    return if node.nil?

    inorder(node.left, array, &block)
    array.push(block_given? ? block.call(node) : node)
    inorder(node.right, array, &block)

    array unless block_given?
  end

  def preorder(node = @root, array = [], &block)
    return if node.nil?

    array.push(block_given? ? block.call(node) : node)
    preorder(node.left, array, &block)
    preorder(node.right, array, &block)

    array unless block_given?
  end

  def postorder(node = @root, array = [], &block)
    return if node.nil?

    postorder(node.left, array, &block)
    postorder(node.right, array, &block)
    array.push(block_given? ? block.call(node) : node)

    array unless block_given?
  end

  def get_parent(value, node = @root)
    return if node.nil?
    return nil if @root.data == value
    return node if node.left.data == value || node.right.data == value

    binding.pry
    value > node.data ? get_parent(value, node.right) : get_parent(value, node.left)
  end

  def delete(value, root = @root)
    return if root.nil?

    delete(value, root.right) if value > root.data
    delete(value, root.left) if value < root.data

    if value == @root.data
      replacement = inorder_successor(@root)
      binding.pry
      delete(replacement.data, @root.right)
      replacement.left = root.left
      replacement.right = root.right
      @root = replacement
    elsif root.data == value && root != @root
      parent = get_parent(value)
      # if node has 2 childs
      # case 3
      # unless (root.left.nil? && root.right.nil?)
      if root.left.nil? && root.right.nil?
        remove_leaf(root, parent)
      elsif root.left.nil? || root.right.nil?
        remove_node_with_one_leaf(root, parent)
      else
        remove_node_with_2_child(root, parent)
      end
    end
  end

  def inorder_successor(root)
    inorder(root.right).first
  end

  def find_parent(value, current = @root)
    return nil if value == @root.data
    return current if current.left.data == value || current.right.data == value

    value > current ? find_parent(value, current.right) : find_parent(value, current.right)
  end

    private

  def remove_leaf(node, parent)
    parent.left = nil if parent.left.data == node.data
    parent.right = nil if parent.right.data == node.data
  end

  def remove_node_with_one_leaf(node, parent)
    if node.data < parent.data
      parent.left = node.left unless node.left.nil?
      parent.left = node.right unless node.right.nil?
    else
      parent.right = node.left unless node.left.nil?
      parent.right = node.right unless node.right.nil?
    end
  end

  def remove_node_with_2_child(node, parent)
    replacement = inorder(node.right).first
    get_parent(replacement.data).left = nil
    replacement.left = node.left
    replacement.right = node.right
    parent.right = replacement if replacement.data > parent.data
    parent.left = replacement if replacement.data < parent.data
  end
end
