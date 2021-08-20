
  // connect to websocket server
  var ws = new WebSocket('ws://localhost:8080/');
  ws.onopen = function() {
    console.log('connected');
  }
  ws.onclose = function() {
    console.log('disconnected');
  }
  ws.onmessage = function(event) {
    //received STDOUT
    console.log(event.data);
  }

  //send commands to bash
    ws.send("/path/to/EtCa.sh --wallet 01123456789 --auth");
