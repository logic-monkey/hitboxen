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
@export var pushback_direction_source : Node2D

@export var always_on : bool = false
func activate():
	hit_id = Time.get_ticks_msec()
	set_deferred("monitorable", true)
	

func deactivate():
	hit_id = 0
	set_deferred("monitorable", false)

signal contact(vector)

func pushback():
	if not pushback_timer.is_stopped(): return
	pushback_timer.start()
	var vec = pushback_vector.normalized()
	if not pushback_direction_source: pushback_direction_source = get_parent()
	vec.x *= pushback_direction_source.scale.x
	vec *= pushback_magnitude
	emit_signal("contact", vec)

	
func _ready():
	collision_layer = 0b01000000
	collision_mask = 0b0100
	if not always_on:
		monitoring = false
		monitorable = false
	pushback_timer.one_shot = true
	pushback_timer.wait_time = pushback_cooldown
	add_child(pushback_timer)
