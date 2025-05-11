ISHarvestCorpseAction = ISBaseTimedAction:derive("ISHarvestCorpseAction");

function ISHarvestCorpseAction:isValid()
  local playerInv = self.character:getInventory()
  return true
  -- return (playerInv:contains("Axe") or playerInv:contains("Crowbar"));
end

function ISHarvestCorpseAction:waitToStart()
  self.character:faceThisObject(self.corpseBody)
  return self.character:shouldBeTurning()
end

function ISHarvestCorpseAction:update()
  self.corpse:setJobDelta(self:getJobDelta());
  self.character:faceThisObject(self.corpseBody);
  self.character:setMetabolicTarget(Metabolics.MediumWork);
end

function ISHarvestCorpseAction:start()
  self:setActionAnim("Loot");
  self:setAnimVariable("LootPosition", "Low");
  self.corpse:setJobType(getText("Destroy Corpse"));
  self.corpse:setJobDelta(0.0);
  -- self.character:getEmitter():playSound("Hammering")
  -- self.character:addBlood(Hand_L, true, false, false)
  -- self.character:addBlood(Hand_R, true, false, false)
end

function ISHarvestCorpseAction:stop()
  ISBaseTimedAction.stop(self);
  self.corpse:setJobDelta(0.0);
end

function ISHarvestCorpseAction:perform()
  self.corpse:setJobDelta(0.0);
  self.character:getInventory():setDrawDirty(true);

  self.character:getInventory():AddItem("Base.Maggots");

  if ZombRand(100) > 95 then
    self.character:getInventory():AddItem("Base.AnimalBone");
  end

  if ZombRand(100) > 95 then
    self.character:getInventory():AddItem("Base.JawboneBovide");
  end

  local obj = self.corpseBody
  local sq = obj:getSquare();

  -- for i=1,obj:getContainerCount() do
  --  local container = obj:getContainerByIndex(i-1)
  --  local sq = obj:getSquare();

  --  for j=1,container:getItems():size() do
  --    if container:getItems():get(j-1):getType() ~= "Nothing" then
  --      local item = sq:AddWorldInventoryItem(container:getItems():get(j-1), 0.0, 0.0, 0.0)
  --    end
  --  end
  -- end

  self.corpseBody:getSquare():removeCorpse(self.corpseBody, false);
  self.corpseBody:getSquare():getObjects():remove(self.corpseBody);

  -- needed to remove from queue / start next.
  ISBaseTimedAction.perform(self);
end

function ISHarvestCorpseAction:new (character, corpse, time)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.character = character;
  o.corpse = corpse:getItem();
  o.corpseBody = corpse;
  o.stopOnWalk = true;
  o.stopOnRun = true;
  o.maxTime = time;
  if character:isTimedActionInstant() then
    o.maxTime = 1;
  end
  return o
end
