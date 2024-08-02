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

	
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer

func jumpp():
	velocity.y = JUMP_VELOCITY
	
func jump_side(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _physics_process(delta):
	# Animations
	if (velocity.x > 1 || velocity.x < -1):
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "default"
		
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.animation = "jump"
		
	if is_on_floor():
		jump_count = 0

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
	print_debug("time")
	dash_count = 0
