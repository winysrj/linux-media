Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smeagol.cambrium.nl ([217.19.16.145] ident=qmailr)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1JV6Ci-0002c8-Ot
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 15:27:16 +0100
Message-ID: <47C8163E.5030009@powercraft.nl>
Date: Fri, 29 Feb 2008 15:27:10 +0100
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <47C7329F.7030705@powercraft.nl>
	<47C73457.1030901@powercraft.nl>	<d9def9db0802281425i5b487f43ub90b263a63e40a01@mail.gmail.com>	<47C7360E.9030908@powercraft.nl>	<d9def9db0802281440x2daa2f21n2169e76b53ccd664@mail.gmail.com>	<47C73A05.2050007@powercraft.nl>	<d9def9db0802281455hb962279g9f45a8e87cf16d28@mail.gmail.com>	<d9def9db0802281458g73939fefq8c5d7bc9aa49e1aa@mail.gmail.com>	<47C74DF4.6040608@powercraft.nl>
	<1204246336.22520.57.camel@youkaida>
	<d9def9db0802282327l1139e17ew8a571ac578e37df2@mail.gmail.com>
In-Reply-To: <d9def9db0802282327l1139e17ew8a571ac578e37df2@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------070208080806010406000402"
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Going though hell here,
 please provide how to for Pinnacle PCTV Hybrid Pro Stick 330e
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------070208080806010406000402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Markus Rechberger wrote:
> On 2/29/08, Nicolas Will <nico@youplala.net> wrote:
>> hmmm...
>>
>> guys.
>>
>> First thing: on a Debian or Ubuntu system, I never needed the full Linux
>> sources to compile a v4l-dvb tree. The headers were always enough.
>>
>> Second thing: when you compile a v4l-dvb tree on the side, I do not
>> think that it is adding anything in the headers.
>> So, if you subsequently need to compile a driver that needs stuff from a
>> recent v4l-dvb tree, it won't find it.
>>
>> Third thing: That weird driver of yours is probably looking for its
>> stuff either int the headers (were there will not be anything good to
>> find because of the point made above) or in an available kernel source
>> tree (where it will probably not find anything that will make it happy
>> because your recent v4l-dvb tree is elsewhere).
>>
>> May I suggest to get a kernel source tree (from the appropriate
>> package), incorporate the v4l-dvb tree in it, then try to compile your
>> weird driver against this.
>>
>> Getting rid of the headers may help.
>>
> 
> When you compile the v4l-dvb or v4l-dvb-experimental tree it will
> update your whole v4l and dvb subsystem.
> As soon as you do so it won't work to install any other external media
> drivers anymore, beside that v4l-dvb is much bigger than the snipped
> out em28xx driver.
> em28xx-userspace2 and userspace-drivers only contains the drivers for
> em28xx based devices and won't affect any other drivers on the system.
> Since the uvc driver is also out of tree it won't break
> compiling/using the uvc driver against the current running kernel.
> 
> The kernel sources are needed because some internal headers are needed
> for the em28xx to build an alternative tuning system for hybrid
> radio/analogue TV/DTV devices. It should work flawlessly with older
> kernel releases where v4l-dvb already fails to compile.
> 
> It's also easier to keep backward compatibility while not breaking any
> other drivers on the system that way (and this is seriously needed)
> 
> Beside all that:
> There's a .deb package available I posted the link very early already
> compiling from source can always introduce some mess so you better
> know what you do otherwise you have to learn how it works...
> The build scripts already do alot work there for several different distributions
> 
> Markus
> 

I spent several hours again to see if I could get it working on Debian 
sid. I got a little bit further bit still got compilation errors.

Can you please look at my attachments.

Kind regards,

Jelle







--------------070208080806010406000402
Content-Type: text/plain;
 name="error-log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="error-log.txt"

