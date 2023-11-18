require "ISUI/ISPanel"

local PerfTest = require("PerfTest/main")
local ScrollPanel = require("PerfTest/UI/ScrollPanel")
local VerticalLayout = require("PerfTest/UI/VerticalLayout")
local HorizontalLayout = require("PerfTest/UI/HorizontalLayout")
local CollapseList2 = require("PerfTest/UI/CollapseList")

-----------------
local BORDER_COLOR = {r=1, g=1, b=1, a=0.4}


-- TODO List registered methods, grouped by ClassName

TestPerfUI = ISPanel:derive("TestPerfUI")

function TestPerfUI:new(x, y, width, height)
    print("Starting TestPerfUI")
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    o.moveWithMouse = true
    o.timePanels = {}

    return o
end

function TestPerfUI:createChildren()
    ISPanel.createChildren(self)
    print("Starting CreateChildren TestPerfUI")


    self.scrollPanel = ScrollPanel:new(0, 30, self.width, self.height)
    self:addChild(self.scrollPanel)
    self:setupScrollPanel()
end

-- TODO Get registered methods and add them to the scroll panel
function TestPerfUI:setupScrollPanel()

    self.collapseMap = {}

    local scrollbarWidth = 13

    local layout = VerticalLayout:new(0, 0, self.scrollPanel:getWidth() - scrollbarWidth, self.scrollPanel:getHeight())
    local width = self.scrollPanel:getWidth() - layout.marginX*2 - scrollbarWidth + 5

    for className, tab in pairs(PerfTest.registeredMethods) do
        print("TPF: INITIALIZING FOR CLASS: " .. className)
        local classCollapseList = CollapseList2:new(0, 0, width, 24)
        local horizontalLayout = HorizontalLayout:new(classCollapseList.marginX, 0, width - classCollapseList.marginX, 24)
        local classLabel = ISLabel:new(0, 0, 20, className, 1, 1, 1, 1, UIFont.Medium)
        horizontalLayout:addElement(classLabel)
        classCollapseList:addElement(horizontalLayout)

        -- TODO Create Class group
        self.collapseMap[className] = classCollapseList

        for i=1, #tab do
            print("TPF: " .. tostring(i))
            ---@type methodElement
            local singleMethod = tab[i]
            print(singleMethod)
            print("TPF: INITIALIZING FOR FUNC: " .. singleMethod.funcName)
            local methodLayout = HorizontalLayout:new(classCollapseList.marginX, 0, width, 24)
            
            local methodLabel = ISLabel:new(0, 0, 20, singleMethod.funcName, 1, 1, 1, 1, UIFont.Medium)
            methodLayout:addSpacer(5)
            methodLayout:addElement(methodLabel)

            local methodTime = ISLabel:new(0, 0, 20, "", 1, 1, 1, 1, UIFont.Medium)
            methodLayout:addRightAnchoredChild(methodTime, 76, 0)

            methodLayout.borderColor = BORDER_COLOR
            methodLayout.marginY = 2
            methodLayout.marginLeft = 8
            classCollapseList:addElement(methodLayout)


            self.timePanels[className .. "_" .. singleMethod.funcName] = methodTime


            -- TODO Create single elment for the function
        end

        layout:addElement(classCollapseList)
    end

    self.scrollPanel:addElement(layout)
end


function TestPerfUI:render()
    ISPanel.render(self)

    for k, panel in pairs(self.timePanels) do
        -- get fTime
        local fTime = PerfTest.times[k]
        panel:setName(tostring(fTime))
    end
end

function TestPerfUI:setCollapseState(collapseState)
    for k, v in pairs(collapseState) do
        if self.collapseMap[k] then
            self.collapseMap[k]:setCollapsed(v)
        end
    end
end

function TestPerfUI:prerender()
    ISPanel.prerender(self)


end

function TestPerfUI.Open()
    local instance = TestPerfUI:new(100, 100, 600, 400)
    instance:initialise()
    instance:addToUIManager()
    instance:setVisible(true)
end
