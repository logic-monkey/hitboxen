extends Node
class_name HeartPoints

@export var hp := 4
var damage_taken := 0

var damage_list := {}

var last_place_i_got_hurt_from = null

var left: int :
	get : return clampi(hp - damage_taken,0, hp)
	

func register_damage(key, damage):
	if key == 0: return false
	if not owner.get_node("%i_frames").is_stopped(): return false
	damage_list[key] = damage
	return true
	
signal hurt
func _physics_process(_delta):
	if damage_list.size() <= 0: return
	var former_damage = damage_taken
	var d_vector := Vector2.ZERO
	for i in damage_list.keys():
		damage_taken += damage_list[i][0]
		d_vector += damage_list[i][1]
		last_place_i_got_hurt_from = damage_list[i][2]
		damage_list.erase(i)
	if damage_taken > former_damage:
		var h = owner.get_node("%take_damage")
		h.poke(d_vector)
		hurt.emit()

signal healed
func register_healing(healing):
	damage_taken -= healing
	if damage_taken < 0: damage_taken = 0
	healed.emit()
