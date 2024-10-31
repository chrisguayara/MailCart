extends Control
@onready var text_timer = $TextTimer
@onready var label_2 = $Label2
@onready var label = $Label
@onready var lightswitch_on = $lightswitchOn
@onready var lightswitch_off = $lightswitchOff


func _ready():
	text_timer.start()
	lightswitch_on.playing=true


func _on_text_timer_timeout():
	label.visible=false

	lightswitch_on.playing=false
	lightswitch_off.playing=true
