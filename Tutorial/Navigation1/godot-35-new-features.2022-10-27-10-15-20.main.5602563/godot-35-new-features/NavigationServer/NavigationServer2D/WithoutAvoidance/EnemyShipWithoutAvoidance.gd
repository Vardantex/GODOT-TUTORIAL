extends KinematicBody2D

export var path_to_player := NodePath()

var _velocity := Vector2.ZERO

onready var _agent: NavigationAgent2D = $NavigationAgent2D
onready var _timer := $Timer
onready var _sprite := $Sprite

onready var _player := get_node(path_to_player)


func _ready() -> void:
	_timer.connect("timeout", self, "_update_pathfinding")


func _physics_process(delta: float) -> void:
	if _agent.is_navigation_finished():
		return

	var target_global_position := _agent.get_next_location()
	var direction := global_position.direction_to(target_global_position)

	var desired_velocity := direction * _agent.max_speed
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering

	_velocity = move_and_slide(_velocity)
	_sprite.rotation = lerp_angle(_sprite.rotation, _velocity.angle(), 10.0 * delta)
	

func _update_pathfinding() -> void:
	_agent.set_target_location(_player.global_position)
