extends Node2D

@export var meteor_spawnrate_mutiplier : float = 0.01

@onready var hud = $"../CanvasLayer/HUD"
@onready var meteor_spawner = $MeteorSpawner
@onready var player = $Player
@onready var meteorsContainer = $MeteorsContainer

var meteor = preload("res://scenes/Meteor.tscn")
var screen_size : Vector2
var random_number_generator : RandomNumberGenerator = RandomNumberGenerator.new()

var score : int = 0

var highscore : int = 0

func _ready() -> void:
	meteor_spawner.spawn_meteor.connect(spawn_meteor)
	screen_size = get_tree().root.size

func spawn_meteor() -> void:
	var meteor_instance = meteor.instantiate()
	var random = random_number_generator.randf_range(0, screen_size.y)
	meteor_instance.position = Vector2(screen_size.x, random)
	meteor_instance.destroyed.connect(on_meteor_destroyed.bind(meteor_instance.score))
	meteorsContainer.add_child(meteor_instance)

func on_meteor_destroyed(points : int) -> void:
	score += points
	hud.set_score(score)
	var meteor_spawnrate = 1 - (score * meteor_spawnrate_mutiplier)
	if meteor_spawnrate <= 0:
		meteor_spawnrate = 0.1
	meteor_spawner.wait_time = meteor_spawnrate
	set_highscore()

func reset_level() -> void:
	score = 0
	hud.set_score(score)
	for child in meteorsContainer.get_children():
		child.queue_free()
	player.reset()

func set_highscore() -> void:
	if score > highscore:
		highscore = score
		hud.set_highscore(highscore)
