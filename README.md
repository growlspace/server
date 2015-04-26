# server
back-end server code

nick's required APIs:
- api.growl.space/1.0/login (POST)
- api.growl.space/1.0/feed (GET)
- api.growl.space/1.0/item/{id} (GET, POST)
- api.growl.space/1.0/user/{username} (GET, POST)

POST login with username with credentials (in body), receive auth token
GET feed, receive list of item ids
GET item with id, receive content
POST item without id, create content
GET user with username, receive user profile content
POST user, create user