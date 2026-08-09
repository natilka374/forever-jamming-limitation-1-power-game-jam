extends Node
class_name GameManager
@onready var round_over_menu: VBoxContainer = get_tree().current_scene.get_node("RoundOverMenu")
var round_over_lost_text: Label
var round_over_won_text: Label
@onready var countdown: Countdown = get_tree().current_scene.get_node("Countdown")
@onready var countdown_ui: CountdownUI = $"../CountdownUI"

var enemies: Array[Enemy]
var round_over := false

func _ready() -> void:
	for enemy: Enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.enemy_fired.connect(enemy_fired)
		enemies.append(enemy)
		
	var player: Player = get_tree().get_first_node_in_group("player")
	player.player_fired.connect(player_fired)
		
	round_over_lost_text = round_over_menu.get_node("LostText")
	round_over_won_text = round_over_menu.get_node("WonText")

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

func reset_round() -> void:
	round_over = false
	countdown.reset()
	round_over_won_text.visible = false
	round_over_lost_text.visible = false
	countdown_ui.z_index = -1
	for enemy in enemies:
		enemy.reset()

func _on_reset_pressed() -> void:
	reset_round()
