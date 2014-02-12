Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:39074 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaBLPUB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 10:20:01 -0500
Date: Wed, 12 Feb 2014 16:19:55 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: OMAP3 ISP capabilities, resizer
Message-ID: <alpine.DEB.2.01.1402121601100.6337@pmeerw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

some more findings:

* the driver bug seen below was observed with kernel 3.7 and is already 
fixed in more recent kernels, likely with commit 864a121274,
[media] v4l: Don't warn during link validation when encountering a V4L2 
devnode

* there still is a a confusing warning:
  omap3isp omap3isp: can't find source, failing now
which may be addressed by the patch here https://linuxtv.org/patch/15200/,
but has not been applied

* I have a test program, http://pmeerw.net/scaler.c, which exercises the 
OMAP3 ISP resizer standalone with the pipeline given below; it crashes the 
system quite reliably on 3.7 and recent kernels :(

the reason for the crash is that the ISP resizer can still be busy and 
doesn't like to be turned off then; a little sleep before 
omap3isp_sbl_disable() helps (or waiting for the ISP resize to become 
idle, see the patch below)

I'm not sure what omap3isp_module_sync_idle() is supposed to do, it 
immediately returns since we are in SINGLESHOT mode and 
isp_pipeline_ready() is false

with below patch I am happily resizing...

// snip, RFC
From: Peter Meerwald <p.meerwald@bct-electronic.com>
Date: Wed, 12 Feb 2014 15:59:20 +0100
Subject: [PATCH] omap3isp: Wait for resizer to become idle before 
disabling

---
 drivers/media/platform/omap3isp/ispresizer.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/platform/omap3isp/ispresizer.c 
b/drivers/media/platform/omap3isp/ispresizer.c
index d11fb26..fea98f7 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1145,6 +1145,7 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
        struct isp_video *video_out = &res->video_out;
        struct isp_device *isp = to_isp_device(res);
        struct device *dev = to_device(res);
+       unsigned long timeout = 0;
 
        if (res->state == ISP_PIPELINE_STREAM_STOPPED) {
                if (enable == ISP_PIPELINE_STREAM_STOPPED)
@@ -1176,6 +1177,15 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
                if (omap3isp_module_sync_idle(&sd->entity, &res->wait,
                                              &res->stopping))
                        dev_dbg(dev, "%s: module stop timeout.\n", sd->name);
+
+               while (omap3isp_resizer_busy(res)) {
+                       if (timeout++ > 1000) {
+                               dev_alert(isp->dev, "ISP resizer does not become idle\n");
+                               return -ETIMEDOUT;
+                       }
+                       udelay(100);
+               }
+
                omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_RESIZER_READ |
                                OMAP3_ISP_SBL_RESIZER_WRITE);
                omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_RESIZER);
// snip

regards, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)

---------- Forwarded message ----------
Date: Tue, 11 Feb 2014 17:02:23 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: OMAP3 ISP capabilities (fwd)

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
