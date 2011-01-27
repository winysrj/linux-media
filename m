Return-path: <mchehab@pedra>
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:38750 "EHLO
	homiemail-a19.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751512Ab1A0Wpn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 17:45:43 -0500
Received: from homiemail-a19.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a19.g.dreamhost.com (Postfix) with ESMTP id 212D060406C
	for <linux-media@vger.kernel.org>; Thu, 27 Jan 2011 14:45:43 -0800 (PST)
Received: from [10.0.1.35] (s64-180-61-141.bc.hsia.telus.net [64.180.61.141])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: neil@gumstix.com)
	by homiemail-a19.g.dreamhost.com (Postfix) with ESMTPSA id BE429604061
	for <linux-media@vger.kernel.org>; Thu, 27 Jan 2011 14:45:42 -0800 (PST)
Message-ID: <4D41F54C.2030804@gumstix.com>
Date: Thu, 27 Jan 2011 14:44:28 -0800
From: Neil MacMunn <neil@gumstix.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: omap3-isp segfault
References: <4D4076C3.4080201@gumstix.com> <4D40CDB3.7090106@gumstix.com> <201101271328.05891.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101271328.05891.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 11-01-27 04:28 AM, Laurent Pinchart wrote:
> Hi again,
>
> As you're using an MT9V032 sensor, I can help you with the pipeline setup. You
> can run the following commands to capture 5 raw images.
>
> ./media-ctl -r -l '"mt9v032 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> ./media-ctl -f '"mt9v032 2-005c":0[SGRBG10 752x480], "OMAP3 ISP CCDC":1[SGRBG10 752x480]'
>
> ./yavta -p -f SGRBG10 -s 752x480 -n 4 --capture=5 --skip 4 -F $(./media-ctl -e "OMAP3 ISP CCDC output")
>

