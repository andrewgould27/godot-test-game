extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	print("[READY] Chest")
	animated_sprite.play("idle")

func interact():
	animated_sprite.play("open_down")
	print("HELLO")
