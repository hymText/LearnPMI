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

# subst(a,b,$(x)) Xの中のaをbに置換
# filter(pattern,text) : textのpatternに一致するものを抽出
#OBJECTS		=	$(subst .cpp,.o,$(filter %.cpp,$(SOURCES)))
OBJECTS		=	$(SOURCES:.cpp=.o)

# .o は .cpp から作ります．
# $< : 最初に依存するファイル名，すなわち$(HEADERS)
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
