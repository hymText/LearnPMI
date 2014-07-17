TARGET		=	learnPMI

INCLUDES	=	./CppLib/
# MeCab$B$rFH<+$K%3%s%Q%$%k$7$?>l9g!$(BMeCab$B%$%s%9%H!<%k%G%#%l%/%H%jCf$N!$(B
# mecab.h$B$,$"$k%G%#%l%/%H%j$X$N%Q%9$r(BMECAB_INCLUDE$B$K5-:\$9$k$3$H!%(B
MECAB_INCLUDE	=	

HEADERS		=	$(INCLUDES)vital.h\
				$(INCLUDES)pmi.h

SOURCES		=	main.cpp\
				$(INCLUDES)vital.cpp\
				$(INCLUDES)pmi.cpp

CXX			=	g++
# MECAB_INCLUDE$B$,JQ?t$H$7$F@_Dj$5$l$F$$$k$+H]$+$G%$%s%/%k!<%I%Q%9@_DjJQ99(B
ifeq ($(MECAB_INCLUDE),)
	CXXFLAGS	=	-c -O3 -Wall -I$(INCLUDES)
else
	CXXFLAGS	=	-c -O3 -Wall -I$(INCLUDES) -I$(MECAB_INCLUDE)
endif

LINKER		=	g++ 
LFLAGS		=	-O3 -Wall `mecab-config --cflags` `mecab-config --libs`

# SOURCES$BCf$N(B.cpp$B$r(B.o$B$KCV49$7$?$b$N$r(BOBJECTS$B$H$9$k!%(B
# $B;XDj$,$J$$(B($BC1$K(Bmake$B%3%^%s%I$r<B9T$7$?(B)$B$H$-!$0lHV:G=i$N@8@.%k!<%k$r<B9T$9$k!%(B
OBJECTS		=	$(SOURCES:.cpp=.o)

### $B0J2<!$%U%!%$%k@8@.%k!<%k(B
$(TARGET):	$(OBJECTS)
	@echo Linking...
	$(LINKER) -o $(TARGET) $(OBJECTS) $(LFLAGS)

# .o $B$O(B .cpp $B$+$i:n$j$^$9!%(B
# $< : $B:G=i$K0MB8$9$k%U%!%$%kL>!$$9$J$o$A(B$(SOURCES)
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
