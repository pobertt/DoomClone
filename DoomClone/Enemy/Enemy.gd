extends CharacterBody3D

@onready var animated_sprite_3d = $AnimatedSprite3D

@export var move_speed : float = 2.0
@export var attack_range : float = 2.0

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
var dead : bool = false

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
		
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	velocity = dir * move_speed
	move_and_slide()
	attack()
	
func attack():
	var dist_to_player = global_position.distance_to(player.global_position) 
	if dist_to_player > attack_range:
		return
		
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position*eye_line, player.global_position+eye_line, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		player.kill()	
	
func kill():
	dead = true
	$DeathSound.play()
	animated_sprite_3d.play("Death")
	$CollisionShape3D.disabled = true
