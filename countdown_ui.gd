extends Node2D
class_name CountdownUI

var initial_time: float
@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var countdown: Countdown = $"../Countdown"
@export var timer_label: Label
var amount_of_chars: int = 4

func _ready() -> void:
	initial_time = countdown.initial_time
#CHECK ENEMY TIMER
func _physics_process(delta: float) -> void:
	if countdown.time_left < 0:
		amount_of_chars = 5
	else:
		amount_of_chars = 4
	timer_label.text = str(countdown.time_left).substr(0, amount_of_chars)
