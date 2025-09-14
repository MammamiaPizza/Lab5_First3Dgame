extends Node3D


@export var mobscene : PackedScene

@onready var gameoverscene = preload("res://scene/GameOver.tscn")
@onready var scoreitem = preload("res://scene/ScoreUp.tscn")

var score = 0

var mintime = 1
var maxtime = 5

func _ready() -> void:
	$UI/CanvasLayer.show()
	score = 0

func _on_spawner_time_timeout() -> void:
	#print("hello")
	var mob = mobscene.instantiate()
	var mob_spawn_location = get_node("Spawnpoint/Spawn")
	mob_spawn_location.progress_ratio = randf()
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	add_child(mob)
	$RandomRok.wait_time = randi_range(mintime,maxtime)
	$RandomRok.start()

func _on_area_3d_area_exited(area: Area3D) -> void:
	area.queue_free()

func _on_area_3d_body_exited(body: Node3D) -> void:
	body.queue_free()
	if body.is_in_group("Player"):
		_on_player_death()

func _on_score_timer_timeout() -> void:
	score += 1
	$UI/CanvasLayer/Score.text =  "Score: " + str(score)
	increaseHard()

func _on_player_death() -> void:
	$ScoreTimer.stop()
	$SpawnerTime.stop()
	$ScoreUp.stop()
	$RandomRok.stop()
	$UI.queue_free()
	$AudioStreamPlayer.stop()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	call_deferred("_show_gameover")

func scoreup(inputscore:int):
	score += inputscore
	$UI/CanvasLayer/Score.text = "Score: " + str(score)
	increaseHard()


func _on_score_up_timeout() -> void:
	var chicken = scoreitem.instantiate()
	var randomSpawnX = randi_range(-41, 41)
	var randomSpawnZ = randi_range(-41, 41)
	var spawnlocation = Vector3(randomSpawnX, 0.6, randomSpawnZ)
	
	chicken.position = spawnlocation
	add_child(chicken)
	
	
func increaseHard():
	if score > 100:
		var delCarCooldown = score / 10000
		if delCarCooldown < 2.5:
			$SpawnerTime.wait_time = 3 - delCarCooldown
			mintime += delCarCooldown + 1.5
			maxtime += delCarCooldown + 1.5
		else:
			$SpawnerTime.wait_time = 0.5
			mintime = 4
			maxtime = 8
	

func _on_random_rok_timeout() -> void:
	var mob_spawn_location = get_node("Spawnpoint/Spawn")
	mob_spawn_location.progress_ratio = randf()
	var sound = load("res://asset/sound/truck-horn-306425.mp3")
	var soundplayer = AudioStreamPlayer3D.new()
	soundplayer.position = mob_spawn_location.position
	soundplayer.set_stream(sound)
	soundplayer.autoplay = true
	add_child(soundplayer)
	await soundplayer.finished
	soundplayer.queue_free()

func _show_gameover() -> void:
	var over = gameoverscene.instantiate()
	add_child(over)
	over.setscore(score)
