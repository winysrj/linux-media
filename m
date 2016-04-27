Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35185 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbcD0G5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 02:57:55 -0400
Received: by mail-wm0-f68.google.com with SMTP id e201so9899189wme.2
        for <linux-media@vger.kernel.org>; Tue, 26 Apr 2016 23:57:54 -0700 (PDT)
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
To: Sebastian Reichel <sre@kernel.org>, pavel@ucw.cz
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth> <572048AC.7050700@gmail.com>
Cc: sakari.ailus@iki.fi, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <572062EF.7060502@gmail.com>
Date: Wed, 27 Apr 2016 09:57:51 +0300
MIME-Version: 1.0
In-Reply-To: <572048AC.7050700@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 27.04.2016 08:05, Ivaylo Dimitrov wrote:
> Hi,
>
> On 27.04.2016 06:08, Sebastian Reichel wrote:
>> Hi,
>>
>> On Mon, Apr 25, 2016 at 12:08:00AM +0300, Ivaylo Dimitrov wrote:
>>> Those patch series make cameras on Nokia N900 partially working.
>>> Some more patches are needed, but I've already sent them for
>>> upstreaming so they are not part of the series:
>>>
>>> https://lkml.org/lkml/2016/4/16/14
>>> https://lkml.org/lkml/2016/4/16/33
>>>
>>> As omap3isp driver supports only one endpoint on ccp2 interface,
>>> but cameras on N900 require different strobe settings, so far
>>> it is not possible to have both cameras correctly working with
>>> the same board DTS. DTS patch in the series has the correct
>>> settings for the front camera. This is a problem still to be
>>> solved.
>>>
>>> The needed pipeline could be made with:
>>>
>>> media-ctl -r
>>> media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2 [1]'
>>> media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
>>> media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
>>> media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
>>> media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
>>> media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'
>>> media-ctl -V '"vs6555 pixel array 2-0010":0 [SGRBG10/648x488
>>> (0,0)/648x488 (0,0)/648x488]'
>>> media-ctl -V '"vs6555 binner 2-0010":1 [SGRBG10/648x488 (0,0)/648x488
>>> (0,0)/648x488]'
>>> media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 648x488]'
>>> media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 648x488]'
>>> media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 648x488]'
>>> media-ctl -V '"OMAP3 ISP preview":1 [UYVY 648x488]'
>>> media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 656x488]'
>>>
>>> and tested with:
>>>
>>> mplayer -tv
>>> driver=v4l2:width=656:height=488:outfmt=uyvy:device=/dev/video6 -vo
>>> xv -vf screenshot tv://
>>
>> 4.6-rc4 + twl regulator patch + the patches mentioned above + this
>> patchset (I put everything together here [0]) do _not_ work for me.
>> The error matches what I have seen when I was working on it: No
>> image data seems to be received by the ISP. For example there are
>> no related IRQs:
>>
>> root@n900:~# cat /proc/interrupts  | grep ISP
>>   40:          0      INTC  24 Edge      480bd400.mmu, OMAP3 ISP
>>
>> I tested with mpv and yavta (yavta --capture=8 --pause --skip 0
>> --format UYVY --size 656x488 /dev/video6)
>>
>> [0]
>> https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/log/?h=n900-camera-ivo
>>
>>
>
> Ok, going to diff with my tree to see what I have missed to send in the
> patchset
>

Now, that's getting weird.

I cloned n900-camera-ivo, copied rx51_defconfig from my tree, added:

CONFIG_VIDEO_SMIAREGS=m
CONFIG_VIDEO_ET8EK8=m
CONFIG_VIDEO_BUS_SWITCH=m

to it, make mrproper, built the kernel using rx51_defconfig and made 
initrd for rescueos, so to be sure that maemo5 did not influence cameras 
somehow.

Booted the device with flasher3.5:

sudo flasher-3.5 -k zImage -n ramfs -l -b"rootdelay root=/dev/ram0 
mtdoops.mtddev=log log_buf_len=1M"

ivo@ivo-H81M-S2PV:~/maemo/rescueos$ sudo ifconfig usb0 192.168.2.14
ivo@ivo-H81M-S2PV:~/maemo/rescueos$ telnet 192.168.2.15
Trying 192.168.2.15...
Connected to 192.168.2.15.
Escape character is '^]'.

