local utils = require("/altaria/utils")
local auth = require("/altaria/auth")
local basalt = require("/altaria/basalt")
local query = require("/altaria/query")

local DevspaceFrame = {} -- This table will serve as our "class"
local leftPadding = utils.leftPadding

function DevspaceFrame:new(mainFrame)
  local instance = {
    mainFrame = mainFrame,
    timelineData = nil
  }
  setmetatable(instance, self)
  self.__index = self

  instance:createFrame()

  return instance
end

function DevspaceFrame:createFrame()
  local menuBarFrame = self.mainFrame:addFrame():setSize("{parent.w}", 1):setPosition(1, 1)
  local aMenubar = menuBarFrame:addMenubar()
      :addItem("TESTSPACE")
      :addItem("New Post", colors.blue, colors.white)
      :addItem("About", colors.blue, colors.white)
      :addItem("Exit", colors.red, colors.white)
      :setSpace(2)
      :setSize("{parent.w}", 1)
      :setBackground(colors.blue)

  local thisFrame = self.mainFrame:addFlexbox():setWrap("wrap"):setPosition(1, 2):setSize("{parent.w}", "{parent.h -1}")
      :hide()

  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)
  thisFrame:addButton():setFlexBasis(1):setFlexGrow(1)

  self.frame = thisFrame
end

function DevspaceFrame:show()
  self.frame:show()
end

function DevspaceFrame:hide()
  self.frame:hide()
end

return DevspaceFrame
