extends StaticBody3D
class_name  buttons_switches
@onready var rusty_bucket = $"../RustyBucket"

@export var prompt_message = "Interact"
var original_position: Vector3

signal bucket_filled
@onready var rustybucket_empty = $"../RustyBucket/rustybucket"
@onready var rustybucket_filled = $"../RustyBucket/rustybucket_filled"
@onready var fill_noise = $"../RustyBucket/fill_noise"

var is_filled = false

func _ready():
	rustybucket_empty.visible=true
	rustybucket_filled.visible = false

func interact(body):
	if body.has_method("get_picked_up_object"):
		var held_object = body.get_picked_up_object()
		if held_object and held_object == rusty_bucket:
			print(body.name, " interacted with ", name)
			emit_signal("bucket_filled")
			is_filled=true
			rustybucket_empty.visible=false
			rustybucket_filled.visible=true
			fill_noise.playing=true
		else: print("You need something to hold the blood...")
	

