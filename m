Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51805 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab1HaPF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 11:05:59 -0400
Received: by bke11 with SMTP id 11so907875bke.19
        for <linux-media@vger.kernel.org>; Wed, 31 Aug 2011 08:05:57 -0700 (PDT)
Date: Wed, 31 Aug 2011 15:05:52 +0000 (UTC)
From: Bastian Hecht <hechtb@googlemail.com>
To: linux-media@vger.kernel.org
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 1/2 v2] media: Add support for arbitrary resolution for the
 ov5642 camera driver
Message-ID: <alpine.DEB.2.02.1108311420540.2154@ipanema>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the ability to get arbitrary resolutions with a width
up to 2592 and a height up to 720 pixels instead of the standard 1280x720
only.

Signed-off-by: Bastian Hecht <hechtb@gmail.com>
---
diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index 6410bda..87b432e 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -14,8 +14,10 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
@@ -34,7 +36,7 @@
 #define REG_WINDOW_START_Y_LOW		0x3803
 #define REG_WINDOW_WIDTH_HIGH		0x3804
 #define REG_WINDOW_WIDTH_LOW		0x3805
-#define REG_WINDOW_HEIGHT_HIGH 		0x3806
+#define REG_WINDOW_HEIGHT_HIGH		0x3806
 #define REG_WINDOW_HEIGHT_LOW		0x3807
 #define REG_OUT_WIDTH_HIGH		0x3808
 #define REG_OUT_WIDTH_LOW		0x3809
@@ -44,19 +46,44 @@
 #define REG_OUT_TOTAL_WIDTH_LOW		0x380d
 #define REG_OUT_TOTAL_HEIGHT_HIGH	0x380e
 #define REG_OUT_TOTAL_HEIGHT_LOW	0x380f
+#define REG_OUTPUT_FORMAT		0x4300
+#define REG_ISP_CTRL_01			0x5001
+#define REG_AVG_WINDOW_END_X_HIGH	0x5682
+#define REG_AVG_WINDOW_END_X_LOW	0x5683
+#define REG_AVG_WINDOW_END_Y_HIGH	0x5686
+#define REG_AVG_WINDOW_END_Y_LOW	0x5687
+
+/* active pixel array size */
+#define OV5642_SENSOR_SIZE_X	2592
+#define OV5642_SENSOR_SIZE_Y	1944
 
 /*
- * define standard resolution.
- * Works currently only for up to 720 lines
- * eg. 320x240, 640x480, 800x600, 1280x720, 2048x720
+ * About OV5642 resolution, cropping and binning:
+ * This sensor supports it all, at least in the feature description.
+ * Unfortunately, no combination of appropriate registers settings could make
+ * the chip work the intended way. As it works with predefined register lists,
+ * some undocumented registers are presumably changed there to achieve their
+ * goals.
+ * This driver currently only works for resolutions up to 720 lines with a
+ * 1:1 scale. Hopefully these restrictions will be removed in the future.
  */
+#define OV5642_MAX_WIDTH	OV5642_SENSOR_SIZE_X
+#define OV5642_MAX_HEIGHT	720
 
