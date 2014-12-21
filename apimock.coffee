express = require 'express'
app = express()

app.use express.static process.env.webapp

app.get '/api/v1/hoge', (req, res) ->
  res.set 'Content-Type', 'application/json'
  res.send JSON.stringify
    price: 100

app.post '/api/v1/hoge', (req, res) ->
  res.set 'Content-Type', 'application/json'
  res.send JSON.stringify
    price: 200

app.listen process.env.port
