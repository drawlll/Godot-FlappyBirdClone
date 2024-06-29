class_name AudioManagerClass

extends Node



func play_sound(sound):
	match sound:
		"wing":
			$wing.play()
		"swoosh":
			$swoosh.play()
		"point":
			$point.play()
		"hit":
			$hit.play()
		"die":
			$die.play()
	
