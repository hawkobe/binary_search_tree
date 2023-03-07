require_relative 'node.rb'

class Tree
  attr_accessor :root, :data

  def initialize(arr)
    @data = arr.sort.uniq
    @root = build_tree(data)
  end

  def build_tree(arr, start_index = 0, end_index = data.length - 1)
    if arr == nil || arr.length == 0 || start_index > end_index
      return nil
    end

    mid = (start_index + end_index) / 2
    node = Node.new(arr[mid])

    node.left_node = build_tree(arr, start_index, mid - 1)

    node.right_node = build_tree(arr, mid + 1, end_index)

    p node
    return node
    
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
  end
end

tree = Tree.new([1, 2, 3, 4, 5, 6, 7])

tree.pretty_print






