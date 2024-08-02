extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#if character surpasses boundary, reload scene and character
func _on_body_entered(body):
	if (body.name == "CharacterBody2D"):
		get_tree().reload_current_scene()