-#define OV5642_WIDTH		1280
-#define OV5642_HEIGHT		720
-#define OV5642_TOTAL_WIDTH	3200
-#define OV5642_TOTAL_HEIGHT	2000
-#define OV5642_SENSOR_SIZE_X	2592
-#define OV5642_SENSOR_SIZE_Y	1944
+/* default sizes */
+#define OV5642_DEFAULT_WIDTH	1280
+#define OV5642_DEFAULT_HEIGHT	OV5642_MAX_HEIGHT
+
+/* minimum extra blanking */
+#define BLANKING_EXTRA_WIDTH		500
+#define BLANKING_EXTRA_HEIGHT		20
+
+/*
+ * the sensor's autoexposure is buggy when setting total_height low.
+ * It tries to expose longer than 1 frame period without taking care of it
+ * and this leads to weird output. So we set 1000 lines as minimum.
+ */
+#define BLANKING_MIN_HEIGHT		1000
 
 struct regval_list {
 	u16 reg_num;
@@ -578,9 +605,20 @@ struct ov5642_datafmt {
 	enum v4l2_colorspace		colorspace;
 };
 
+/* the output resolution and blanking information */
+struct ov5642_out_size {
+	int width;
+	int height;
+	int total_width;
+	int total_height;
+};
+
 struct ov5642 {
 	struct v4l2_subdev		subdev;
+
 	const struct ov5642_datafmt	*fmt;
+	struct v4l2_rect                crop_rect;
+	struct ov5642_out_size		out_size;
 };
 
 static const struct ov5642_datafmt ov5642_colour_fmts[] = {
@@ -641,6 +679,21 @@ static int reg_write(struct i2c_client *client, u16 reg, u8 val)
 
 	return 0;
 }
+
+/*
+ * convenience function to write 16 bit register values that are split up
+ * into two consecutive high and low parts
+ */
+static int reg_write16(struct i2c_client *client, u16 reg, u16 val16)
+{
+	int ret;
+
+	ret = reg_write(client, reg, val16 >> 8);
+	if (ret)
+		return ret;
+	return reg_write(client, reg + 1, val16 & 0x00ff);
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ov5642_get_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
@@ -684,107 +737,101 @@ static int ov5642_write_array(struct i2c_client *client,
 	return 0;
 }
 
-static int ov5642_set_resolution(struct i2c_client *client)
+static int ov5642_set_resolution(struct v4l2_subdev *sd)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov5642 *priv = to_ov5642(client);
+	int width = priv->out_size.width;
+	int height = priv->out_size.height;
+	int total_width = priv->out_size.total_width;
+	int total_height = priv->out_size.total_height;
+	int start_x = (OV5642_SENSOR_SIZE_X - width) / 2;
+	int start_y = (OV5642_SENSOR_SIZE_Y - height) / 2;
 	int ret;
-	u8 start_x_high = ((OV5642_SENSOR_SIZE_X - OV5642_WIDTH) / 2) >> 8;
-	u8 start_x_low  = ((OV5642_SENSOR_SIZE_X - OV5642_WIDTH) / 2) & 0xff;
-	u8 start_y_high = ((OV5642_SENSOR_SIZE_Y - OV5642_HEIGHT) / 2) >> 8;
-	u8 start_y_low  = ((OV5642_SENSOR_SIZE_Y - OV5642_HEIGHT) / 2) & 0xff;
-
-	u8 width_high	= OV5642_WIDTH  >> 8;
-	u8 width_low	= OV5642_WIDTH  & 0xff;
-	u8 height_high	= OV5642_HEIGHT >> 8;
-	u8 height_low	= OV5642_HEIGHT & 0xff;
-
-	u8 total_width_high  = OV5642_TOTAL_WIDTH  >> 8;
-	u8 total_width_low   = OV5642_TOTAL_WIDTH  & 0xff;
-	u8 total_height_high = OV5642_TOTAL_HEIGHT >> 8;
-	u8 total_height_low  = OV5642_TOTAL_HEIGHT & 0xff;
-
-	ret = reg_write(client, REG_WINDOW_START_X_HIGH, start_x_high);
-	if (!ret)
-		ret = reg_write(client, REG_WINDOW_START_X_LOW, start_x_low);
-	if (!ret)
-		ret = reg_write(client, REG_WINDOW_START_Y_HIGH, start_y_high);
-	if (!ret)
-		ret = reg_write(client, REG_WINDOW_START_Y_LOW, start_y_low);
 
+	/* 
+	 * This should set the starting point for cropping.
+	 * Doesn't work so far.
+	 */ 
+	ret = reg_write16(client, REG_WINDOW_START_X_HIGH, start_x);
 	if (!ret)
-		ret = reg_write(client, REG_WINDOW_WIDTH_HIGH, width_high);
-	if (!ret)
-		ret = reg_write(client, REG_WINDOW_WIDTH_LOW , width_low);
-	if (!ret)
-		ret = reg_write(client, REG_WINDOW_HEIGHT_HIGH, height_high);
-	if (!ret)
-		ret = reg_write(client, REG_WINDOW_HEIGHT_LOW,  height_low);
+		ret = reg_write16(client, REG_WINDOW_START_Y_HIGH, start_y);
+	if (!ret) {
+		priv->crop_rect.left = start_x;
+		priv->crop_rect.top = start_y;
+	}
 
 	if (!ret)
-		ret = reg_write(client, REG_OUT_WIDTH_HIGH, width_high);
-	if (!ret)
-		ret = reg_write(client, REG_OUT_WIDTH_LOW , width_low);
+		ret = reg_write16(client, REG_WINDOW_WIDTH_HIGH, width);
 	if (!ret)
-		ret = reg_write(client, REG_OUT_HEIGHT_HIGH, height_high);
+		ret = reg_write16(client, REG_WINDOW_HEIGHT_HIGH, height);
+	if (ret)
+		return ret;
+	priv->crop_rect.width = width;
+	priv->crop_rect.height = height;
+
+	/* Set the output window size. Only 1:1 scale is supported so far. */
+	ret = reg_write16(client, REG_OUT_WIDTH_HIGH, width);
 	if (!ret)
-		ret = reg_write(client, REG_OUT_HEIGHT_LOW,  height_low);
+		ret = reg_write16(client, REG_OUT_HEIGHT_HIGH, height);
 
+	/* Total width = output size + blanking */
 	if (!ret)
-		ret = reg_write(client, REG_OUT_TOTAL_WIDTH_HIGH, total_width_high);
+		ret = reg_write16(client, REG_OUT_TOTAL_WIDTH_HIGH, total_width);
 	if (!ret)
-		ret = reg_write(client, REG_OUT_TOTAL_WIDTH_LOW, total_width_low);
+		ret = reg_write16(client, REG_OUT_TOTAL_HEIGHT_HIGH, total_height);
+
+	/* Sets the window for AWB calculations */
 	if (!ret)
-		ret = reg_write(client, REG_OUT_TOTAL_HEIGHT_HIGH, total_height_high);
+		ret = reg_write16(client, REG_AVG_WINDOW_END_X_HIGH, width);
 	if (!ret)
-		ret = reg_write(client, REG_OUT_TOTAL_HEIGHT_LOW,  total_height_low);
+		ret = reg_write16(client, REG_AVG_WINDOW_END_Y_HIGH, height);
 
 	return ret;
 }
 
-static int ov5642_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *mf)
+static int ov5642_try_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov5642 *priv = to_ov5642(client);
 	const struct ov5642_datafmt *fmt = ov5642_find_datafmt(mf->code);
 
