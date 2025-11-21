local Vector2 = {}
Vector2.__index = Vector2

function Vector2.new(x,y)
    local v = setmetatable({}, Vector2)
    v.x = x or 0
    v.y = y or 0
    return v
end

function Vector2.one()
    return Vector2.new(1, 1)
end

function Vector2.zero()
    return Vector2.new(0, 0)
end

function Vector2:Magnitude()
    return math.sqrt(self.x^2 + self.y^2)
end

function Vector2:Unit()
    return self / self:Magnitude()
end

function Vector2:Dot(v)
    return self.x * v.x + self.y * v.y
end


Vector2.__mul = function(a, b)
    if type(b) == "number" then
        return Vector2.new(a.x * b, a.y * b)
    elseif type(a) == "number" then
        return Vector2.new(a * b.x, a * b.y)
    else
        error("Invalid Multiplication")
    end
end

Vector2.__div = function(a, b)
    if type(b) == "number" then
        return Vector2.new(a.x / b, a.y / b)
    elseif type(a) == "number" then
        return Vector2.new(a / b.x, a / b.y)
    else
        error("Invalid Division")
    end
end

Vector2.__add = function(a, b)
    if type(a) == "number" and getmetatable(b) == Vector2 then
        return Vector2.new(a + b.x, a + b.y)
    elseif type(b) == "number" and getmetatable(a) == Vector2 then
        return Vector2.new(a.x + b, a.y + b)
    elseif getmetatable(a) == Vector2 and getmetatable(b) == Vector2 then
        return Vector2.new(a.x + b.x, a.y + b.y)
    else
        error("Invalid Addition")
    end
end

Vector2.__sub = function(a, b)
    if type(a) == "number" and getmetatable(b) == Vector2 then
        return Vector2.new(a - b.x, a - b.y)
    elseif type(b) == "number" and getmetatable(a) == Vector2 then
        return Vector2.new(a.x - b, a.y - b)
    elseif getmetatable(a) == Vector2 and getmetatable(b) == Vector2 then
        return Vector2.new(a.x - b.x, a.y - b.y)
    else
        error("Invalid Subtraction")
    end
end

function Vector2.__unm(a)
    return Vector2.new(-a.x, -a.y)
end

Vector2.__tostring = function(self)
    return tostring(self.x)..", "..tostring(self.y)
end

return Vector2