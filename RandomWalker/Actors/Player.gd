extends "Actor.gd"


const TIME_DEATH := 0.2

@onready var danger_detector: Area2D = $DangerDetector
@onready var animate_sprite : AnimatedSprite2D = $AnimatedSprite2D


func _on_DangerDetector_body_entered(_body: Node) -> void:
	set_physics_process(false)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, TIME_DEATH)
	tween.tween_callback(queue_free)
	get_tree().reload_current_scene()


func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += 3500 * _delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -speed.y

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed.x
	if direction != 0:
		animate_sprite.flip_h = (direction ==  -1)
	else:
		velocity.x = move_toward(velocity.x, 0, speed.x)
	move_and_slide()
	update_animations(direction)

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			animate_sprite.play("idle")
		else:
			animate_sprite.play("run")
	else:
		if velocity.y < 0:
			animate_sprite.play("jump")
		else:
			animate_sprite.play("fall")
	
