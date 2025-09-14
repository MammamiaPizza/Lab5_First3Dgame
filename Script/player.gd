extends CharacterBody3D

signal death

@export var speed : int
var speedbase = 15
var sprintspeed = 30
@export var fall = 75

var alive = true

var target_velocity = Vector3.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Node3D2.rotate_y(deg_to_rad(0.2 * -event.relative.x))
		##$Node3D2.rotate_x(deg_to_rad(0.2 * -event.relative.y))

func _physics_process(delta: float) -> void:
	if alive:
		var direction = Vector3.ZERO
		
		var axisx = Input.get_axis("left","right")
		var axisz = Input.get_axis("forward","backward")
		
		direction.x += axisx
		direction.z += axisz
		
		direction = direction.rotated(Vector3.UP, $Node3D2/Camera3D.global_rotation.y)
	
		if direction != Vector3.ZERO:
			direction = direction.normalized()
			# * -1 to make looking at make real to move direction
			$Node3D.basis = Basis.looking_at(direction * -1)
			if Input.is_action_pressed("sprint"):
				$Node3D/Root_Scene/AnimationPlayer.play("HumanArmature|Man_Run")
				speed = sprintspeed
			else:
				speed = speedbase
				$Node3D/Root_Scene/AnimationPlayer.play("HumanArmature|Man_Walk")
		else:
			$Node3D/Root_Scene/AnimationPlayer.play("HumanArmature|Man_Idle")

		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
		
		if !is_on_floor():
			target_velocity.y = target_velocity.y - (fall * delta)
			
		velocity = target_velocity
		move_and_slide()
		


func _on_hit_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("Enemy"):
		alive = false
		queue_free()
		death.emit()
	if area.is_in_group("ScoreUp"):
		$"..".scoreup(area.getscore())
