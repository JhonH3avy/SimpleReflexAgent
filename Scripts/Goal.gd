extends Area2D


export var position_offset : int = 16
export var position_tile_size : int = 32


func _on_exit_position_generated(exit_position):	
	position_exit(exit_position)


func _on_Goal_body_entered(body):
	print("agent detected")


func position_exit(tile_position):
	var temp_position = tile_position * position_tile_size
	temp_position.x += position_offset
	temp_position.y += position_offset
	position = temp_position