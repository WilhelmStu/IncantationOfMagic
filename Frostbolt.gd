extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target = Vector2.ZERO
var velocity = 5
var damage = 0
onready var hitBox = get_node("CollisionShape2D")
onready var particles = get_node("Particles2D")
var timer
var hitGround = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#hitBox.shape.radius = size
	#particles.process_material.emission_sphere_radius = size
	#particles.amount += size*2
	timer = Timer.new()
	timer.connect("timeout", self, "on_timer_timeout")
	timer.set_wait_time(0.1)
	add_child(timer)

func _integrate_forces(state):
	#target.x -= 50
	applied_force = (target - position + Vector2(0,18)).normalized() * velocity
	pass
	

func _physics_process(delta):
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.is_in_group("Enemy") || body.is_in_group("Enemy2"):
			print("Hit an enemy!")
			body.health -= damage
			body.update_health()
			queue_free()
			if body.health <= 0:
				body.queue_free()
				if body.is_in_group("Enemy"):
					get_parent().addMoneyScore(5)
				else: 
					get_parent().addMoneyScore(20)
		if body.is_in_group("Ground"):
			#print("Hit Ground!")
#			hitGround = true
#			timer.start()
			queue_free()
	
#	var bodies2 = area2D.get_overlapping_bodies()
#	for body in bodies2:
#		if body.is_in_group("Enemy"):
#			print("Hit an enemy!")
#			body.health -= damage
#			body.update_health()
#			queue_free()
#			if body.health <= 0:
#				body.queue_free()
#				get_parent().addMoneyScore(5)

func on_timer_timeout():
	queue_free()
#func _on_FireBall_body_entered(body):
#	print("Entered body")
#	if body.get_parent() is Enemy:
#		print("It is enemy")
#		body.get_parent().queue_free()
#		queue_free()
#	pass # Replace with function body.
