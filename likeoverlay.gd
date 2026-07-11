extends TextureRect

var imgName
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var main: Node2D = $".."

const SAVE_PATH := "user://liked.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func doOverlay(tex: Texture, name: String):
	texture = tex
	imgName = name
	anim.play("down")


func _on_unlike_pressed() -> void:
	var liked: Array = get_liked()
	liked.remove_at(liked.find(imgName))
	print(liked)
	save_liked(liked)
	main.createGrid()
	anim.play("exit")
	
func _on_close_pressed() -> void:
	anim.play("exit")



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
	
