extends CharacterBody2D

signal piece_clicked

var bMouseOver = false
var piece = 0
var dragging = false
var drag_start_position = Vector2()
var dragMinDistance = 30
var moving = false

enum Direction{
	UP = 0,
	DOWN = 1,
	LEFT = 2,
	RIGHT = 3
}
# Called when the node enters the scene tree for the first time.
func _ready():
	$board.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.dragging:
		# 先确定是横向移动还是纵向移动
		var drag_distance = drag_start_position - get_viewport().get_mouse_position()
		if drag_distance.length() > dragMinDistance:
			if abs(drag_distance.x) > abs(drag_distance.y):
				if drag_distance.x > 0:
					move_object(Direction.LEFT)
				else:
					move_object(Direction.RIGHT)
			else:
				if drag_distance.y > 0:
					move_object(Direction.UP)
				else:
					move_object(Direction.DOWN)

func move_object(direction):
	# 找到所有与它接壤的格子
	moving = true
	var objects = []
	var node_name = ""
	if direction == Direction.UP or direction == Direction.DOWN:
		node_name = "colArea"
	elif direction == Direction.LEFT or direction == Direction.RIGHT:
		node_name = "rowArea"
	# 让他们也移动
	objects = get_node(node_name).get_overlapping_areas()

	for object in objects:
		if object.name == node_name:
			if not object.get_parent().moving:
				object.get_parent().move_object(direction)

	# 移动自己
	if direction == Direction.UP:
		move_and_collide(Vector2(0, -64))
	elif direction == Direction.DOWN:
		move_and_collide(Vector2(0, 64))
	elif direction == Direction.LEFT:
		move_and_collide(Vector2(-64, 0))
	elif direction == Direction.RIGHT:
		move_and_collide(Vector2(64, 0))

func set_piece(piece):
	#先把数字补到两位的字符
	var piece_str = str(piece)
	while piece_str.length() < 2:
		piece_str = "0" + piece_str
	#设置图片
	var piece_texture = load("res://assets/texture/" + piece_str + ".svg")
	$Sprite.texture = piece_texture
	self.piece = piece

func _input(event):
	if event is InputEventMouseButton and not event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = false
		if bMouseOver:
			piece_clicked.emit(self)
	# drag and drop
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and bMouseOver:
		dragging = true
		drag_start_position = event.position

func _on_area_2d_mouse_entered():
	bMouseOver = true
	pass # Replace with function body.

func _on_area_2d_mouse_exited():
	bMouseOver = false
	pass # Replace with function body.

func set_selected(bSelected):
	if bSelected:
		$board.visible = true
	else:
		$board.visible = false
