local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then -- CLIENT
  local pad = 7 -- padding
  local iconSize = 64

  local const_defaults = {
    basepos = {x = 0, y = 0},
    size = {w = 365, h = 32},
    minsize = {w = 225, h = 32}
  }

  function HUDELEMENT:PreInitialize()
    BaseClass.PreInitialize(self)

    local hud = huds.GetStored("pure_skin")
		if hud then
			hud:ForceElement(self.id)
		end

		-- set as fallback default, other skins have to be set to true!
		self.disabledUnlessForced = false
  end

  function HUDELEMENT:Initialize()
    self.scale = 1.0
    self.basecolor = self:GetHUDBasecolor()
    self.pad = pad
    self.iconSize = iconSize

    BaseClass.Initialize(self)
  end

  -- parameter overwrites
  function HUDELEMENT:IsResizable()
    return true, false
  end
  -- parameter overwrites end

  function HUDELEMENT:GetDefaults()
    const_defaults["basepos"] = {
      x = 10 * self.scale,
      y = ScrH() - self.size.h - 146 * self.scale - self.pad - 10 * self.scale
    }

    return const_defaults
  end

  function HUDELEMENT:PerformLayout()
    self.scale = self:GetHUDScale()
    self.basecolor = self:GetHUDBasecolor()
    self.iconSize = iconSize * self.scale
    self.pad = pad * self.scale

    BaseClass.PerformLayout(self)
  end

  function HUDELEMENT:DrawComponent(multiplier, col, text)
    multiplier = multiplier or 1

    local pos = self:GetPos()
    local size = self:GetSize()
    local x, y = pos.x, pos.y
    local w, h = size.w, size.h

    self:DrawBg(x, y, w, h, self.basecolor)

    -- draw bar
    self:DrawBar(x + pad, y + pad, w - pad * 2, h - pad * 2, col, multiplier, scale, text)

    self:DrawLines(x, y, w, h, self.basecolor.a)
  end

  function HUDELEMENT:ShouldDraw()
    local client = LocalPlayer()

    return IsValid(client)
  end

  function HUDELEMENT:Draw()
    local client = LocalPlayer()
    local multiplier

    local color = Color(255,0,0,255)

    if client:IsActive() and client:Alive() and client:GetSubRole() == ROLE_LEECH then
      if client:GetNWFloat("Leech_Hunger_Level", 0) > 0 then
        local leechHungerTime = client:GetNWFloat("Leech_Hunger_Level", 0)
        local delay = GetConVar("ttt2_leech_starve_time"):GetFloat()

        multiplier = leechHungerTime / delay

        local secondColor = Color(0,255,0,255)
        local r = color.r - (color.r - secondColor.r) * multiplier
        local g = color.g - (color.g - secondColor.g) * multiplier
        local b = color.b - (color.b - secondColor.b) * multiplier

        color = Color(r, g, b, 255)
      else
        multiplier = 0
      end
    end

    if HUDEditor.IsEditing then
      self:DrawComponent(1, color)
    elseif multiplier then
      self:DrawComponent(multiplier, color, true and "")
    end
  end
end
