--!native

const CFrameSerializer = require("./CFrameSerializer")
const CFrameUtils = require(".")

return function()
	describe('CFrameSerializer', function()
		it('serializes and deserializes json roundtrip close enough', function()
			local cf = CFrame.new(1.25, 2.5, -3.75) * CFrame.Angles(math.rad(10), math.rad(20), math.rad(-15))
			local json = CFrameSerializer.toJSONString(cf)
			local result = CFrameSerializer.fromJSONString(json)

			expect(result).never.to.equal(nil)
			expect(CFrameUtils.areClose(result :: CFrame, cf, 0.02)).to.equal(true)
		end)

		it('recognizes valid rotation azure payloads', function()
			expect(CFrameSerializer.isRotationAzure({ 1, 2, 3, 4, 5, 6 })).to.equal(true)
			expect(CFrameSerializer.isRotationAzure({ 1, 2, 3 })).to.equal(false)
		end)
	end)
end
