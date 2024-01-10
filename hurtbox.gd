extends Area2D
class_name HurtBox

@export_flags("Player","Enemy1","Enemy2") var team
@export_flags("Bump","Impact","Pierce","Energy") var damage_type

@export var damage := 4
@export var hit_id := -1

@export_group("Force", "force_")
@export var force_vector := Vector2.ZERO
@export var force_magnitude := 1.0
@export_group("Pushback", "pushback_")
@export var pushback_vector := Vector2.ZERO
@export var pushback_magnitude := 1.0
@export var pushback_cooldown := 0.33
@onready var pushback_timer := Timer.new()

func activate():
	hit_id = Time.get_ticks_msec()
	monitorable = true
	

func deactivate():
	hit_id = 0
	monitorable = false

signal contact(vector)

func pushback():
	if not pushback_timer.is_stopped(): return
	pushback_timer.start()
	var vec = pushback_vector.normalized()
	vec.x *= get_parent().scale.x
	vec *= pushback_magnitude
	emit_signal("contact", vec)

	
func _ready():
	collision_layer = 0b01000000
	collision_mask = 0b0100
	monitoring = false
	monitorable = false
	pushback_timer.one_shot = true
	pushback_timer.wait_time = pushback_cooldown
	add_child(pushback_timer)
