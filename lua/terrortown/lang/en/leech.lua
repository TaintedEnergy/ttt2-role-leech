L = LANG.GetLanguageTableReference("en")

L[LEECH.name] = "Leech"
L["info_popup_" .. LEECH.name] = [[You are a Leech! You must hang around people to survive until the end of the round!]]
L["body_found_" .. LEECH.abbr] = "They were a Leech!"
L["search_role_" .. LEECH.abbr] = "This person was a Leech!"
L["target_" .. LEECH.name] = "Leech"
L["ttt2_desc_" .. LEECH.name] = [[Leech is a neutral role that will die if alone for too long, and wins with the winning team if they remain alive.]]