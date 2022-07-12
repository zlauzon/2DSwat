extends Camera2D


export var decay = 0.8
export var MAX_OFFSET = Vector2(100, 50)
export var MAX_ROLL = 0.1
export (NodePath) var target

var trauma = 0.0
var TRAUMA_POWER = 2

onready var noise = OpenSimplexNoise.new()
var noiseY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func add_trauma(amount):
	trauma = min(amount, 1.0)

func shake():
	noiseY += 1
	var amount = pow(trauma, TRAUMA_POWER)
	rotation = MAX_ROLL * amount * noise.get_noise_2d(noise.seed, noiseY)
	offset.x = MAX_OFFSET.x * amount * noise.get_noise_2d(noise.seed*2, noiseY)
	offset.y = MAX_OFFSET.y * amount * noise.get_noise_2d(noise.seed*3, noiseY)
	#get_parent().rotation = rotation
	#get_parent().offset.x = offset.x
	#get_parent().offset.y = offset.y
