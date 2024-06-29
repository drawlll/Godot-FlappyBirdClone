extends MarginContainer
signal restart
signal start


@onready var score_counter = %ScoreCounter

var value = 0

func update_score(value):
	print(value)
	score_counter.display_digits(value)



func _on_button_pressed():
	restart.emit()
	%AnimationPlayer.play("hide")


func _on_start_button_pressed():
	start.emit()
