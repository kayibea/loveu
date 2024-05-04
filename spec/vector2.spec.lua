local Vector2 = require("src.Vector2")

describe("Vector2", function()
    it("should create a new Vector2", function()
        local v = Vector2.new(1, 2)
        assert.are.equal(1, v.x)
        assert.are.equal(2, v.y)
    end)

    it("should create a new Vector2", function()
        local v = Vector2(1, 2)
        assert.are.equal(1, v.x)
        assert.are.equal(2, v.y)
    end)

    it("shout test if the object is a Vector2", function()
        local v = Vector2(1, 2)
        assert.is_true(Vector2.isVector2(v))

        assert.is_false(Vector2.isVector2({}))
        assert.is_false(Vector2.isVector2(""))
    end)

    it("should create a new Vector2 with default values", function()
        local v = Vector2()
        assert.are.equal(0, v.x)
        assert.are.equal(0, v.y)
    end)

    it("should create a new Vector2 with default values", function()
        local v = Vector2(1)
        assert.are.equal(1, v.x)
        assert.are.equal(0, v.y)
    end)

    it("should create a new Vector2 with x and y components set to 0", function()
        local v = Vector2.zero()
        assert.are.equal(0, v.x)
        assert.are.equal(0, v.y)
    end)


    it("should create a new Vector2 with x and y components set to 1", function()
        local v = Vector2.one()
        assert.are.equal(1, v.x)
        assert.are.equal(1, v.y)
    end)

    it("should create a new Vector2 with x component set to 0 and y component set to -1", function()
        local v = Vector2.up()
        assert.are.equal(0, v.x)
        assert.are.equal(-1, v.y)
    end)

    it("should create a new Vector2 with x component set to 0 and y component set to 1", function()
        local v = Vector2.down()
        assert.are.equal(0, v.x)
        assert.are.equal(1, v.y)
    end)

    it("should create a new Vector2 with x component set to -1 and y component set to 0", function()
        local v = Vector2.left()
        assert.are.equal(-1, v.x)
        assert.are.equal(0, v.y)
    end)

    it("should create a new Vector2 with x component set to 1 and y component set to 0", function()
        local v = Vector2.right()
        assert.are.equal(1, v.x)
        assert.are.equal(0, v.y)
    end)

    it("should create a new Vector2 with x and y components set to -math.huge", function()
        local v = Vector2.negativeInfinity()
        assert.are.equal(-math.huge, v.x)
        assert.are.equal(-math.huge, v.y)
    end)

    it("should create a new Vector2 with x and y components set to math.huge", function()
        local v = Vector2.positiveInfinity()
        assert.are.equal(math.huge, v.x)
        assert.are.equal(math.huge, v.y)
    end)

    it("should create a new Vector2 from the angle in deg", function()
        local v, a

        a = 45
        v = Vector2.fromAngle(a)
        assert.are.equal(math.cos(math.rad(a)), v.x)
        assert.are.equal(math.sin(math.rad(a)), v.y)

        a = 90
        v = Vector2.fromAngle(a)
        assert.are.equal(math.cos(math.rad(a)), v.x)
        assert.are.equal(math.sin(math.rad(a)), v.y)

        a = 180
        v = Vector2.fromAngle(a)
        assert.are.equal(math.cos(math.rad(a)), v.x)
        assert.are.equal(math.sin(math.rad(a)), v.y)

        a = 270
        v = Vector2.fromAngle(a)
        assert.are.equal(math.cos(math.rad(a)), v.x)
        assert.are.equal(math.sin(math.rad(a)), v.y)
    end)

    it("should compare two vectors", function()
        local v1, v2

        v1 = Vector2(1, 2)
        v2 = Vector2(1, 2)
        assert.is_true(v1 == v2)

        v1 = Vector2(1, 2)
        v2 = Vector2(3, 4)
        assert.is_false(v1 == v2)
    end)

    it("should add two vectors", function()
        local v1 = Vector2(1, 2)
        local v2 = Vector2(3, 4)
        local v3 = v1 + v2
        assert.are.equal(4, v3.x)
        assert.are.equal(6, v3.y)
    end)

    it("should subtract two vectors", function()
        local v1 = Vector2(1, 2)
        local v2 = Vector2(3, 4)
        local v3 = v1 - v2
        assert.are.equal(-2, v3.x)
        assert.are.equal(-2, v3.y)
    end)

    it("should multiply a vector by a scalar", function()
        local v1 = Vector2(1, 2)
        local v2 = v1 * 2
        assert.are.equal(2, v2.x)
        assert.are.equal(4, v2.y)
    end)

    it("should divide a vector by a scalar", function()
        local v1 = Vector2(1, 2)
        local v2 = v1 / 2
        assert.are.equal(0.5, v2.x)
        assert.are.equal(1, v2.y)
    end)

    it("should calculate the dot product of two vectors", function()
        local v1 = Vector2(1, 2)
        local v2 = Vector2(3, 4)
        local dot = v1:dot(v2)
        assert.are.equal(11, dot)
    end)

    it("should calculate the magnitude of a vector", function()
        local v = Vector2(3, 4)
        local mag = v:magnitude()
        assert.are.equal(5, mag)
    end)

    it("should normalize a vector", function()
        local v = Vector2(3, 4)
        local v2 = v:normalized()
        assert.are.equal(0.6, v2.x)
        assert.are.equal(0.8, v2.y)
    end)

    it("should calculate the squared magnitude of a vector", function()
        local v = Vector2(3, 4)
        local mag = v:sqrMagnitude()
        assert.are.equal(25, mag)
    end)

    it("should negate a vector", function()
        local v = Vector2(3, 4)
        local v2 = -v
        assert.are.equal(-3, v2.x)
        assert.are.equal(-4, v2.y)
    end)

    it("should convert a vector to a string", function()
        local v = Vector2(3, 4)
        assert.are.equal("Vector2(3, 4)", tostring(v))
    end)

    it("should calculate the angle between two vectors", function()
        local v1 = Vector2(1, 0)
        local v2 = Vector2(0, 1)
        local angle = v1:angle(v2)
        assert.are.equal(90, angle)

        v1 = Vector2(1, 0)
        v2 = Vector2(1, 0)
        angle = v1:angle(v2)
        assert.are.equal(0, angle)

        v1 = Vector2(1, 0)
        v2 = Vector2(-1, 0)
        angle = v1:angle(v2)
        assert.are.equal(180, angle)
    end)

    it("should calculate the signed angle between two vectors", function()
        local v1 = Vector2(1, 0)
        local v2 = Vector2(0, 1)
        local angle = v1:signedAngle(v2)
        assert.are.equal(90, angle)

        v1 = Vector2(1, 0)
        v2 = Vector2(1, 0)
        angle = v1:signedAngle(v2)
        assert.are.equal(0, angle)

        v1 = Vector2(1, 0)
        v2 = Vector2(-1, 0)
        angle = v1:signedAngle(v2)
        assert.are.equal(180, angle)

        v1 = Vector2(1, 0)
        v2 = Vector2(0, -1)
        angle = v1:signedAngle(v2)
        assert.are.equal(-90, angle)
    end)


    it("should calculate the distance between two vectors", function()
        local v1 = Vector2(1, 2)
        local v2 = Vector2(4, 6)
        local distance = v1:distance(v2)
        assert.are.equal(5, distance)
    end)

    it("should linearly interpolate between two vectors", function()
        local v1 = Vector2(1, 2)
        local v2 = Vector2(4, 6)
        local v3 = v1:lerp(v2, 0.5)
        assert.are.equal(2.5, v3.x)
        assert.are.equal(4, v3.y)
    end)

    it("should set the x and y components of a vector", function()
        local v = Vector2(1, 2)
        v:set(3, 4)
        assert.are.equal(3, v.x)
        assert.are.equal(4, v.y)
    end)

    it("should unpack a vector", function()
        local v = Vector2(1, 2)
        local x, y = v:unpack()
        assert.are.equal(1, x)
        assert.are.equal(2, y)
    end)

    it("should clone a vector", function()
        local v = Vector2(1, 2)
        local v2 = v:clone()
        assert.is_true(v == v2)
        assert.are.equal(1, v2.x)
        assert.are.equal(2, v2.y)
    end)

    it("should clamp the vector to a maximum length", function()
        local v = Vector2(1, 2)
        local v2 = v:clampMagnitude(1)
        assert.are.equal(0.4472135954999579, v2.x)
        assert.are.equal(0.8944271909999159, v2.y)
    end)

    it("should move a point current towards target", function()
        local v1 = Vector2(1, 2)
        local v2 = Vector2(4, 6)
        local v3 = v1:moveTowards(v2, 1)
        assert.are.equal(2, math.floor(v3.x + 0.5))
        assert.are.equal(3, math.floor(v3.y + 0.5))
    end)

    it("should return a vector that is made from the largest components of two vectors", function()
        local v1 = Vector2(1, 2)
        local v2 = Vector2(4, 6)
        local v3 = v1:max(v2)
        assert.are.equal(4, v3.x)
        assert.are.equal(6, v3.y)
    end)

    it("should return a vector that is made from the smallest components of two vectors", function()
        local v1 = Vector2(1, 2)
        local v2 = Vector2(4, 6)
        local v3 = v1:min(v2)
        assert.are.equal(1, v3.x)
        assert.are.equal(2, v3.y)
    end)

    it("should reflect a vector", function()
        local v1 = Vector2(1, 2)
        local v2 = Vector2(4, 6)
        local normal = v2:normalized()               -- Normalize v2 to get the normal vector
        local v3 = v1:reflect(normal)
        assert.are.equal(math.floor(v3.x + 0.5), -1) -- Round to the nearest integer
        assert.are.equal(math.floor(v3.y + 0.5), -2) -- Round to the nearest integer
    end)
end)
