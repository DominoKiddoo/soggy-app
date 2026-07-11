extends HTTPRequest


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	request_completed.connect(_req_done)
	request("https://raw.githubusercontent.com/DominoKiddoo/soggy-app/refs/heads/master/version.txt")

@onready var outdated: ColorRect = $"../outadtaed"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _req_done(result, response_code, headers, body):
	var latestVer = body.get_string_from_utf8().strip_edges()
	print(latestVer)
	
	var file = FileAccess.open("res://version.txt", FileAccess.READ)
	var localVer = file.get_file_as_string("res://version.txt").strip_edges()
	file.close()
	print(localVer)
	if localVer != latestVer:
		outdated.show()


func _on_button_pressed() -> void:
	OS.shell_open("https://github.com/DominoKiddoo/soggy-app/releases/latest")
