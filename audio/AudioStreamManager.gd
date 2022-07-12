extends Node


var numPlayers = 8
var bus = "master"

var available = [] # the available players
var queue = [] # Queue of sounds to play


# Called when the node enters the scene tree for the first time.
func _ready():
	# Create the pool of AudioStreamPlayer nodes
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -13)
	for i in numPlayers:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Play a queued sound if any players are available
	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()

func _on_stream_finished(stream):
	# When finished playing a stream, make the player avaiable again
	available.append(stream)
	
func play(sound_path):
	queue.append(sound_path)
