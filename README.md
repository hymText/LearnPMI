LearnPMI
========
正規化された，平滑化PMIを計算する．

Settings
========
MeCabを独自にコンパイルした場合，Makefile中のMECAB_INCLUDEに，
MeCabインストールディレクトリ中のmecab.hがあるディレクトリへのパスを記載して下さい．
apt-get等で入れた場合，特に指定はいりません．

Notice
======
読み込むファイルの文字エンコードと，MeCabの辞書のエンコードは同じにしてください．  
(ファイルがutf-8なら，MeCabはutf-8を解析できるようにする)

How to use
==========
### コンパイル
$ make  
(Ubuntuの場合，libmecab-devをapt-getでインストールする必要がある．)

### /path/to/corpus/ディレクトリにあるテキストファイル群を使ってPMIを学習
$ ./learnPMI /path/to/corpus/ > output.txt

Output
======
<単語１>    <単語２>    <PMI値>のように出力されます.  
(NOTE:PMIは [-1,1] の値を取るように正規化(joint normalization)されます)  
アウトプットのサンプルは以下の様になります．  
  
アクシデント	ラッキー	0.535912  
アクシデント	事実	0.332352  
アクシデント	危険	0.374877  
アクシデント	否定	0.347459  
アクシデント	員	0.368306  

