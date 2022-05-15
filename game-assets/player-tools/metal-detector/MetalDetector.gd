extends Spatial

onready var audio:AudioStreamPlayer3D = $AudioStreamPlayer3D
onready var detector = $Shaft/Detector
onready var detector_radius:float = $Shaft/Detector/Area/CollisionShape.shape.radius
var current_object = null

func _process(delta):
	if current_object:
		var distance = current_object.global_transform.origin.distance_to(detector.global_transform.origin)
		var pitch = 1- (distance / detector_radius)
		pitch = clamp(pitch * 2 , .5  , 2)
		print(pitch)
		$AudioStreamPlayer3D.pitch_scale = pitch

func _on_Area_area_entered(area:Spatial):
	if area.is_in_group("Treasure"):
		current_object = area
		$AudioStreamPlayer3D.play()


func _on_Area_area_exited(area):
	if area.is_in_group("Treasure"):
		audio.stop()
		current_object = null
