
CC:=gcc
CFLAGS:=-g -Wall -Wextra -Wmissing-prototypes -Wformat-security -Wno-unused-parameter
LDFLAGS:=
LDLIBS:=-lm

all: stamp

.PHONY: all clean check check2

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
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

stamp: $(BMPSUITE)
	./$(BMPSUITE)
	touch stamp

checksums checksums.tmp: stamp
	md5sum -b g/* q/* b/* x/* | LC_ALL=C sort -k2 > $@

# check2 is not portable, due to differences in sort order, and in md5sum's
# output. But it's useful for development, because it can find unlisted files.
check2: checksums.tmp
	diff checksums checksums.tmp
	@echo OK
	@rm -f checksums.tmp

check: stamp
	md5sum --check --warn checksums

clean:
	rm -f $(BMPSUITE) *.o
	rm -f stamp g/*.bmp q/*.bmp b/*.bmp x/*.bmp

