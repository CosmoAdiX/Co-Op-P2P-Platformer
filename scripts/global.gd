extends Node

var username := ''

var forest: Node3D
var spawn_container: Node3D

var BALL = load("uid://c1yny3sauy8yu")

var session_info: Dictionary = { }
signal signal_session_info(new_info)

func _ready() :
	Network.tube_client.session_created.connect(set_up_scoreboard)

func set_up_scoreboard():
	session_info[1] = { "score": 0, "username": username }
	multiplayer.peer_connected.connect(add_session)
	multiplayer.peer_disconnected.connect(erased_session)
	
func add_session(peer_id: int):
	await get_tree().create_timer(1.0).timeout
	var new_player = get_player(peer_id)
	session_info[peer_id] = { "score": 0, "username": new_player.nameplate.text }
	replicate_session_info.rpc(session_info)
	
func erased_session(peer_id: int):
	session_info.erase(peer_id)
	
@rpc("authority", "call_local")
func replicate_session_info(new_info):
	signal_session_info.emit(new_info)
	
func get_player(peer_id: int) -> Player:
	var player_to_find: Player
	for current_player in get_tree().get_nodes_in_group("Players"):
		if current_player.name == str(peer_id):
			player_to_find = current_player
			break
			
	# TODO: not found???
	return player_to_find

@rpc("any_peer", "call_local")
func shoot_ball(pos, dir, force):
	var new_ball: RigidBody3D = BALL.instantiate()
	new_ball.source = multiplayer.get_remote_sender_id()
	new_ball.position = pos + Vector3(0.0, 1.5, 0.0) + (dir * 1.2)
	spawn_container.add_child(new_ball, true)
	new_ball.apply_central_impulse(dir * force)
