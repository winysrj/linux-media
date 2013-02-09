Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2809 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3BIKBU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 14/26] cx231xx: improve std handling.
Date: Sat,  9 Feb 2013 11:00:44 +0100
Message-Id: <63ea22c9a3a4a2d7bea5333b8df68a5605cbf08e.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Set the initial standard of subdevices instead of leaving it undefined.
Also update the width and height when a new standard is chosen and
return -EBUSY when attempting to change the standard while videobuf is
busy.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 311d106..208926f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -992,34 +992,34 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
 	struct v4l2_mbus_framefmt mbus_fmt;
-	struct v4l2_format f;
 	int rc;
 
 	rc = check_dev(dev);
 	if (rc < 0)
 		return rc;
 
-	cx231xx_info("vidioc_s_std : 0x%x\n", (unsigned int)*norm);
+	if (dev->norm == *norm)
+		return 0;
+
+	if (videobuf_queue_is_busy(&fh->vb_vidq))
+		return -EBUSY;
 
 	dev->norm = *norm;
 
 	/* Adjusts width/height, if needed */
-	f.fmt.pix.width = dev->width;
-	f.fmt.pix.height = dev->height;
-	vidioc_try_fmt_vid_cap(file, priv, &f);
+	dev->width = 720;
+	dev->height = (dev->norm & V4L2_STD_625_50) ? 576 : 480;
 
 	call_all(dev, core, s_std, dev->norm);
 
 	/* We need to reset basic properties in the decoder related to
 	   resolution (since a standard change effects things like the number
 	   of lines in VACT, etc) */
-	v4l2_fill_mbus_format(&mbus_fmt, &f.fmt.pix, V4L2_MBUS_FMT_FIXED);
+	memset(&mbus_fmt, 0, sizeof(mbus_fmt));
+	mbus_fmt.code = V4L2_MBUS_FMT_FIXED;
+	mbus_fmt.width = dev->width;
+	mbus_fmt.height = dev->height;
 	call_all(dev, video, s_mbus_fmt, &mbus_fmt);
-	v4l2_fill_pix_format(&f.fmt.pix, &mbus_fmt);
-
-	/* set new image size */
-	dev->width = f.fmt.pix.width;
-	dev->height = f.fmt.pix.height;
 
 	/* do mode control overrides */
 	cx231xx_do_mode_ctrl_overrides(dev);
@@ -2306,6 +2306,8 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	/* Set the initial input */
 	video_mux(dev, dev->video_input);
 
+	call_all(dev, core, s_std, dev->norm);
+
 	v4l2_ctrl_handler_init(&dev->ctrl_handler, 10);
 	v4l2_ctrl_handler_init(&dev->radio_ctrl_handler, 5);
 
-- 
1.7.10.4

