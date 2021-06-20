extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var difficulty = 5
var availableSpawnAmount = 20
var oneSec = 1
var tenSec = 10
var spawnTimer = 2
var enemy1 = load("res://Enemy.tscn")
var enemy2 = load("res://Enemy2.tscn")

var enemies = []
var money = 10
var score = 0

var spawnPointOffset = 0

onready var moneyLabel = get_node("TopUI/Money")
onready var scoreLabel = get_node("Score")


# Called when the node enters the scene tree for the first time.
func _ready():
	moneyLabel.text = str(money)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if score < -100 || money < -100:
		get_tree().change_scene("res://GameOver.tscn")
	if spawnTimer > 0:
		spawnTimer -= delta
	else:
		availableSpawnAmount = difficulty
		spawnTimer = 10
		print("Spawning new enemies, availble amount: ", availableSpawnAmount)
		spawnEnemies()
	
	increaseDiff(delta)
	pass

func spawnEnemies():
	print("Spawning enemies!")
	while(availableSpawnAmount > 0 && enemies.size() < 15 ):
		var enemy
		if randi() % 10 == 1:
			enemy = enemy2.instance()
			enemy.scale = Vector2(3,3)
			availableSpawnAmount -= 20
			enemy.health += difficulty * 4
		else:
			enemy = enemy1.instance()
			enemy.health += difficulty/2
		if randi() % 2:
			enemy.position = Vector2(2000, 500)
		else:
			enemy.position = Vector2(-100, 500)
#			if spawnPointOffset > 450:
#				spawnPointOffset = 0
#			enemy.position = Vector2(-500 +spawnPointOffset, 500)
#			spawnPointOffset += 80
		add_child(enemy)
		enemies.push_back(enemy)
		availableSpawnAmount -= 10
				   
func increaseDiff (delta):
	if oneSec > 0:
		oneSec -= delta
	else:
		difficulty += 1
		difficulty *=1.001
		oneSec = 1
	
	if tenSec > 0:
		tenSec -=delta
	else:
		print("Current difficulty value: ", difficulty)
		tenSec = 10

func _physics_process(delta):
#	if fire != null:
#		pass
#		fire.target = getNearestEnemy().position
	pass
	


func addMoneyScore(amount):
	money += amount
	score += amount
	moneyLabel.text = str(money)
	scoreLabel.text = "Score: "  + str(score)



