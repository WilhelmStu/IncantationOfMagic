extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var game = get_parent()
var fireball = load("res://FireBall.tscn")
var frostbolt = load("res://Frostbolt.tscn")
onready var dmgUPPriceLabel = get_node("/root/Node2D/VBoxContainer/VBoxContainer/HBoxContainer2/DmgUPPrice")
onready var sizeUPPriceLabel = get_node("/root/Node2D/VBoxContainer/VBoxContainer/HBoxContainer2/SizeUPPrice")
onready var fireButton = get_node("/root/Node2D/VBoxContainer/VBoxContainer/ButtonFireball")
onready var autoFireButton = get_node("/root/Node2D/VBoxContainer/AutoFireball")

onready var dmgUPPriceLabelFrost = get_node("/root/Node2D/VBoxContainer2/VBoxContainer/HBoxContainer2/DmgUPPriceFrost")
onready var delayPriceLabel = get_node("/root/Node2D/VBoxContainer2/VBoxContainer/HBoxContainer2/DelayPriceFrost")
onready var frostButton = get_node("/root/Node2D/VBoxContainer2/VBoxContainer/ButtonFrostbolt")
onready var autoFrostButton = get_node("/root/Node2D/VBoxContainer2/AutoFrostbolt")

# following only for fireball
var fire = null
var damage = 40
var size = 8

var timer
var timerAutoFireball
var timerAutoDelay = 2

var costDmg = 5
var costSize = 20
var costAuto = 30

#following only for frostbolt
var frost = null
var damageFrost = 120
var delayFrost = 2

var timerFrost
var timerAutoFrostbolt
var timerAutoDelayFrost = 4

var costDmgFrost = 10
var costDelay = 20
var costAutoFrost = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	dmgUPPriceLabel.text = "Cost " + str(costDmg)
	sizeUPPriceLabel.text = "Cost " + str(costSize)
	dmgUPPriceLabelFrost.text = "Cost " + str(costDmgFrost)
	delayPriceLabel.text = "Cost " + str(costDelay)
	autoFireButton.text = "Autofire (" + str(costAuto) + ")"
	autoFrostButton.text = "Autofrost (" + str(costAutoFrost) + ")"
	timer = Timer.new()
	timer.connect("timeout", self, "on_timer_timeout")
	timer.set_wait_time(0.5)
	add_child(timer)
	
	timerAutoFireball = Timer.new()
	timerAutoFireball.connect("timeout", self, "auto_fire")
	timerAutoFireball.set_wait_time(timerAutoDelay)
	add_child(timerAutoFireball)
	
	timerFrost = Timer.new()
	timerFrost.connect("timeout", self, "on_timerFrost_timeout")
	timerFrost.set_wait_time(5)
	add_child(timerFrost)
	
	timerAutoFrostbolt = Timer.new()
	timerAutoFrostbolt.connect("timeout", self, "auto_frost")
	timerAutoFrostbolt.set_wait_time(timerAutoDelayFrost)
	add_child(timerAutoFrostbolt)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func getHit(damage):
	print("Hit an enemy!")
	get_parent().addMoneyScore(damage)

func _on_Button_pressed():
	fireButton.disabled = true
	timer.start()
	fire()
	
func auto_fire():
	fire()

func auto_frost():
	frost()
	
func fire():
	if game.enemies.size() > 0:  #&& enemies.front().position.x < 1920:
		#print(game.enemies)
		while game.enemies.front() == null || !is_instance_valid(game.enemies.front()) :
			if game.enemies.size() == 0:
				return
			game.enemies.pop_front()
		if game.enemies.front().position.x < 1920:
			fire = fireball.instance()
			fire.damage = damage
			fire.size = size
			fire.position = Vector2(960, 450)
			fire.target = getNearestEnemy().position
			game.add_child(fire)

func frost():
	if game.enemies.size() > 0:  #&& enemies.front().position.x < 1920:
		#print(game.enemies)
		while game.enemies.front() == null || !is_instance_valid(game.enemies.front()) :
			if game.enemies.size() == 0:
				return
			game.enemies.pop_front()
		if game.enemies.front().position.x < 1920:
			frost = frostbolt.instance()
			frost.damage = damageFrost
			frost.position = Vector2(960, 450)
			frost.target = getNearestEnemy().position
			game.add_child(frost)
	pass
	
	
func on_timer_timeout():
	fireButton.disabled = false
	timer.stop()
	
func on_timerFrost_timeout():
	frostButton.disabled = false
	timerFrost.stop()
	
func getNearestEnemy() -> RigidBody2D:
	if game.enemies.size() == 0:
		return null
	var enem
	var distance = 1920
	for enemy in game.enemies :
		if enemy == null || !is_instance_valid(enemy):
			continue
		#print (enemy.position.x)
		if enemy.position.x < 960:
			var d = 960-enemy.position.x
			if d < distance:
				distance = d
				enem = enemy
			else:
				continue
		else:
			var d = enemy.position.x - 960
			if d < distance:
				distance = d
				enem = enemy
			
	return enem

func _on_DmgUP_pressed():
	if game.money >= costDmg:
		damage += 5
		game.money -= costDmg
		game.moneyLabel.text = str(game.money)
	pass # Replace with function body.


func _on_SizeUP_pressed():
	if game.money >= costSize:
		size += 2
		game.money -= costSize
		game.moneyLabel.text = str(game.money)
	pass # Replace with function body.


func _on_AutoFireball_pressed():
	#game.money += 1000
	if game.money >= costAuto:
		if timerAutoFireball.is_stopped():
			timerAutoFireball.start()
			game.money -= costAuto
			game.moneyLabel.text = str(game.money)
			autoFireButton.text = "Autospeed (" + str(costAuto) + ")"
		else:	
			if timerAutoDelay > 0:
				timerAutoDelay *= 0.95
				timerAutoFireball.set_wait_time(timerAutoDelay)
				game.money -= costAuto
				game.moneyLabel.text = str(game.money)
	pass # Replace with function body.


func _on_ButtonFrostbolt_pressed():
	frostButton.disabled = true
	timerFrost.start()
	frost()
	pass # Replace with function body.


func _on_DmgFrostUP_pressed():
	if game.money >= costDmgFrost:
		damage += 40
		game.money -= costDmgFrost
		game.moneyLabel.text = str(game.money)
	pass # Replace with function body.

func _on_DelayFrost_pressed():
	if game.money >= costDelay:
		delayFrost *= 0.9
		game.money -= costDelay
		game.moneyLabel.text = str(game.money)
	pass # Replace with function body.


func _on_AutoFrostbolt_pressed():
	
	if game.money >= costAuto:
		if timerAutoFrostbolt.is_stopped():
			timerAutoFrostbolt.start()
			game.money -= costAutoFrost
			game.moneyLabel.text = str(game.money)
			autoFrostButton.text = "Autospeed (" + str(costAutoFrost) + ")"
		else:	
			if timerAutoDelayFrost > 0:
				timerAutoDelayFrost *= 0.95
				timerAutoFrostbolt.set_wait_time(timerAutoDelayFrost)
				game.money -= costAutoFrost
				game.moneyLabel.text = str(game.money)
	pass # Replace with function body.



