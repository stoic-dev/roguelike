class_name Player
extends CharacterBody2D

@export var tile_size: int = 48
@onready var sprite: Sprite2D = $PlayerSprite
@onready var camera: Camera2D = $Camera2D

var movement_directions = {
	"move_left": Vector2.LEFT,
	"move_right": Vector2.RIGHT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}

var zoom_modifiers = {
	"zoom_in": 1,
	"zoom_out": -1
}

func _unhandled_input(event: InputEvent) -> void:
	var action = get_action_from_event(event)
	
	if not action:
		return
		
	if action.begins_with("zoom_"):
		handle_zoom(action)

func _unhandled_key_input(event: InputEvent) -> void:
	var action = get_action_from_event(event)
	
	if not action:
		return
	
	if action.begins_with("move_"):
		handle_movement_action(action)

func does_collide_with_wall(direction: Vector2) -> bool:
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(tile_size, tile_size) * direction)
	var result = PhysicsServer2D.space_get_direct_state(get_world_2d().space).intersect_ray(query)
	return result and result.collider.is_in_group("Wall")
	
func get_action_from_event(event: InputEvent):
	for action in InputMap.get_actions():
		if (event.is_action_pressed(action)):
			return action
	return null
	
func get_movement_direction_vector(action: String) -> Vector2:
	if not movement_directions.has(action):
		return Vector2.ZERO
	return movement_directions.get(action)
	
func handle_movement_action(action: String) -> void:
	var movement_direction = get_movement_direction_vector(action)
	flip_sprite_based_on_movement(action)
	if does_collide_with_wall(movement_direction):
		return
	velocity = movement_direction
	position += tile_size * velocity
	
func flip_sprite_based_on_movement(action) -> void:
	if action == "move_up" or action == "move_down":
		return
	if action == "move_left":
		sprite.flip_h = true
		return
	if action == "move_right":
		sprite.flip_h = false
		return

func handle_zoom(action: String) -> void:
	var zoom_step: float = 0.1 * zoom_modifiers.get(action)
	var zoom_vector = Vector2(zoom_step, zoom_step)
	if camera.zoom + zoom_vector < zoom_vector.abs():
		camera.zoom = zoom_vector.abs()
	else:
		camera.zoom += zoom_vector
