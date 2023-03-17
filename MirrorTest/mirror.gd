@tool
extends MeshInstance3D

@export var size : Vector2 =  Vector2(4,5) : set = set_mirror_size
@export var pixels_per_unit = 200

@onready var viewport : Viewport = get_node("SubViewport")
@onready var mirror_camera_transform : Transform3D = Transform3D()

var main_camera = null
var mirror_camera = null

func set_mirror_size (new_size):
	size = new_size
	mesh.size = size
	initialize_camera()

func _ready():
	if Engine.is_editor_hint():
		return
	#flip x axis scale of mesh for mirroed effect
	scale_object_local(Vector3(-1,1,1))
	initialize_camera()
	
func _process(delta):
	if Engine.is_editor_hint():
		return
		
	# compute reflection plane and its global transform
	var mirror_origin : Vector3 = global_transform.origin
	var mirror_normal : Vector3 = global_transform.basis.z.normalized()
	# compute reflection plane and its global transform
	var reflection_plane : Plane = Plane(mirror_normal, mirror_origin.dot(mirror_normal))
	
	# Main camera position
	var main_camera_origin : Vector3 = main_camera.global_transform.origin 
	
	# the projected point of main camera's position onto the reflection plane
	var projection_position : Vector3  = reflection_plane.project(main_camera_origin)
	# main camera position reflected over the mirror's plane
	var mirrored_camera_position : Vector3 = main_camera_origin + (projection_position - main_camera_origin) * 2.0

	# set mirror camera origin to the mirrored position
	mirror_camera_transform.origin = mirrored_camera_position;
	# looking perpedicularly into the relfection plane
	mirror_camera_transform = mirror_camera_transform.looking_at(projection_position, global_transform.basis.y.normalized())
	# set mirror camera transform and flip x basis
	print(mirror_camera_transform.basis.x)
	mirror_camera.set_global_transform(mirror_camera_transform)
	print(mirror_camera_transform.basis.x)
	# Compute the tilting offset for the frustum
	var offset = main_camera_origin * global_transform
	offset = Vector2(offset.x, offset.y)

	# Set mirror camera frustum
	mirror_camera.frustum_offset = Vector2(-offset.x, -offset.y)
	mirror_camera.near = projection_position.distance_to(main_camera_origin)

func initialize_camera():
	if Engine.is_editor_hint():
		return
		
	# get main camera
	main_camera = get_tree().root.get_camera_3d()
	
	# remove mirror camera if it already exists
	if mirror_camera != null:
		mirror_camera.queue_free()
		
	# add a mirror camera
	mirror_camera = Camera3D.new()
	viewport.add_child(mirror_camera)
	mirror_camera.keep_aspect = Camera3D.KEEP_WIDTH
	mirror_camera.current = true
	mirror_camera.set_frustum(mesh.size.x, Vector2(0,0), 0, 1000)
	# adjust viewport size to match the actual mirror size, multiplied by the resolution ratio
	viewport.size = mesh.size * pixels_per_unit
	
	# set material texture
	
	get_active_material(0).set_shader_parameter("texture_albedo", viewport.get_texture())
	
