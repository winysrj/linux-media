Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34595 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab0FYKBn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jun 2010 06:01:43 -0400
Received: by qyk38 with SMTP id 38so508422qyk.19
        for <linux-media@vger.kernel.org>; Fri, 25 Jun 2010 03:01:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006251132.52431.laurent.pinchart@ideasonboard.com>
References: <AANLkTilsMviOOwo1IWpyfNkd5jeSMU9SozqvgcamBdF_@mail.gmail.com>
	<201006251132.52431.laurent.pinchart@ideasonboard.com>
Date: Fri, 25 Jun 2010 18:01:42 +0800
Message-ID: <AANLkTikn3OCc7V2IiwQaetoVmt1flFaVN5zHQz_7S_ri@mail.gmail.com>
Subject: Re: Question on newly build uvcvideo.ko
From: Samuel Xu <samuel.xu.tech@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One correction: After make and make install, uvcvideo module can't
auto loaded any more. I must manually "insmod uvcvideo.ko" to load it.

Here is lsmod result, I never have chance to make uvcvideo module used
bit to 1 :(
[root@user-desktop uvc]# lsmod
Module                  Size  Used by
uvcvideo               46182  0
rt2860sta             406917  1
battery                 7968  0

After 2 questions, there is dmesg from uvcvideo after my manually
insmod, any idea?
Another question is: If newest v4l code tree has been advanced much
than src tree inside 2.6.33 kernel, which v4l src label is nearest
from src tree inside 2.6.33 kernel?
3rdd question is: if I want to build v4l driver from src inside 2.6.33
kernel directly. How should I do? (I tried to make menuconfig and make
modules from a clean kernel, while insmod the newly build uvcvideo.ko
reports: insmod: error inserting './uvcvideo.ko': -1 Invalid module
format

[   78.446109] uvcvideo: Found UVC 1.00 device CNF7129 (04f2:b071)
[   78.462540] ------------[ cut here ]------------
[   78.462569] WARNING: at drivers/media/video/v4l2-dev.c:420
__video_register_device+0x44/0x3d7()
[   78.462581] Hardware name: 1000H
[   78.462588] Modules linked in: uvcvideo(+) rt2860sta(C) battery
[   78.462616] Pid: 690, comm: insmod Tainted: G         C
2.6.33.3-11.1-netbook #1
[   78.462626] Call Trace:
[   78.462647]  [<c1030944>] warn_slowpath_common+0x66/0x7d
[   78.462665]  [<c12f89ad>] ? __video_register_device+0x44/0x3d7
[   78.462682]  [<c1030968>] warn_slowpath_null+0xd/0x10
[   78.462697]  [<c12f89ad>] __video_register_device+0x44/0x3d7
[   78.462714]  [<c12f8d56>] video_register_device+0xa/0xc
[   78.462744]  [<f82e50fc>] uvc_probe+0x9c0/0xb26 [uvcvideo]
[   78.462763]  [<c12c1e35>] usb_probe_interface+0xe1/0x136
[   78.462782]  [<c11fff7b>] driver_probe_device+0x87/0x107
[   78.462799]  [<c120003e>] __driver_attach+0x43/0x5f
[   78.462815]  [<c11ff907>] bus_for_each_dev+0x3e/0x69
[   78.462831]  [<c11ffe46>] driver_attach+0x14/0x16
[   78.462846]  [<c11ffffb>] ? __driver_attach+0x0/0x5f
[   78.462862]  [<c11ff3aa>] bus_add_driver+0x105/0x235
[   78.462879]  [<c1200280>] driver_register+0x7a/0xe1
[   78.462894]  [<c12c1bf6>] usb_register_driver+0x67/0x104
[   78.462919]  [<f82c2000>] ? uvc_init+0x0/0x71 [uvcvideo]
[   78.462942]  [<f82c2059>] uvc_init+0x59/0x71 [uvcvideo]
[   78.462958]  [<c100113a>] do_one_initcall+0x4d/0x132
[   78.462977]  [<c105a1b6>] sys_init_module+0xa7/0x1db
[   78.462992]  [<c10027d0>] sysenter_do_call+0x12/0x26
[   78.463051] ---[ end trace a67861dcf94e1e3a ]---
[   78.463064] uvcvideo: Failed to register video device (-22).
[   78.463758] usbcore: registered new interface driver uvcvideo
[   78.463774] USB Video Class driver (v0.1.0)

2010/6/25 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Samuel,
>
> On Friday 25 June 2010 11:25:13 Samuel Xu wrote:
>> HI:
>> I am using a ASUS netbook with a USB 2.0 web camera (04f2:b071 Chicony
>> Electronics Co., Ltd 2.0M UVC WebCam / CNF7129)
>> I installed Linux, and the default uvcvideo.ko works (I tried
>> gstreamer-properties, which can find CNF7129 device and show correct
>> video camera test).
>> While I want to try the newest V4L2 build, So I follow
>> http://www.linuxtv.org/wiki to:
>> 1: get the src code v4l-dvb-9652f85e688a.tar.gz
>> 2: make and make install on my netbook.
>> 3: reboot system
>>
>> lsmod shows me uvcvideo module has been loaded, while
>> gstreamer-properties can't find CNF7129 device, so I can't use this
>> USB 2.0 web camera now.
>
> Can you look at the kernel log (dmesg) and report messages printed by the
> uvcvideo driver ?
>
>> I also tried re-install original workable Linux, and make v4l again.
>> Then copy the newly build uvcvideo.ko to
>> /lib/modules/2.6.33.xx/kernel/drivers/media/video/uvc/
>> module still can be found from lsmod, while gstreamer-properties still
>> can't find CNF7129 device.
>
> That's to be expected, as the new v4l-dvb build you installed replaced the
> core v4l modules (such as videodev.ko), and the new version isn't compatible
> with the uvcvideo driver that came with your kernel.
>
>> Does it mean I must do some code modification for 04f2:b071 device
>> before I build v4l driver?
>
> In theory, no.
>
> --
> Regards,
>
> Laurent Pinchart
>
