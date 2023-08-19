os.loadAPI("/altaria/jsonapi.lua")

function Login(handle, password)
  local request = http.post("https://bsky.social/xrpc/com.atproto.server.createSession",
    '{"identifier":"' .. handle .. '","password":"' .. password .. '"}', {
      ["Content-Type"] = "application/json"
    }
  )

  -- http.post returns "nil" if the request fails
  if request == nil then
    return false, "Login request failed\n(double check your username and password)"
  end

  -- request might be a valid object, but the response code might not be OK
  local httpCode, httpMessage = request.getResponseCode()
  if httpCode ~= 200 then
    return false, "Unable to login\n(double check your username and password) [" .. httpCode .. "]"
  end

  -- everything works, save to file
  local requestText = request.readAll()
  local fileHandle = fs.open("/altaria/bluesky_session.json", "w")
  local didFileSave, fileSaveErrorMsg = pcall(function()
    fileHandle.write(requestText)
    fileHandle.close()
  end)

  if not didFileSave then
    return false, "Login successful, but\nunable to save session to file"
  end

  return true, "Login successful"
end

function GetSessionJSON()
  if not fs.exists("/altaria/bluesky_session.json") then
    return false, "Please login first."
  end

  local fileHandle, fileHandleError = fs.open("/altaria/bluesky_session.json", "r")

  if fileHandle == nil then
    return false, "Couldn't read session file"
  end

  local fileSessionReadWorked, fileSessionFeedback = pcall(function()
    local sessionData = jsonapi.decode(fileHandle.readAll())

    if sessionData == nil then
      error("could not decode JSON")
    end

    return sessionData
  end)

  if not fileSessionReadWorked then
    return false, "Session file read failed: " .. fileSessionFeedback
  end

  if fileSessionFeedback["accessJwt"] == nil or
      fileSessionFeedback["refreshJwt"] == nil or
      fileSessionFeedback["email"] == nil or
      fileSessionFeedback["handle"] == nil or
      fileSessionFeedback["did"] == nil then
    return false, "Session file is missing data"
  end

  return true, fileSessionFeedback
end

return {
  login = Login,
  getSessionJSON = GetSessionJSON
}
