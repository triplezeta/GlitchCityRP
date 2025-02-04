/decl/codex_category/languages
	name = "Languages"
	desc = "Languages spoken in known space."

/decl/codex_category/languages/Populate()
	var/example_line = "This is just some random words. What did you expect here? Hah hah!"
	var/language_types = decls_repository.get_decls_of_subtype(/decl/language)
	for(var/langname in language_types)
		var/decl/language/L = language_types[langname]
		if(L.hidden_from_codex)
			continue
		var/list/lang_info = list()
		var/decl/prefix/P = /decl/prefix/language
		lang_info += "Key to use it: '[initial(P.default_key)][L.key]'"
		if(L.flags & NONVERBAL)
			lang_info += "It has a significant non-verbal component. Speech is garbled without line-of-sight."
		if(L.flags & SIGNLANG)
			lang_info += "It is completely non-verbal, using gestures or signs to communicate."
		if(L.flags & HIVEMIND)
			lang_info += "It's a 'hivemind' language, broadcast to all creatures who understand it."
		if(L.flags & NO_STUTTER)
			lang_info += "It will not be affected by speech impediments."

		var/list/lang_lore = list(L.desc)
		lang_lore += "Shorthand: '[L.shorthand]'"
		if(!(L.flags & (SIGNLANG|NONVERBAL|HIVEMIND)))
			var/lang_example = L.format_message(L.scramble(null, example_line), L.speech_verb)
			lang_lore += "It sounds like this:"
			lang_lore += ""
			lang_lore += "<b>CodexBot</b> [lang_example]"

		var/datum/codex_entry/entry = new(
			_display_name = "[L.name] (language)",
			_lore_text = jointext(lang_lore, "<br>"),
			_mechanics_text = jointext(lang_info, "<br>")
		)
		items |= entry.name

	. = ..()