Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4879 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab3CTSjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 14:39:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 10/11] hdpvr: add g/querystd, remove deprecated current_norm.
Date: Wed, 20 Mar 2013 19:39:01 +0100
Message-Id: <1363804742-5355-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
References: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |   62 ++++++++++++++++++++++++++-------
 drivers/media/usb/hdpvr/hdpvr.h       |    5 ++-
 2 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 558dbe7..491732b 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -549,12 +549,50 @@ static int vidioc_s_std(struct file *file, void *private_data,
 	struct hdpvr_device *dev = video_drvdata(file);
 	u8 std_type = 1;
 
-	if (*std & (V4L2_STD_NTSC | V4L2_STD_PAL_60))
+	if (dev->options.video_input == HDPVR_COMPONENT)
+		return -ENODATA;
+	if (dev->status != STATUS_IDLE)
+		return -EBUSY;
+	if (*std & V4L2_STD_525_60)
 		std_type = 0;
+	dev->cur_std = *std;
+	dev->width = 720;
+	dev->height = std_type ? 576 : 480;
 
 	return hdpvr_config_call(dev, CTRL_VIDEO_STD_TYPE, std_type);
 }
 
+static int vidioc_g_std(struct file *file, void *private_data,
+			v4l2_std_id *std)
+{
+	struct hdpvr_device *dev = video_drvdata(file);
+
+	if (dev->options.video_input == HDPVR_COMPONENT)
+		return -ENODATA;
+	*std = dev->cur_std;
+	return 0;
+}
+
+static int vidioc_querystd(struct file *file, void *fh, v4l2_std_id *a)
+{
+	struct hdpvr_device *dev = video_drvdata(file);
+	struct hdpvr_video_info *vid_info;
+
+	if (dev->options.video_input == HDPVR_COMPONENT)
+		return -ENODATA;
+	*a = V4L2_STD_ALL;
+	vid_info = get_video_info(dev);
+	if (vid_info == NULL)
+		return 0;
+	if (vid_info->width == 720 &&
+	    (vid_info->height == 480 || vid_info->height == 576)) {
+		*a = (vid_info->height == 480) ?
+			V4L2_STD_525_60 : V4L2_STD_625_50;
+	}
+	kfree(vid_info);
+	return 0;
+}
+
 static const char *iname[] = {
 	[HDPVR_COMPONENT] = "Component",
 	[HDPVR_SVIDEO]    = "S-Video",
@@ -564,7 +602,6 @@ static const char *iname[] = {
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *i)
 {
-	struct hdpvr_device *dev = video_drvdata(file);
 	unsigned int n;
 
 	n = i->index;
@@ -578,7 +615,8 @@ static int vidioc_enum_input(struct file *file, void *priv,
 
 	i->audioset = 1<<HDPVR_RCA_FRONT | 1<<HDPVR_RCA_BACK | 1<<HDPVR_SPDIF;
 
-	i->std = dev->video_dev->tvnorms;
+	i->capabilities = n ? V4L2_IN_CAP_STD : V4L2_IN_CAP_DV_TIMINGS;
+	i->std = n ? V4L2_STD_ALL : 0;
 
 	return 0;
 }
@@ -596,8 +634,11 @@ static int vidioc_s_input(struct file *file, void *private_data,
 		return -EBUSY;
 
 	retval = hdpvr_config_call(dev, CTRL_VIDEO_INPUT_VALUE, index+1);
-	if (!retval)
+	if (!retval) {
 		dev->options.video_input = index;
+		dev->video_dev->tvnorms =
+			index != HDPVR_COMPONENT ? V4L2_STD_ALL : 0;
+	}
 
 	return retval;
 }
@@ -775,7 +816,6 @@ static int hdpvr_s_ctrl(struct v4l2_ctrl *ctrl)
 static int vidioc_enum_fmt_vid_cap(struct file *file, void *private_data,
 				    struct v4l2_fmtdesc *f)
 {
-
 	if (f->index != 0)
 		return -EINVAL;
 
@@ -872,6 +912,8 @@ static int vidioc_try_encoder_cmd(struct file *filp, void *priv,
 static const struct v4l2_ioctl_ops hdpvr_ioctl_ops = {
 	.vidioc_querycap	= vidioc_querycap,
 	.vidioc_s_std		= vidioc_s_std,
+	.vidioc_g_std		= vidioc_g_std,
+	.vidioc_querystd	= vidioc_querystd,
 	.vidioc_enum_input	= vidioc_enum_input,
 	.vidioc_g_input		= vidioc_g_input,
 	.vidioc_s_input		= vidioc_s_input,
@@ -914,13 +956,6 @@ static const struct video_device hdpvr_video_template = {
 	.fops			= &hdpvr_fops,
 	.release		= hdpvr_device_release,
 	.ioctl_ops 		= &hdpvr_ioctl_ops,
-	.tvnorms 		=
-		V4L2_STD_NTSC  | V4L2_STD_SECAM | V4L2_STD_PAL_B |
-		V4L2_STD_PAL_G | V4L2_STD_PAL_H | V4L2_STD_PAL_I |
-		V4L2_STD_PAL_D | V4L2_STD_PAL_M | V4L2_STD_PAL_N |
-		V4L2_STD_PAL_60,
-	.current_norm 		= V4L2_STD_NTSC | V4L2_STD_PAL_M |
-		V4L2_STD_PAL_60,
 };
 
 static const struct v4l2_ctrl_ops hdpvr_ctrl_ops = {
@@ -935,6 +970,9 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 	bool ac3 = dev->flags & HDPVR_FLAG_AC3_CAP;
 	int res;
 
+	dev->cur_std = V4L2_STD_525_60;
+	dev->width = 720;
+	dev->height = 480;
 	v4l2_ctrl_handler_init(hdl, 11);
 	if (dev->fw_ver > 0x15) {
 		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
index 1c12981..050c6b9 100644
--- a/drivers/media/usb/hdpvr/hdpvr.h
+++ b/drivers/media/usb/hdpvr/hdpvr.h
@@ -78,6 +78,8 @@ struct hdpvr_device {
 		struct v4l2_ctrl *video_bitrate;
 		struct v4l2_ctrl *video_bitrate_peak;
 	};
+	/* v4l2 format */
+	uint width, height;
 
 	/* the max packet size of the bulk endpoint */
 	size_t			bulk_in_size;
@@ -87,8 +89,9 @@ struct hdpvr_device {
 	/* holds the current device status */
 	__u8			status;
 
-	/* holds the cureent set options */
+	/* holds the current set options */
 	struct hdpvr_options	options;
+	v4l2_std_id		cur_std;
 
 	uint			flags;
 
-- 
1.7.10.4

