require('luautils');

local function FixSquare(x, y, z)
  local sq = getCell():getGridSquare(x, y, z)
  if not sq then return end

  local objects = sq:getObjects()
  for i = 0, objects:size() - 1 do
    local object = objects:get(i)
    if object then
      local attached = object:getAttachedAnimSprite()
      if attached then
        for n = attached:size() - 1, 0, -1 do
          local sprite = attached:get(n)
          if sprite then
            local parent = sprite:getParentSprite()
            local name = parent and parent:getName()
            if name and (
              luautils.stringStarts(name, "floors_overlay_tiles") or
              luautils.stringStarts(name, "floors_overlay_wood") or
              luautils.stringStarts(name, "d_streetcrack") or
              luautils.stringStarts(name, "floors_overlay_street") or
              luautils.stringStarts(name, "d_wallcrack") or
              luautils.stringStarts(name, "blends_streetoverlays")
            ) then
              object:RemoveAttachedAnim(n)
              object:transmitUpdatedSpriteToClients()
            end
          end
        end
      end
    end
  end
end

local function onFixFloorCommand(module, command, player, args)
  if module ~= 'FixFloor' or command ~= 'FixFloorCommand' then
    return
  end

  -- Change to 1~5 levels, so that wall crack can be fixed
  -- Or maybe separate to independent command later
  for z = args.z, args.z + 5 do
    FixSquare(args.x, args.y, z)
  end
end

Events.OnClientCommand.Add(onFixFloorCommand)
