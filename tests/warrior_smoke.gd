extends SceneTree
## Run: godot --headless --path . --script res://tests/warrior_smoke.gd

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var turnaround: SpriteFrames = load("res://resources/characters/warrior/idle_turnaround.tres")
	assert(turnaround.get_animation_names().size() == 2)
	for animation in [&"idle_normal", &"idle_isometrico"]:
		assert(turnaround.get_frame_count(animation) == 8)
		assert(turnaround.get_animation_loop(animation))
		assert(turnaround.get_animation_speed(animation) == 4.0)
		var perspective := "classic" if animation == &"idle_normal" else "isometric"
		var poses: SpriteFrames = load("res://resources/characters/warrior/%s_idle.tres" % perspective)
		var directions := ["n", "ne", "e", "se", "s", "sw", "w", "nw"]
		for index in range(8):
			var frame := turnaround.get_frame_texture(animation, index) as AtlasTexture
			var pose := poses.get_frame_texture("idle_" + directions[index], 0) as AtlasTexture
			assert(frame.atlas == pose.atlas and frame.region == pose.region and frame.margin == pose.margin)
	print("PASS: both looping turnarounds contain the eight ordered poses at 4 FPS.")
	var packed: PackedScene = load("res://scenes/warrior.tscn")
	var lab = packed.instantiate()
	root.add_child(lab)
	await process_frame
	var warrior = lab.get_node("Warrior")
	var sprite: AnimatedSprite2D = warrior.get_node("AnimatedSprite2D")
	var checked := 0
	for perspective in range(2):
		lab._on_perspective_selected(perspective)
		assert(sprite.sprite_frames.get_animation_names().size() == 8)
		for direction in range(8):
			lab._on_direction_selected(direction)
			var expected := StringName("idle_" + str(warrior.DIRECTIONS[direction]))
			assert(sprite.animation == expected)
			assert(sprite.sprite_frames.get_frame_count(expected) == 1)
			var texture := sprite.sprite_frames.get_frame_texture(expected, 0) as AtlasTexture
			assert(texture != null and texture.get_size() == Vector2(512, 512))
			assert(texture.atlas != null)
			assert(not sprite.flip_h and not sprite.flip_v)
			assert(warrior.position == Vector2(106, 262))
			assert(lab.get_node("Previews/Pose%d" % direction).animation == expected)
			checked += 1
	lab._on_zoom_changed(1.5)
	assert(sprite.scale == Vector2(0.375, 0.375))
	assert(warrior.get_node("FeetOrigin").position == Vector2.ZERO)
	print("PASS: %d idle poses, perspective/direction selection, atlas dimensions, no mirroring, zoom and feet origin." % checked)
	lab.queue_free()
	await process_frame
	quit()
