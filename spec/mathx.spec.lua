local mathx = require 'src.mathx'

describe('mathx', function()
    describe('round', function()
        it('should round a number to the nearest integer', function()
            assert.is.equal(1, mathx.round(1.4))
            assert.is.equal(2, mathx.round(1.5))
            assert.is.equal(2, mathx.round(1.6))
        end)
    end)

    describe('clamp', function()
        it('should clamp a number between a minimum and maximum value', function()
            assert.is.equal(1, mathx.clamp(0, 1, 2))
            assert.is.equal(1, mathx.clamp(1, 1, 2))
            assert.is.equal(2, mathx.clamp(2, 1, 2))
            assert.is.equal(2, mathx.clamp(3, 1, 2))
        end)
    end)

    describe('clamp01', function()
        it('should clamp a number between 0 and 1', function()
            assert.is.equal(0, mathx.clamp01(-1))
            assert.is.equal(0, mathx.clamp01(0))
            assert.is.equal(0.5, mathx.clamp01(0.5))
            assert.is.equal(1, mathx.clamp01(1))
            assert.is.equal(1, mathx.clamp01(2))
        end)
    end)

    describe("rep", function()
        it("should loop the value v, so that it is never larger than length and never smaller than 0", function()
            assert.is.equal(0, mathx.rep(0, 1))
            assert.is.equal(0, mathx.rep(1, 1))
            assert.is.equal(0, mathx.rep(0, 5))
            assert.is.equal(1, mathx.rep(1, 5))
            assert.is.equal(2, mathx.rep(2, 5))
            assert.is.equal(3, mathx.rep(3, 5))
            assert.is.equal(4, mathx.rep(4, 5))
            assert.is.equal(0, mathx.rep(5, 5))
            assert.is.equal(1, mathx.rep(6, 5))
            assert.is.equal(2, mathx.rep(7, 5))
            assert.is.equal(3, mathx.rep(8, 5))
            assert.is.equal(4, mathx.rep(9, 5))
            assert.is.equal(0, mathx.rep(10, 5))
            assert.is.equal(1, mathx.rep(11, 5))
            assert.is.equal(2, mathx.rep(12, 5))
            assert.is.equal(3, mathx.rep(13, 5))
            assert.is.equal(4, mathx.rep(14, 5))
            assert.is.equal(0, mathx.rep(15, 5))
            assert.is.equal(1, mathx.rep(16, 5))
            assert.is.equal(2, mathx.rep(17, 5))
        end)
    end)

    describe("lerp", function()
        it("should linearly interpolate between two values", function()
            assert.is.equal(0, mathx.lerp(0, 1, 0))
            assert.is.equal(0.5, mathx.lerp(0, 1, 0.5))
            assert.is.equal(1, mathx.lerp(0, 1, 1))
            assert.is.equal(0.25, mathx.lerp(0, 1, 0.25))
            assert.is.equal(0.75, mathx.lerp(0, 1, 0.75))
        end)
    end)

    describe("lerpAngle", function()
        it("should linearly interpolate between two angles", function()
            assert.is.equal(0, mathx.lerpAngle(0, 360, 0))
            assert.is.equal(0, mathx.lerpAngle(0, 360, 0.5))
            assert.is.equal(0, mathx.lerpAngle(0, 360, 1))
            assert.is.equal(90, mathx.lerpAngle(0, 180, 0.5))
            assert.is.equal(270, mathx.lerpAngle(180, 360, 0.5))
            assert.is.equal(45, mathx.lerpAngle(0, 90, 0.5))
            assert.is.equal(180, mathx.lerpAngle(90, 270, 0.5))
            assert.is.equal(360, mathx.lerpAngle(360, 0, 0.25))
            assert.is.equal(360, mathx.lerpAngle(360, 0, 0.5))
            assert.is.equal(360, mathx.lerpAngle(360, 0, 0.75))
            assert.is.equal(22.5, mathx.lerpAngle(0, 90, 0.25))
            assert.is.equal(67.5, mathx.lerpAngle(0, 90, 0.75))
            assert.is.equal(337.5, mathx.lerpAngle(270, 0, 0.75))
            assert.is.equal(292.5, mathx.lerpAngle(270, 0, 0.25))
            assert.is.equal(-22.5, mathx.lerpAngle(0, 270, 0.25))
            assert.is.equal(90, mathx.lerpAngle(0, 540, 0.5))
            assert.is.equal(180, mathx.lerpAngle(90, 270, 0.5))
            assert.is.equal(90, mathx.lerpAngle(90, 450, 0.25))
            assert.is.equal(450, mathx.lerpAngle(450, 90, 0.75))
            assert.is.equal(315, mathx.lerpAngle(270, 450, 0.25))
            assert.is.equal(540, mathx.lerpAngle(450, 270, 0.5))
            assert.is.equal(0, mathx.lerpAngle(0, 720, 1))
        end)
    end)

    describe("lerpUnclamped", function()
        it("should linearly interpolate between two values without clamping the t value", function()
            assert.is.equal(0, mathx.lerpUnclamped(0, 1, 0))
            assert.is.equal(0.5, mathx.lerpUnclamped(0, 1, 0.5))
            assert.is.equal(1, mathx.lerpUnclamped(0, 1, 1))
            assert.is.equal(-0.5, mathx.lerpUnclamped(0, -1, 0.5))
            assert.is.equal(0.5, mathx.lerpUnclamped(-1, 1, 0.75))
        end)
    end)

    describe("smoothDamp", function()
        it("should gradually move the current value towards a target value", function()
            local current = 0
            local target = 10
            local currentVelocity = 0
            local smoothTime = 1
            local maxSpeed = 10
            local deltaTime = 1
            local newCurrent, newCurrentVelocity = mathx.smoothDamp(current, target, currentVelocity, smoothTime,
                maxSpeed, deltaTime)

            assert.is.near(newCurrent, 5.588235, 0.0001)
            assert.is.near(newCurrentVelocity, 5.882353, 0.0001)
        end)

        it("should handle negative current and target values correctly", function()
            local current = -5
            local target = -10
            local currentVelocity = 0
            local smoothTime = 1
            local maxSpeed = 10
            local deltaTime = 1
            local newCurrent, newCurrentVelocity = mathx.smoothDamp(current, target, currentVelocity, smoothTime,
                maxSpeed, deltaTime)

            assert.is.near(newCurrent, -7.794117, 0.0001)
            assert.is.near(newCurrentVelocity, -2.941177, 0.0001)
        end)

        it("should handle different smooth times correctly", function()
            local current = 0
            local target = 10
            local currentVelocity = 0
            local smoothTime = 0.5
            local maxSpeed = 10
            local deltaTime = 1
            local newCurrent, newCurrentVelocity = mathx.smoothDamp(current, target, currentVelocity, smoothTime,
                maxSpeed, deltaTime)
            assert.is.near(newCurrent, 4.098124, 0.0001)
            assert.is.near(newCurrentVelocity, 2.886002, 0.0001)
        end)

        it("should handle zero smooth time correctly", function()
            local current = 0
            local target = 10
            local currentVelocity = 0
            local smoothTime = 0
            local maxSpeed = 10
            local deltaTime = 1
            local newCurrent, newCurrentVelocity = mathx.smoothDamp(current, target, currentVelocity, smoothTime,
                maxSpeed, deltaTime)

            assert.is.near(newCurrent, 0.0009999999, 0.0001)
            assert.is.near(newCurrentVelocity, 2.127442E-07, 0.0001)
        end)
    end)

    describe('smoothStep', function()
        it('should gradually change a value towards a desired goal over time', function()
            local result = mathx.smoothStep(0, 1, 0.25)
            assert.is.near(result, 0.15625, 0.0001)

            result = mathx.smoothStep(0, 1, 0.5)
            assert.is.near(result, 0.5, 0.0001)

            result = mathx.smoothStep(0, 1, 0.75)
            assert.is.near(result, 0.84375, 0.0001)

            result = mathx.smoothStep(0, 1, 1)
            assert.is.near(result, 1, 0.0001)
        end)
    end)

    describe("deltaAngle", function()
        it("calculates the shortest difference between two angles.", function()
            assert.are.equal(0, mathx.deltaAngle(0, 0))
            assert.are.equal(45, mathx.deltaAngle(45, 90))
            assert.are.equal(-45, mathx.deltaAngle(90, 45))
            assert.are.equal(0, mathx.deltaAngle(180, -180))
            assert.are.equal(0, mathx.deltaAngle(0, 360))
            assert.are.equal(0, mathx.deltaAngle(360, 0))
            assert.are.equal(0, mathx.deltaAngle(270, -90))
            assert.are.equal(0, mathx.deltaAngle(-90, 270))
            assert.are.equal(20, mathx.deltaAngle(350, 10))
            assert.are.equal(-20, mathx.deltaAngle(10, 350))
            assert.are.equal(20, mathx.deltaAngle(-10, 10))
            assert.are.equal(-20, mathx.deltaAngle(10, -10))
            assert.are.equal(0, mathx.deltaAngle(-180, 180))
            assert.are.equal(1, mathx.deltaAngle(180, 181)) --
            assert.are.equal(-1, mathx.deltaAngle(181, 180))
            assert.are.equal(1, mathx.deltaAngle(-181, -180))
            assert.are.equal(-1, mathx.deltaAngle(-180, -181))
            assert.are.equal(-1, mathx.deltaAngle(-179, 180))
            assert.are.equal(1, mathx.deltaAngle(180, -179))
            assert.are.equal(2, mathx.deltaAngle(179, -179))
        end)
    end)

    describe("smoothDampAngle", function()
        it("should gradually move the current angle towards a target angle", function()
            local current = 0
            local target = 10
            local currentVelocity = 0
            local smoothTime = 1
            local maxSpeed = 10
            local deltaTime = 1
            local newCurrent = mathx.smoothDampAngle(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)

            assert.is.near(newCurrent, 5.588235, 0.0001)
        end)

        it("should handle negative current and target angles correctly", function()
            local current = -5
            local target = -10
            local currentVelocity = 0
            local smoothTime = 1
            local maxSpeed = 10
            local deltaTime = 1
            local newCurrent = mathx.smoothDampAngle(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)

            assert.is.near(newCurrent, -7.794117, 0.0001)
        end)

        it("should handle different smooth times correctly", function()
            local current = 0
            local target = 10
            local currentVelocity = 0
            local smoothTime = 0.5
            local maxSpeed = 10
            local deltaTime = 1
            local newCurrent = mathx.smoothDampAngle(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)

            assert.is.near(newCurrent, 4.098124, 0.0001)
        end)

        it("should handle zero smooth time correctly", function()
            local current = 0
            local target = 10
            local currentVelocity = 0
            local smoothTime = 0
            local maxSpeed = 10
            local deltaTime = 1
            local newCurrent = mathx.smoothDampAngle(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)

            assert.is.near(newCurrent, 0.0009999999, 0.0001)
        end)
    end)

    describe('log10', function()
        it('should return the base 10 logarithm of a number', function()
            assert.is.near(1, mathx.log10(10), 0.0001)
            assert.is.near(2, mathx.log10(100), 0.0001)
            assert.is.near(3, mathx.log10(1000), 0.0001)
            assert.is.near(4, mathx.log10(10000), 0.0001)
            assert.is.near(5, mathx.log10(100000), 0.0001)
            assert.is.near(6, mathx.log10(1000000), 0.0001)
            assert.is.near(7, mathx.log10(10000000), 0.0001)
            assert.is.near(8, mathx.log10(100000000), 0.0001)
            assert.is.near(9, mathx.log10(1000000000), 0.0001)
            assert.is.near(10, mathx.log10(10000000000), 0.0001)
        end)
    end)

    describe("sign", function()
        it("should return 1 for positive numbers", function()
            assert.are.equal(1, mathx.sign(1))
            assert.are.equal(1, mathx.sign(0.1))
            assert.are.equal(1, mathx.sign(0.0001))
            assert.are.equal(1, mathx.sign(0.00001))
            assert.are.equal(1, mathx.sign(0.000001))
            assert.are.equal(1, mathx.sign(0.0000001))
            assert.are.equal(1, mathx.sign(0.00000001))
            assert.are.equal(1, mathx.sign(0.000000001))
            assert.are.equal(1, mathx.sign(0.0000000001))
            assert.are.equal(1, mathx.sign(0.00000000001))
        end)

        it("should return -1 for negative numbers", function()
            assert.are.equal(-1, mathx.sign(-1))
            assert.are.equal(-1, mathx.sign(-0.1))
            assert.are.equal(-1, mathx.sign(-0.0001))
            assert.are.equal(-1, mathx.sign(-0.00001))
            assert.are.equal(-1, mathx.sign(-0.000001))
            assert.are.equal(-1, mathx.sign(-0.0000001))
            assert.are.equal(-1, mathx.sign(-0.00000001))
            assert.are.equal(-1, mathx.sign(-0.000000001))
            assert.are.equal(-1, mathx.sign(-0.0000000001))
            assert.are.equal(-1, mathx.sign(-0.00000000001))
        end)

        it("should return 0 for 0", function()
            assert.are.equal(0, mathx.sign(0))
        end)
    end)
end)
