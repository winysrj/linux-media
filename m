Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57185 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730466AbeK0VAs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 16:00:48 -0500
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: enrico.scholz@sigma-chemnitz.de, devicetree@vger.kernel.org,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        graphics@pengutronix.de,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH v3 3/6] media: mt9m111: add support to select formats and fps for {Q,SXGA}
Date: Tue, 27 Nov 2018 11:02:50 +0100
Message-Id: <20181127100253.30845-4-m.felsch@pengutronix.de>
In-Reply-To: <20181127100253.30845-1-m.felsch@pengutronix.de>
References: <20181127100253.30845-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

This patch implements the framerate selection using the skipping and
readout power-modi features. The power-modi cut the framerate by half
and each context has an independent selection bit. The same applies to
the 2x skipping feature.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>

---
Changelog

v3:
- check if sensor window size is set to default and return if not
- check if requested fps is supported by image size and do not update
  the image size if requested fps is not supported by selected image
  size
- update fps mode only if a mode was found

v2:
- fix updating read mode register, use mt9m111_reg_mask() to update the
  relevant bits only. For this purpose add reg_mask field to
  struct mt9m111_mode_info.

 drivers/media/i2c/mt9m111.c | 165 ++++++++++++++++++++++++++++++++++++
 1 file changed, 165 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 9b0a3689fa98..f97fd32181ed 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -129,6 +129,8 @@
 #define MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr_RGB_R_B	(1 << 0)
 #define MT9M111_TPG_SEL_MASK		GENMASK(2, 0)
 #define MT9M111_EFFECTS_MODE_MASK	GENMASK(2, 0)
+#define MT9M111_RM_PWR_MASK		BIT(10)
+#define MT9M111_RM_SKIP2_MASK		GENMASK(3, 2)
 
 /*
  * Camera control register addresses (0x200..0x2ff not implemented)
@@ -207,6 +209,23 @@ static const struct mt9m111_datafmt mt9m111_colour_fmts[] = {
 	{MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
 };
 
+enum mt9m111_mode_id {
+	MT9M111_MODE_SXGA_8FPS,
+	MT9M111_MODE_SXGA_15FPS,
+	MT9M111_MODE_QSXGA_30FPS,
+	MT9M111_NUM_MODES,
+};
+
+struct mt9m111_mode_info {
+	unsigned int sensor_w;
+	unsigned int sensor_h;
+	unsigned int max_image_w;
+	unsigned int max_image_h;
+	unsigned int max_fps;
+	unsigned int reg_val;
+	unsigned int reg_mask;
+};
+
 struct mt9m111 {
 	struct v4l2_subdev subdev;
 	struct v4l2_ctrl_handler hdl;
@@ -216,6 +235,8 @@ struct mt9m111 {
 	struct v4l2_clk *clk;
 	unsigned int width;	/* output */
 	unsigned int height;	/* sizes */
+	struct v4l2_fract frame_interval;
+	const struct mt9m111_mode_info *current_mode;
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
 	const struct mt9m111_datafmt *fmt;
@@ -226,6 +247,37 @@ struct mt9m111 {
 #endif
 };
 
+static const struct mt9m111_mode_info mt9m111_mode_data[MT9M111_NUM_MODES] = {
+	[MT9M111_MODE_SXGA_8FPS] = {
+		.sensor_w = 1280,
+		.sensor_h = 1024,
+		.max_image_w = 1280,
+		.max_image_h = 1024,
+		.max_fps = 8,
+		.reg_val = MT9M111_RM_LOW_POWER_RD,
+		.reg_mask = MT9M111_RM_PWR_MASK | MT9M111_RM_SKIP2_MASK,
+	},
+	[MT9M111_MODE_SXGA_15FPS] = {
+		.sensor_w = 1280,
+		.sensor_h = 1024,
+		.max_image_w = 1280,
+		.max_image_h = 1024,
+		.max_fps = 15,
+		.reg_val = MT9M111_RM_FULL_POWER_RD,
+		.reg_mask = MT9M111_RM_PWR_MASK | MT9M111_RM_SKIP2_MASK,
+	},
+	[MT9M111_MODE_QSXGA_30FPS] = {
+		.sensor_w = 1280,
+		.sensor_h = 1024,
+		.max_image_w = 640,
+		.max_image_h = 512,
+		.max_fps = 30,
+		.reg_val = MT9M111_RM_LOW_POWER_RD | MT9M111_RM_COL_SKIP_2X |
+			   MT9M111_RM_ROW_SKIP_2X,
+		.reg_mask = MT9M111_RM_PWR_MASK | MT9M111_RM_SKIP2_MASK,
+	},
+};
+
 /* Find a data format by a pixel code */
 static const struct mt9m111_datafmt *mt9m111_find_datafmt(struct mt9m111 *mt9m111,
 						u32 code)
