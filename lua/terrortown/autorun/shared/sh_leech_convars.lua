CreateConVar("ttt2_leech_refill_radius", 50000.0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_leech_refill_multiplier", 5.0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_leech_starve_time", 30.0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_leech_tick_length", 0.02, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_leech_convars", function(tbl)
  tbl[ROLE_LEECH] = tbl[ROLE_LEECH] or {}

  table.insert(tbl[ROLE_LEECH], {
      cvar = "ttt2_leech_refill_radius",
      slider = true,
      min = 0,
      max = 1000000,
      decimal = 1,
      desc = "ttt2_leech_refill_radius (def. 50000.0)"
  })

  table.insert(tbl[ROLE_LEECH], {
      cvar = "ttt2_leech_refill_multiplier",
      slider = true,
      min = 0,
      max = 100,
      decimal = 1,
      desc = "ttt2_leech_refill_multiplier (def. 5.0)"
  })

  table.insert(tbl[ROLE_LEECH], {
      cvar = "ttt2_leech_starve_time",
      slider = true,
      min = 0,
      max = 600,
      decimal = 1,
      desc = "ttt2_leech_starve_time (def. 30.0)"
  })

  table.insert(tbl[ROLE_LEECH], {
      cvar = "ttt2_leech_tick_length",
      slider = true,
      min = 0,
      max = 1,
      decimal = 1,
      desc = "ttt2_leech_tick_length (def. 0.02)"
  })
end)
