extends CharacterBody2D

	
func _physics_process(delta):
	velocity = Vector2(0,Input.get_axis("ui_up", "ui_down")) *300
	move_and_slide()
