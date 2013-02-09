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

Template.navbar.isAdmin = ->
	Meteor.user()?.profile?.isAdmin is true

Template.registerUser.events
	'click button': (event, template) ->
		email = template.find('#email').value.trim() 
		name = template.find('#name').value.trim()

		alertEl = $(template.find '.alert')
		alertEl.removeClass 'alert-error'
		alertEl.removeClass 'alert-success'
		alertEl.hide()

		emailEl = $(template.find '.email')
		emailEl.removeClass 'error'
		nameEl = $(template.find '.name')
		nameEl.removeClass 'error'

		if email is ''
			emailEl.addClass 'error'
			alertEl.addClass 'alert-error'
			alertEl.find('.reason').html 'Adres email jest obowiazkowy.'
			alertEl.show()
			return

		if name is ''
			nameEl.addClass 'error'
			alertEl.addClass 'alert-error'
			alertEl.find('.reason').html 'Imię i nazwizko są obowiazkowe.'
			alertEl.show()
			return 

		data = 
			email: email
			profile:
				name: name
			
		Meteor.call 'registerUser', data, (error, userId) ->
			alertEl.removeClass 'alert-error'
			alertEl.removeClass 'alert-success'

			if error
				alertEl.addClass 'alert-error'
				alertEl.find('.reason').html error.reason
				alertEl.show()

			else
				alertEl.addClass 'alert-success'
				alertEl.find('.reason').html 'Użytkownik został zarejestrowany. Informacja o rejestracji została przesłana na podany email.'
				alertEl.show()

				template.find('#email').value = ''
				template.find('#name').value = ''