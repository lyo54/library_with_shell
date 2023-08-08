#!/bin/sh
#author:罗智超
#projiect:简易图书管理系统
#version:1.0
#date:2022/6/22
#email:1303694715@qq.com
##############
#两个判断常量 #
##############

yes='y'
no='n'

	#################################################
	#		 Function： menu                 #
	#	         打印菜单                        #
	#################################################
menu()
{
	echo "\t\t\t################################"
	echo "\t\t\t#                               #"
	echo "\t\t\t#       1. 添加图书信息         #"
	echo "\t\t\t#       2. 显示图书信息         #"
	echo "\t\t\t#       3. 查找图书信息         #"
	echo "\t\t\t#       4. 删除图书信息         #"
	echo "\t\t\t#       5. 退出管理系统         #"
	echo "\t\t\t################################"
}
	#################################################
	#		 Function： Addbook 		#
	#		    添加图书信息	  	#
	#################################################

addbook()
{
	echo "请编辑书籍信息！\n"
	echo "图书标题：\c"
	#################
	#读取图书相关信息#
	#               #
	#################	
	read title
	info=`grep -w $title library.db`
	###################
	#判断图书是否存在  #
	#                 #
	###################	
	if [ ! -z "$info" ];then
		clear
		echo "\n\n这本图书已经存在！\n\n"
	else
		echo "图书库存： \c"
		read author
		echo "图书价格: \c"
		read category
		echo "$title $author $category" >> library.db
		clear
		echo "\n\n图书信息添加成功!\n\n"
	fi
	echo "按回车退出！\n\n\n"
	echo "是否添加更多书籍（y/n)？\c"
	read yn
	################################
	#如果继续添加图书则继续调用函数#
	#                              #
	################################
	if [ "$yn" = "$yes" ];then
		clear
		echo "\n\n\n"
		addbook
	else
		clear
		return
	fi
}
	#################################################
	#						#
	#		 Function: showall		#
	#		 排序并显示图书信息	 	#
	#################################################
showall(){
	echo "请问您要按哪种类别排序！()"
	echo "\t\t\t#       1. 图书标题         #"
	echo "\t\t\t#       2. 图书库存         #"
	echo "\t\t\t#       3. 图书价格         #"
	read class
	max=3
	min=1 
	if [ $class -gt $max ] || [ $class -lt $min ]
	then
		wrong
		return
	fi
	echo "请问您要按哪种方式排序！()"
	echo "\t\t\t#       1. 正序         #"
	echo "\t\t\t#       2. 倒序         #"
	read list
	stdsort=1
	rsort=2
	if [ $list =  $stdsort ]
	then	
		sort -k $class -r -n library.db -o library.db
	elif [ $list = $rsort ]
	then
		sort -k $class -n library.db -o library.db
	else
		wrong
		return
	fi
	clear
	awk  '{ printf "%-10s %-8s % -8s\n" ,$1,$2,$3}' library.db
	echo "\n按回车退出\c"
	read tmp
	clear
}
	#################################################
	#		function：Searchbook		#
	#		   查找书籍信息	                #
	#################################################
searchbook(){
	echo "请问您要按哪种类别查找！"
	echo "\t\t\t#       1. 图书标题         #"
	echo "\t\t\t#       2. 图书库存         #"
	echo "\t\t\t#       3. 图书价格         #"
	read search
	echo "请输入您要查找的内容！"
	read content
	result="`awk '$'$search'=="'$content'" {print $1,$2,$3}' library.db`"
	if [ -z "$result" ]
	then
		echo "参数错误，或未找到相关书籍信息"
	else
		echo "\n\n已经为您找到以下书籍"		
		awk '$'$search'=="'$content'" {print $1,$2,$3}' library.db
	
	fi	
	#################################
	#如果继续查找图书则继续调用函数 #
	#			        #	
	#################################
	echo  "是否查找其他书籍（y/n)?"	
	read ser
	if [ "$ser" = "$yes" ];then
		clear
		echo "\n\n\n"
		searchbook
	else
		clear
		return
	fi
	
	
}
	#################################################
	#						#
	#		 Function: deletebook		#
	#		 对图书信息进行删除	 	#
	#################################################
deletebook(){
	###################################################
	#                                                 #
	#通过指定图书书名来删除图书			  #
	#                                                 #
	###################################################
	echo "请输入您要删除的图书名"
	read title
	result="`awk '$1=="'$title'" {print $1,$2,$3}' library.db`"
	if [ -z "$result" ]
	then
		echo "未找到该书籍"
		echo "是否继续删除图书?(y/n)"
		#################################
		#如果继续删除图书则继续调用函数 #
		#			        #	
		#################################
		read del
		if [ "$del" = "$yes" ];then
			clear
			echo "\n\n\n"
			deletebook
		else
			clear
			return
		fi
	fi
	echo "已为您找到该书籍相关信息，是否删除?（y/n）"
	awk '$1=="'$title'" {print $1,$2,$3}' library.db
	read sure
	if [ "$sure" = "$yes" ]
	then
		sed -i -e '/'$title'/d' library.db >>  library.db
		echo "已经为您成功删除书籍"		
	fi
	
	echo "是否继续删除图书?(y/n)"
	#################################
	#如果继续删除图书则继续调用函数 #
	#			        #	
	#################################
	read del
	if [ "$del" = "$yes" ];then
		clear
		echo "\n\n\n"
		deletebook
	else
		clear
		return
	fi
}

	#################################################
	#						#
	#		 Function: wrong		#
	#		 错误参数时显示信息	 	#
	#################################################
wrong(){
	echo "错误参数，请重试！！！！！"
}
###############################################################
#		         主程序部分                           #
#							      #
#							      #
###############################################################
########################################################
#判断是否存在数据库文件，若不存在则创建                #
########################################################
if [ ! -r library ]
then
	touch library.db
fi
#####################
#                   #
#程序主体部分       #
#####################
while (true)
do
	clear
	menu
	read choice
	case $choice in
		1)addbook;;
		2)showall;;
		3)searchbook;;
		4)deletebook;;
		5)exit;;
		*) clear;wrong
		esac
done


