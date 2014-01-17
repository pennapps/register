root = exports ? this

# http://stackoverflow.com/questions/1184624/convert-form-data-to-js-object-with-jquery/8407771#8407771
jQuery.fn.serializeObject = ->
  arrayData = @serializeArray()
  objectData = {}

  $.each arrayData, ->
    if @value?
      value = @value
    else
      value = ''

    if objectData[@name]?
      unless objectData[@name].push
        objectData[@name] = [objectData[@name]]

      objectData[@name].push value
    else
      objectData[@name] = value
  return objectData

root.pickFile = (on_success) ->
  on_error = (err) -> console.log err
  services = ["COMPUTER", "DROPBOX", "GOOGLE_DRIVE", "SKYDRIVE", "URL"]
  filepicker.setKey("AA_3IkmAOQX2Drld5QS9qz")
  filepicker.pickAndStore {services: services, extensions: [".pdf", ".doc", ".docx"]},
    {location: 'S3'}, on_success, on_error
