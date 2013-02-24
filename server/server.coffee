Meteor.publish 'products', ->
	Parties.find
		amount: $gt: 0

Meteor.methods
	registerUser: (options) ->
		userId = Accounts.createUser options

		if userId
			Accounts.sendEnrollmentEmail userId