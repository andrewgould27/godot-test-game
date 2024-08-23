extends Node

signal on_health_changed(node: Node)

# Interacted
signal on_interacted(node: Node)

# Inventory Toggled
signal inventory_toggled()
signal item_changed(item: int)

func _ready():
	print("[READY] EventController")
