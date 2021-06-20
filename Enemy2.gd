extends RigidBody2D
class_name Enemy2

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 40
var health = 200
var damage = 20
var tic = 0.5
onready var stats = $EnemyStats

# Called when the node enters the scene tree for the first time.
func _ready():
#	if position.x > 1000:
#		set_linear_velocity(Vector2(speed * -1, 0))
#		#applied_force = Vector2(speed * -1,0)
#	else:
#		set_linear_velocity(Vector2(speed, 0))
		#applied_force = Vector2(speed ,0)
	stats.healthbar.max_value = health
	stats.healthbar.value = health
	if position.x <960:
		add_central_force(Vector2(speed, 0))
	else:
		add_central_force(Vector2(-speed, 0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if tic > 0:
		tic -= delta
	else:
		var bodies = get_colliding_bodies()
		for body in bodies:
			if body.is_in_group("Fence"):
				print("Enemy hit the fence!")
				body.getHit(-damage)
				tic = 0.5
	pass
	
func _integrate_forces(state):
	if position.x < 960:
		pass
		#applied_force = position.normalized() * speed
		#apply_impulse(Vector2.ZERO, Vector2(speed, 0))
	else:
		pass
		#applied_force = Vector2(960, 10).normalized() * speed * -1
		#apply_impulse(Vector2.ZERO, Vector2(speed*-1, 0))
	
	#applied_force = (target - position + Vector2(0,20)).normalized() * velocity
	pass
	
func update_health():
	stats.update_healthbar(health)
	
