extends Node2D

@onready var sprite = $Sprite2D
@export var amplitude: float = 20.0
@export var speed: float = 4.0
var time_passed: float = 0.0

func _process(delta: float) -> void:
	time_passed += delta
	var y_offset = sin(time_passed * speed) * amplitude
	sprite.position.y = y_offset
