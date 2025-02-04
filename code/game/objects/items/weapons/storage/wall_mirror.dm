//wip wip wup

//#TODO: Should definitely be a structure!
/obj/item/storage/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) mirror! The leading brand in hair salon products, utilizing nano-machinery to style your hair just right. The black box inside warns against attempting to release the nanomachines."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	use_sound = 'sound/effects/closet_open.ogg'
	material = /decl/material/solid/glass
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY)
	var/shattered = 0
	var/list/ui_users

	startswith = list(
		/obj/item/haircomb/random,
		/obj/item/haircomb/brush,
		/obj/random/medical/lite,
		/obj/item/lipstick,
		/obj/random/lipstick,
		/obj/random/soap,
		/obj/item/chems/spray/cleaner/deodorant,
		/obj/item/towel/random)
	directional_offset = "{'NORTH':{'y':-29}, 'SOUTH':{'y':29}, 'EAST':{'x':29}, 'WEST':{'x':-29}}"
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

/obj/item/storage/mirror/handle_mouse_drop(atom/over, mob/user)
	. = ..()
	if(.)
		flick("mirror_open",src)

/obj/item/storage/mirror/attack_hand(mob/user)
	use_mirror(user)

/obj/item/storage/mirror/proc/use_mirror(var/mob/living/carbon/human/user)
	if(shattered)
		to_chat(user, SPAN_WARNING("You enter the key combination for the style you want on the panel, but the nanomachines inside \the [src] refuse to come out."))
		return
	open_mirror_ui(user, ui_users, "SalonPro Nano-Mirror&trade;", mirror = src)

/obj/item/storage/mirror/shatter()
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"

/obj/item/storage/mirror/bullet_act(var/obj/item/projectile/Proj)

	if(prob(Proj.get_structure_damage() * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()

/obj/item/storage/mirror/attackby(obj/item/W, mob/user)
	if(!(. = ..()))
		return
	flick("mirror_open",src)
	if(prob(W.force) && (user.a_intent == I_HURT))
		visible_message("<span class='warning'>[user] smashes [src] with \the [W]!</span>")
		if(!shattered)
			shatter()

/obj/item/storage/mirror/Destroy()
	clear_ui_users(ui_users)
	. = ..()

/obj/item/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! Now a portable version."
	icon = 'icons/obj/items/mirror.dmi'
	icon_state = "mirror"
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_SECONDARY, 
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY
	)
	var/list/ui_users

/obj/item/mirror/attack_self(mob/user)
	open_mirror_ui(user, ui_users, "SalonPro Nano-Mirror&trade;", APPEARANCE_HAIR, src)

/obj/item/mirror/Destroy()
	clear_ui_users(ui_users)
	. = ..()

/proc/open_mirror_ui(var/mob/user, var/ui_users, var/title, var/flags, var/obj/item/mirror)
	if(!ishuman(user))
		return

	var/W = weakref(user)
	var/datum/nano_module/appearance_changer/AC = LAZYACCESS(ui_users, W)
	if(!AC)
		AC = new(mirror, user)
		AC.name = title
		if(flags)
			AC.flags = flags
		LAZYSET(ui_users, W, AC)
	AC.ui_interact(user)

/proc/clear_ui_users(var/list/ui_users)
	for(var/W in ui_users)
		var/AC = ui_users[W]
		qdel(AC)
	LAZYCLEARLIST(ui_users)
