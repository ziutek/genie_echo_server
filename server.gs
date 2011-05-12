class Server : Object
	_srv: ThreadedSocketService	

	init
		_srv = new ThreadedSocketService(2)
		_srv.run.connect(_conn_handler)

	construct (addr: string, port: uint16) raises Error
		// Ustawienie adresu na ktorym nasluchuje serwer
		var listen_on = new InetSocketAddress(
			new InetAddress.from_string(addr),
			port
		)
		effect_addr: SocketAddress 
		_srv.add_address(listen_on, SocketType.STREAM,
			SocketProtocol.DEFAULT, null, out effect_addr)

	def start()
		_srv.start()

	def _conn_handler(conn: SocketConnection, src_obj: Object?): bool
		var rd = new DataInputStream(conn.input_stream)
		var wr = new DataOutputStream(conn.output_stream)
		msg: string
		try
			while (msg = rd.read_line(null)) != null
				msg = msg.strip()
				if msg == ""
					wr.put_string("Bye!\n")
					break
				else
					wr.put_string("-> %s\n".printf(msg))
		except err: Error
			log_err(err.message)
		return true
