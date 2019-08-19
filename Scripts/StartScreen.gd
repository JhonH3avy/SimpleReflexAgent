extends CanvasLayer



func _on_Button_pressed():
	var error = get_tree().change_scene("res://Scenes/Game.tscn")
	if error != OK:
		print("Scene could not be loaded normally")
	
