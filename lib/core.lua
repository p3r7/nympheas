
-- ------------------------------------------------------------------------
-- math

function round(v)
  return math.floor(v+0.5)
end

function rnd(x)
  if x == 0 then
    return 0
  end
  if (not x) then
    x = 1
  end
  x = round(x * 100000)
  x = math.random(x) / 100000
  return x
end

function srand(x)
  if not x then
    x = 0
  end
  math.randomseed(x)
end

function cos(x)
  return math.cos(math.rad(x * 360))
end

function sin(x)
  return -math.sin(math.rad(x * 360))
end

-- base1 modulo
function mod1(v, m)
  return ((v - 1) % m) + 1
end

function mean(t)
  local sum = 0
  local count= 0
  for _, v in pairs(t) do
    sum = sum + v
    count = count + 1
  end
  return (sum / count)
end

function sum(t)
  local sum = 0
  for _, v in pairs(t) do
    sum = sum + v
  end
  return sum
end

function circles_center_dist(x1, y1, x2, y2)
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt(dx^2 + dy^2)
end

function circles_colliding(x1, y1, r1, x2, y2, r2)
  local dcenters = circles_center_dist(x1, y1, x2, y2)
  return ( dcenters <= (r1 + r2) )
end
