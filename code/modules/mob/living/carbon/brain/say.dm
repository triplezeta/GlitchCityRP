//TODO: Convert this over for languages.
/mob/living/carbon/brain/say(var/message)
	if(HAS_STATUS(src, STAT_SILENCE))
		return

	message = sanitize(message)

	if(!(container && istype(container, /obj/item/mmi)))
		return //No MMI, can't speak, bucko./N
	else
		var/decl/language/speaking = parse_language(message)
		if(speaking)
			message = copytext(message, 2+length(speaking.key))
		var/verb = "says"
		var/ending = copytext(message, length(message))
		if (speaking)
			verb = speaking.get_spoken_verb(src, ending)
		else
			if(ending=="!")
				verb=pick("exclaims","shouts","yells")
			if(ending=="?")
				verb="asks"

		if(prob(emp_damage*4))
			if(prob(10))//10% chane to drop the message entirely
				return
			else
				message = Gibberish(message, (emp_damage*6))//scrambles the message, gets worse when emp_damage is higher

		if(speaking && speaking.flags & HIVEMIND)
			speaking.broadcast(src,trim(message))
			return

		if(istype(container, /obj/item/mmi/radio_enabled))
			var/obj/item/mmi/radio_enabled/R = container
			if(R.radio)
				spawn(0) R.radio.hear_talk(src, sanitize(message), verb, speaking)
		..(trim(message), speaking, verb)
