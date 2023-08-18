local utils = require("/altaria/utils")
local auth = require("/altaria/auth")
local basalt = require("/altaria/basalt")
local bluesky = require("/altaria/bluesky")
local ccstrings = require "cc.strings"

local AboutFrame = {} -- This table will serve as our "class"
local leftPadding = utils.leftPadding

local function count(base, pattern)
  return select(2, string.gsub(base, pattern, ""))
end

function AboutFrame:new(mainFrame)
  local instance = {
    mainFrame = mainFrame,
    timelineData = nil
  }
  setmetatable(instance, self)
  self.__index = self

  instance:createFrame()

  return instance
end

function AboutFrame:createFrame()
  local thisFrame = self.mainFrame:addScrollableFrame():setPosition(1, 2):setSize(
        "{parent.w}", "{parent.h -1}")
      :hide()

  local titleLabel = thisFrame:addLabel():setPosition(leftPadding, 2):setText("About Altaria " ..
    utils.version):setForeground(colors.blue)

  local byLabel = thisFrame:addLabel():setPosition(leftPadding, 3):setText("by")
  local zyplosLabel = thisFrame:addLabel():setPosition(5, 3):setText("@zyplos.dev"):setForeground(colors.red)

  local aboutText = [[
Altaria is a Bluesky client for ComputerCraft.

Uses Pyroxenium's Basalt library for the UI
and ElvishJerricco's JSON API for data parsing.

Altaria's source code can be found here:
https://github.com/Zyplos/altaria
]]

  local aboutLabel = thisFrame:addLabel():setPosition(leftPadding, 5):setText(aboutText)

  self.frame = thisFrame
end

function AboutFrame:show()
  self.frame:show()
end

function AboutFrame:hide()
  self.frame:hide()
end

return AboutFrame
