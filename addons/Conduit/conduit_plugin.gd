@tool
extends EditorPlugin

const ICON = preload("res://addons/Conduit/icon.svg")
const ADDON_BASE_PATH := "res://addons/Conduit"
const SIGNAL_BUS_AUTOLOAD_NAME := "SignalBus"

# filename -> [custom type name, base class]
const ADDON_SCRIPTS := {
	"emitter.gd"       :   ["Emitter", "Node"],
	"area_emitter.gd"  :   ["AreaEmitter", "Area3D"],
	"signal_bus.gd"    :   ["SignalBus", "Node"] }

var script_paths: Dictionary = {}


func _enter_tree() -> void:
	if not DirAccess.dir_exists_absolute(ADDON_BASE_PATH):
		push_error(
			"Conduit: expected folder '%s' was not found. " % ADDON_BASE_PATH +
			"This usually means the addon was installed with the wrong folder name, " +
			"or its contents were placed directly under res://addons/ (or res://) " +
			"instead of keeping the 'Conduit' folder intact. " +
			"Reinstall so the addon files live at res://addons/Conduit/ and re-enable the plugin."
		)
		return

	script_paths = find_files(ADDON_BASE_PATH, ADDON_SCRIPTS.keys())

	var all_ok: bool = true

	for file_name in ADDON_SCRIPTS:
		if not script_paths.has(file_name):
			push_warning("Conduit: could not find %s under %s" % [file_name, ADDON_BASE_PATH])
			all_ok = false
			continue

		var type_name:  String = ADDON_SCRIPTS[file_name][0]
		var base_class: String = ADDON_SCRIPTS[file_name][1]
		add_custom_type(type_name, base_class, load(script_paths[file_name]), ICON)

	var autoload_ready: bool = true
	if script_paths.has("signal_bus.gd"):
		if not ProjectSettings.has_setting("autoload/%s" % SIGNAL_BUS_AUTOLOAD_NAME):
			add_autoload_singleton(SIGNAL_BUS_AUTOLOAD_NAME, script_paths["signal_bus.gd"])
	else:
		autoload_ready = false

	if all_ok and autoload_ready:
		print("Conduit: addon loaded successfully — all nodes and the SignalBus autoload are set up.")
	else:
		push_warning("Conduit: addon loaded with issues — see warnings above. Some nodes or the SignalBus autoload may be unavailable.")


func _exit_tree() -> void:
	for file_name in ADDON_SCRIPTS:
		remove_custom_type(ADDON_SCRIPTS[file_name][0])

	if ProjectSettings.has_setting("autoload/%s" % SIGNAL_BUS_AUTOLOAD_NAME):
		remove_autoload_singleton(SIGNAL_BUS_AUTOLOAD_NAME)


func find_files(path: String, names: Array) -> Dictionary:
	var results: Dictionary = {}
	var dir := DirAccess.open(path)
	if dir == null:
		return results

	for file_name in dir.get_files():
		if file_name in names:
			results[file_name] = path.path_join(file_name)

	for dir_name in dir.get_directories():
		results.merge(find_files(path.path_join(dir_name), names))

	return results
