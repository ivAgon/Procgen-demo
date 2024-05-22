extends "Actor.gd"


var _inital_speed: float = 200
var _direction: float = 1.0

@onready var visibility_enabler: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D


func _ready() -> void:
	visibility_enabler.screen_entered.connect(set_physics_process.bind(true))
	visibility_enabler.screen_exited.connect(set_physics_process.bind(false))
	set_physics_process(false)
	velocity.x = _inital_speed
	velocity.y = 0.0
	add_to_group("Player")


func _physics_process(_delta: float) -> void:
	if is_on_wall():
		_direction *= -1
	velocity.x = _inital_speed * _direction
	if not is_on_floor():
		velocity.y += 3500 * _delta

	move_and_slide()


func _on_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
