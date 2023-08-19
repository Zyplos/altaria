local basalt = require("basalt")

-- import sub screens
local SignInScreen = require("screens/signin_screen")
local TimelineScreen = require("screens/timeline_screen")
local AboutScreen = require("screens/about_screen")
local NewPostScreen = require("screens/newpost_screen")
-- local DevspaceScreen = require("screens/devspace_screen")
local utils = require("utils")
local auth = require("auth")

local ScreenManager = {}
function ScreenManager:new(mainFrameParam)
  print("INIT SCREENMANAGER")
  print("mainFrameParam: ", mainFrameParam)
  local instance = {
    mainFrame = mainFrameParam,
    subFrames = {},
    menuBar = nil
  }
  setmetatable(instance, self)
  self.__index = self

  local devmainframe = instance.mainFrame
  print("devmainframe: ", devmainframe)

  -- create subframes
  instance.subFrames["signin"] = SignInScreen:new(devmainframe)
  instance.subFrames["timeline"] = TimelineScreen:new(devmainframe)
  instance.subFrames["about"] = AboutScreen:new(devmainframe)
  instance.subFrames["newpost"] = NewPostScreen:new(devmainframe)
  -- instance.subFrames["devspace"] = DevspaceScreen:new(devmainframe)

  -- create menubar
  instance.menuBar = devmainframe:addMenubar()
      :addItem("Timeline", colors.blue, colors.white, "timeline")
      :addItem("New Post", colors.blue, colors.white, "newpost")
      :addItem("About", colors.blue, colors.white, "about")
      :addItem("Exit", colors.red, colors.white, "exit")
      :setSpace(2)
      :setPosition(1, 1)
      :setSize("{parent.w}", 1)
      :setBackground(colors.blue)
      :onChange(function(self, event, val)
        instance:show(val.args[1])
      end):hide()

  return instance
end

-- from https://basalt.madefor.cc/#/objects/Frame?id=menubar-for-switching-frames
function ScreenManager:show(id) -- we create a function which switches the frame for us
  -- print("SHOWING FRAME: ", id.args)
  if id == "exit" then
    basalt.stop()
  end

  if id == "signin" then
    -- print("HIDING MENUBAR")
    self.menuBar:hide()
  else
    -- print("SHOWING MENUBAR")
    self.menuBar:show()
  end

  if (self.subFrames[id] ~= nil) then
    for k, v in pairs(self.subFrames) do
      v:hide()
    end
    self.subFrames[id]:show()
  end
end

-- main frame
local mainFrame = basalt.createFrame():setTheme({ FrameBG = colors.lightBlue, FrameFG = colors.black })
print("mainFrame: ", mainFrame)
mainFrame.screenManager = ScreenManager:new(mainFrame)
mainFrame.sessionData = nil

-- NOTE checking auth stuff here
local sessionFileReadWorked, sessionFileReadFeedback = auth.getSessionJSON()

if not sessionFileReadWorked then
  -- session file either doesn't exist or is formatted wrong
  mainFrame.screenManager.subFrames["signin"]:setFeedbackText(sessionFileReadFeedback)
  mainFrame.screenManager:show("signin")
else
  -- everything seems fine for auth stuff, show main screen
  mainFrame.sessionData = sessionFileReadFeedback
  mainFrame.screenManager:show("timeline")
end


basalt.autoUpdate()
