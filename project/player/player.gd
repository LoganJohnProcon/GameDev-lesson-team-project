extends CharacterBody2D
#Make this thing walk as a top down character instead of as a platformer character (aka no gravity, up down left right)
#Give them the ability to run
#Add inputs via the Input manager (project -> project settings -> input manager) for up down left right (WASD, maybe arrow keys and maybe 
var health = 10
var maxHealth = 10
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var save_dictionary : Dictionary

func _ready() -> void:
	save_dictionary = await Saves.get_save_dictionary()
	GlobalVars.player = self
	
	#Setup
	global_position.x = save_dictionary.get_or_add("player_pose_x", 0)
	global_position.y = save_dictionary.get_or_add("player_pose_y", 0)
	print_debug("Loaded player at: " + str(global_position))

func _physics_process(delta: float) -> void:

	$ProgressBar.value = health * 100 / maxHealth
	
	if health < 0:
		queue_free()
		health = health - 1
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	velocity.y = 0
	velocity.x = 0
	
	if Input.is_action_pressed("Up"):
		velocity.y = -SPEED
	if Input.is_action_pressed("Down"):
		velocity.y = velocity.y +SPEED
	if Input.is_action_pressed("Left"):
		velocity.x = -SPEED
	if Input.is_action_pressed("Right"):
		velocity.x = velocity.x +SPEED
		
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	move_and_slide()
	
	#Store pose in dictionary
	
	save_dictionary["player_pose_x"] = global_position.x
	save_dictionary["player_pose_y"] = global_position.y
