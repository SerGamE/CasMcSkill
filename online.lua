local admins = {
  {"Тех.Админ","lLuffy","0xFF0000","0xFFFFFF","0","false"},
  {"Куратор","TheTzdDark","0xFF0000","0xFFFFFF","0","false"},
  {"Гл.Модератор","poiji","0x006DFF","0x33B6BF","0","false"},
  {"Гейм Дизайнер","supernovus","0x006DFF","0x33B6BF","0","false"},
  {"Модератор","vitasuper","0xFF55FF","0xFF9200","0","false"},
  {"Модератор","zeplin","0xFF55FF","0xFF9200","0","false"},
  {"Модератор","Dv1Corn","0xFF55FF","0xFF9200","0","false"},
  {"Помощник","Keengit","0x00FF00","0x00FF00","0","false"},
  {"Помощник","Dipressiv","0x00FF00","0x00FF00","0","false"},
  {"Хозяин","Ser6amE","0xFF0000","0xFF0000","0","false"}
}
 
local com = require("component")
local computer = require("computer")
local unicode = require("unicode")
local fs = require('filesystem')
local event = require("event")
local gpu = com.gpu
local run = true
 
local w, h = 80, 25
local w2 = w / 2
 
local function get_time()
  local time_correction = 3
  io.open('/tmp/clock.dt', 'w'):write(''):close()
  return tonumber(string.sub(fs.lastModified('/tmp/clock.dt'), 1, -4)) + time_correction * 3600
end
 
local function save()
  local f = io.open("/home/tbl", "w")  
  f:write("List = {")
  for ind = 1,#admins do
    local w = tonumber(admins[ind][5])
    if ind == #admins then
      f:write(w)
    else
      f:write(w..',')
    end
  end
  f:write("}")
  f:close()
end
 
if not fs.exists("/home/tbl") then
  save()
end  
dofile("/home/tbl")
local t = {}
local t = List
local start_time = get_time()
for ind = 1,#t do
  if t[ind] == 0 then
    admins[ind][5] = start_time
  else
    admins[ind][5] = t[ind]
  end
end
for ind = 1,#admins do
  computer.removeUser(admins[ind][2])
end
os.execute("cls")
print("Коснитесь экрана")
computer.addUser(({event.pull("touch")})[6])
os.execute("cls")
gpu.setResolution(w, h)
gpu.setBackground(0x000000)
gpu.setForeground(0x333333)
for i = 1,w do
  gpu.set(i,1,"=")
  gpu.set(i,h,"=")
end
for i = 1,h do
  gpu.set(1, i, "||")
  gpu.set(w-1, i, "||")
end
gpu.setForeground(0x66FF00)
gpu.set(w2 - unicode.len("[ OpenAdmins ]")/2,1,"[ OpenAdmins ]")
gpu.set(w2 - unicode.len("Список администрации")/2,3,"Список администрации")
local line = 10
for ind = 1,#admins do
  gpu.setForeground(0x2D2D2D)
  gpu.set(10,line,"[")
  gpu.set(11+unicode.len(admins[ind][1]),line,"]")
  gpu.setForeground(tonumber(admins[ind][3]))
  gpu.set(11,line,admins[ind][1])
  gpu.setForeground(tonumber(admins[ind][4]))
  gpu.set(30,line,admins[ind][2])
  line = line + 1
end
 
while run do
  local current_time = get_time()
  local line = 10
  for ind = 1,#admins do
    if computer.addUser(admins[ind][2]) then
      computer.removeUser(admins[ind][2])
      gpu.setForeground(0x00FF00)
      gpu.set(47,line,"online ")
    else
      gpu.setForeground(0x2D2D2D)
      gpu.set(47,line,"offline")
    end
     line = line + 1
  end
  local e = ({event.pull(5,"key_down")})[4]
  if e == 29 or e == 157 then -- Ctrl Выход
    save()
    gpu.setResolution(w,h)
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
    os.execute("cls")
    run = false
    os.exit()
  end
end
 
if run then
  computer.shutdown(false)
end
