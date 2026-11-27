@tool
extends CharacterBody2D
## Directional idle/walk controller. Frames, FPS and loops live in SpriteFrames.

enum Perspective { CLASSIC, ISOMETRIC }
enum Direction { N, NE, E, SE, S, SW, W, NW }
enum AnimationState { IDLE, WALK }

@export var classic_frames: SpriteFrames
@export var isometric_frames: SpriteFrames
@export var classic_walk_frames: SpriteFrames
@export var isometric_walk_frames: SpriteFrames
@export var animation_state: AnimationState = AnimationState.IDLE:
	set(value):
		animation_state = value
		_update_pose()
@export_group("Sprite Layout")
@export var idle_sprite_scale: float = 0.25
@export var idle_sprite_offset := Vector2(-256, -448)
@export var walk_sprite_scale: float = 0.33333334
@export var walk_sprite_offset := Vector2(-192, -336)
@export_range(0.5, 2.0, 0.25) var display_zoom: float = 1.0:
	set(value):
		display_zoom = value
		_apply_sprite_layout()
@export_group("Facing")
@export var perspective: Perspective = Perspective.CLASSIC:
	set(value):
		perspective = value
		_update_pose()
@export var direction: Direction = Direction.S:
	set(value):
		direction = value
		_update_pose()

const DIRECTIONS: Array[StringName] = [&"n", &"ne", &"e", &"se", &"s", &"sw", &"w", &"nw"]

func _ready() -> void:
	$AnimatedSprite2D.animation_changed.connect(_apply_sprite_layout)
	# Leave the selected turnaround animation available for editor playback.
	if Engine.is_editor_hint():
		_apply_sprite_layout()
		return
	_update_pose()

func _apply_sprite_layout() -> void:
	if not is_node_ready():
		return
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	var walking := str(sprite.animation).begins_with("walk")
	sprite.scale = Vector2.ONE * (walk_sprite_scale if walking else idle_sprite_scale) * display_zoom
	sprite.offset = walk_sprite_offset if walking else idle_sprite_offset

func _update_pose() -> void:
	if not is_node_ready():
		return
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	var walking := animation_state == AnimationState.WALK
	if Engine.is_editor_hint():
		var preview := &"idle_normal" if perspective == Perspective.CLASSIC else &"idle_isometrico"
		if walking:
			var prefix := "walk_" if perspective == Perspective.CLASSIC else "walk_isometrico_"
			preview = StringName(prefix + str(DIRECTIONS[direction]))
		if sprite.sprite_frames != null and sprite.sprite_frames.has_animation(preview):
			sprite.animation = preview
			sprite.frame = 0 if walking else direction
			_apply_sprite_layout()
		return
	var frames := classic_frames if perspective == Perspective.CLASSIC else isometric_frames
	if walking:
		frames = classic_walk_frames if perspective == Perspective.CLASSIC else isometric_walk_frames
	var phase := sprite.get_frame_progress()
	var frame := sprite.frame
	var was_walking := str(sprite.animation).begins_with("walk") and sprite.is_playing()
	sprite.sprite_frames = frames
	var pose := StringName(("walk_" if walking else "idle_") + str(DIRECTIONS[direction]))
	if sprite.sprite_frames != null and sprite.sprite_frames.has_animation(pose):
		sprite.animation = pose
		if walking:
			sprite.play()
			if was_walking:
				sprite.set_frame_and_progress(frame % sprite.sprite_frames.get_frame_count(pose), phase)
		else:
			sprite.frame = 0
			sprite.stop()
		_apply_sprite_layout()
