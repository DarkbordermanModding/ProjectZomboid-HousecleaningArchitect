-- require('luautils');

-- local function predicateNotBroken(item)
--   return not item:isBroken()
-- end

-- -- local function onDestroyFloorMenu(worldobjects, square, player)
-- --   getCell():setDrag(FixFloorCursor:new("", "", player), player:getPlayerNum())
-- -- end

-- local function addDestroyFloorMenu(player, context, worldobjects)
--   local player = getSpecificPlayer(player);
--   local inventory = player:getInventory();
--   local square;
--   local target;

--   if player:getVehicle() then return end
--   -- if not (
--   --   inventory:contains("Hammer") or
--   --   inventory:contains("HammerForged") or
--   --   inventory:contains("BallPeenHammer") or
--   --   inventory:contains("BallPeenHammerForged") or
--   --   inventory:contains("ClubHammer") or
--   --   inventory:contains("ClubHammerForged") or
--   --   inventory:contains("SmithingHammer") or
--   --   inventory:contains("HammerStone")
--   -- ) then
--   --   return
--   -- end

--   for i,v in ipairs(worldobjects) do
--     square = v:getSquare();
--   end

--   if not square then return end


--   print(square:getX())
--   print(square:getY())
--   print(square:getZ())
--   below = getCell():getGridSquare(square:getX(), square:getY(), square:getZ() - 1)
--   if below then
--     print("here")
--   end

--   -- local props = object:getProperties()
--   -- for i=0,square:getObjects():size()-1 do
--   --   local object = square:getObjects():get(i);

--   --   if object then
--   --     local attached = object:getAttachedAnimSprite()
--   --     if attached then
--   --       for n=1,attached:size() do
--   --         local sprite = attached:get(n-1)
--   --         if sprite and sprite:getParentSprite() and sprite:getParentSprite():getName() and
--   --           (
--   --             luautils.stringStarts(sprite:getParentSprite():getName(), "floors_overlay_tiles") or
--   --             luautils.stringStarts(sprite:getParentSprite():getName(), "floors_overlay_wood") or
--   --             luautils.stringStarts(sprite:getParentSprite():getName(), "d_streetcrack") or
--   --             luautils.stringStarts(sprite:getParentSprite():getName(), "floors_overlay_street") or
--   --             luautils.stringStarts(sprite:getParentSprite():getName(), "d_wallcrack") or
--   --             luautils.stringStarts(sprite:getParentSprite():getName(), "blends_streetoverlays")
--   --           ) then
--   --             target = sprite
--   --           break;
--   --         end
--   --       end
--   --     end
--   --   end
--   -- end

--   if not target then return end
--   print("herer")
--   -- context:addOption(getText('ContextMenu_FixFloor'), worldobjects, onDestroyFloorMenu, square, player);
-- end

-- -- ------------------------------------------------
-- -- Game hooks
-- -- ------------------------------------------------
-- Events.OnFillWorldObjectContextMenu.Add(addDestroyFloorMenu);
