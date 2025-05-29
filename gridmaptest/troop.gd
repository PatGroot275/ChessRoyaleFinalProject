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
var moved = true
var attacked = true


func create(t,p):
	player = p
	troopName =t
	print(troopName)
	if troopName == "Giant":
		#speed = 2
		speed=2
		#attack = 3
		attack = 30
		attackRange = 2
		totalHealth = 70
	elif troopName == "Knight":
		speed = 2
		attack = 40
		attackRange = 3
		totalHealth = 30
	elif troopName == "Calvalry": 
		speed = 4
		attack = 30
		attackRange = 2
		totalHealth = 30
	elif troopName == "Archer":
		speed = 2
		attack = 20
		attackRange = 4
		totalHealth = 20
	elif troopName == "Tower":
		speed = 0
		attack = 10
		attackRange = 3
		totalHealth = 100
		moneyPerTurn = 3
	elif troopName == "Merchant":
		moneyPerTurn =2
		speed = 2
		attackRange = 0 
		attack = 0 
		totalHealth = 10
	healthLeft = totalHealth
	updateHealth()
func updateHealth():
	$Label.text = str(healthLeft) +"/" + str(totalHealth)
	
func move(newPosition):

	position = newPosition*Vector2(64,64)
	#position += Vector2(64,64)
	print(position)
	print($Label.text)
