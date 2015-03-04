Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:45238 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758951AbbCDJtT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2015 04:49:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCHv2 7/8] v4l2-subdev: add support for the new enum_frame_interval 'which' field.
Date: Wed,  4 Mar 2015 10:48:00 +0100
Message-Id: <1425462481-8200-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
References: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Support the new 'which' field in the enum_frame_interval ops. Most drivers do not
need to be changed since they always returns the same enumeration regardless
of the 'which' field.

Tested for ov7670 and marvell-ccic on a OLPC XO-1 laptop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov7670.c                      | 37 +++++++++++--------
 drivers/media/platform/marvell-ccic/mcam-core.c | 48 ++++++++++++++++++++++---
 drivers/media/platform/soc_camera/soc_camera.c  | 30 +++++++++++-----
 drivers/media/platform/via-camera.c             | 15 ++++++--
 4 files changed, 101 insertions(+), 29 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 957927f..b984752 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1069,29 +1069,35 @@ static int ov7670_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 
 static int ov7670_frame_rates[] = { 30, 15, 10, 5, 1 };
 
-static int ov7670_enum_frameintervals(struct v4l2_subdev *sd,
-		struct v4l2_frmivalenum *interval)
+static int ov7670_enum_frame_interval(struct v4l2_subdev *sd,
+				      struct v4l2_subdev_pad_config *cfg,
+				      struct v4l2_subdev_frame_interval_enum *fie)
 {
-	if (interval->index >= ARRAY_SIZE(ov7670_frame_rates))
+	if (fie->pad)
 		return -EINVAL;
-	interval->type = V4L2_FRMIVAL_TYPE_DISCRETE;
-	interval->discrete.numerator = 1;
-	interval->discrete.denominator = ov7670_frame_rates[interval->index];
+	if (fie->index >= ARRAY_SIZE(ov7670_frame_rates))
+		return -EINVAL;
+	fie->interval.numerator = 1;
+	fie->interval.denominator = ov7670_frame_rates[fie->index];
 	return 0;
 }
 
 /*
  * Frame size enumeration
  */
