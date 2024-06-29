class_name Camera
extends Camera2D


@export var camera: Camera2D
@export var max_offset := Vector2(10.0, 10.0)
@export var max_rotation := 0.01
@export var decay := 5.0


var _shake_offset := Vector2.ZERO
var _shake_rotation := 0.0


func _process(delta: float) -> void:
	_update_current_camera()

	if not is_current():
		return

	_shake_offset = _shake_offset.lerp(Vector2.ZERO, decay * delta)
	_shake_rotation = lerp(_shake_rotation, 0.0, decay * delta)

	offset = camera.offset + Vector2(
		randf_range(-_shake_offset.x, _shake_offset.x),
		randf_range(-_shake_offset.y, _shake_offset.y),
	)

	rotation = camera.rotation + randf_range(-_shake_rotation, _shake_rotation)


func _update_current_camera() -> void:
	if not _shake_offset.is_zero_approx() and not is_current():
		make_current()
	elif _shake_offset.is_zero_approx() and not camera.is_current():
		_make_camera_current()


func _make_camera_current() -> void:
	offset = Vector2.ZERO
	rotation = 0.0

	_shake_offset = Vector2.ZERO
	_shake_rotation = 0.0

	camera.make_current()


func shake() -> void:
	_shake_offset = max_offset
	_shake_rotation = max_rotation
