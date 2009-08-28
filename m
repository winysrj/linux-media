Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:16976 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZH1Skh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 14:40:37 -0400
Received: by fg-out-1718.google.com with SMTP id 22so76643fge.1
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2009 11:40:38 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 28 Aug 2009 21:40:38 +0300
Message-ID: <880dece00908281140r16385c1fr476b18f2fcfe3c1b@mail.gmail.com>
Subject: Using MSI StarCam 370i Webcam with Kubuntu Linux
From: Dotan Cohen <dotancohen@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have the MSI StarCam 370i Webcam and I have trying to use it with
Kubuntu Linux 9.04 Jaunty. According to this page, "The StarCam 370i
is compliant with UVC, USB video class":
http://gadgets.softpedia.com/gadgets/Computer-Peripherals/The-MSI-StarCam-370i-3105.html

According to the Linux UVC driver and tools download page, "Linux
2.6.26 and newer includes the Linux UVC driver natively" which is nice
as I am on a higher version:
$ uname -r
2.6.28-15-generic

However, plugging in the webcam and testing with camorama, cheese, and
luvcview led me to no results:

jaunty2@laptop:~$ luvcview -f yuv
luvcview 0.2.4

SDL information:
 Video driver: x11
 A window manager is available
Device information:
 Device path:  /dev/video0
Stream settings:
ERROR: Requested frame format YUYV is not available and no fallback
format was found.
 Init v4L2 failed !! exit fatal
jaunty2@laptop:~$ luvcview -f uyvy
luvcview 0.2.4

SDL information:
 Video driver: x11
 A window manager is available
Device information:
 Device path:  /dev/video0
Stream settings:
ERROR: Requested frame format UYVY is not available and no fallback
format was found.
 Init v4L2 failed !! exit fatal
jaunty2@laptop:~$ luvcview
luvcview 0.2.4

SDL information:
 Video driver: x11
 A window manager is available
Device information:
 Device path:  /dev/video0
Stream settings:
ERROR: Requested frame format MJPG is not available and no fallback
format was found.
 Init v4L2 failed !! exit fatal


Some more details:

jaunty2@laptop:~$ ls /dev/vi*
/dev/video0
jaunty2@laptop:~$ dmesg | tail
[ 2777.811972] sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers
v1:1.47pre49
[ 2777.814989] usb 2-1: SN9C105 PC Camera Controller detected (vid:pid
0x0C45:0x60FC)
[ 2777.842123] usb 2-1: HV7131R image sensor detected
[ 2778.185108] usb 2-1: Initialization succeeded
[ 2778.185220] usb 2-1: V4L2 device registered as /dev/video0
[ 2778.185225] usb 2-1: Optional device control through 'sysfs'
interface disabled
[ 2778.185283] usbcore: registered new interface driver sn9c102
[ 2778.216691] usbcore: registered new interface driver snd-usb-audio
[ 2778.218738] usbcore: registered new interface driver sonixj
[ 2778.218745] sonixj: registered
jaunty2@laptop:~$ lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 005 Device 002: ID 413c:8126 Dell Computer Corp. Wireless 355 Bluetooth
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 004: ID 045e:0040 Microsoft Corp. Wheel Mouse Optical
Bus 004 Device 003: ID 045e:00db Microsoft Corp. Natural Ergonomic
Keyboard 4000 V1.0
Bus 004 Device 002: ID 05e3:0604 Genesys Logic, Inc. USB 1.1 Hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 002: ID 0c45:60fc Microdia PC Camera with Mic (SN9C105)
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
jaunty2@laptop:~$



Anything missing? What should I do? Thanks in advance!



-- 
Dotan Cohen

http://what-is-what.com
http://gibberish.co.il
