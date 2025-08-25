extends Control

@export var spaceship_scene : PackedScene
@export var bullet : PackedScene
var astroid_scene = preload("res://scenes/astroid.tscn")
var spaceship
@export var score = 0
var astroid = astroid_scene.instantiate()
const SPEED = 600
var level = 0
var lives = 3

var astroids = []
var number_of_astroids = 1


var q = false
var w = false
var e = false
var r = false
var t = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	$Spaceship_2/CollisionShape2D2.disabled = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$HUD/game_over.visible = false
	var width = get_viewport_rect().size.x
	var height = get_viewport_rect().size.y
	$HUD/bakgrunn.size.x = width
	$HUD/bakgrunn.size.y = height
	#newgame()
	
	
	
func _process(delta):
	
	spaceship = spaceship_scene.instantiate()
	if Input.is_action_just_pressed("start"):
		$HUD._on_start_pressed()
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().reload_current_scene()
		
	if q:
		
		if !w && Input.is_action_just_pressed("up"):
			$HUD/tutorial/ad.visible = true
			$HUD/tutorial/w.visible = false
			w = true
		if w == true && Input.is_action_just_pressed("rotate"):
			$HUD/tutorial/ad.visible = false
			$HUD/tutorial/space.visible = true
			e = true
		if !r && e && Input.is_action_just_pressed("shoot"):
			$HUD/tutorial/space.visible = false
			$HUD/tutorial/arrows.visible = true
			r = true
			
		if r && Input.is_action_just_pressed("arrows"):
			$HUD/tutorial/arrows.visible = false
			q = false
			$HUD.tutorial = true
			$asteroids.add_child(astroid)
			await get_tree().create_timer(2.5).timeout
			$HUD/tutorial/shoot.visible = false
		if !q:
			$HUD/tutorial/w.visible = false
			$HUD/tutorial/ad.visible = false
			$HUD/tutorial/space.visible = false
			$HUD/tutorial/arrows.visible = false
			$HUD/tutorial/shoot.visible = false
			pass
	delta = delta
	


func spawnA():
	
	for n in number_of_astroids:
		astroid = astroid_scene.instantiate()
		astroids.append(astroid)
		$asteroids.add_child(astroid)
	
	number_of_astroids += 1
		
		
		#print("COLLISION ", astroid.collision_mask)
		#print(n)
		#print(num_astroids)

func kill_astroid(collision):
	
	$rock.play()
	if lives >= 0:
		$HUD.lives(lives)
		
	astroids.erase(collision.get_collider())
	var temp_astroid = collision.get_collider()

	
	if temp_astroid.scale > Vector2(5, 5):
		if $HUD.tutorial == false:
			$HUD.update_score(score)
			score += 1
		for n in 2:
			
			#print("score: ", score)
			astroid = astroid_scene.instantiate()
			astroid.scale = Vector2(5, 5)
			$asteroids.add_child(astroid)
			astroid.position = temp_astroid.position
			astroids.append(astroid)
			
	elif temp_astroid.scale > Vector2(3, 3):
		
		if $HUD.tutorial == false:
			$HUD.update_score(score)
			score += 1
			
		for n in 2:
			#print("score: ", score)
			
			astroid = astroid_scene.instantiate()
			astroid.scale = Vector2(3, 3)
			$asteroids.add_child(astroid)
			astroid.position = temp_astroid.position
			astroids.append(astroid)
		
	
	else:
		if $HUD.tutorial == false:
			score += 2
			$HUD.update_score(score)
		#print("score: ", score)
		if astroids.is_empty() && $HUD.tutorial == false:
			newlevel()
		
		if astroids.is_empty() && $HUD.tutorial == true:
			$HUD/ASTEROIDS.visible = true
			$HUD/start.visible = true
			$HUD/hiscore.visible = true
			$HUD/tutorial/tutorial_trigger.visible = true
			$HUD.tutorial = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			#print($HUD.tutorial)
			
		
	collision.get_collider().queue_free()
	
	

	
func newlevel():
	level += 1
	#print("level: ", level)
	$HUD.update_level(level)
	$HUD.lives(lives)
	spawnA()
	$Spaceship_2/CollisionShape2D2.disabled = true
	await get_tree().create_timer(1).timeout
	$Spaceship_2/CollisionShape2D2.disabled = false
	#spaceship = spaceship_scene.instantiate()
	#spaceship.name = "spaceship"
	#add_child(spaceship)
	
	



func _on_spaceship_2_hit() -> void:
	lives -= 1
	$HUD.lives(lives)
	

func _on_hud_gameover() -> void:
	$Spaceship_2.move_to_spawn = false
	newgame()
	#get_tree().reload_current_scene()


func newgame():
	$HUD.update_score(0)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Spaceship_2.position = get_viewport_rect().size / 2
	$Spaceship_2/CollisionShape2D2.disabled = true
	$Spaceship_2.move_to_spawn = false
	#$Spaceship_2.position = get_viewport_rect().size / 2
	lives = 3
	level = 1
	$HUD.lives(lives)
	number_of_astroids = 1
	level = 0
	score = 0
	$HUD/score.visible = false
	$HUD/lives.visible = false
	$HUD/level.visible = false
	$HUD/ASTEROIDS.visible = true
	$HUD/hiscore.visible = true
	$HUD/start.visible = true
	$HUD/game_over.visible = false
	$HUD/tutorial/tutorial_trigger.visible = true
	#print("NICE " + str($HUD.tutorial))
	
	astroids.clear()
	for n in $asteroids.get_children():
		$asteroids.remove_child(n)
		n.queue_free()

func _on_hud_start_game() -> void:
	#print("OK " + str($HUD.tutorial))
	$Spaceship_2/CollisionShape2D2.disabled = false
	astroids.clear()
	for n in $asteroids.get_children():
		$asteroids.remove_child(n)
		n.queue_free()
	
	$HUD/tutorial/tutorial_trigger.visible = false
	newlevel()
	$Spaceship_2.position = get_viewport_rect().size / 2
	#$Spaceship_2.get_node("CollisionShape2D2").disabled = true
	$Spaceship_2.velocity = Vector2(0, 0)
	$Spaceship_2.rotation = 0
	
	
	



func _on_hud_tutorial_button() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Spaceship_2.position = get_viewport_rect().size / 2
	$Spaceship_2.velocity = Vector2.ZERO
	$Spaceship_2.rotation = 0
	$HUD/ASTEROIDS.visible = false
	$HUD/start.visible = false
	$HUD/hiscore.visible = false
	$HUD/tutorial/tutorial_trigger.visible = false
	$HUD/tutorial/w.visible = true
	q = true
	
	
