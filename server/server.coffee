Meteor.publish "app", ->
  return Apps.find(user_id: @userId)

Apps.allow
  insert: -> (userId, doc) ->
    # check if user has been accepted?
    return doc.user_id?  # make sure there is a user_id lol
  update: (userId, doc) ->
    return userId == doc.user_id
  remove: (userId, doc) ->
    return userId == doc.user_id
