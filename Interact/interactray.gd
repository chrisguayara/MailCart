extends RayCast3D
@onready var prompt = $Prompt

func _physics_process(delta):
	prompt.text = ""
	
	if is_colliding():
		var collider = get_collider()
		
		if collider is Interactable:
			prompt.text = collider.prompt_message
			
			if Input.is_action_just_pressed("interact"):
				collider.interact(owner)
		if collider is buttons_switches:
			prompt.text = collider.prompt_message
			if Input.is_action_just_pressed("interact"):
				collider.interact(owner)
