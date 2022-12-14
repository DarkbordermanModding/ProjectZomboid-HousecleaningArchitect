CleanDirtCursor = ISBuildingObject:derive("CleanDirtCursor")

local function doCleanDirtMenu(player, square)
	local inventory = player:getInventory()
	if luautils.walkAdj(player, square, true) then
		local item = inventory:getFirstTypeRecurse("Mop") or
			inventory:getFirstTypeRecurse("DishCloth") or
			inventory:getFirstTypeRecurse("BathTowel");
		ISWorldObjectContextMenu.transferIfNeeded(player, item)
		-- dish clothes will be doing a low animation
		if item:getType() == "DishCloth" or item:getType() == "BathTowel" then
            luautils.equipItems(player, item)
		else -- broom/mop equipped in both hands
			luautils.equipItems(player, item)
		end
		ISTimedActionQueue.add(CleanDirtAction:new(player, square, 100));
	end
end

function CleanDirtCursor:create(x, y, z, north, sprite)
	local square = getWorld():getCell():getGridSquare(x, y, z)
	doCleanDirtMenu(self.character, square)
end

function CleanDirtCursor:isValid(square)
	local inventory = self.character:getInventory()

	if not (
		inventory:contains("BathTowel") or
		inventory:contains("DishCloth") or
		inventory:contains("Mop")
	) then
		return false
	end

	if square:haveBlood() then
		return true;
	end

	for i=0,square:getObjects():size()-1 do
		local object = square:getObjects():get(i);

        if object then
            if object:getTextureName() and luautils.stringStarts(object:getTextureName(), "overlay_graffiti") then
                return true;
            else
                local attached = object:getAttachedAnimSprite()
                if attached then
                    for n=1,attached:size() do
                        local sprite = attached:get(n-1)
                        if sprite and sprite:getParentSprite() and sprite:getParentSprite():getName() and
                            (luautils.stringStarts(sprite:getParentSprite():getName(), "overlay_grime") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "overlay_graffiti")) then
                            return true;
                        end
                    end
                end
            end
		end
	end
    return false
end

function CleanDirtCursor:render(x, y, z, square)
	if not CleanDirtCursor.floorSprite then
		CleanDirtCursor.floorSprite = IsoSprite.new()
		CleanDirtCursor.floorSprite:LoadFramesNoDirPageSimple('media/ui/FloorTileCursor.png')
	end
	local r,g,b,a = 0.0,1.0,0.0,0.8
	if self:isValid(square) == false then
		r = 1.0
		g = 0.0
	end
	CleanDirtCursor.floorSprite:RenderGhostTileColor(x, y, z, r, g, b, a)
end

function CleanDirtCursor:new(sprite, northSprite, character)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o:init()
	o:setSprite(sprite)
	o:setNorthSprite(northSprite)
	o.character = character
	o.player = character:getPlayerNum()
	o.noNeedHammer = true
	o.skipBuildAction = true
	return o
end

