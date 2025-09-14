extends Control


@onready var mainmenu = load("res://scene/menu.tscn")

func _ready() -> void:
	mainmenu = load("res://scene/menu.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_packed(mainmenu)

func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()

func setscore(scoreinput : int):
	$CanvasLayer/Score.text = "Score: " + str(scoreinput)