rescueos login: root
Password:
~$ modprobe smiapp
~$ cd /camera/
/camera$ export LD_LIBRARY_PATH=./
/camera$ ./media-ctl -r
/camera$ ./media-ctl -l '"vs6555 binner 2-0010":1 -> 
"video-bus-switch":2 [1]'
/camera$ ./media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
/camera$ ./media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
/camera$ ./media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
/camera$ ./media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
/camera$ ./media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer 
output":0 [1]'
/camera$ ./media-ctl -V '"vs6555 pixel array 2-0010":0 [SGRBG10/648x488 
(0,0)/648x488 (0,0)/648x488]'
/camera$ ./media-ctl -V '"vs6555 binner 2-0010":1 [SGRBG10/648x488 
(0,0)/648x488 (0,0)/648x488]'
/camera$ ./media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 648x488]'
/camera$ ./media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 648x488]'
/camera$ ./media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 648x488]'
/camera$ ./media-ctl -V '"OMAP3 ISP preview":1 [UYVY 648x488]'
/camera$ ./media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 656x488]'
/camera$ ./yavta --capture=8 --pause --skip 0 --format UYVY --size 
656x488 /dev/video6
Device /dev/video6 opened.
Device `OMAP3 ISP resizer output' on `media' is a video capture device.
Video format set: UYVY (59565955) 656x488 (stride 1312) buffer size 640256
Video format: UYVY (59565955) 656x488 (stride 1312) buffer size 640256
8 buffers requested.
length: 640256 offset: 0 timestamp type: monotonic
Buffer 0 mapped at address 0xb6de5000.
length: 640256 offset: 643072 timestamp type: monotonic
Buffer 1 mapped at address 0xb6d48000.
length: 640256 offset: 1286144 timestamp type: monotonic
Buffer 2 mapped at address 0xb6cab000.
length: 640256 offset: 1929216 timestamp type: monotonic
Buffer 3 mapped at address 0xb6c0e000.
length: 640256 offset: 2572288 timestamp type: monotonic
Buffer 4 mapped at address 0xb6b71000.
length: 640256 offset: 3215360 timestamp type: monotonic
Buffer 5 mapped at address 0xb6ad4000.
length: 640256 offset: 3858432 timestamp type: monotonic
Buffer 6 mapped at address 0xb6a37000.
length: 640256 offset: 4501504 timestamp type: monotonic
Buffer 7 mapped at address 0xb699a000.
Press enter to start capture

0 (0) [-] 0 640256 bytes 211.742779 211.742932 28.518 fps
1 (1) [-] 1 640256 bytes 211.808148 211.808331 15.298 fps
2 (2) [-] 2 640256 bytes 211.873547 211.873669 15.291 fps
3 (3) [-] 3 640256 bytes 211.938946 211.939099 15.291 fps
4 (4) [-] 4 640256 bytes 212.004345 212.004498 15.291 fps
5 (5) [-] 5 640256 bytes 212.069714 212.069836 15.298 fps
6 (6) [-] 6 640256 bytes 212.135113 212.135296 15.291 fps
7 (7) [-] 7 640256 bytes 212.200512 212.200665 15.291 fps
Captured 8 frames in 0.492950 seconds (16.228812 fps, 10390594.234990 B/s).
8 buffers released.

/camera$ cat /proc/interrupts | grep ISP
  40:         30      INTC  24 Edge      480bd400.mmu, OMAP3 ISP
  41:          0      INTC  25 Edge      OMAP DISPC
/camera$ uname -a
Linux rescueos 4.6.0-rc4+ #1 PREEMPT Wed Apr 27 08:55:02 EEST 2016 
armv7l GNU/Linux

I you want to try it, zImage and initrd are on 
http://46.249.74.23/linux/camera-n900/

Please, Sebastian and Pavel, make sure you're not using some development 
devices, old board versions need VAUX3 enabled as well, and this is not 
supported in the $subject patchset. I guess you may try to make VAUX3 
always-on in board DTS if that's the case, but I've never tested that, 
my device is a production one.

Thanks,
Ivo

