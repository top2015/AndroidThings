#判断上一次命令是否执行成功
function isSuc(){
  if [ $? -ne 0 ];then
    echo $1
    exit 1
  fi 
}
#安装app
function installApp(){
  echo "-------即将安装app---------"
  if [ ! -f "./clipper.apk" ];then
    echo "clipper.apk 不存在 请先检查统计目录是否存在clipper.apk"
    exit 1
  fi
  adb  install -r "./clipper.apk"
  isSuc "安装apk失败"
  echo "-------安装完成---------"
}
#查看app是否在运行
function isAppRunning(){
  echo "-------检测app是否在运行---------"
  CML_RUNNING=`adb shell ps | grep ca.zgrs.clipper`
  if [ ! -n "$CML_RUNNING" ];then
    adb shell am start ca.zgrs.clipper/.Main
    isSuc "启动clipper失败"
    echo "-------检测完成---------"
  fi
  }
  #从收到的字符串提取字符
  function extraString(){
    tem=${$1#*\"}
    tem=${$tem%\"*}
    return $tem
  }
  #main入口
  echo "##########################################################"
  echo "## 1. 脚本执行时传入参数为pc--->>>android传输数据       ##"
  echo "## 2. 脚本执行时不传参数为android--->>>pc传输数据       ##"
  echo "## 3. 当android-->>>pc传输数据时，将内容复制好，        ##"
  echo "##    并将Clipper.apk打开置于前台 ##"
  echo "## 4. 第一次调用脚本时，call 任意数据，则会自动安装apk  ##"
  echo "##########################################################"
  CML_INSTALLED=`adb shell pm list packages | grep ca.zgrs.clipper`
  if [ -n "$CML_INSTALLED" ];then
    echo "已安装app"
  else
    installApp
  fi
  isAppRunning

  if [ ! -n "$1" ];then
    DATA=`adb shell am broadcast -a clipper.get`
    echo $DATA
    isSuc "获取失败"
  else
    adb shell am broadcast -a clipper.set -e text $1
    isSuc "发送失败"
  fi
  echo "执行成功"



