extends CharacterBody2D

@export var speed = 5000
@onready var screen_size = get_viewport_rect().size
@export var score = 0

var dir : float
var spawnPos : Vector2
var spawnRot : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass

func _physics_process(delta):
	delta = delta
	screen_wrap()
	move_and_collide(velocity)




	
func _process(delta: float) -> void:
	
	var collition = move_and_collide(velocity * delta)
	
	
	if collition:
		if collition.get_collider().has_method("astroid"):
			#print("ASTROID")
			get_tree().get_root().get_node("Main").kill_astroid(collition)
			queue_free()
		else:
			pass

func _on_kill_timeout() -> void:
	queue_free()

func screen_wrap():
	position.x = wrapf(position.x, 0 - $CollisionShape2D.shape.get_rect().size.x, screen_size.x + $CollisionShape2D.shape.get_rect().size.x)
	position.y = wrapf(position.y, 0 - $CollisionShape2D.shape.get_rect().size.y, screen_size.y + $CollisionShape2D.shape.get_rect().size.y)
