extends Node2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var countdown: Countdown = get_tree().current_scene.get_node("Countdown")

@export var allowed_shoot_margin: float

signal player_fired(fired_at_time: bool)

func _ready() -> void:
	add_to_group("player")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()



func shoot() -> void:
	animated_sprite_2d.play("shoot")
	player_fired.emit(countdown.time_left <= allowed_shoot_margin)
