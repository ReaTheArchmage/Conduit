# Conduit

A small signal-emission and connection system for Godot 4.8+.

## Installing in another project

1. Copy the whole `addons/Conduit/` folder into your project's `addons/` folder
   (so you end up with `res://addons/Conduit/...`).
2. Open the project in Godot, go to **Project > Project Settings > Plugins**,
   and enable **Conduit**.
3. That's it — enabling the plugin automatically:
   - Registers `AreaEmitter` as a custom node type (extends `Area3D`) in the
	 "Create New Node" dialog.
   - Adds the `SignalBus` autoload singleton, if your project doesn't already
     have one, so global signals work out of the box.

No manual editing of `project.godot` is required.

## Classes

### `Emitter` (extends `Node`)

Base class for emitting and connecting signals.

- `connect_couples(pkg: Package) -> bool` — iterates `pkg.couples` and
  connects each `{signal_name: method_name}` pair across `self` and
  `SignalBus`.
- `group_emit(signals: Array[StringName], args, looped: bool, delay_duration: float = 2.0)` —
  emits a group of signals (local, or on `SignalBus` if not found locally,
  falling back to `default_emitter_signal`). Can optionally loop on a delay.

### `AreaEmitter` (extends `Emitter`, `Area3D`)

Emitter pre-wired to `area_entered` / `area_exited`. Set `group_to_check` to
the group name an incoming `Area3D` must belong to; when it matches, it emits
`area_in_group(area)`.

Exported properties:
- `group_to_check: String`
- `push_warnings: bool` — warn in the editor about missing group/collision setup
- `connect_to_signal: bool`

### `Package` (extends `Resource`)

Data resource passed around to describe connections and payloads:
- `couples: Dictionary[StringName, StringName]` — `{signal name: method name}`
- `content: Dictionary[StringName, Variant]` — arbitrary keyed data

### `SignalBus` (autoload)

Empty `Node` singleton meant to hold/route global, project-wide signals.

### `Static` (class_name, static utility container)

- `Static.Resources.Default.DEF_AREA_EMITTER_PKG` — default `Package` used by `AreaEmitter`
- `Static.Utility.get_all_global_groups()` — cached list of project global groups
- `Static.Emitters` — debug/warning helpers used internally

## Full docs

See `Docs/GodotLibrary by Rea.odt` and `Docs/documentation.txt` for the original notes.
