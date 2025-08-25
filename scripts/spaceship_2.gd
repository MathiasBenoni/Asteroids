extends CharacterBody2D


@export var speed = 1000
var dead_speed = 450
var speed_bullet = 30
@onready var screen_size = get_viewport_rect().size
@onready var main = get_tree().get_root().get_node("Main")
#@onready var projectile = load("res://bullet.tscn")
@export var direction = Vector2.ZERO
@export var bullet_scene : PackedScene
var cool_canon = true
var rot = 4.5
var is_alive = true
var spawn
signal hit
var move_to_spawn = false
var iframes = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	spawn = screen_size / 2
	$AnimatedSprite2D2.play("ship")
	
	#print("Direction:", direction)
	#print("Direction in bullet.gd:", direction)
	set_position(spawn)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if move_to_spawn == true:
		$CollisionShape2D2.disabled = true
		$AnimatedSprite2D2.play("i_frames")
		velocity = Vector2.ZERO
		position = position.move_toward(spawn, delta * dead_speed)
		rotation = rotate_toward(rotation, 0, 1)
		#get_node("CollisionShape2D2").disabled = false
		#$AnimatedSprite2D2.play("idle")
		if position == spawn:
			rotation = 0
			move_to_spawn = false
			iframes = true
			$sound/no.play()
			await get_tree().create_timer(1).timeout
			iframes = false
			$CollisionShape2D2.disabled = false
		
	if !is_alive:
		$CollisionShape2D2.disabled = true
	
	if is_alive && !move_to_spawn:
		#position += direction * delta
		#var velocity = Vector2.ZERO # The player's movement vector.
		if iframes:
			$AnimatedSprite2D2.play("i_frames")

		
		if Input.is_action_pressed("right"):
			#velocity.x += 1
			rotate(rot * delta)
		if Input.is_action_pressed("left"):
			#velocity.x -= 1
			rotate(-rot * delta)
		if Input.is_action_pressed("up"):
			velocity += Vector2(0, -1).rotated(rotation) * speed * delta
			velocity += velocity.normalized()
			
			#print(velocity)
			$AnimatedSprite2D2.play("ship")
		elif !iframes:
			$sound/rocket.play()
			$AnimatedSprite2D2.play("idle")
			velocity -= velocity.normalized()*2.5
	
	
		#position.x = wrapf(position.x, 0-$CollisionShape2D2.shape.height, screen_size.x+$CollisionShape2D2.shape.height)
		#position.y = wrapf(position.y, 0-$CollisionShape2D2.shape.height, screen_size.y+$CollisionShape2D2.shape.height)	

		if Input.is_action_pressed("shoot"):
			if cool_canon:
				$sound/Shoot.play()
				$Cooldown.start()
				cool_canon = false
				var bullet = bullet_scene.instantiate()
				main.add_child(bullet)
				bullet.name = "bullet"
				bullet.rotation = rotation
				bullet.position = position
				#print(bullet.position)
				#print(position)
				bullet.velocity = speed_bullet * Vector2(0, -1).rotated(rotation).normalized()
				velocity -= bullet.velocity * 5
				
				
				#print(velocity)
	

	var collition = move_and_collide(velocity * delta)
	
	if collition:
		#print("COLLISION")
		if collition.get_collider().has_method("astroid"):
			emit_signal("hit")
			$sound/Die.play()
			$AnimatedSprite2D2.play("i_frames")
			if main.lives == 0:
				pass
			#print("GAME OVER")
			
			if position == spawn:
				$CollisionShape2D2.disabled = true
				$AnimatedSprite2D2.play("i_frames")
				await get_tree().create_timer(1).timeout
				$CollisionShape2D2.disabled = false
				$AnimatedSprite2D2.play("idle")
			else:
				move_to_spawn = true
			
			#velocity = Vector2(0, -1).rotated(screen_widht / 2).normalized() * speed
		

	#position = position.clamp(Vector2.ZERO, screen_size)
	screen_wrap()
	
	
	
	
func start(pos):
	position = pos
	show()
	#print("hit")
	


func _on_cooldown_timeout() -> void:
	cool_canon = true
	
func screen_wrap():
	position.x = wrapf(position.x, 0 - $CollisionShape2D2.shape.get_rect().size.x, screen_size.x + $CollisionShape2D2.shape.get_rect().size.x)
	position.y = wrapf(position.y, 0 - $CollisionShape2D2.shape.get_rect().size.y, screen_size.y + $CollisionShape2D2.shape.get_rect().size.y)


func _on_hud_ship_ready() -> void:
	velocity = Vector2(0, 0)
	rotation = 0
	set_position(screen_size / 2)
	
