Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:33660 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab3ADVAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 16:00:05 -0500
Received: by mail-vb0-f44.google.com with SMTP id fc26so16901779vbb.17
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 13:00:04 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/15] em28xx: std fixes: don't implement in webcam mode, and fix std changes.
Date: Fri,  4 Jan 2013 15:59:42 -0500
Message-Id: <1357333186-8466-13-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When in webcam mode the STD API shouldn't be implemented.

When changing the standard the resolution wasn't updated, and there was no
check against streaming-in-progress.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 7c09b55..ae713a0 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -909,6 +909,8 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
 	struct em28xx      *dev = fh->dev;
 	int                rc;
 
+	if (dev->board.is_webcam)
+		return -ENOTTY;
 	rc = check_dev(dev);
 	if (rc < 0)
 		return rc;
@@ -924,6 +926,8 @@ static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
 	struct em28xx      *dev = fh->dev;
 	int                rc;
 
+	if (dev->board.is_webcam)
+		return -ENOTTY;
 	rc = check_dev(dev);
 	if (rc < 0)
 		return rc;
@@ -940,15 +944,24 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	struct v4l2_format f;
 	int                rc;
 
+	if (dev->board.is_webcam)
+		return -ENOTTY;
+	if (*norm == dev->norm)
+		return 0;
 	rc = check_dev(dev);
 	if (rc < 0)
 		return rc;
 
+	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
+		em28xx_errdev("%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
 	dev->norm = *norm;
 
 	/* Adjusts width/height, if needed */
-	f.fmt.pix.width = dev->width;
-	f.fmt.pix.height = dev->height;
+	f.fmt.pix.width = 720;
+	f.fmt.pix.height = (*norm & V4L2_STD_525_60) ? 480 : 576;
 	vidioc_try_fmt_vid_cap(file, priv, &f);
 
 	/* set new image size */
@@ -1034,6 +1047,9 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		i->type = V4L2_INPUT_TYPE_TUNER;
 
 	i->std = dev->vdev->tvnorms;
+	/* webcams do not have the STD API */
+	if (dev->board.is_webcam)
+		i->capabilities = 0;
 
 	return 0;
 }
@@ -2059,7 +2075,6 @@ static const struct video_device em28xx_video_template = {
 	.ioctl_ops 		    = &video_ioctl_ops,
 
 	.tvnorms                    = V4L2_STD_ALL,
-	.current_norm               = V4L2_STD_PAL,
 };
 
 static const struct v4l2_file_operations radio_fops = {
@@ -2109,6 +2124,8 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 	vfd->debug	= video_debug;
 	vfd->lock	= &dev->lock;
 	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
+	if (dev->board.is_webcam)
+		vfd->tvnorms = 0;
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s",
 		 dev->name, type_name);
@@ -2127,7 +2144,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 		dev->name, EM28XX_VERSION);
 
 	/* set default norm */
-	dev->norm = em28xx_video_template.current_norm;
+	dev->norm = V4L2_STD_PAL;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
 	dev->interlaced = EM28XX_INTERLACED_DEFAULT;
 
-- 
1.7.9.5

