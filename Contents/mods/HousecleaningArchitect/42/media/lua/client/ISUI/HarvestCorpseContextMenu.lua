function Bone_Context (player, context, worldobjects, test)
  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()

  -- if playerInv:contains("Axe") or playerInv:contains("Crowbar")  then
    local corpse = IsoObjectPicker.Instance:PickCorpse(context.x, context.y)
    if corpse then
      context:addOption(getText("Destroy Corpse"), worldobjects, ISWorldObjectContextMenu.onButcherCorpseItem, corpse, player);
    end
  -- end
end


ISWorldObjectContextMenu.onButcherCorpseItem = function(worldobjects, WItem, player)
  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()
  -- local hammer = playerInv:getFirstType("Axe") or  playerInv:getFirstType("Crowbar")

  if WItem:getSquare() and luautils.walkAdj(playerObj, WItem:getSquare()) then
    -- ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), hammer, true, true);
		ISTimedActionQueue.add(ISHarvestCorpseAction:new(playerObj, WItem, 250));
	end
end

Events.OnPreFillWorldObjectContextMenu.Add(Bone_Context)
