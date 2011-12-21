Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1LUPxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 10:53:49 -0500
Date: Wed, 21 Dec 2011 16:53:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 1/3] V4L: mt9m111: cleanly separate register contexts
In-Reply-To: <Pine.LNX.4.64.1112211649070.30646@axis700.grange>
Message-ID: <Pine.LNX.4.64.1112211652130.30646@axis700.grange>
References: <Pine.LNX.4.64.1112211649070.30646@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanly separating register contexts A and B will allow us to configure
the contexts independently.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m111.c |  137 +++++++++++++++++++++++------------------
 1 files changed, 76 insertions(+), 61 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 258adfd..54edb6b4 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -139,6 +139,46 @@
 #define MT9M111_MAX_HEIGHT	1024
 #define MT9M111_MAX_WIDTH	1280
 
+struct mt9m111_context {
+	u16 read_mode;
+	u16 blanking_h;
+	u16 blanking_v;
+	u16 reducer_xzoom;
+	u16 reducer_yzoom;
+	u16 reducer_xsize;
+	u16 reducer_ysize;
+	u16 output_fmt_ctrl2;
+	u16 control;
+};
+
+static struct mt9m111_context context_a = {
+	.read_mode		= MT9M111_READ_MODE_A,
+	.blanking_h		= MT9M111_HORIZONTAL_BLANKING_A,
+	.blanking_v		= MT9M111_VERTICAL_BLANKING_A,
+	.reducer_xzoom		= MT9M111_REDUCER_XZOOM_A,
+	.reducer_yzoom		= MT9M111_REDUCER_YZOOM_A,
+	.reducer_xsize		= MT9M111_REDUCER_XSIZE_A,
+	.reducer_ysize		= MT9M111_REDUCER_YSIZE_A,
+	.output_fmt_ctrl2	= MT9M111_OUTPUT_FORMAT_CTRL2_A,
+	.control		= MT9M111_CTXT_CTRL_RESTART,
+};
+
+static struct mt9m111_context context_b = {
+	.read_mode		= MT9M111_READ_MODE_B,
+	.blanking_h		= MT9M111_HORIZONTAL_BLANKING_B,
+	.blanking_v		= MT9M111_VERTICAL_BLANKING_B,
+	.reducer_xzoom		= MT9M111_REDUCER_XZOOM_B,
+	.reducer_yzoom		= MT9M111_REDUCER_YZOOM_B,
+	.reducer_xsize		= MT9M111_REDUCER_XSIZE_B,
+	.reducer_ysize		= MT9M111_REDUCER_YSIZE_B,
+	.output_fmt_ctrl2	= MT9M111_OUTPUT_FORMAT_CTRL2_B,
+	.control		= MT9M111_CTXT_CTRL_RESTART |
+		MT9M111_CTXT_CTRL_DEFECTCOR_B | MT9M111_CTXT_CTRL_RESIZE_B |
+		MT9M111_CTXT_CTRL_CTRL2_B | MT9M111_CTXT_CTRL_GAMMA_B |
+		MT9M111_CTXT_CTRL_READ_MODE_B | MT9M111_CTXT_CTRL_VBLANK_SEL_B |
+		MT9M111_CTXT_CTRL_HBLANK_SEL_B,
+};
+
 /* MT9M111 has only one fixed colorspace per pixelcode */
 struct mt9m111_datafmt {
 	enum v4l2_mbus_pixelcode	code;
@@ -173,18 +213,13 @@ static const struct mt9m111_datafmt mt9m111_colour_fmts[] = {
 	{V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
 };
 
-enum mt9m111_context {
-	HIGHPOWER = 0,
-	LOWPOWER,
-};
-
 struct mt9m111 {
 	struct v4l2_subdev subdev;
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_ctrl *gain;
 	int model;	/* V4L2_IDENT_MT9M111 or V4L2_IDENT_MT9M112 code
 			 * from v4l2-chip-ident.h */
-	enum mt9m111_context context;
+	struct mt9m111_context *ctx;
 	struct v4l2_rect rect;
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
@@ -275,35 +310,33 @@ static int mt9m111_reg_mask(struct i2c_client *client, const u16 reg,
 }
 
 static int mt9m111_set_context(struct mt9m111 *mt9m111,
-			       enum mt9m111_context ctxt)
+			       struct mt9m111_context *ctx)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	int valB = MT9M111_CTXT_CTRL_RESTART | MT9M111_CTXT_CTRL_DEFECTCOR_B
-		| MT9M111_CTXT_CTRL_RESIZE_B | MT9M111_CTXT_CTRL_CTRL2_B
-		| MT9M111_CTXT_CTRL_GAMMA_B | MT9M111_CTXT_CTRL_READ_MODE_B
-		| MT9M111_CTXT_CTRL_VBLANK_SEL_B
-		| MT9M111_CTXT_CTRL_HBLANK_SEL_B;
-	int valA = MT9M111_CTXT_CTRL_RESTART;
-
-	if (ctxt == HIGHPOWER)
-		return reg_write(CONTEXT_CONTROL, valB);
-	else
-		return reg_write(CONTEXT_CONTROL, valA);
+	return reg_write(CONTEXT_CONTROL, ctx->control);
+}
+
+static int mt9m111_setup_rect_ctx(struct mt9m111 *mt9m111,
+			struct v4l2_rect *rect, struct mt9m111_context *ctx)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
+	int ret = mt9m111_reg_write(client, ctx->reducer_xzoom, MT9M111_MAX_WIDTH);
+	if (!ret)
+		ret = mt9m111_reg_write(client, ctx->reducer_yzoom, MT9M111_MAX_HEIGHT);
+	if (!ret)
+		ret = mt9m111_reg_write(client, ctx->reducer_xsize, rect->width);
+	if (!ret)
+		ret = mt9m111_reg_write(client, ctx->reducer_ysize, rect->height);
+	return ret;
 }
 
 static int mt9m111_setup_rect(struct mt9m111 *mt9m111,
 			      struct v4l2_rect *rect)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	int ret, is_raw_format;
