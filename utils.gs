def log_err(msg: string)
	if errno != 0
		Daemon.log(Posix.LOG_ERR, "%s: %s", msg, strerror(errno))
		errno = 0
	else
		Daemon.log(Posix.LOG_ERR, msg)


def log_die(msg: string)
	log_err(msg)
	Process.exit(1)


def log_inf(msg: string)
	Daemon.log(Posix.LOG_INFO, msg)

