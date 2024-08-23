extends CharacterBody2D

@export var MOVEMENT_SPEED : int = 100
@export var INTERACTION_RADIUS : int = 16
@export var START_DIRECTION : Vector2 = Vector2(0, 1)

# Animations
@onready var animated_sprite = $Sprite2D
@onready var animation_tree = $AnimationTree 
@onready var state_machine = animation_tree.get("parameters/playback")

# Attack 
@onready var attack_timer = $AttackTimer
var CAN_ATTACK: bool = true 

# Inventory 
@export var CURRENT_ITEM : String = "Hoe"

func _ready():
	print("[READY] MainCharacter")
	
func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized() 
	
	velocity = input_direction * MOVEMENT_SPEED 
	move_and_slide()
	update_animation(input_direction)
	
	if (Input.is_action_just_pressed("interact")):
		obj_interact()
	if (Input.is_action_just_pressed("attack")):
		attack()
	if (Input.is_action_just_pressed("inventory")):
		toggle_inventory()
	
	# Item Switching
	if (Input.is_action_just_pressed("item1")):
		CURRENT_ITEM = "Hoe"
	if (Input.is_action_just_pressed("item2")):
		CURRENT_ITEM = "Chop"
	if (Input.is_action_just_pressed("item3")):
		CURRENT_ITEM = "Water"

func update_animation(input_direction: Vector2) -> void:
	if input_direction != Vector2.ZERO:
		animation_tree.set("parameters/Walk/blend_position", input_direction)
		animation_tree.set("parameters/Idle/blend_position", input_direction)
		animation_tree.set("parameters/Hoe/blend_position", input_direction)
		animation_tree.set("parameters/Chop/blend_position", input_direction)
		animation_tree.set("parameters/Water/blend_position", input_direction)
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func obj_interact():
	var shape = CircleShape2D.new()
	shape.radius = INTERACTION_RADIUS
	
	var query = PhysicsShapeQueryParameters2D.new()
	query.set_shape(shape)
	query.transform = global_transform 
	query.exclude = [self]
	
	var space_state = get_world_2d().direct_space_state
	var results = space_state.intersect_shape(query)
	
	for result in results:
		var collider = result.collider
		if collider.has_method("interact"):
			collider.interact()
			return 
			
	print("No interactables")

func attack():
	if CAN_ATTACK:
		CAN_ATTACK = false 
		state_machine.travel(CURRENT_ITEM)
		attack_timer.start()
	else:
		print("CAN'T ATTACK")

func _on_attack_timer_timeout():
	CAN_ATTACK = true

func toggle_inventory():
	EventController.emit_signal("inventory_toggled")
