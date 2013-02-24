Products = new Meteor.Collection 'products'

Meteor.methods
	addProduct: (product) ->
		Products.insert product