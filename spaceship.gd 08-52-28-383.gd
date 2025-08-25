extends Area2D

signal shoot

@export var speed = 400 
@onready var main = get_tree().get_root().get_node("main")
@onready var projectile = load("res://bullet.tscn")
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	skudd()

func	 skudd():
	var instance =projectile.instantiate()
	instance.dir = rotation
	instance.spawnPos = global_position
	instance.spawnRot = rotation
	main.add_child.call_deferred(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("right"):
		#velocity.x += 1
		rotate(0.08)
	if Input.is_action_pressed("left"):
		#velocity.x -= 1
		rotate(-0.08)
	if Input.is_action_pressed("up"):
		velocity = Vector2(0, -1).rotated(rotation) * speed * delta
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	
		#if Input.is_action_pressed("shoot"):
			
			
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
