extends Node
class_name Countdown

signal timer_finished

var is_running := false

@export var initial_time: float

var timer_text: Label

var time_left: float
var inital_time: float 

func _process(delta: float) -> void:
	if is_running:
		time_left = time_left - delta
		if time_left <= 0.0:
			timer_finished.emit()
			is_running = false

func start(time: float) -> void:
	time_left = initial_time
	is_running = true

func stop() -> void:
	is_running = false

func resume() -> void:
	is_running = false
