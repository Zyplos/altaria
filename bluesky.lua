os.loadAPI("jsonapi.lua")
local auth = require("auth")

function GetTimeline(handle, password)
  -- get session data from file
  local sessionFileReadWorked, sessionFileReadFeedback = auth.getSessionJSON()

  if not sessionFileReadWorked then
    -- session file either doesn't exist or is formatted wrong
    return false, sessionFileReadFeedback
  end

  local request = http.get("https://bsky.social/xrpc/app.bsky.feed.getTimeline?algorithm=reverse-chronological&limit=10",
    {
      ["Content-Type"] = "application/json",
      ["Authorization"] = "Bearer " .. sessionFileReadFeedback["accessJwt"],
      ["User-Agent"] = "Altaria/0.1 (ComputerCraft)",
      ["Accept"] = "application/json"
    }
  )

  -- http.post returns "nil" if the request fails
  if request == nil then
    return false, "Couldn't get timeline\n(session outdated? sign in again)"
  end

  -- request might be a valid object, but the response code might not be OK
  local httpCode, httpMessage = request.getResponseCode()
  if httpCode ~= 200 then
    return false, "Unable to get timeline\n(session outdated?) [" .. httpCode .. "]"
  end

  -- everything works, save to file
  local timelineData = jsonapi.decode(request.readAll())

  if timelineData == nil then
    return false, "Couldn't decode timeline data"
  end

  return true, timelineData
  -- https://bsky.app/profile/nanoraptor.danamania.com/post/3k4yc54bog32p
  -- author data
  -- feed[0].post.author.handle
  -- feed[0].post.author.displayName
  -- feed[0].post.author.viewer.muted
  -- feed[0].post.author.viewer.blockedBy

  -- feed[0].post.record.text
  -- feed[0].post.record.embed.images[0].alt
  -- feed[0].post.replyCount
  -- feed[0].post.repostCount
  -- feed[0].post.likeCount

  -- post data for the post this is a reply to
  -- feed[0].reply.parent

  -- root post
  -- feed[0].reply.root
end

function CreateRecord(handle, password)

end

return {
  getTimeline = GetTimeline,
  createRecord = CreateRecord
}
