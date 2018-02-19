Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54332 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752748AbeBSOII (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 09:08:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 04/10] staging: atomisp: Kill subdev s_parm abuse
Date: Mon, 19 Feb 2018 15:07:56 +0100
Message-Id: <20180219140802.3514-5-hverkuil@xs4all.nl>
In-Reply-To: <20180219140802.3514-1-hverkuil@xs4all.nl>
References: <20180219140802.3514-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Remove sensor driver's interface for setting the use case specific mode
list as well as the mode lists that are related to other than
CI_MODE_PREVIEW. This removes s_parm abuse in using driver specific values
in v4l2_streamparm.capture.capturemode. The drivers already support
[gs]_frame_interval so removing support for [gs]_parm is enough.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c | 26 ---------
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c | 26 ---------
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c | 29 ---------
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c | 26 ---------
 drivers/staging/media/atomisp/i2c/gc0310.h         | 43 --------------
 drivers/staging/media/atomisp/i2c/gc2235.h         |  1 -
 drivers/staging/media/atomisp/i2c/ov2680.h         | 68 ----------------------
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      | 27 ---------
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |  9 +--
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    | 12 +---
 10 files changed, 3 insertions(+), 264 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
index 61b7598469eb..572c9127c24d 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
@@ -1224,37 +1224,12 @@ static int gc0310_g_parm(struct v4l2_subdev *sd,
 	if (dev->fmt_idx >= 0 && dev->fmt_idx < N_RES) {
 		param->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
 		param->parm.capture.timeperframe.numerator = 1;
-		param->parm.capture.capturemode = dev->run_mode;
 		param->parm.capture.timeperframe.denominator =
 			gc0310_res[dev->fmt_idx].fps;
 	}
 	return 0;
 }
 
