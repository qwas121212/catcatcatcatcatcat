extends Node

var current_cutscene = "none"

func _process(delta):
	Global.current_cutscene = current_cutscene
	
	if Global.newswimzone_activate == true:
		if current_cutscene == "none":
			current_cutscene = "newswimzone"
