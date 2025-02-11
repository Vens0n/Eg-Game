extends Node2D

@export var target_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(target_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		switch_to_scene(target_scene)

func switch_to_scene(new_scene: PackedScene) -> void:
	if not new_scene:
		print("Invalid scene: %s" % new_scene)
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
