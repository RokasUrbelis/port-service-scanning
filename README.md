# port-service-scan
- The purpose of writing this script is to detect the security of the website, mainly used for batch scanning the target port open situation and detection service version, speed has also done a great degree of optimization, rely on the background process to achieve multi-threaded scanning

- Disadvantages: when the number of targets is greater than 300, the background process will always be in a waiting state, and the scanning results will miss about 30-60. So you can batch scan, using crontab timing batch switching file scan, if you think there is a better way to achieve and improve can contact me at any time

***Usage:***
```shell
bash test.sh -f file  #exec script
bash scan.sh -h       #print help
```
#### Note that the format of the file(which can be arbitrarily specified) must be in the form ipaddress:port, so be sure to keep a single line, like this:
```shell
127.0.0.1:80
192.168.1.1:23
45.32.117.7:443
```
#### Screen:

* STDOUT

![](https://www.linux-code.com/wp-content/uploads/2018/05/96d99760986f95a7037f64f54b13e152.png)

* result file text

![](https://www.linux-code.com/wp-content/uploads/2018/05/a9eed714deba71bc9a82804a2f8616be.png)
