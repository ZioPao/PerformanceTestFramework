--- TODO should be similiar in use to  Test Framework

local PerfTest = {
    ogMethods = {}
}
local os_time = os.time

local function PrintToLog(str)
    if str ~= nil then
        print("TEST_PERF_FRAMWORK: " .. str)
    end
end

---comment
---@param classTable table
---@param funcName string Name of the function. Can be static or an object method
function PerfTest.RegisterMethod(className, classTable, funcName)
    PerfTest.ogMethods[funcName] = classTable[funcName]

    classTable[funcName] = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
        local sTime = os_time()
        PerfTest.ogMethods[funcName](arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
        print("Test Perf Framework")
        local eTime = os_time()
        local fTime = eTime - sTime
        local stringToPrint = className .. " " .. funcName .. " -> " .. tostring(fTime)
        PrintToLog(stringToPrint)
    end
end


-- TODO Server ping pong checks?



return PerfTest