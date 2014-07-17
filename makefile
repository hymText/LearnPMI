TARGET		=	learnPMI

INCLUDES	=	./CppLib/
# MeCabを独自にコンパイルした場合，MeCabインストールディレクトリ中の，
# mecab.hがあるディレクトリへのパスをMECAB_INCLUDEに記載すること．
MECAB_INCLUDE	=	

HEADERS		=	$(INCLUDES)vital.h\
				$(INCLUDES)pmi.h

SOURCES		=	main.cpp\
				$(INCLUDES)vital.cpp\
				$(INCLUDES)pmi.cpp

CXX			=	g++
# MECAB_INCLUDEが変数として設定されているか否かでインクルードパス設定変更
ifeq ($(MECAB_INCLUDE),)
	CXXFLAGS	=	-c -O3 -Wall -I$(INCLUDES)
else
	CXXFLAGS	=	-c -O3 -Wall -I$(INCLUDES) -I$(MECAB_INCLUDE)
endif

LINKER		=	g++ 
LFLAGS		=	-O3 -Wall `mecab-config --cflags` `mecab-config --libs`

# SOURCES中の.cppを.oに置換したものをOBJECTSとする．
# 指定がない(単にmakeコマンドを実行した)とき，一番最初の生成ルールを実行する．
OBJECTS		=	$(SOURCES:.cpp=.o)

### 以下，ファイル生成ルール
$(TARGET):	$(OBJECTS)
	@echo Linking...
	$(LINKER) -o $(TARGET) $(OBJECTS) $(LFLAGS)

# .o は .cpp から作ります．
# $< : 最初に依存するファイル名，すなわち$(SOURCES)
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
