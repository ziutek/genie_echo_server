def log_errno(prio: int, msg: string)
	if errno != 0
		Daemon.log(prio, "%s: %s", msg, strerror(errno))
		errno = 0
	else
		Daemon.log(prio, msg)

def log_err(msg: string)
	log_errno(Posix.LOG_ERR, msg)

def log_die(msg: string)
	log_err(msg)
	Process.exit(1)

def log_wrn(msg: string)
	log_errno(Posix.LOG_WARNING, msg)

def log_inf(msg: string)
	Daemon.log(Posix.LOG_INFO, msg)
