/obj/structure/terrain_scanner
	name = "terrain scanner"
	desc = "Сложная блюспейс аппаратура для сканирования местности."
	icon = 'icons/obj/machines/broadcast.dmi'
	icon_state = "broadcaster"
	density = TRUE
	anchored = TRUE
	var/static/list/blacklist
	var/static/list/exceptions

/obj/structure/terrain_scanner/get_ru_names()
	return alist(
		NOMINATIVE = "сканер местности",
		GENITIVE = "сканера местности",
		DATIVE = "сканеру местности",
		ACCUSATIVE = "сканер местности",
		INSTRUMENTAL = "сканером местности",
		PREPOSITIONAL = "сканере местности",
	)

/obj/item/object_scanner
	name = "object scanner"
	desc = "Устройство для сканирования объектов, используйте на сканере местности, чтобы найти объекты, идентичные отсканированному."
	icon = 'icons/obj/device.dmi'
	icon_state = "forensic0"
	w_class = WEIGHT_CLASS_TINY
	var/saved_type

/obj/item/object_scanner/get_ru_names()
	return alist(
		NOMINATIVE = "сканер объектов",
		GENITIVE = "сканера объектов",
		DATIVE = "сканеру объектов",
		ACCUSATIVE = "сканер объектов",
		INSTRUMENTAL = "сканером объектов",
		PREPOSITIONAL = "сканере объектов",
	)

/obj/item/object_scanner/afterattack(atom/target, mob/user, proximity_flag, list/modifiers, status)
	if(target)
		saved_type = target.type
		balloon_alert(user, "сохранено!")
	return

/obj/structure/terrain_scanner/Initialize(mapload)
	. = ..()
	if(!blacklist)
		blacklist = typecacheof(list(
			/obj/item,
			/obj/machinery/atmospherics,
			/obj/structure/cable,
			/mob,
			/obj/structure/sign,
			/obj/machinery/station_map,
			/obj/effect/decal/cleanable,
			/obj/structure/disposalpipe,
			/obj/structure/closet/body_bag,
			/obj/machinery/iv_drip,
			/obj/effect/landmark,
			/obj/effect/decal/ants,
			/obj/effect/countdown,
			/obj/docking_port,
			/obj/effect/decal/straw/medium
		))
	if(!exceptions)
		exceptions = typecacheof(list(
			/obj/machinery/atmospherics/unary/vent_pump,
			/obj/machinery/atmospherics/unary/vent_scrubber,
			/obj/machinery/atmospherics/unary/thermomachine,
			/obj/machinery/atmospherics/unary/cryo_cell
		))

