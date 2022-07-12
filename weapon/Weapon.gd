extends KinematicBody2D

export(PackedScene) var BULLET_SCENE
export(PackedScene) var BULLETCASING_SCENE
export(PackedScene) var RELOADING_SCENE

var _rootNode

var _knockBack #How far in pixels the gun pushes you back
var _recoil #Higher recoil is worse (screen shake)
var _fireRate #Lower fire rate is faster
var _damage
var _accuracy #Higher accuracy is worse (bullet deviation from target)
var _magazineSize
var _weaponName
var _currentAmmo
var _state
var _canShove

var PARAM_STATE_LIVE = 0
var PARAM_STATE_RELOAD = 1
var PARAM_STATE_FIRE = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	$ShootTimer.wait_time = _fireRate
	_state = PARAM_STATE_LIVE
	_rootNode = get_tree().get_root().get_node("Main")
	_canShove = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getKnockBack():
	return _knockBack

func getRecoil():
	return _recoil

func getFireRate():
	return _fireRate

func getDamage():
	return _damage

func getAccuracy():
	return _accuracy

func getMagazineSize():
	return _magazineSize

func getWeaponName():
	return _weaponName
	
func getCurrentAmmo():
	return _currentAmmo
	
func getState():
	return _state
	
func canShove():
	return _canShove
	
func setKnockBack(knockBack):
	_knockBack = knockBack
	
func setRecoil(recoil):
	_recoil = recoil
	
func setFireRate(fireRate):
	_fireRate = fireRate
	
func setDamage(damage):
	_damage = damage
	
func setAccuracy(accuracy):
	_accuracy = accuracy
	
func setMagazineSize(magazineSize):
	_magazineSize = magazineSize
	
func setWeaponName(weaponName):
	_weaponName = weaponName
	
func setCurrentAmmo(currentAmmo):
	_currentAmmo = currentAmmo
	
func shoot():
	if ($ShootTimer.is_stopped() and getCurrentAmmo()):
		var bullet = BULLET_SCENE.instance()
		var bulletCasing = BULLETCASING_SCENE.instance()
		_rootNode.add_child(bullet)
		playGunshot()
		_rootNode.add_child(bulletCasing)
		bulletCasing.transform = $GunPort.global_transform
		bullet.transform = $Muzzle.global_transform
		bullet.rotation += deg2rad(rand_range(-getAccuracy(), getAccuracy()))
		bullet.setDamage(getDamage())
		setCurrentAmmo(getCurrentAmmo() - 1)
		$ShootTimer.start()
		return true
	else:
		if (!getCurrentAmmo()):
			reload()
		return false
		
func reload():
	if ($ReloadTimer.is_stopped()):
		$ReloadTimer.start()
		var reloading = RELOADING_SCENE.instance()
		_rootNode.add_child(reloading)
		reloading.set_position(get_parent().get_position())
		reloading.move_local_y(-64)
		reloading.move_local_x(32)
		_state = PARAM_STATE_RELOAD

func _on_ReloadTimer_timeout():
	setCurrentAmmo(getMagazineSize())
	_state = PARAM_STATE_LIVE
	
func playGunshot():
	#AudioStreamManager.play("res://assets/weapon/Gunshot_1.wav")
	pass

func setWeaponSmg():
	setKnockBack(1)
	setRecoil(.25)
	setFireRate(.067)
	setDamage(26)
	setAccuracy(10)
	setMagazineSize(30)
	setWeaponName("SMG")
	setCurrentAmmo(getMagazineSize())

func setWeaponRifle():
	setKnockBack(1)
	setRecoil(.3)
	setFireRate(.111)
	setDamage(26)
	setAccuracy(10)
	setMagazineSize(30)
	setWeaponName("Rifle")
	setCurrentAmmo(getMagazineSize())
