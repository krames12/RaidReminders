-- This addon is using the Ace3 addon framework
local RaidReminders = LibStub("AceAddon-3.0"):NewAddon("RaidReminders", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0")

-- Will probably need to refactor config stuff into it's own file
-- local AceConfig = LibStub("AceConfig-3.0")
-- AceConfig:RegisterOptionsTable("RaidReminders", {}, {"/raidreminders", "/rr"})

function RaidReminders:OnInitialize()
  -- Code that's run when first loaded
  local isConfigOpen = false
  -- Registers slash command to open the Raid Reminders Window
  RaidReminders:RegisterChatCommand("raidreminders", "RaidRemindersToggleWindow")
end

function RaidReminders:OnEnable()
  -- Called when addon is enabled
end

function RaidReminders:OnDisable()
  -- When addon is disabled
end

local function showFrame()
  if isConfigOpen then 
    return
  else
    isConfigOpen = true
  end

  RaidReminders:Print("Yup, the addon is working")
  local OptionsContainer = AceGUI:Create("Frame")
  OptionsContainer:SetTitle("Raid Reminders")
  OptionsContainer:SetCallback("OnClose", 
    function(widget)
      AceGUI:Release(widget)
      isConfigOpen = false
    end
  )
  OptionsContainer:SetLayout("Flow")

  local editbox = AceGUI:Create("EditBox")
  editbox:SetLabel("Testing the test:")
  editbox:SetWidth(200)
  editbox:SetCallback("OnEnterPressed",
    function(widget, event, text)
      textstore = text
    end
  )
  OptionsContainer:AddChild(editbox)

  local button = AceGUI:Create("Button")
  button:SetText("Push me!")
  button:SetWidth(100)
  button:SetCallback("OnClick", function() print(textstore) end)
  OptionsContainer:AddChild(button)
end

function RaidReminders:RaidRemindersToggleWindow(input)
  -- If the config window is open, typing the command will not cause it to open multiple instances of it.
  showFrame()
end

--
-- UI --
--
local textstore