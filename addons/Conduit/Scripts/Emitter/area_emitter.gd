## Emitter that is already connected to area_entered/exited signals.
class_name AreaEmitter extends Emitter

@warning_ignore("unused_signal")
signal area_in_group(area: Area3D)
@export var group_to_check: String
@export var connect_area_signals: bool = true

## Implicit ready call to area setup.
@onready var ir_area_setup = area_setup(
	) if connect_area_signals else false

func area_setup() -> bool:
	return connect_couples(Static.Resources.Default.DEF_AREA_EMITTER_PKG
		) if check_group_validity() else false

func check_group_validity() -> bool:
	var group_is_valid: bool = (
		true if group_to_check
		and     group_to_check
		in      Static.Utility.get_all_global_groups()
		else false)

	if not group_is_valid:
		push_warning(group_to_check, " :group doesn't exist or requires correction.")

	return group_is_valid

## Signal hooks, they get connected to internal Area3D signals:
func _on_area_entered(area: Area3D) -> void:  area_entered_emit(area)
func _on_area_exited(area: Area3D)  -> void:  area_entered_emit(area)

## Emits a signal when the entered area matches the specified @export group_to_check String.
func area_entered_emit(area: Area3D):
	if area.is_in_group(group_to_check):
		group_emit([&"area_in_group"], area, false)
