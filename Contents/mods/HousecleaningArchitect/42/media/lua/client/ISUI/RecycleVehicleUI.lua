require "ISUI/ISModalDialog"
require "luautils"

if not RecycleVehicle then RecycleVehicle = {} end
if not RecycleVehicle.UI then RecycleVehicle.UI = {} end

-- ------------------------------------------------------
-- Copy of the same functions from ISBlacksmithMenu
-- for compatibility reasons
-- ------------------------------------------------------

local function comparatorDrainableUsesInt(item1, item2)
	return item1:getCurrentUses() - item2:getCurrentUses()
end

local function predicateDrainableUsesInt(item, count)
    return item:getDrainableUsesInt() >= count
end

local function getFirstBlowTorchWithUses(container, uses)
    return container:getFirstTypeEvalArgRecurse("Base.BlowTorch", predicateDrainableUsesInt, uses)
end

-- ------------------------------------------------------
-- The mod's functions
-- ------------------------------------------------------

local function onRecycleVehicleAux(player, button, vehicle, propaneNeeded)
    if button.internal == "NO" then return end

    if luautils.walkAdj(player, vehicle:getSquare()) then
        local blowTorch = getFirstBlowTorchWithUses(player:getInventory(), propaneNeeded)
        ISWorldObjectContextMenu.equip(player, player:getPrimaryHandItem(), blowTorch, true);
        local mask = player:getInventory():getFirstTypeRecurse("WeldingMask")
        if mask then
            ISInventoryPaneContextMenu.wearItem(mask, player:getPlayerNum())
        end
        ISTimedActionQueue.add(ISRemoveBurntVehicle:new(player, vehicle))
    end
end

local function onRecycleVehicle(player, vehicle, propaneNeeded)
    local message = getText("IGUI_VehicleRecycling_ConfirmDialog_Vehicle")
    if vehicle:getScript():getName():find("Trailer") then
        message = getText("IGUI_VehicleRecycling_ConfirmDialog_Trailer")
    end

    local playerNum = player:getPlayerNum()
    local modal = ISModalDialog:new(0, 0, 350, 150, message, true, player, onRecycleVehicleAux, playerNum, vehicle, propaneNeeded)
    modal:initialise();
    modal:addToUIManager();
end

