init
	Daemon.pid_file_ident = Daemon.log_ident = Daemon.ident_from_argv0(args[0])

	if Daemon.reset_sigs(-1) == -1
		log_die("Failed to reset all signal handlers")
	if Daemon.unblock_sigs(-1) == -1
		log_die("Failed to unblock all signals")
	pid: int
	if (pid = Daemon.pid_file_is_running()) != -1
		log_die("Already running on PID file %u".printf(pid))
	if (pid = Daemon.fork()) == -1
		log_die("Couldn't daemonize")
	else if pid != 0
		Process.exit(0)

	if Daemon.close_all(-1) == -1
		log_die("Failed to close all filedescriptors")
	if Daemon.pid_file_create() == -1
		log_wrn("Can't create PID file")
	
	s: Server
	try
		s = new Server("0.0.0.0", 1234)
		s.start()
	except err: Error
		log_die("Can't create server: " + err.message)

	log_inf("Server started")

	new MainLoop().run()
