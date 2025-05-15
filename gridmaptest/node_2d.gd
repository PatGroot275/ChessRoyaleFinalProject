extends Node2D


func _ready():
	selectStuff(Vector2(5,5),18)

func selectStuff(center, attackrange):
	#this function took like 2 hours to make, i might be cooked 
	var highlightSquares = []
	for i in attackrange:
		var ring = i 
		for j in attackrange-ring:
			
			highlightSquares.append(center + Vector2(ring,j))
			highlightSquares.append(center + Vector2(ring,-j))
			highlightSquares.append(center + Vector2(-ring,j))
			highlightSquares.append(center + Vector2(-ring,-j))
			i-=1
		
	
			
			
	for square in highlightSquares:
		$TileMapLayer.set_cell(square,-1)
		
		
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var mousePosition = get_global_mouse_position()
		var cellPosition = floor( mousePosition/ Vector2(64,64)) 
		print(cellPosition)
		selectStuff(cellPosition,5)
