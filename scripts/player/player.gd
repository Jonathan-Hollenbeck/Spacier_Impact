extends Node2D

@export var accelaration : Vector4 = Vector4(1.5, 1, 1.5, 1)
@export var slow : Vector2 = Vector2(0.5, 0.2)
@export var max_speed : Vector4 = Vector4(12, 8, 12, 8)
@export var hitpoints : int = 4

@onready var animationIdle = $Area2D/AnimatedSprite2D
@onready var shootTimer = $ShootTimer

@onready var topGun = $TopGun
@onready var bottomGun = $BottomGun

signal game_over
signal set_hitpoints

var laser_single = preload("res://scenes/projectiles/laser_single.tscn")
var screen_size : Vector2

var speed : Vector2 = Vector2(0, 0)

var shootReady : bool = true

var shootBottom : bool = true

func _ready() -> void:
	screen_size = get_tree().root.size

func _process(delta: float) -> void:
	animationIdle.play("default")
	move()
	shoot()

func move() -> void:
	#read input and apply accelarations
	if Input.is_action_pressed("input_left"):
		speed.x -= accelaration.x
		if speed.x < (-max_speed.x):
			speed.x = -max_speed.x
	if Input.is_action_pressed("input_up"):
		speed.y -= accelaration.y
		if speed.y < (-max_speed.y):
			speed.y = -max_speed.y
	if Input.is_action_pressed("input_right"):
		speed.x += accelaration.z
		if speed.x > max_speed.z:
			speed.x = max_speed.z
	if Input.is_action_pressed("input_down"):
		speed.y += accelaration.w
		if speed.y > max_speed.w:
			speed.y = max_speed.w
	#apply slows
	if speed.x > 0:
		speed.x -= slow.x
		if speed.x < slow.x:
			speed.x = 0
	elif speed.x < 0:
		speed.x += slow.x
		if -speed.x < slow.x:
			speed.x = 0
	if speed.y > 0:
		speed.y -= slow.y
		if speed.y < slow.y:
			speed.y = 0
	elif speed.y < 0:
		speed.y += slow.y
		if -speed.y < slow.y:
			speed.y = 0
	#setting positions
	if !(position.y + speed.y) < 0 and !(position.y + speed.y) > screen_size.y:
		position.y += speed.y
	else:
		speed.y = 0
	if !(position.x + speed.x) < 0 and !(position.x + speed.x) > screen_size.x:
		position.x += speed.x
	else:
		speed.x = 0

func shoot() -> void:
	if Input.is_action_pressed("input_shoot"):
		if shootReady == true:
			var gunPosition : Vector2 = position + topGun.position
			if shootBottom == true:
				gunPosition = position + bottomGun.position
				shootBottom = false
			else:
				shootBottom = true
				
			var laser_single_instance = laser_single.instantiate()
			laser_single_instance.position = gunPosition
			get_tree().root.add_child(laser_single_instance)
			shootReady = false
			shootTimer.start()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Meteor"):
		hitpoints -= 1
		set_hitpoints.emit()
		if hitpoints <= 0:
			game_over.emit()

func reset() -> void:
	hitpoints = 4
	set_hitpoints.emit

func _on_shoot_timer_timeout() -> void:
	shootReady = true
