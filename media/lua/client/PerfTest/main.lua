---@alias methodElement { classTable : table, funcName : string }
---@alias registeredMethodTab table<string,table<integer, methodElement>>
-----------------

local PerfTest = {
    ---@type registeredMethodTab
    registeredMethods = {},
    originalMethods = {},
    times = {},
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
    
    if PerfTest.registeredMethods[className] == nil then
        PerfTest.registeredMethods[className] = {}
    end

    print("TPF: inserting " .. className .. " " .. funcName)
    table.insert(PerfTest.registeredMethods[className], {classTable = classTable, funcName = funcName})
end

---Setup registered methods
---@private
function PerfTest.SetupRegisteredMethods()
    PerfTest.print("initializing registered methods")

    for className, tab in pairs(PerfTest.registeredMethods) do
        print(className)
        for i=1, #tab do
            local singleMethod = tab[i]
            PerfTest.SetupSingleMethod(tostring(className), singleMethod.classTable, singleMethod.funcName)
        end
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

            PerfTest.times[className .. "_" .. funcName] = fTime

            --local stringToPrint = string.format(baseString, className, funcName, fTime)
            --PerfTest.print(stringToPrint)
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