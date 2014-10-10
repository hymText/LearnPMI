#include <iostream>
#include <string>
#include <cmath>
#include <fstream>
#include <mecab.h>
#include <vector>
#include <map>
#include <algorithm>
#include "CppLib/vital.h"
#include "CppLib/pmi.h"

using namespace std;

int main(int argc, char const* argv[])
{
    // パラメータ設定
    int size = 20;              // フレームサイズ
    int shift = 10;             // フレームシフト
    double threshold = 1.65;    // t検定閾値(有意水準5%)
    const char* char_pos_arr[] = {"名詞", "形容詞"};

    //char_pos_arrをvector<string>に変換
    vector<string> content_poslist;
    int pos_count = (int)sizeof(char_pos_arr) / (int)sizeof(char_pos_arr[0]);
    for (int i = 0; i < pos_count; i++) {
        content_poslist.push_back(char_pos_arr[i]);
    }

    // PMIの結果を格納する二重ハッシュ
    map<pair<string, string>, double> pmi_hash;

    // ファイルリストを生成する
    if (argc != 2) {
        cerr << "引数の数が間違っています．" << endl;
        return 0;
    }
    const char* src_directory_char = argv[1];
    string src_directory= src_directory_char;
    vector<string> file_list = vital::GetFileList(src_directory);

    int frame_count = 0;
    map<string, int> word_count;
    map<pair<string,string>, int>conbination_count;

    // 各ファイルに対して操作
    int file_count = 0;
    for(vector<string>::iterator it = file_list.begin(); it != file_list.end(); it++){

        // ファイルを一括で読み込む
        string file_path = src_directory + (string)(*it);
        file_count++;
        cerr << "Reading... " << file_count << " : " << file_path << endl;
        string contents = vital::fileRead(file_path);

        // 読み込んだ内容をDocumentクラスに格納
        pmi::Document document(&contents);

        // Documentからフレーム化して，SegmentedDocumentクラスの配列に
        vector<pmi::SegmentedDocument> seg_doc_arr = document.Segment(size,shift, content_poslist);

        // フレーム数をカウント
        frame_count += seg_doc_arr.size();
        
        // 単語の生起回数と共起回数をカウント
        for(vector<pmi::SegmentedDocument>::iterator it = seg_doc_arr.begin(); it != seg_doc_arr.end(); it++){
            pmi::SegmentedDocument seg_doc = (pmi::SegmentedDocument)*it;
            // seg_doc.Print();
            seg_doc.AddCount(&word_count, &conbination_count, content_poslist);
        }
    }

    // 単語ペアとその出現回数を出力する(デバッグ用)
    // for(map<string, int>::iterator it = word_count.begin(); it != word_count.end(); it++){
    //     string word = (*it).first;
    //
    //     cout << word << "\t" << word_count[word] << endl;
    // }

    // 共起数0のペアと共起数1のペアをカウントし，チューリング推定量を計算
    int no_occur = ((word_count.size() * (word_count.size()-1) ) / 2) - conbination_count.size();  
    int occur_once = 0;
    for(map<pair<string,string>, int>::iterator it = conbination_count.begin(); it != conbination_count.end(); it++){
        if ((*it).second == 1) {
            occur_once += 1;
        }
    }
    double turing_value = (double)occur_once / (double)no_occur;

    // 実際にPMIを計算する
    for(map<pair<string,string>, int>::iterator it = conbination_count.begin(); it != conbination_count.end(); it++){
        string word_x = (*it).first.first;
        string word_y = (*it).first.second;

        int freq_x = word_count[word_x];
        int freq_y = word_count[word_y];
        double freq_xy = (double)conbination_count[make_pair(word_x, word_y)];

        if (freq_xy <= 0) {
            freq_xy = turing_value;
        }
        double t_value = pmi::CalcTValue(freq_x, freq_y, freq_xy, frame_count);

        if (t_value > threshold) {
            // 桁溢れに注意し，double型キャストする．
            pmi_hash[make_pair(word_x,word_y)] = (log( (double)(freq_xy * frame_count) / (double)((double)freq_x * (double)freq_y)) / (-1 * log( ( (double) freq_xy / (double) frame_count))));
        }
    }

    // // PMIの出力
    for(map<pair<string,string>, double>::iterator it = pmi_hash.begin(); it != pmi_hash.end(); it++){
        cout << (*it).first.first << "\t" << (*it).first.second << "\t" << (*it).second << endl;
    }

    return 0;
}
