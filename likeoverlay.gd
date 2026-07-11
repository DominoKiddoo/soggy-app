extends TextureRect

var imgName
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var main: Node2D = $".."
var overlayShowing = false
const SAVE_PATH := "user://liked.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func doOverlay(tex: Texture, name: String):
	overlayShowing = true
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
	overlayShowing = false
	
func _on_close_pressed() -> void:
	anim.play("exit")
	overlayShowing = false



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
	

var length = 20
var startingPos:Vector2
var curPos: Vector2
var swiping = false
var threshold = 15
var didswipe = false

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("press"):
		if !swiping:
			didswipe = false 
			swiping = true
			startingPos = get_global_mouse_position()
	if Input.is_action_pressed("press"):
		if swiping:
			curPos = get_global_mouse_position()
			if startingPos.distance_to(curPos) >= length:
				didswipe = true
				
				if abs(startingPos.y - curPos.y) <= threshold:
					main.swipes += 1
					if (startingPos.x > curPos.x):
						print("left")
					else:
						print("right")
					swiping = false
				elif abs(startingPos.x - curPos.x) <= threshold:
					if (startingPos.y > curPos.y):
						pass
					else:
						if overlayShowing:
							overlayShowing = false
							anim.play("exit")
					swiping = false
					
	if Input.is_action_just_released("press"):
		swiping = false
		didswipe = false
		if overlayShowing:
			overlayShowing = false;
			anim.play("exit")
