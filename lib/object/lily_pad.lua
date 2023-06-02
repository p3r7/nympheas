-- nympheas/lily_pad


-- ------------------------------------------------------------------------
-- deps

include("nympheas/lib/core")


-- ------------------------------------------------------------------------

local LilyPad = {}
LilyPad.__index = LilyPad


-- ------------------------------------------------------------------------
-- constructors

function LilyPad.new(x, y, radius)
  local p = setmetatable({}, LilyPad)

  p.x = x
  p.y = y
  p.r = radius

  p.split_pct = math.floor(2 + rnd(8))
  p.rot = rnd(2 * math.pi) -- rotation, in radians

  return p
end


-- ------------------------------------------------------------------------
-- screen

function LilyPad:redraw()

  -- local x = round(self.x)
  -- local y = round(self.y)
  local x = self.x
  local y = self.y

  local max_rad = 2 * math.pi
  local rad = max_rad - (self.split_pct * max_rad / 100)

  local arc_start_x = x + self.r * cos(self.rot/max_rad)
  local arc_start_y = y + self.r * sin(self.rot/max_rad) * -1

  local arc_mid_x = x + self.r * cos((self.rot+rad/2)/max_rad)
  local arc_mid_y = y + self.r * sin((self.rot+rad/2)/max_rad) * -1

  -- local arc_end_x = self.x + self.r * cos(rad/max_rad) * -1
  -- local arc_end_y = self.y + self.r * sin(rad/max_rad)

  screen.level(0)
  screen.move(x, y)
  screen.line(arc_start_x, arc_start_y)
  screen.arc(x, y, self.r, 0 + self.rot, rad + self.rot)
  screen.line(x, y)
  screen.fill()

  screen.level(10)

  screen.move(x, y)
  screen.line(arc_start_x, arc_start_y)
  screen.arc(x, y, self.r, 0 + self.rot, rad + self.rot)
  screen.line(x, y)
  screen.stroke()

  screen.level(2)
  screen.move(x, y)
  screen.line(arc_mid_x, arc_mid_y)

  screen.stroke()

end

-- ------------------------------------------------------------------------

return LilyPad
