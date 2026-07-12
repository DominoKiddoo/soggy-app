extends Node2D
const SAVE_PATH := "user://liked.json"
var pos = Vector2()
@onready var startingpos: Node2D = $cells/startingpos
var liked = []
@onready var soog: Sprite2D = $Soog

@onready var overlay: TextureRect = $overlay
@onready var grid_container: GridContainer = $cells/ScrollContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createGrid()
	if len(get_liked()) == 0:
		soog.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_liked():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var string = file.get_as_text()
		file.close()
		var json = JSON.new()
		var error = json.parse(string)
		if error == OK:
			return(json.get_data())

func save_liked(array: Array):
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var jstring = JSON.stringify(array)
		file.store_string(jstring)
		file.close()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://sog.tscn")

func _oncelloverlay(tex: Texture, img_name: String):
	if overlay:
		overlay.doOverlay(tex, img_name)

func createGrid():
	for n in grid_container.get_children(): # stolen from reddit lmao
		grid_container.remove_child(n)
		n.queue_free()

	liked = get_liked()
	print(liked)
	for i in range(len(liked)):
		var cell = load("res://imgcell.tscn").instantiate()
		grid_container.add_child(cell)
		var 	url = "https://mirror.guweh.com/" + liked[len(liked)-i-1]
		url = url.replace(" ", "%20")
		cell.initWithImage(url)
		cell.reqoverlay.connect(_oncelloverlay)
