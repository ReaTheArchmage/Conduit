## Standard class used to emit signals, has connect and emit extension
## methods.
class_name Emitter extends Node
@warning_ignore("unused_signal")
## Singnal emitted in absence of other signals.
signal default_emitter_signal()

var classes                      : Array[Object] = [self, SignalBus]
@export var signal_registry      : Package = Static.Resources.Default.DEF_EMPTY_PACKAGE
@export var enable_connections   : bool

@onready var ir_connect_couples = connect_couples(signal_registry
) if enable_connections else false

## Connects signal/method couples from pkg.couples 
func connect_couples(pkg: Package) -> bool:

	if pkg.couples.is_empty():
		push_warning("No connection assigned in the registry. ", name, " is inert.")

	var couples = pkg.couples
	for signal_name in couples: for _class in classes:

		var signal_      =  Signal   (_class, signal_name)
		var method_name: StringName = couples[signal_name]
		var callable =  Callable (_class, method_name) 

		if not signal_.is_connected(callable): 
			signal_.connect(callable)

	return true

## Emits global/local/default grouped signals, can loop emission.
func group_emit(
	signals: Array[StringName], args,
	looped: bool, delay_duration: float = 2.0):

	for s in signals:

		if self.has_signal(s):
			self.emit_signal(s, args)

		elif SignalBus.has_signal(s):
			SignalBus.emit_signal(s, args)

		else:
			default_emitter_signal.emit(args)

	if looped:
		await get_tree().create_timer(delay_duration).timeout
		group_emit(signals, args, looped, delay_duration)
