extends Node2D

var board_size = Vector2(17,8)
var piece_types = 34
var per_piece_count = 4

var total_count = board_size.x * board_size.y
var achieve_count = 0
var remain_count = total_count

var achieve_list = []

var prefab_mahjong = preload("res://assets/prefabs/prefab_mahjong.tscn")
var last_clicked_piece = null

#棋盘的二维数组
var board = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()

	start_new_game()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_new_game():
	#初始化棋盘
	initialize_board()
	refresh_achieve_info()


func refresh_achieve_info():
	$UI.get_node("achieveCount").text = str(achieve_count)
	$UI.get_node("remainCount").text = str(remain_count)
	pass

func initialize_board():
	achieve_count = 0
	remain_count = total_count
	achieve_list = []
	board = []
	last_clicked_piece = null

	var pieces = []
	for i in range(piece_types):
		for j in range(per_piece_count):
			pieces.append(i+1)
	for i in range(board_size.x):
		var row = []
		for j in range(board_size.y):
			var index = randi() % pieces.size()
			var piece = pieces[index]
			pieces.erase(index)
			row.append(piece)
		board.append(row)
	# 打印棋盘，用于调试
	print_board()
	# 更新棋盘
	for i in range(board_size.x):
		for j in range(board_size.y):
			var piece = board[i][j]
			var piece_node = $Board.get_node("Board").get_node(str(i) + "_" + str(j))
			if piece_node == null:
				piece_node = prefab_mahjong.instantiate()
				piece_node.name = str(i) + "_" + str(j)
				#放到最下面，不然会被覆盖
				$Board.get_node("Board").add_child(piece_node)
			piece_node.position = Vector2(i * 60, j * 80)
			piece_node.set_piece(piece)
			piece_node.connect("piece_clicked", Callable(self , "on_piece_click"))
	pass

func print_board():
	for i in range(board_size.x):
		var row = ""
		for j in range(board_size.y):
			row += str(board[i][j]) + " "
		print(row)
	print("")
	pass

func on_piece_click(piece):
	print(last_clicked_piece,"!!!!")
	if last_clicked_piece != null and are_adjacent(last_clicked_piece, piece):
		# 如果两个PieceNode相邻，检查数值是否相等
		if last_clicked_piece.get_meta("Piece") == piece.get_meta("Piece"):
			achieve_list.append(last_clicked_piece)
			achieve_list.append(piece)
			achieve_count += 2
			remain_count -= 2
			# 如果数值相等，消除两个PieceNode
			last_clicked_piece.queue_free()
			piece.queue_free()
	if last_clicked_piece != null:
		last_clicked_piece.set_selected(false)
	piece.set_selected(true)
	last_clicked_piece = piece

func are_adjacent(piece1, piece2):
	# 检查两个Piece是否相邻
	var pos1 = piece1.position
	var pos2 = piece2.position
	var distance = pos1.distance_to(pos2)
	print(distance)
	if distance == 60 or distance == 80:
		return true