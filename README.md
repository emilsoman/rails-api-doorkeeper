Rails-API + Doorkeeper
======================

This is a sample app with some specs explaining how to authenticate users of
a Rails API by implementing an OAuth2 provider using Doorkeeper gem. This app
does not use devise, instead rolls its own authentication using bcrypt and
`has_secure_password`. This makes it easy to not use sessions or cookies and thus
it makes no assumptions about what type of client the API will talk to.
The idea is to allow native apps or separate static sites to be able to consume
and authenticate using the same APIs.
