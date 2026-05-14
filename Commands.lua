local DMT = DeadMansTally

---------------------------------------------------------------------
function DMT.msg(msg)
    if (not msg) then return end
    msg = "|c3bdb5e[DMT]|caaaaaa " .. tostring(msg) .. "|r"
    if (CHAT_ROUTER) then
        CHAT_ROUTER:AddSystemMessage(msg)
    end
end


---------------------------------------------------------------------
local function PrintUsage()
    if (ZO_IsConsoleOrGameCoreUI()) then
        DMT.msg([[Usage:
|cAAAAAA/dmt tally - toggles the UI
|cAAAAAA/dmt lock
|cAAAAAA/dmt unlock
|cAAAAAA/dmt settings
|cAAAAAA/dmt reset]])
    else

---------------------------------------------------------------------
SLASH_COMMANDS["/dmt"] = function(argstring)
    local args = {}
    for word in string.gmatch(argString, "%S+") do
        table.insert(args, word)
    end

    if (#args == 0) then
        PrintUsage()
        return
    end
    local cmd = string.lower(args[1])

    local currSVs = DMT.packedSVs[GetWorldName()][GetUnitDisplayName("player")]

    ------------
    if (args[1] == "tally") then
        DMT.ToggleUI()

    elseif (args[1] == "lock") then
        DMT.Lock()

    elseif (args[1] == "unlock") then
        DMT.Unlock()

    elseif (args[1] == "settings") then
        LibAddonMenu2:OpenToPanel(DeadMansTallyOptions)

    elseif (args[1] == "reset") then
        DMT.ClearSession()

    else
        PrintUsage()
    end
end

