
CC:=gcc
CFLAGS:=-Wall -g
LDFLAGS:=-lm

all: stamp

.PHONY: all clean check

ifeq ($(OS),Windows_NT)
BMPSUITE:=bmpsuite.exe
bmpsuite: $(BMPSUITE)
.PHONY: bmpsuite
else
BMPSUITE:=bmpsuite
endif

bmpsuite.o: bmpsuite.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(BMPSUITE): bmpsuite.o
	$(CC) $(LDFLAGS) -o $@ $^

stamp: $(BMPSUITE)
	./$(BMPSUITE)
	touch stamp

check: stamp
	md5sum g/* q/* b/* > checksums.tmp
	diff checksums checksums.tmp
	@echo OK
	@rm -f checksums.tmp

clean:
	rm -f $(BMPSUITE) *.o
	rm -f stamp g/*.bmp q/*.bmp b/*.bmp

