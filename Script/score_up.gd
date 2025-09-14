extends Area3D


func _on_body_entered(body: Node3D) -> void:
	#print(body.get_groups())
	queue_free()

func getscore() ->int:
	var randomscore = randi_range(1,20000)
	return randomscore

func _on_timer_timeout() -> void:
	queue_free()
