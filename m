Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.lie-comtel.li ([217.173.238.89]:52566 "EHLO
	smtp2.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZH1ThK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 15:37:10 -0400
Message-ID: <4A982F5D.6070904@kaiser-linux.li>
Date: Fri, 28 Aug 2009 21:26:21 +0200
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: Dotan Cohen <dotancohen@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Using MSI StarCam 370i Webcam with Kubuntu Linux
References: <880dece00908281140r16385c1fr476b18f2fcfe3c1b@mail.gmail.com>
In-Reply-To: <880dece00908281140r16385c1fr476b18f2fcfe3c1b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/28/2009 08:40 PM, Dotan Cohen wrote:
> I have the MSI StarCam 370i Webcam and I have trying to use it with
> Kubuntu Linux 9.04 Jaunty. According to this page, "The StarCam 370i
> is compliant with UVC, USB video class":
> http://gadgets.softpedia.com/gadgets/Computer-Peripherals/The-MSI-StarCam-370i-3105.html
> 
> According to the Linux UVC driver and tools download page, "Linux
> 2.6.26 and newer includes the Linux UVC driver natively" which is nice
> as I am on a higher version:
> $ uname -r
> 2.6.28-15-generic
> 
> However, plugging in the webcam and testing with camorama, cheese, and
> luvcview led me to no results:
> 
> jaunty2@laptop:~$ luvcview -f yuv
> luvcview 0.2.4
> 
> SDL information:
>  Video driver: x11
>  A window manager is available
> Device information:
>  Device path:  /dev/video0
> Stream settings:
> ERROR: Requested frame format YUYV is not available and no fallback
> format was found.
>  Init v4L2 failed !! exit fatal
> jaunty2@laptop:~$ luvcview -f uyvy
> luvcview 0.2.4
> 
> SDL information:
>  Video driver: x11
>  A window manager is available
> Device information:
>  Device path:  /dev/video0
> Stream settings:
> ERROR: Requested frame format UYVY is not available and no fallback
> format was found.
>  Init v4L2 failed !! exit fatal
> jaunty2@laptop:~$ luvcview
> luvcview 0.2.4
> 
> SDL information:
>  Video driver: x11
>  A window manager is available
> Device information:
>  Device path:  /dev/video0
> Stream settings:
> ERROR: Requested frame format MJPG is not available and no fallback
> format was found.
>  Init v4L2 failed !! exit fatal
> 
> 
> Some more details:
> 
> jaunty2@laptop:~$ ls /dev/vi*
> /dev/video0
> jaunty2@laptop:~$ dmesg | tail
> [ 2777.811972] sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers
> v1:1.47pre49
> [ 2777.814989] usb 2-1: SN9C105 PC Camera Controller detected (vid:pid
> 0x0C45:0x60FC)
> [ 2777.842123] usb 2-1: HV7131R image sensor detected
> [ 2778.185108] usb 2-1: Initialization succeeded
> [ 2778.185220] usb 2-1: V4L2 device registered as /dev/video0
> [ 2778.185225] usb 2-1: Optional device control through 'sysfs'
> interface disabled
> [ 2778.185283] usbcore: registered new interface driver sn9c102
> [ 2778.216691] usbcore: registered new interface driver snd-usb-audio
> [ 2778.218738] usbcore: registered new interface driver sonixj
> [ 2778.218745] sonixj: registered
> jaunty2@laptop:~$ lsusb
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 005 Device 002: ID 413c:8126 Dell Computer Corp. Wireless 355 Bluetooth
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 004: ID 045e:0040 Microsoft Corp. Wheel Mouse Optical
> Bus 004 Device 003: ID 045e:00db Microsoft Corp. Natural Ergonomic
> Keyboard 4000 V1.0
> Bus 004 Device 002: ID 05e3:0604 Genesys Logic, Inc. USB 1.1 Hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 002: ID 0c45:60fc Microdia PC Camera with Mic (SN9C105)
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> jaunty2@laptop:~$
> 
> 
> 
> Anything missing? What should I do? Thanks in advance!

Hello Dotan, me again ;-)

Looks like your cam is detected, but does not provide a good frame 
format. You my have to use libv4l to convert to a know format.

See: http://hansdegoede.livejournal.com/7622.html

and it is provided by Ubuntu:

thomas@AMD64:~$ cat /etc/issue
Ubuntu 9.04 \n \l

thomas@AMD64:~$ uname -a
Linux AMD64 2.6.28-15-generic #49-Ubuntu SMP Tue Aug 18 19:25:34 UTC 
2009 x86_64 GNU/Linux

thomas@AMD64:~$ apt-cache show libv4l-0
Package: libv4l-0
Priority: optional
Section: libs
Installed-Size: 256
Maintainer: Ubuntu Core Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Original-Maintainer: Gregor Jasny <gjasny@web.de>
Architecture: amd64
Source: libv4l
Version: 0.5.8-1
Depends: libc6 (>= 2.4)
Filename: pool/main/libv/libv4l/libv4l-0_0.5.8-1_amd64.deb
Size: 64680
MD5sum: c7011003567b7ea3d4271f677ec28c7a
SHA1: 43a623f0b74b506cee8b7b15e1db996040358294
SHA256: 16cc3199df039259500657db98788ea39b7615a9080ffa4e7159a66f2b8a8b6e
Description: Collection of video4linux support libraries
  libv4l is a collection of libraries which adds a thin abstraction layer on
  top of video4linux2 devices. The purpose of this (thin) layer is to 
make it
  easy for application writers to support a wide variety of devices without
  having to write separate code for different devices in the same class. 
libv4l
  consists of 3 different libraries: libv4lconvert, libv4l1 and libv4l2.
  .
  libv4lconvert offers functions to convert from any (known) pixelformat
  to BGR24, RGB24, YUV420 and YVU420.
  .
  libv4l1 offers the (deprecated) v4l1 API on top of v4l2 devices, 
independent
  of the drivers for those devices supporting v4l1 compatibility (which many
  v4l2 drivers do not).
  .
  libv4l2 offers the v4l2 API on top of v4l2 devices, while adding for the
  application transparent libv4lconvert conversion where necessary.
  .
  This package contains the shared libraries.
Homepage: http://people.atrpms.net/~hdegoede/
Bugs: https://bugs.launchpad.net/ubuntu/+filebug
Origin: Ubuntu
Task: ubuntu-desktop, edubuntu-desktop, xubuntu-desktop, mobile-mid, 
mobile-netbook-remix

thomas@AMD64:~$

Thomas

