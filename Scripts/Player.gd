extends RigidBody2D

@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var immunitytimer = $Immunity

@onready var deathpart = $"Death Particles"

@onready var boosterbar = $boostbar
@onready var boostermeter = $boostbar/holder

var checkpoint = Vector2()
var speed = 10
var jump = 20
var cancontrol = true
var tempdataforspeed
var jumppower = 100

var normal_camera_zoom = 4
var death_camera_zoom = 12

func _ready() -> void:
	print("started")
	checkpoint = Vector2(global_position.x, global_position.y)
	Input.vibrate_handheld(500)


func _process(delta: float) -> void:
	if global_position.y > 300:
		killtheplayer()
		global_position.y = 0
		global_position.x = 0
		linear_velocity = Vector2(0, 0)
	boosterbar.global_rotation = 0
	boosterbar.global_position = Vector2(global_position.x - 12, global_position.y + 6.5)
	boostermeter.scale.y = jumppower / 100
	if jumppower == 100: 
		boosterbar.scale.y = 0
	else: boosterbar.scale.y = 1
	boosterbar.z_index = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var speeddif = 0
	if !tempdataforspeed:
		tempdataforspeed = sqrt(pow(((linear_velocity.x + linear_velocity.y) / 2),2))
	else:
		var curentspeed = (linear_velocity.x + linear_velocity.y) / 2
		speeddif = sqrt(pow(curentspeed - tempdataforspeed, 2))
		if speeddif > 100:
			if immunitytimer.is_stopped():
				killtheplayer()
		tempdataforspeed = curentspeed

	if cancontrol:
		if Input.is_action_pressed("ui_right"):
			apply_central_impulse(Vector2(speed, 0))
		if Input.is_action_pressed("ui_left"):
			apply_central_impulse(Vector2(-speed, 0))
		if Input.is_action_pressed("ui_up"):
			if jumppower > 0:
				apply_central_impulse(Vector2(0, -jump))
				jumppower -= 100 * delta
				$CPUParticles2D.modulate.a = jumppower / 100.0
				$CPUParticles2D.emitting = true
				var amplitude = jumppower / 100.0 # Scale amplitude based on remaining jumppower (0.0 to 1.0)
				Input.vibrate_handheld(100, amplitude)
		else:
			jumppower += 100 * delta
			if jumppower > 100: jumppower = 100
			$CPUParticles2D.emitting = false
		
		var target_zoom = Vector2(normal_camera_zoom, normal_camera_zoom)
		get_viewport().get_camera_2d().zoom = get_viewport().get_camera_2d().zoom.lerp(target_zoom, 1 * delta)

	else:
		$CPUParticles2D.emitting = false
		
		var target_zoom = Vector2(death_camera_zoom, death_camera_zoom)
		get_viewport().get_camera_2d().zoom = get_viewport().get_camera_2d().zoom.lerp(target_zoom, 1 * delta)



func _on_timer_timeout() -> void:
	if !immunitytimer.is_stopped() :
		jumppower = 100
		linear_velocity = Vector2(0, 0)
		angular_velocity = 0
		rotation = 0
		global_position = checkpoint
		global_position.y -= 15
		if cancontrol: deathpart.emitting = false
		cancontrol = true
		timer.start()
		sprite.texture = load("res://Sprites/Player/Eg.png")
	else:
		print("no longer safe")
	

func switch_to_scene(scene_path: String) -> void:
	# Load the new scene.
	var new_scene = load(scene_path)
	if not new_scene:
		print("Failed to load scene at path: %s" % scene_path)
		return

	# Instance the new scene.
	var new_scene_instance = new_scene.instantiate()
	
	# Get the root of the current scene tree.
	var root = get_tree().root

	# Remove all children of the current root.
	for child in root.get_children():
		child.queue_free()

	# Add the new scene to the root.
	root.add_child(new_scene_instance)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "kill":
		killtheplayer()
	elif body.name == "checkpoint":
		if cancontrol: 
			checkpoint = Vector2(body.global_position.x, body.global_position.y)
			var new_texture = preload("res://Sprites/Things/cp green.png")
			body.get_parent().get_child(0).texture = new_texture

func killtheplayer():
	print("Dead")
	jumppower = 100
	deathpart.emitting = true
	cancontrol = false
	timer.start()
	immunitytimer.start()
	sprite.texture = load("res://Sprites/Player/Eg_Dead.png")
