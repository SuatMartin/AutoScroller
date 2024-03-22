extends Node

var bird_scene = preload("res://Bird.tscn")
var obstacles : Array
var bird_heights := [100, 450]


const Player_Start_Pos := Vector2i(150, 300)
const Cam_Start_Pos :=  Vector2i(576,324)

var score : int
const SCORE_MOD : int = 10
var high_score : int
var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
const SPEED_MOD : int = 5000
var screen_size : Vector2i
var game_running : bool
var difficulty
const MAX_DIFFICULTY : int = 2
var last_obs
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()

func new_game():
	score = 0
	show_score()
	game_running = false
	get_tree().paused = false
	difficulty = 0
	
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	$Player.position = Player_Start_Pos
	$Player.velocity = Vector2(0,0)
	$Camera2D.position = Cam_Start_Pos
	$HUD.get_node("StartLabel").show()
	$GameOver.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		speed = START_SPEED + score / SPEED_MOD
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
			
		generate_obs()
		$Player.position.x += speed
		$Camera2D.position.x += speed
		score += speed
		show_score()
		
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score/ SCORE_MOD)
	
func check_high_score():
	if score > high_score:
		high_score = score
		$HUD.get_node("HighScoreLabel").text = "HIGH SCORE: " + str(high_score/ SCORE_MOD)

func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300,500):
		var obs
		var max_obs	 = difficulty + 1
		for i in range(randi() % max_obs + 1):
			obs = bird_scene.instantiate()
			last_obs = obs
			var obs_x : int = screen_size.x + score + 100 + (i * 100)
			var obs_y : int = bird_heights[randi() % bird_heights.size()]
			add_obs(obs, obs_x, obs_y)

func add_obs(obs, x, y):
	obs.position = Vector2i(x,y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
func hit_obs(body):
	if body.name == "Player":
		game_over()
	
func adjust_difficulty():
	difficulty = score / SPEED_MOD
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY
		
func game_over():
	check_high_score()
	get_tree().paused = true
	game_running = false
	$GameOver.show()
