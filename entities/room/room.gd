class_name Room
extends Node2D

@export var dimensions: Vector2i
@export var should_draw_floor: bool = false
@export var should_have_doors: bool = true
var center: Vector2
var door_count: int = 0

@onready var wall_layer: TileMapLayer = $Walls
@onready var floor_layer: TileMapLayer = $Floor

var tile_set = preload("res://resources/tile-set.tres")
var tile_atlas_coordinates = preload("res://resources/tile-atlas-coordinates/tile-atlas-coordinates.tres")

func _ready() -> void:
	draw_room()
	scale = Vector2(3,3)
	
func draw_room() -> void:
	draw_top_and_bottom_walls()
	draw_left_and_right_walls()
	draw_doors()
	draw_corners()
	if should_draw_floor:
		draw_floor()
	
func draw_top_and_bottom_walls() -> void:
	for i in range(1, dimensions.x):
		wall_layer.set_cell(Vector2i(i, 0), 0, tile_atlas_coordinates.dungeon_top_wall)
		wall_layer.set_cell(Vector2i(i, dimensions.y), 0, tile_atlas_coordinates.dungeon_bottom_wall)
		
func draw_left_and_right_walls() -> void:
	for i in range(1, dimensions.y):
		wall_layer.set_cell(Vector2i(0, i), 0, tile_atlas_coordinates.dungeon_left_wall)
		wall_layer.set_cell(Vector2i(dimensions.x, i), 0, tile_atlas_coordinates.dungeon_right_wall)
		
func draw_corners() -> void:
	wall_layer.set_cell(Vector2i(0,0), 0, tile_atlas_coordinates.dungeon_top_left_corner_wall)
	wall_layer.set_cell(Vector2i(0,dimensions.y), 0, tile_atlas_coordinates.dungeon_bottom_left_corner_wall)
	wall_layer.set_cell(Vector2i(dimensions.x,0), 0, tile_atlas_coordinates.dungeon_top_right_corner_wall)
	wall_layer.set_cell(dimensions, 0, tile_atlas_coordinates.dungeon_bottom_right_corner_wall)
	
func draw_floor() -> void:
	for x in range(1, dimensions.x):
		for y in range(1, dimensions.y):
			floor_layer.set_cell(Vector2i(x, y), 0, tile_atlas_coordinates.dungeon_floor)
			
func get_center_coordinates() -> Vector2:
	var tile_size: Vector2 = Vector2(tile_set.tile_size) * scale
	return position + Vector2(floor(float(dimensions.x) / 2) * tile_size.x, floor(float(dimensions.y) / 2) * tile_size.y)
	
func get_rect() -> Rect2i:
	var tile_size: Vector2i = Vector2i(tile_set.tile_size) * Vector2i(3 , 3)
	return Rect2i(position, dimensions * tile_size)
	
func draw_doors() -> void:
	if not should_have_doors or door_count == 4:
		return
	var doors_to_draw: int = randi_range(1, 4)
	var top_wall_coordinates = range(1, dimensions.x).map(func(i: int) -> Vector2i: return Vector2i(i, 0))
	var bottom_wall_coordinates = range(1, dimensions.x).map(func(i: int) -> Vector2i: return Vector2i(i, dimensions.y))
	var left_wall_coordinates = range(1, dimensions.y).map(func(i: int) -> Vector2i: return Vector2i(0, i))
	var right_wall_coordinates = range(1, dimensions.y).map(func(i: int) -> Vector2i: return Vector2i(dimensions.x, i))
	
	var walls = [1, 2, 3, 4]
	
	while door_count < doors_to_draw:
		var wall_id = randi_range(0, walls.size() - 1)
		var wall = walls[wall_id]
		match wall:
			1:
				if top_wall_coordinates.size() != 0:
					wall_layer.set_cell(top_wall_coordinates[randi_range(0, top_wall_coordinates.size() - 1)])
			2:
				if bottom_wall_coordinates.size() != 0:
					wall_layer.set_cell(bottom_wall_coordinates[randi_range(0, bottom_wall_coordinates.size() - 1)])
			3:
				if left_wall_coordinates.size() != 0:
					wall_layer.set_cell(left_wall_coordinates[randi_range(0, left_wall_coordinates.size() - 1)])
			4:
				if right_wall_coordinates.size() != 0:
					wall_layer.set_cell(right_wall_coordinates[randi_range(0, right_wall_coordinates.size() - 1)])
		walls.remove_at(wall_id)
		door_count += 1
		
