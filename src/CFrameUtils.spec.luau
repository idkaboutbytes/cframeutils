--!native

local CFrameUtils = require(script.Parent)

return function()
	describe("CFrameUtils.cframeFromTo", function()
		it("should return identity for zero vector input", function()
			local a = Vector3.zero
			local b = Vector3.zero

			local result = CFrameUtils.cframeFromTo(a, b)

			expect(result).to.equal(CFrame.identity)
		end)

		it("should return a valid orthonormal CFrame", function()
			local a = Vector3.zero
			local b = Vector3.new(10, 0, 0)

			local result = CFrameUtils.cframeFromTo(a, b)
			local right = result.RightVector
			local up = result.UpVector
			local forward = result.LookVector

			expect(math.abs(right:Dot(up)) < 0.01).to.equal(true)
			expect(math.abs(right:Dot(forward)) < 0.01).to.equal(true)
			expect(math.abs(up:Dot(forward)) < 0.01).to.equal(true)
		end)
	end)

	describe("CFrameUtils.redirectLocalAxis", function()
		it("should rotate local axis toward world goal", function()
			local cframe = CFrame.new()
			local localAxis = Vector3.new(0, 1, 0)
			local worldGoal = Vector3.new(0, 1, 0)

			local result = CFrameUtils.redirectLocalAxis(cframe, localAxis, worldGoal)

			expect(result).to.equal(cframe)
		end)

		it("should rotate when axes differ", function()
			local cframe = CFrame.new()
			local localAxis = Vector3.new(0, 1, 0)
			local worldGoal = Vector3.new(1, 0, 0)

			local result = CFrameUtils.redirectLocalAxis(cframe, localAxis, worldGoal)

			expect(result).never.to.equal(cframe)
		end)
	end)

	describe("CFrameUtils.axisAngleToCFrame", function()
		it("should produce identity-like CFrame when axis is zero", function()
			local result = CFrameUtils.axisAngleToCFrame(Vector3.zero)

			expect(result.Position).to.equal(Vector3.zero)
		end)

		it("should apply position when provided", function()
			local pos = Vector3.new(1, 2, 3)

			local result = CFrameUtils.axisAngleToCFrame(Vector3.yAxis, pos)

			expect(result.Position).to.equal(pos)
		end)
	end)

	describe("CFrameUtils.fromUpRight", function()
		it("should return a valid CFrame when vectors are valid", function()
			local result = CFrameUtils.fromUpRight(Vector3.zero, Vector3.yAxis, Vector3.xAxis)

			expect(result).never.to.equal(nil)
		end)

		it("should return nil for degenerate vectors", function()
			local result = CFrameUtils.fromUpRight(Vector3.zero, Vector3.zero, Vector3.zero)

			expect(result).to.equal(nil)
		end)
	end)

	describe("CFrameUtils.scalePosition", function()
		it("should scale position when scale != 1", function()
			local cf = CFrame.new(1, 2, 3)

			local result = CFrameUtils.scalePosition(cf, 2)

			expect(result.Position).never.to.equal(cf.Position)
		end)

		it("should return same CFrame when scale is 1", function()
			local cf = CFrame.new(1, 2, 3)

			local result = CFrameUtils.scalePosition(cf, 1)

			expect(result).to.equal(cf)
		end)
	end)

	describe("CFrameUtils.mirror", function()
		it("should reflect CFrame across a plane defined by point + normal", function()
			local cf = CFrame.new(10, 0, 0)
			local point = Vector3.new(0, 0, 0)
			local normal = Vector3.new(1, 0, 0)

			local result = CFrameUtils.mirror(cf, point, normal)

			expect(result).never.to.equal(cf)
			expect(result.Position.X).to.equal(-10)
		end)

		it("should default to z-axis normal when not provided", function()
			local cf = CFrame.new(0, 0, 10)

			local result = CFrameUtils.mirror(cf)

			expect(result).never.to.equal(cf)
		end)

		it("should mirror relative to custom point", function()
			local cf = CFrame.new(10, 0, 0)
			local point = Vector3.new(5, 0, 0)
			local normal = Vector3.new(1, 0, 0)

			local result = CFrameUtils.mirror(cf, point, normal)

			expect(result.Position.X).to.equal(0)
		end)
	end)

	describe("CFrameUtils.areClose", function()
		it("should detect identical CFrames", function()
			local a = CFrame.new()
			local b = CFrame.new()

			expect(CFrameUtils.areClose(a, b, 0.0001)).to.equal(true)
		end)

		it("should detect different CFrames", function()
			local a = CFrame.new()
			local b = CFrame.new(10, 0, 0)

			expect(CFrameUtils.areClose(a, b, 0.0001)).to.equal(false)
		end)
	end)

	describe("CFrameUtils.getRotationInXZPlane", function()
		it("should return a valid CFrame", function()
			local cf = CFrame.new(0, 5, 0) * CFrame.Angles(0, math.rad(45), 0)

			local result = CFrameUtils.getRotationInXZPlane(cf)

			expect(result).never.to.equal(nil)
		end)
	end)
end
