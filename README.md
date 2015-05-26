# nativescript-vm
##NativeScript Virtual Machine  

The initialize.sh Script can be ran on a fresh Ubuntu 64bit 14.04 Installation.  (I've tested it in both VMWare and VirtualBox)   

This sets up a fully function VM with all the NativeScript components; including a clone of all 4 major NativeScript repo's so that you can hack on any part of the NativeScript system.

If you use Vagrant and VirtualBox or just plain VirtualBox and also use a Android VM that runs on VirtualBox (Like Geny or Andy); then this VM can EASILY connect to the Android VM. 

To Connect; you need the ip address of the Android VM. (Geny typically defaults to 192.168.56.100 if it is the first VM running on VirtualBox) So then you would type:
```adb connect 192.168.56.100``` 

Please note if you are using Geny you can type:
```genyshell -c "devices list"``` 
to get a list of devices and their status and ip address

Then when you want to compile, deploy & test to your Android vm you would type:
```tns run android --device 1```

  
Nathanael Anderson
[http://Master-Technology.com](http://master-technology.com)