-	dev_dbg(sd->v4l2_dev->dev, "%s(%u) width: %u heigth: %u\n",
-			__func__, mf->code, mf->width, mf->height);
+	mf->width = priv->out_size.width;
+	mf->height = priv->out_size.height;
 
 	if (!fmt) {
 		mf->code	= ov5642_colour_fmts[0].code;
 		mf->colorspace	= ov5642_colour_fmts[0].colorspace;
 	}
 
-	mf->width	= OV5642_WIDTH;
-	mf->height	= OV5642_HEIGHT;
 	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int ov5642_s_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int ov5642_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov5642 *priv = to_ov5642(client);
-
-	dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
+	int ret;
 
 	/* MIPI CSI could have changed the format, double-check */
 	if (!ov5642_find_datafmt(mf->code))
 		return -EINVAL;
 
 	ov5642_try_fmt(sd, mf);
-
 	priv->fmt = ov5642_find_datafmt(mf->code);
 
-	ov5642_write_array(client, ov5642_default_regs_init);
-	ov5642_set_resolution(client);
-	ov5642_write_array(client, ov5642_default_regs_finalise);
+	ret = ov5642_write_array(client, ov5642_default_regs_init);
+	if (!ret)
+		ret = ov5642_set_resolution(sd);
+	if (!ret)
+		ret = ov5642_write_array(client, ov5642_default_regs_finalise);
 
-	return 0;
+	return ret;
 }
 
