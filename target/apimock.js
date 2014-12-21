(function() {
  var app, express;

  express = require('express');

  app = express();

  app.use(express["static"](process.env.webapp));

  app.get('/api/v1/hoge', function(req, res) {
    res.set('Content-Type', 'application/json');
    return res.send(JSON.stringify({
      price: 100
    }));
  });

  app.post('/api/v1/hoge', function(req, res) {
    res.set('Content-Type', 'application/json');
    return res.send(JSON.stringify({
      price: 200
    }));
  });

  app.listen(process.env.port);

}).call(this);
