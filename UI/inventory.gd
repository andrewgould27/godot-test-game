extends Control

func _ready():
	EventController.connect("inventory_toggled", Callable(on_inventory_toggled))
	visible = false 
	print("[READY] Inventory")
	
func on_inventory_toggled():
	visible = not visible 

func _on_close_button_pressed():
	on_inventory_toggled()
