extends StaticBody2D

const SPEED = 600
@onready var screen_size = get_viewport_rect().size
@onready var screen_sizex = get_viewport_rect().size
@onready var screen_sizey = get_viewport_rect().size

var rotation_speed

var random_rot 

var speed_v

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	var dir = randi() % 4
	rotation_speed = randf_range(-3, 3)
	screen_sizey = get_viewport_rect().size.y
	screen_sizex = get_viewport_rect().size.x
	random_rot = randf_range(0, 0.05)
	
	#print("Asteroid Layer:", collision_layer)
	#print("Asteroid Mask:", collision_mask)
	
	if dir == 1:
		#print("Top")
		############## Position ###############
		position.y = 0
		position.x = randi_range(0, screen_sizex)
		############## Velocity ###############
	elif dir == 2:
		#print("Left")
		############## Position ###############
		position.y = randi_range(0, screen_sizey)
		position.x = 0
		############## Velocity ###############
	elif dir == 3:
		#print("Bottom")
		############## Position ###############
		position.y = screen_sizey
		position.x = randi_range(0, screen_sizex)
		############## Velocity ###############
	else:
		#print("Right")
		############## Position ###############
		position.x = screen_sizex
		position.y = randi_range(0, screen_sizey)
		############## Velocity ###############
		
		
	rotation_degrees = randi() % 360
	speed_v = Vector2(0, 1).rotated(rotation)*(randi_range(2, 8))
	#position += speed_v
	
func _physics_process(delta):
	delta = delta
	screen_wrap()
	
	
func _process(delta: float) -> void:
	delta = delta
	position += speed_v
	screen_wrap()
	rotate(random_rot)
	
	

func astroid():
	pass

func screen_wrap():
	position.x = wrapf(position.x, 0 - $CollisionShape2D.shape.get_rect().size.x, screen_size.x + $CollisionShape2D.shape.get_rect().size.x)
	position.y = wrapf(position.y, 0 - $CollisionShape2D.shape.get_rect().size.y, screen_size.y + $CollisionShape2D.shape.get_rect().size.y)
