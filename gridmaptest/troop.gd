extends Node2D
var healthLeft
var hasMoved
var totalHealth

var troopName

var attack
var attackRange
var speed
var moved = false


func create(t):
	troopName =t
	print(troopName)
	if troopName == "Giant":
		speed = 3
	elif troopName == "Knight":
		pass
	elif troopName == "Cavalry":
		pass
	elif troopName == "archer":
		pass
	elif troopName == "Tower":
		pass
	elif troopName == "Merchant":
		pass
