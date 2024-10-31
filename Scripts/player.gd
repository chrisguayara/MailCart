extends CharacterBody3D

@onready var camera = $Head/Camera
@onready var character_mover = $character_mover
@export var mouse_sensitivity_h = .13
@export var mouse_sensitivity_v = .13
@onready var interact_ray = $Head/Camera/InteractRay
@onready var hand_marker = $HandMarker

var object_in_hand = false
var picked_up_object = null

var dead = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h
		camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -78, 90)

func _physics_process(delta):
	
	# Quit, restart, and fullscreen commands
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("fullscreen"):
		var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if fs:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if dead:
		return
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	character_mover.set_move_dir(move_dir)

	if Input.is_action_just_pressed("jump"):
		character_mover.jump()

	# Interaction with objects
	if Input.is_action_just_pressed("interact") and interact_ray.is_colliding():
		var collider = interact_ray.get_collider()
		if collider and collider is Interactable:
			# If no object is currently picked up, pick up the object
			if picked_up_object == null:
				collider.interact(self)
				pick_up_object(collider)
				object_in_hand = true
			# Drop the object if one is already held
			else:
				drop_object()
	if object_in_hand and Input.is_action_just_pressed("drop"):
		drop_object()
	# Move the picked-up object with the hand marker if an object is held
	if object_in_hand and picked_up_object:
		move_object_with_hand()
		
	

func pick_up_object(object): 
	picked_up_object = object

	picked_up_object.set_freeze_enabled(true) 
	picked_up_object.global_transform.origin = hand_marker.global_transform.origin 
	
	if picked_up_object.get_parent() != hand_marker:
		picked_up_object.get_parent().remove_child(picked_up_object)  
		hand_marker.add_child(picked_up_object)  
		picked_up_object.global_transform.origin = Vector3.ZERO 



func drop_object(): 
	if picked_up_object:
		picked_up_object.get_parent().remove_child(picked_up_object)  
		var drop_position = $HandMarker.global_transform.origin  
		picked_up_object.global_transform.origin = drop_position
		get_tree().current_scene.add_child(picked_up_object) 
		picked_up_object.set_freeze_enabled(false)  
		
		#gives this velocity so it doesnt just fall flat
		var forward_direction = hand_marker.global_transform.basis.z.normalized() 
		var forward_velocity = forward_direction * 26.0  
		picked_up_object.set_linear_velocity(forward_velocity)
		
		picked_up_object = null  
		object_in_hand=false

func get_picked_up_object():
	return picked_up_object

func move_object_with_hand():
	if picked_up_object:
		picked_up_object.global_transform.origin = hand_marker.global_transform.origin
		picked_up_object.global_transform.basis = hand_marker.global_transform.basis  # Optional: match rotation



func kill():
	dead = true
	character_mover.set_move_dir(Vector3.ZERO)


func _on_fill_blood_bucket_filled():
	print("the bucket is filled")
