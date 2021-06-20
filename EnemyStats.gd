extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health_low = preload("res://assets/health_low.png")
var health_medium = preload("res://assets/health_medium.png")
var health_high = preload("res://assets/health_high.png")
var health_full = preload("res://assets/health_full.png")
onready var healthbar = $Health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_healthbar(value):
	if value > healthbar.max_value * 0.9:
		healthbar.texture_progress = health_full
		print("Health is full!")
	if value < healthbar.max_value * 0.9:
		healthbar.texture_progress = health_high
		print("Health is high!")
	if value < healthbar.max_value * 0.6:
		healthbar.texture_progress = health_medium
		print("Health is medium!")
	if value < healthbar.max_value * 0.3:
		healthbar.texture_progress = health_low
		print("Health is low!")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
