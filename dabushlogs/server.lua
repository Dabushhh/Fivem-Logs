local deathWebhook = "https://discord.com/api/webhooks/1349885217305006171/XCL8rYpDvJnyPMkm3sBzNYyuDxPkLfuHa6B9yiQGu-uyuAi0ek-6NB_dnPTeKNehd_pW"
local joinLeaveWebhook = "https://discord.com/api/webhooks/1349885217305006171/XCL8rYpDvJnyPMkm3sBzNYyuDxPkLfuHa6B9yiQGu-uyuAi0ek-6NB_dnPTeKNehd_pW"
local shootWebhook = "https://discord.com/api/webhooks/1349885217305006171/XCL8rYpDvJnyPMkm3sBzNYyuDxPkLfuHa6B9yiQGu-uyuAi0ek-6NB_dnPTeKNehd_pW"
local commandWebhook = "https://discord.com/api/webhooks/1349885217305006171/XCL8rYpDvJnyPMkm3sBzNYyuDxPkLfuHa6B9yiQGu-uyuAi0ek-6NB_dnPTeKNehd_pW"
local chatWebhook = "https://discord.com/api/webhooks/1349885217305006171/XCL8rYpDvJnyPMkm3sBzNYyuDxPkLfuHa6B9yiQGu-uyuAi0ek-6NB_dnPTeKNehd_pW"

function sendLog(webhook, title, description, color)
    if webhook == "" then return end -- Prevent empty webhook calls
    local connect = {
        {
            ["title"] = title,
            ["description"] = description,
            ["color"] = color
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "FiveM Logs", embeds = connect}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    sendLog(joinLeaveWebhook, "Player Connected", "**" .. name .. "** has joined the server.", 65280)
end)

AddEventHandler('playerDropped', function(reason)
    local playerName = GetPlayerName(source)
    sendLog(joinLeaveWebhook, "Player Disconnected", "**" .. playerName .. "** has left the server. Reason: " .. reason, 16711680)
end)

AddEventHandler('gameEventTriggered', function(eventName, args)
    if eventName == "CEventNetworkEntityDamage" then
        local victim = args[1]
        local attacker = args[2]
        if IsEntityAPed(victim) and IsPedAPlayer(victim) then
            local victimName = GetPlayerName(NetworkGetEntityOwner(victim))
            local attackerName = "Environment"
            if IsEntityAPed(attacker) and IsPedAPlayer(attacker) then
                attackerName = GetPlayerName(NetworkGetEntityOwner(attacker))
            end
            sendLog(deathWebhook, "Player Death", "**" .. victimName .. "** was killed by **" .. attackerName .. "**", 16753920)
        end
    end
end)

AddEventHandler('gameEventTriggered', function(eventName, args)
    if eventName == "CEventNetworkGunShot" then
        local shooter = args[1]
        if IsPedAPlayer(shooter) then
            local shooterName = GetPlayerName(NetworkGetEntityOwner(shooter))
            sendLog(shootWebhook, "Player Shooting", "**" .. shooterName .. "** fired a weapon.", 255)
        end
    end
end)

RegisterCommand("*", function(source, args, rawCommand)
    if rawCommand ~= "playerfocus" then
        local playerName = GetPlayerName(source)
        sendLog(commandWebhook, "Command Used", "**" .. playerName .. "** used command: " .. rawCommand, 3447003)
    end
end, true)

AddEventHandler('chatMessage', function(source, name, message)
    if message ~= "/playerfocus" then
        sendLog(chatWebhook, "Chat Message", "**" .. name .. "**: " .. message, 15844367)
    end
end)