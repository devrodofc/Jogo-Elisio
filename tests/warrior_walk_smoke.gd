extends SceneTree
## Run: godot --headless --path . --script res://tests/warrior_walk_smoke.gd

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var combined: SpriteFrames = load("res://resources/characters/warrior/warrior_animations.tres")
	assert(combined.get_animation_names().size() == 20)
	var directions := ["n", "ne", "e", "se", "s", "sw", "w", "nw"]
	var checked := 0
	for perspective in ["classic", "isometric"]:
		var frames: SpriteFrames = load("res://resources/characters/warrior/%s_walk.tres" % perspective)
		assert(frames.get_animation_names().size() == 8)
		var prefix := "walk_" if perspective == "classic" else "walk_isometrico_"
		for direction in directions:
			var name := StringName("walk_" + direction)
			assert(frames.get_frame_count(name) == 8)
			assert(frames.get_animation_speed(name) == 8.0)
			assert(frames.get_animation_loop(name))
			var regions: Array[Rect2] = []
			var margin := Rect2()
			for index in range(8):
				var frame := frames.get_frame_texture(name, index) as AtlasTexture
				assert(frame.get_size() == Vector2(384, 384))
				assert(not regions.has(frame.region))
				regions.append(frame.region)
				if index == 0:
					margin = frame.margin
				assert(frame.margin == margin) # No frame-by-frame recentering that erases gait motion.
				var copy := combined.get_frame_texture(prefix + direction, index) as AtlasTexture
				assert(copy.atlas == frame.atlas and copy.region == frame.region and copy.margin == frame.margin)
				checked += 1
		var alias := "walk" if perspective == "classic" else "walk_isometrico"
		for index in range(8):
			assert(combined.get_frame_texture(alias, index) == combined.get_frame_texture(prefix + "s", index))

	var packed: PackedScene = load("res://scenes/warrior.tscn")
	var lab = packed.instantiate()
	root.add_child(lab)
	await process_frame
	var actor = lab.get_node("Warrior")
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	var origin: Vector2 = actor.position
	var button: Button = lab.get_node("Interface/Panel/Walk")
	button.button_pressed = true
	for perspective in range(2):
		lab._on_perspective_selected(perspective)
		for direction in range(8):
			lab._on_direction_selected(direction)
			assert(sprite.animation == StringName("walk_" + directions[direction]))
			assert(sprite.is_playing())
			assert(not sprite.flip_h and not sprite.flip_v)
			assert(sprite.scale.is_equal_approx(Vector2.ONE / 3.0))
			assert(sprite.offset == Vector2(-192, -336))
			assert(actor.position == origin) # Preview walks in place.
			var preview: AnimatedSprite2D = lab.get_node("Previews/Pose%d" % direction)
			assert(preview.is_playing() and preview.animation == sprite.animation)
	# Real elapsed playback, including the frame-7 -> frame-0 loop.
	var loops := [0]
	sprite.animation_looped.connect(func(): loops[0] += 1)
	sprite.set_frame_and_progress(7, 0.99)
	await create_timer(0.18).timeout
	assert(loops[0] > 0 and sprite.frame != 7)
	sprite.set_frame_and_progress(3, 0.4)
	lab._on_direction_selected(4)
	assert(sprite.frame == 3 and is_equal_approx(sprite.frame_progress, 0.4))
	lab._on_zoom_changed(1.5)
	assert(sprite.scale.is_equal_approx(Vector2.ONE * 0.5))
	button.button_pressed = false
	assert(sprite.animation == &"idle_s" and not sprite.is_playing())
	assert(sprite.scale == Vector2(0.375, 0.375))
	assert(sprite.offset == Vector2(-256, -448))
	# Manual selection, as in the AnimatedSprite2D animation panel, applies matching layout.
	actor.display_zoom = 1.0
	sprite.sprite_frames = combined
	sprite.animation = &"walk_isometrico_ne"
	assert(sprite.scale.is_equal_approx(Vector2.ONE / 3.0))
	assert(sprite.offset == Vector2(-192, -336))
	sprite.animation = &"idle_normal"
	assert(sprite.scale == Vector2(0.25, 0.25))
	assert(sprite.offset == Vector2(-256, -448))
	print("PASS: %d walk frames; 16 directional cycles; loop playback; phase continuity; lab previews; idle/walk layout and zoom." % checked)
	lab.queue_free()
	await process_frame
	quit()
