## Container of all static data/fuctions. Divided in subclasses.
class_name Static extends Node

class Resources:
	## Default resources used by classes.
	class Default:
		const DEF_AREA_EMITTER_PKG   =    preload("uid://02wucdaons1k")   
		const DEF_EMPTY_PACKAGE      =    preload("uid://ccyfk0fdt8nhq")

class Utility:

	const GLOBAL_GROUP_PREFIX := "global_group/"
	static var _global_groups_cache: PackedStringArray = []

	## Returns an array of all the global groups in the project and caches it.
	static func get_all_global_groups() -> PackedStringArray:
		var current_groups: PackedStringArray = []

		for prop in ProjectSettings.get_property_list():
			var _name: String = prop.name
			if _name.begins_with(GLOBAL_GROUP_PREFIX):
				current_groups.append(_name.substr(GLOBAL_GROUP_PREFIX.length()))
	
		if current_groups == _global_groups_cache:
			return _global_groups_cache
	
		for group in current_groups:
			if group not in _global_groups_cache:
				_global_groups_cache.append(group)
	
		return _global_groups_cache
