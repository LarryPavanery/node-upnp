dgram = require 'dgram'
uuid = require 'uuid'

SSDPPort = 1900
SSDPAddress = '239.255.255.250'
UUID = uuid.generate()

client = dgram.createSocket 'udp4', (msg, rinfo) -> 
	console.log msg.toString()
	console.log rinfo


txt = "M-SEARCH * HTTP/1.1\r\nHost:#{ SSDPAddress }:#{ SSDPPort }\r\nMan:\"ssdp:discover\"\r\nST:upnp:rootdevice\r\nMX:3\r\n\r\n"

message = new Buffer txt, 'utf8'

console.log message.toString()

client.setMulticastLoopback dgram.IP_MULTICAST_LOOP
client.addMembership SSDPAddress

client.on "listening", () ->
	address = client.address()
	console.log "client listening #{ address.address }:#{ address.port }"
	client.send message, 0, message.length, SSDPPort, SSDPAddress, (err, bytes) ->
		if (err)
			throw err
		console.log "Wrote " + bytes + " bytes to socket."

client.bind SSDPPort
