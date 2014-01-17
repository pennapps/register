Meteor.subscribe "app"

Template.main.helpers
  login: -> Session.get("login")
  forgot: -> Session.get('forgot')
  email: -> Meteor.user()?.emails?[0]?.address

Template.main.events
  'click .logout': (e) -> Meteor.logout()
  'click .forgot': (e) ->
    e.preventDefault()
    Session.set "forgot", !Session.get("forgot")
  'click .switch': (e) ->
    e.preventDefault()
    Session.set "login", !Session.get("login")

Template.register.events
  'submit #register': (e) ->
    e.preventDefault()
    form = $('#register').serializeObject()
    if form.password == form.confirm
      Accounts.createUser {email: form.email, password: form.password}, (err) ->
        if err
          alert err
    else
      alert "Your passwords don't match. What's up with that?"

Template.login.events
  'submit #login': (e) ->
    e.preventDefault()
    form = $('#login').serializeObject()
    Meteor.loginWithPassword form.email, form.password, (err) ->
      if err
        alert err

Template.forgot.events
  'submit #forgot': (e) ->
    e.preventDefault()
    email = $('#forgot').serializeObject().email
    if email
      Accounts.forgotPassword {email}, (err) ->
        alert(err or "Email sent.")

CUSTOM_FORMS = [
  {name: "liability"}
  {name: "resume"}
]

FORMS = [
  {name: "c1", display_name: "C1 Form", description: "Upload your signed C1 form", url: "/c1.pdf", default: "Everyone"}
  {name: "w9", display_name: "W9 Form", description: "Upload your signed W9 form", url: "/w9.pdf", default: "US Citizens Only"}
  {name: "fnif", display_name: "FNIF Form", description: "Upload your signed FNIF form", url: "/fnif.pdf", default: "non-US Citizens Only"}
  {name: "visa", display_name: "Visa Scan", description: "Upload a scanned copy of your visa", default: "non-US Citizens Only"}
  {name: "passport", display_name: "Passport Scan", description: "Upload a scanned copy of your passport", default: "non-US Citizens Only"}

  {name: "receipt1", display_name: "Receipt 1", description: "Upload your first receipt", default: "If applicable"}
  {name: "receipt2", display_name: "Receipt 2", description: "Upload your second receipt", default: "If applicable"}
  {name: "receipt3", display_name: "Receipt 3", description: "Upload your third receipt", default: "If applicable"}
  {name: "receipt4", display_name: "Receipt 4", description: "Upload your fourth receipt", default: "If applicable"}
]

Template.application.helpers
  application: -> Apps.findOne(user_id: Meteor.userId()) or {}
  checked: (a, b) -> if a == b then "checked" else ""
  checkedArray: (a, b) -> if _.contains(a, b) then "checked" else ""
  submitted: -> Session.get("submitted")
  forms: FORMS
  # (field, suffix, object, default)
  get: (f, s, o, d) -> o[f + s] or d

# dynamically create the events map
events = {
  'submit #application': (e) ->
    e.preventDefault()
    app = $('#application').serializeObject()
    app.user_id = Meteor.userId()
    app.developer = [app.developer] if not _.isArray(app.developer)

    old_app = Apps.findOne(user_id: Meteor.userId())
    if old_app
      Apps.update old_app._id, {$set: app}
    else
      Apps.insert app

    Session.set "submitted", true
    setTimeout (-> Session.set "submitted"), 2000
}

for form in FORMS.concat(CUSTOM_FORMS)
  do (name = form.name) ->
    events["click .#{name}picker"] = (e) ->
      e.preventDefault()
      pickFile (files) ->
        file = if files.length then files[0] else {}
        $("##{name}_name").text file.filename
        $("input[name=#{name}_name]").val file.filename
        $("input[name=#{name}_url]").val file.url

Template.application.events(events)
