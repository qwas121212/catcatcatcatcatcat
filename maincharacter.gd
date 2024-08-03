extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -300.0
const JUMP_VELOCITY_HIGHER = -500.0
const DASH_VELOCITY = 3000.0
#jump count
var jump_count = 0

#dash count
var dash_count = 0
var max_dashes = 3

#water
var is_in_water : bool = false

	
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer
@export var SWIM_GRAVITY_FACTOR : float = 0.25
@export var SWIM_VELOCITY_CAP : float  = 80
@export var SWIM_JUMP : float = -200

func _ready():
	Global.playerBody = self
	
func jumpp():
	velocity.y = JUMP_VELOCITY
	
func jump_side(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Animations
	if (is_in_water):
		animated_sprite_2d.animation = "swim"
	
	if (velocity.x > 1 || velocity.x < -1):
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "default"
		
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.animation = "jump"
		
	if is_on_floor():
		jump_count = 0
		
	#gravity
	if not is_on_floor():
		if(!is_in_water):
			velocity.y += gravity * delta
		else:
			velocity.y = clampf(velocity.y + (gravity * delta * SWIM_GRAVITY_FACTOR), -10000, SWIM_VELOCITY_CAP)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jump_count == 1:
		velocity.y = JUMP_VELOCITY_HIGHER 
		jump_count += 1

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and jump_count < 2:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		
		
	#Handle dash
	if Input.is_action_just_pressed("dash") and dash_count < 4  and not is_on_floor():
		velocity.x = DASH_VELOCITY
		dash_count += 1
		
	if dash_count == 3:
		timer.start()
		
		#jump in water
	if Input.is_action_just_pressed("up") and is_in_water == true:
		velocity.y = SWIM_JUMP
		animated_sprite_2d.animation = "swim"
		
		
	#travelling down in water
	if Input.is_action_pressed("down") and is_in_water:
		velocity.y = 300
		animated_sprite_2d.animation = "swim"
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	animated_sprite_2d.flip_h = isLeft

#timer for dash cooldown
func _on_timer_timeout():
	print_debug("time ")
	dash_count = 0


func _on_water_detection_2d_water_state_changed(is_in_water):
	self.is_in_water = is_in_water
	print(is_in_water)

