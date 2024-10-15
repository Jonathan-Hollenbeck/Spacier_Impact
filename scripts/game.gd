extends Node2D

@onready var hud = $CanvasLayer/HUD
@onready var level = $Level
@onready var player = $Level/Player

func _ready() -> void:
	player.game_over.connect(game_over)
	player.set_hitpoints.connect(set_hitpoints)
	hud.retry_button_pressed.connect(restart_game)
	set_hitpoints()

func game_over() -> void:
	get_tree().paused = true
	hud.retry_button.visible = true
	level.set_highscore()

func restart_game() -> void:
	get_tree().paused = false
	hud.retry_button.visible = false
	level.reset_level()
	set_hitpoints()

func set_hitpoints() -> void:
	hud.set_hitpoints(player.hitpoints)
