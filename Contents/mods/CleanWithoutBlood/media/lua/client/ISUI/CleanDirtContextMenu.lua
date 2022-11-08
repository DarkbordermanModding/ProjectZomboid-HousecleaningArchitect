require('luautils');

local function onCleanDirtMenu(worldobjects, square, player)
    getCell():setDrag(
        CleanDirtCursor:new("", "", player),
        player:getPlayerNum()
    )
end

local function addCleanDirtMenu(player, context, worldobjects)
    local player = getSpecificPlayer(player);
    local inventory = player:getInventory();
    local square;
    local target;

    if player:getVehicle() then return end

    if not (
        inventory:containsTypeRecurse("BathTowel") or
        inventory:containsTypeRecurse("DishCloth") or
        inventory:containsTypeRecurse("Mop")
    ) then return end

    for i,v in ipairs(worldobjects) do
        square = v:getSquare();
    end
    if not square then return end

    for i=0,square:getObjects():size()-1 do
        local object = square:getObjects():get(i);

        if object then
            if object:getTextureName() and luautils.stringStarts(object:getTextureName(), "overlay_graffiti") then
                target = object;
                break;
            else
                local attached = object:getAttachedAnimSprite()
                if attached then
                    for n=1,attached:size() do
                        local sprite = attached:get(n-1)
                        if sprite and sprite:getParentSprite() and sprite:getParentSprite():getName() and
                            (luautils.stringStarts(sprite:getParentSprite():getName(), "overlay_grime") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "overlay_graffiti")) then
                            target = sprite
                            break;
                        end
                    end
                end
            end
        end
    end

    if not target then
        if not square:haveBlood() then return end
    end

    context:addOption(getText('ContextMenu_CleanDirt'), worldobjects, onCleanDirtMenu, square, player);
end

-- ------------------------------------------------
-- Game hooks
-- ------------------------------------------------
Events.OnFillWorldObjectContextMenu.Add(addCleanDirtMenu);
