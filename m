Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smeagol.cambrium.nl ([217.19.16.145] ident=qmailr)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1JUsrj-0003UE-Qn
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 01:12:44 +0100
Message-ID: <47C74DF4.6040608@powercraft.nl>
Date: Fri, 29 Feb 2008 01:12:36 +0100
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <47C7329F.7030705@powercraft.nl>	
	<d9def9db0802281421v698df05eq52a1978c69d80df2@mail.gmail.com>	
	<47C73457.1030901@powercraft.nl>	
	<d9def9db0802281425i5b487f43ub90b263a63e40a01@mail.gmail.com>	
	<47C7360E.9030908@powercraft.nl>	
	<d9def9db0802281440x2daa2f21n2169e76b53ccd664@mail.gmail.com>	
	<47C73A05.2050007@powercraft.nl>	
	<d9def9db0802281455hb962279g9f45a8e87cf16d28@mail.gmail.com>
	<d9def9db0802281458g73939fefq8c5d7bc9aa49e1aa@mail.gmail.com>
In-Reply-To: <d9def9db0802281458g73939fefq8c5d7bc9aa49e1aa@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------050304070309050309070109"
Cc: linux-dvb <linux-dvb@linuxtv.org>, em28xx@mcentral.de
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
--------------050304070309050309070109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Markus Rechberger wrote:
> On 2/28/08, Markus Rechberger <mrechberger@gmail.com> wrote:
>> On 2/28/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
>>> Markus Rechberger wrote:
>>>> On 2/28/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
>>>>> Markus Rechberger wrote:
>>>>>> On 2/28/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
>>>>>>> Markus Rechberger wrote:
>>>>>>>> On 2/28/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
>>>>>>>>> This message contains the following attachment(s):
>>>>>>>>> Pinnacle PCTV Hybrid Pro Stick 330e.txt
>>>>>>>>>
>>>>>>>>> Spent my hole day trying to get a dvd-t device up and running, this
>>> is
>>>>>>>>> device number two I tried.
>>>>>>>>>
>>>>>>>>> Can somebody please tell me how to get this device working on:
>>>>>>>>>
>>>>>>>>> 2.6.24-1-686 debian sid and 2.6.22-14-generic ubuntu
>>>>>>>>>
>>>>>>>>> I have to get some sleep now, because this is getting on my health
>>> and
>>>>>>>>> that does not happen often....
>>>>>>>>>
>>>>>>>> Jelle, it's really easy to install it actually.
>>>>>>>> http://www.mail-archive.com/em28xx%40mcentral.de/msg00750.html
>>>>>>>>
>>>>>>>> this is the correct "howto" for it.
>>>>>>>>
>>>>>>>> You need the linux kernel sources for your kernel, if you experience
>>>>>>>> any problems just post them to the em28xx ML.
>>>>>>>>
>>>>>>>> Markus
>>>>>>> Hi Markus,
>>>>>>>
>>>>>>> I tried that two times,
>>>>>>>
>>>>>>> The seconds build blows up in my face, I need specified dependecies
>> to
>>>>>>> be able to compile the seconds driver...
>>>>>>>
>>>>>> there are not so many dependencies, just submit the errors you get.
>>>>>>
>>>>>> Markus
>>>>> Here you go, lets see I will try it for 40 more minutes with your help
>>>>>
>>>> jelle@xubutu-en12000e:~$ hg clone
>>> http://mcentral.de/hg/~mrec/em28xx-userspace2
>>>> destination directory: em28xx-userspace2
>>>> requesting all changes
>>>> adding changesets
>>>> adding manifests
>>>> adding file changes
>>>> added 21 changesets with 65 changes to 20 files
>>>> 18 files updated, 0 files merged, 0 files removed, 0 files unresolved
>>>> jelle@xubutu-en12000e:~$ cd em28xx-userspace2
>>>> jelle@xubutu-en12000e:~/em28xx-userspace2$ sudo ./build.sh
>>>> if [ -f ../userspace-drivers/kernel/Module.symvers ]; then \
>>>> grep v4l_dvb_stub_attach
>>>> ../userspace-drivers/kernel/Module.symvers > Module.symvers; \
>>>> fi
>>>> make -C /lib/modules/2.6.22-14-generic/build
>>>> SUBDIRS=/home/jelle/em28xx-userspace2 modules
>>>> make[1]: Entering directory `/usr/src/linux-headers-2.6.22-14-generic'
>>>> CC [M] /home/jelle/em28xx-userspace2/em2880-dvb.o
>>>> In file included from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
>>>> /home/jelle/em28xx-userspace2/em28xx.h:33:20: error: dmxdev.h: No
>>>> such file or directory
>>>> /home/jelle/em28xx-userspace2/em28xx.h:34:23: error: dvb_demux.h: No
>>>> such file or directory
>>>> /home/jelle/em28xx-userspace2/em28xx.h:35:21: error: dvb_net.h: No
>>>> such file or directory
>>>> /home/jelle/em28xx-userspace2/em28xx.h:36:26: error: dvb_frontend.h:
>>>> No such file or directory
>>>>
>>>> there we go, the linux kernel sources aren't installed for your system.
>>>>
>>>> apt-get install linux-source linux-headers-`uname -r`
>>>>
>>>> I'm not sure if the kernel sources are decompressed in /usr/src you
>>>> might have a look at it.
>>>>
>>>> /lib/modules/`uname -r`/build should be a symlink to the root of the
>>>> extracted kernelsources.
>>>>
>>>> the root of your kernelsources should also contain a .config file.
>>>>
>>>> You can find the config file for your current kernel in /boot
>>>>
>>>> /boot/config-`uname -r`
>>>>
>>>> copy this file to the kernelroot and rename it to ".config"
>>>>
>>>> Markus
>>> sudo apt-get install linux-source linux-headers-`uname -r`
>>> Reading package lists... Done
>>> Building dependency tree
>>> Reading state information... Done
>>> linux-source is already the newest version.
>>> linux-headers-2.6.22-14-generic is already the newest version.
>>> 0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
>>> jelle@xubutu-en12000e:~/em28xx-userspace2$ ls -hal /lib/modules/`uname
>>> -r`/build
>>> lrwxrwxrwx 1 root root 40 2007-10-21 18:19
>>> /lib/modules/2.6.22-14-generic/build ->
>>> /usr/src/linux-headers-2.6.22-14-generic
>>> jelle@xubutu-en12000e:~/em28xx-userspace2$ /boot/config-`uname -r`
>>> bash: /boot/config-2.6.22-14-generic: Permission denied
>>> jelle@xubutu-en12000e:~/em28xx-userspace2$ sudo /boot/config-`uname -r`
>>> sudo: /boot/config-2.6.22-14-generic: command not found
>>> jelle@xubutu-en12000e:~/em28xx-userspace2$ sudo ls /boot/config-`uname -r`
>>> /boot/config-2.6.22-14-generic
>>> jelle@xubutu-en12000e:~/em28xx-userspace2$
>>>
>>> sudo cp --verbose /boot/config-2.6.22-14-generic /usr/src/linux/.config
>>> `/boot/config-2.6.22-14-generic' -> `/usr/src/linux/.config'
>>>
>>>
>>> still all the same problems !
>>>
>> it's just one problem actually, the kernel sources aren't installed or
>> not installed correctly.
>>
>> You need to have
>>
>> /usr/src/linux/drivers/media/dvb/dvb-core/dmxdev.h
>> /usr/src/linux/drivers/media/dvb/dvb-core/dvb_frontend.h
>> /usr/src/linux/drivers/media/dvb/dvb-core/dvb_demux.h
>> /usr/src/linux/drivers/media/dvb/dvb-core/dvb_net.h
>>
>> those are part of the ubuntu linux source package.
>>
>> look up the source package for 2.6.22 with apt-cache
>> apt-cache search linux-source | grep -i 2.6.22 or something like that
>> and install it.
>>
> 
> if you have an instant messenger (icq/aim/or irc), just send me a mail
> it shouldn't take so long to get it work if you know what to do...
> you ran into quite many wrong directions with your previous attempts..
> 
> Markus

