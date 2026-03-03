extends Node3D

@onready var spawn_container: Node3D = %SpawnerContainer


func _ready() -> void:
	Global.forest = self
	Global.spawn_container = spawn_container
