DeadMansTally = {
    name = "DeadMansTally",
    version = "0.0.0"
}
local DMT = DeadMansTally


---------------------------------------------------------------------
local defaultOptions = {}

---------------------------------------------------------------------
-- Initialize
---------------------------------------------------------------------
local function FillDefaults(tab)
    local defaults = {"ungroupedplayer", "group", "playerpet", "boss", "companion", "groupcompanion"}
    for _, name in ipairs(defaults) do
        if (not tab[name]) then
            tab[name] = ""
        end
    end
end

local function Initialize()
    DeadMansTallySavedVariables = DeadMansTallySavedVariables or {}
    DMT.packedSVs = DeadMansTallySavedVariables

    local world = GetWorldName()
    if (not DMT.packedSVs[world]) then
        DMT.packedSVs[world] = {}
    end

    local accName = GetUnitDisplayName("player")
    if (not DMT.packedSVs[world][accName]) then
        DMT.packedSVs[world][accName] = {
            includeInAll = true,
            foreverDeaths = {},
            currentDeaths = {},
        }
    end

    FillDefaults(DMT.packedSVs[world][accName].foreverDeaths)
    FillDefaults(DMT.packedSVs[world][accName].currentDeaths)

    DMT.InitializeDataStore()
    DMT.InitializeCore()
end


---------------------------------------------------------------------
-- On load
local function OnAddOnLoaded(_, addonName)
    if (addonName == DMT.name) then
        EVENT_MANAGER:UnregisterForEvent(DMT.name, EVENT_ADD_ON_LOADED)
        Initialize()
    end
end
 
EVENT_MANAGER:RegisterForEvent(DMT.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
