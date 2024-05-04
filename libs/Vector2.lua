---@module 'Vector2'


local mathx = require 'mathx'

---@class V2
---@operator call: Vector2
local Vector2 = {}

---Representation of a 2D vector and point.
---@class Vector2
---@field private __index Vector2
---@field x number The x component.
---@field y number The y component.
---@operator add(Vector2): Vector2
---@operator sub(Vector2): Vector2
---@operator mul(Vector2 | number): Vector2
---@operator div(Vector2 | number): Vector2
---@operator unm(): Vector2
---@operator eq(Vector2): boolean
---@operator concat(Vector2): string
---@operator tostring(): string
local Vector2Meta = {}
Vector2Meta.__index = Vector2Meta

--- Creates a new Vector2 object.
---@param x? number The x component.
---@param y? number The y component.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2.new(x, y)
    local vector2 = {
        x = x or 0,
        y = y or 0
    }

    setmetatable(vector2, Vector2Meta)

    return vector2
end

setmetatable(Vector2, {
    __call = function(_, x, y)
        return Vector2.new(x, y)
    end,
})


--- Returns a Vector2 object with x and y components set to 1.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2.one() return Vector2(1, 1) end

--- Returns a Vector2 object with x and y components set to 0.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2.zero() return Vector2(0, 0) end

--- Returns a Vector2 object with x component set to 0 and y component set to -1.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2.up() return Vector2(0, -1) end

--- Returns a Vector2 object with x component set to 0 and y component set to 1.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2.down() return Vector2(0, 1) end

--- Returns a Vector2 object with x component set to -1 and y component set to 0.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2.left() return Vector2(-1, 0) end

--- Returns a Vector2 object with x component set to 1 and y component set to 0.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2.right() return Vector2(1, 0) end

--- Returns a Vector2 object with x and y components set to -math.huge.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2.negativeInfinity() return Vector2(-math.huge, -math.huge) end

--- Returns a Vector2 object with x and y components set to math.huge.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2.positiveInfinity() return Vector2(math.huge, math.huge) end

--- Creates a new Vector2 object from an angle.
---@param angle number The angle in degrees.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2.fromAngle(angle)
    local angleRad = math.rad(angle)

    return Vector2(math.cos(angleRad), math.sin(angleRad))
end

--- Checks if an object is a Vector2 object.
---@param obj any The object to check.
---@return boolean #True if the object is a Vector2 object, false otherwise.
---@nodiscard
function Vector2.isVector2(obj)
    return getmetatable(obj) == Vector2Meta
end

--- Adds two Vector2 objects together.
---@param other Vector2 The other Vector2 object.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2Meta:__add(other)
    return Vector2(self.x + other.x, self.y + other.y)
end

--- Subtracts two Vector2 objects.
---@param other Vector2 The other Vector2 object.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2Meta:__sub(other)
    return Vector2(self.x - other.x, self.y - other.y)
end

--- Multiplies a Vector2 object by a scalar.
---@param other Vector2 | number The scalar.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2Meta:__mul(other)
    if (type(other) == "number") then
        return Vector2(self.x * other, self.y * other)
    end

    return Vector2(self.x * other, self.y * other)
end

--- Divides a Vector2 object by a scalar.
---@param other Vector2 The scalar.
---@return Vector2 The #new Vector2 object.
function Vector2Meta:__div(other)
    if (type(other) == "number") then
        return Vector2(self.x / other, self.y / other)
    end

    return Vector2(self.x / other, self.y / other)
end

--- Negates a Vector2 object.
---@return Vector2 #The new Vector2 object.
function Vector2Meta:__unm()
    return Vector2(-self.x, -self.y)
end

--- Checks if two Vector2 objects are equal.
---@param other Vector2 The other Vector2 object.
---@return boolean #True if the two vectors are equal, false otherwise.
function Vector2Meta:__eq(other)
    return self.x == other.x and self.y == other.y
end

--- Returns a string representation of the Vector2 object.
---@return string #The string representation.
function Vector2Meta:__tostring()
    return "Vector2(" .. self.x .. ", " .. self.y .. ")"
end

--- Returns the magnitude of the vector.
---@return number #The magnitude of the vector.
---@nodiscard
function Vector2Meta:magnitude()
    return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

--- Returns the squared magnitude of the vector.
---@return number The squared magnitude of the vector.
---@nodiscard
function Vector2Meta:sqrMagnitude()
    return self.x ^ 2 + self.y ^ 2
end

--- Returns the normalized vector.
---@return Vector2 #The normalized vector.
---@nodiscard
function Vector2Meta:normalized()
    local mag = self:magnitude()
    return Vector2(self.x / mag, self.y / mag)
end

