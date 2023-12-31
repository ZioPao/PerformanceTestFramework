-- !!! Lifted from TestFramework for now from NOTLOC


local LayoutElement = require "PerfTest/UI/LayoutElement"
------------------

---@class VerticalLayout : LayoutElement
local VerticalLayout = LayoutElement:derive("VerticalLayout")

function VerticalLayout:new(x, y, width, height)
    local o = LayoutElement:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    return o
end

function VerticalLayout:addElement(element)
    if element.fillY then
        element.fillY = false
    end
    LayoutElement.addElement(self, element)
end

function VerticalLayout:reflow()
    LayoutElement.reflow(self)

    local x = self.marginX
    local y = self.marginY
    for _, element in ipairs(self.elements) do
        element:setX(x)
        element:setY(y)

        local h = element:getMaxDrawHeight() ~= -1 and element:getMaxDrawHeight() or element:getHeight()
        y = y + h + self.paddingY
    end
    self:setHeight(y + self.marginY - self.paddingY)
end

return VerticalLayout
