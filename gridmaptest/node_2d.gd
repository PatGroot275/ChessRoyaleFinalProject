extends Node2D

@onready var Troop = preload("res://troop.tscn")

@onready var player1 = $Player1
@onready var player2 = $Player2
@onready var currentPlayer = player2
@onready var buttonContainer = $PlayerButtons/HBoxContainer
var buying = false
var troopSelected = false
var validSpot = false
var moving =false
var attacking = false
var player1merchantadder = 0
var player2merchantadder = 0

var troopSelectedToBuy = "none"
var currentCellSelected = Vector2(0,0)


var troopNumber = { "Knight": 0, "Calvalry": 1, "Archer": 2,"Tower": 3, "Giant":  4, "Merchant":  5}
var troopValues = {}
@onready var playerNumber = { player1: 0, player2: 1}


var troopCost = [3,5,4,0,5,3]
var troopCostss = [3,5,4,5,3]
var troopPositions = []

var knight
var merchant
var calvalry
var giant
var archer



func _ready():
	
	knight = Troop.instantiate()
	knight.hide()
	knight.create("Knight", player1)
	troopValues.set("Knight", knight)
	
	merchant = Troop.instantiate()
	merchant.hide()
	merchant.create("Merchant", player1)
	troopValues.set("Merchant", merchant)
	
	giant = Troop.instantiate()
	giant.hide()
	giant.create("Giant", player1)
	troopValues.set("Giant", giant)
	
	archer = Troop.instantiate()
	archer.hide()
	archer.create("Archer", player1)
	troopValues.set("Archer", archer)
	
	calvalry = Troop.instantiate()
	calvalry.hide()
	calvalry.create("Calvalry", player1)
	troopValues.set("Calvalry", calvalry)
	
	
	player1 = $Player1
	player2 = $Player2
	currentPlayer = player2
	for x in 18:
		var colum = []
		for y in 10:
			colum.append(null)
		troopPositions.append(colum)
	
	
	for button in get_tree().get_nodes_in_group("troopButtons"):
		button.connect("pressed",buyTroop.bind(button.text) )
		button.connect("mouse_entered",dispayStats.bind(button) )
		button.connect("mouse_exited",hideStats.bind(button) )
	
	$TileMapLayer.set_cell(Vector2(6,4),0,Vector2(troopNumber["Tower"],playerNumber[player1]))
	var redTower = Troop.instantiate()
	$TroopHolder.add_child(redTower)
	redTower.create("Tower", player1)
	troopPositions[6][4] = redTower
	redTower.move(Vector2(6,4))
	
	
	$TileMapLayer.set_cell(Vector2(11,4),0,Vector2(troopNumber["Tower"],playerNumber[player2]))
	var blueTower = Troop.instantiate()
	$TroopHolder.add_child(blueTower)
	blueTower.create("Tower", player2)
	troopPositions[11][4] = blueTower
	blueTower.move(Vector2(11,4))
	updateMoneyDisplay()
	
	endTurn()
	#selectStuff(Vector2(5,5),18,)

