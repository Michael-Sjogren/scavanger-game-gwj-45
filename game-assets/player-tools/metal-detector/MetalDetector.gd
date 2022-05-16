extends Spatial

export var max_energy:float = 60*3
onready var energy:float = max_energy
onready var audio:AudioStreamPlayer = $AudioStreamPlayer
onready var detector = $Shaft/Detector
onready var detector_radius:float = $Shaft/Detector/Area/CollisionShape.shape.radius
var current_object = null
var _is_active:bool = false
onready var parent = get_parent()
func _ready():
	set_as_toplevel(true)

func activate(active:bool):
	_is_active = active

func _process(delta):
	global_transform = global_transform.interpolate_with(parent.global_transform , .5 )
	orthonormalize()
	if current_object:
		var target:Vector3 = current_object.global_transform.origin
		$Shaft/Detector/Arrow/ArrowMesh.rotate_object_local(Vector3.FORWARD, target.angle_to(global_transform.origin))
		var distance = current_object.global_transform.origin.distance_to(detector.global_transform.origin)
		var pitch = 1- (distance / detector_radius)
		pitch = clamp(pitch * 2 , .95  , 2)
		audio.pitch_scale = pitch
	if _is_active:
		audio.stream_paused = false
		energy -= delta
		print(energy)
	else:
		audio.stream_paused = true
func _on_Area_area_entered(area:Spatial):
	if area.is_in_group("Treasure"):
		current_object = area
		start_detecting()

func stop_detecting():
		var stream:AudioStreamSample= audio.stream
		stream.loop_mode = AudioStreamSample.LOOP_DISABLED
		$Tween.interpolate_property(audio , "volume_db" , audio.volume_db , - 60  , .5 , Tween.TRANS_LINEAR , Tween.EASE_IN_OUT)
		$Tween.start()
		current_object = null
func start_detecting():
		audio.volume_db = 0.0
		var stream:AudioStreamSample = audio.stream
		stream.loop_mode = AudioStreamSample.LOOP_FORWARD
		audio.play()

func _on_Area_area_exited(area):
	if area.is_in_group("Treasure"):
		stop_detecting()
