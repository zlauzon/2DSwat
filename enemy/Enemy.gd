extends RigidBody2D


export(PackedScene) var WEAPON_SCENE
var _target = null
var _weapon
var _health
var _rootNode


# Called when the node enters the scene tree for the first time.
func _ready():
	_health = 100
	_weapon = WEAPON_SCENE.instance()
	_weapon.setWeaponSmg()
	#_weapon.set2DPositions($Muzzle, $GunPort)
	add_child(_weapon)
	_rootNode = get_tree().get_root().get_node("Main")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if _target == null:
		_target = getNearestEnemies()
	else:
		look_at(_target.global_position)
		#if _weapon.shoot():
		#	velocity -= transform.x * _weapon.getKnockBack()
			
	position += velocity * delta
	#position.x = clamp(position.x, 0, SCREEN_SIZE.x)
	#position.y = clamp(position.y, 0, SCREEN_SIZE.y)

func setHealth(health):
	_health = health
	
func getHealth():
	return _health

func getNearestEnemies():
	var nearestGood = get_tree().get_nodes_in_group("good")[0]
	
	for good in get_tree().get_nodes_in_group("good"):
		if good.global_position.distance_to(global_position) < nearestGood.global_position.distance_to(global_position):
			nearestGood = good
	return nearestGood

func hurt(dmg):
	if ((getHealth() - dmg) <= 0):
		queue_free()
	setHealth(getHealth() - dmg)

func _on_Enemy_body_entered(body):
	print("body entered!")
	if body.is_in_group("projectile"):
		hurt(body.getDamage())