func selectStuff(center, range, moving):
	#this function took like 2 hours to make, i might be cooked 
	var highlightSquares = []
	for i in range:
		var ring = i 
		for j in range-ring:
			
			highlightSquares.append(center + Vector2(ring,j))
			highlightSquares.append(center + Vector2(ring,-j))
			highlightSquares.append(center + Vector2(-ring,j))
			highlightSquares.append(center + Vector2(-ring,-j))
			i-=1
		
	
			
			
	for square in highlightSquares:
		if moving and square.y < 10 and square.y > 0:
			if $TileMapLayer.get_cell_atlas_coords(square) == Vector2i(-1,-1):
				$highlight.set_cell(square,0,Vector2(0,0))
			else:
				$highlight.set_cell(square,0,Vector2(1,0))
			#$TileMapLayer.set_cell(square,-1)
		else:
			if $TileMapLayer.get_cell_atlas_coords(square) == Vector2i(-1,-1) or $TileMapLayer.get_cell_atlas_coords(square).y == playerNumber[currentPlayer]:
				$highlight.set_cell(square,0,Vector2(1,0))
			else:
				$highlight.set_cell(square,0,Vector2(0,0))
		
		
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var mousePosition = get_global_mouse_position()
		var cellPosition = floor( mousePosition/ Vector2(64,64)) 
		
		if buying: 
			if  cellPosition.y > 0 and cellPosition.y < 10 and $TileMapLayer.get_cell_atlas_coords(cellPosition) == Vector2i(-1,-1) and ( (currentPlayer == player1 and cellPosition.x <9) or (currentPlayer == player2 and cellPosition.x >8) ):
				buying = false
				print("start new values")
				print(troopCost[troopNumber[troopSelectedToBuy]])
				print(currentPlayer.money)
				if troopSelectedToBuy == "Merchant":
					if currentPlayer == player1:
						currentPlayer.money -= troopCost[troopNumber[troopSelectedToBuy]] + player1merchantadder
						player1merchantadder += 5
					else:
						currentPlayer.money -= troopCost[troopNumber[troopSelectedToBuy]] + player2merchantadder
						player2merchantadder += 5
				else:
					currentPlayer.money -= troopCost[troopNumber[troopSelectedToBuy]]
				print(currentPlayer.money)
				updateMoneyDisplay()
				print(currentPlayer.money)
				$TileMapLayer.set_cell(cellPosition,0,Vector2(troopNumber[troopSelectedToBuy],playerNumber[currentPlayer]))
				$highlight.set_cell(currentCellSelected,-1)
				var troop = Troop.instantiate()
				$TroopHolder.add_child(troop)
				troop.create(troopSelectedToBuy,currentPlayer)
				
				troopPositions[cellPosition.x][cellPosition.y] = troop
				troop.move(cellPosition)

				updatePurchasables()
		elif moving: 
			if $highlight.get_cell_atlas_coords(cellPosition) == Vector2i(0,0):
				#move troop
				$TileMapLayer.set_cell(cellPosition,0,$TileMapLayer.get_cell_atlas_coords(currentCellSelected))
				$TileMapLayer.set_cell(currentCellSelected,-1)
				troopPositions[currentCellSelected.x][currentCellSelected.y].moved = true
				troopPositions[currentCellSelected.x][currentCellSelected.y].move(cellPosition)
				troopPositions[cellPosition.x][cellPosition.y] = troopPositions[currentCellSelected.x][currentCellSelected.y]
				currentCellSelected.x=cellPosition.x
				currentCellSelected.y = cellPosition.y
				
				#$PlayerButtons/HBoxContainer/Button6.disabled = true
				$PlayerButtons/HBoxContainer/Button7.disabled = true
				
			else:
				pass
			moving = false
			clearHightlight()
		elif attacking:
			if $highlight.get_cell_atlas_coords(cellPosition) == Vector2i(0,0):
				#attack troop
				
				
				troopPositions[currentCellSelected.x][currentCellSelected.y].attacked = true
				troopPositions[cellPosition.x][cellPosition.y].healthLeft -= troopPositions[currentCellSelected.x][currentCellSelected.y].attack
				troopPositions[cellPosition.x][cellPosition.y].updateHealth()
				if (troopPositions[cellPosition.x][cellPosition.y].healthLeft < 1):
					if troopPositions[cellPosition.x][cellPosition.y].troopName == "Tower":
						if troopPositions[cellPosition.x][cellPosition.y].player == player1:
							$gameOverLabel.text = "Player 2 Wins!!"
						else:
							$gameOverLabel.text = "Player 1 Wins!!"
						$gameOverLabel.show()
						$TileMapLayer.hide()
						$PlayerButtons.hide()
					troopPositions[cellPosition.x][cellPosition.y].queue_free()
					troopPositions[cellPosition.x][cellPosition.y] = null
					$TileMapLayer.set_cell(cellPosition,-1)
				
				$PlayerButtons/HBoxContainer/Button6.disabled = true
				#$PlayerButtons/HBoxContainer/Button7.disabled = true
				
				
			else:
				pass
			attacking = false
			clearHightlight()
		elif cellPosition.y > 0:
			if $TileMapLayer.get_cell_atlas_coords(cellPosition).y  == playerNumber[currentPlayer] and (troopPositions[cellPosition.x][cellPosition.y].moved == false or troopPositions[cellPosition.x][cellPosition.y].attacked==false):
				$highlight.set_cell(cellPosition,0,Vector2(0,0))
				currentCellSelected = cellPosition
				if troopPositions[cellPosition.x][cellPosition.y].moved  == false:
					$PlayerButtons/HBoxContainer/Button7.disabled = false
				if troopPositions[cellPosition.x][cellPosition.y].attacked == false:
					$PlayerButtons/HBoxContainer/Button6.disabled = false
				troopSelected = true
			else:
				$highlight.set_cell(currentCellSelected,-1)
				$PlayerButtons/HBoxContainer/Button6.disabled = true
				$PlayerButtons/HBoxContainer/Button7.disabled = true
				troopSelected = false
		
		#selectStuff(cellPosition,5)
	elif event is InputEventMouseMotion:
		var mousePosition = get_global_mouse_position()
		if buying:
			#var mousePosition = get_global_mouse_position()
			var cellPosition = floor( mousePosition/ Vector2(64,64)) 
			if cellPosition.y > 0 and cellPosition.y < 10  and ( (currentPlayer == player1 and cellPosition.x <9) or (currentPlayer == player2 and cellPosition.x >8) ):
				if $TileMapLayer.get_cell_atlas_coords(cellPosition) == Vector2i(-1,-1):
					$highlight.set_cell(currentCellSelected,-1)
					$highlight.set_cell(cellPosition,0,Vector2(0,0))
				
				else:
					$highlight.set_cell(currentCellSelected,-1)
					$highlight.set_cell(cellPosition,0,Vector2(1,0))
				currentCellSelected = cellPosition
			$statDisplay.hide()
		#else: 
			#if mousePosition.y < 40 and mousePosition.x < 470:
				#$statDisplay.show()
			#else:
			#	$statDisplay.hide()
				


