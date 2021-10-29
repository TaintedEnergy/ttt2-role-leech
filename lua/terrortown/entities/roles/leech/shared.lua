if SERVER then
  AddCSLuaFile()
  resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_leech.vmt")
end

function ROLE:PreInitialize()
  self.color = Color(187, 156, 155, 255)

  self.abbr = "leech"
  self.surviveBonus = 0
  self.scoreKillsMultiplier = 5
  self.scoreTeamKillsMultiplier = -16

  self.defaultEquipment = SPECIAL_EQUIPMENT
  self.defaultTeam = TEAM_NONE

  self.conVarData = {
    pct = 0.17,
    maximum = 1,
    minPlayers = 6,
    togglable = true
  }
end

function ROLE:Initialize()
  if SERVER and JESTER then self.networkRoles = {JESTER} end
end

if SERVER then
  function ROLE:GiveRoleLoadout(ply, isRoleChange)
    ply:SetNWFloat("Leech_Hunger_Level", GetConVar("ttt2_leech_starve_time"):GetFloat())
    ply.leechHungerTime = CurTime() + 0.04
    ply.leechChange = -(GetConVar("ttt2_leech_tick_length"):GetFloat())
  end

  hook.Add("TTT2ModifyWinningAlives", "CheckLeechTeamSwitch", function(alives)
    local winningTeam = ""

    if alives == nil then return end

    -- Check alive teams
    for i in pairs(alives) do
      local t = alives[i]
      if winningTeam != "" and winningTeam != t then return end
      winningTeam = t
    end

    if winningTeam == "" then return end
 
    -- Find any Leechs that arn't feeding and prevent a win
    for _, ply in ipairs(player.GetAll()) do
      if not IsValid(ply) or not ply:Alive() then continue end
			if SpecDM and (ply.IsGhost and ply:IsGhost() or (vics.IsGhost and vics:IsGhost())) then continue end

      if ply:GetSubRole() == ROLE_LEECH and ply.leechChange < 0 then
        table.insert(alives, "leech")
        return
      end
    end

  -- Find all Leechs and turn them to the winning team
    for _, ply in ipairs(player.GetAll()) do
      if not IsValid(ply) or not ply:Alive() then continue end
			if SpecDM and (ply.IsGhost and ply:IsGhost() or (vics.IsGhost and vics:IsGhost())) then continue end

      if ply:GetSubRole() == ROLE_LEECH and ply.leechChange >= 0 then
        ply:UpdateTeam(winningTeam, false)
      end
    end
  end)

  hook.Add("Think", "LeechHungerThink", function()
    if GetRoundState() ~= ROUND_ACTIVE then return end

    -- Get all viable host positions
    local hostPoses = {}

    for _, ply in ipairs(player.GetAll()) do
      if not IsValid(ply) or not ply:Alive() or ply:IsSpec() then continue end
			if SpecDM and (ply.IsGhost and ply:IsGhost() or (vics.IsGhost and vics:IsGhost())) then continue end
      if ply:GetSubRole() == ROLE_LEECH then continue end

      table.insert(hostPoses, ply:GetPos())
    end

    -- Foreach leech
    for _, ply in ipairs(player.GetAll()) do
      if not IsValid(ply) or not ply:Alive() or ply:IsSpec() then continue end
			if SpecDM and (ply.IsGhost and ply:IsGhost() or (vics.IsGhost and vics:IsGhost())) then continue end
      if ply:GetSubRole() ~= ROLE_LEECH then continue end

      if not ply.leechHungerTime then ply.leechHungerTime = CurTime() + GetConVar("ttt2_leech_tick_length"):GetFloat() end

      local closestDistance = 1000000.0
      for i, hostPos in ipairs(hostPoses) do
        if ply:GetPos():DistToSqr(hostPos) < closestDistance then closestDistance = ply:GetPos():DistToSqr(hostPos) end
      end

      if ply.leechHungerTime <= CurTime() then
         ply.leechChange = -(GetConVar("ttt2_leech_tick_length"):GetFloat())
        if closestDistance < GetConVar("ttt2_leech_refill_radius"):GetFloat() then
          ply.leechChange = GetConVar("ttt2_leech_tick_length"):GetFloat() * GetConVar("ttt2_leech_refill_multiplier"):GetFloat()
        end

        ply:SetNWFloat("Leech_Hunger_Level", math.Clamp(ply:GetNWFloat("Leech_Hunger_Level", 0) + ply.leechChange, 0, GetConVar("ttt2_leech_starve_time"):GetFloat()))

        if ply:GetNWFloat("Leech_Hunger_Level") > 0 then
            ply.leechHungerTime = CurTime() + GetConVar("ttt2_leech_tick_length"):GetFloat()
        else
            ply:Kill()
        end
      end
    end
  end)
end