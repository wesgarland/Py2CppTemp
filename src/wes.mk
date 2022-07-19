# @file		wes.mk
# 		Temporary Makefile to build hello.so until cmake can be fixed
# @author	Wes Garland
# @date		July 2022
#
# Usage example: make -f wes.mk clean all
#

TARGETS   = hello.$(SOLIB_EXT)
BUILD     = debug

CXX       = g++
CPPFLAGS  = $(shell python3-config --includes)
CXXFLAGS  = -fpic -Werror -Wall
LDFLAGS   = --shared
OS        = $(shell uname -s)
SOLIB_EXT = so

# Mac-specific overrides to defaults
ifeq ($(OS),Darwin)
LDFLAGS   += -undefined dynamic_lookup
LINKER    ?= $(CXX) -dynamiclib -undefined dynamic_lookup
SOLIB_EXT  = dylib
endif

# Build-specific changes - only release builds do not get debug symbols
ifneq ($(BUILD),release)
CXXFLAGS += -g
endif

# Implicit rule for building solibs
%.$(SOLIB_EXT):
	$(CXX) $(LDFLAGS) $(filter %.o,$^) $(LOADLIBES) $(LDLIBS) -o $@

all:	$(TARGETS)
clean:
	rm -f $(wildcard *.o)
	rm -f $(TARGETS)

hello.$(SOLIB_EXT): hello.o
