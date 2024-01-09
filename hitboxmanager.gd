extends Node
class_name HB_Manager

@export var hitboxen : Array[Node]
@export var attach_i_frames := true


func _ready():
	for hb in hitboxen:
		selected_off.append(false)
	if attach_i_frames:
		var ifr = owner.get_node("%i_frames") as Timer
		if ifr: ifr.timeout.connect(enable)

var on = true
var selected_off : Array[bool] = []

func enable():
	on = true
	for i in hitboxen.size():
		if not selected_off[i]:
			hitboxen[i].set_deferred("disabled", false)

func disable():
	on = false
	for hb in hitboxen:
		hb.set_deferred("disabled", true)

func selective_disable(box:Node):
	if not box in hitboxen: return
	var i = hitboxen.find(box)
	box.set_deferred("disabled", true)
	selected_off[i] = true
	
func selective_enable(box:Node):
	if not box in hitboxen: return
	var i = hitboxen.find(box)
	selected_off[i] = false
	if on: box.set_deferred("disabled", false)
