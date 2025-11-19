local utils = {}

local Vector2 = require("Vector2")

local function clamp(v, min, max)  
    if v > max then
        v = max
    elseif v < min then
        v = min
    end
    return v
end

function utils.MergeArryInto(t1, t2) --takes t2 into t1
    t1 = t1 or {}
    t2 = t2 or {}

    for key, value in pairs(t2) do
        t1[key] = value
    end
    return t1
end

function utils.Clamp(v, min, max)
    if not v then error("NIL VALUE PASSED TO CLAMP"); return end
    
    if type(v) == "number" then
        return clamp(v, min, max)
    elseif getmetatable(v) == Vector2 then
        local xv = v.x
        local yv = v.y
        return Vector2.new(
            clamp(xv, min, max),
            clamp(yv, min, max)
        )
    else
        error("Invalid clamp value type!")
    end
end


return utils