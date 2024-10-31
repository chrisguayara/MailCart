extends StaticBody3D
class_name  placeholder
@onready var rusty_bucket = $"../RustyBucket"

@export var prompt_message = "Interact"
var original_position: Vector3
signal place_item

func interact(body):
	if body.has_method("get_picked_up_object"):
		var held_object = body.get_picked_up_object()
		if held_object and held_object == rusty_bucket:
			print(body.name, " put ", name, " down.")
