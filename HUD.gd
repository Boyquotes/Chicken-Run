extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mobile

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "Android":
		mobile = true
		$Joystick.show()
		$TouchScreenButton.show()
	else:
		mobile = false
		$Joystick.hide()
		$TouchScreenButton.hide()


func _process(_delta):
	$FPSLabel.text = "FPS: " + String(Engine.get_frames_per_second())
	
func _on_TouchScreenButton_pressed():
	if mobile:
		Input.action_press("jump")



func _on_TouchScreenButton_released():
	if mobile:
		Input.action_release("jump")
