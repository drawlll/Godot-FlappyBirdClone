extends Area2D

signal hit
signal score

func _on_body_entered(body :CharacterBody2D):
	if !body.falling:
		hit.emit()
		get_parent().get_child(0).play_sound("hit")
		await get_tree().create_timer(0.1).timeout
		get_parent().get_child(0).play_sound("die")


func _on_score_area_body_entered(body):
	get_parent().get_child(0).play_sound("point")
	score.emit()
