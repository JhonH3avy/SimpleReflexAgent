extends TileMap

signal start_position_generated(start_position)
signal exit_position_generated(exit_position)

export var width : int = 32
export var height : int = 19

var visited_cells = []
var neightboors = []

func _ready():
	randomize()
	var initial_cell = generate_initial_cell()
	add_to_maze(initial_cell)
	neightboors = get_neigtboor_walls(initial_cell)
	generate_maze()
	generate_start()
	generate_exit()


func generate_initial_cell()->Vector2:
	var x = (randi() + 1) % (width - 1)
	var y = (randi() + 1) % (height - 1)
	return Vector2(x,y)


func generate_start():
	var is_valid = false
	var start
	while not is_valid:
		var x = 0
		var y = (randi() + 1) % (height - 1)
		start = Vector2(x,y)
		var neightboor_cells = get_neigtboor_cells(start)
		var visited_cell_neightboors = 0
		for neightboor in neightboor_cells:
			if visited_cells.has(neightboor):
				visited_cell_neightboors += 1
		is_valid = visited_cell_neightboors == 1
	add_to_maze(start)
	emit_signal("start_position_generated", start)


func generate_exit():
	var is_valid = false
	var exit
	while not is_valid:
		var x = width - 1
		var y = (randi() + 1) % (height - 1)
		exit = Vector2(x,y)
		var neightboor_cells = get_neigtboor_cells(exit)
		var visited_cell_neightboors = 0
		for neightboor in neightboor_cells:
			if visited_cells.has(neightboor):
				visited_cell_neightboors += 1
		is_valid = visited_cell_neightboors == 1
	add_to_maze(exit)
	emit_signal("exit_position_generated", exit)


func generate_maze():
	while neightboors.size() > 0:
		var rand_idx = randi() % neightboors.size()
		var neightboor = neightboors[rand_idx]
		if is_valid_to_add_to_maze(neightboor):
			add_to_maze(neightboor)
			var new_neightboors = get_neigtboor_walls(neightboor)
			neightboors = neightboors + new_neightboors
		neightboors.erase(neightboor)


func add_to_maze(cell):
	set_cell(cell.x, cell.y, 0)
	visited_cells.append(cell)


func is_valid_to_add_to_maze(wall)->bool:
	if wall.x == 0 or wall.x == width - 1 or wall.y == 0 or wall.y == height - 1:
		return false
	var wall_neightboors = get_neigtboor_cells(wall)
	var visited_wall_neightboors = 0
	for neightboor in wall_neightboors:
		if visited_cells.has(neightboor):
			visited_wall_neightboors += 1
	return visited_wall_neightboors == 1


func is_cell_visited(cell_to_check)->bool:
	for cell in visited_cells:
		if cell.x == cell_to_check.x and cell.y == cell_to_check.y:
			return true
	return false


func get_neigtboor_walls(cell)->Array:
	var current_neightboors = []
	if cell.x - 1 >= 0 and cell.y >= 0 and cell.y <= height:
		current_neightboors.append(Vector2(cell.x - 1, cell.y))
	if cell.x >= 0 and cell.x <= width and cell.y - 1 >= 0:
		current_neightboors.append(Vector2(cell.x, cell.y - 1))
	if cell.x + 1 <= width and cell.y >= 0 and cell.y <= height:
		current_neightboors.append(Vector2(cell.x + 1, cell.y))
	if cell.x >= 0 and cell.x <= width and cell.y + 1 <= height:
		current_neightboors.append(Vector2(cell.x, cell.y + 1))
	var neighboor_walls = HelperFunctions.filter(funcref(self, "is_wall"), current_neightboors)
	return neighboor_walls


func get_neigtboor_cells(cell)->Array:
	var current_neightboors = []
	if cell.x - 1 >= 0 and cell.y >= 0 and cell.y <= height:
		current_neightboors.append(Vector2(cell.x - 1, cell.y))
	if cell.x >= 0 and cell.x <= width and cell.y - 1 >= 0:
		current_neightboors.append(Vector2(cell.x, cell.y - 1))
	if cell.x + 1 <= width and cell.y >= 0 and cell.y <= height:
		current_neightboors.append(Vector2(cell.x + 1, cell.y))
	if cell.x >= 0 and cell.x <= width and cell.y + 1 <= height:
		current_neightboors.append(Vector2(cell.x, cell.y + 1))
	return current_neightboors


func is_wall(cell)->bool:
	for visited_cell in visited_cells:
		if visited_cell.x == cell.x and visited_cell.y == cell.y:
			return false
	return true