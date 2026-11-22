-- COPY THIS: 
-- BetterUI by Rynx

local betterUI = {}
betterUI.Children = {}
betterUI.__index = betterUI

function betterUI:GetChildren()
    return betterUI.Children
end

function betterUI.new(name: string)
    local self = {}
    setmetatable(betterUI, self)
    
    function self:AddPowerButton()
        
    end
    
    function self:CreateTab(tabName: string)
        local tab = loadstring(game:HttpGet(""))().new(tabName)
        return tab
    end
    
    function self:Notify()
        
    end
    
    return self
end

function betterUI:Destroy()
    
end

return betterUI
