extends Control

@onready var score_label = $Score
@onready var retry_button = $RetryButton
@onready var high_score_label = $HighScore
@onready var hitpoints : Control = $Hitpoints

var heart = preload("res://scenes/Heart.tscn")
var heart_width = 32

signal retry_button_pressed

func set_score(score : int):
	score_label.text = "Score " + str(score)

func set_highscore(high_score: int):
	high_score_label.text = "Highscore " + str(high_score)

func _on_retry_button_pressed() -> void:
	retry_button_pressed.emit()

func set_hitpoints(_hitpoints : int) -> void:
	for child in hitpoints.get_children():
		child.queue_free()
	for i in _hitpoints:
		var heart_instance = heart.instantiate()
		heart_instance.position = Vector2(i * (heart_width + 2), 0)
		hitpoints.add_child(heart_instance)
