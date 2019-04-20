extends Control

var tile_map
var ui_map
var grid_input_enabled = true

func _ready():
	tile_map = $TileMap
	ui_map = $UITileMap
	
	connect('mouse_entered', self, '_on_mouse_entered')
	connect('mouse_exited', self, '_on_mouse_exited')

func _input(event):
	if grid_input_enabled == true:
		if event is InputEventMouseMotion:
			ui_map.clear()
			ui_map.set_cellv(ui_map.world_to_map(ui_map.get_local_mouse_position()), 0)

func _process(delta):
	if grid_input_enabled == true:
		var highlighted_cell = tile_map.world_to_map(tile_map.get_local_mouse_position())
	
		if Input.is_action_pressed('add cell'):
			tile_map.set_cellv(highlighted_cell, 0)
	
		if Input.is_action_pressed('remove cell'):
			tile_map.set_cellv(highlighted_cell, -1)
		
func _on_mouse_entered():
	grid_input_enabled = true
	
func _on_mouse_exited():
	grid_input_enabled = false
