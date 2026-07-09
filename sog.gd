extends Node2D
@onready var images = []
var path = "res://images.txt"
@onready var req: HTTPRequest = $HTTPRequest
var url
@onready var spr: Sprite2D = $Soggycat
var holding = false
@onready var timer: Timer = $Timer
@onready var menu: Control = $Control
@onready var notif: Label = $notif
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var overlay: Sprite2D = $overlay
@onready var swipe: AnimationPlayer = $swipe
@onready var doubletap: Timer = $doubletap

@onready var imglabel: Label = $Control/imglabel
var cimage = "soggy.jpg"
var attemptedImg = ""
var justDoubleTapped = false
var showingMenu = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	req.request_completed.connect(_req_done)
	notif.hide()
	notif.text = "Changing Sog.."
	menu.hide()
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_file_as_string(path)
	var json = JSON.new()
	json.parse(content)
	images = json.get_data()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if holding == true:
		spr.scale = spr.scale.lerp(Vector2(0.649 * 1.1, 0.864 * 1.1), delta * 4.0)
	else:
		spr.scale = spr.scale.lerp(Vector2(0.649, 0.864), delta * 4.0)
	imglabel.text = "Current Image:\n" + cimage
	
	if Input.is_action_just_pressed("press"):
		if !doubletap.time_left > 0:
			doubletap.stop()
			doubletap.wait_time = 0.3
			doubletap.start()
		else:
			print("double tapped!")
			justDoubleTapped = true
		
func changeSog():
	anim.play("RESET")
	req.cancel_request()
	notif.text = "Changing Sog.."
	notif.show()
	attemptedImg = images.pick_random()
	url = "https://mirror.guweh.com/" + attemptedImg
	url = url.replace(" ", "%20")
	req.request(url)
	menu.hide()
	showingMenu = false

func _req_done(result, response_code, headers, body):
	self.visible = true
	var img = Image.new()
	var error
	var type
	if "png" in url:
		error = img.load_png_from_buffer(body)
	else:
		error = img.load_jpg_from_buffer(body)
	
	if error != OK:
		notif.text = "There was an error 3:"
		await get_tree().create_timer(1).timeout
		anim.play("fade")
		return
	cimage = attemptedImg

	anim.play("fade")
	
	img.resize(1000, 1333)
	var tex = ImageTexture.create_from_image(img)
	var prevsize = spr.texture.get_size() * spr.scale
	overlay.texture = tex
	swipe.play("RESET")
	swipe.play("swipe")
	await swipe.animation_finished
	spr.texture = tex
	swipe.play("RESET")
	
func _input(event):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		if event.pressed:
			holding = true
			timer.wait_time = 1
			timer.start()
		else:
			timer.stop()
			holding = false
			if !showingMenu:
				if !justDoubleTapped:
					var sfx = AudioStreamPlayer.new()
					var meows = ["res://meow1.ogg", "res://meow2.ogg", "res://meow3.ogg", "res://meow4.ogg"]
					sfx.stream = load(meows.pick_random())
					sfx.finished.connect(sfx.queue_free)
					add_child(sfx)
					sfx.play()
				else:
					justDoubleTapped = false


func _on_timer_timeout() -> void:
	if !showingMenu:
		print("Menu")
		showingMenu = true
		menu.show()


func _on_new_pressed() -> void:
	changeSog()
	menu.hide()
	showingMenu = false
	


func _on_reset_pressed() -> void:
	cimage = "soggy.jpg"
	attemptedImg = "soggy.jpg"

	menu.hide()
	showingMenu = false
	overlay.texture = load("res://soggycat.webp")
	swipe.play("RESET")
	swipe.play("swipe")
	await swipe.animation_finished
	spr.texture = load("res://soggycat.webp")
	swipe.play("RESET")

func _on_close_pressed() -> void:
	menu.hide()
	showingMenu = false


func _on_otherclosebutton_pressed() -> void:
	showingMenu = false
	menu.hide()
