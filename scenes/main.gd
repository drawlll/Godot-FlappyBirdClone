extends Node


@onready var bird = %Bird
@onready var ground = %Ground
@export var pipe_scene :PackedScene 

@onready var ui = %UI.get_node("UI")

var game_running :bool
var game_over :bool
var scroll = 0
var score = 0
const SCROLL_SPEED :int = 4
var screen_size :Vector2
var ground_height :int
var pipes :Array
const PIPE_DELAY :int = 100
const PIPE_RANGE :int = 200

func _ready():
	screen_size = get_window().size
	ground_height = ground.get_node("Sprite2D").texture.get_height()
	ui.restart.connect(new_game)
	ground.hit.connect(bird_hit)
	match Global.bird_pressed:
		"yellow":
			bird.get_node("AnimatedSprite2D").play("yellow_flying")
		"red":
			bird.get_node("AnimatedSprite2D").play("red_flying")
		"blue":
			bird.get_node("AnimatedSprite2D").play("blue_flying")
		_:
			bird.get_node("AnimatedSprite2D").play("yellow_flying")
	new_game()
	ui.get_parent().get_node("StartButton").visible = false
	ui.get_child(0).get_node("ScoreCounter").visible = true
	$CanvasLayer/AnimationPlayer.play("black2wipe")
	await get_tree().create_timer(0.3).timeout
	$Audio.play_sound("swoosh")

func new_game():
	$CanvasLayer/AnimationPlayer.play("fade2white")
	await get_tree().create_timer(0.8).timeout
	$BackgroundNight.position.x = screen_size.x
	score = 0
	get_node("CanvasLayer/UI").find_child("UI").update_score(score)
	scroll = 0
	game_running = false
	game_over = false
	pipes.clear()
	get_tree().call_group("pipes", "queue_free")
	generate_pipes()
	bird.reset()

func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if bird.flying:
						bird.flap()
						check_top()
		if event is InputEventKey:
			if event.key_label == KEY_SPACE and event.pressed:
				if game_running == false:
					start_game()
				else:
					if bird.flying:
						bird.flap()
						check_top()



func start_game():
	game_running = true
	bird.flying = true
	bird.flap()
	$PipesTimer.start()

func stop_game():
	$PipesTimer.stop()
	bird.flying = false
	game_running = false
	game_over = true

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.score.connect(update_score)
	add_child(pipe)
	pipes.append(pipe)
	

func check_top():
	if bird.position.y < 0:
		bird.falling = true
		get_child(0).play_sound("die")
		stop_game()

func _on_pipes_timer_timeout():
	generate_pipes()

func _physics_process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		%Ground.position.x = (-scroll)
		$BackgroundNight.position.x = (-scroll / 2 + screen_size.x)
		for pipe in pipes:
			if is_instance_valid(pipe):
				pipe.position.x -= SCROLL_SPEED
			

func bird_hit():
	bird.falling = true
	$CanvasLayer/AnimationPlayer.play("whitescreen")
	$Camera2D.shake()
	$CanvasLayer/UI.find_child("AnimationPlayer").play("game_over")
	stop_game()


func _on_ground_hit():
	bird.falling = false
	stop_game()

func update_score():
	score += 1
	get_node("CanvasLayer/UI").find_child("UI").update_score(score)

