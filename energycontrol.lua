function reactorControl()
  print("reactorControl")
end


function threadMain()
  os.startThread(reactorControl)
  print("Main thread")
end

shell.run("/thread-api")