-static int ov7670_enum_framesizes(struct v4l2_subdev *sd,
-		struct v4l2_frmsizeenum *fsize)
+static int ov7670_enum_frame_size(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct ov7670_info *info = to_state(sd);
 	int i;
 	int num_valid = -1;
-	__u32 index = fsize->index;
+	__u32 index = fse->index;
 	unsigned int n_win_sizes = info->devtype->n_win_sizes;
 
+	if (fse->pad)
+		return -EINVAL;
+
 	/*
 	 * If a minimum width/height was requested, filter out the capture
 	 * windows that fall outside that.
@@ -1103,9 +1109,8 @@ static int ov7670_enum_framesizes(struct v4l2_subdev *sd,
 		if (info->min_height && win->height < info->min_height)
 			continue;
 		if (index == ++num_valid) {
-			fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
-			fsize->discrete.width = win->width;
-			fsize->discrete.height = win->height;
+			fse->min_width = fse->max_width = win->width;
+			fse->min_height = fse->max_height = win->height;
 			return 0;
 		}
 	}
@@ -1485,13 +1490,17 @@ static const struct v4l2_subdev_video_ops ov7670_video_ops = {
 	.s_mbus_fmt = ov7670_s_mbus_fmt,
 	.s_parm = ov7670_s_parm,
 	.g_parm = ov7670_g_parm,
-	.enum_frameintervals = ov7670_enum_frameintervals,
-	.enum_framesizes = ov7670_enum_framesizes,
+};
+
+static const struct v4l2_subdev_pad_ops ov7670_pad_ops = {
+	.enum_frame_interval = ov7670_enum_frame_interval,
+	.enum_frame_size = ov7670_enum_frame_size,
 };
 
 static const struct v4l2_subdev_ops ov7670_ops = {
 	.core = &ov7670_core_ops,
 	.video = &ov7670_video_ops,
+	.pad = &ov7670_pad_ops,
 };
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index dd5b141..9c64b5d 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1568,24 +1568,64 @@ static int mcam_vidioc_enum_framesizes(struct file *filp, void *priv,
 		struct v4l2_frmsizeenum *sizes)
 {
 	struct mcam_camera *cam = priv;
+	struct mcam_format_struct *f;
+	struct v4l2_subdev_frame_size_enum fse = {
+		.index = sizes->index,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int ret;
 
+	f = mcam_find_format(sizes->pixel_format);
+	if (f->pixelformat != sizes->pixel_format)
+		return -EINVAL;
+	fse.code = f->mbus_code;
 	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, enum_framesizes, sizes);
+	ret = sensor_call(cam, pad, enum_frame_size, NULL, &fse);
 	mutex_unlock(&cam->s_mutex);
-	return ret;
+	if (ret)
+		return ret;
+	if (fse.min_width == fse.max_width &&
+	    fse.min_height == fse.max_height) {
+		sizes->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+		sizes->discrete.width = fse.min_width;
+		sizes->discrete.height = fse.min_height;
+		return 0;
+	}
+	sizes->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
+	sizes->stepwise.min_width = fse.min_width;
+	sizes->stepwise.max_width = fse.max_width;
+	sizes->stepwise.min_height = fse.min_height;
+	sizes->stepwise.max_height = fse.max_height;
+	sizes->stepwise.step_width = 1;
+	sizes->stepwise.step_height = 1;
+	return 0;
 }
 
 static int mcam_vidioc_enum_frameintervals(struct file *filp, void *priv,
 		struct v4l2_frmivalenum *interval)
 {
 	struct mcam_camera *cam = priv;
+	struct mcam_format_struct *f;
+	struct v4l2_subdev_frame_interval_enum fie = {
+		.index = interval->index,
+		.width = interval->width,
+		.height = interval->height,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int ret;
 
+	f = mcam_find_format(interval->pixel_format);
+	if (f->pixelformat != interval->pixel_format)
+		return -EINVAL;
+	fie.code = f->mbus_code;
 	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, enum_frameintervals, interval);
+	ret = sensor_call(cam, pad, enum_frame_interval, NULL, &fie);
 	mutex_unlock(&cam->s_mutex);
-	return ret;
+	if (ret)
+		return ret;
+	interval->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	interval->discrete = fie.interval;
+	return 0;
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index cee7b56..1ed0a0b 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1888,22 +1888,34 @@ static int default_enum_framesizes(struct soc_camera_device *icd,
 	int ret;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
-	__u32 pixfmt = fsize->pixel_format;
-	struct v4l2_frmsizeenum fsize_mbus = *fsize;
+	struct v4l2_subdev_frame_size_enum fse = {
+		.index = fsize->index,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 
-	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	xlate = soc_camera_xlate_by_fourcc(icd, fsize->pixel_format);
 	if (!xlate)
 		return -EINVAL;
-	/* map xlate-code to pixel_format, sensor only handle xlate-code*/
-	fsize_mbus.pixel_format = xlate->code;
+	fse.code = xlate->code;
 
-	ret = v4l2_subdev_call(sd, video, enum_framesizes, &fsize_mbus);
+	ret = v4l2_subdev_call(sd, pad, enum_frame_size, NULL, &fse);
 	if (ret < 0)
 		return ret;
 
-	*fsize = fsize_mbus;
-	fsize->pixel_format = pixfmt;
-
+	if (fse.min_width == fse.max_width &&
+	    fse.min_height == fse.max_height) {
+		fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+		fsize->discrete.width = fse.min_width;
+		fsize->discrete.height = fse.min_height;
+		return 0;
+	}
+	fsize->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
+	fsize->stepwise.min_width = fse.min_width;
+	fsize->stepwise.max_width = fse.max_width;
+	fsize->stepwise.min_height = fse.min_height;
+	fsize->stepwise.max_height = fse.max_height;
+	fsize->stepwise.step_width = 1;
+	fsize->stepwise.step_height = 1;
 	return 0;
 }
 
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index 86989d8..678ed9f 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -1147,12 +1147,23 @@ static int viacam_enum_frameintervals(struct file *filp, void *priv,
 		struct v4l2_frmivalenum *interval)
 {
 	struct via_camera *cam = priv;
+	struct v4l2_subdev_frame_interval_enum fie = {
+		.index = interval->index,
+		.code = cam->mbus_code,
+		.width = cam->sensor_format.width,
+		.height = cam->sensor_format.height,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int ret;
 
 	mutex_lock(&cam->lock);
-	ret = sensor_call(cam, video, enum_frameintervals, interval);
+	ret = sensor_call(cam, pad, enum_frame_interval, NULL, &fie);
 	mutex_unlock(&cam->lock);
-	return ret;
+	if (ret)
+		return ret;
+	interval->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	interval->discrete = fie.interval;
+	return 0;
 }
 
 
-- 
2.1.4

