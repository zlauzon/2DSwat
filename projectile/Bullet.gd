extends Area2D

export(PackedScene) var BLOODLIGHT_SCENE
var _speed = 1500
var _damage = 0
var _rootNode

func _ready():
	_rootNode = get_tree().get_root().get_node("Main")
	$AnimatedSprite.playing = true

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	position += transform.x * _speed * delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getDamage():
	return _damage
	
func setDamage(damage):
	_damage = damage

func _on_Bullet_body_entered(body):
	if body.is_in_group("bad"):
		body.hurt(_damage)
		var bloodLight = BLOODLIGHT_SCENE.instance()
		bloodLight.rotation = rotation
		bloodLight.position = body.position
		_rootNode.add_child(bloodLight)
		queue_free()
	#queue_free()

func _on_Life_timeout():
	queue_free()
