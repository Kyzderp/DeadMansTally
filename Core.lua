local DMT = DeadMansTally


---------------------------------------------------------------------
local function StartsWith(str, prefix)
    return string.sub(str, 1, #prefix) == prefix
end

local function EndsWith(str, suffix)
    return string.sub(str, #str - #suffix + 1) == suffix
end


---------------------------------------------------------------------
local function SaveDeathSub(subtable, name)
    if (not subtable[name]) then
        subtable[name] = 0
    end
    subtable[name] = subtable[name] + 1
end

local function SaveDeath(type, name)
    SaveDeathSub(DMT.svs.foreverDeaths[type], name)
    SaveDeathSub(DMT.svs.currentDeaths[type], name)
end


---------------------------------------------------------------------
local function OnDeathStateChanged(_, unitTag, isDead)
    if (not isDead) then return end

    if (unitTag == "player") then
        if (IsUnitGrouped("player")) then return end -- Ignore grouped player, group death will cover it
        SaveDeath("ungroupedplayer", GetUnitDisplayName(unitTag))
        return
    end

    if (StartsWith(unitTag, "playerpet")) then
        SaveDeath("playerpet", GetUnitName(unitTag))
        return
    end

    if (StartsWith(unitTag, "boss")) then
        SaveDeath("boss", GetUnitName(unitTag))
        return
    end

    if (unitTag == "companion") then
        SaveDeath("companion", GetUnitName(unitTag))
        return
    end

    if (StartsWith(unitTag, "group")) then
        if (EndsWith(unitTag, "companion")) then
            if (not AreUnitsEqual(unitTag, "companion")) then -- Ignore self companion in group, companion will cover it
                SaveDeath("groupcompanion", GetUnitName(unitTag))
            end
        else
            SaveDeath("group", GetUnitDisplayName(unitTag))
        end
        return
    end
end

function DMT.InitializeCore()
    EVENT_MANAGER:RegisterForEvent(DMT.name .. "Death", EVENT_UNIT_DEATH_STATE_CHANGED, OnDeathStateChanged)
end
