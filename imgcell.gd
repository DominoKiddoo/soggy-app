extends TextureRect
@onready var button: Button = $Button
@onready var overlay: TextureRect = $overlay

@onready var req: HTTPRequest = $HTTPRequest
var globalTex
var globalUrl
signal reqoverlay(texture: Texture, name: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	req.request_completed.connect(self._req_done)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initWithImage(url: String):
	button.hide()
	globalUrl = url
	print("made req")
	req.request(globalUrl)

func _req_done(result, response_code, headers, body):

	self.visible = true
	var img = Image.new()
	var error
	var type
	if "png" in globalUrl:
		error = img.load_png_from_buffer(body)
	else:
		error = img.load_jpg_from_buffer(body)
	
	if error != OK:
		print("error")
		self.texture = load("res://Error.png")
		return
	
	button.show()
	
	globalTex = ImageTexture.create_from_image(img)
	
	var resizedImg = img.duplicate()
	resizedImg.resize(200, 266)
	
	var tex = ImageTexture.create_from_image(resizedImg)
	self.texture = tex

func _on_button_pressed() -> void:
	var lastslash = globalUrl.rfind("/")

	if lastslash != -1:
		var result = globalUrl.substr(lastslash + 1)
		result = result.replace("%20", " ")
		print(result)
		reqoverlay.emit(globalTex, result)
