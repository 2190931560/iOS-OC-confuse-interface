#!/usr/bin/env bash
#搜索到的要替换的方法名
STRING_SYMBOL_FILE="$PROJECT_DIR/confuse/func.list"
#不被替换的方法名 系统方法 继承的方法 等
IGNORE_SYMBOL_FILE="$PROJECT_DIR/confuse/ignore.list"
#要替换的文件搜索目录
CONFUSE_FILE="$PROJECT_DIR/"
#替换的头文件名 加入pch文件
HEAD_FILE="$PROJECT_DIR/confuse/confuseHeader.h"

#用于字符分类和字符串处理，控制所有字符的处理方式，包括字符编码，字符是单字节还是多字节，如何打印等。是最重要的一个环境变量。
export LC_CTYPE=C

#过滤方法名
grep -h -r -I  "^ *[-+]" $CONFUSE_FILE  --include '*.m'  --include '*.mm'|grep -v 'IBAction'|sed 's/ //g'|sed 's/[+-]//g'|sed "s/[();,: *\^\/\{]/ /g"|awk '{split($0,b," "); print b[2]; }'| sort|uniq |sed "/^$/d"|grep -Fvf $IGNORE_SYMBOL_FILE >$STRING_SYMBOL_FILE
#过滤class名
grep -h -r -I  "^ *@implementation" $CONFUSE_FILE  --include '*.m'  --include '*.mm'|sed 's/^[ ]*//g'|sed 's/@implementation//'|sed 's/ //g'| sort|uniq |grep -Fvf $IGNORE_SYMBOL_FILE >>$STRING_SYMBOL_FILE

#生成随机方法名 用于替换
ramdomString()
{
openssl rand -base64 64 | tr -cd 'a-zA-Z' |head -c 16

}

rm -f $HEAD_FILE

touch $HEAD_FILE
echo '#ifndef confuse_header_h
#define confuse_header_h' >> $HEAD_FILE
echo "//confuse string at `date`" >> $HEAD_FILE
cat "$STRING_SYMBOL_FILE" | while read -ra line; do
if [[ ! -z "$line" ]]; then
ramdom=`ramdomString`
echo $line $ramdom
echo "#define $line $ramdom" >> $HEAD_FILE
fi
done
echo "#endif" >> $HEAD_FILE


