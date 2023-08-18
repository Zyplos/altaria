local utils = require("/altaria/utils")
local auth = require("/altaria/auth")

local SignInFrame = {} -- This table will serve as our "class"
local leftPadding = utils.leftPadding

function SignInFrame:new(mainFrame)
  print("INIT SIGNINFRAME")
  print(mainFrame)
  local instance = {
    mainFrame = mainFrame,
    frame = nil,
    labelFeedback = nil
  }
  setmetatable(instance, self)
  self.__index = self

  print("mainframedev", instance.mainFrame)
  print("mainframesm", instance.mainFrame.screenManager)

  print("--POSTSINGIN")

  instance:createFrame()

  return instance
end

function SignInFrame:createFrame()
  local thisFrame = self.mainFrame:addFrame():setPosition(1, 1):setSize("{parent.w}", "{parent.h}"):hide()

  local labelTitle = thisFrame:addLabel()
  labelTitle:setPosition(leftPadding, 2)
  labelTitle:setFontSize(2)
  labelTitle:setBackground(colors.lightBlue)
  labelTitle:setForeground(colors.blue)
  labelTitle:setText("Altaria")

  local labelHandle = thisFrame:addLabel()
  labelHandle:setPosition(leftPadding, 6)
  labelHandle:setText("Handle")

  local inputHandle = thisFrame:addInput()
  inputHandle:setPosition(leftPadding, 7)
  inputHandle:setInputType("text")
  inputHandle:setSize(20, 1)
  inputHandle:setInputLimit(100)

  local labelPassword = thisFrame:addLabel()
  labelPassword:setPosition(leftPadding, 9)
  labelPassword:setText("Password")

  local inputPassword = thisFrame:addInput()
  inputPassword:setPosition(leftPadding, 10)
  inputPassword:setInputType("password")
  inputPassword:setSize(20, 1)
  inputPassword:setInputLimit(100)

  self.labelFeedback = thisFrame:addLabel()
  self.labelFeedback:setPosition(leftPadding, 12)
  self.labelFeedback:setForeground(colors.red)
  self.labelFeedback:setText("")

  local buttonSignIn = thisFrame:addButton()
  buttonSignIn:setPosition(leftPadding, 15)
  buttonSignIn:setBackground(colors.blue)
  buttonSignIn:setForeground(colors.white)
  buttonSignIn:setText("Sign In")

  local function buttonClick()
    -- self.mainFrame.screenManager:hideAllFrames()
    self:setFeedbackText("")

    local handleString = inputHandle:getValue()
    local passwordString = inputPassword:getValue()

    if handleString == nil or handleString == "" then
      self:setFeedbackText("Please enter a handle.")
      return
    end

    -- if handleString starts with a @ remove it
    if string.sub(handleString, 1, 1) == "@" then
      handleString = string.sub(handleString, 2)
    end

    if passwordString == nil or passwordString == "" then
      self:setFeedbackText("Please enter a password.")
      return
    end

    -- self:setFeedbackText("[DEBUG] " .. handleString .. " | " .. passwordString)

    local loginSuccess, loginFeedbackMessage = auth.login(handleString, passwordString)

    if not loginSuccess then
      self:setFeedbackText(loginFeedbackMessage)
      return
    end

    self.mainFrame.screenManager:show("timeline")
    print("SINGINmainframesmdev", self.mainFrame.screenManager)
  end

  -- Now we just need to register the function to the button's onClick event handlers, this is how we can achieve that:
  buttonSignIn:onClick(buttonClick)

  self.frame = thisFrame
end

function SignInFrame:setFeedbackText(text)
  self.labelFeedback:setText(text)
end

function SignInFrame:show()
  self.frame:show()
end

function SignInFrame:hide()
  self.frame:hide()
end

return SignInFrame
