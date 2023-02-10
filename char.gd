extends RigidBody3D

@onready var planet: StaticBody3D = get_node("../Planet")
@onready var collision_shape: CollisionShape3D = $CollisionShape
@onready var body: MeshInstance3D = $Body
@onready var head: MeshInstance3D = $Head
@onready var label: Label = $Label

const SPEED: int = 1000
const JUMP: int = 5

func _process(_delta: float) -> void:
	label.text = "%d FPS\n\nPosition: %s\nRotation: %s\nVelocity: %s\n\nGravity: %s\n\nBasis X: %s\nBasis Y: %s\nBasis Z: %s" % [
		Performance.get_monitor(Performance.TIME_FPS),
		position.snapped(Vector3.ONE * 0.1),
		rotation_degrees.snapped(Vector3.ONE * 0.1),
		linear_velocity.snapped(Vector3.ONE * 0.1),
		gravity_dir().snapped(Vector3.ONE * 0.001),
		transform.basis.x,
		transform.basis.y,
		transform.basis.z
	]

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.transform.basis.y = -gravity_dir()
	
	if Input.is_action_pressed("move_forward"):
		apply_force(-transform.basis.z * SPEED * state.step)

	if Input.is_action_pressed("move_back"):
		apply_force(transform.basis.z * SPEED * state.step)

	if Input.is_action_pressed("move_left"):
		apply_force(-transform.basis.x * SPEED * state.step)

	if Input.is_action_pressed("move_right"):
		apply_force(transform.basis.x * SPEED * state.step)
	
	if Input.is_action_just_pressed("jump"):
		apply_impulse(Vector3.UP * JUMP, transform.basis.y)

func gravity_dir() -> Vector3:
	return (planet.position - position).normalized()
