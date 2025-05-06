Citizen.CreateThread(function()
    Wait(2000) 
    local success = pcall(function()
        if exports['tgiann-lumihud'] and exports['tgiann-lumihud'].getCurrentColor then
            local color = exports['tgiann-lumihud']:getCurrentColor()
            --print("^2[ox_target] Got color from LumiHud export: ^7", json.encode(color))
            exports['ox_target']:setTargetColor(color)
        end
    end)
    
    if not success then
        --print("^1[ox_target] Could not get color from LumiHud export^7")
    end
end)

exports('updateTargetColor', function(color)
    --print("^2[ox_target] LumiHud called updateTargetColor export with color: ^7", json.encode(color))
    exports['ox_target']:setTargetColor(color)
    return true
end)