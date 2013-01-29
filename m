Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4791 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab3A2Qdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 14/20] cx231xx: improve std handling.
Date: Tue, 29 Jan 2013 17:33:07 +0100
Message-Id: <800f7f512cbbcf9afed994088fa226af4f532219.1359476777.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
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
index 51c686c..2a440cd 100644
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
@@ -2305,6 +2305,8 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	/* Set the initial input */
 	video_mux(dev, dev->video_input);
 
+	call_all(dev, core, s_std, dev->norm);
+
 	v4l2_ctrl_handler_init(&dev->ctrl_handler, 10);
 	v4l2_ctrl_handler_init(&dev->radio_ctrl_handler, 5);
 
-- 
1.7.10.4

