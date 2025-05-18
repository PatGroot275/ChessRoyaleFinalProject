extends Node2D
var healthLeft
var hasMoved
var totalHealth
var player

var troopName
var moneyPerTurn = 0 

var attack
var attackRange
var speed
var moved = false


func create(t,p):
	player = p
	troopName =t
	print(troopName)
	if troopName == "Giant":
		speed = 2
		attack = 3
		attackRange = 2
		totalHealth = 6
	elif troopName == "Knight":
		speed = 2
		attack = 2
		attackRange = 2
		totalHealth = 3
	elif troopName == "Cavalry":
		speed = 4
		attack = 2
		attackRange = 2
		totalHealth = 3
	elif troopName == "Archer":
		speed = 2
		attack = 2
		attackRange = 4
		totalHealth = 2
	elif troopName == "Tower":
		speed = 0
		attack = 1
		attackRange = 5
		totalHealth = 10
		moneyPerTurn = 3
	elif troopName == "Merchant":
		moneyPerTurn =2
		speed = 2
		attackRange = 0 
		attack = 0 
		totalHealth = 1
	healthLeft = totalHealth
	updateHealth()
func updateHealth():
	$Label.text = str(healthLeft) +"/" + str(totalHealth)
	
func move(newPosition):

	position = newPosition*Vector2(64,64)
	#position += Vector2(64,64)
	print(position)
	print($Label.text)
