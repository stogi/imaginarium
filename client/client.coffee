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

Meteor.subscribe 'products'

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

Template.products.products = ->
	Products.find {}

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
			
		Meteor.call 'registerUser', data, (error) ->
			clearMessage template

			if error
				showMessage 'error', error.reason, template

			else
				showMessage 'success', 'Użytkownik został zarejestrowany. Informacja o rejestracji została przesłana na podany email.', template

				template.find('#email').value = ''
				template.find('#name').value = ''

Template.addProduct.events
	'click button': (event, template) ->
		product =
			name: template.find('#name').value.trim()
			url: template.find('#url').value.trim()
			description: template.find('#description').value.trim()
			type: template.find('#type').value.trim()
			occasion: template.find('#occasion').value.trim()
			amount: parseInt template.find('#amount').value.trim()
			price: parseInt template.find('#price').value.trim()

		console.log product

		Meteor.call 'addProduct', product, (error) ->
			if error
				console.log error

			else
				showMessage 'success', 'Artykuł został pomyślnie dodany.', template




