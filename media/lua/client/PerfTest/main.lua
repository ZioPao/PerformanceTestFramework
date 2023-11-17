---@alias registeredMethodTab {className : string, classTable : table, funcName : string}

-----------------

PerfTest = {
    ---@type table<registeredMethodTab>
    registeredMethods = {},
    originalMethods = {},
    isEnabled = true
}

local baseString = "%s %s -> %.6f ms"
local os_time = os.time


function PerfTest.print(str)
    print("PTF: " .. tostring(str))
end

---Run it to initialize PerfTest
function PerfTest.Init()
    local function OnGameStart()
        local function WaitForPerfTest()
            local cTime = os.time()
            if cTime > PerfTest.startTime then
                print("Perf test initialized")
                PerfTest.SetupRegisteredMethods()
                Events.OnTick.Remove(WaitForPerfTest)
            end
        end
        PerfTest.startTime = os.time() + 1
        Events.OnTick.Add(WaitForPerfTest)

    end
    Events.OnGameStart.Add(OnGameStart)
end

---Register a method that will be initialized after a while
---@param className string
---@param classTable table
---@param funcName string Name of the function. Can be static or an object method
function PerfTest.RegisterMethod(className, classTable, funcName)
    table.insert(PerfTest.registeredMethods, {className = className, classTable = classTable, funcName = funcName})
end

---Setup registered methods
---@private
function PerfTest.SetupRegisteredMethods()
    PerfTest.print("initializing registered methods")
    for i=1, #PerfTest.registeredMethods do
        local regTab = PerfTest.registeredMethods[i]
        PerfTest.SetupSingleMethod(regTab.className, regTab.classTable, regTab.funcName)
    end
end

---Setup a single method and stores the og one in PerfTest.originalMethods table
---@param className string
---@param classTable table
---@param funcName string
---@private
function PerfTest.SetupSingleMethod(className, classTable, funcName)
    local index = className .. "_" .. funcName
    PerfTest.originalMethods[index] = classTable[funcName]
    classTable[funcName] = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
        local sTime
        if PerfTest.isEnabled then
            sTime = os_time()
        end
        PerfTest.originalMethods[index](arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
        if PerfTest.isEnabled then
            local eTime = os_time()
            local fTime = (eTime - sTime)*1000 -- convert them to ms
            local stringToPrint = string.format(baseString, className, funcName, fTime)
            PerfTest.print(stringToPrint)
        end
    end

end

-----------------------------
--* Settings *--

---Toggle printing PTF stats
function PerfTest.TogglePrintout()
    PerfTest.isEnabled = not PerfTest.isEnabled
end

-- TODO Server ping pong checks?


return PerfTest