extends HBoxContainer


var digit_coords = {
	0: Vector2(0, 0),
	1: Vector2(24, 0),
	2: Vector2(48, 0),
	3: Vector2(72, 0),
	4: Vector2(96, 0),
	5: Vector2(120, 0),
	6: Vector2(144, 0),
	7: Vector2(168, 0),
	8: Vector2(192, 0),
	9: Vector2(216, 0),
}

func display_digits(n):
	var s = "%03d" % n
	for i in 3:
		print(i)
		get_child(i).texture.region = Rect2(digit_coords[int(s[i])], Vector2(24, 36))
