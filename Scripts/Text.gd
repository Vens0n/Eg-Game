extends RichTextLabel

@onready var player = %Player
@export var distance_to_show = 100
@export var distance_to_hide = 200

var mode = 0

func _ready() -> void:
	modulate.a = -1


func _process(delta: float) -> void:
	var distance_to_player = position.x - player.position.x
	
	
	if mode == 1:
		modulate.a = lerpf(modulate.a, 1, 5 * delta)
	elif mode == 0:
		modulate.a = lerpf(modulate.a, -1, 5 * delta)

	if abs(distance_to_player) < distance_to_show:
		mode = 1
	elif abs(distance_to_player) >= distance_to_hide:
		mode = 0