--- Clamps the vector to a maximum length.
---@param maxLength number The maximum length.
---@return Vector2 #The clamped vector.
---@nodiscard
function Vector2Meta:clampMagnitude(maxLength)
    if self:sqrMagnitude() > maxLength ^ 2 then
        return self:normalized() * maxLength
    end

    return self:clone()
end

--- Returns the dot product of two vectors.
---@param other Vector2 The other Vector2 object.
---@return number #The dot product of the two vectors.
---@nodiscard
function Vector2Meta:dot(other)
    return self.x * other.x + self.y * other.y
end

--- Returns the angle between two vectors.
---@param other Vector2 The other Vector2 object.
---@return number #The angle between the two vectors.
---@nodiscard
function Vector2Meta:angle(other)
    local angleRad = math.acos(self:dot(other) / (self:magnitude() * other:magnitude()))
    return math.deg(angleRad)
end

--- Returns the signed angle between two vectors.
---@param other Vector2 The other Vector2 object.
---@return number #The signed angle between the two vectors.
---@nodiscard
function Vector2Meta:signedAngle(other)
    local angle = self:angle(other)
    local sign = self.x * other.y - self.y * other.x
    return sign < 0 and -angle or angle
end

--- Returns the distance between two vectors.
---@param other Vector2 The other Vector2 object.
---@return number #The distance between the two vectors.
---@nodiscard
function Vector2Meta:distance(other)
    return (self - other):magnitude()
end

--- Linearly interpolates between two vectors.
---@param other Vector2 The other Vector2 object.
---@param t number The interpolation factor.
---@return Vector2 #The interpolated vector.
---@nodiscard
function Vector2Meta:lerp(other, t)
    return self + (other - self) * t
end

--- Sets the x and y components of the vector.
---@param x number The x component.
---@param y number The y component.
---@return Vector2 #The vector.
function Vector2Meta:set(x, y)
    self.x = x
    self.y = y

    return self
end

--- Returns the x and y components of the vector.
---@return number, number #The x and y components.
---@nodiscard
function Vector2Meta:unpack()
    return self.x, self.y
end

--- Clones the vector.
---@return Vector2 #The cloned vector.
---@nodiscard
function Vector2Meta:clone()
    return Vector2(self.x, self.y)
end

--- Moves a point current towards target.
---@param target Vector2 The target point.
---@param maxDistanceDelta number The maximum distance to move.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2Meta:moveTowards(target, maxDistanceDelta)
    local vector = target - self
    local magnitude = vector:magnitude()

    if magnitude <= maxDistanceDelta or magnitude == 0 then
        return target:clone()
    end

    return self + vector / magnitude * maxDistanceDelta
end

---Returns a vector that is made from the largest components of two vectors.
---@param other Vector2 The other Vector2 object.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2Meta:max(other)
    return Vector2(math.max(self.x, other.x), math.max(self.y, other.y))
end

---Returns a vector that is made from the smallest components of two vectors.
---@param other Vector2 The other Vector2 object.
---@return Vector2 #The new Vector2 object.
---@nodiscard
function Vector2Meta:min(other)
    return Vector2(math.min(self.x, other.x), math.min(self.y, other.y))
end

--- Reflects a vector off the surface defined by a normal.
---@param normal Vector2 The normal of the surface.
---@return Vector2 #The reflected vector.
---@nodiscard
function Vector2Meta:reflect(normal)
    return self - normal * 2 * self:dot(normal)
end

--- Gradually moves the current vector towards a target vector, over a specified time and at a specified velocity.
---@param target Vector2 The target vector.
---@param currentVelocity Vector2 The current velocity, this value is modified by the function every time you call it.
---@param smoothTime number The approximate time it will take to reach the target. A smaller value will reach the target faster.
---@param maxSpeed? number The maximum speed. Defaults to math.huge.
---@param deltaTime? number The time since the last call to this function. Defaults to love.timer.getDelta().
---@return Vector2 #The new vector.
function Vector2Meta:smoothDamp(target, currentVelocity, smoothTime, maxSpeed, deltaTime)
    maxSpeed = maxSpeed or math.huge
    deltaTime = deltaTime or love.timer.getDelta()

    local newX, velX = mathx.smoothDamp(self.x, target.x, currentVelocity.x, smoothTime, maxSpeed, deltaTime)
    local newY, velY = mathx.smoothDamp(self.y, target.y, currentVelocity.y, smoothTime, maxSpeed, deltaTime)

    currentVelocity:set(velX, velY)

    return Vector2(newX, newY)
end

--- Concatenates the string representation of the vector with other strings.
---@vararg any The other strings.
---@return string #The concatenated string.
---@nodiscard
function Vector2Meta:__concat(...)
    local str = tostring(self)

    for _, v in ipairs({ ... }) do
        str = str .. tostring(v)
    end

    return str
end

return Vector2
