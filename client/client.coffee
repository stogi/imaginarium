Meteor.Router.add
	'/': 'products'
	'/products': 'products'
	'/orders': 'orders'
	'/users': ->
		if Meteor.user()?.profile?.isAdmin is true
			'users'
		else
			'notFound'
	'/*': 'notFound' 

Accounts.config
	forbidClientAccountCreation: true

isAdmin = ->
	Meteor.user()?.profile?.isAdmin is true

clearMessage = (template) ->
	alertEl = $(template.find '.alert')
	alertEl.removeClass 'alert-error'
	alertEl.removeClass 'alert-success'
	alertEl.hide()

showMessage = (type, message, template) ->
	alertEl = $(template.find '.alert')
	alertEl.removeClass 'alert-error'
	alertEl.removeClass 'alert-success'
	alertEl.addClass "alert-#{type}"
	alertEl.find('.reason').html message
	alertEl.show()

Template.navbar.isAdmin = isAdmin

Template.products.isAdmin = isAdmin

Template.registerUser.events
	'click button': (event, template) ->
		email = template.find('#email').value.trim() 
		name = template.find('#name').value.trim()

		clearMessage template

		emailEl = $(template.find '.email')
		emailEl.removeClass 'error'
		nameEl = $(template.find '.name')
		nameEl.removeClass 'error'

		if email is ''
			emailEl.addClass 'error'
			showMessage 'error', 'Adres email jest obowiazkowy.', template
			return

		if name is ''
			nameEl.addClass 'error'
			showMessage 'error', 'Imię i nazwisko są obowiazkowe.', template
			return 

		data = 
			email: email
			profile:
				name: name
			
		Meteor.call 'registerUser', data, (error, userId) ->
			clearMessage template

			if error
				showMessage 'error', error.reason, template

			else
				showMessage 'success', 'Użytkownik został zarejestrowany. Informacja o rejestracji została przesłana na podany email.', template

				template.find('#email').value = ''
				template.find('#name').value = ''