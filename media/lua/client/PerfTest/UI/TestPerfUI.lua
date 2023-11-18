require "ISUI/ISPanel"

local PerfTest = require("PerfTest/main")
local ScrollPanel = require("PerfTest/UI/ScrollPanel")

-----------------


-- TODO List registered methods, grouped by ClassName

local TestPerfUI = ISCollapsableWindow:derive("TestPerfUI")

function TestPerfUI:new(x, y, width, height)
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    o.moveWithMouse = true

    return o
end

function TestPerfUI:createChildren()
    ISCollapsableWindow.createChildren(self)

    self.scrollPanel = ScrollPanel:new(0, 0, self.width, self.height)
    self:addChild(self.scrollPanel)
end

-- TODO Get registered methods and add them to the scroll panel
function TestPerfUI:setupScrollPanel()

    for className, tab in ipairs(PerfTest.registeredMethods) do
        print(className)

        -- TODO Create Class group

        for i=1, #tab do
            local singleMethod = tab[i]
            print(singleMethod)
            -- TODO Create single elment for the function
        end
    end
end