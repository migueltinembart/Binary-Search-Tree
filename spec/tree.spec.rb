require './lib/tree'
require 'pry'

describe Tree do
  array = [3, 6, 9, 7, 1, 6, 8, 4, 20, 14, 17, 12, 19, 32, 28]
  bst = Tree.new(array)
  bst.pretty_print
  describe '#leaf?' do
    it 'returns true if node has child' do
      expect(bst.leaf?(7)).to eql(true)
    end
    it ' returns false if node has no child' do
      expect(bst.leaf?(32)).to eql(false)
    end
  end

  describe '#insert' do
    it 'inserts value in balanced tree after the right node, returns the node to which it has been added as leaf' do
      expect(bst.leaf?(3)).to eql(false)
      bst.insert(2)
      expect(bst.leaf?(3)).to eql(true)
      expect(bst.find(2).data).to eql(2)
      expect(bst.find(3).left.data).to eql(2)
    end
  end

  describe '#delete' do
    it 'removes an element from the tree' do
      expect(bst.delete(2).data).to eql(2)
      expect(bst.find(3).left).to eql(nil)
    end

    it 'if element only has only 1 child, replace element with child' do
    end
  end
end
