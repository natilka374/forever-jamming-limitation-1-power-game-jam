extends Node
class_name GameManager
@onready var round_over_menu: VBoxContainer = get_tree().current_scene.get_node("RoundOverMenu")
var round_over_lost_text: Label
var round_over_won_text: Label
var next_round_button: Button
@onready var countdown: Countdown = get_tree().current_scene.get_node("Countdown")
@onready var countdown_ui: CountdownUI = $"../CountdownUI"

var enemies: Array[Enemy]
var round_over := false

const ENEMY_SCENE = preload("res://enemy.tscn")

@export var enemy_min_reaction_time: float
@export var enemy_max_reaction_time: float

@export var inital_time_max: float
@export var inital_time_min: float
var inital_time: float

@export var ENEMY_SPAWN_POSITION: Vector2

func _ready() -> void:	
	round_over_lost_text = round_over_menu.get_node("LostText")
	round_over_won_text = round_over_menu.get_node("WonText")
	next_round_button = round_over_menu.get_node("NextRound")
	
	start_round()
	
	for enemy: Enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.enemy_fired.connect(enemy_fired)
		enemies.append(enemy)
		
	var player: Player = get_tree().get_first_node_in_group("player")
	player.player_fired.connect(player_fired)


func enemy_fired() -> void:
	player_lost()

func player_fired(fired_at_time: bool) -> void:
	if fired_at_time:
		player_won()
	else:
		player_lost()

func player_lost() -> void:
	if not round_over:
		round_over_lost_text.visible = true
		round_over = true	
	countdown.stop()
	countdown_ui.z_index = 1

func player_won() -> void:
	if not round_over:
		round_over_won_text.visible = true
		round_over = true
	countdown.stop()
	countdown_ui.z_index = 1
	next_round_button.visible = true
	
func reset_round() -> void:
	round_over = false
	countdown.start(inital_time)
	round_over_won_text.visible = false
	round_over_lost_text.visible = false
	countdown_ui.z_index = -1
	for enemy in enemies:
		enemy.reset()

func spawn_random_enemy() -> Enemy:
	var enemy: Enemy = ENEMY_SCENE.instantiate()
	get_tree().current_scene.get_node("Enemies").add_child(enemy)
	
	var reaction_time := randf_range(enemy_min_reaction_time, enemy_max_reaction_time)
	enemy.reaction_time = reaction_time
	enemy.position = ENEMY_SPAWN_POSITION
	enemy.should_block_timer_ui = reaction_time > 0.5
	enemy.block_timer_ui_after_seconds = inital_time / 2
	
	return enemy 


func _on_reset_pressed() -> void:
	reset_round()

func start_round() -> void:
	round_over_lost_text.visible = false
	round_over_won_text.visible = false
	next_round_button.visible = false
	
	if enemies:
		for enemy: Enemy in enemies:
			enemies.erase(enemy)
			enemy.queue_free()
	var enemy: Enemy = spawn_random_enemy()
	enemies.append(enemy)
	inital_time = randf_range(inital_time_min, inital_time_max)
	countdown.start(inital_time)

func _on_next_round_button_pressed() -> void:
	start_round()
