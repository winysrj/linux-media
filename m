Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smeagol.cambrium.nl ([217.19.16.145] ident=qmailr)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1JV6t8-0007SD-29
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 16:11:06 +0100
Message-ID: <47C82083.6080800@powercraft.nl>
Date: Fri, 29 Feb 2008 16:10:59 +0100
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <47C7329F.7030705@powercraft.nl> <47C7360E.9030908@powercraft.nl>	
	<d9def9db0802281440x2daa2f21n2169e76b53ccd664@mail.gmail.com>	
	<47C73A05.2050007@powercraft.nl>	
	<d9def9db0802281455hb962279g9f45a8e87cf16d28@mail.gmail.com>	
	<d9def9db0802281458g73939fefq8c5d7bc9aa49e1aa@mail.gmail.com>	
	<47C74DF4.6040608@powercraft.nl>
	<1204246336.22520.57.camel@youkaida>	
	<d9def9db0802282327l1139e17ew8a571ac578e37df2@mail.gmail.com>	
	<47C8163E.5030009@powercraft.nl>
	<d9def9db0802290637k5495258n7b6cff5700d94675@mail.gmail.com>
In-Reply-To: <d9def9db0802290637k5495258n7b6cff5700d94675@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------030909070709050207050502"
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
--------------030909070709050207050502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Markus Rechberger wrote:
>>  I spent several hours again to see if I could get it working on Debian
>>  sid. I got a little bit further bit still got compilation errors.
>>
>>  Can you please look at my attachments.
>>
> 
>  CC [M]  /home/jelle/em28xx-userspace2/em2880-dvb.o
> In file included from /home/jelle/em28xx-userspace2/em28xx.h:42,
>                 from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
> include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in
> a function)
> 
> ok this seems to come from a cleanup patch to remove some warnings. I
> reverted that change again.
> Can you download em28xx-userspace2 again and try to recompile it.
> 
> thanks,
> Markus

Thank you it is now compiling, however when loading the drivers after 
rebooting the pc (also before rebooting) i get the following errors.

See the attachments,

Kind regards,

Jelle


--------------030909070709050207050502
Content-Type: text/plain;
 name="error-log-2-em28xx.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="error-log-2-em28xx.txt"

usb 5-3: new high speed USB device using ehci_hcd and address 5
usb 5-3: configuration #1 chosen from 1 choice
em28xx: disagrees about version of symbol video_unregister_device
em28xx: Unknown symbol video_unregister_device
em28xx: disagrees about version of symbol video_device_alloc
em28xx: Unknown symbol video_device_alloc
em28xx: disagrees about version of symbol video_register_device
em28xx: Unknown symbol video_register_device
em28xx: disagrees about version of symbol video_device_release
em28xx: Unknown symbol video_device_release
jelle@debian-eeepc:~$ sudo modinfo em28xx
filename:       /lib/modules/2.6.24-1-686/kernel/drivers/media/video/em28xx/em28xx.ko
license:        GPL
description:    Empia em28xx based USB video device driver
author:         Ludovico Cavedon <cavedon@sssup.it>, Markus Rechberger <mrechberger@gmail.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Sascha Sommer <saschasommer@freenet.de>
alias:          usb:v0CCDp0072d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v093BpA005d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1ApA316d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1ApE305d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1Ap2751d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2304p0226d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2304p0227d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2040p6513d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1Ap2883d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2001pF112d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0413p6023d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v185Bp2870d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp0047d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp0043d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp005Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp004Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp004Fd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp0042d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2040p6502d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2040p6500d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2304p021Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2304p0207d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2040p650Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2040p4201d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2040p4200d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2304p0208d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp0036d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1ApE357d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1ApE355d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1ApE350d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1ApE300d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1ApE320d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1ApE310d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1Ap2870d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1Ap2881d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1Ap2861d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1Ap2860d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1Ap2750d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1Ap2821d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1Ap2820d*dc*dsc*dp*ic*isc*ip*
alias:          usb:vEB1Ap2800d*dc*dsc*dp*ic*isc*ip*
depends:        i2c-core,usbcore,videodev,v4l2-common,v4l1-compat
vermagic:       2.6.24-1-686 SMP mod_unload 686
parm:           disable_ir:disable infrared remote support (int)
parm:           ir_debug:enable debug messages [IR] (int)
parm:           core_debug:enable debug messages [core] (int)
parm:           reg_debug:enable debug messages [URB reg] (int)
parm:           isoc_debug:enable debug messages [isoc transfers] (int)
parm:           alt:alternate setting to use for video endpoint (int)
parm:           i2c_scan:scan i2c bus at insmod time (int)
parm:           i2c_debug:enable debug messages [i2c] (int)
parm:           card:card type (array of int)
parm:           video_nr:video device numbers (array of int)
parm:           vbi_nr:vbi device numbers (array of int)
parm:           tuner:tuner type (int)
parm:           userspace_tuner:userspace tuner (int)
parm:           video_debug:enable debug messages [video] (int)
parm:           device_mode:device mode (DVB-T/Analogue TV) (int)
parm:           vbi_mode:VBI mode (0 disabled/1 enabled(default, if appropriate)) (int)

--------------030909070709050207050502
Content-Type: text/plain;
 name="Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.2j.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v";
 filename*1="0.1.2j.txt"

#!/bin/bash

#       Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.1j.txt
#
#       Copyright 2008 Jelle de Jong <jelledejong@powercraft.nl>
#
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.

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

# step 11: download and build the second driver after you build the first one
cd ~
sudo rm -r em28xx-userspace2
hg clone http://mcentral.de/hg/~mrec/em28xx-userspace2
cd em28xx-userspace2
sudo ./build.sh
cd ~

# step 12: reboot your computer to be on the save side
sudo shutdown -r now

# step 12: load the main userspace kernel module that should load all others to
sudo modprobe em28xx-dvb

# step 13: plugin the device and check the dmesg output
dmesg

# step 14: install completed exiting, please look at the uing guide for more info
exit

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

--------------030909070709050207050502
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030909070709050207050502--
