FixFloorCursor = ISBuildingObject:derive("FixFloorCursor")

local function predicateNotBroken(item)
  return not item:isBroken()
end

local function doFixFloorMenu(player, square)
  local inventory = player:getInventory()
  if luautils.walkAdj(player, square, true) then
    local item =inventory:getFirstTypeEvalRecurse("Hammer", predicateNotBroken);

    ISWorldObjectContextMenu.transferIfNeeded(player, item)
    luautils.equipItems(player, item)

    ISTimedActionQueue.add(FixFloorAction:new(player, square, 150));
  end
end

function FixFloorCursor:create(x, y, z, north, sprite)
  local square = getWorld():getCell():getGridSquare(x, y, z)
  doFixFloorMenu(self.character, square)
end

function FixFloorCursor:isValid(square)
  local inventory = self.character:getInventory()

  for i=0,square:getObjects():size()-1 do
    local object = square:getObjects():get(i);

    if object then
      local attached = object:getAttachedAnimSprite()
      if attached then
        for n=1,attached:size() do
          local sprite = attached:get(n-1)
          if sprite and sprite:getParentSprite() and sprite:getParentSprite():getName() and
            (
              luautils.stringStarts(sprite:getParentSprite():getName(), "floors_overlay_tiles") or
              luautils.stringStarts(sprite:getParentSprite():getName(), "floors_overlay_wood") or
              luautils.stringStarts(sprite:getParentSprite():getName(), "d_streetcrack") or
              luautils.stringStarts(sprite:getParentSprite():getName(), "floors_overlay_street") or
              luautils.stringStarts(sprite:getParentSprite():getName(), "d_wallcrack") or
              luautils.stringStarts(sprite:getParentSprite():getName(), "blends_streetoverlays")
            ) then
            return (
              inventory:contains("Hammer") or
              inventory:contains("HammerForged") or
              inventory:contains("BallPeenHammer") or
              inventory:contains("BallPeenHammerForged") or
              inventory:contains("ClubHammer") or
              inventory:contains("ClubHammerForged") or
              inventory:contains("SmithingHammer") or
              inventory:contains("HammerStone")
            );
          end
        end
      end
    end
  end
  return false
end

function FixFloorCursor:render(x, y, z, square)
  if not FixFloorCursor.floorSprite then
    FixFloorCursor.floorSprite = IsoSprite.new()
    FixFloorCursor.floorSprite:LoadFramesNoDirPageSimple('media/ui/FloorTileCursor.png')
  end
  local r,g,b,a = 0.0,1.0,0.0,0.8
  if self:isValid(square) == false then
    r = 1.0
    g = 0.0
  end
  FixFloorCursor.floorSprite:RenderGhostTileColor(x, y, z, r, g, b, a)
end

function FixFloorCursor:new(sprite, northSprite, character)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o:init()
  o:setSprite(sprite)
  o:setNorthSprite(northSprite)
  o.character = character
  o.player = character:getPlayerNum()
  o.skipBuildAction = true
  return o
end

