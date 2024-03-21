extends Camera2D


var speed = 100.0

func _process(delta):
	# Move the camera forward along the Y-axis
	# Adjust the direction as per your scene setup
	var viewport_rect = get_viewport_rect()
	position.x += speed * delta
	
	
