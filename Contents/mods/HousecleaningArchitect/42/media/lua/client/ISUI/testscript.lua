--Scripts for testing

-- require('luautils');

-- local square = getPlayer():getSquare()

-- for i = 0,square:getObjects():size()-1 do
--   local object = square:getObjects():get(i);
--   if object then
--     local attached = object:getAttachedAnimSprite()
--     for n=1,attached:size() do
--       local sprite = attached:get(n-1)
--       print(sprite:getParentSprite():getName())
--     end
--   end
-- end


--[[
local square = getPlayer():getSquare()

square:addFloor(
  "floors_exterior_natural_01_1"
)
]]--
