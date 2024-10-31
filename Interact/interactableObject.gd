extends RigidBody3D
class_name  Interactable

@export var prompt_message = "Interact"
var original_position: Vector3
var is_picked_up: bool = false

func interact(body):
	print(body.name, " interacted with ", name)
	is_picked_up=true
	set_freeze_enabled(true)
	FREEZE_MODE_KINEMATIC
	print(is_picked_up)

func drop():
	is_picked_up = false
	set_freeze_enabled(false)
	