I tried it again, it is still not working, can you please specify what 
the dependency's are and where you are looking for them?

I have added the logs and information about my system into the attachments,

I am going to sleep now....

Kind regards,

Jelle de Jong





--------------050304070309050309070109
Content-Type: text/plain;
 name="Pinnacle PCTV Hybrid Pro Stick 330e.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Pinnacle PCTV Hybrid Pro Stick 330e.txt"

sudo apt-get install dvb-utils

http://www.linuxtv.org/v4lwiki/index.php/Pinnacle/330e
http://www.linuxtv.org/wiki/index.php/DVB_via_USB
http://lunapark6.com/usb-hdtv-tuner-stick-for-windows-linux-hauppauge-wintv-hvr-950.html
http://www.wi-bw.tfh-wildau.de/~pboettch/home/index.php?site=dvb-usb-firmware
http://www.mail-archive.com/em28xx@mcentral.de/msg00750.html

sudo apt-get update
sudo apt-get upgrade
sudo apt-get autoremove
sudo apt-get remove linux-headers linux-source linux-headers-$(uname -r)
sudo apt-get remove linux-source
sudo apt-get remove mercurial linux-headers-$(uname -r) linux-source-2.6.22 linux-headers-2.6.22-14 linux-source build-essential
sudo apt-get autoremove

