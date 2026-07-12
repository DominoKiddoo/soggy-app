extends Sprite2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sfx: AudioStreamPlayer = $sfx
const SAVE_PATH := "user://liked.json"
var likedArray = []
@onready var notif: Label = $"../notif"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var anim2: AnimationPlayer = $"../AnimationPlayer"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func like(pos: Vector2, str: String):
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var string = file.get_as_text()
			file.close()
			var json = JSON.new()
			var error = json.parse(string)
			if error == OK:
				likedArray = json.get_data()
	
	if !likedArray.has(str):
		likedArray.append(str)
	else:
		print("alr liked")
		notif.text = "You have already\nliked this post!\nSwipe up and\nclick button to remove"
		notif.show()
		anim2.stop()
		anim2.play("fade")
		anim2.animation_finished.connect(notif.hide, CONNECT_ONE_SHOT)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var jstring = JSON.stringify(likedArray)
		file.store_string(jstring)
		file.close()
	

	sfx.play()
	anim.stop()
	global_position = pos
	anim.play("like")
	await anim.animation_finished
