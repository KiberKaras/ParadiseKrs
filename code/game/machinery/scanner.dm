/obj/machinery/location_scanner
	name = "terrain scanner"
	desc = "Сложная блюспейс аппаратура для сканирования местности."
  icon = "icons/obj/machines/broadcast.dmi"
	icon_state = "broadcaster"
	density = TRUE
	idle_power_usage = 0
	active_power_usage = 0
	anchored = TRUE
  var in_work = FALSE

/obj/machinery/location_scanner/get_ru_names()
	return alist(
		NOMINATIVE = "сканер местности",
		GENITIVE = "сканера местности",
		DATIVE = "сканеру местности",
		ACCUSATIVE = "сканер местности",
		INSTRUMENTAL = "сканером местности",
		PREPOSITIONAL = "сканере местности",
	)

/obj/machinery/location_scanner/attack_hand(mob/user)
  if(in_work)
    balloon_alert(user, "уже работает!")
    return
  switch(tgui_alert(user, "Что вы собираетесь сделать?", "Уничтожить все объекты из черного списка", "Получить список уникальных объектов", "Получить карту определенного объекта", "Получить карту стен и полов", "Получить полный набор карт", "отмена")))
			if("Уничтожить все объекты из черного списка")
				balloon_alert(user, "еще не реалиовано!")
        return
			if("Получить список уникальных объектов")
				balloon_alert(user, "еще не реалиовано!")
        return
			if("Получить карту определенного объекта")
				balloon_alert(user, "еще не реалиовано!")
        return
			if("Получить карту стен и полов")
        balloon_alert(user, "еще не реалиовано!")
        return
      if("Получить полный набор карт")
        balloon_alert(user, "еще не реалиовано!")
        return
      if("отмена")
        return
