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
		data = 
			email: template.find('#email').value
			profile:
				name: template.find('#name').value
			
		Meteor.call 'registerUser', data, (error, userId) ->
			alert = $(template.find '.alert')
			alert.removeClass 'alert-error'
			alert.removeClass 'alert-success'

			if error
				alert.addClass 'alert-error'
				alert.find('.reason').html error.reason
				alert.show()

			else
				alert.addClass 'alert-success'
				alert.find('.reason').html 'Użytkownik został zarejestrowany. Informacja o rejestracji została przesłana na podany email.'
				alert.show()