sudo apt-get install linux-source-2.6.22 linux-headers-2.6.22-14-generic build-essential mercurial

cd /usr/src
sudo tar --bzip2 -xvf linux-source-2.6.22.tar.bz2
sudo rm /usr/src/linux
sudo ln -s /usr/src/linux-source-2.6.22 /usr/src/linux
cd ~

sudo cp --verbose /boot/config-2.6.22-14-generic /usr/src/linux/.config

ls -hal /usr/src/
total 44M
drwxrwsr-x  5 root src  4.0K 2008-02-29 01:05 .
drwxr-xr-x 12 root root 4.0K 2007-10-22 21:29 ..
lrwxrwxrwx  1 root src    28 2008-02-29 01:05 linux -> /usr/src/linux-source-2.6.22
drwxr-xr-x 19 root root 4.0K 2008-02-29 01:03 linux-headers-2.6.22-14
drwxr-xr-x  5 root root 4.0K 2008-02-29 01:03 linux-headers-2.6.22-14-generic
drwxr-xr-x 21 root root 4.0K 2008-02-12 11:24 linux-source-2.6.22
-rw-r--r--  1 root root  44M 2008-02-12 11:25 linux-source-2.6.22.tar.bz2

ls /usr/src/linux/drivers/media/dvb/dvb-core/dvb_net.h
/usr/src/linux/drivers/media/dvb/dvb-core/dvb_net.h

cd ~
sudo rm -r userspace-drivers
hg clone http://mcentral.de/hg/~mrec/userspace-drivers
cd userspace-drivers
sudo ./build.sh

cd ~
sudo rm -r em28xx-userspace2
hg clone http://mcentral.de/hg/~mrec/em28xx-userspace2
cd em28xx-userspace2
sudo ./build.sh

-- -- -- -- -- -- --
-- -- -- -- -- -- --

# OLD

wget http://www.linuxtv.org/pipermail/linux-dvb/attachments/20070802/3b2e4d6a/attachment-0001.obj
patch --strip=1 --directory=/home/jelle/v4l-dvb-experimental < attachment-0001.obj

sudo apt-get install mercurial
cd $HOME
hg clone http://linuxtv.org/hg/v4l-dvb
cd v4l-dvb
make
sudo make install
sudo depmod -a

sudo modprobe crc32
sudo modprobe crc32c
sudo modprobe firmware_class

sudo apt-get install kaffeine-xine


sudo apt-get install mercurial
cd $HOME
hg clone http://linuxtv.org/hg/v4l-dvb

rm -r $HOME/v4l-dvb/linux/drivers/media/video/em28xx
cp --verbose --recursive $HOME/v4l-dvb-experimental/linux/drivers/media/video/em28xx $HOME/v4l-dvb/linux/drivers/media/video/em28xx
cd $HOME/v4l-dvb
make clean
make
sudo make install


sudo modprobe i2c-core
sudo modprobe dvb-core
sudo modprobe dvb-pll

sudo modprobe em28xx

sudo find $HOME/v4l-dvb '*' -type f -exec sudo grep -H -n "0x0226" '{}' \;
sudo find $HOME/v4l-dvb '*' -type f -exec sudo grep -H -n "0x2304" '{}' \;

/home/jelle/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h:122:#define USB_PID_WT220U_FC_WARM       0x0226
/home/jelle/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h:42:#define USB_VID_PINNACLE              0x2304


sudo apt-get install mercurial linux-headers-$(uname -r) linux-source build-essential
cd ~
wget http://konstantin.filtschew.de/v4l-firmware/firmware_v3.tgz
sudo tar xvz -C /lib/firmware -f firmware_v3.tgz
ls -hal /lib/firmware
rm firmware_v3.tgz

cd ~
hg clone http://linuxtv.org/hg/v4l-dvb
cd v4l-dvb
make
sudo make install

