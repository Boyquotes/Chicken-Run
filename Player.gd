extends KinematicBody2D


const UP = Vector2(0, -1)
const accel = 40
const topSpeed = 200
const jumpForce = 400
const gravity = 20
const maxFall = 400
const doubleJumpForce = 450

var dead = false
var startPos
var motion = Vector2.ZERO
var facingRight = true
var canDoubleJump = true
var numOfKeys = 0
var keysFound = [false, false, false]
var deathFlash
var curLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	startPos = position
	deathFlash = get_node("/root/Game/HUD/DeathFlash")
	deathFlash.hide()
	$DeathFlashTimer.one_shot = true
	curLevel = int((get_node("..").get_name())[5])
	
func loadLevel(levelNum):
	
	if levelNum < 3:
		numOfKeys = 0
		keysFound = [false, false, false]
		var newLevel = load("res://Levels/Level" + String(curLevel + 1) + ".tscn")

		get_node("/root/Game").add_child(newLevel.instance())
		get_node("/root/Game").remove_child(get_node(".."))
			
		
	


func die():
	dead = true
	keysFound = [false, false, false]
	get_node("../Key1").show()
	get_node("../Key2").show()
	get_node("../Key3").show()
	numOfKeys = 0
	$DeathFlashTimer.start()
	deathFlash.show()

func _physics_process(_delta):
	get_node("/root/Game/HUD/KeysLabel").text = "Keys Found: " + String(numOfKeys) + "/3"	
	
	#Check if all keys collected
	if numOfKeys == 3:
		loadLevel(curLevel + 1)
	#Gravity
	motion.y += gravity
	if motion.y > maxFall:
		motion.y = maxFall
	
	#Left-to-Right movement
	if Input.is_action_pressed("left"):
		motion.x -= accel
		facingRight = false
		
	elif Input.is_action_pressed("right"):
		motion.x += accel
		facingRight = true
	else:
		motion.x = 0
	
	motion.x = clamp(motion.x, -topSpeed, topSpeed)
	
	#Jump
	if Input.is_action_just_pressed("jump") :
		if is_on_floor():
			motion.y = -jumpForce
			canDoubleJump = true
			$JumpSoundPlayer.play()
		if motion.y > 0 and canDoubleJump:
			motion.y = -doubleJumpForce
			canDoubleJump = false
			$JumpSoundPlayer.play()
	
	#Move
	motion = move_and_slide(motion, UP)
	
	#Die
	if position.y > startPos.y + 300 and !dead:
		die()
	
	#Animations
	if facingRight:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
		
	if motion.x != 0 and is_on_floor():
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
	

#Spikes

func onSpikesCollision(_body):
	die()

#Keys
func findsKey1(_body):

	if !keysFound[0]:
		keysFound[0] = true
		numOfKeys += 1
		get_node("../Key1").hide()
		get_node("/root/Game/HUD/KeysLabel").text = "Keys Found: " + String(numOfKeys) + "/3"
		
func findsKey2(_body):

	if keysFound[1] == false:
		keysFound[1] = true
		numOfKeys += 1
		get_node("../Key2").hide()
		get_node("/root/Game/HUD/KeysLabel").text = "Keys Found: " + String(numOfKeys) + "/3"
	
func findsKey3(_body):
	if !keysFound[2]:
		keysFound[2] = true
		numOfKeys += 1
		get_node("../Key3").hide()
		get_node("/root/Game/HUD/KeysLabel").text = "Keys Found: " + String(numOfKeys) + "/3"
	

func _on_DeathFlashTimer_timeout():
	dead = false
	position = startPos
	deathFlash.hide()
