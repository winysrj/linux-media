Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:57924 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752857AbeBSOII (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 09:08:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 06/10] staging: atomisp: i2c: Drop g_parm support in sensor drivers
Date: Mon, 19 Feb 2018 15:07:58 +0100
Message-Id: <20180219140802.3514-7-hverkuil@xs4all.nl>
In-Reply-To: <20180219140802.3514-1-hverkuil@xs4all.nl>
References: <20180219140802.3514-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

These drivers already support g_frame_interval. Therefore just dropping
g_parm is enough.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c | 27 ----------------------
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c | 27 ----------------------
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c | 27 ----------------------
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c | 27 ----------------------
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      | 27 ----------------------
 5 files changed, 135 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
index 572c9127c24d..93753cb96180 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
@@ -1204,32 +1204,6 @@ static int gc0310_s_config(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int gc0310_g_parm(struct v4l2_subdev *sd,
-			struct v4l2_streamparm *param)
-{
-	struct gc0310_device *dev = to_gc0310_sensor(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!param)
-		return -EINVAL;
-
-	if (param->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dev_err(&client->dev,  "unsupported buffer type.\n");
-		return -EINVAL;
-	}
-
-	memset(param, 0, sizeof(*param));
-	param->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	if (dev->fmt_idx >= 0 && dev->fmt_idx < N_RES) {
-		param->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
-		param->parm.capture.timeperframe.numerator = 1;
-		param->parm.capture.timeperframe.denominator =
-			gc0310_res[dev->fmt_idx].fps;
-	}
-	return 0;
-}
-
 static int gc0310_g_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *interval)
 {
@@ -1288,7 +1262,6 @@ static const struct v4l2_subdev_sensor_ops gc0310_sensor_ops = {
 
 static const struct v4l2_subdev_video_ops gc0310_video_ops = {
 	.s_stream = gc0310_s_stream,
-	.g_parm = gc0310_g_parm,
 	.g_frame_interval = gc0310_g_frame_interval,
 };
 
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
index 2bc179f3afe5..93f9c618f3d8 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
@@ -944,32 +944,6 @@ static int gc2235_s_config(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int gc2235_g_parm(struct v4l2_subdev *sd,
-			struct v4l2_streamparm *param)
-{
-	struct gc2235_device *dev = to_gc2235_sensor(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!param)
-		return -EINVAL;
-
-	if (param->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dev_err(&client->dev,  "unsupported buffer type.\n");
-		return -EINVAL;
-	}
-
-	memset(param, 0, sizeof(*param));
-	param->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	if (dev->fmt_idx >= 0 && dev->fmt_idx < N_RES) {
-		param->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
-		param->parm.capture.timeperframe.numerator = 1;
-		param->parm.capture.timeperframe.denominator =
-			gc2235_res[dev->fmt_idx].fps;
-	}
-	return 0;
-}
-
 static int gc2235_g_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *interval)
 {
@@ -1027,7 +1001,6 @@ static const struct v4l2_subdev_sensor_ops gc2235_sensor_ops = {
 
 static const struct v4l2_subdev_video_ops gc2235_video_ops = {
 	.s_stream = gc2235_s_stream,
-	.g_parm = gc2235_g_parm,
 	.g_frame_interval = gc2235_g_frame_interval,
 };
 
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
index e3e0fdd0c816..11412061c40e 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
@@ -1280,32 +1280,6 @@ static int ov2680_s_config(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int ov2680_g_parm(struct v4l2_subdev *sd,
-			struct v4l2_streamparm *param)
-{
-	struct ov2680_device *dev = to_ov2680_sensor(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!param)
-		return -EINVAL;
-
-	if (param->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dev_err(&client->dev,  "unsupported buffer type.\n");
-		return -EINVAL;
-	}
-
-	memset(param, 0, sizeof(*param));
-	param->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	if (dev->fmt_idx >= 0 && dev->fmt_idx < N_RES) {
-		param->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
-		param->parm.capture.timeperframe.numerator = 1;
-		param->parm.capture.timeperframe.denominator =
-			ov2680_res[dev->fmt_idx].fps;
-	}
-	return 0;
-}
-
 static int ov2680_g_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *interval)
 {
@@ -1359,7 +1333,6 @@ static int ov2680_g_skip_frames(struct v4l2_subdev *sd, u32 *frames)
 
 static const struct v4l2_subdev_video_ops ov2680_video_ops = {
 	.s_stream = ov2680_s_stream,
-	.g_parm = ov2680_g_parm,
 	.g_frame_interval = ov2680_g_frame_interval,
 };
 
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
index cd9f6433cd42..e59358ac89ce 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
@@ -1083,32 +1083,6 @@ static int ov2722_s_config(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int ov2722_g_parm(struct v4l2_subdev *sd,
-			struct v4l2_streamparm *param)
-{
-	struct ov2722_device *dev = to_ov2722_sensor(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!param)
-		return -EINVAL;
-
-	if (param->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dev_err(&client->dev,  "unsupported buffer type.\n");
-		return -EINVAL;
-	}
-
-	memset(param, 0, sizeof(*param));
-	param->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	if (dev->fmt_idx >= 0 && dev->fmt_idx < N_RES) {
-		param->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
-		param->parm.capture.timeperframe.numerator = 1;
-		param->parm.capture.timeperframe.denominator =
-			ov2722_res[dev->fmt_idx].fps;
-	}
-	return 0;
-}
-
 static int ov2722_g_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *interval)
 {
@@ -1167,7 +1141,6 @@ static const struct v4l2_subdev_sensor_ops ov2722_sensor_ops = {
 
 static const struct v4l2_subdev_video_ops ov2722_video_ops = {
 	.s_stream = ov2722_s_stream,
-	.g_parm = ov2722_g_parm,
 	.g_frame_interval = ov2722_g_frame_interval,
 };
 
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
index 7f594c7de76e..56f3cd0d8c23 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
@@ -1805,32 +1805,6 @@ static int ov5693_s_config(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int ov5693_g_parm(struct v4l2_subdev *sd,
-			struct v4l2_streamparm *param)
-{
-	struct ov5693_device *dev = to_ov5693_sensor(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!param)
-		return -EINVAL;
-
-	if (param->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dev_err(&client->dev,  "unsupported buffer type.\n");
-		return -EINVAL;
-	}
-
-	memset(param, 0, sizeof(*param));
-	param->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	if (dev->fmt_idx >= 0 && dev->fmt_idx < N_RES) {
-		param->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
-		param->parm.capture.timeperframe.numerator = 1;
-		param->parm.capture.timeperframe.denominator =
-			ov5693_res[dev->fmt_idx].fps;
-	}
-	return 0;
-}
-
 static int ov5693_g_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *interval)
 {
@@ -1873,7 +1847,6 @@ static int ov5693_enum_frame_size(struct v4l2_subdev *sd,
 
 static const struct v4l2_subdev_video_ops ov5693_video_ops = {
 	.s_stream = ov5693_s_stream,
-	.g_parm = ov5693_g_parm,
 	.g_frame_interval = ov5693_g_frame_interval,
 };
 
-- 
2.15.1