sudo modprobe em2880-dvb

tvtime | arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | aplay -

hg clone http://mcentral.de/hg/~mrec/v4l-dvb-kernel
cd v4l-dvb-kernel
make module em2880-dvb

cd ~
hg clone http://mcentral.de/hg/~mrec/v4l-dvb-experimental
cd v4l-dvb-experimental
make

hg clone http://mcentral.de/hg/~mrec/v4l-dvb-experimental
cd v4l-dvb-experimental
make
make install

sudo apt-get remove --purge mercurial linux-headers-$(uname -r) linux-source build-essential

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

--------------050304070309050309070109
Content-Type: text/plain;
 name="error-log.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="error-log.txt"

sudo ./build.sh
if [ -f ../userspace-drivers/kernel/Module.symvers ]; then \
        grep v4l_dvb_stub_attach ../userspace-drivers/kernel/Module.symvers > Module.symvers; \
        fi
make -C /lib/modules/2.6.22-14-generic/build SUBDIRS=/home/jelle/em28xx-userspace2 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.22-14-generic'
  CC [M]  /home/jelle/em28xx-userspace2/em2880-dvb.o
In file included from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
/home/jelle/em28xx-userspace2/em28xx.h:46:24: error: media-stub.h: No such file or directory
In file included from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
/home/jelle/em28xx-userspace2/em28xx.h:550: error: field ‘tobj’ has incomplete type
/home/jelle/em28xx-userspace2/em28xx.h:551: error: field ‘vobj’ has incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘drx3975d_callback’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:522: error: ‘DEMOD_INIT’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:522: error: (Each undeclared identifier is reported only once
/home/jelle/em28xx-userspace2/em2880-dvb.c:522: error: for each function it appears in.)
/home/jelle/em28xx-userspace2/em2880-dvb.c:524: error: ‘TUNER_STUB_DVBT_TV’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:525: warning: implicit declaration of function ‘tuner_run_cmd’
/home/jelle/em28xx-userspace2/em2880-dvb.c:525: error: ‘TUNER_CMD_INIT’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:527: error: ‘TUNER_CMD_S_GATE’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘zl10353_callback’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:540: error: ‘DEMOD_INIT’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:542: error: ‘TUNER_STUB_DVBT_TV’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:544: error: ‘TUNER_CMD_INIT’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em28xx_ts_bus_ctrl’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:556: error: dereferencing pointer to incomplete type
/home/jelle/em28xx-userspace2/em2880-dvb.c:563: error: ‘TUNER_STUB_DVBT_TV’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:567: error: ‘TUNER_CMD_INIT’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c: In function ‘em2880_dvb_init’:
/home/jelle/em28xx-userspace2/em2880-dvb.c:596: error: storage size of ‘demod_conf’ isn’t known
/home/jelle/em28xx-userspace2/em2880-dvb.c:601: error: ‘TUNER_STUB_DVBT_TV’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:607: error: ‘U_DEMOD_DRX3975D’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:611: error: ‘STUB_DEMOD’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:613: error: ‘v4l_dvb_stub_attach’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:613: warning: type defaults to ‘int’ in declaration of ‘__a’
/home/jelle/em28xx-userspace2/em2880-dvb.c:613: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:613: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:613: error: called object ‘__a’ is not a function
/home/jelle/em28xx-userspace2/em2880-dvb.c:616: error: storage size of ‘config’ isn’t known
/home/jelle/em28xx-userspace2/em2880-dvb.c:618: warning: implicit declaration of function ‘TUNER_CLIENT_ID’
/home/jelle/em28xx-userspace2/em2880-dvb.c:622: error: ‘STUB_TUNER’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:627: warning: type defaults to ‘int’ in declaration of ‘__a’
/home/jelle/em28xx-userspace2/em2880-dvb.c:627: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:627: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:627: error: called object ‘__a’ is not a function
/home/jelle/em28xx-userspace2/em2880-dvb.c:629: error: ‘TUNER_CMD_INIT’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:616: warning: unused variable ‘config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:596: warning: unused variable ‘demod_conf’
/home/jelle/em28xx-userspace2/em2880-dvb.c:682: error: ‘TUNER_STUB_ATSC_TV’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:692: error: storage size of ‘config’ isn’t known
/home/jelle/em28xx-userspace2/em2880-dvb.c:703: warning: type defaults to ‘int’ in declaration of ‘__a’
/home/jelle/em28xx-userspace2/em2880-dvb.c:703: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:703: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:703: error: called object ‘__a’ is not a function
/home/jelle/em28xx-userspace2/em2880-dvb.c:692: warning: unused variable ‘config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:711: error: storage size of ‘demod_conf’ isn’t known
/home/jelle/em28xx-userspace2/em2880-dvb.c:720: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:720: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:720: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:720: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:720: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:720: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:721: error: ‘U_DEMOD_ZL10353’ undeclared (first use in this function)
/home/jelle/em28xx-userspace2/em2880-dvb.c:728: warning: type defaults to ‘int’ in declaration of ‘__a’
/home/jelle/em28xx-userspace2/em2880-dvb.c:728: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:728: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:728: error: called object ‘__a’ is not a function
/home/jelle/em28xx-userspace2/em2880-dvb.c:731: error: storage size of ‘config’ isn’t known
/home/jelle/em28xx-userspace2/em2880-dvb.c:747: warning: type defaults to ‘int’ in declaration of ‘__a’
/home/jelle/em28xx-userspace2/em2880-dvb.c:747: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:747: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:747: error: called object ‘__a’ is not a function
/home/jelle/em28xx-userspace2/em2880-dvb.c:731: warning: unused variable ‘config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:711: warning: unused variable ‘demod_conf’
/home/jelle/em28xx-userspace2/em2880-dvb.c:760: error: storage size of ‘demod_conf’ isn’t known
/home/jelle/em28xx-userspace2/em2880-dvb.c:769: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:769: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:769: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:769: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:769: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:769: error: invalid application of ‘sizeof’ to incomplete type ‘struct media_config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:781: warning: type defaults to ‘int’ in declaration of ‘__a’
/home/jelle/em28xx-userspace2/em2880-dvb.c:781: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:781: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:781: error: called object ‘__a’ is not a function
/home/jelle/em28xx-userspace2/em2880-dvb.c:784: error: storage size of ‘config’ isn’t known
/home/jelle/em28xx-userspace2/em2880-dvb.c:799: warning: type defaults to ‘int’ in declaration of ‘__a’
/home/jelle/em28xx-userspace2/em2880-dvb.c:799: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:799: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:799: error: called object ‘__a’ is not a function
/home/jelle/em28xx-userspace2/em2880-dvb.c:784: warning: unused variable ‘config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:760: warning: unused variable ‘demod_conf’
/home/jelle/em28xx-userspace2/em2880-dvb.c:829: error: storage size of ‘config’ isn’t known
/home/jelle/em28xx-userspace2/em2880-dvb.c:839: warning: type defaults to ‘int’ in declaration of ‘__a’
/home/jelle/em28xx-userspace2/em2880-dvb.c:839: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:839: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:839: error: called object ‘__a’ is not a function
/home/jelle/em28xx-userspace2/em2880-dvb.c:829: warning: unused variable ‘config’
/home/jelle/em28xx-userspace2/em2880-dvb.c:859: error: storage size of ‘config’ isn’t known
/home/jelle/em28xx-userspace2/em2880-dvb.c:868: warning: type defaults to ‘int’ in declaration of ‘__a’
/home/jelle/em28xx-userspace2/em2880-dvb.c:868: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:868: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/jelle/em28xx-userspace2/em2880-dvb.c:868: error: called object ‘__a’ is not a function
/home/jelle/em28xx-userspace2/em2880-dvb.c:859: warning: unused variable ‘config’
make[2]: *** [/home/jelle/em28xx-userspace2/em2880-dvb.o] Error 1
make[1]: *** [_module_/home/jelle/em28xx-userspace2] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.22-14-generic'
make: *** [default] Error 2
rm -rf /lib/modules/2.6.22-14-generic/kernel/drivers/media/video/em28xx/em28xx.ko ; \
        make INSTALL_MOD_PATH= INSTALL_MOD_DIR=kernel/drivers/media/video/em28xx \
                -C /lib/modules/2.6.22-14-generic/build M=/home/jelle/em28xx-userspace2 modules_install
make[1]: Entering directory `/usr/src/linux-headers-2.6.22-14-generic'
  DEPMOD  2.6.22-14-generic
make[1]: Leaving directory `/usr/src/linux-headers-2.6.22-14-generic'
depmod -a
jelle@xubutu-en12000e:~/em28xx-userspace2$


--------------050304070309050309070109
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------050304070309050309070109--
