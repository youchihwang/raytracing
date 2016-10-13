EXEC = raytracing
.PHONY: all
all: $(EXEC)

CC ?= gcc

# <<< 2016/10/31-youchihwang, add define NDEBUG for better performance
#CFLAGS += -DNDEBUG
# >>> 2016/10/31-youchihwang, add define NDEBUG for better performance
# <<< 2016/10/31-youchihwang, add define dot_product_loop_unrolling_optimization for better performance
#CFLAGS += -DDOT_PRODUCT_LOOP_UNROLLING_OPTIMIZATION
# >>> 2016/10/31-youchihwang, add define dot_product_loop_unrolling_optimization for better performance

CFLAGS = \
	-std=gnu99 -Wall -O0 -g -DDOT_PRODUCT_LOOP_UNROLLING_OPTIMIZATION -DNDEBUG

LDFLAGS = \
	-lm
GPROF2DOT = \
        /usr/local/lib/python2.7/dist-packages/gprof2dot.py

ifeq ($(strip $(PROFILE)),1)
PROF_FLAGS = -pg
CFLAGS += $(PROF_FLAGS)
LDFLAGS += $(PROF_FLAGS) 
endif

OBJS := \
	objects.o \
	raytracing.o \
	main.o \
        computeci.o

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<


$(EXEC): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

main.o: use-models.h
use-models.h: models.inc Makefile
	@echo '#include "models.inc"' > use-models.h
	@egrep "^(light|sphere|rectangular) " models.inc | \
	    sed -e 's/^light /append_light/g' \
	        -e 's/light[0-9]/(\&&, \&lights);/g' \
	        -e 's/^sphere /append_sphere/g' \
	        -e 's/sphere[0-9]/(\&&, \&spheres);/g' \
	        -e 's/^rectangular /append_rectangular/g' \
	        -e 's/rectangular[0-9]/(\&&, \&rectangulars);/g' \
	        -e 's/ = {//g' >> use-models.h

check: $(EXEC)
	@./$(EXEC) && diff -u baseline.ppm out.ppm || (echo Fail; exit)
	@echo "Verified OK"

plot:
	make clean;
	make PROFILE=1;
	./raytracing;
	gprof ./$(EXEC) | $(GPROF2DOT) | dot -Tpng -o $@.png;

no_plot:
	make clean;
	make;
	./raytracing;

clean:
	$(RM) $(EXEC) $(OBJS) use-models.h \
		out.ppm gmon.out
