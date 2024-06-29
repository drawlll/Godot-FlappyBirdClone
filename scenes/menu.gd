extends Node


@onready var bird = %Bird
@onready var ground = %Ground

@onready var ui = %UI.get_node("UI")

var scroll = 0
const SCROLL_SPEED :int = 4
var screen_size :Vector2

func _ready():
	screen_size = get_window().size
	ui.start.connect(start_game)
	ui.get_parent().get_node("StartButton").visible = true
	ui.get_child(0).get_node("ScoreCounter").visible = false

func _input(event):
	pass

func start_game():
	# wipe to black
	$CanvasLayer/AnimationPlayer.play("wipe2black")
	await get_tree().create_timer(0.3).timeout
	$Audio.play_sound("swoosh")
	await get_tree().create_timer(1).timeout
	# change scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _physics_process(delta):
	scroll += SCROLL_SPEED
	if scroll >= screen_size.x:
		scroll = 0
	%Ground.position.x = -scroll


func _on_blue_bird_pressed():
	Global.bird_pressed = "blue"
	$CanvasLayer/Control/ChosenBird.set_frame_and_progress(2,0)


func _on_red_bird_pressed():
	Global.bird_pressed = "red"
	$CanvasLayer/Control/ChosenBird.set_frame_and_progress(1,0)


func _on_yellow_bird_pressed():
	Global.bird_pressed = "yellow"
	$CanvasLayer/Control/ChosenBird.set_frame_and_progress(0,0)