function RecycleVehicle.UI.FillMenuOutsideVehicle(player, context, vehicle)
    --if RecycleVehicle.Utils.isBurnt(vehicle) and not RecycleVehicleOptions.overrideBurnt then return end
    --if RecycleVehicle.Utils.isSmashed(vehicle) and not RecycleVehicleOptions.overrideSmashed then return end
    -- if not RecycleVehicle.Utils.isBurnt(vehicle) and not RecycleVehicle.Utils.isSmashed(vehicle) then
    --     if not player:getInventory():containsTypeRecurse("BlowTorch") then return end

    --     local hasPassengers
    --     for i = 0, vehicle:getMaxPassengers() - 1 do
    --         if vehicle:getCharacter(i) then
    --             hasPassengers = true
    --             break
    --         end
    --     end
    --     if hasPassengers then
    --         local option = context:addOption(getText("ContextMenu_VehicleRecycling_RemoveVehicle"), nil, nil)
    --         local toolTip = ISToolTip:new()
    --         toolTip:initialise()
    --         toolTip:setVisible(false)
    --         option.toolTip = toolTip
    --         toolTip.description = getText("Tooltip_VehicleRecycling_Passengers")
    --         option.notAvailable = true
    --         return
    --     end
    -- end

    local propaneNeeded = 0
    for i = 1, vehicle:getPartCount() do
        local part = vehicle:getPartByIndex(i - 1)
        local partId = part:getId()

        if not (part:getItemType() and not part:getItemType():isEmpty() and not part:getInventoryItem()) then
            if not (
                partId:find("Wind") or
                partId:find("Headlight") or
                partId:find("TruckBed") or
                partId:find("GloveBox") or
                partId:find("Engine") or
                partId:find("Heater") or
                partId:find("PassengerCompartment") or
                partId == "TrunkDoorWreck"
            ) then
                propaneNeeded = propaneNeeded + 0.65
            end
        end
    end

    local optionText = getText("ContextMenu_RemoveBurntVehicle")
    if vehicle:getScript():getName():find("Trailer") then
        optionText = getText("ContextMenu_RemoveBurntVehicle")
    end

    local option
    -- Override the vanilla implementation for burnt or smashed vehicles
    --if RecycleVehicleOptions.overrideBurnt and RecycleVehicle.Utils.isBurnt(vehicle) then
    -- if RecycleVehicle.Utils.isBurnt(vehicle) then
    --     option = context:getOptionFromName(getText("ContextMenu_RemoveBurntVehicle"))
    -- end
    -- --if RecycleVehicleOptions.overrideSmashed and RecycleVehicle.Utils.isSmashed(vehicle) then
    -- if RecycleVehicle.Utils.isSmashed(vehicle) then
    --     option = context:getOptionFromName(getText("ContextMenu_RemoveBurntVehicle"))
    -- end
    local propaneNeeded = 10
    if option then
        option.name = optionText
        option.target = player
        option.onSelect = onRecycleVehicle
        option.param1 = vehicle
        option.param2 = propaneNeeded
    else
        option = context:addOption(optionText, player, onRecycleVehicle, vehicle, propaneNeeded)
    end

    local toolTip = ISToolTip:new()
    toolTip:initialise()
    toolTip:setVisible(false)
    toolTip:setName(optionText)
    option.toolTip = toolTip

    local text = getText("Tooltip_VehicleRecycling") .. " <LINE> "
    local notAvailable = false

    local playerObj = getSpecificPlayer(player)
    if playerObj:getInventory():containsTypeRecurse("WeldingMask") then
        text = text .. " <LINE> <RGB:1,1,1> " .. getItemNameFromFullType("Base.WeldingMask")
    else
        text = text .. " <LINE> <RGB:1,0,0> " .. getItemNameFromFullType("Base.WeldingMask")
        notAvailable = true
    end

    local blowTorch = playerObj:getInventory():getBestTypeEvalRecurse("Base.BlowTorch", comparatorDrainableUsesInt)
    if blowTorch then
        local blowTorchUseLeft = blowTorch:getCurrentUses();
        if blowTorchUseLeft >= 10 then
            toolTip.description = toolTip.description .. " <LINE> <RGB:1,1,1> " .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Uses") .. " " .. blowTorchUseLeft .. "/" .. 10;
        else
            toolTip.description = toolTip.description .. " <LINE> <RGB:1,0,0> " .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Uses") .. " " .. blowTorchUseLeft .. "/" .. 10;
            option.notAvailable = true;
        end
    else
        toolTip.description = toolTip.description .. " <LINE> <RGB:1,0,0> " .. getItemNameFromFullType("Base.BlowTorch") .. " 0/10";
        option.notAvailable = true;
    end

    -- if SandboxVars.VehicleRecycling.UninstallParts then
    --     local partsToRemove = {}
    --     for i = 1, vehicle:getPartCount() do
    --         local part = vehicle:getPartByIndex(i - 1)
    --         local partId = part:getId()
    --         -- Looking for all windows, doors (including engine and trunk doors), seats
    --         if partId:find("^Wind") or partId:find("Door") or partId:find("Seat") then
    --             if part:getItemType() and not part:getItemType():isEmpty() and part:getInventoryItem() then
    --                 table.insert(partsToRemove, partId)
    --             end
    --         end
    --     end

    --     if #partsToRemove > 0 then
    --         text = text .. " <LINE> <LINE> <RGB:1,1,1> " .. getText("Tooltip_VehicleRecycling_Uninstall")
    --         for _, part in ipairs(partsToRemove) do
    --             text = text .. " <LINE> <RGB:1,0,0> " .. getText("IGUI_VehiclePart" .. part)
    --         end
    --         notAvailable = true
    --     end
    -- end

    toolTip.description = text
    option.notAvailable = notAvailable
end

-- Wrap the original function
if not RecycleVehicle.UI.defaultMenuOutsideVehicle then
    RecycleVehicle.UI.VanillaFillMenuOutsideVehicle = ISVehicleMenu.FillMenuOutsideVehicle
end

-- Override the original function
function ISVehicleMenu.FillMenuOutsideVehicle(player, context, vehicle, test)
    RecycleVehicle.UI.VanillaFillMenuOutsideVehicle(player, context, vehicle, test)
    RecycleVehicle.UI.FillMenuOutsideVehicle(player, context, vehicle)
end
