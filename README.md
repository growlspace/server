# Back-end API

back-end api endpoints

accessible at something like `https://api.growl.space/v1`

Coming soon: [growl.space](http://growl.space)

* todo
    - investigate oauth2/openid for identity/account management
    - api requests extra info -- security concerns
        * info in some JSON body or as query parameters?

# Login

note: we absolutely must use https to not send pw plaintext. credentials are
provided via JSON in request body. may have some extra headers too

## Request

````
POST /login
````

## Response

200: Ok
500: other errors

# Get Feed
### Login Required

Fetch list of X most recent item ids.
Session token is required, obtained through
a successful /login.

## Request

````
GET /feed
    ?token={}
````

## Response

200: List of item ids as JSON.
401: not logged in
500: other error

# Get Item
### Login Required

Fetch item content

## Request

````
GET /item/{id}
    ?token={}
````

## Response

200: Item content as JSON
401: not logged in
404: item doesn't exist
500: internal error

# Create Item
### Login Required

Creates a new item with the content provided within body.

## Request

````
POST /item
     ?token={}
````

## Response

200: Id of created item
401: not logged in
500: other errors

# Get User
### Login Required

Fetch user profile content

## Request

````
GET /user/{username}
    ?token={}
````

## Response

200: User profile information as JSON
401: unauthorized
404: user does not exist
500: other errors

# Create User

Create user with information provided in request body as JSON.

## Request

````
POST /user
```

## Response

200: Returns username of created user
500: user already exists, other error, etc.