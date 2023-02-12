extends RigidBody3D

@onready var planet: StaticBody3D = get_node("../Planet")
@onready var label: Label = $Label

const SPEED: int = 1000
const JUMP: int = 5

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# Orient character to ground
	var gravity_up: Vector3 = planet.position.direction_to(position)
	var up: Vector3 = basis.y
	
	var a: Quaternion = Quaternion(up, gravity_up)
	var b: Quaternion = Quaternion(basis)
	var c: Quaternion = a * b
	
	basis = Basis(c)
	
	# Move character by input
	if Input.is_action_pressed("move_forward"):
		apply_force(-basis.z * SPEED * state.step)
	
	if Input.is_action_pressed("move_back"):
		apply_force(basis.z * SPEED * state.step)
	
	if Input.is_action_pressed("move_left"):
		apply_force(-basis.x * SPEED * state.step)
	
	if Input.is_action_pressed("move_right"):
		apply_force(basis.x * SPEED * state.step)
	
	if Input.is_action_just_pressed("jump"):
		apply_impulse(Vector3.UP * JUMP, basis.y)

func _process(_delta: float) -> void:
	label.text = "Position: %s\nRotation: %s\n\nBasis X: %s\nBasis Y: %s\nBasis Z: %s" % [
		position.snapped(Vector3.ONE * 0.1),
		rotation_degrees.snapped(Vector3.ONE * 0.1),
		basis.x.snapped(Vector3.ONE * 0.001),
		basis.y.snapped(Vector3.ONE * 0.001),
		basis.z.snapped(Vector3.ONE * 0.001)
	]
