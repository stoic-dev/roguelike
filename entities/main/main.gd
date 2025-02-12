extends Node

var player_scene: PackedScene = preload("res://entities/player/player.tscn")
var room_scene: PackedScene = preload("res://entities/room/room.tscn")
var tile_set: TileSet = preload("res://resources/tile-set.tres")
var tile_atlas_coordinates: TileAtlasCoordinates = TileAtlasCoordinates.new()

@export var tile_size: int = 48
@export var max_room_count: int = 6
@export var min_room_count: int = 3
@export var max_dungeon_size: int = 3200
@export var min_dungeon_size: int = 2400
@export var min_room_size: int = 5

var random_dungeon_size = randi_range(min_dungeon_size, max_dungeon_size)
var dungeon_size = random_dungeon_size - (random_dungeon_size % tile_size)
var dungeon_room_count = randi_range(min_room_count, max_room_count)

var rooms = []

func _ready() -> void:
	var root_node = BSPNode.new(null, Vector2i.ZERO, Vector2i(dungeon_size, dungeon_size))
	var root_room = create_room(Vector2i(-4 * tile_size, -4 * tile_size), Vector2i((dungeon_size / tile_size) + 4, (dungeon_size / tile_size) + 4))
	root_room.should_draw_floor = true
	root_room.should_have_doors = false
	add_child(root_room)
	root_node.partition(2)
	for node in root_node.get_leaves():
		rooms.append(spawn_room_in_region(node.position, node.size))
	
	spawn_player(get_smallest_room())
	
func spawn_player(room: Room) -> Player:
	var player_instance: Player = player_scene.instantiate()
	player_instance.position = room.get_center_coordinates() + Vector2(24, 24)
	add_child(player_instance)
	return player_instance
	
func create_room(position: Vector2i, dimensions: Vector2i) -> Room:
	var room_instance: Room = room_scene.instantiate()
	room_instance.position = position
	room_instance.dimensions = dimensions
	return room_instance

func spawn_room_in_region(region_position: Vector2i, region_size: Vector2i) -> Room:
	var room = create_room(region_position + Vector2i(2, 2), Vector2i(floor(region_size.x / tile_size) - 4, floor(region_size.y / tile_size) - 4))
	add_child(room)
	return room

func get_biggest_room() -> Room:
	var room_areas = rooms.map(func(r: Room) -> float: return r.get_rect().get_area())
	return rooms[room_areas.find(room_areas.max())]

func get_smallest_room() -> Room:
	var room_areas = rooms.map(func(r: Room) -> float: return r.get_rect().get_area())
	return rooms[room_areas.find(room_areas.min())]
	
func is_tile_in_room(position: Vector2i):
	var tile = Rect2i(position, Vector2i(tile_size, tile_size))
	return rooms.any(func(r: Room) -> bool: return r.get_rect().intersects(tile))
	
