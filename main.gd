<<<<<<< HEAD

=======
extends Node2D


@onready var timer = $Timer

func start_dash(dur):
	timer.wait_time = dur
	timer.start()

func is_dashing():
	return timer.is_stopped
>>>>>>> b7f5ceec452bf0ccc94a8511aaa5e70a479bd89c
