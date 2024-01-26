L = LANG.GetLanguageTableReference("en")

L[LEECH.name] = "Leech"
L["info_popup_" .. LEECH.name] = [[You are a Leech! You must hang around people to survive until the end of the round!]]
L["body_found_" .. LEECH.abbr] = "They were a Leech!"
L["search_role_" .. LEECH.abbr] = "This person was a Leech!"
L["target_" .. LEECH.name] = "Leech"
L["ttt2_desc_" .. LEECH.name] = [[Leech is a neutral role that will die if alone for too long, and wins with the winning team if they remain alive.]]

L.label_ttt2_leech_refill_radius = "Refill Radius"
L.desc_ttt2_leech_refill_radius = "The maximum (squared) distance a player can be from a Leech to prevent starving."
L.label_ttt2_leech_refill_multiplier = "Refill Multiplier"
L.desc_ttt2_leech_refill_multiplier = "The how much hunger is satiated every tick. This is a factor of the \"Hunger Tick Length\"."
L.label_ttt2_leech_starve_time = "Starve Time"
L.desc_ttt2_leech_starve_time = "The duration of time that a Leech can remain isolated before taking health damage."
L.label_ttt2_leech_tick_length = "Hunger Tick Length"
L.desc_ttt2_leech_tick_length = "The amount of time that passes between each hunger check."