local natureorder={"Atk","Def","Spd","SpAtk","SpDef"}
local naturename={
"Hardy","Lonely","Brave","Adamant","Naughty",
"Bold","Docile","Relaxed","Impish","Lax",
"Timid","Hasty","Serious","Jolly","Naive",
"Modest","Mild","Quiet","Bashful","Rash",
"Calm","Gentle","Sassy","Careful","Quirky"}
local typeorder={
"Fighting","Flying","Poison","Ground",
"Rock","Bug","Ghost","Steel",
"Fire","Water","Grass","Electric",
"Psychic","Ice","Dragon","Dark"}

--EDIT THESE VALUES
local targetSaveHour=0
local targetSaveMinute=57
local targetSaveSecond=0
local targetsixtiethSecond=1
local targetJirachiSeed=0xF500
local savedelaySecond=1
local savedelayFrame=47

--DON'T EDIT ANYTHING BEYOND HERE
local time=0x2F64EB3
local startMinute=0
local startSecond=0
local startsixtiethSecond=0
local startHour=0
local start=0x030045C0
local realSaveHour=0
local realSaveMinute=0
local realSaveSecond=0
local realSaveFrame=0

if targetSaveSecond<savedelaySecond then
     realSaveMinute = targetSaveMinute - 1
     realSaveSecond = 60 + targetSaveSecond - savedelaySecond
end

if targetsixtiethSecond<savedelayFrame then
     realSaveSecond = realSaveSecond - 1
     realSaveFrame = 60 + targetsixtiethSecond - savedelayFrame
end

while true do
    tid=memory.readwordunsigned(0x2024EAE)
    sid=memory.readwordunsigned(0x2024EB0)
    minute=memory.readbyte(time+0x01)
    second=memory.readbyte(time+0x02)
    sixtiethSecond=memory.readbyte(time+0x03)
    hour=memory.readword(0x2024EB2)
    money=memory.readwordunsigned(0x2F25BC4)
    seed=memory.readdwordunsigned(0x03004818)
    gui.text(4,20,"Save Delay: "..savedelaySecond..":"..savedelayFrame)
    gui.text(4,30,"Target Save Time:  "..targetSaveHour..":"..targetSaveMinute..":"..targetSaveSecond..":"..targetsixtiethSecond)
    gui.text(4,40,"Real Save Time:  "..targetSaveHour..":"..realSaveMinute..":"..realSaveSecond..":"..realSaveFrame)
    gui.text(4,50,"Time:  "..hour..":"..minute..":"..second..":"..sixtiethSecond)
    gui.text(4,60,"Money: "..money)
    gui.text(4,70,"TID: "..tid)
    gui.text(4,80,"SID: "..sid)
    gui.text(4,100,"Target Jirachi Seed: 0x"..string.format("%X", targetJirachiSeed))
    gui.text(4,110,"Frame: "..vba.framecount()) 
    gui.text(4,120,"Seed: "..string.format("%8X", seed))
    print("Seed: "..string.format("%8X", seed))
    emu.frameadvance()
end
