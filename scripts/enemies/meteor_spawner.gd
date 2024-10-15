extends Timer

signal spawn_meteor

func _on_timeout() -> void:
	spawn_meteor.emit()