-	int width = rect->width;
-	int height = rect->height;
-
-	if (mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
-	    mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE)
-		is_raw_format = 1;
-	else
-		is_raw_format = 0;
+	int ret;
+	bool is_raw_format = mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
+		mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE;
 
 	ret = reg_write(COLUMN_START, rect->left);
 	if (!ret)
@@ -311,26 +344,14 @@ static int mt9m111_setup_rect(struct mt9m111 *mt9m111,
 
 	if (is_raw_format) {
 		if (!ret)
-			ret = reg_write(WINDOW_WIDTH, width);
+			ret = reg_write(WINDOW_WIDTH, rect->width);
 		if (!ret)
-			ret = reg_write(WINDOW_HEIGHT, height);
+			ret = reg_write(WINDOW_HEIGHT, rect->height);
 	} else {
 		if (!ret)
-			ret = reg_write(REDUCER_XZOOM_B, MT9M111_MAX_WIDTH);
-		if (!ret)
-			ret = reg_write(REDUCER_YZOOM_B, MT9M111_MAX_HEIGHT);
-		if (!ret)
-			ret = reg_write(REDUCER_XSIZE_B, width);
+			ret = mt9m111_setup_rect_ctx(mt9m111, rect, &context_b);
 		if (!ret)
-			ret = reg_write(REDUCER_YSIZE_B, height);
-		if (!ret)
-			ret = reg_write(REDUCER_XZOOM_A, MT9M111_MAX_WIDTH);
-		if (!ret)
-			ret = reg_write(REDUCER_YZOOM_A, MT9M111_MAX_HEIGHT);
-		if (!ret)
-			ret = reg_write(REDUCER_XSIZE_A, width);
-		if (!ret)
-			ret = reg_write(REDUCER_YSIZE_A, height);
+			ret = mt9m111_setup_rect_ctx(mt9m111, rect, &context_a);
 	}
 
 	return ret;
@@ -503,11 +524,11 @@ static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
 		return -EINVAL;
 	}
 
-	ret = reg_mask(OUTPUT_FORMAT_CTRL2_A, data_outfmt2,
-		       mask_outfmt2);
+	ret = mt9m111_reg_mask(client, context_a.output_fmt_ctrl2,
+			       data_outfmt2, mask_outfmt2);
 	if (!ret)
-		ret = reg_mask(OUTPUT_FORMAT_CTRL2_B, data_outfmt2,
-			       mask_outfmt2);
+		ret = mt9m111_reg_mask(client, context_b.output_fmt_ctrl2,
+				       data_outfmt2, mask_outfmt2);
 
 	return ret;
 }
@@ -649,17 +670,10 @@ static int mt9m111_set_flip(struct mt9m111 *mt9m111, int flip, int mask)
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
 
-	if (mt9m111->context == HIGHPOWER) {
-		if (flip)
-			ret = reg_set(READ_MODE_B, mask);
-		else
-			ret = reg_clear(READ_MODE_B, mask);
-	} else {
-		if (flip)
-			ret = reg_set(READ_MODE_A, mask);
-		else
-			ret = reg_clear(READ_MODE_A, mask);
-	}
+	if (flip)
+		ret = mt9m111_reg_set(client, mt9m111->ctx->read_mode, mask);
+	else
+		ret = mt9m111_reg_clear(client, mt9m111->ctx->read_mode, mask);
 
 	return ret;
 }
@@ -744,7 +758,7 @@ static int mt9m111_suspend(struct mt9m111 *mt9m111)
 
 static void mt9m111_restore_state(struct mt9m111 *mt9m111)
 {
-	mt9m111_set_context(mt9m111, mt9m111->context);
+	mt9m111_set_context(mt9m111, mt9m111->ctx);
 	mt9m111_set_pixfmt(mt9m111, mt9m111->fmt->code);
 	mt9m111_setup_rect(mt9m111, &mt9m111->rect);
 	v4l2_ctrl_handler_setup(&mt9m111->hdl);
@@ -769,12 +783,13 @@ static int mt9m111_init(struct mt9m111 *mt9m111)
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
 
-	mt9m111->context = HIGHPOWER;
+	/* Default HIGHPOWER context */
+	mt9m111->ctx = &context_b;
 	ret = mt9m111_enable(mt9m111);
 	if (!ret)
 		ret = mt9m111_reset(mt9m111);
 	if (!ret)
-		ret = mt9m111_set_context(mt9m111, mt9m111->context);
+		ret = mt9m111_set_context(mt9m111, mt9m111->ctx);
 	if (ret)
 		dev_err(&client->dev, "mt9m111 init failed: %d\n", ret);
 	return ret;
-- 
1.7.2.5

