---@module "mathx"
--- A class that extends the math library with additional math functions inspired by Unity's Mathf class.
---@class mathx: mathlib
---@field epsilon number    #The smallest value that is considered to be zero.
---@field deg2Rad number    #The value to convert degrees to radians.
---@field rad2Deg number    #The value to convert radians to degrees.
local mathx = {}

setmetatable(mathx, { __index = math })

mathx.deg2Rad = math.rad(1)
mathx.rad2Deg = math.deg(1)
mathx.epsilon = 1e-5

--- Rounds the given value to the nearest integer.
---@param  value number The value to round.
---@return number   #The rounded value.
---@nodiscard
function mathx.round(value)
    local floorValue = math.floor(value)
    local remainder = value - floorValue
    if remainder >= 0.5 then
        return floorValue + 1
    else
        return floorValue
    end
end

--- Clamps the given value between the given minimum and maximum values.
--- Returns the given value if it is within the minimum and maximum range.
---@param  value number The value to clamp.
---@param  min number   The minimum value.
---@param  max number   The maximum value.
---@return number   #The clamped value.
function mathx.clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

--- Clamps value between 0 and 1 and returns value.
---@param  value number The value to clamp.
---@return number   #The clamped value.
---@nodiscard
function mathx.clamp01(value)
    return mathx.clamp(value, 0, 1)
end

--- Loops the value v, so that it is never larger than length and never smaller than 0.
---@param  v number The value to loop.
---@param  length number The value that t should not exceed.
---@return number   #The looped value.
---@nodiscard
function mathx.rep(v, length)
    return v - math.floor(v / length) * length
end

--- Returns the sign of a number.
---@param  value number The value to check.
---@return number   #The sign of the value.
---@nodiscard
function mathx.sign(value)
    return value > 0 and 1 or value < 0 and -1 or 0
end

---Linearly interpolates between a and b by t.
---@param  a number The start value.
---@param  b number The end value.
---@param  t number The interpolation value between the two floats.
---@return number   #The interpolated value.
---@nodiscard
function mathx.lerp(a, b, t)
    return a + (b - a) * mathx.clamp01(t)
end

--- Linearly interpolates between a and b by t with no limit to t.
---@param  a number The start value.
---@param  b number The end value.
---@param  t number The interpolation value between the two floats.
---@return number   #The interpolated value.
---@nodiscard
function mathx.lerpUnclamped(a, b, t)
    return a + (b - a) * t
end

---Same as Lerp but makes sure the values interpolate correctly when they wrap around 360 degrees.
---@param  a number The start value.
---@param  b number The end value.
---@param  t number The interpolation value between the two floats.
---@return number   #The interpolated value.
---@source https://docs.unity3d.com/ScriptReference/Mathf.LerpAngle.html
function mathx.lerpAngle(a, b, t)
    local num = mathx.rep(b - a, 360)
    if num > 180 then
        num = num - 360
    end
    return a + num * mathx.clamp01(t)
end

---Calculates the shortest difference between two angles.
---@param  current number The current angle.
---@param  target number  The target angle.
---@return number   #The shortest difference between the two angles.
function mathx.deltaAngle(current, target)
    local num = target - current
    num = num % 360
    if num > 180 then
        num = num - 360
    end
    if num < -180 then
        num = num + 360
    end
    return num
end

--- Gradually moves the current value towards a target value, over a specified time and at a specified velocity.
--- This is similar to the Lerp function but instead the function will automatically dampen the value when it gets close to the target value.
---@param  current number The current position.
---@param  target number  The position we are trying to reach.
---@param  currentVelocity number The current velocity, this value is modified by the function every time you call it.
---@param  smoothTime number The approximate time it will take to reach the target. A smaller value will reach the target faster.
---@param  maxSpeed number The maximum speed.
---@param  deltaTime number The time since the last call to this function.
---@return number, number  #The new position and the new velocity.
---@nodiscard
---@source https://docs.unity3d.com/ScriptReference/Mathf.SmoothDamp.html
---@source https://discussions.unity.com/t/formula-behind-smoothdamp/6483/5
function mathx.smoothDamp(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)
    smoothTime = math.max(0.0001, smoothTime)
    local num = 2 / smoothTime
    local num2 = num * deltaTime
    local num3 = 1 / (1 + num2 + 0.48 * num2 * num2 + 0.235 * num2 * num2 * num2)
    local num4 = current - target
    local num5 = target
    local num6 = maxSpeed * smoothTime
    num4 = mathx.clamp(num4, -num6, num6)
    target = current - num4
    local num7 = (currentVelocity + num * num4) * deltaTime
    currentVelocity = (currentVelocity - num * num7) * num3
    local num8 = target + (num4 + num7) * num3
    if (num5 - current > 0) == (num8 > num5) then
        num8 = num5
        currentVelocity = (num8 - num5) / deltaTime
    end

    return num8, currentVelocity
end

function mathx.smoothDampAngle(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)
    target = current + mathx.deltaAngle(current, target)
    return mathx.smoothDamp(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)
end

--- Gradually changes a value towards a desired goal over time.
--- The value is smoothed by some spring-damper like function, which will never overshoot.
---@param  from number The start value.
---@param  to number   The end value.
---@param  t number    The interpolation value between the two floats.
---@return number   #The smoothed value.
---@source https://docs.unity3d.com/ScriptReference/Mathf.SmoothStep.html
function mathx.smoothStep(from, to, t)
    t = mathx.clamp(t, 0, 1)
    t = -2 * t * t * t + 3 * t * t

    return to * t + from * (1 - t)
end

---Returns the base 10 logarithm of a specified number.
---@param  value number The value to calculate the logarithm of.
---@return number   #The base 10 logarithm of the value.
---@source https://docs.unity3d.com/ScriptReference/Mathf.Log10.html
function mathx.log10(value)
    return math.log(value) / math.log(10)
end

return mathx
