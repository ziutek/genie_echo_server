class Server : Object
	_srv: ThreadedSocketService	

	init
		_srv = new ThreadedSocketService(2)
		_srv.run.connect(_conn_handler)

	construct (addr: string, port: uint16) raises Error
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
		try
			var rem_addr = "unknown"
			var so_addr = conn.get_remote_address()
			case so_addr.get_family()
				when SocketFamily.IPV4
				when SocketFamily.IPV6
					rem_addr = ((InetSocketAddress) so_addr).address.to_string()

			log_inf("Connection from " + rem_addr)
			var rd = new DataInputStream(conn.input_stream)
			var wr = new DataOutputStream(conn.output_stream)
			msg: string
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