jelle@debian-eeepc:~$ ls -hal /usr/src/
total 44M
drwxrwsr-x  6 root src  4.0K Feb 29 15:16 .
drwxr-xr-x 11 root root 4.0K Feb 23 00:32 ..
lrwxrwxrwx  1 root src    28 Feb 29 15:16 linux -> /usr/src/linux-source-2.6.24
drwxr-xr-x  4 root root 4.0K Feb 29 15:10 linux-headers-2.6.24-1-686
drwxr-xr-x 18 root root 4.0K Feb 29 15:10 linux-headers-2.6.24-1-common
drwxr-xr-x  3 root root 4.0K Feb 29 15:10 linux-kbuild-2.6.24
drwxr-xr-x 20 root root 4.0K Feb 29 15:17 linux-source-2.6.24
-rw-r--r--  1 root root  44M Feb 11 12:42 linux-source-2.6.24.tar.bz2
jelle@debian-eeepc:~$ ls -hal /lib/modules/$(uname -r)/source
lrwxrwxrwx 1 root root 28 Feb 29 15:16 /lib/modules/2.6.24-1-686/source -> /usr/src/linux-source-2.6.24
jelle@debian-eeepc:~$ ls -hal /lib/modules/$(uname -r)/source/drivers/media/dvb/dvb-core/dmxdev.h
-rw-r--r-- 1 root root 2.4K Jan 24 22:58 /lib/modules/2.6.24-1-686/source/drivers/media/dvb/dvb-core/dmxdev.h
jelle@debian-eeepc:~$ ls -hal /lib/modules/$(uname -r)/source/drivers/media/dvb/dvb-core/dvb_frontend.h
-rw-r--r-- 1 root root 5.7K Jan 24 22:58 /lib/modules/2.6.24-1-686/source/drivers/media/dvb/dvb-core/dvb_frontend.h
jelle@debian-eeepc:~$ ls -hal /lib/modules/$(uname -r)/source/drivers/media/dvb/dvb-core/dvb_demux.h
-rw-r--r-- 1 root root 3.5K Jan 24 22:58 /lib/modules/2.6.24-1-686/source/drivers/media/dvb/dvb-core/dvb_demux.h
jelle@debian-eeepc:~$ ls -hal /lib/modules/$(uname -r)/source/drivers/media/dvb/dvb-core/dvb_net.h
-rw-r--r-- 1 root root 1.4K Jan 24 22:58 /lib/modules/2.6.24-1-686/source/drivers/media/dvb/dvb-core/dvb_net.h
jelle@debian-eeepc:~$ ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dmxdev.h
-rw-r--r-- 1 root root 2.4K Jan 24 22:58 /usr/src/linux/drivers/media/dvb/dvb-core/dmxdev.h
jelle@debian-eeepc:~$ ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dvb_frontend.h
-rw-r--r-- 1 root root 5.7K Jan 24 22:58 /usr/src/linux/drivers/media/dvb/dvb-core/dvb_frontend.h
jelle@debian-eeepc:~$ ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dvb_demux.h
-rw-r--r-- 1 root root 3.5K Jan 24 22:58 /usr/src/linux/drivers/media/dvb/dvb-core/dvb_demux.h
jelle@debian-eeepc:~$ ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dvb_net.h
-rw-r--r-- 1 root root 1.4K Jan 24 22:58 /usr/src/linux/drivers/media/dvb/dvb-core/dvb_net.h
jelle@debian-eeepc:~$
jelle@debian-eeepc:~$
jelle@debian-eeepc:~$ cd ~
jelle@debian-eeepc:~$ sudo rm -r userspace-drivers
rm: cannot remove `userspace-drivers': No such file or directory
jelle@debian-eeepc:~$ hg clone http://mcentral.de/hg/~mrec/userspace-drivers
destination directory: userspace-drivers
requesting all changes
adding changesets
adding manifests
adding file changes
added 85 changesets with 392 changes to 146 files
76 files updated, 0 files merged, 0 files removed, 0 files unresolved
jelle@debian-eeepc:~$ cd userspace-drivers
jelle@debian-eeepc:~/userspace-drivers$ sudo ./build.sh
found kernel version (2.6.24-1-686)
make -C /lib/modules/2.6.24-1-686/build M=/home/jelle/userspace-drivers/kernel modules -Wall
make[1]: Entering directory `/usr/src/linux-headers-2.6.24-1-686'
  CC [M]  /home/jelle/userspace-drivers/kernel/media-stub.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC      /home/jelle/userspace-drivers/kernel/media-stub.mod.o
  LD [M]  /home/jelle/userspace-drivers/kernel/media-stub.ko
make[1]: Leaving directory `/usr/src/linux-headers-2.6.24-1-686'
make INSTALL_MOD_PATH= INSTALL_MOD_DIR=kernel/drivers/media/userspace  \
        -C /lib/modules/2.6.24-1-686/build M=/home/jelle/userspace-drivers/kernel modules_install
make[1]: Entering directory `/usr/src/linux-headers-2.6.24-1-686'
  INSTALL /home/jelle/userspace-drivers/kernel/media-stub.ko
  DEPMOD  2.6.24-1-686
