extends Area2D


onready var bigCircle = $BigCircle
onready var smallCircle = $BigCircle/SmallCircle

onready var max_distance = $CollisionShape2D.shape.radius


var touched = false
var mobile = true

func _ready():
	smallCircle.position = Vector2.ZERO
	
	if OS.get_name() == "Android":
		mobile = true
	else:
		mobile = false

func _input(event):
	
	if event is InputEventScreenTouch and mobile:
		var distance = event.position.distance_to(bigCircle.global_position)
		if not touched:
			if distance < max_distance:
				touched = true
		else:
			smallCircle.position = Vector2.ZERO
			touched = false
			

				
func _physics_process(delta):
	if mobile:
		if touched:
			smallCircle.global_position = get_global_mouse_position()
			smallCircle.position = bigCircle.position + (smallCircle.position - bigCircle.position).clamped(max_distance)
			
		if smallCircle.position.x > 0 :
			Input.action_press("right")
		else:
			Input.action_release("right")
		if smallCircle.position.x < 0:
			Input.action_press("left")		
		else:
			Input.action_release("left")
