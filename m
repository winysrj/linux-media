Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4386 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab3CTSjU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 14:39:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 11/11] hdpvr: add dv_timings support.
Date: Wed, 20 Mar 2013 19:39:02 +0100
Message-Id: <1363804742-5355-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
References: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |  217 +++++++++++++++++++++++++++++----
 drivers/media/usb/hdpvr/hdpvr.h       |    1 +
 2 files changed, 194 insertions(+), 24 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 491732b..e0381a7 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -20,6 +20,7 @@
 #include <linux/workqueue.h>
 
 #include <linux/videodev2.h>
+#include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
@@ -35,6 +36,25 @@
 			 list_size(&dev->free_buff_list),		\
 			 list_size(&dev->rec_buff_list)); }
 
+static const struct v4l2_dv_timings hdpvr_dv_timings[] = {
+	V4L2_DV_BT_CEA_720X480I59_94,
+	V4L2_DV_BT_CEA_720X576I50,
+	V4L2_DV_BT_CEA_720X480P59_94,
+	V4L2_DV_BT_CEA_720X576P50,
+	V4L2_DV_BT_CEA_1280X720P50,
+	V4L2_DV_BT_CEA_1280X720P60,
+	V4L2_DV_BT_CEA_1920X1080I50,
+	V4L2_DV_BT_CEA_1920X1080I60,
+};
+
+/* Use 480i59 as the default timings */
+#define HDPVR_DEF_DV_TIMINGS_IDX (0)
+
+struct hdpvr_fh {
+	struct v4l2_fh fh;
+	bool legacy_mode;
+};
+
 static uint list_size(struct list_head *list)
 {
 	struct list_head *tmp;
@@ -354,13 +374,23 @@ static int hdpvr_stop_streaming(struct hdpvr_device *dev)
  * video 4 linux 2 file operations
  */
 
+static int hdpvr_open(struct file *file)
+{
+	struct hdpvr_fh *fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+
+	if (fh == NULL)
+		return -ENOMEM;
+	fh->legacy_mode = true;
+	v4l2_fh_init(&fh->fh, video_devdata(file));
+	v4l2_fh_add(&fh->fh);
+	file->private_data = fh;
+	return 0;
+}
+
 static int hdpvr_release(struct file *file)
 {
 	struct hdpvr_device *dev = video_drvdata(file);
 
-	if (!dev)
-		return -ENODEV;
-
 	mutex_lock(&dev->io_mutex);
 	if (file->private_data == dev->owner) {
 		hdpvr_stop_streaming(dev);
@@ -387,9 +417,6 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 	if (*pos)
 		return -ESPIPE;
 
-	if (!dev)
-		return -ENODEV;
-
 	mutex_lock(&dev->io_mutex);
 	if (dev->status == STATUS_IDLE) {
 		if (hdpvr_start_streaming(dev)) {
@@ -517,7 +544,7 @@ static unsigned int hdpvr_poll(struct file *filp, poll_table *wait)
 
 static const struct v4l2_file_operations hdpvr_fops = {
 	.owner		= THIS_MODULE,
-	.open		= v4l2_fh_open,
+	.open		= hdpvr_open,
 	.release	= hdpvr_release,
 	.read		= hdpvr_read,
 	.poll		= hdpvr_poll,
@@ -593,6 +620,121 @@ static int vidioc_querystd(struct file *file, void *fh, v4l2_std_id *a)
 	return 0;
 }
 
+static int vidioc_s_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct hdpvr_device *dev = video_drvdata(file);
+	struct hdpvr_fh *fh = _fh;
+	int i;
+
+	fh->legacy_mode = false;
+	if (dev->options.video_input)
+		return -ENODATA;
+	if (dev->status != STATUS_IDLE)
+		return -EBUSY;
+	for (i = 0; i < ARRAY_SIZE(hdpvr_dv_timings); i++)
+		if (v4l_match_dv_timings(timings, hdpvr_dv_timings + i, 0))
+			break;
+	if (i == ARRAY_SIZE(hdpvr_dv_timings))
+		return -EINVAL;
+	dev->cur_dv_timings = hdpvr_dv_timings[i];
+	dev->width = hdpvr_dv_timings[i].bt.width;
+	dev->height = hdpvr_dv_timings[i].bt.height;
+	return 0;
+}
+
+static int vidioc_g_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct hdpvr_device *dev = video_drvdata(file);
+	struct hdpvr_fh *fh = _fh;
+
+	fh->legacy_mode = false;
+	if (dev->options.video_input)
+		return -ENODATA;
+	*timings = dev->cur_dv_timings;
+	return 0;
+}
+
+static int vidioc_query_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct hdpvr_device *dev = video_drvdata(file);
+	struct hdpvr_fh *fh = _fh;
+	struct hdpvr_video_info *vid_info;
+	bool interlaced;
+	int ret = 0;
+	int i;
+
+	fh->legacy_mode = false;
+	if (dev->options.video_input)
+		return -ENODATA;
+	vid_info = get_video_info(dev);
+	if (vid_info == NULL)
+		return -ENOLCK;
+	interlaced = vid_info->fps <= 30;
+	for (i = 0; i < ARRAY_SIZE(hdpvr_dv_timings); i++) {
+		const struct v4l2_bt_timings *bt = &hdpvr_dv_timings[i].bt;
+		unsigned hsize;
+		unsigned vsize;
+		unsigned fps;
+
+		hsize = bt->hfrontporch + bt->hsync + bt->hbackporch + bt->width;
+		vsize = bt->vfrontporch + bt->vsync + bt->vbackporch +
+			bt->il_vfrontporch + bt->il_vsync + bt->il_vbackporch +
+			bt->height;
+		fps = (unsigned)bt->pixelclock / (hsize * vsize);
+		if (bt->width != vid_info->width ||
+		    bt->height != vid_info->height ||
+		    bt->interlaced != interlaced ||
+		    (fps != vid_info->fps && fps + 1 != vid_info->fps))
+			continue;
+		*timings = hdpvr_dv_timings[i];
+		break;
+	}
+	if (i == ARRAY_SIZE(hdpvr_dv_timings))
+		ret = -ERANGE;
+	kfree(vid_info);
+	return ret;
+}
+
+static int vidioc_enum_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_enum_dv_timings *timings)
+{
+	struct hdpvr_device *dev = video_drvdata(file);
+	struct hdpvr_fh *fh = _fh;
+
+	fh->legacy_mode = false;
+	memset(timings->reserved, 0, sizeof(timings->reserved));
+	if (dev->options.video_input)
+		return -ENODATA;
+	if (timings->index >= ARRAY_SIZE(hdpvr_dv_timings))
+		return -EINVAL;
+	timings->timings = hdpvr_dv_timings[timings->index];
+	return 0;
+}
+
+static int vidioc_dv_timings_cap(struct file *file, void *_fh,
+				    struct v4l2_dv_timings_cap *cap)
+{
+	struct hdpvr_device *dev = video_drvdata(file);
+	struct hdpvr_fh *fh = _fh;
+
+	fh->legacy_mode = false;
+	if (dev->options.video_input)
+		return -ENODATA;
+	cap->type = V4L2_DV_BT_656_1120;
+	cap->bt.min_width = 720;
+	cap->bt.max_width = 1920;
+	cap->bt.min_height = 480;
+	cap->bt.max_height = 1080;
+	cap->bt.min_pixelclock = 27000000;
+	cap->bt.max_pixelclock = 74250000;
+	cap->bt.standards = V4L2_DV_BT_STD_CEA861;
+	cap->bt.capabilities = V4L2_DV_BT_CAP_INTERLACED | V4L2_DV_BT_CAP_PROGRESSIVE;
+	return 0;
+}
+
 static const char *iname[] = {
 	[HDPVR_COMPONENT] = "Component",
 	[HDPVR_SVIDEO]    = "S-Video",
@@ -826,29 +968,48 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *private_data,
 	return 0;
 }
 
-static int vidioc_g_fmt_vid_cap(struct file *file, void *private_data,
+static int vidioc_g_fmt_vid_cap(struct file *file, void *_fh,
 				struct v4l2_format *f)
 {
 	struct hdpvr_device *dev = video_drvdata(file);
-	struct hdpvr_video_info *vid_info;
-
-	if (!dev)
-		return -ENODEV;
-
-	vid_info = get_video_info(dev);
-	if (!vid_info)
-		return -EFAULT;
-
-	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	struct hdpvr_fh *fh = _fh;
+
+	/*
+	 * The original driver would always returns the current detected
+	 * resolution as the format (and EFAULT if it couldn't be detected).
+	 * With the introduction of VIDIOC_QUERY_DV_TIMINGS there is now a
+	 * better way of doing this, but to stay compatible with existing
+	 * applications we assume legacy mode every time an application opens
+	 * the device. Only if one of the new DV_TIMINGS ioctls is called
+	 * will the filehandle go into 'normal' mode where g_fmt returns the
+	 * last set format.
+	 */
+	if (fh->legacy_mode) {
+		struct hdpvr_video_info *vid_info;
+
+		vid_info = get_video_info(dev);
+		if (!vid_info)
+			return -EFAULT;
+		f->fmt.pix.width = vid_info->width;
+		f->fmt.pix.height = vid_info->height;
+		kfree(vid_info);
+	} else {
+		f->fmt.pix.width = dev->width;
+		f->fmt.pix.height = dev->height;
+	}
 	f->fmt.pix.pixelformat	= V4L2_PIX_FMT_MPEG;
-	f->fmt.pix.width	= vid_info->width;
-	f->fmt.pix.height	= vid_info->height;
 	f->fmt.pix.sizeimage	= dev->bulk_in_size;
-	f->fmt.pix.colorspace	= 0;
 	f->fmt.pix.bytesperline	= 0;
-	f->fmt.pix.field	= V4L2_FIELD_ANY;
-
-	kfree(vid_info);
+	f->fmt.pix.priv		= 0;
+	if (f->fmt.pix.width == 720) {
+		/* SDTV formats */
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+		f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	} else {
+		/* HDTV formats */
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE240M;
+		f->fmt.pix.field = V4L2_FIELD_NONE;
+	}
 	return 0;
 }
 
@@ -914,6 +1075,11 @@ static const struct v4l2_ioctl_ops hdpvr_ioctl_ops = {
 	.vidioc_s_std		= vidioc_s_std,
 	.vidioc_g_std		= vidioc_g_std,
 	.vidioc_querystd	= vidioc_querystd,
+	.vidioc_s_dv_timings	= vidioc_s_dv_timings,
+	.vidioc_g_dv_timings	= vidioc_g_dv_timings,
+	.vidioc_query_dv_timings= vidioc_query_dv_timings,
+	.vidioc_enum_dv_timings	= vidioc_enum_dv_timings,
+	.vidioc_dv_timings_cap	= vidioc_dv_timings_cap,
 	.vidioc_enum_input	= vidioc_enum_input,
 	.vidioc_g_input		= vidioc_g_input,
 	.vidioc_s_input		= vidioc_s_input,
@@ -922,6 +1088,8 @@ static const struct v4l2_ioctl_ops hdpvr_ioctl_ops = {
 	.vidioc_s_audio		= vidioc_s_audio,
 	.vidioc_enum_fmt_vid_cap= vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
 	.vidioc_encoder_cmd	= vidioc_encoder_cmd,
 	.vidioc_try_encoder_cmd	= vidioc_try_encoder_cmd,
 	.vidioc_log_status	= v4l2_ctrl_log_status,
@@ -973,6 +1141,7 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 	dev->cur_std = V4L2_STD_525_60;
 	dev->width = 720;
 	dev->height = 480;
+	dev->cur_dv_timings = hdpvr_dv_timings[HDPVR_DEF_DV_TIMINGS_IDX];
 	v4l2_ctrl_handler_init(hdl, 11);
 	if (dev->fw_ver > 0x15) {
 		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
index 050c6b9..1478f3d 100644
--- a/drivers/media/usb/hdpvr/hdpvr.h
+++ b/drivers/media/usb/hdpvr/hdpvr.h
@@ -92,6 +92,7 @@ struct hdpvr_device {
 	/* holds the current set options */
 	struct hdpvr_options	options;
 	v4l2_std_id		cur_std;
+	struct v4l2_dv_timings	cur_dv_timings;
 
 	uint			flags;
 
-- 
1.7.10.4

