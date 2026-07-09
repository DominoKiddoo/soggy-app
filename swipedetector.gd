extends Camera2D

var length = 20
var startingPos:Vector2
var curPos: Vector2
var swiping = false
var threshold = 20
@onready var main: Node2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("press"):
		if !swiping:
			swiping = true
			startingPos = get_global_mouse_position()
	if Input.is_action_pressed("press"):
		if swiping:
			curPos = get_global_mouse_position()
			if startingPos.distance_to(curPos) >= length:
				if abs(startingPos.y - curPos.y) <= threshold:
					if (startingPos.x > curPos.x):
						print("left")
						main.changeSog()
					else:
						print("right")
						main._on_reset_pressed()
					swiping = false
				elif abs(startingPos.x - curPos.x) <= threshold:
					if (startingPos.y > curPos.y):
						main.menu.show()
						main.showingMenu = true
					else:
						main.menu.hide()
						main.showingMenu = false
					swiping = false
	else:
		swiping = false
