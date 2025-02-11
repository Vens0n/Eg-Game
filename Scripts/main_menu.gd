extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		switch_to_scene("res://Scenes/Debug/Scene.tscn")
		
func switch_to_scene(scene_path: String) -> void:
	# Load the new scene.
	scene_path = "res://Scenes/Levels/Level1.tscn"
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

func _input(event: InputEvent) -> void:
	# Check for mouse button press
	if event is InputEventMouseButton and event.pressed:
		switch_to_scene("res://Scenes/Debug/Scene.tscn")
	
	# Check for screen touch
	elif event is InputEventScreenTouch and event.pressed:
		switch_to_scene("res://Scenes/Debug/Scene.tscn")
