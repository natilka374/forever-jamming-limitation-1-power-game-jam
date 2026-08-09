extends Node2D
class_name Enemy

@export var reaction_time: float
@onready var shoot_timer: Timer = $ShootTimer
@export var enemy_gun: AnimatedSprite2D

@onready var countdown: Countdown = get_tree().current_scene.get_node("Countdown")
@onready var countdown_ui: CountdownUI = get_tree().current_scene.get_node("CountdownUI")


@export var block_timer_ui_after_seconds: float
@export var should_block_timer_ui: bool
var block_timer_ui_timer: Timer 
var original_position: Vector2

signal enemy_fired()

func _ready() -> void:
	original_position = position
	shoot_timer.wait_time = reaction_time
	countdown.timer_finished.connect(shoot_player)
	add_to_group("enemies")
	
	if should_block_timer_ui:
		block_timer_ui_timer= Timer.new()
		add_child(block_timer_ui_timer)	
		activate_block_ui_timer()
		
func activate_block_ui_timer() -> void:
	block_timer_ui_timer.wait_time = block_timer_ui_after_seconds
	block_timer_ui_timer.start()
	await block_timer_ui_timer.timeout
	block_timer_ui()
	
func shoot_player() -> void:
	shoot_timer.start()
	await shoot_timer.timeout
	enemy_fired.emit()
	
	if enemy_gun:
		enemy_gun.play("shoot")
	
func block_timer_ui() -> void:
	var countdown_ui_container: HBoxContainer = countdown_ui.get_child(0)
	var timer_ui_position: Vector2 = countdown_ui_container.global_position
	for child: Control in countdown_ui_container.get_children(true):
		if child.name == "Timer":
			timer_ui_position += child.size / 2
		else:
			timer_ui_position += child.size
		
	position = timer_ui_position

func reset() -> void:
	position = original_position
	
	if should_block_timer_ui:
		activate_block_ui_timer()
