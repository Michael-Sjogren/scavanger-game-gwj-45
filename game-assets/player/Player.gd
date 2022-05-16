extends MovementController


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var cam = $Head/Camera
var decal = preload("res://game-assets/decals/Decal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("dig"):
		dig()
	if event.is_action_pressed("detect"):
		$AnimationPlayer.play("DetectMetal")
		$DetectorHolder/MetalDetector.activate(true)
	if event.is_action_released("detect"):
		$AnimationPlayer.play_backwards("DetectMetal")
		$DetectorHolder/MetalDetector.activate(false)
func dig():
	$AnimationPlayer.play("Pick")
	var center = get_viewport().get_visible_rect().size *.5
	var origin = cam.project_ray_origin(center)
	var dir = cam.project_ray_normal(center)
	var col:Dictionary = cast_ray(origin , dir)
	if not col.empty():

		if col.collider.is_in_group("Treasure"):
			var treasure = col.collider
			treasure.dig_up()
		else:
			var d =  decal.instance()
			col.collider.add_child(d)
			d.global_transform.origin = col.position
			d.look_at(col.position + -col.normal , Vector3.UP)

func cast_ray(origin:Vector3 , dir:Vector3 , length:float = 4) -> Dictionary:
	var space_state = PhysicsServer.space_get_direct_state(get_world().space)
	return space_state.intersect_ray(origin , origin + dir*length , [] , 3 , true , true)
