extends Area2D

signal hit

export(PackedScene) var WEAPON_SCENE
export(PackedScene) var RELOADING_SCENE
export var speed = 400
export var aimSpeedModifier = 0.5
export var health = 100

# Players states:
# MOVING
# AIMING
# DEAD
var state = "MOVING"
var SCREEN_SIZE
var weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	#SCREEN_SIZE = get_viewport_rect().size
	weapon = WEAPON_SCENE.instance()
	weapon.setWeaponSmg()
	add_child(weapon)
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("right_click"):
		state = "AIMING"
	else:
		state = "MOVING"
	if Input.is_action_pressed("left_click") && (state == "AIMING"):
		if weapon.shoot():
			$Camera2D.add_trauma(weapon.getRecoil())
	
	if velocity.length() > 0:
		if (state == "MOVING"):
			velocity = velocity.normalized() * speed
		elif (state == "AIMING"):
			velocity = velocity.normalized() * (speed*aimSpeedModifier)
		
	position += velocity * delta
	#position.x = clamp(position.x, 0, SCREEN_SIZE.x)
	#position.y = clamp(position.y, 0, SCREEN_SIZE.y)
	
	#look_at(get_global_mouse_position())
	rotateHead(delta)
	rotateTorso(delta)
	
	#weapon.set_rotation($WeaponPos.get_rotation())
	#weapon.set_position($WeaponPos.get_position())
	weapon.transform = $WeaponPos.transform
	
#	if velocity.x != 0:
#		$AnimatedSprite.animation = "walk"
#		$AnimatedSprite.flip_v = false
#		$AnimatedSprite.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func rotateHead(delta):
	var turnRate = .05
	var minAngle = $HeadSprite.rotation + rotation
	var maxAngle = position.angle_to_point(get_global_mouse_position()) - PI
	var headAngle = lerp_angle(minAngle, maxAngle, turnRate) - rotation
	$HeadSprite.rotation = clamp(headAngle, -PI/4, PI/4)
	turnRate += delta

func rotateTorso(delta):
	var turnRate = 0.02
	var minAngle = rotation
	var maxAngle = position.angle_to_point(get_global_mouse_position()) - PI
	var torsoAngle = lerp_angle(minAngle, maxAngle, turnRate)
	
	rotation = torsoAngle
	#rotateWeaponPos(torsoAngle)
	turnRate += delta

func rotateWeaponPos(rotation):
	$WeaponPos.rotation = rotation
