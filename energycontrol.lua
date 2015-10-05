function drawScreen()
  print("draw screen")
end

function refreshScreen()
  print("refresh screen")
end

function reactorControl()
  print("Thread Reactorcontrol started")
  local r_max=10000000
  while true do
    r_perc=100*(r.getEnergyStored()/r_max)
    r.setAllControlRodLevels(math.floor(r_perc))
    r.setActive(i1 and r_perc < 99)
    sleep(1)
  end
end

function redstoneControl()
  while true do
    event= os.pullEvent()
    if (event == "redstone") then
      print("redstone event")
    end
  end
end

function init()
  mon=peripheral.wrap("monitor_5")
  reac=peripheral.wrap("bottom")
  cell1=peripheral.wrap("tile_thermalexpansion_cell_resonant_name_0")
  cell2=peripheral.wrap("tile_thermalexpansion_cell_resonant_name_1")
  return (mon and reac and cell1 and cell2)
end

function threadMain()
  if init() then
    drawScreen()
    os.startThread(reactorControl)
    os.startThread(redstoneControl)
    while true do
      local timerid = os.startTimer(5)
      local event, param
      while true do
        event, param= os.pullEvent()
        if event == "timer" and param == timerid then
          break
        end --if
      end -- while
      refreshScreen()
    end --while
  end --if
end -- threadMain

shell.run("/thread-api")