func endTurn():
	resetPlayerMoved()
	
	for button in buttonContainer.get_children():
		button.disabled = true
	if currentPlayer == player1:
		currentPlayer = player2
		$PlayerButtons.position= (Vector2(500,0))
	else: 
		currentPlayer = player1
		$PlayerButtons.position= (Vector2(0,0))
	
	updateMoney()
	updateMoneyDisplay()
	for button in buttonContainer.get_children():
		if button.text != "Attack" and button.text != "Move":
			button.disabled = false
	updatePurchasables()
	
func updatePurchasables():
	'''
	for i in troopCostss.size():
		
		var button = buttonContainer.get_child(i)
		if button.text == "Merchant":
			if currentPlayer == player1:
				if currentPlayer.money < troopCostss[i] + player1merchantadder:
					button.disabled = true
			else:
				if currentPlayer.money < troopCostss[i] + player2merchantadder:
					button.disabled = true
		else:
			if currentPlayer.money < troopCostss[i]:
				button.disabled = true'''
	for i in range(5):
		var button = buttonContainer.get_child(i)
		var cost = troopCost[troopNumber[button.text]]
		if button.text == "Merchant":
			if currentPlayer == player1:
				if currentPlayer.money < cost + player1merchantadder:
					button.disabled = true
			else:
				if currentPlayer.money < cost + player2merchantadder:
					button.disabled = true
		else:
			if currentPlayer.money < cost:
				button.disabled = true
		


func buyTroop(troopName): 
	troopSelectedToBuy = troopName
	buying = true
	


func clearHightlight():
	print("clearing")
	for x in 20: 
		for y in 16:
			$highlight.set_cell(Vector2(x,y),-1)


func _on_moved_pressed():
	moving = true
	var range = troopPositions[currentCellSelected.x][currentCellSelected.y].speed
	print(range)
	selectStuff(currentCellSelected,range,true)




func _on_attack_pressed() -> void:
	attacking = true
	var range = troopPositions[currentCellSelected.x][currentCellSelected.y].attackRange
	selectStuff(currentCellSelected,range,false)


func resetPlayerMoved():
	for x in troopPositions:
		for y in x:
			if y != null:
				y.moved = false
				y.attacked = false


func updateMoney():
	print("udpating money")
	for x in troopPositions:
		for y in x:
			if y != null:
				if y.player == currentPlayer:
					currentPlayer.money += y.moneyPerTurn
func updateMoneyDisplay():
	if currentPlayer == player1:
		$PlayerButtons/Label.text = "P1 Money:" + str(currentPlayer.money)
	else:
		$PlayerButtons/Label.text = "P2 Money:" + str(currentPlayer.money)

func dispayStats(button):
	var values = troopValues.get(button.text)
	var cost
	if button.text == "Merchant":
		if currentPlayer == player1:
			cost = troopCost[troopNumber[button.text]] + player1merchantadder
		else:
			cost = troopCost[troopNumber[button.text]] + player2merchantadder
	else:
		cost = troopCost[troopNumber[button.text]]
	$statDisplay.show()
	$statDisplay.position   = button.get_global_position() + Vector2(0,50)
	$statDisplay/VBoxContainer/CostLabel.text = "Cost: $" + str(cost)
	$statDisplay/VBoxContainer/HealthLabel.text = "Health: " + str(values.totalHealth)
	$statDisplay/VBoxContainer/DamageLabel.text = "Damage: " + str(values.attack)
	$statDisplay/VBoxContainer/RangeLabel.text = "Range: " + str(values.attackRange)
	$statDisplay/VBoxContainer/SpeedLabel.text = "Speed: " + str(values.speed)
	
func hideStats(button):
	$statDisplay.hide()


func _on_cancelbutton_pressed() -> void:
	buying = false # Replace with function body.
	clearHightlight()