@@ -618,6 +670,61 @@ static int mt9m111_set_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static const struct mt9m111_mode_info *
+mt9m111_find_mode(struct mt9m111 *mt9m111, unsigned int req_fps,
+		  unsigned int width, unsigned int height)
+{
+	const struct mt9m111_mode_info *mode;
+	struct v4l2_rect *sensor_rect = &mt9m111->rect;
+	unsigned int gap, gap_best = (unsigned int) -1;
+	int i, best_gap_idx = MT9M111_MODE_SXGA_15FPS;
+	bool skip_30fps = false;
+
+	/*
+	 * The fps selection is based on the row, column skipping mechanism.
+	 * So ensure that the sensor window is set to default else the fps
+	 * aren't calculated correctly within the sensor hw.
+	 */
+	if (sensor_rect->width != MT9M111_MAX_WIDTH ||
+	    sensor_rect->height != MT9M111_MAX_HEIGHT) {
+		dev_info(mt9m111->subdev.dev,
+			 "Framerate selection is not supported for cropped "
+			 "images\n");
+		return NULL;
+	}
+
+	/* 30fps only supported for images not exceeding 640x512 */
+	if (width > MT9M111_MAX_WIDTH / 2 || height > MT9M111_MAX_HEIGHT / 2) {
+		dev_dbg(mt9m111->subdev.dev,
+			"Framerates > 15fps are supported only for images "
+			"not exceeding 640x512\n");
+		skip_30fps = true;
+	}
+
+	/* find best matched fps */
+	for (i = 0; i < MT9M111_NUM_MODES; i++) {
+		unsigned int fps = mt9m111_mode_data[i].max_fps;
+
+		if (fps == 30 && skip_30fps)
+			continue;
+
+		gap = abs(fps - req_fps);
+		if (gap < gap_best) {
+			best_gap_idx = i;
+			gap_best = gap;
+		}
+	}
+
+	/*
+	 * Use context a/b default timing values instead of calculate blanking
+	 * timing values.
+	 */
+	mode = &mt9m111_mode_data[best_gap_idx];
+	mt9m111->ctx = (best_gap_idx == MT9M111_MODE_QSXGA_30FPS) ? &context_a :
+								    &context_b;
+	return mode;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9m111_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
@@ -803,11 +910,16 @@ static int mt9m111_suspend(struct mt9m111 *mt9m111)
 
 static void mt9m111_restore_state(struct mt9m111 *mt9m111)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
+
 	mt9m111_set_context(mt9m111, mt9m111->ctx);
 	mt9m111_set_pixfmt(mt9m111, mt9m111->fmt->code);
 	mt9m111_setup_geometry(mt9m111, &mt9m111->rect,
 			mt9m111->width, mt9m111->height, mt9m111->fmt->code);
 	v4l2_ctrl_handler_setup(&mt9m111->hdl);
+	mt9m111_reg_mask(client, mt9m111->ctx->read_mode,
+			 mt9m111->current_mode->reg_val,
+			 mt9m111->current_mode->reg_mask);
 }
 
 static int mt9m111_resume(struct mt9m111 *mt9m111)
@@ -903,6 +1015,53 @@ static const struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
 #endif
 };
 
+static int mt9m111_g_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *fi)
+{
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
+
+	fi->interval = mt9m111->frame_interval;
+
+	return 0;
+}
+
+static int mt9m111_s_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *fi)
+{
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
+	const struct mt9m111_mode_info *mode;
+	struct v4l2_fract *fract = &fi->interval;
+	int fps;
+
+	if (mt9m111->is_streaming)
+		return -EBUSY;
+
+	if (fi->pad != 0)
+		return -EINVAL;
+
+	if (fract->numerator == 0) {
+		fract->denominator = 30;
+		fract->numerator = 1;
+	}
+
+	fps = DIV_ROUND_CLOSEST(fract->denominator, fract->numerator);
+
+	/* Find best fitting mode. Do not update the mode if no one was found. */
+	mode = mt9m111_find_mode(mt9m111, fps, mt9m111->width, mt9m111->height);
+	if (!mode)
+		return 0;
+
+	if (mode->max_fps != fps) {
+		fract->denominator = mode->max_fps;
+		fract->numerator = 1;
+	}
+
+	mt9m111->current_mode = mode;
+	mt9m111->frame_interval = fi->interval;
+
+	return 0;
+}
+
 static int mt9m111_enum_mbus_code(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_mbus_code_enum *code)
@@ -936,6 +1095,8 @@ static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 static const struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 	.g_mbus_config	= mt9m111_g_mbus_config,
 	.s_stream	= mt9m111_s_stream,
+	.g_frame_interval = mt9m111_g_frame_interval,
+	.s_frame_interval = mt9m111_s_frame_interval,
 };
 
 static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
@@ -1061,6 +1222,10 @@ static int mt9m111_probe(struct i2c_client *client,
 		goto out_hdlfree;
 #endif
 
+	mt9m111->current_mode = &mt9m111_mode_data[MT9M111_MODE_SXGA_15FPS];
+	mt9m111->frame_interval.numerator = 1;
+	mt9m111->frame_interval.denominator = mt9m111->current_mode->max_fps;
+
 	/* Second stage probe - when a capture adapter is there */
 	mt9m111->rect.left	= MT9M111_MIN_DARK_COLS;
 	mt9m111->rect.top	= MT9M111_MIN_DARK_ROWS;
-- 
2.19.1
