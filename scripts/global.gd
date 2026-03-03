extends Node

var forest: Node3D
var spawn_container: Node3D

const ball_1 = preload("uid://cn6fmbuyc1jyh")

@rpc("any_peer")
func shoot_ball(pos, _dir, _force):
	var new_ball = ball_1.instantiate()
	new_ball.position = pos
	spawn_container.add_child(new_ball, true)
