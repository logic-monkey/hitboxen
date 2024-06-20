extends Area2D
class_name HitBox

@export_flags("Player","Enemy1","Enemy2")
var team

static var friendly_fire : bool = false

func _on_hitbox_area_entered(area):
	if not area is HurtBox: return
	if area.owner == owner: return
	if not friendly_fire and (team & area.team) != 0: return
	if not owner.get_node("%i_frames").is_stopped(): return
	
	var hb = area as HurtBox
	var h_vector = hb.force_vector as Vector2
	if h_vector == Vector2.ZERO:
		h_vector = global_position - area.global_position
	h_vector = h_vector.normalized()
	h_vector.x *= area.get_parent().scale.x
	h_vector *= hb.force_magnitude
	
	var src_loc = area.owner.global_position
	
	var hp = owner.get_node("%hp") as HeartPoints
	if hp.register_damage(hb.hit_id, [hb.damage, h_vector, src_loc]):
		hb.pushback()
	
func _ready():
	collision_layer = 0b0100
	collision_mask = 0b01000000
	monitorable = false
	area_entered.connect(_on_hitbox_area_entered)
