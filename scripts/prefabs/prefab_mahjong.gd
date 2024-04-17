extends Node2D

var bMouseOver = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$board.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_piece(piece):
	#先把数字补到两位的汉字
	var piece_str = str(piece)
	while piece_str.length() < 2:
		piece_str = "0" + piece_str
	#设置图片
	var piece_texture = load("res://assets/texture/" + piece_str + ".svg")
	$Sprite.texture = piece_texture
	self.set_meta("Piece", piece)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and bMouseOver:
		print("Piece Clicked")
		emit_signal("piece_clicked", self)

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