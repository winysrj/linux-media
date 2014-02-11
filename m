Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:46859 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbaBKQCY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 11:02:24 -0500
Date: Tue, 11 Feb 2014 17:02:23 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: OMAP3 ISP capabilities (fwd)
Message-ID: <alpine.DEB.2.01.1402111650330.6474@pmeerw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

trying (3) below and hitting

[ 6241.536071] WARNING: at drivers/media/v4l2-core/v4l2-subdev.c:424 v4l2_subdev_link_validate_get_format+0x90/0xa8()
[ 6241.573150] Driver bug! Wrong media entity type 65536, entity OMAP3 ISP resizer input
[ 6241.595153] [<c0011cdc>] (unwind_backtrace+0x0/0xe0) from [<c002ed28>] (warn_slowpath_common+0x4c/0x64)
[ 6241.605651] [<c002ed28>] (warn_slowpath_common+0x4c/0x64) from [<c002edc0>] (warn_slowpath_fmt+0x2c/0x3c)
[ 6241.615997] [<c002edc0>] (warn_slowpath_fmt+0x2c/0x3c) from [<c027e2e4>] (v4l2_subdev_link_validate_get_format+0x90/0xa8)
[ 6241.632751] [<c027e2e4>] (v4l2_subdev_link_validate_get_format+0x90/0xa8) from [<c027e314>] (v4l2_subdev_link_validate+0x18)
[ 6241.645324] [<c027e314>] (v4l2_subdev_link_validate+0x18/0xac) from [<c0272954>] (media_entity_pipeline_start+0xc8/0x170)
[ 6241.657012] [<c0272954>] (media_entity_pipeline_start+0xc8/0x170) from [<c0285820>] (isp_video_streamon+0xa4/0x314)
[ 6241.672027] [<c0285820>] (isp_video_streamon+0xa4/0x314) from [<c02748ec>] (v4l_streamon+0x18/0x1c)
[ 6241.681884] [<c02748ec>] (v4l_streamon+0x18/0x1c) from [<c02779c0>] (__video_do_ioctl+0x1c4/0x2e4)
[ 6241.691558] [<c02779c0>] (__video_do_ioctl+0x1c4/0x2e4) from [<c0277d84>] (video_usercopy+0x2a4/0x3e0)
[ 6241.701507] [<c0277d84>] (video_usercopy+0x2a4/0x3e0) from [<c02730e0>] (v4l2_ioctl+0x6c/0x110)
[ 6241.715240] [<c02730e0>] (v4l2_ioctl+0x6c/0x110) from [<c00c36ec>] (do_vfs_ioctl+0x548/0x5b8)
[ 6241.724792] [<c00c36ec>] (do_vfs_ioctl+0x548/0x5b8) from [<c00c3794>] (sys_ioctl+0x38/0x54)
[ 6241.733795] [<c00c3794>] (sys_ioctl+0x38/0x54) from [<c000d420>] (ret_fast_syscall+0x0/0x30)
[ 6241.743438] ---[ end trace 3ce601d6bddf2d7e ]---

pipeline is

media-ctl -r
media-ctl -l '"OMAP3 ISP resizer input":0->"OMAP3 ISP resizer":0[1]'
media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
media-ctl -V '"OMAP3 ISP resizer":0 [YUYV2X8 640x480]'
media-ctl -V '"OMAP3 ISP resizer":1 [YUYV2X8 320x240]'

I'm opening /dev/video5 and /dev/video6, do S_FMT on both as VIDEO_OUTPUT 
and VIDEO_CAPTURE, respectively, configure buffers and then STREAMON --
bang!

regards, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)

---------- Forwarded message ----------
Date: Tue, 11 Feb 2014 15:54:00 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: OMAP3 ISP capabilities

Hello Laurent,

some quick question about the OMAP3 ISP pipeline capabilities:

(1) can the OMAP3 ISP CCDC output concurrently to memory AND the resizer 
in YUV mode? I think the answer is no due to hardware limitation

(2) in RAW mode, I think it should be possible to connect pad 1 of the 
OMAP3 ISP CCDC to CCDC output and pad 2 to the ISP preview and 
subsequently to the resizer? so two stream can be read concurrently from 
video2 and video6?

(3) it should be possible to use the ISP resizer input / output 
(memory-to-memory) independently; it there any example code doing this?

thanks, regards, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