make[1]: Leaving directory `/usr/src/linux-headers-2.6.24-1-686'
depmod -a
gcc -c media-core.c "-I/lib/modules/`uname -r`/source/include"
gcc media-core.o tuner-qt1010.c -o tuner-qt1010 "-I/lib/modules/`uname -r`/source/include"  -g
gcc media-core.o tuner-mt2060.c -o tuner-mt2060 "-I/lib/modules/`uname -r`/source/include"  -g
gcc -shared media-core.c -o libmedia-core.so "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -shared -L. -lmedia-core tuner-xc3028.c -o libtuner-xc3028.so "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -shared -L. -lmedia-core demod-zl10353.c -o libdemod-zl10353.so "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -L. -lmedia-core demod-zl10353.c -o demod-zl10353 "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -L. -lmedia-core vdecoder-tvp5150.c -o vdecoder-tvp5150 "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -shared -L. -lmedia-core vdecoder-tvp5150.c -o libvdec-tvp5150.so "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -shared -L. -lmedia-core vdecoder-cx25840.c -o libvdec-cx25840.so "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
make[1]: Entering directory `/home/jelle/userspace-drivers/userspace/xc5000'
g++ XC5000_example_app.cpp i2c_driver.c xc5000_control.c -o test "-I/lib/modules/`uname -r`/source/include" -lmedia-core -L..
gcc -shared tuner-xc5000.c i2c_driver.c xc5000_control.c -o libtuner-xc5000.so -g -fPIC -lm "-I/lib/modules/`uname -r`/source/include"
gcc tuner-xc5000.c i2c_driver.c xc5000_control.c -o tuner-xc5000 -g -L.. -lmedia-core -lm "-I/lib/modules/`uname -r`/source/include"
make[1]: Leaving directory `/home/jelle/userspace-drivers/userspace/xc5000'
make[1]: Entering directory `/home/jelle/userspace-drivers/userspace/drx3975d'
gcc drx3973d.c drx_dap_wasi.c bsp_host.c bsp_i2c.c drx_driver.c main.c -lmedia-core -L.. -DDRXD_TYPE_B -o test -lm -g "-I/lib/modules/`uname -r`/source/include"
gcc drx3973d.c drx_dap_wasi.c bsp_host.c bsp_i2c.c drx_driver.c demod-drx3975d.c -shared -DDRXD_TYPE_B -DDRXD_TYPE_A -fPIC -o libdemod-drx3975d.so -lm -L.. -lmedia-core -g "-I/lib/modules/`uname -r`/source/include"
make[1]: Leaving directory `/home/jelle/userspace-drivers/userspace/drx3975d'
make[1]: Entering directory `/home/jelle/userspace-drivers/userspace/xc3028'
gcc xc3028_example_app.c -lm -o test
gcc tuner-xc3028.c -o tuner-xc3028 -g -L.. -lmedia-core -lm
gcc -shared tuner-xc3028.c -o libtuner-xc3028.so -g -fPIC -lm
make[1]: Leaving directory `/home/jelle/userspace-drivers/userspace/xc3028'
gcc media-daemon.c -L. -lmedia-core -ldl -o media-daemon "-I/lib/modules/`uname -r`/source/include"  -g
mkdir -p //usr/sbin
mkdir -p //usr/lib
mkdir -p //usr/lib/v4l-dvb
mkdir -p //usr/lib/v4l-dvb/firmware #will disappear later because the firmware will be included within the xc3028 driver
install media-daemon //usr/sbin
cp libmedia-core.so //usr/lib
cp libtuner-xc3028.so //usr/lib/v4l-dvb
cp libdemod-zl10353.so //usr/lib/v4l-dvb
cp libvdec-tvp5150.so //usr/lib/v4l-dvb
cp libvdec-cx25840.so //usr/lib/v4l-dvb
cp xc5000/libtuner-xc5000.so //usr/lib/v4l-dvb
cp xc3028/libtuner-xc3028.so //usr/lib/v4l-dvb
cp drx3975d/libdemod-drx3975d.so //usr/lib/v4l-dvb
Ubuntu found
jelle@debian-eeepc:~/userspace-drivers$ cd ~
jelle@debian-eeepc:~$ cd ~
jelle@debian-eeepc:~$ sudo rm -r em28xx-userspace2
rm: cannot remove `em28xx-userspace2': No such file or directory
jelle@debian-eeepc:~$ hg clone http://mcentral.de/hg/~mrec/em28xx-userspace2
destination directory: em28xx-userspace2
requesting all changes
adding changesets
adding manifests
adding file changes
added 22 changesets with 67 changes to 20 files
18 files updated, 0 files merged, 0 files removed, 0 files unresolved
jelle@debian-eeepc:~$ cd em28xx-userspace2
jelle@debian-eeepc:~/em28xx-userspace2$ sudo ./build.sh
if [ -f ../userspace-drivers/kernel/Module.symvers ]; then \
    grep v4l_dvb_stub_attach ../userspace-drivers/kernel/Module.symvers > Module.symvers; \
    fi
make -C /lib/modules/2.6.24-1-686/build SUBDIRS=/home/jelle/em28xx-userspace2 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.24-1-686'
  CC [M]  /home/jelle/em28xx-userspace2/em2880-dvb.o
In file included from /home/jelle/em28xx-userspace2/em28xx.h:42,
                 from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in a function)
