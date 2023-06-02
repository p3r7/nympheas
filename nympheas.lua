-- nympheas.
-- @eigen
--


-- ------------------------------------------------------------------------
-- deps

local LilyPad = include("nympheas/lib/object/lily_pad")
local Droplet = include("nympheas/lib/object/droplet")
local Dragonfly = include("nympheas/lib/object/dragonfly")

include("nympheas/lib/core")


-- ------------------------------------------------------------------------
-- state

local NB_LILY_PADS = 4
local lily_pads = {}

local droplets = {}

local NB_DRAGONFLIES = 2
local dragonflies = {}


-- ------------------------------------------------------------------------
-- script lifecycle

local FPS = 15
local RECOMPUTE_PS = 30
local MAX_ATTEMPTS_SPAWN_PADS = 10

local redraw_clock
local recompute_clock

function are_rnd_coord_overlapping_others(x, y, r, objects)
  for _, o in pairs(objects) do
    if circles_colliding(x, y, r, o.x, o.y, o.r) then
      return true
    end
  end
  return false
end

function init()
  screen.aa(1)
  screen.line_width(1)

  for i=1,NB_DRAGONFLIES do
    dragonflies[i] = Dragonfly.new(math.random(128), math.random(64))
  end

  for i=1,NB_LILY_PADS do
    math.random(10)

    local x = math.random(128)
    local y = math.random(64)
    local r = 12 + math.random(3)

    local attempts = 1
    while are_rnd_coord_overlapping_others(x, y, r, lily_pads) and attempts <= MAX_ATTEMPTS_SPAWN_PADS do
      x = math.random(128)
      y = math.random(64)
      attempts = attempts + 1
    end

    if attempts > MAX_ATTEMPTS_SPAWN_PADS then
      break
    end

    lily_pads[i] = LilyPad.new(x, y, r)
  end

  redraw_clock = clock.run(
    function()
      local step_s = 1 / FPS
      while true do
        clock.sleep(step_s)
        redraw()
      end
  end)
  recompute_clock = clock.run(
    function()
      local step_s = 1 / RECOMPUTE_PS
      while true do
        clock.sleep(step_s)
        recompute()
      end
  end)
end

function cleanup()
  clock.cancel(redraw_clock)
end


-- ------------------------------------------------------------------------
-- recompute

function recompute()
  -- srand(os.time())

  for _, lily_pad in pairs(lily_pads) do
    local max_rad = 2 * math.pi
    -- rotate
    lily_pad.rot = lily_pad.rot + max_rad / 1000
    -- modulo, basically
    while lily_pad.rot >= max_rad do
      lily_pad.rot = lily_pad.rot - max_rad
    end

    -- move
    if rnd() < 0.1 then
      local sign = 1
      if rnd() < 0.5 then sign = -1 end
      lily_pad.x = lily_pad.x + sign * rnd() / 2
    end
    if rnd() < 0.1 then
      local sign = 1
      if rnd() < 0.5 then sign = -1 end
      lily_pad.y = lily_pad.y + sign * rnd() / 2
    end
  end

  local nb_droplets = tab.count(droplets)
  for i, droplet in ipairs(droplets) do
    if droplet.v < 800 / nb_droplets then
      droplet.v = droplet.v + 0.3
    else
      table.remove(droplets, i)
    end
  end

  if rnd() < 0.01 then
    table.insert(droplets, Droplet.new(math.random(128 * 2) - 64, math.random(64 * 2) - 32))
  end

  local max_rad = 2 * math.pi
  for _, dragonfly in pairs(dragonflies) do
    dragonfly.x = dragonfly.x + 5 * cos(dragonfly.rot/max_rad)
    dragonfly.y = dragonfly.y + 5 * sin(dragonfly.rot/max_rad) * -1

    if dragonfly.x < -64 or dragonfly.x > (128 + 64) or dragonfly.y < -32 or dragonfly.y > (64 + 32) then
      local new_rot = dragonfly.rot + 2 * rnd(max_rad/10)
      while new_rot >= max_rad do
        new_rot = new_rot - max_rad
      end
      while new_rot < 0 do
        new_rot = new_rot + max_rad
      end
      dragonfly.rot = new_rot
    elseif rnd() < 0.05 then
      local sign = 1
      if rnd() < 0.5 then sign = -1 end
      local new_rot = dragonfly.rot + sign * rnd(max_rad/10)
      while new_rot >= max_rad do
        new_rot = new_rot - max_rad
      end
      while new_rot < 0 do
        new_rot = new_rot + max_rad
      end
      dragonfly.rot = new_rot
    end
  end

end


-- ------------------------------------------------------------------------
-- screen

function redraw()
  screen.clear()

  for i, droplet in ipairs(droplets) do
    droplet:redraw()
  end

  for _, lily_pad in pairs(lily_pads) do
    lily_pad:redraw()
  end

  for _, dragonfly in pairs(dragonflies) do
    dragonfly:redraw()
  end

  screen.update()
end
