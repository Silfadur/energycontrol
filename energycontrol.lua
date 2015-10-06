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
      i1=redstone.getBundledInput("back", colors.purple)
      i2=redstone.getBundledInput("back", colors.cyan)
      i3=redstone.getBundledInput("back", colors.lightGray)
      i4=redstone.getBundledInput("back", colors.gray)
      if q1 then
        redstone.setBundledInput("back", colors.brown)
      else
        redstone.setBundledInput("back", colors.white)
      end
    end
  end
end

function init()
  mon=peripheral.wrap("monitor_5")
  r=peripheral.wrap("bottom")
  cell1=peripheral.wrap("tile_thermalexpansion_cell_resonant_name_0")
  cell2=peripheral.wrap("tile_thermalexpansion_cell_resonant_name_1")
  i1,i2,i3,i4 = false
  return (mon and r and cell1 and cell2)
end

function threadMain()
  if init() then
    drawScreen()
    os.startThread(reactorControl)
    os.startThread(redstoneControl)
    local cell_max=cell1.getMaxEnergyStored()
    local cell1_curr, cell2_curr
    while true do
      local timerid = os.startTimer(5)
      local event, param
      while true do
        event, param= os.pullEvent()
        if event == "timer" and param == timerid then
          break
        end --if
      end -- while
      cell1_curr = cell1.getEnergyStored()
      cell1_curr = cell1.getEnergyStored()
      cell1_perc=math.floor(100*(cell1_curr/cell_max))
      cell2_perc=math.floor(100*(cell2_curr/cell_max))
      if cell1_perc < 10 and cell2_perc < 10 then
        q1=true
        os.queueEvent("redstone")
      end
      if cell1_perc > 90 and cell2_perc > 90 then
        q1=false
        os.queueEvent("redstone")
      end
      refreshScreen()
    end --while
  end --if
end -- threadMain

shell.run("/thread-api")
