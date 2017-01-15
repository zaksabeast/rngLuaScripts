# Automatic RNG for FRLG Wild and Legends
[autoFrLgRNG.lua](https://github.com/zaksabeast/rngLuaScripts/blob/master/autoFrLgRNG.lua)

## Setup:
1. Edit "autoFrLRNG.lua" where it says "MAKE EDITS HERE"
  1. If you know the delay between using Pressing "A" to use Sweet Scent or to activate a Stationary/Legendary Pokemon battle, change "delayFrame" to equal the delay number
  2. If you don't know the delay, keep it at "0" and the script will figure it out automatically
  3. Edit "potentialoffset" to equal the potential amount of frames off your computer can be while attempting to RNG a Pokemon
    1. Personally, since I mainly use wine with Linux, this can be quite a bit
    2. As a general rule of thumb, for every 15,000 frames my wanted frame has, I add 1,000 to "potentialoffset", so if I'm aiming for frame 60000, I set "potentialoffset" to equal 4000
    3. In other words, wantedFrame/15 = "potentialoffset"
    4. Of course, this can change depending on your computer
2. Edit "method" to equal "1" if you are RNGing a Method 1 Pokemon, or any other value for Method H-2 or Method H-4
3. Create three empty files - "h2.csv", "h4.csv" and "1.csv" in the same directory as this script
  1. These correspond to the methods available for use with this script
4. Create a file called "target.csv" filled with the temporary info in the "Example target.csv" section of this guide in the same directory as this script (this is needed to find your starting seed)
  1. This will hold the frame info for the Pokemon you wish to obtain
    
## Usage for beginners:
1. Start the lua script with vba-rr, and get to where you press "A" to load your save
2. On the emulator screen, you'll notice some text that says "Starting Seed = XXXX"
3. Open up RngReporter, and type in the information you're using to RNG
  1. Type the starting seed into the "Seed (Hex)" field of RngReporter
  2. Make sure your TID and SID are correct
  3. Set your Method
    1. If RNGing a Shiny Wild Pokemon, change your Method to "Method H-2 (Gen 3)"
    2. If RNGing a Shiny Stationary Pokemon, such as a Legendary, change your Method to "Method 1"
  4. Check the "Shiny Only" Box
4. Press "Generate" on RngReporter
  1. If you find a spread you like, export the portential shiny spreads as "target.csv"
  2. Edit "target.csv" to contain only the line of the frame you wish to hit.
5. Uncheck "Shiny Only" in RngReporter, and export all potential frames you could hit
  1. By default, this will be 100,000 frames
  2. If you are RNGing a Method 1 Pokemon, save the csv as "1.csv"
  3. If you are RNGing a Method H-2 Pokemon, save the csv as "h2.csv"
    1. Afterwards, generate all 100,000 Method H-4 frames and save them as "h4.csv"
6. Back in vba-rr, click "Restart" on the "Lua Script" window for it to load all the information
7. Setup your emulator so that Pressing "A" will enter a battle (either with Sweet Scent, or a Stationary Pokemon)
  1. Check the screenshots for more info
8. Let the emulator run with the lua script, and it will hit your target Pokemon
  1. The emulator will have text saying "Target Pokemon Hit" when this happens
  2. If lua gives you an prompt saying "Lua has been running for a long time.  Do you wish to kill it?", click "No".  This happens because of the amount of variables it is loading when it first runs.

## Usage for more advanced users:
1. Start the lua script with vba-rr, and get to where you press "A" to load your save
2. On the emulator screen, you'll notice some text that says "Starting Seed = XXXX"
3. Open RngReporter, and use the starting seed in the "Seed (Hex)" field
4. Find the frame you wish to hit, and export the results containing your frame as "target.csv"
  1. Edit "target.csv" to only contain the line of the frame you wish to hit
5. Export all the frames around the frame you wish to hit
  1. I just do all 100,000 frames that appear
  2. If attempting Method 1, export these results as "1.csv"
  3. If attempting Method H-2 or Method H-4, export both results as "h2.csv" and "h4.csv" respectively
6. Restart the lua script
7. Setup your emulator so that Pressing "A" will enter a battle (either with Sweet Scent, or a Stationary Pokemon)
  1. Check the screenshots for more info
8. Let the emulator run with the lua script, and it will hit your target Pokemon
  1. The emulator will have text saying "Target Pokemon Hit" when this happens
  2. If lua gives you an prompt saying "Lua has been running for a long time.  Do you wish to kill it?", click "No".  This happens because of the amount of variables it is loading when it first runs.

### Example target.csv
```
24352,24364,6:45.86,5,837FDBCB,!!!,Timid,1,15,15,13,2,14,11,Ground,67,M,M,M,M,
```

### Screenshots
[![WildSetup](autoFrLgRNGWild1.png?raw=true)](autoFrLgRNGWild1.png)
[![WildRNG](autoFrLgRNGWild2.png?raw=true)](autoFrLgRNGWild2.png)
[![LegendSetup](autoFrLgRNG-0.png?raw=true)](autoFrLgRNG-0.png)
[![LegendRNG](autoFrLgRNG-1.png?raw=true)](autoFrLgRNG-1.png)

### Credits
* Thanks to http://stackoverflow.com/a/5032014 for string:split
* Thanks to http://stackoverflow.com/a/21287623 for newAtuotable
* Thanks to FractalFusion and Kaphotics for the base of this script
