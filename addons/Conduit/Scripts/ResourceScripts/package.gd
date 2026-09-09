## Data structure that is used as argument for signal. Carries any type of data.
class_name Package extends Resource

## data package that contains all variant types with a descriptor name.
@export_group("Content")
@export var content: Dictionary[StringName, Variant]
var descriptor: String = ""
## couples{signal.name : method.name,} often used to easily connect signals to methods.
@export_group("Couples")
@export var couples: Dictionary[StringName, StringName]
# Any other data entry can be easily inplemented here, without breaking the rest.

## INFO: Memory Weight Table # =================================================
#| Empty | ~120 B | ~120 B | **~0.4–0.6 KB** |
#| Light (5 entries each, scalars) | ~700 B | ~700 B | **~1.4–1.8 KB** |
#| Heavy (500 entries, mixed types) | ~75–85 KB | ~22 KB | **~95–110 KB** |
## =============================================================================
