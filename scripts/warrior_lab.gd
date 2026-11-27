extends Node2D
## Preview logic only: pose resources and scene structure are authored on disk.

@export var classic_frames: SpriteFrames
@export var isometric_frames: SpriteFrames
@export var classic_walk_frames: SpriteFrames
@export var isometric_walk_frames: SpriteFrames

@onready var warrior: CharacterBody2D = $Warrior
@onready var perspective_picker: OptionButton = $Interface/Panel/Perspective
@onready var direction_picker: OptionButton = $Interface/Panel/Direction
@onready var pose_label: Label = $Interface/Panel/PoseLabel
@onready var previews: Node2D = $Previews
@onready var walk_button: Button = $Interface/Panel/Walk

func _ready() -> void:
	perspective_picker.item_selected.connect(_on_perspective_selected)
	direction_picker.item_selected.connect(_on_direction_selected)
	$Interface/Panel/Zoom.value_changed.connect(_on_zoom_changed)
	walk_button.toggled.connect(_on_walk_toggled)
	_refresh()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.is_pressed() or event.is_echo():
		return
	if event is InputEventKey and event.keycode == KEY_TAB:
		_on_perspective_selected(1 - perspective_picker.selected)
		return
	var heading := Vector2(
		float(Input.is_physical_key_pressed(KEY_RIGHT)) - float(Input.is_physical_key_pressed(KEY_LEFT)),
		float(Input.is_physical_key_pressed(KEY_DOWN)) - float(Input.is_physical_key_pressed(KEY_UP))
	)
	if heading != Vector2.ZERO:
		var index := posmod(roundi((heading.angle() + PI / 2.0) / (PI / 4.0)), 8)
		_on_direction_selected(index)

func _on_perspective_selected(index: int) -> void:
	perspective_picker.select(index)
	warrior.perspective = index
	_refresh()

func _on_direction_selected(index: int) -> void:
	direction_picker.select(index)
	warrior.direction = index
	_refresh()

func _on_zoom_changed(value: float) -> void:
	warrior.display_zoom = value

func _on_walk_toggled(enabled: bool) -> void:
	warrior.animation_state = 1 if enabled else 0
	_refresh()

func _refresh() -> void:
	var frames := classic_frames if perspective_picker.selected == 0 else isometric_frames
	var walking := walk_button.button_pressed
	if walking:
		frames = classic_walk_frames if perspective_picker.selected == 0 else isometric_walk_frames
	var prefix := "walk_" if walking else "idle_"
	for index in range(8):
		var sprite: AnimatedSprite2D = previews.get_node("Pose%d" % index)
		sprite.sprite_frames = frames
		sprite.animation = prefix + str(warrior.DIRECTIONS[index])
		sprite.scale = Vector2.ONE * (warrior.walk_sprite_scale if walking else warrior.idle_sprite_scale) * 0.64
		sprite.offset = warrior.walk_sprite_offset if walking else warrior.idle_sprite_offset
		if walking:
			sprite.play()
		else:
			sprite.stop()
	pose_label.text = "%s / %s%s" % [perspective_picker.get_item_text(perspective_picker.selected), prefix, warrior.DIRECTIONS[direction_picker.selected]]
