extends Camera2D

@onready var player = %Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player:
		#global_position = player.global_position
		var lerptopos = Vector2(player.global_position.x, player.global_position.y)
		global_position = global_position.lerp(lerptopos, 3 * delta)
	else:
		print("No player :(")
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
