-- If delayFrame=0, the script will attempt to find the delay itself
-- If method=1, then 1.csv will be read, any other value will use h2.csv and h4.csv
-- Set reporter to either "9.96.6-beta" if you are using that version with Windows or "9.93-beta" for use with Linux and Mac with Wine, or that version with Windows.

-- MAKE EDITS HERE
local delayFrame=0
local potentialoffset = 1000
local method = 2
local reporter = "9.96.6-beta"
-- DON'T EDIT PAST HERE

-- Thanks to http://stackoverflow.com/a/5032014 for string:split
-- Thanks to http://stackoverflow.com/a/21287623 for newAtuotable
-- Thanks to FractalFusion and Kaphotics for the base of this script

function closestTo(goal, num1, num2)
    local temp1 = goal-num1
    local temp2 = goal-num2
    if(temp1<0) then
        temp1=temp1*-1
    end
    if(temp2<0) then
        temp2=temp2*-1
    end
    print("temp1 = "..temp1.." temp2 = "..temp2)
    if(temp1<temp2) then
        return num1
    else
        return num2
    end
end

function csvToArray(fileName, method, reporter)
    local keysTxt=io.open(fileName, "r")
    local targetList = newAutotable(2)
    local line=1
    local row=1
    local pidCol
    if(method~=1) or  (reporter=="9.96.6-beta") then
        pidCol = 5
    elseif (reporter=="9.93-beta") then
        pidCol = 4
    end
    for keyLine in keysTxt:lines() do
        local tempShine=keyLine:split(",")
        if(string.match(tempShine[1],"%d")) then
            targetList[row][0] = tempShine[1]
            targetList[row][1] = tempShine[pidCol]
            row=row+1
        end
        line=line+1
    end
    keysTxt:close()
    return targetList
end

