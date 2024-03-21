extends CharacterBody2D

var viewport_size = Vector2(1152, 648)

# Define the boundaries within which the player can move
var min_position = Vector2()
var max_position = viewport_size

func _ready():
	# Set the player's initial position to the center of the viewport
	position = viewport_size / 2
	
func _physics_process(delta):
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") *150
	move_and_slide()
	position.x = clamp(position.x, min_position.x, max_position.x - 52)
	position.y = clamp(position.y, min_position.y, max_position.y - 58)