make[2]: *** [/home/jelle/em28xx-userspace2/em2880-dvb.o] Error 1
make[1]: *** [_module_/home/jelle/em28xx-userspace2] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.24-1-686'
make: *** [default] Error 2
rm -rf /lib/modules/2.6.24-1-686/kernel/drivers/media/video/em28xx/em28xx.ko ; \
    make INSTALL_MOD_PATH= INSTALL_MOD_DIR=kernel/drivers/media/video/em28xx \
        -C /lib/modules/2.6.24-1-686/build M=/home/jelle/em28xx-userspace2 modules_install
make[1]: Entering directory `/usr/src/linux-headers-2.6.24-1-686'
  DEPMOD  2.6.24-1-686
make[1]: Leaving directory `/usr/src/linux-headers-2.6.24-1-686'
depmod -a
jelle@debian-eeepc:~/em28xx-userspace2$ cd ~
jelle@debian-eeepc:~$

--------------070208080806010406000402
Content-Type: text/plain;
 name="Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.1j.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v";
 filename*1="0.1.1j.txt"

#!/bin/sh

# step 1: update your system
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade
sudo apt-get autoremove

# step 2: clean your system
sudo apt-get remove linux-headers linux-source linux-headers-$(uname -r)
sudo apt-get autoremove

# step 3: install the nessesary tools
sudo apt-get install linux-source linux-headers-$(uname -r) build-essential mercurial

# step 4: extract the kernel source
cd /usr/src
sudo tar --bzip2 -xvf linux-source-2.6.*.tar.bz2
cd ~

# step 5: remove old symlinks
sudo rm /usr/src/linux
sudo rm /lib/modules/$(uname -r)/source

# step 6: create new sysmlinks, change the kernel to its current version
sudo ln -s /usr/src/linux-source-2.6.24 /usr/src/linux
sudo ln -s /usr/src/linux-source-2.6.24 /lib/modules/$(uname -r)/source

# step 7: copy your orignal config to the kernel source root tree
sudo cp --verbose /boot/config-$(uname -r) /usr/src/linux/.config

# step 8: check if the symlink and kernel source is there
ls -hal /usr/src/
#total 44M
#drwxrwsr-x  6 root src  4.0K Feb 29 15:16 .
#drwxr-xr-x 11 root root 4.0K Feb 23 00:32 ..
#lrwxrwxrwx  1 root src    28 Feb 29 15:16 linux -> /usr/src/linux-source-2.6.24
#drwxr-xr-x  4 root root 4.0K Feb 29 15:10 linux-headers-2.6.24-1-686
#drwxr-xr-x 18 root root 4.0K Feb 29 15:10 linux-headers-2.6.24-1-common
#drwxr-xr-x  3 root root 4.0K Feb 29 15:10 linux-kbuild-2.6.24
#drwxr-xr-x 20 root root 4.0K Feb 29 15:17 linux-source-2.6.24
#-rw-r--r--  1 root root  44M Feb 11 12:42 linux-source-2.6.24.tar.bz2

# step 9: make sure all these files and locations excist
ls -hal /lib/modules/$(uname -r)/source
ls -hal /lib/modules/$(uname -r)/source/drivers/media/dvb/dvb-core/dmxdev.h
ls -hal /lib/modules/$(uname -r)/source/drivers/media/dvb/dvb-core/dvb_frontend.h
ls -hal /lib/modules/$(uname -r)/source/drivers/media/dvb/dvb-core/dvb_demux.h
ls -hal /lib/modules/$(uname -r)/source/drivers/media/dvb/dvb-core/dvb_net.h
ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dmxdev.h
ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dvb_frontend.h
ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dvb_demux.h
ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dvb_net.h

# step 10: download and build the first driver nessecary to build the second one
cd ~
sudo rm -r userspace-drivers
hg clone http://mcentral.de/hg/~mrec/userspace-drivers
cd userspace-drivers
sudo ./build.sh
cd ~

# step 10: download and build the second driver after you build the first one
cd ~
sudo rm -r em28xx-userspace2
hg clone http://mcentral.de/hg/~mrec/em28xx-userspace2
cd em28xx-userspace2
sudo ./build.sh
cd ~

# step 11: load the main userspace kernel module that should load all others to
sudo modprobe em28xx-dvb

# step 12: plugin the device

-- -- -- -- -- -- --
-- -- -- -- -- -- --

Bus 005 Device 015: ID 2304:0226 Pinnacle Systems, Inc. [hex]
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x2304 Pinnacle Systems, Inc. [hex]
  idProduct          0x0226
  bcdDevice            1.10
  iManufacturer           3 Pinnacle Systems
  iProduct                1 PCTV 330e
  iSerial                 2 070901090280
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          305
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       2
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0ad4  2x 724 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       3
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0c00  2x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       4
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1300  3x 768 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       5
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x135c  3x 860 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       6
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x13c4  3x 964 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       7
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

--------------070208080806010406000402
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------070208080806010406000402--
