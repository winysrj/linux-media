Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2861 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935106Ab3E2Hzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 03:55:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: leo@lumanate.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 3/3] hdpvr: improve error handling
Date: Wed, 29 May 2013 09:55:15 +0200
Message-Id: <1369814115-12174-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369814115-12174-1-git-send-email-hverkuil@xs4all.nl>
References: <1369814115-12174-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

get_video_info() should never return EFAULT, instead it should return
the low-level usb_control_msg() error. Add a valid field to the hdpvr_video_info
struct so the driver can easily check if a valid format was detected.

Whenever get_video_info is called and it returns an error (e.g. usb_control_msg
failed), then return that error to userspace as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-control.c |   21 +++++++++------------
 drivers/media/usb/hdpvr/hdpvr-video.c   |   18 +++++++++++-------
 drivers/media/usb/hdpvr/hdpvr.h         |    1 +
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
index df6bcb5..6053661 100644
--- a/drivers/media/usb/hdpvr/hdpvr-control.c
+++ b/drivers/media/usb/hdpvr/hdpvr-control.c
@@ -49,6 +49,7 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
 {
 	int ret;
 
+	vidinf->valid = false;
 	mutex_lock(&dev->usbc_mutex);
 	ret = usb_control_msg(dev->udev,
 			      usb_rcvctrlpipe(dev->udev, 0),
@@ -56,11 +57,6 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
 			      0x1400, 0x0003,
 			      dev->usbc_buf, 5,
 			      1000);
-	if (ret == 5) {
-		vidinf->width	= dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
-		vidinf->height	= dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
-		vidinf->fps	= dev->usbc_buf[4];
-	}
 
 #ifdef HDPVR_DEBUG
 	if (hdpvr_debug & MSG_INFO) {
@@ -73,14 +69,15 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
 #endif
 	mutex_unlock(&dev->usbc_mutex);
 
-	if ((ret > 0 && ret != 5) ||/* fail if unexpected byte count returned */
-	    !vidinf->width ||	/* preserve original behavior -  */
-	    !vidinf->height ||	/* fail if no signal is detected */
-	    !vidinf->fps) {
-		ret = -EFAULT;
-	}
+	if (ret < 0)
+		return ret;
 
-	return ret < 0 ? ret : 0;
+	vidinf->width	= dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
+	vidinf->height	= dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
+	vidinf->fps	= dev->usbc_buf[4];
+	vidinf->valid   = vidinf->width && vidinf->height && vidinf->fps;
+
+	return 0;
 }
 
 int get_input_lines_info(struct hdpvr_device *dev)
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index e947105..4f8567a 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -285,7 +285,10 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
 		return -EAGAIN;
 
 	ret = get_video_info(dev, &vidinf);
-	if (ret) {
+	if (ret < 0)
+		return ret;
+
+	if (!vidinf.valid) {
 		msleep(250);
 		v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
 				"no video signal at input %d\n", dev->options.video_input);
@@ -617,15 +620,12 @@ static int vidioc_querystd(struct file *file, void *_fh, v4l2_std_id *a)
 	if (dev->options.video_input == HDPVR_COMPONENT)
 		return fh->legacy_mode ? 0 : -ENODATA;
 	ret = get_video_info(dev, &vid_info);
-	if (ret)
-		return 0;
-	if (vid_info.width == 720 &&
+	if (vid_info.valid && vid_info.width == 720 &&
 	    (vid_info.height == 480 || vid_info.height == 576)) {
 		*a = (vid_info.height == 480) ?
 			V4L2_STD_525_60 : V4L2_STD_625_50;
 	}
-
-	return 0;
+	return ret;
 }
 
 static int vidioc_s_dv_timings(struct file *file, void *_fh,
@@ -679,6 +679,8 @@ static int vidioc_query_dv_timings(struct file *file, void *_fh,
 		return -ENODATA;
 	ret = get_video_info(dev, &vid_info);
 	if (ret)
+		return ret;
+	if (!vid_info.valid)
 		return -ENOLCK;
 	interlaced = vid_info.fps <= 30;
 	for (i = 0; i < ARRAY_SIZE(hdpvr_dv_timings); i++) {
@@ -1008,7 +1010,9 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *_fh,
 		struct hdpvr_video_info vid_info;
 
 		ret = get_video_info(dev, &vid_info);
-		if (ret)
+		if (ret < 0)
+			return ret;
+		if (!vid_info.valid)
 			return -EFAULT;
 		f->fmt.pix.width = vid_info.width;
 		f->fmt.pix.height = vid_info.height;
diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
index 808ea7a..dc685d4 100644
--- a/drivers/media/usb/hdpvr/hdpvr.h
+++ b/drivers/media/usb/hdpvr/hdpvr.h
@@ -154,6 +154,7 @@ struct hdpvr_video_info {
 	u16	width;
 	u16	height;
 	u8	fps;
+	bool	valid;
 };
 
 enum {
-- 
1.7.10.4

