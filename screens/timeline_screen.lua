local utils = require("/altaria/utils")
local auth = require("/altaria/auth")
local basalt = require("/altaria/basalt")
local bluesky = require("/altaria/bluesky")
local ccstrings = require "cc.strings"

local TimelineFrame = {} -- This table will serve as our "class"
local leftPadding = utils.leftPadding

local function count(base, pattern)
  return select(2, string.gsub(base, pattern, ""))
end

local screenManager = nil

function TimelineFrame:new(mainFrame)
  local instance = {
    mainFrame = mainFrame,
    timelineData = nil
  }
  setmetatable(instance, self)
  self.__index = self

  instance:createFrame()

  screenManager = instance.mainFrame.screenManager

  print("mainframedev", instance.mainFrame)
  print("mainframesm", instance.mainFrame.screenManager)
  print("screenmanvar", screenManager)

  return instance
end

function TimelineFrame:switchTo(framename)
  self.mainFrame.screenManager:show(framename)
end

function TimelineFrame:createFrame()
  local thisFrame = self.mainFrame:addScrollableFrame():setPosition(1, 2):setSize(
        "{parent.w}", "{parent.h-1}")
      :hide()

  self.frame = thisFrame
end

function TimelineFrame:show()
  self.frame:show()

  local timelineRequestWorked, timelineFeedback = bluesky.getTimeline()

  if not timelineRequestWorked then
    self.mainFrame.screenManager.subFrames["signin"]:setFeedbackText(timelineFeedback)
    self.mainFrame.screenManager:show("signin")
    return
  end

  print("WORKING")

  local currentY = 2

  for key, value in pairs(timelineFeedback.feed) do
    -- DEBUGSTART
    -- self.frame:addLabel():setPosition(leftPadding, currentY):setText("[STARTPOST]"):setForeground(colors
    --   .gray)
    -- currentY = currentY + 1

    -- display name and handle
    local handleString = value.post.author.handle
    local displayNameString = value.post.author.displayName

    if displayNameString == nil then
      displayNameString = ""
    end

    if handleString == nil then
      handleString = ""
    end

    self.frame:addLabel():setPosition(leftPadding, currentY):setText(displayNameString ..
      " @" .. handleString):setForeground(colors.blue)

    currentY = currentY + 1

    local termw, termh = term.getSize()

    -- post text
    if value.post.record.text ~= "" then
      local postTextString = value.post.record.text
      local wrappedString = ccstrings.wrap(postTextString, termw - leftPadding * 2)

      for i = 1, #wrappedString do
        self.frame:addLabel():setPosition(leftPadding, currentY):setText(wrappedString[i])
        currentY = currentY + 1
      end
    end


    -- check if post has images
    if value.post.record.embed ~= nil then
      if next(value.post.record.embed.images) ~= nil then
        for key, value in pairs(value.post.record.embed.images) do
          local imageAltString = value.alt

          if imageAltString == nil then
            local genericImageLabel = self.frame:addLabel():setPosition(leftPadding, currentY):setText("[Image]")
                :setForeground(colors.gray)
            currentY = currentY + 1
          else
            local wrappedAltString = ccstrings.wrap(imageAltString, termw - leftPadding * 2)

            for i = 1, #wrappedAltString do
              if i == 1 then
                self.frame:addLabel():setPosition(leftPadding, currentY):setText("[Image] " .. wrappedAltString[i])
                    :setForeground(colors
                      .gray)
              else
                self.frame:addLabel():setPosition(leftPadding, currentY):setText(wrappedAltString[i]):setForeground(
                  colors.gray)
              end

              currentY = currentY + 1
            end
          end
        end
      end
    end

    local statsLabel = self.frame:addLabel():setPosition(leftPadding, currentY):setText("\26 " ..
      value.post.replyCount .. " \167 " ..
      value.post.repostCount .. " \3 " ..
      value.post.likeCount):setForeground(colors.gray)

    --DEBUGLABEL
    -- currentY = currentY + 1
    -- self.frame:addLabel():setPosition(leftPadding, currentY):setText("[ENDPOST]"):setForeground(colors
    --   .gray)

    currentY = currentY + 2
  end
end

function TimelineFrame:hide()
  self.frame:hide()
end

return TimelineFrame
