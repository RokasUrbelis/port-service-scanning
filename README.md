# port-service-scan
>写这个脚本的目的完全是为了检测网站安全性，主要用于批量扫描目标端口开放情况与探测服务版本等，速度上也做了很大程度的优化，靠后台进程来实现多线程扫描。

>缺点：当目标大于300个的时候，会出现后台进程一直处于等待状态，扫描结果也会漏掉30-60个左右。所以你可以分批扫描，使用crontab定时批量切换文件扫描，如果你觉得有更好的方式去实现与改进可以随时与我联系。

***Usage:***
```shell
bash test.sh -f file  执行脚本
bash scan.sh -h       显示帮助
```
#### 注意file(文件可以任意指定)的格式必须是ipaddress:port形式，请务必保持一行一条，比如:
```bash
127.0.0.1:80
192.168.1.1:23
45.32.117.7:443
```
#### 运行截图:

* 运行过程输出

![](https://www.linux-code.com/wp-content/uploads/2018/05/96d99760986f95a7037f64f54b13e152.png)

* result文件结果

![](https://www.linux-code.com/wp-content/uploads/2018/05/a9eed714deba71bc9a82804a2f8616be.png)
