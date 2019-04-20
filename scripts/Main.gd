extends Node2D

signal on_time_tick

var tile_map
var next_map : TileMap

const grid_size = Vector2(64, 40)

export var random_population : int = 50
var MAX_POPULATION : int

var continuous_mode = false

func _ready():
	tile_map = $Grid/TileMap

	next_map = TileMap.new()
	next_map.tile_set = load('res://cell-tileset.tres')

	connect('on_time_tick', self, '_on_time_tick')

	randomize()
	MAX_POPULATION = grid_size.x * grid_size.y
	assert(random_population <= MAX_POPULATION)

var cell_dir = {
		'top': Vector2(0, -1),
		'bottom': Vector2(0, 1),
		'left': Vector2(-1, 0),
		'right': Vector2(1, 0),
		'topleft': Vector2(-1, -1),
		'topright': Vector2(1, -1),
		'bottomleft': Vector2(-1, 1),
		'bottomright': Vector2(1, 1)
	}

func _generate_random_map(population):
	for i in range(0, population):
		var x = randi() % int(grid_size.x)
		var y = randi() % int(grid_size.y)
		var new_position = Vector2(x, y)
		tile_map.set_cellv(new_position, 0)

func _process(delta):
	if continuous_mode == true:
		emit_signal('on_time_tick')

func _input(event):
	if event.is_pressed():
		if event.is_action('regenerate map'):
			_generate_random_map(random_population)

		if event.is_action('clear map'):
			tile_map.clear()

		if event.is_action('next step') and continuous_mode == false:
			emit_signal('on_time_tick')
			
		if event.is_action('toggle continuous'):
			continuous_mode = !continuous_mode
				
func _on_time_tick():
	var neighbors : int = 0
	var cell_at_position : Vector2
	var cell_type : int

	for x in range(0, grid_size.x):
		for y in range(0, grid_size.y):
			cell_at_position = Vector2(x, y)
			neighbors = get_neighbor_count(cell_at_position)
			cell_type = tile_map.get_cellv(cell_at_position)

			if cell_type == -1:
				if neighbors == 3:
					next_map.set_cellv(cell_at_position, 0)
			if cell_type != -1:
				next_map.set_cellv(cell_at_position, 0)
				if neighbors < 2 or neighbors > 3:
					next_map.set_cellv(cell_at_position, -1)

	set_map(next_map)
	next_map.clear()

func set_map(map : TileMap):
	var cell_at_position
	for x in range(0, grid_size.x):
		for y in range(0, grid_size.y):
			cell_at_position = Vector2(x, y)
			tile_map.set_cellv(cell_at_position, map.get_cellv(cell_at_position))

func get_neighbor_count(cell_at_position : Vector2) -> int:
	var neighbor_count = 0
	var current_neighbor_cell = Vector2()

	for cell in cell_dir.keys():
		current_neighbor_cell = cell_at_position + cell_dir[cell]
		if tile_map.get_cellv(current_neighbor_cell) != -1:
			neighbor_count += 1

	return neighbor_count
