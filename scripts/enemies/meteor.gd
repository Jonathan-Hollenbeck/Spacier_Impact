extends Node2D

signal destroyed

@export var move_speed : float = 4
@export var hitpoints : int = 2
@export var score : int = 1

var movement : Vector2

var rotation_speed : float = randf_range(-0.1, 0.1)

func _ready() -> void:
	var scale_size : float = randf_range(-0.2, 0.5)
	scale += Vector2(scale_size, scale_size)
	move_speed += move_speed * (scale_size * -1)
	var vertical_movement = randf_range(-0.9, 0.9)
	movement = Vector2(-move_speed, vertical_movement)

func _process(delta: float) -> void:
	position += movement
	rotation += rotation_speed

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		queue_free()
	if area.is_in_group("LaserSingle"):
		hitpoints -= 1
		movement.x /= 2
		scale = Vector2(scale.x - 0.3, scale.y - 0.3)
		if hitpoints <= 0:
			destroyed.emit()
			queue_free()

func in_range(value: float, min: float, max: float) -> bool:
	return value >= min and value <= max

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
