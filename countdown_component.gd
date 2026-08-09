extends Node
class_name Countdown

signal timer_finished

var finished := false

@export var initial_time: float

var time_left: float
var timer_text: Label

func _ready() -> void:
	time_left = initial_time

func _process(delta: float) -> void:
	if not finished:
		#time_left = maxf(time_left - delta, 0.0)
		time_left = time_left - delta
		if time_left <= 0.0:
			timer_finished.emit()
			finished = true

func reset() -> void:
	time_left = initial_time
	finished = false

func stop() -> void:
	finished = true
