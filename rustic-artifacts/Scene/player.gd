extends CharacterBody2D
@export_category("Player Movement")
@export var speed : float = 300.0
@export var walk_haltspeed : float = 300.0

@export var jump_velocity = -400.0
@export var jump_gravity = 2000
@export var fall_gravity = 2700

var block_movement : bool
@export var player_sprite : AnimatedSprite2D
var cached_x: float
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		# while going up
		if velocity.y < 0:
			velocity.y += jump_gravity * delta
		#while coming down	
		else:
			velocity.y += fall_gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("A", "D")
	
	if direction && !block_movement:
		velocity.x = direction * speed
		player_sprite.flip_h = !bool(int(direction + 1)/2)
		cached_x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, walk_haltspeed)
	
	if Input.is_action_just_pressed("Attack"):
		player_sprite.play("Attack")
		block_movement = true

	move_and_slide()


func Animation_finished() -> void:
	if(player_sprite.animation == "Attack"):
		player_sprite.play("Idle")
		block_movement = false
