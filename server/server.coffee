Meteor.methods
	registerUser: (options) ->
		userId = Accounts.createUser options

		if userId
			Accounts.sendEnrollmentEmail userId