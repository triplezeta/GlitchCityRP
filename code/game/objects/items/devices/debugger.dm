/**
 * Multitool -- A multitool is used for hacking electronic devices.
 * TO-DO -- Using it as a power measurement tool for cables etc. Nannek.
 *
 */

/obj/item/debugger
	name = "debugger"
	desc = "Used to debug electronic equipment."
	icon = 'icons/obj/hacktool.dmi'
	icon_state = "hacktool-g"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 5.0
	w_class = ITEM_SIZE_SMALL
	throwforce = 5
	throw_range = 15
	throw_speed = 3
	desc = "You can use this on airlocks or APCs to try to hack them without cutting wires."

	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/fiberglass = MATTER_AMOUNT_TRACE
	)

	origin_tech = "{'magnets':1,'engineering':1}"

/obj/item/debugger/is_used_on(obj/O, mob/user)
	if(istype(O, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = O
		if(A.emagged || A.hacker)
			to_chat(user, "<span class='warning'>There is a software error with the device.</span>")
		else
			to_chat(user, "<span class='notice'>The device's software appears to be fine.</span>")
		return 1
	if(istype(O, /obj/machinery/door))
		var/obj/machinery/door/D = O
		if(D.operating == -1)
			to_chat(user, "<span class='warning'>There is a software error with the device.</span>")
		else
			to_chat(user, "<span class='notice'>The device's software appears to be fine.</span>")
		return 1
	else if(istype(O, /obj/machinery))
		var/obj/machinery/A = O
		if(A.emagged)
			to_chat(user, "<span class='warning'>There is a software error with the device.</span>")
		else
			to_chat(user, "<span class='notice'>The device's software appears to be fine.</span>")
		return 1
