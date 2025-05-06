local defaultColor = "green"
local currentColor = defaultColor


local function formatColor(color)
    --print("^3[ox_target] Formatting color: ^7", json.encode(color))
    
    if type(color) == "table" and color.background then
        --print("^2[ox_target] Using background color from LumiHud: ^7", color.background)
        return color.background
    end

    if type(color) == "string" and (color:sub(1,1) == "#" or color:match("^%a+$")) then
        return color
    end
    
    if type(color) == "table" then
        if color.r and color.g and color.b then
            return string.format("#%02X%02X%02X", 
                math.floor(color.r * 255), 
                math.floor(color.g * 255), 
                math.floor(color.b * 255))
        elseif #color >= 3 then
            return string.format("#%02X%02X%02X", 
                math.floor(color[1] * 255), 
                math.floor(color[2] * 255), 
                math.floor(color[3] * 255))
        end
    end
    
    --print("^1[ox_target] Could not format color: ^7", json.encode(color))
    return defaultColor
end

local function updateTargetColor(color)
    if not color then 
        --print("^1[ox_target] No color provided to updateTargetColor^7")
        return 
    end
    
    local formattedColor = formatColor(color)
    currentColor = formattedColor
    
    --print("^2[ox_target] Updating target color to: ^7", formattedColor)
    
    SendNUIMessage({
        action = "updateColor",
        color = formattedColor
    })
    
    --print("^3[ox_target] NUI message sent with color: ^7", formattedColor)
end

AddEventHandler("tgiann-lumihud:setLumiHudColor", function(color)
    --print("^2[ox_target] Received tgiann-lumihud:setLumiHudColor event with color: ^7", json.encode(color))
    updateTargetColor(color)
end)

AddEventHandler("setLumiHudColor", function(color)
    --print("^2[ox_target] Received setLumiHudColor event with color: ^7", json.encode(color))
    updateTargetColor(color)
end)

RegisterNUICallback('setTargetColor', function(color, cb)
    --print("^2[ox_target] Received setTargetColor NUI callback with color: ^7", json.encode(color))
    updateTargetColor(color)
    cb("")
end)


exports('setTargetColor', updateTargetColor)

RegisterCommand('targetcolor', function(source, args)
    local color = args[1] or defaultColor
    --print("^2[ox_target] Command used to change color to: ^7", color)
    updateTargetColor(color)
end, false)

-- Initialize with default color
Citizen.CreateThread(function()
    Wait(1000) -- Wait for NUI to load
    --print("^2[ox_target] Initializing with default color: ^7", defaultColor)
    updateTargetColor(defaultColor)
end)

--print("^2[ox_target] LumiHud integration loaded^7")