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
		log_die("Can't daemonize")
	else if pid != 0
		Process.exit(0)

	if Daemon.close_all(-1) == -1
		log_die("Failed to close all filedescriptors")
	
	s: Server
	try
		s = new Server("0.0.0.0", 1234)
		s.start()
	except err: Error
		log_die("Can't create server: " + err.message)

	log_inf("Started successfully")

	new MainLoop().run()