function string:split(delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end


function newAutotable(dim)
    local MT = {};
    for i=1, dim do
        MT[i] = {__index = function(t, k)
            if i < dim then
                t[k] = setmetatable({}, MT[i+1])
                return t[k];
            end
        end}
    end
    return setmetatable({}, MT[1]);
end

function pid2frame(needle, haystack, wantedFrame, lastPer)
    i=1
    closestFrame = 300000
    while i<table.getn(haystack) do
        if(haystack[i][1]==needle)then
            tempClose = haystack[i][0]-wantedFrame
            if tempClose<0 then
                tempClose=tempClose*-1
            end
            if(lastPer~=needle) then
                if (closestFrame-wantedFrame)>tempClose then
                    closestFrame=haystack[i][0]
                end
            else
                closestFrame=haystack[i][0]
            end
        end
        i=i+1
    end
    if(closestFrame==300000) then
        return 0
    else
        return closestFrame
    end
end

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
local start=0x0202402C
local startSeed
local tempFrame1, tempFrame2
local personality
local lastPer = 0
local trainerid
local magicword
local growthoffset, miscoffset
local saveNum = savestate.create()
local species
local ivs, hpiv, atkiv, defiv, spdiv, spatkiv, spdefiv
local nature, natinc, natdec
local hidpowbase, hidpowtype
local i
local h2List, h4List, method1List
if(method~=1) then
    h2List = csvToArray("h2.csv", 2, reporter)
    h4List = csvToArray("h4.csv", 4, reporter)
else
    method1List = csvToArray("1.csv", 1, reporter) 
end
local targetList = csvToArray("target.csv")
local joypress={}
joypress["A"]=1
local tid, sid
local saveBool=true
local offset=0
local wantedFrame=tonumber(targetList[1][0])
local targetPID=targetList[1][1]
local targetFrame=wantedFrame-delayFrame
local oldPer=0
local delayCalc=0
local hitFrame
local infoString, memo
print("Attempting Frame "..wantedFrame)
memo="Attempting to hit target..."
while true do
    startSeed = string.format("%04X",memory.readword(0x02020000))
    if (saveBool==true) and ((wantedFrame-potentialoffset)==frameNum) then
        savestate.save(saveNum)
        print("Savestate made on frame "..frameNum)
        saveBool=false
    end
    personality=memory.readdwordunsigned(start)
    trainerid=memory.readdwordunsigned(start+4)
    magicword=bit.bxor(personality, trainerid)
    seed=memory.readdwordunsigned(0x03005000)

    i=personality%24

    if i<=5 then
        growthoffset=0
    elseif i%6<=1 then
        growthoffset=12
    elseif i%2==0 then
        growthoffset=24
    else
        growthoffset=36
    end

    if i>=18 then
        miscoffset=0
    elseif i%6>=4 then
        miscoffset=12
    elseif i%2==1 then
        miscoffset=24
    else
        miscoffset=36
    end

    species=bit.band(bit.bxor(memory.readdwordunsigned(start+32+growthoffset),magicword),0xFFF)
    ivs=bit.bxor(memory.readdwordunsigned(start+32+miscoffset+4),magicword)
 
    hpiv=bit.band(ivs,0x1F)
    atkiv=bit.band(ivs,0x1F*0x20)/0x20
    defiv=bit.band(ivs,0x1F*0x400)/0x400
    spdiv=bit.band(ivs,0x1F*0x8000)/0x8000
    spatkiv=bit.band(ivs,0x1F*0x100000)/0x100000
    spdefiv=bit.band(ivs,0x1F*0x2000000)/0x2000000
 
    nature=personality%25
    natinc=math.floor(nature/5)
    natdec=nature%5
 
    hidpowtype=math.floor(((hpiv%2 + 2*(atkiv%2) + 4*(defiv%2) + 8*(spdiv%2) + 16*(spatkiv%2) + 32*(spdefiv%2))*15)/63)
    hidpowbase=math.floor(((bit.band(hpiv,2)/2 + bit.band(atkiv,2) + 2*bit.band(defiv,2) + 4*bit.band(spdiv,2) + 8*bit.band(spatkiv,2) + 16*bit.band(spdefiv,2))*40)/63 + 30)
 
    gui.text(0,0,"Stats")
    gui.text(30,0,"HP  "..memory.readwordunsigned(start+86))
    gui.text(65,0,"Atk "..memory.readwordunsigned(start+90))
    gui.text(99,0,"Def "..memory.readwordunsigned(start+92))
    gui.text(133,0,"SpA "..memory.readwordunsigned(start+96))
    gui.text(167,0,"SpD "..memory.readwordunsigned(start+98))
    gui.text(201,0,"Spe "..memory.readwordunsigned(start+94))

    gui.text(0,8,"IVs")
    gui.text(30,8,"HP  "..hpiv)
    gui.text(65,8,"Atk "..atkiv)
    gui.text(99,8,"Def "..defiv)
    gui.text(133,8,"SpA "..spatkiv)
    gui.text(167,8,"SpD "..spdefiv)
    gui.text(201,8,"Spe "..spdiv)

    gui.text(0,40,"PID:  "..string.format("%08X", personality))
    gui.text(60,40,"IVs: "..string.format("%08X", ivs))
    gui.text(0,50,"Nature: "..naturename[nature+1])
    gui.text(0,60,natureorder[natinc+1].."+ "..natureorder[natdec+1].."-")
    gui.text(167,15,"HP "..typeorder[hidpowtype+1].." "..hidpowbase)
    frameNum=vba.framecount()+offset
    gui.text(0,95,"Current Frame: "..frameNum)
    gui.text(0,105,"Seed: "..string.format("%8X", seed))
    if(frameNum==targetFrame) then
        joypad.set(1,joypress)
        if(delayFrame==0) then
            delayCalc=frameNum
        end
    end
    if(personality~=0) then
        if(delayFrame==0) then
            delayFrame = frameNum-delayCalc
            memo = "Set delay = "..delayFrame
            print(memo)
            savestate.load(saveNum)
        elseif(oldPer~=personality) then
            if(string.upper(string.format("%08x",personality))~=targetPID) then
                oldPer=personality
                infoString = "targetFrame="..wantedFrame.."\ndelay="..delayFrame.."\noffset="..offset
                -- Set offset
                if(method~=1) then
                    tempFrame1 = tonumber(pid2frame(string.upper(string.format("%08x",personality)), h2List, wantedFrame, lastPer))
                    tempFrame2 = tonumber(pid2frame(string.upper(string.format("%08x",personality)), h4List, wantedFrame, lastPer))
                    hitFrame = closestTo(wantedFrame, tempFrame1, tempFrame2)
                else
                    hitFrame = tonumber(pid2frame(string.upper(string.format("%08x",personality)), method1List, wantedFrame, lastPer))
                end
                if(hitFrame~=0) then
                    offset=offset+hitFrame-wantedFrame
                else
                    offset=offset+1
                end
                lastPer=personality
                memo = "Adjusted slightly for offset! PID hit was "..string.upper(string.format("%08x",personality))
                print(memo)
                print("Set offset = "..offset)
                savestate.load(saveNum)
            end
        else
            memo = "Target Pokemon Hit!"
        end
    end
    gui.text(0,115,memo)
    gui.text(0,125,"Starting Seed = "..startSeed)
    emu.frameadvance()

end
