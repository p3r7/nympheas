-- nympheas/dragonfly


-- ------------------------------------------------------------------------
-- deps

include("nympheas/lib/core")


-- ------------------------------------------------------------------------

local Dragonfly = {}
Dragonfly.__index = Dragonfly


-- ------------------------------------------------------------------------
-- constructors

function Dragonfly.new(x, y, radius)
  local p = setmetatable({}, Dragonfly)

  p.x = x
  p.y = y
  p.is_flying = true

  p.rot = rnd(2 * math.pi) -- rotation, in radians

  p.frame = 1

  return p
end


-- ------------------------------------------------------------------------
-- screen

function Dragonfly:redraw()

  local BODY_LEN = 15
  local WING_LEN = 10
  local HEAD_R = 1.5

  local max_rad = 2 * math.pi
  local start_x = self.x + BODY_LEN * cos(self.rot/max_rad) * -1
  local start_y = self.y + BODY_LEN * sin(self.rot/max_rad)

  -- abbodmen
  screen.level(12)
  screen.move(self.x, self.y)
  screen.line(start_x, start_y)
  screen.stroke()

  -- head
  screen.move(self.x+HEAD_R, self.y)
  screen.circle(self.x, self.y, HEAD_R)
  screen.fill()

  -- wings
  screen.level(6)
  screen.line_width(2.5)
  local w_start_x = self.x + HEAD_R * 3 * cos(self.rot/max_rad) * -1
  local w_start_y = self.y + HEAD_R * 3 * sin(self.rot/max_rad)

  local wing_pos = {25, 15}
  if mod1(self.frame, 2) == 2 then
    wing_pos = {30, 35}
  end

  for _, angle in pairs(wing_pos) do
    local rad = (self.rot + (angle * max_rad/ 100))
    while rad >= max_rad do
      rad = rad - max_rad
    end

    local w_end_x = self.x + WING_LEN * cos(rad/max_rad) * -1
    local w_end_y = self.y + WING_LEN * sin(rad/max_rad)

    screen.move(w_start_x, w_start_y)
    screen.line(w_end_x, w_end_y)
    screen.stroke()

    w_end_x = self.x + WING_LEN * cos(rad/max_rad)
    w_end_y = self.y + WING_LEN * sin(rad/max_rad) * -1

    screen.move(w_start_x, w_start_y)
    screen.line(w_end_x, w_end_y)
    screen.stroke()
  end

  self.frame = self.frame + 1

  screen.line_width(1)


end

-- ------------------------------------------------------------------------

return Dragonfly
