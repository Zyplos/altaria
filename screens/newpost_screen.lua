local utils = require("/altaria/utils")
local auth = require("/altaria/auth")
local basalt = require("/altaria/basalt")
local bluesky = require("/altaria/bluesky")
local ccstrings = require "cc.strings"

local NewPostScreen = {} -- This table will serve as our "class"
local leftPadding = utils.leftPadding

local function count(base, pattern)
  return select(2, string.gsub(base, pattern, ""))
end

function NewPostScreen:new(mainFrame)
  local instance = {
    mainFrame = mainFrame,
    timelineData = nil
  }
  setmetatable(instance, self)
  self.__index = self

  instance:createFrame()

  return instance
end

function NewPostScreen:createFrame()
  local thisFrame = self.mainFrame:addScrollableFrame():setPosition(1, 2):setSize(
        "{parent.w}", "{parent.h -1}")
      :hide()

  local titleLabel = thisFrame:addLabel():setPosition(leftPadding, 2):setText("New Post"):setForeground(colors.blue)


  self.frame = thisFrame
end

function NewPostScreen:show()
  self.frame:show()
end

function NewPostScreen:hide()
  self.frame:hide()
end

return NewPostScreen
