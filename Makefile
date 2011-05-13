OPTS = -X -O2 --thread --pkg gio-2.0 --pkg gio-unix-2.0 --pkg posix --pkg libdaemon
OUT = echo_server

$OUT : *.gs
	valac $(OPTS) -o $(OUT) *.gs

c : *.gs
	valac -C $(OPTS) *.gs

clean :
	rm -f $(OUT) *.c