/obj/structure/terrain_scanner/attack_hand(mob/user)
	switch(tgui_alert(user, "Что вы собираетесь сделать?", "Сканер местности", list("Уничтожить все объекты из черного списка", "Получить список уникальных объектов", "Получить карту определенного объекта", "Получить карту турфов", "Получить полный набор карт")))
		if("Уничтожить все объекты из черного списка")
			for(var/turf/turf in RANGE_TURFS(361, src))
				for(var/atom/movable/atom in turf)
					if(is_type_in_typecache(atom.type, blacklist) && !is_type_in_typecache(atom.type, exceptions))
						qdel(atom)
			return
		if("Получить список уникальных объектов")
			var/list/unique_obj
			for(var/turf/turf in RANGE_TURFS(361, src))
				for(var/atom/movable/atom in turf)
					if(is_type_in_typecache(atom.type, blacklist) && !is_type_in_typecache(atom.type, exceptions))
						continue
					if(!unique_obj)
						unique_obj = list(atom.type)
					else
						var/in_list = FALSE
						for(var/obj_type in unique_obj)
							if(istype(atom, obj_type))
								in_list = TRUE
								break
						if(!in_list)
							unique_obj += atom.type
			var/obj/item/paper/paper = new /obj/item/paper (loc)
			paper.name = "Отчет о сканировании (уникальные объекты)"
			for(var/obj_type in unique_obj)
				paper.info += "[obj_type]<br>"
			return
		if("Получить карту определенного объекта")
			new /obj/item/object_scanner (loc)
			return
		if("Получить карту турфов")
			var/list/unique_turfs
			var/output = ""
			for(var/turf/turf in RANGE_TURFS(361, src))
				if(istype(turf, /turf/space))
					continue
				if(!unique_turfs)
					unique_turfs = list(turf.type)
				else
					var/in_list = FALSE
					for(var/turf_type in unique_turfs)
						if(istype(turf, turf_type))
							in_list = TRUE
							break
					if(!in_list)
						unique_turfs += turf.type
			for(var/turf_type in unique_turfs)
				output += "#[turf_type]<br>"
				for(var/turf/turf in RANGE_TURFS(361, src))
					if(istype(turf, turf_type))
						// 0 - dir, 1 - texture
						output += "[turf.x]-[turf.y]-0-1<br>"
			var/obj/item/paper/paper = new /obj/item/paper (loc)
			paper.name = "Отчет о сканировании (турфы)"
			paper.info = output
			paper = new /obj/item/paper (loc)
			paper.name = "Отчет о сканировании (уникальные турфы)"
			for(var/turf_type in unique_turfs)
				paper.info += "[turf_type]<br>"
			return
		if("Получить полный набор карт")
			var/list/unique_turfs
			var/output = ""
			var/list/unique_obj
			for(var/turf/turf in RANGE_TURFS(361, src))
				if(istype(turf, /turf/space))
					continue
				if(!unique_turfs)
					unique_turfs = list(turf.type)
				else
					var/in_list = FALSE
					for(var/turf_type in unique_turfs)
						if(istype(turf, turf_type))
							in_list = TRUE
							break
					if(!in_list)
						unique_turfs += turf.type
				for(var/atom/movable/atom in turf)
					if(is_type_in_typecache(atom.type, blacklist) && !is_type_in_typecache(atom.type, exceptions))
						continue
					if(!unique_obj)
						unique_obj = list(atom.type)
					else
						var/in_list = FALSE
						for(var/obj_type in unique_obj)
							if(istype(atom, obj_type))
								in_list = TRUE
								break
						if(!in_list)
							unique_obj += atom.type
			for(var/turf_type in unique_turfs)
				output += "#[turf_type]<br>"
				for(var/turf/turf in RANGE_TURFS(361, src))
					if(istype(turf, turf_type))
						// 0 - dir, 1 - texture
						output += "[turf.x]-[turf.y]-0-1<br>"
			for(var/obj_type in unique_obj)
				output += "#[obj_type]<br>"
				for(var/turf/turf in RANGE_TURFS(361, src))
					for(var/atom/movable/atom in turf)
						if(is_type_in_typecache(atom.type, blacklist) && !is_type_in_typecache(atom.type, exceptions))
							continue
						if(istype(atom, obj_type))
							// 0 - dir, 1 - texture
							output += "[atom.x]-[atom.y]-0-1<br>"
			var/obj/item/paper/paper = new /obj/item/paper (loc)
			paper.name = "Отчет о сканировании (полный)"
			paper.info = output
			paper = new /obj/item/paper (loc)
			paper.name = "Отчет о сканировании (уникальные турфы)"
			for(var/turf_type in unique_turfs)
				paper.info += "[turf_type]<br>"
			paper = new /obj/item/paper (loc)
			paper.name = "Отчет о сканировании (уникальные объекты)"
			for(var/obj_type in unique_obj)
				paper.info += "[obj_type]<br>"
			return
	return

/obj/structure/terrain_scanner/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/object_scanner))
		var/obj/item/object_scanner/scanner = item
		if(!scanner.saved_type)
			balloon_alert(user, "сохраненных объектов не найдено!")
		else
			var/obj_type = scanner.saved_type
			var/output = "#[obj_type]<br>"
			for(var/turf/turf in RANGE_TURFS(361, src))
				for(var/atom/movable/atom in turf)
					if(is_type_in_typecache(atom.type, blacklist) && !is_type_in_typecache(atom.type, exceptions))
						continue
					if(istype(atom, obj_type))
						// 0 - dir, 1 - texture
						output += "[atom.x]-[atom.y]-0-1<br>"
			var/obj/item/paper/paper = new /obj/item/paper (loc)
			paper.name = "Отчет о сканировании ([obj_type])"
			paper.info = output
	return
