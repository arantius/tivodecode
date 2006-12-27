# Makefile for tivodecode, (c) 2006, Jeremy Drake
# See COPYING file for license terms
CC=gcc
CFLAGS=-Wall -O3
DEFINES=-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
override CFLAGS+=$(DEFINES)
LDFLAGS=
CTAGS=ctags
CTFLAGS=--c-types=+dfmstuv

OBJDIR=objects.dir
LIBOBJS=hexlib.o TuringFast.o sha1.o tivo-parse.o turing_stream.o tivodecoder.o
PROGOBJS=happyfile.o getopt.o getopt_long.o
TDOBJS=tivodecode.o

OBJS=$(LIBOBJS) $(TDOBJS) $(PROGOBJS)

REALLIBOBJS=$(patsubst %.o,$(OBJDIR)/%.o,$(LIBOBJS))
REALTDOBJS=$(patsubst %.o,$(OBJDIR)/%.o,$(PROGOBJS) $(TDOBJS))

SRCS=$(patsubst %.o,%.c,$(OBJS))
HEADERS=QUTsbox.h Turing.h TuringMultab.h TuringSbox.h getopt_long.h happyfile.h hexlib.h sha1.h tivo-parse.h tivodecoder.h turing_stream.h

all: libtivodecode.a tivodecode

.PHONY: clean
clean:
	rm -rf $(OBJDIR)

.PHONY: prep
prep:
	mkdir -p $(OBJDIR)

.PHONY: tivodecode
tivodecode: prep $(OBJDIR)/tivodecode

.PHONY: libtivodecode.a
libtivodecode.a: prep $(OBJDIR)/libtivodecode.a

tags: $(SRCS) $(HEADERS)
	$(CTAGS) $(CTFLAGS) $^

$(OBJDIR)/tivodecode: $(OBJDIR)/libtivodecode.a $(REALTDOBJS)
	$(CC) $(LDFLAGS) -o $@ $(REALTDOBJS) -L$(OBJDIR) -ltivodecode

$(OBJDIR)/libtivodecode.a: $(REALLIBOBJS)
	$(AR) r $@ $^

$(OBJDIR)/%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJDIR):
	mkdir $(OBJDIR)


#############################################################################
# Do not use targets below here.  They are for releasing new versions.
# Users should not use these.  These are not the targets you are looking for...

CREL=$(if $(REL),$(strip $(subst .,_, $(REL))),YOU_NEED_A_RELEASE)
CVSROOT=:ext:jeremyd2019@tivodecode.cvs.sourceforge.net:/cvsroot/tivodecode
RELDIR=tivodecode-$(strip $(REL))

.PHONY: tag
tag:
	@echo TAG = REL_$(CREL)
	$(if $(filter YOU_NEED_A_RELEASE, $(CREL)), false SET A RELEASE, )
	sed -i -e 's/^\(Version \)\([0-9.]\+\)$$/\1$(strip $(REL))/' README
	sed -i -e 's/^\(static const char \* VERSION_STR = "\)\([0-9.]\+\)\(";\)$$/\1$(strip $(REL))\3/' tivodecode.c
	cvs commit -m"Flag release $(strip $(REL))" README tivodecode.c
	cvs tag REL_$(CREL)

.PHONY: release
release:
	@echo TAG = REL_$(CREL)
	@echo VER = $(strip $(REL))
	$(if $(filter YOU_NEED_A_RELEASE, $(CREL)), false SET A RELEASE, )
	cvs -d$(CVSROOT) export -rREL_$(CREL) -d$(RELDIR) tivodecode
	tar -zcvf $(RELDIR).tar.gz $(RELDIR)/
	rm -rf $(RELDIR)/
