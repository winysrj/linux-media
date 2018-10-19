Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33945 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbeJSX5X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 19:57:23 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com
Cc: akinobu.mita@gmail.com, enrico.scholz@sigma-chemnitz.de,
        linux-media@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de
Subject: [PATCH 3/4] media: mt9m111: add support to select formats and fps for {Q,SXGA}
Date: Fri, 19 Oct 2018 17:50:26 +0200
Message-Id: <20181019155027.28682-4-m.felsch@pengutronix.de>
In-Reply-To: <20181019155027.28682-1-m.felsch@pengutronix.de>
References: <20181019155027.28682-1-m.felsch@pengutronix.de>
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
 drivers/media/i2c/mt9m111.c | 156 ++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index d060075a670b..13080c6c1ba3 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -204,6 +204,22 @@ static const struct mt9m111_datafmt mt9m111_colour_fmts[] = {
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
+};
+
 struct mt9m111 {
 	struct v4l2_subdev subdev;
 	struct v4l2_ctrl_handler hdl;
@@ -213,6 +229,8 @@ struct mt9m111 {
 	struct v4l2_clk *clk;
 	unsigned int width;	/* output */
 	unsigned int height;	/* sizes */
+	struct v4l2_fract frame_interval;
+	const struct mt9m111_mode_info *current_mode;
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
 	const struct mt9m111_datafmt *fmt;
@@ -223,6 +241,34 @@ struct mt9m111 {
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
+	},
+	[MT9M111_MODE_SXGA_15FPS] = {
+		.sensor_w = 1280,
+		.sensor_h = 1024,
+		.max_image_w = 1280,
+		.max_image_h = 1024,
+		.max_fps = 15,
+		.reg_val = MT9M111_RM_FULL_POWER_RD,
+	},
+	[MT9M111_MODE_QSXGA_30FPS] = {
+		.sensor_w = 1280,
+		.sensor_h = 1024,
+		.max_image_w = 640,
+		.max_image_h = 512,
+		.max_fps = 30,
+		.reg_val = MT9M111_RM_LOW_POWER_RD | MT9M111_RM_COL_SKIP_2X |
+			   MT9M111_RM_ROW_SKIP_2X,
+	},
+};
+
 /* Find a data format by a pixel code */
 static const struct mt9m111_datafmt *mt9m111_find_datafmt(struct mt9m111 *mt9m111,
 						u32 code)
@@ -616,6 +662,62 @@ static int mt9m111_set_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static const struct mt9m111_mode_info *
+mt9m111_find_mode(struct mt9m111 *mt9m111, unsigned int req_fps,
+		  unsigned int width, unsigned int height)
+{
+	const struct mt9m111_mode_info *mode;
+	struct v4l2_rect *sensor_rect = &mt9m111->rect;
+	unsigned int gap, gap_best = (unsigned int) -1;
+	int i, best_gap_idx = 1;
+
+	/* find best matched fps */
+	for (i = 0; i < MT9M111_NUM_MODES; i++) {
+		unsigned int fps = mt9m111_mode_data[i].max_fps;
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
+
+	/*
+	 * Check if current settings support the fps because fps selection is
+	 * based on the row/col skipping mechanism which has some restriction.
+	 */
+	if (sensor_rect->width != mode->sensor_w ||
+	    sensor_rect->height != mode->sensor_h ||
+	    width > mode->max_image_w ||
+	    height > mode->max_image_h) {
+		/* reset sensor window size */
+		mt9m111->rect.left = MT9M111_MIN_DARK_COLS;
+		mt9m111->rect.top = MT9M111_MIN_DARK_ROWS;
+		mt9m111->rect.width = mode->sensor_w;
+		mt9m111->rect.height = mode->sensor_h;
+
+		/* reset image size */
+		mt9m111->width = mode->max_image_w;
+		mt9m111->height = mode->max_image_h;
+
+		dev_warn(mt9m111->subdev.dev,
+			 "Warning: update image size %dx%d[%dx%d] -> %dx%d[%dx%d]\n",
+			 sensor_rect->width, sensor_rect->height, width, height,
+			 mode->sensor_w, mode->sensor_h, mode->max_image_w,
+			 mode->max_image_h);
+	}
+
+	return mode;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9m111_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
@@ -776,11 +878,15 @@ static int mt9m111_suspend(struct mt9m111 *mt9m111)
 
 static void mt9m111_restore_state(struct mt9m111 *mt9m111)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
+
 	mt9m111_set_context(mt9m111, mt9m111->ctx);
 	mt9m111_set_pixfmt(mt9m111, mt9m111->fmt->code);
 	mt9m111_setup_geometry(mt9m111, &mt9m111->rect,
 			mt9m111->width, mt9m111->height, mt9m111->fmt->code);
 	v4l2_ctrl_handler_setup(&mt9m111->hdl);
+	mt9m111_reg_write(client, mt9m111->ctx->read_mode,
+			  mt9m111->current_mode->reg_val);
 }
 
 static int mt9m111_resume(struct mt9m111 *mt9m111)
@@ -873,6 +979,50 @@ static const struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
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
+	/* find best fitting mode */
+	mode = mt9m111_find_mode(mt9m111, fps, mt9m111->width, mt9m111->height);
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
@@ -906,6 +1056,8 @@ static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 static const struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 	.g_mbus_config	= mt9m111_g_mbus_config,
 	.s_stream	= mt9m111_s_stream,
+	.g_frame_interval = mt9m111_g_frame_interval,
+	.s_frame_interval = mt9m111_s_frame_interval,
 };
 
 static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
@@ -1022,6 +1174,10 @@ static int mt9m111_probe(struct i2c_client *client,
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
2.19.0
