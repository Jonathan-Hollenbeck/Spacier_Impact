extends Node2D

@export var move_speed : float = 18

func _process(delta: float) -> void:
	position.x += move_speed

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Meteor"):
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