-static int gc0310_s_parm(struct v4l2_subdev *sd,
-			struct v4l2_streamparm *param)
-{
-	struct gc0310_device *dev = to_gc0310_sensor(sd);
-	dev->run_mode = param->parm.capture.capturemode;
-
-	mutex_lock(&dev->input_lock);
-	switch (dev->run_mode) {
-	case CI_MODE_VIDEO:
-		gc0310_res = gc0310_res_video;
-		N_RES = N_RES_VIDEO;
-		break;
-	case CI_MODE_STILL_CAPTURE:
-		gc0310_res = gc0310_res_still;
-		N_RES = N_RES_STILL;
-		break;
-	default:
-		gc0310_res = gc0310_res_preview;
-		N_RES = N_RES_PREVIEW;
-	}
-	mutex_unlock(&dev->input_lock);
-	return 0;
-}
-
 static int gc0310_g_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *interval)
 {
@@ -1314,7 +1289,6 @@ static const struct v4l2_subdev_sensor_ops gc0310_sensor_ops = {
 static const struct v4l2_subdev_video_ops gc0310_video_ops = {
 	.s_stream = gc0310_s_stream,
 	.g_parm = gc0310_g_parm,
-	.s_parm = gc0310_s_parm,
 	.g_frame_interval = gc0310_g_frame_interval,
 };
 
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
index d8de46da64ae..2bc179f3afe5 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
@@ -964,37 +964,12 @@ static int gc2235_g_parm(struct v4l2_subdev *sd,
 	if (dev->fmt_idx >= 0 && dev->fmt_idx < N_RES) {
 		param->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
 		param->parm.capture.timeperframe.numerator = 1;
-		param->parm.capture.capturemode = dev->run_mode;
 		param->parm.capture.timeperframe.denominator =
 			gc2235_res[dev->fmt_idx].fps;
 	}
 	return 0;
 }
 
-static int gc2235_s_parm(struct v4l2_subdev *sd,
-			struct v4l2_streamparm *param)
-{
-	struct gc2235_device *dev = to_gc2235_sensor(sd);
-	dev->run_mode = param->parm.capture.capturemode;
-
-	mutex_lock(&dev->input_lock);
-	switch (dev->run_mode) {
-	case CI_MODE_VIDEO:
-		gc2235_res = gc2235_res_video;
-		N_RES = N_RES_VIDEO;
-		break;
-	case CI_MODE_STILL_CAPTURE:
-		gc2235_res = gc2235_res_still;
-		N_RES = N_RES_STILL;
-		break;
-	default:
-		gc2235_res = gc2235_res_preview;
-		N_RES = N_RES_PREVIEW;
-	}
-	mutex_unlock(&dev->input_lock);
-	return 0;
-}
-
 static int gc2235_g_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *interval)
 {
@@ -1053,7 +1028,6 @@ static const struct v4l2_subdev_sensor_ops gc2235_sensor_ops = {
 static const struct v4l2_subdev_video_ops gc2235_video_ops = {
 	.s_stream = gc2235_s_stream,
 	.g_parm = gc2235_g_parm,
-	.s_parm = gc2235_s_parm,
 	.g_frame_interval = gc2235_g_frame_interval,
 };
 
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
index 84f8d33ce2d1..e3e0fdd0c816 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
@@ -1300,40 +1300,12 @@ static int ov2680_g_parm(struct v4l2_subdev *sd,
 	if (dev->fmt_idx >= 0 && dev->fmt_idx < N_RES) {
 		param->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
 		param->parm.capture.timeperframe.numerator = 1;
-		param->parm.capture.capturemode = dev->run_mode;
 		param->parm.capture.timeperframe.denominator =
 			ov2680_res[dev->fmt_idx].fps;
 	}
 	return 0;
 }
 
-static int ov2680_s_parm(struct v4l2_subdev *sd,
-			struct v4l2_streamparm *param)
-{
-	struct ov2680_device *dev = to_ov2680_sensor(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	dev->run_mode = param->parm.capture.capturemode;
-
-	v4l2_info(client, "\n%s:run_mode :%x\n", __func__, dev->run_mode);
-
-	mutex_lock(&dev->input_lock);
-	switch (dev->run_mode) {
-	case CI_MODE_VIDEO:
-		ov2680_res = ov2680_res_video;
-		N_RES = N_RES_VIDEO;
-		break;
-	case CI_MODE_STILL_CAPTURE:
-		ov2680_res = ov2680_res_still;
-		N_RES = N_RES_STILL;
-		break;
-	default:
-		ov2680_res = ov2680_res_preview;
-		N_RES = N_RES_PREVIEW;
-	}
-	mutex_unlock(&dev->input_lock);
-	return 0;
-}
-
 static int ov2680_g_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *interval)
 {
@@ -1388,7 +1360,6 @@ static int ov2680_g_skip_frames(struct v4l2_subdev *sd, u32 *frames)
 static const struct v4l2_subdev_video_ops ov2680_video_ops = {
 	.s_stream = ov2680_s_stream,
 	.g_parm = ov2680_g_parm,
-	.s_parm = ov2680_s_parm,
 	.g_frame_interval = ov2680_g_frame_interval,
 };
 
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
index 2b6ae0faf972..cd9f6433cd42 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
@@ -1103,37 +1103,12 @@ static int ov2722_g_parm(struct v4l2_subdev *sd,
 	if (dev->fmt_idx >= 0 && dev->fmt_idx < N_RES) {
 		param->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
 		param->parm.capture.timeperframe.numerator = 1;
-		param->parm.capture.capturemode = dev->run_mode;
 		param->parm.capture.timeperframe.denominator =
 			ov2722_res[dev->fmt_idx].fps;
 	}
 	return 0;
 }
 
-static int ov2722_s_parm(struct v4l2_subdev *sd,
-			struct v4l2_streamparm *param)
-{
-	struct ov2722_device *dev = to_ov2722_sensor(sd);
-	dev->run_mode = param->parm.capture.capturemode;
-
-	mutex_lock(&dev->input_lock);
-	switch (dev->run_mode) {
-	case CI_MODE_VIDEO:
-		ov2722_res = ov2722_res_video;
-		N_RES = N_RES_VIDEO;
-		break;
-	case CI_MODE_STILL_CAPTURE:
-		ov2722_res = ov2722_res_still;
-		N_RES = N_RES_STILL;
-		break;
-	default:
-		ov2722_res = ov2722_res_preview;
-		N_RES = N_RES_PREVIEW;
-	}
-	mutex_unlock(&dev->input_lock);
-	return 0;
-}
-
 static int ov2722_g_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *interval)
 {
@@ -1193,7 +1168,6 @@ static const struct v4l2_subdev_sensor_ops ov2722_sensor_ops = {
 static const struct v4l2_subdev_video_ops ov2722_video_ops = {
 	.s_stream = ov2722_s_stream,
 	.g_parm = ov2722_g_parm,
-	.s_parm = ov2722_s_parm,
 	.g_frame_interval = ov2722_g_frame_interval,
 };
 
diff --git a/drivers/staging/media/atomisp/i2c/gc0310.h b/drivers/staging/media/atomisp/i2c/gc0310.h
index c422d0398fc7..af6b11f6e5e7 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.h
+++ b/drivers/staging/media/atomisp/i2c/gc0310.h
@@ -150,7 +150,6 @@ struct gc0310_device {
 	struct camera_sensor_platform_data *platform_data;
 	int vt_pix_clk_freq_mhz;
 	int fmt_idx;
-	int run_mode;
 	u8 res;
 	u8 type;
 };
@@ -400,48 +399,6 @@ struct gc0310_resolution gc0310_res_preview[] = {
 };
 #define N_RES_PREVIEW (ARRAY_SIZE(gc0310_res_preview))
 
-struct gc0310_resolution gc0310_res_still[] = {
-	{
-		.desc = "gc0310_VGA_30fps",
-		.width = 656, // 648,
-		.height = 496, // 488,
-		.fps = 30,
-		//.pix_clk_freq = 73,
-		.used = 0,
-#if 0
-		.pixels_per_line = 0x0314,
-		.lines_per_frame = 0x0213,
-#endif
-		.bin_factor_x = 1,
-		.bin_factor_y = 1,
-		.bin_mode = 0,
-		.skip_frames = 2,
-		.regs = gc0310_VGA_30fps,
-	},
-};
-#define N_RES_STILL (ARRAY_SIZE(gc0310_res_still))
-
-struct gc0310_resolution gc0310_res_video[] = {
-	{
-		.desc = "gc0310_VGA_30fps",
-		.width = 656, // 648,
-		.height = 496, // 488,
-		.fps = 30,
-		//.pix_clk_freq = 73,
-		.used = 0,
-#if 0
-		.pixels_per_line = 0x0314,
-		.lines_per_frame = 0x0213,
-#endif
-		.bin_factor_x = 1,
-		.bin_factor_y = 1,
-		.bin_mode = 0,
-		.skip_frames = 2,
-		.regs = gc0310_VGA_30fps,
-	},
-};
-#define N_RES_VIDEO (ARRAY_SIZE(gc0310_res_video))
-
 static struct gc0310_resolution *gc0310_res = gc0310_res_preview;
 static unsigned long N_RES = N_RES_PREVIEW;
 #endif
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.h b/drivers/staging/media/atomisp/i2c/gc2235.h
index 3c30a05c3991..45a54fea5466 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.h
+++ b/drivers/staging/media/atomisp/i2c/gc2235.h
@@ -156,7 +156,6 @@ struct gc2235_device {
 	struct camera_sensor_platform_data *platform_data;
 	int vt_pix_clk_freq_mhz;
 	int fmt_idx;
-	int run_mode;
 	u8 res;
 	u8 type;
 };
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.h b/drivers/staging/media/atomisp/i2c/ov2680.h
index 03f75dd80f87..cb38e6e79409 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.h
+++ b/drivers/staging/media/atomisp/i2c/ov2680.h
@@ -850,74 +850,6 @@ struct ov2680_format {
 };
 #define N_RES_PREVIEW (ARRAY_SIZE(ov2680_res_preview))
 
-static struct ov2680_resolution ov2680_res_still[] = {
-	{
-		.desc = "ov2680_1616x1216_30fps",
-		.width = 1616,
-		.height = 1216,
-		.pix_clk_freq = 66,
-		.fps = 30,
-		.used = 0,
-		.pixels_per_line = 1698,//1704,
-		.lines_per_frame = 1294,
-		.bin_factor_x = 0,
-		.bin_factor_y = 0,
-		.bin_mode = 0,
-		.skip_frames = 3,
-		.regs = ov2680_1616x1216_30fps,
-	},
-   	{
-		.desc = "ov2680_1616x916_30fps",
-		.width = 1616,
-		.height = 916,
-		.fps = 30,
-		.pix_clk_freq = 66,
-		.used = 0,
-		.pixels_per_line = 1698,//1704,
-		.lines_per_frame = 1294,
-		.bin_factor_x = 0,
-		.bin_factor_y = 0,
-		.bin_mode = 0,
-		.skip_frames = 3,
-		.regs = ov2680_1616x916_30fps,
-	},
-};
-#define N_RES_STILL (ARRAY_SIZE(ov2680_res_still))
-
-static struct ov2680_resolution ov2680_res_video[] = {
-	{
-		.desc = "ov2680_1616x1216_30fps",
-		.width = 1616,
-		.height = 1216,
-		.pix_clk_freq = 66,
-		.fps = 30,
-		.used = 0,
-		.pixels_per_line = 1698,//1704,
-		.lines_per_frame = 1294,
-		.bin_factor_x = 0,
-		.bin_factor_y = 0,
-		.bin_mode = 0,
-		.skip_frames = 3,
-		.regs = ov2680_1616x1216_30fps,
-	},
-	{
-		.desc = "ov2680_720p_30fps",
-		.width = 1616,
-		.height = 916,
-		.fps = 30,
-		.pix_clk_freq = 66,
-		.used = 0,
-		.pixels_per_line = 1698,//1704,
-		.lines_per_frame = 1294,
-		.bin_factor_x = 0,
-		.bin_factor_y = 0,
-		.bin_mode = 0,
-		.skip_frames = 3,
-		.regs = ov2680_1616x916_30fps,
-	},
-};
-#define N_RES_VIDEO (ARRAY_SIZE(ov2680_res_video))
-
 static struct ov2680_resolution *ov2680_res = ov2680_res_preview;
 static unsigned long N_RES = N_RES_PREVIEW;
 
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
index 40d01bf4bf28..7f594c7de76e 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
@@ -1825,38 +1825,12 @@ static int ov5693_g_parm(struct v4l2_subdev *sd,
 	if (dev->fmt_idx >= 0 && dev->fmt_idx < N_RES) {
 		param->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
 		param->parm.capture.timeperframe.numerator = 1;
-		param->parm.capture.capturemode = dev->run_mode;
 		param->parm.capture.timeperframe.denominator =
 			ov5693_res[dev->fmt_idx].fps;
 	}
 	return 0;
 }
 
-static int ov5693_s_parm(struct v4l2_subdev *sd,
-			struct v4l2_streamparm *param)
-{
-	struct ov5693_device *dev = to_ov5693_sensor(sd);
-
-	dev->run_mode = param->parm.capture.capturemode;
-
-	mutex_lock(&dev->input_lock);
-	switch (dev->run_mode) {
-	case CI_MODE_VIDEO:
-		ov5693_res = ov5693_res_video;
-		N_RES = N_RES_VIDEO;
-		break;
-	case CI_MODE_STILL_CAPTURE:
-		ov5693_res = ov5693_res_still;
-		N_RES = N_RES_STILL;
-		break;
-	default:
-		ov5693_res = ov5693_res_preview;
-		N_RES = N_RES_PREVIEW;
-	}
-	mutex_unlock(&dev->input_lock);
-	return 0;
-}
-
 static int ov5693_g_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *interval)
 {
@@ -1900,7 +1874,6 @@ static int ov5693_enum_frame_size(struct v4l2_subdev *sd,
 static const struct v4l2_subdev_video_ops ov5693_video_ops = {
 	.s_stream = ov5693_s_stream,
 	.g_parm = ov5693_g_parm,
-	.s_parm = ov5693_s_parm,
 	.g_frame_interval = ov5693_g_frame_interval,
 };
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index debf0e3853ff..3410a7fb1fcf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -2091,7 +2091,7 @@ int atomisp_set_sensor_runmode(struct atomisp_sub_device *asd,
 	struct atomisp_device *isp = asd->isp;
 	struct v4l2_ctrl *c;
 	struct v4l2_streamparm p = {0};
-	int ret;
+	int ret = 0;
 	int modes[] = { CI_MODE_NONE,
 			CI_MODE_VIDEO,
 			CI_MODE_STILL_CAPTURE,
@@ -2105,13 +2105,8 @@ int atomisp_set_sensor_runmode(struct atomisp_sub_device *asd,
 	c = v4l2_ctrl_find(isp->inputs[asd->input_curr].camera->ctrl_handler,
 			   V4L2_CID_RUN_MODE);
 
-	if (c) {
+	if (c)
 		ret = v4l2_ctrl_s_ctrl(c, runmode->mode);
-	} else {
-		p.parm.capture.capturemode = modes[runmode->mode];
-		ret = v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
-				       video, s_parm, &p);
-	}
 
 	mutex_unlock(asd->ctrl_handler.lock);
 	return ret;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
index f3e18d627b0a..b78276ac22da 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
@@ -819,12 +819,6 @@ static int __atomisp_update_run_mode(struct atomisp_sub_device *asd)
 	struct atomisp_device *isp = asd->isp;
 	struct v4l2_ctrl *ctrl = asd->run_mode;
 	struct v4l2_ctrl *c;
-	struct v4l2_streamparm p = {0};
-	int modes[] = { CI_MODE_NONE,
-			CI_MODE_VIDEO,
-			CI_MODE_STILL_CAPTURE,
-			CI_MODE_CONTINUOUS,
-			CI_MODE_PREVIEW };
 	s32 mode;
 
 	if (ctrl->val != ATOMISP_RUN_MODE_VIDEO &&
@@ -840,11 +834,7 @@ static int __atomisp_update_run_mode(struct atomisp_sub_device *asd)
 	if (c)
 		return v4l2_ctrl_s_ctrl(c, mode);
 
-	/* Fall back to obsolete s_parm */
-	p.parm.capture.capturemode = modes[mode];
-
-	return v4l2_subdev_call(
-		isp->inputs[asd->input_curr].camera, video, s_parm, &p);
+	return 0;
 }
 
 int atomisp_update_run_mode(struct atomisp_sub_device *asd)
-- 
2.15.1