When I use media-ctl the pipeline gets configured properly. I can 
generate graphs before and after and see the pipeline change. However, 
my system hangs when I attempt to use yavta. I've also tried outputting 
to video4.

    # ./media-ctl -p
    Opening media device /dev/media0
    Enumerating entities
    Found 16 entities
    Enumerating pads and links
    Device topology
    - entity 1: OMAP3 ISP CCP2 (2 pads, 1 link)
                 type V4L2 subdev subtype Unknown
                 device node name /dev/v4l-subdev0
         pad0: Input [SGRBG10 4096x4096]
         pad1: Output [SGRBG10 4096x4096]
             -> 'OMAP3 ISP CCDC':pad0 []

    - entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
                 type Node subtype V4L
                 device node name /dev/video0
         pad0: Output
             -> 'OMAP3 ISP CCP2':pad0 []

    - entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
                 type V4L2 subdev subtype Unknown
                 device node name /dev/v4l-subdev1
         pad0: Input [SGRBG10 4096x4096]
         pad1: Output [SGRBG10 4096x4096]
             -> 'OMAP3 ISP CSI2a output':pad0 []
             -> 'OMAP3 ISP CCDC':pad0 []

    - entity 4: OMAP3 ISP CSI2a output (1 pad, 0 link)
                 type Node subtype V4L
                 device node name /dev/video1
         pad0: Input

    - entity 5: OMAP3 ISP CCDC (3 pads, 6 links)
                 type V4L2 subdev subtype Unknown
                 device node name /dev/v4l-subdev2
         pad0: Input [SGRBG10 752x480]
         pad1: Output [SGRBG10 752x480]
             -> 'OMAP3 ISP CCDC output':pad0 []
             -> 'OMAP3 ISP resizer':pad0 []
         pad2: Output [SGRBG10 752x479]
             -> 'OMAP3 ISP preview':pad0 [ACTIVE]
             -> 'OMAP3 ISP AEWB':pad0 [IMMUTABLE,ACTIVE]
             -> 'OMAP3 ISP AF':pad0 [IMMUTABLE,ACTIVE]
             -> 'OMAP3 ISP histogram':pad0 [IMMUTABLE,ACTIVE]

    - entity 6: OMAP3 ISP CCDC output (1 pad, 0 link)
                 type Node subtype V4L
                 device node name /dev/video2
         pad0: Input

    - entity 7: OMAP3 ISP preview (2 pads, 2 links)
                 type V4L2 subdev subtype Unknown
                 device node name /dev/v4l-subdev3
         pad0: Input [SGRBG10 752x479]
         pad1: Output [YUYV 734x471]
             -> 'OMAP3 ISP preview output':pad0 [ACTIVE]
             -> 'OMAP3 ISP resizer':pad0 []

    - entity 8: OMAP3 ISP preview input (1 pad, 1 link)
                 type Node subtype V4L
                 device node name /dev/video3
         pad0: Output
             -> 'OMAP3 ISP preview':pad0 []

    - entity 9: OMAP3 ISP preview output (1 pad, 0 link)
                 type Node subtype V4L
                 device node name /dev/video4
         pad0: Input

    - entity 10: OMAP3 ISP resizer (2 pads, 1 link)
                  type V4L2 subdev subtype Unknown
                  device node name /dev/v4l-subdev4
         pad0: Input [YUYV 4095x4095 (0,0)/4094x4082]
         pad1: Output [YUYV 3312x4095]
             -> 'OMAP3 ISP resizer output':pad0 []

    - entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
                  type Node subtype V4L
                  device node name /dev/video5
         pad0: Output
             -> 'OMAP3 ISP resizer':pad0 []

    - entity 12: OMAP3 ISP resizer output (1 pad, 0 link)
                  type Node subtype V4L
                  device node name /dev/video6
         pad0: Input

    - entity 13: OMAP3 ISP AEWB (1 pad, 0 link)
                  type V4L2 subdev subtype Unknown
                  device node name /dev/v4l-subdev5
         pad0: Input

    - entity 14: OMAP3 ISP AF (1 pad, 0 link)
                  type V4L2 subdev subtype Unknown
                  device node name /dev/v4l-subdev6
         pad0: Input

    - entity 15: OMAP3 ISP histogram (1 pad, 0 link)
                  type V4L2 subdev subtype Unknown
                  device node name /dev/v4l-subdev7
         pad0: Input

    - entity 16: mt9v032 3-005c (1 pad, 1 link)
                  type V4L2 subdev subtype Unknown
                  device node name /dev/v4l-subdev8
         pad0: Output [SGRBG10 752x480 (2,10)/752x480]
             -> 'OMAP3 ISP CCDC':pad0 [ACTIVE]


      # ./media-ctl -r -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1],
    "OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP
    preview":1->"OMAP3 ISP preview output":0[1]'
      Resetting all links to inactive
      Setting up link 16:0 -> 5:0 [1]
      Setting up link 5:2 -> 7:0 [1]
      Setting up link 7:1 -> 9:0 [1]

      # ./media-ctl -f '"mt9v032 3-005c":0[SGRBG10 752x480], "OMAP3 ISP
    CCDC":2[SGRBG10 752x480], "OMAP3 ISP preview":1[YUYV 752x480]'
      Setting up format SGRBG10 752x480 on pad mt9v032 3-005c/0
      Format set: SGRBG10 752x480
      Setting up format SGRBG10 752x480 on pad OMAP3 ISP CCDC/0
      Format set: SGRBG10 752x480
      Setting up format SGRBG10 752x480 on pad OMAP3 ISP CCDC/2
      Format set: SGRBG10 752x479
      Setting up format SGRBG10 752x479 on pad OMAP3 ISP preview/0
      Format set: SGRBG10 752x479
      Setting up format SGRBG10 752x479 on pad OMAP3 ISP AEWB/0
      Unable to set format: Invalid argument (-22)
      Setting up format SGRBG10 752x479 on pad OMAP3 ISP AF/0
      Unable to set format: Invalid argument (-22)
      Setting up format SGRBG10 752x479 on pad OMAP3 ISP histogram/0
      Unable to set format: Invalid argument (-22)
      Setting up format YUYV 752x480 on pad OMAP3 ISP preview/1
      Format set: YUYV 734x471

      # gst-launch v4l2src device=/dev/video4 ! xvimagesink
      Setting pipeline to PAUSED ...
      ------------[ cut here ]------------
      WARNING: at drivers/media/video/isp/ispvideo.c:157
    isp_video_try_format+0x54/0xd0()
      Modules linked in: ipv6 libertas_sdio libertas lib80211 option
    ads7846 usb_wwan usbserial
      [<c003a634>] (unwind_backtrace+0x0/0xec) from [<c005db88>]
    (warn_slowpath_common+0x4c/0x64)
      [<c005db88>] (warn_slowpath_common+0x4c/0x64) from [<c005dbbc>]
    (warn_slowpath_null+0x1c/0x24)
      [<c005dbbc>] (warn_slowpath_null+0x1c/0x24) from [<c02cbae4>]
    (isp_video_try_format+0x54/0xd0)
      [<c02cbae4>] (isp_video_try_format+0x54/0xd0) from [<c02bcf7c>]
    (__video_do_ioctl+0xd14/0x3e64)
      [<c02bcf7c>] (__video_do_ioctl+0xd14/0x3e64) from [<c02bbf88>]
    (__video_usercopy+0x2d0/0x400)
      [<c02bbf88>] (__video_usercopy+0x2d0/0x400) from [<c02bb074>]
    (v4l2_ioctl+0x7c/0x12c)
      [<c02bb074>] (v4l2_ioctl+0x7c/0x12c) from [<c00ce844>]
    (do_vfs_ioctl+0x4c8/0x534)
      [<c00ce844>] (do_vfs_ioctl+0x4c8/0x534) from [<c00ce8e8>]
    (sys_ioctl+0x38/0x5c)
      [<c00ce8e8>] (sys_ioctl+0x38/0x5c) from [<c0035ec0>]
    (ret_fast_syscall+0x0/0x30)
      ---[ end trace 3916808675e46fff ]---
      ------------[ cut here ]------------
      ERROR: Pipeline doesn't want to pause.
      ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
    Device '/dev/video4' cannot capture in the specified format
      Additional debug info:
      gstv4l2object.c(1971): gst_v4l2_object_set_format ():
    /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
      Tried to capture in YU12, but device returned format YUYV
      Setting pipeline to NULL ...
      Freeing pipeline ...


Does anybody know how I can capture images from the camera? From 
previous posts it appears that I'm not the first to go through this process.

Thanks. Neil


