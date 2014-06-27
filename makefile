TARGET		=	learnPMI

CXX			=	g++
CXXFLAGS	=	-c -O3 -Wall

LINKER		=	g++ 
LFLAGS		=	-O3 -Wall `mecab-config --cflags` `mecab-config --libs`

INCLUDES	=	./CppLib/
HEADERS		=	$(INCLUDES)vital.h\
				$(INCLUDES)pmi.h

SOURCES		=	main.cpp\
				$(INCLUDES)vital.cpp\
				$(INCLUDES)pmi.cpp

# subst(a,b,$(x)) X$B$NCf$N(Ba$B$r(Bb$B$KCV49(B
# filter(pattern,text) : text$B$N(Bpattern$B$K0lCW$9$k$b$N$rCj=P(B
#OBJECTS		=	$(subst .cpp,.o,$(filter %.cpp,$(SOURCES)))
OBJECTS		=	$(SOURCES:.cpp=.o)

# .o $B$O(B .cpp $B$+$i:n$j$^$9!%(B
# $< : $B:G=i$K0MB8$9$k%U%!%$%kL>!$$9$J$o$A(B$(HEADERS)
$(TARGET):	$(OBJECTS)
	@echo Linking...
	$(LINKER) -o $(TARGET) $(OBJECTS) $(LFLAGS)

.cpp.o:	$(SOURCES) $(HEADERS)
	$(CXX) $(CXXFLAGS) $<
	@mv $(@F) $(@D)

main.o:	main.cpp CppLib/vital.h
	$(CXX) $(CXXFLAGS) $<

run:	$(TARGET)
	./$(TARGET)

tags:
	ctags $(SOURCES) $(HEADERS)

clean:	
	@echo Clean All Object
	@rm -f $(TARGET) $(OBJECTS)
