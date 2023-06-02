-- nympheas/droplet


-- ------------------------------------------------------------------------
-- deps

include("nympheas/lib/core")


-- ------------------------------------------------------------------------

local Droplet = {}
Droplet.__index = Droplet


-- ------------------------------------------------------------------------
-- constructors

function Droplet.new(x, y)
  local p = setmetatable({}, Droplet)

  p.x = x
  p.y = y

  p.v = 1

  return p
end


-- ------------------------------------------------------------------------
-- screen

function Droplet:redraw()

  screen.level(2)

  local r = self.v

  screen.move(self.x + r, self.y)

  screen.circle(self.x, self.y, r)
  screen.stroke()

  if mod1(r, 4) then
    screen.circle(self.x, self.y, r/2)
    screen.stroke()
  end
  if mod1(r, 2) then
    screen.circle(self.x, self.y, r/4)
    screen.stroke()
    screen.circle(self.x, self.y, 3*r/4)
    screen.stroke()
  end

end

-- ------------------------------------------------------------------------

return Droplet
