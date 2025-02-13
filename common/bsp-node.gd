class_name BSPNode
extends RefCounted

var parent: BSPNode
var left: BSPNode
var right: BSPNode
var position: Vector2i
var size: Vector2i

func _init(node_parent: BSPNode, starting_position: Vector2i, starting_size: Vector2i) -> void:
	self.parent = node_parent
	self.position = starting_position
	self.size = starting_size

func partition(depth: int) -> void:
	var split_percent = randf_range(0.3, 0.7)
	var split_horizontal = size.y > size.x
	
	if split_horizontal:
		var top_height = int(size.y * split_percent)
		top_height = top_height - (top_height % 48)
		left = BSPNode.new(self, position, Vector2i(size.x, top_height))
		right = BSPNode.new(self, Vector2i(position.x, position.y + top_height), Vector2i(size.x, size.y - top_height))
	else:
		var left_width = int(size.x * split_percent)
		left_width = left_width - (left_width % 48)
		left = BSPNode.new(self, position, Vector2i(left_width, size.y))
		right = BSPNode.new(self, Vector2i(position.x + left_width, position.y), Vector2i(size.x - left_width, size.y))
	
	if depth > 0:
		left.partition(depth - 1)
		right.partition(depth - 1)

func get_leaves() -> Array[BSPNode]:
	if not left and not right:
		return [self]
	else:
		return left.get_leaves() + right.get_leaves()
	
func get_center() -> Vector2i:
	return Vector2i(position.x + floor(float(size.x / 2)) / 2, position.y + floor(float(size.y / 2)))