-static int ov5642_g_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int ov5642_g_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov5642 *priv = to_ov5642(client);
@@ -793,8 +840,8 @@ static int ov5642_g_fmt(struct v4l2_subdev *sd,
 
 	mf->code	= fmt->code;
 	mf->colorspace	= fmt->colorspace;
-	mf->width	= OV5642_WIDTH;
-	mf->height	= OV5642_HEIGHT;
+	mf->width	= priv->out_size.width;
+	mf->height	= priv->out_size.height;
 	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
@@ -827,15 +874,42 @@ static int ov5642_g_chip_ident(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int ov5642_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov5642 *priv = to_ov5642(client);
+	struct v4l2_rect *rect = &a->c;
+	int ret;
+
+	v4l_bound_align_image(&rect->width, 48, OV5642_MAX_WIDTH, 1,
+			      &rect->height, 32, OV5642_MAX_HEIGHT, 1, 0);
+
+	priv->out_size.width		= rect->width;
+	priv->out_size.height		= rect->height;
+	priv->out_size.total_width	= rect->width + BLANKING_EXTRA_WIDTH;
+	priv->out_size.total_height	= max_t(int, rect->height +
+							BLANKING_EXTRA_HEIGHT,
+							BLANKING_MIN_HEIGHT);
+	priv->crop_rect.width		= rect->width;
+	priv->crop_rect.height		= rect->height;
+
+	ret = ov5642_write_array(client, ov5642_default_regs_init);
+	if (!ret)
+		ret = ov5642_set_resolution(sd);
+	if (!ret)
+		ret = ov5642_write_array(client, ov5642_default_regs_finalise);
+
+	return ret;
+}
+
 static int ov5642_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov5642 *priv = to_ov5642(client);
 	struct v4l2_rect *rect = &a->c;
 
-	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	rect->top	= 0;
-	rect->left	= 0;
-	rect->width	= OV5642_WIDTH;
-	rect->height	= OV5642_HEIGHT;
+	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	*rect = priv->crop_rect;
 
 	return 0;
 }
@@ -844,8 +918,8 @@ static int ov5642_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 {
 	a->bounds.left			= 0;
 	a->bounds.top			= 0;
-	a->bounds.width			= OV5642_WIDTH;
-	a->bounds.height		= OV5642_HEIGHT;
+	a->bounds.width			= OV5642_MAX_WIDTH;
+	a->bounds.height		= OV5642_MAX_HEIGHT;
 	a->defrect			= a->bounds;
 	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	a->pixelaspect.numerator	= 1;
@@ -858,9 +932,8 @@ static int ov5642_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	cfg->type = V4L2_MBUS_CSI2;
-	cfg->flags = V4L2_MBUS_CSI2_2_LANE |
-		V4L2_MBUS_CSI2_CHANNEL_0 |
-		V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	cfg->flags = V4L2_MBUS_CSI2_2_LANE | V4L2_MBUS_CSI2_CHANNEL_0 |
+					V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 
 	return 0;
 }
@@ -870,6 +943,7 @@ static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 	.g_mbus_fmt	= ov5642_g_fmt,
 	.try_mbus_fmt	= ov5642_try_fmt,
 	.enum_mbus_fmt	= ov5642_enum_fmt,
+	.s_crop		= ov5642_s_crop,
 	.g_crop		= ov5642_g_crop,
 	.cropcap	= ov5642_cropcap,
 	.g_mbus_config	= ov5642_g_mbus_config,
@@ -941,8 +1015,17 @@ static int ov5642_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov5642_subdev_ops);
 
-	icd->ops	= NULL;
-	priv->fmt	= &ov5642_colour_fmts[0];
+	icd->ops		= NULL;
+	priv->fmt		= &ov5642_colour_fmts[0];
+
+	priv->crop_rect.width	= OV5642_DEFAULT_WIDTH;
+	priv->crop_rect.height	= OV5642_DEFAULT_HEIGHT;
+	priv->crop_rect.left	= (OV5642_MAX_WIDTH - OV5642_DEFAULT_WIDTH) / 2;
+	priv->crop_rect.top	= (OV5642_MAX_HEIGHT - OV5642_DEFAULT_HEIGHT) / 2;
+	priv->out_size.width	= OV5642_DEFAULT_WIDTH;
+	priv->out_size.height	= OV5642_DEFAULT_HEIGHT;
+	priv->out_size.total_width = OV5642_DEFAULT_WIDTH + BLANKING_EXTRA_WIDTH;
+	priv->out_size.total_height = BLANKING_MIN_HEIGHT;
 
 	ret = ov5642_video_probe(icd, client);
 	if (ret < 0)
@@ -951,6 +1034,7 @@ static int ov5642_probe(struct i2c_client *client,
 	return 0;
 
 error:
+	icd->ops = NULL;
 	kfree(priv);
 	return ret;
 }
@@ -961,6 +1045,7 @@ static int ov5642_remove(struct i2c_client *client)
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
+	icd->ops = NULL;
 	if (icl->free_bus)
 		icl->free_bus(icl);
 	kfree(priv);
