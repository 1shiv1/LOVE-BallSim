local particle = require("Particle")
local Vector2 = require("Vector2")
local cfg = require("cfg")
local utils = require("utils")

local ActiveParticles = {}

math.randomseed(os.time())

local WinWidth = cfg.window.width
local WinHeight = cfg.window.height

local function sleep(seconds)
    local start_time = os.clock()
    while os.clock() - start_time < seconds do
        -- busy-wait
    end
end

function love.load()
    love.window.setMode(WinWidth, WinHeight, {resizable=false, vsync=true})
    love.window.setTitle(cfg.window.title)

    for i = 1, cfg.general.particleCount do
        local p = particle.new(
            Vector2.new(math.random(0,WinWidth), math.random(0,WinHeight)),
            7,
            Vector2.new((math.random(0,15)-7.5),(math.random(0,15)-7.5)),
            0.6,
            false
        )
        table.insert(ActiveParticles, p)
    end
end

local function NarrowPhase(a, b)
    local dist = (a.Position - b.Position):Magnitude()
    local radiusSum = a.radius + b.radius
    return dist < radiusSum
end


local function inMouse()
    local affected = {}
    local x, y = love.mouse.getPosition()

    for _, p in pairs(ActiveParticles) do
        local r = 110
        local dx = p.Position.x - x
        local dy = p.Position.y - y
        local distanceSquared = dx * dx + dy * dy

        if distanceSquared <= r * r then
            table.insert(affected, p)
        end
    end

    return affected
end

local function MousePushPull(factor)
    local x, y = love.mouse.getPosition()
    local affected = inMouse()

    for _, p in pairs(affected) do 
        local r = 110
        local dx = p.Position.x - x
        local dy = p.Position.y - y
        local distanceSquared = dx * dx + dy * dy

        if distanceSquared <= r * r then
            p.Velocity = Vector2.new(dx/factor,dy/factor)
            p.AttMouse = true
        end
    end
end

local function Uncollide(a, b, n)
    local aP = a.Position
    local bP = b.Position

    local rSum = a.radius+b.radius

    local v = bP - aP --vector between both balls
    local d = v:Magnitude() --distance
    local o = rSum-d --overlap
    local s = v * (o/d)

    a.Position = a.Position + (-s * a.radius /rSum)
    b.Position = b.Position + (s * b.radius /rSum)
end

local function CollisionChecks(a, b, dt)
    if NarrowPhase(a, b) then
        a.Color = {0,0,1}
        b.Color = {0,0,1}

        local n = (a.Position - b.Position):Unit()
        local vRel = a.Velocity - b.Velocity
        local proj = vRel:Dot(n)
        
        Uncollide(a, b, n)

        a.Velocity = a.Velocity - n * proj * (a.Elasticity)
        b.Velocity = b.Velocity + n * proj * (b.Elasticity)
    end
end

local function PerParticleCheck(particle, dt)
    for i = 1, #ActiveParticles do --for every object in cells
        local a = ActiveParticles[i] --object in cells
        for j = i + 1, #ActiveParticles do 
            local b = ActiveParticles[j] 
            CollisionChecks(a,b,dt)
        end
    end
end



function love.update(dt)
    for _, p in pairs(ActiveParticles) do
        p:Update(dt)
        PerParticleCheck(p, dt)
    end

    if love.mouse.isDown(1) then  -- 1 = left, 2 = right, 3 = middle
        MousePushPull(-10)
    end

    if love.mouse.isDown(2) then
        MousePushPull(15)
    end
end

function love.draw()
    local x, y = love.mouse.getPosition()

    for _, p in pairs(ActiveParticles) do
        p:Draw()
    end

    for _, p in pairs(ActiveParticles) do
        if p.AttMouse then
            local x, y = love.mouse.getPosition()
            love.graphics.setColor(1,0.5,0)
            love.graphics.line(x, y, p.Position.x, p.Position.y)
        end
        p.AttMouse = false
    end

    love.graphics.setColor(1,0.4,0,0.25)
    love.graphics.circle("fill", x, y, 110)
end