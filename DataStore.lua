local DMT = DeadMansTally

---------------------------------------------------------------------
-- Concats table to :; separated string
local function Concat(tab)
    local tempTable = {}
    for name, num in pairs(tab) do
        table.insert(tempTable, name .. ":" .. num)
    end
    return table.concat(tempTable, ";")
end

local function Split(str)
    local tab = {}
    for pair in string.gmatch(str, "([^;]+)") do
        local name, num
        for part in string.gmatch(pair, "([^:]+)") do
            if (not name) then
                name = part
            else
                num = part
            end
        end
        tab[name] = tonumber(num)
    end
    return tab
end
DMT.Split = Split


---------------------------------------------------------------------
--[[
["NA Megaserver"] = {
    ["@Kyzeragon"] = {
        includeInAll = true,
        foreverDeaths = {
            ungroupedplayer = "",
            group = "",
            playerpet = "",
            boss = "",
            companion = "",
            groupcompanion = "",
        },
        currentDeaths = {
            ungroupedplayer = "",
            group = "",
            playerpet = "",
            boss = "",
            companion = "",
            groupcompanion = "",
        },
    },
},
]]

local function SaveSubtable(from, to)
    for type, tab in pairs(from) do
        to[type] = Concat(tab)
    end
end

-- Before logout, convert all tables back to string storage
-- The only data that should've gotten changed is current server + account
local function SaveAll()
    local accData = DMT.packedSVs[GetWorldName()][GetUnitDisplayName("player")]
    accData.includeInAll = DMT.svs.includeInAll
    SaveSubtable(DMT.svs.foreverDeaths, accData.foreverDeaths)
    SaveSubtable(DMT.svs.currentDeaths, accData.currentDeaths)
end

---------------------------------------------------------------------
local function LoadSubtable(tab)
    local result = {}
    for type, str in pairs(tab) do
        result[type] = Split(str)
    end
    return result
end

local function LoadCurrent()
    local result = {}
    local accData = DMT.packedSVs[GetWorldName()][GetUnitDisplayName("player")]
    result.includeInAll = accData.includeInAll
    result.foreverDeaths = LoadSubtable(accData.foreverDeaths)
    result.currentDeaths = LoadSubtable(accData.currentDeaths)
    return result
end


function DMT.InitializeDataStore()
    ZO_PreHook("ReloadUI", SaveAll)
    ZO_PreHook("Logout", SaveAll)
    ZO_PreHook("SetCVar", SaveAll)
    ZO_PreHook("Quit", SaveAll)

    DMT.svs = LoadCurrent()
end
