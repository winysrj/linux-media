Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33630 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbdDBEsS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 2 Apr 2017 00:48:18 -0400
Received: by mail-qt0-f194.google.com with SMTP id r45so15151203qte.0
        for <linux-media@vger.kernel.org>; Sat, 01 Apr 2017 21:48:18 -0700 (PDT)
Date: Sun, 2 Apr 2017 00:48:15 -0400
From: Kevin Wern <kevin.m.wern@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        bcm-kernel-feedback-list@broadcom.com, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] staging: media/platform/bcm2835: remove gstreamer workaround
Message-ID: <20170402044815.GA23614@kwern-HP-Pavilion-dv5-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gstreamer's v4l2src reacted poorly to certain outputs from the bcm2835
video driver's ioctl ops function vidioc_enum_framesizes, so a
workaround was created that could be activated by user input. This
workaround would replace the driver's ioctl ops struct with another,
similar struct--only with no function pointed to by
vidioc_enum_framesizes. With no response, gstreamer would attempt to
continue with some default settings that happened to work better.

However, this bug has been fixed in gstreamer since 2014, so we
shouldn't include this workaround in the stable version of the driver.

Signed-off-by: Kevin Wern <kevin.m.wern@gmail.com>
---
 drivers/staging/media/platform/bcm2835/TODO        |  5 --
 .../media/platform/bcm2835/bcm2835-camera.c        | 59 ----------------------
 2 files changed, 64 deletions(-)

diff --git a/drivers/staging/media/platform/bcm2835/TODO b/drivers/staging/media/platform/bcm2835/TODO
index 61a5099..0ab9e88 100644
--- a/drivers/staging/media/platform/bcm2835/TODO
+++ b/drivers/staging/media/platform/bcm2835/TODO
@@ -32,8 +32,3 @@ We should have VCHI create a platform device once it's initialized,
 and have this driver bind to it, so that we automatically load the
 v4l2 module after VCHI loads.
 
-5) Drop the gstreamer workaround.
-
-This was a temporary workaround for a bug that was fixed mid-2014, and
-we should remove it before stabilizing the driver.
-
diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
index ca15a69..6a50862 100644
--- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
@@ -66,19 +66,6 @@ MODULE_PARM_DESC(max_video_width, "Threshold for video mode");
 module_param(max_video_height, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(max_video_height, "Threshold for video mode");
 
-/* Gstreamer bug https://bugzilla.gnome.org/show_bug.cgi?id=726521
- * v4l2src does bad (and actually wrong) things when the vidioc_enum_framesizes
- * function says type V4L2_FRMSIZE_TYPE_STEPWISE, which we do by default.
- * It's happier if we just don't say anything at all, when it then
- * sets up a load of defaults that it thinks might work.
- * If gst_v4l2src_is_broken is non-zero, then we remove the function from
- * our function table list (actually switch to an alternate set, but same
- * result).
- */
-static int gst_v4l2src_is_broken;
-module_param(gst_v4l2src_is_broken, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
-MODULE_PARM_DESC(gst_v4l2src_is_broken, "If non-zero, enable workaround for Gstreamer");
-
 /* global device data array */
 static struct bm2835_mmal_dev *gdev[MAX_BCM2835_CAMERAS];
 
@@ -1456,47 +1443,6 @@ static const struct v4l2_ioctl_ops camera0_ioctl_ops = {
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-static const struct v4l2_ioctl_ops camera0_ioctl_ops_gstreamer = {
-	/* overlay */
-	.vidioc_enum_fmt_vid_overlay = vidioc_enum_fmt_vid_overlay,
-	.vidioc_g_fmt_vid_overlay = vidioc_g_fmt_vid_overlay,
-	.vidioc_try_fmt_vid_overlay = vidioc_try_fmt_vid_overlay,
-	.vidioc_s_fmt_vid_overlay = vidioc_s_fmt_vid_overlay,
-	.vidioc_overlay = vidioc_overlay,
-	.vidioc_g_fbuf = vidioc_g_fbuf,
-
-	/* inputs */
-	.vidioc_enum_input = vidioc_enum_input,
-	.vidioc_g_input = vidioc_g_input,
-	.vidioc_s_input = vidioc_s_input,
-
-	/* capture */
-	.vidioc_querycap = vidioc_querycap,
-	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-
-	/* buffer management */
-	.vidioc_reqbufs = vb2_ioctl_reqbufs,
-	.vidioc_create_bufs = vb2_ioctl_create_bufs,
-	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
-	.vidioc_querybuf = vb2_ioctl_querybuf,
-	.vidioc_qbuf = vb2_ioctl_qbuf,
-	.vidioc_dqbuf = vb2_ioctl_dqbuf,
-	/* Remove this function ptr to fix gstreamer bug
-	.vidioc_enum_framesizes = vidioc_enum_framesizes, */
-	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
-	.vidioc_g_parm        = vidioc_g_parm,
-	.vidioc_s_parm        = vidioc_s_parm,
-	.vidioc_streamon = vb2_ioctl_streamon,
-	.vidioc_streamoff = vb2_ioctl_streamoff,
-
-	.vidioc_log_status = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
-	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-};
-
 /* ------------------------------------------------------------------
 	Driver init/finalise
    ------------------------------------------------------------------*/
@@ -1813,11 +1759,6 @@ static int __init bm2835_mmal_init_device(struct bm2835_mmal_dev *dev,
 	int ret;
 
 	*vfd = vdev_template;
-	if (gst_v4l2src_is_broken) {
-		v4l2_info(&dev->v4l2_dev,
-			  "Work-around for gstreamer issue is active.\n");
-		vfd->ioctl_ops = &camera0_ioctl_ops_gstreamer;
-	}
 
 	vfd->v4l2_dev = &dev->v4l2_dev;
 
-- 
2.7.4
