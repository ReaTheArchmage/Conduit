# Conduit

A small signal-emission and connection system for Godot 4.8+.

Enable the plugin in **Project Settings → Plugins** — that's it. On enable,
Conduit scans its own folder, registers `Emitter` and `AreaEmitter` as
custom node types, and adds `SignalBus` as an autoload. If the addon was
installed under the wrong path, or a script is missing, you'll get a clear
error or warning instead of a silent failure.

## Classes

### `Emitter` (extends `Node`)
Base class for connecting and emitting signals.

- `signal_registry: Package` — Used for couples to connect on ready. (in Package.couples)
- `enable_connections: bool` — auto-run `connect_couples()` on ready.
- `connect_couples(pkg: Package) -> bool` — connects each `{signal: method}` couple in `pkg.couples`, across `self` and `SignalBus`.
- `group_emit(signals, args, looped, delay_duration = 2.0)` — emits a group of signals
(local → `SignalBus` → `default_emitter_signal`, in that order), optionally looping on a delay.

### `AreaEmitter` (extends `Emitter`)
Attach to an `Area3D` and connect its `area_entered`/`area_exited` signals
to `_on_area_entered`/`_on_area_exited`. Emits `area_in_group(area)` when an
entering area belongs to `group_to_check`.

- `group_to_check: String` — required group for a match.
- `connect_area_signals: bool` (default `true`) — auto-connects internal signals (area_entered and area exited)
on ready if `group_to_check` is a valid global group; warns and skips otherwise. 

### `Package` (extends `Resource`)
- `couples: Dictionary[StringName, StringName]` — `{signal: method}` pairs.
- `content: Dictionary[StringName, Variant]` — free-form payload data.

### `SignalBus` (autoload)
Empty `Node` singleton for routing global, project-wide signals.

### `Static`
- `Static.Resources.Default.DEF_AREA_EMITTER_PKG` — default package for `AreaEmitter`.
- `Static.Resources.Default.DEF_EMPTY_PACKAGE` — default (empty) package for `Emitter`.
- `Static.Utility.get_all_global_groups()` — cached list of project global groups.
