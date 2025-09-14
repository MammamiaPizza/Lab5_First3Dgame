extends CharacterBody3D

var minSpeed = 65
var maxSpeed = 80

func _process(delta: float) -> void:
	move_and_slide()

# This function will be called from the Main scene.
func initialize(start_position, player_position):
	look_at_from_position(start_position, player_position, Vector3.DOWN)
	#rotate_y(randf_range(-PI / 4, PI / 4))
	var random_speed = randi_range(minSpeed, maxSpeed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
