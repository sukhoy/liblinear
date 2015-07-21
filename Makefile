CXX ?= g++
CC ?= gcc
CFLAGS = -Wall -Wconversion -O3 -fPIC -fopenmp
LIBS = blas/blas.a
SHVER = 3
OS = $(shell uname)
#LIBS = -lblas

# case 1098: use SFMT instead of the standard rand()
override CFLAGS += -msse2 -DHAVE_SSE2 -DSFMT_MEXP=19937
override LIBS += SFMT/SFMT.a

all: train predict

lib: linear.o tron.o blas/blas.a SFMT/SFMT.a
	if [ "$(OS)" = "Darwin" ]; then \
		SHARED_LIB_FLAG="-dynamiclib -Wl,-install_name,liblinear.so.$(SHVER)"; \
	else \
		SHARED_LIB_FLAG="-shared -Wl,-soname,liblinear.so.$(SHVER)"; \
	fi; \
	$(CXX) $${SHARED_LIB_FLAG} linear.o tron.o blas/blas.a SFMT/SFMT.a -lgomp -o liblinear.so.$(SHVER)

train: tron.o linear.o train.c blas/blas.a SFMT/SFMT.a
	$(CXX) $(CFLAGS) -o train train.c tron.o linear.o $(LIBS)

predict: tron.o linear.o predict.c blas/blas.a SFMT/SFMT.a
	$(CXX) $(CFLAGS) -o predict predict.c tron.o linear.o $(LIBS)

tron.o: tron.cpp tron.h
	$(CXX) $(CFLAGS) -c -o tron.o tron.cpp

linear.o: linear.cpp linear.h
	$(CXX) $(CFLAGS) -c -o linear.o linear.cpp

blas/blas.a: blas/*.c blas/*.h
	make -C blas OPTFLAGS='$(CFLAGS)' CC='$(CC)';

clean:
	make -C blas clean
	make -C matlab clean
	rm -f *~ tron.o linear.o train predict liblinear.so.$(SHVER)
	rm -f SFMT/SFMT.o SFMT/SFMT.a

SFMT/SFMT.a: SFMT/SFMT.c
	$(CC) $(CFLAGS) -c -o SFMT/SFMT.o SFMT/SFMT.c
	ar -rsc SFMT/SFMT.a SFMT/SFMT.o
