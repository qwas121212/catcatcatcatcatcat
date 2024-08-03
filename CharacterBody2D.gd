extends CharacterBody2D

@onready var game_manager = %GameManager
@onready var animated_sprite_2d = $AnimatedSprite2D

const speed = 30.0
var dir: Vector2

var is_bat_chase: bool
var player: CharacterBody2D

func _ready():
	is_bat_chase = true
	
func _process(delta):
	move(delta)
	handle_animation()
	
func move(delta):
	if is_bat_chase:
		player = Global.playerBody
		velocity = position.direction_to(player.position) * speed
		dir.x = abs(velocity.x) / velocity.x
	elif !is_bat_chase:
		velocity += dir * speed * delta 
		
	move_and_slide()

func _on_area_2d_body_entered(body):
	if (body.name == "CharacterBody2D"):
		print("decrease player health")
		game_manager.decrease_health()

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 0.8])
	if !is_bat_chase:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		
		
func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	animated_sprite.play("flying")
	if dir.x == -1:
		animated_sprite.flip_h = true
	elif dir.x == 1:
		animated_sprite.flip_h = false
	
func choose(array):
	array.shuffle()
	return array.front()
