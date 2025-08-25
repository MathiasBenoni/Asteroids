extends ParallaxBackground

var main = preload("res://scenes/main.tscn")


var a = false
var b = false
var c = false
signal start_game
signal ship_ready

signal tutorial_button

var local_score = 0
var hiscore = 0

var tutorial = false

signal gameover

func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta = delta
	pass

func update_score(score):
	if tutorial == false:
	
		local_score = score
		
		if score > hiscore:
			$hiscore.text = "Highscore: " + str(score)
			hiscore = score

		$score.text = "Score: " + str(score)
		$SCORE.text = "Score: " + str(score)
	
	
	
	
func update_level(level):
	if tutorial == false:
		$levelup.play()
		$level.text = "Level: " + str(level)
		$LEVEL.text = "Level: " + str(level)
		$level_timer.start()
		$LEVEL.visible = true
	

	
func lives(lives):
	if tutorial == false:
		if lives <= 0:
			gameOver()
			
		$lives.text = "Lives: " + str(lives)


func gameOver():
	$score.text = "Score: " + str(local_score)
	$gameOver.play()
	print("GAME OVER!!!")
	$game_over.visible = true
	$SCORE.visible = true
	$game_over_timer.start()
	

func _on_game_over_timer_timeout() -> void:
	emit_signal("gameover")
	$SCORE.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _on_start_pressed() -> void:
	tutorial = false
	$click.play()
	$score.visible = true
	$SCORE.text = "Score: 0"
	$start.visible = false
	$level.visible = true
	$lives.visible = true
	$hiscore.visible = false
	emit_signal("start_game")
	$ASTEROIDS.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	

func _on_level_timer_timeout() -> void:
	$LEVEL.visible = false
	


func _on_tutorial_trigger_pressed() -> void:
	emit_signal("tutorial_button")
