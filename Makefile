
CC:=gcc
CFLAGS:=-Wall -g
LDFLAGS:=-lm

all: stamp

.PHONY: all clean

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

clean:
	rm -f $(BMPSUITE) *.o
	rm -f stamp g/*.bmp q/*.bmp b/*.bmp

