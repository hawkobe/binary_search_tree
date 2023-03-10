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

    return node
    
  end

  def insert(data_to_insert, node = @root)
    if data_to_insert == node.data
      return nil
    end 
    if data_to_insert < node.data
      if node.left_node == nil
        return node.left_node = Node.new(data_to_insert)
      end
      node = insert(data_to_insert, node.left_node)
    else
      if node.right_node == nil
        return node.right_node = Node.new(data_to_insert)
      end
      node = insert(data_to_insert, node.right_node)
    end
  end

  def delete(data_to_delete, node = @root)
    return node if node == nil

    if data_to_delete < node.data
      node.left_node = delete(data_to_delete, node.left_node)
    elsif data_to_delete > node.data
      node.right_node = delete(data_to_delete, node.right_node)
    else
      if node.left_node == nil
        temp = node.right_node
        node = nil
        return temp
      elsif node.right_node == nil
        temp = node.left_node
        node = nil
        return temp
      else
        left_node_least_value = lowest_value_left_node(node.right_node)
        node.data = left_node_least_value.data
        node.right_node = delete(left_node_least_value.data, node.right_node)
      end
    end
    return node
  end

  def lowest_value_left_node(node)
    node = node.left_node until node.left_node == nil

    node
  end

  def find(value, node = @root)
    return node if node.nil? || node.data == value
    
    value < node.data ? find(value, node.left_node) : find(value, node.right_node)
  end

  def level_order(node = @root, queue = [@root], arr_to_return = [], &block)
    # solve with iteration

    # arr_to_return = []
    # queue << node
    # until queue.empty?
    #   queue << node.left_node unless node.left_node.nil?
    #   queue << node.right_node unless node.right_node.nil?
    #   yield(node.data) if block_given?
    #   arr_to_return << node.data
    #   queue.shift
    #   node = queue[0]
    # end
    # arr_to_return

    # solve with recursion

    return arr_to_return if queue.empty?
    queue << node.left_node unless node.left_node.nil?
    queue << node.right_node unless node.right_node.nil?
    arr_to_return << node.data
    queue.shift
    block.call(node.data) if block_given?
    level_order(queue[0], queue, arr_to_return, &block)
  end

  def preorder(node = @root, arr_to_return = [], &block)
    return if node.nil?

    arr_to_return << node.data
    block.call(node.data) if block_given?
    preorder(node.left_node, arr_to_return, &block)
    preorder(node.right_node, arr_to_return, &block)

    arr_to_return
  end

  def inorder(node = @root, arr_to_return = [], &block)
    return if node.nil?

    inorder(node.left_node, arr_to_return, &block)
    arr_to_return << node.data
    block.call(node.data) if block_given?
    inorder(node.right_node, arr_to_return, &block)

    arr_to_return
  end

  def postorder(node = @root, arr_to_return = [], &block)
    return if node.nil?

    postorder(node.left_node, arr_to_return, &block)
    postorder(node.right_node, arr_to_return, &block)
    arr_to_return << node.data
    block.call(node.data) if block_given?

    arr_to_return
  end

  def height(node = @root, left_counter = -1, right_counter = -1)

    # right_counter = 0
    # left_counter = 0
    # lowest_left_node = node
    # lowest_right_node = node

    # until lowest_left_node.left_node.nil?
    #   left_counter += 1
    #   lowest_left_node = lowest_left_node.left_node
    # end

    # until lowest_right_node.right_node.nil?
    #   right_counter += 1
    #   lowest_right_node = lowest_right_node.right_node
    # end

    # left_counter > right_counter ? left_counter : right_counter    

    return left_counter < right_counter ? left_counter : right_counter if node == nil

    height(node.left_node, left_counter += 1, right_counter)
    height(node.right_node, left_counter, right_counter += 1)
  end

  def depth(node_to_find, node = @root, depth = 0)
    return depth if node_to_find === node
    return nil if node_to_find.nil?
    
    if node_to_find.data < node.data
      depth(node_to_find, node.left_node, depth += 1)
    else
      depth(node_to_find, node.right_node, depth += 1)
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
  end
end

tree = Tree.new([20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 150, 155, 160, 165, 170])

# tree.insert(60)

tree.pretty_print

# p tree.find(110)

# tree.pretty_print

# p tree.preorder {|data| puts "#{data} is preordered"}

p tree.depth(tree.find(170))






