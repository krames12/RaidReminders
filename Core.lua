-- This addon is using the Ace3 addon framework
local RaidReminders = LibStub("AceAddon-3.0"):NewAddon("RaidReminders", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local eventFrame, events = CreateFrame("Frame"), {}

-- Will probably need to refactor config stuff into it's own file
-- local AceConfig = LibStub("AceConfig-3.0")
-- AceConfig:RegisterOptionsTable("RaidReminders", {}, {"/raidreminders", "/rr"})

local configOptionsTable = {
  type = "group",
  args = {
    bfa={
      name = "Battle for Azeroth",
      type = "group",
      args={
        -- nyalotha={
        --   name = "Ny'alotha"
        --   type = "group",
        --   args={
        --     wrathion={
        --       name = "Wrathion",
        --       type = "group",
        --       args={

        --       }
        --     }
        --   }
        -- }
        freehold={
          name = "Freehold - Dungeon",
          type = "group",
          args={
            text={
              name = "Text",
              type = "input"
            },
            timer={
              name = "Timer (in seconds)",
              type = "range",
              min = 0,
              max = 999,
              -- below: not working when trying to `get`
              -- set = function(info, value) RaidReminders.bfa.freehold.timer = value end,
              -- get = function(info) return RaidReminders.bfa.freehold.timer end
            }
          }
        }
      }
    }
  }
}

function RaidReminders:OnInitialize()
  -- Code that's run when first loaded
  -- init DB
  self.db = LibStub("AceDB-3.0"):New("RaidRemindersDB", defaults)

  -- AceDBOption profile handler
  configOptionsTable.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

  local isConfigOpen = false

  -- Registers slash command to open the Raid Reminders Window
  AceConfig:RegisterOptionsTable("RaidReminders", configOptionsTable)
  self:RegisterChatCommand("raidreminders", "RaidRemindersToggleWindow")
  self:RegisterChatCommand("raidrem", "RaidRemindersToggleWindow")
  self:RegisterChatCommand("rr", "RaidRemindersToggleWindow")

  -- Registers the encounter start and end events for when 
  self:RegisterEvent("ENCOUNTER_START", "EncounterStart")
  self:RegisterEvent("ENCOUNTER_END", "EncounterEnd")
end

function RaidReminders:OnEnable()
  -- Called when addon is enabled
end

function RaidReminders:OnDisable()
  -- When addon is disabled
end

--
-- UI --
--
local function showFrame()
  AceConfigDialog:SetDefaultSize("RaidReminders", 800, 600)
  AceConfigDialog:Open("RaidReminders")
end

function RaidReminders:RaidRemindersToggleWindow(input)
  -- If the config window is open, typing the command will not cause it to open multiple instances of it.
  showFrame()
end

local textstore

function createNewReminder(parentFrame)
  local editbox = AceGUI:Create("EditBox")
  editbox:SetLabel("Testing the test:")
  editbox:SetWidth(200)
  editbox:SetCallback("OnEnterPressed",
    function(widget, event, text)
      textstore = text
    end
  )
  parentFrame:AddChild(editbox)
end

--
-- Combat Timer --
--
function RaidReminders:ScheduleReminder(text, time, delay)
  -- math out delay and time
  RaidReminders:ScheduleTimer(function() print(text) end, time)
end

function RaidReminders:EncounterStart(...)
  print("Combat has started")

  -- Start timers based on ones set in the configuration
    -- Config needs to be created first

  -- Load reminders based on what boss encounter has been engaged

  -- Test reminders
  self:ScheduleReminder("Weapon buffs", 3)
  self:ScheduleReminder("Pop Heroism", 8)
  self:ScheduleReminder("RESET BOSS", 15)
end

function RaidReminders:EncounterEnd(...)
  print("Combat has Ended")

  RaidReminders:CancelAllTimers()
end
function events:ENCOUNTER_START(...)
  print("Combat has started")
end

function events:ENCOUNTER_END(...)
  print("Combat has ended")
end

-- Config example
-- local options = {
  -- Array of bosses & data per boss per instance
  -- Check difficulty?
--   ["reminders"] = [
--     "xanesh" : [
--       {
--         ["timer"]: 110,
--         ["text"]: "Pop your wings ya numbskull",
--         ["buffer"]: 5,
--         ["sound"]: "../path-to-sound"
--       },
--       { ... }
--     ],
--     "vexiona": [
--       {...}
--     ]
--   ]

--   ["profile"] = {
--     ["positionX"]: 532
--   }

--   addReminder = function(self, args)
--     self["reminders"]
--   end
-- }