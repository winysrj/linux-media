Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:63663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1LUPx6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 10:53:58 -0500
Date: Wed, 21 Dec 2011 16:53:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 3/3] V4L: mt9m111: properly implement .s_crop and .s_fmt(),
 reset on STREAMON
In-Reply-To: <Pine.LNX.4.64.1112211649070.30646@axis700.grange>
Message-ID: <Pine.LNX.4.64.1112211653100.30646@axis700.grange>
References: <Pine.LNX.4.64.1112211649070.30646@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mt9m111 camera sensors support cropping and scaling. The current
implementation is broken. For example, .s_crop() sets output frame sizes
instead of the input cropping window. This patch adds a proper implementation
of these methods. Besides it adds a sensor-disable and -enable operations
on first open() and last close() respectively, to save power while closed and
to return the camera to the default power-on state.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m111.c |  226 ++++++++++++++++++++--------------------
 1 files changed, 113 insertions(+), 113 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 797660b..ba1ea8c 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -185,19 +185,6 @@ struct mt9m111_datafmt {
 	enum v4l2_colorspace		colorspace;
 };
 
-/* Find a data format by a pixel code in an array */
-static const struct mt9m111_datafmt *mt9m111_find_datafmt(
-	enum v4l2_mbus_pixelcode code, const struct mt9m111_datafmt *fmt,
-	int n)
-{
-	int i;
-	for (i = 0; i < n; i++)
-		if (fmt[i].code == code)
-			return fmt + i;
-
-	return NULL;
-}
-
 static const struct mt9m111_datafmt mt9m111_colour_fmts[] = {
 	{V4L2_MBUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG},
 	{V4L2_MBUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG},
@@ -220,7 +207,9 @@ struct mt9m111 {
 	int model;	/* V4L2_IDENT_MT9M111 or V4L2_IDENT_MT9M112 code
 			 * from v4l2-chip-ident.h */
 	struct mt9m111_context *ctx;
-	struct v4l2_rect rect;
+	struct v4l2_rect rect;	/* cropping rectangle */
+	int width;		/* output */
+	int height;		/* sizes */
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
 	const struct mt9m111_datafmt *fmt;
@@ -228,6 +217,18 @@ struct mt9m111 {
 	unsigned char datawidth;
 };
 
+/* Find a data format by a pixel code */
+static const struct mt9m111_datafmt *mt9m111_find_datafmt(struct mt9m111 *mt9m111,
+						enum v4l2_mbus_pixelcode code)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(mt9m111_colour_fmts); i++)
+		if (mt9m111_colour_fmts[i].code == code)
+			return mt9m111_colour_fmts + i;
+
+	return mt9m111->fmt;
+}
+
 static struct mt9m111 *to_mt9m111(const struct i2c_client *client)
 {
 	return container_of(i2c_get_clientdata(client), struct mt9m111, subdev);
@@ -316,43 +317,49 @@ static int mt9m111_set_context(struct mt9m111 *mt9m111,
 }
 
 static int mt9m111_setup_rect_ctx(struct mt9m111 *mt9m111,
-			struct v4l2_rect *rect, struct mt9m111_context *ctx)
+			struct mt9m111_context *ctx, struct v4l2_rect *rect,
+			unsigned int width, unsigned int height)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	int ret = mt9m111_reg_write(client, ctx->reducer_xzoom, MT9M111_MAX_WIDTH);
+	int ret = mt9m111_reg_write(client, ctx->reducer_xzoom, rect->width);
 	if (!ret)
-		ret = mt9m111_reg_write(client, ctx->reducer_yzoom, MT9M111_MAX_HEIGHT);
+		ret = mt9m111_reg_write(client, ctx->reducer_yzoom, rect->height);
 	if (!ret)
-		ret = mt9m111_reg_write(client, ctx->reducer_xsize, rect->width);
+		ret = mt9m111_reg_write(client, ctx->reducer_xsize, width);
 	if (!ret)
-		ret = mt9m111_reg_write(client, ctx->reducer_ysize, rect->height);
+		ret = mt9m111_reg_write(client, ctx->reducer_ysize, height);
 	return ret;
 }
 
-static int mt9m111_setup_rect(struct mt9m111 *mt9m111,
-			      struct v4l2_rect *rect)
+static int mt9m111_setup_geometry(struct mt9m111 *mt9m111, struct v4l2_rect *rect,
+			int width, int height, enum v4l2_mbus_pixelcode code)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
-	bool is_raw_format = mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
-		mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE;
 
 	ret = reg_write(COLUMN_START, rect->left);
 	if (!ret)
 		ret = reg_write(ROW_START, rect->top);
 
-	if (is_raw_format) {
-		if (!ret)
-			ret = reg_write(WINDOW_WIDTH, rect->width);
-		if (!ret)
-			ret = reg_write(WINDOW_HEIGHT, rect->height);
-	} else {
+	if (!ret)
+		ret = reg_write(WINDOW_WIDTH, rect->width);
+	if (!ret)
+		ret = reg_write(WINDOW_HEIGHT, rect->height);
+
+	if (code != V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
+		/* IFP in use, down-scaling possible */
 		if (!ret)
-			ret = mt9m111_setup_rect_ctx(mt9m111, rect, &context_b);
+			ret = mt9m111_setup_rect_ctx(mt9m111, &context_b,
+						     rect, width, height);
 		if (!ret)
-			ret = mt9m111_setup_rect_ctx(mt9m111, rect, &context_a);
+			ret = mt9m111_setup_rect_ctx(mt9m111, &context_a,
+						     rect, width, height);
 	}
 
+	dev_dbg(&client->dev, "%s(%x): %ux%u@%u:%u -> %ux%u = %d\n",
+		__func__, code, rect->width, rect->height, rect->left, rect->top,
+		width, height, ret);
+
 	return ret;
 }
 
@@ -377,43 +384,41 @@ static int mt9m111_reset(struct mt9m111 *mt9m111)
 	return ret;
 }
 
-static int mt9m111_make_rect(struct mt9m111 *mt9m111,
-			     struct v4l2_rect *rect)
+static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
+	struct v4l2_rect rect = a->c;
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
+	int width, height;
+	int ret;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
 	if (mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
 	    mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
 		/* Bayer format - even size lengths */
-		rect->width	= ALIGN(rect->width, 2);
-		rect->height	= ALIGN(rect->height, 2);
+		rect.width	= ALIGN(rect.width, 2);
+		rect.height	= ALIGN(rect.height, 2);
 		/* Let the user play with the starting pixel */
 	}
 
 	/* FIXME: the datasheet doesn't specify minimum sizes */
-	soc_camera_limit_side(&rect->left, &rect->width,
+	soc_camera_limit_side(&rect.left, &rect.width,
 		     MT9M111_MIN_DARK_COLS, 2, MT9M111_MAX_WIDTH);
 
-	soc_camera_limit_side(&rect->top, &rect->height,
+	soc_camera_limit_side(&rect.top, &rect.height,
 		     MT9M111_MIN_DARK_ROWS, 2, MT9M111_MAX_HEIGHT);
 
-	return mt9m111_setup_rect(mt9m111, rect);
-}
-
-static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
-{
-	struct v4l2_rect rect = a->c;
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
-	int ret;
+	width = min(mt9m111->width, rect.width);
+	height = min(mt9m111->height, rect.height);
 
-	dev_dbg(&client->dev, "%s left=%d, top=%d, width=%d, height=%d\n",
-		__func__, rect.left, rect.top, rect.width, rect.height);
-
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	ret = mt9m111_make_rect(mt9m111, &rect);
-	if (!ret)
+	ret = mt9m111_setup_geometry(mt9m111, &rect, width, height, mt9m111->fmt->code);
+	if (!ret) {
 		mt9m111->rect = rect;
+		mt9m111->width = width;
+		mt9m111->height = height;
+	}
+
 	return ret;
 }
 
@@ -448,8 +453,8 @@ static int mt9m111_g_fmt(struct v4l2_subdev *sd,
 {
 	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 
-	mf->width	= mt9m111->rect.width;
-	mf->height	= mt9m111->rect.height;
+	mf->width	= mt9m111->width;
+	mf->height	= mt9m111->height;
 	mf->code	= mt9m111->fmt->code;
 	mf->colorspace	= mt9m111->fmt->colorspace;
 	mf->field	= V4L2_FIELD_NONE;
@@ -527,80 +532,74 @@ static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
 	return ret;
 }
 
-static int mt9m111_s_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	const struct mt9m111_datafmt *fmt;
-	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
-	struct v4l2_rect rect = {
-		.left	= mt9m111->rect.left,
-		.top	= mt9m111->rect.top,
-		.width	= mf->width,
-		.height	= mf->height,
-	};
-	int ret;
-
-	fmt = mt9m111_find_datafmt(mf->code, mt9m111_colour_fmts,
-				   ARRAY_SIZE(mt9m111_colour_fmts));
-	if (!fmt)
-		return -EINVAL;
-
-	dev_dbg(&client->dev,
-		"%s code=%x left=%d, top=%d, width=%d, height=%d\n", __func__,
-		mf->code, rect.left, rect.top, rect.width, rect.height);
-
-	ret = mt9m111_make_rect(mt9m111, &rect);
-	if (!ret)
-		ret = mt9m111_set_pixfmt(mt9m111, mf->code);
-	if (!ret) {
-		mt9m111->rect	= rect;
-		mt9m111->fmt	= fmt;
-		mf->colorspace	= fmt->colorspace;
-	}
-
-	return ret;
-}
-
 static int mt9m111_try_fmt(struct v4l2_subdev *sd,
 			   struct v4l2_mbus_framefmt *mf)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 	const struct mt9m111_datafmt *fmt;
-	bool bayer = mf->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
-		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE;
-
-	fmt = mt9m111_find_datafmt(mf->code, mt9m111_colour_fmts,
-				   ARRAY_SIZE(mt9m111_colour_fmts));
-	if (!fmt) {
-		fmt = mt9m111->fmt;
-		mf->code = fmt->code;
-	}
+	struct v4l2_rect *rect = &mt9m111->rect;
+	bool bayer;
+
+	fmt = mt9m111_find_datafmt(mt9m111, mf->code);
+
+	bayer = fmt->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
+		fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE;
 
 	/*
 	 * With Bayer format enforce even side lengths, but let the user play
 	 * with the starting pixel
 	 */
+	if (bayer) {
+		rect->width = ALIGN(rect->width, 2);
+		rect->height = ALIGN(rect->height, 2);
+	}
 
-	if (mf->height > MT9M111_MAX_HEIGHT)
-		mf->height = MT9M111_MAX_HEIGHT;
-	else if (mf->height < 2)
-		mf->height = 2;
-	else if (bayer)
-		mf->height = ALIGN(mf->height, 2);
+	if (fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
+		/* IFP bypass mode, no scaling */
+		mf->width = rect->width;
+		mf->height = rect->height;
+	} else {
+		/* No upscaling */
+		if (mf->width > rect->width)
+			mf->width = rect->width;
+		if (mf->height > rect->height)
+			mf->height = rect->height;
+	}
 
-	if (mf->width > MT9M111_MAX_WIDTH)
-		mf->width = MT9M111_MAX_WIDTH;
-	else if (mf->width < 2)
-		mf->width = 2;
-	else if (bayer)
-		mf->width = ALIGN(mf->width, 2);
+	dev_dbg(&client->dev, "%s(): %ux%u, code=%x\n", __func__,
+		mf->width, mf->height, fmt->code);
 
+	mf->code = fmt->code;
 	mf->colorspace = fmt->colorspace;
 
 	return 0;
 }
 
+static int mt9m111_s_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
+{
+	const struct mt9m111_datafmt *fmt;
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
+	struct v4l2_rect *rect = &mt9m111->rect;
+	int ret;
+
+	mt9m111_try_fmt(sd, mf);
+	fmt = mt9m111_find_datafmt(mt9m111, mf->code);
+	/* try_fmt() guarantees fmt != NULL && fmt->code == mf->code */
+
+	ret = mt9m111_setup_geometry(mt9m111, rect, mf->width, mf->height, mf->code);
+	if (!ret)
+		ret = mt9m111_set_pixfmt(mt9m111, mf->code);
+	if (!ret) {
+		mt9m111->width	= mf->width;
+		mt9m111->height	= mf->height;
+		mt9m111->fmt	= fmt;
+	}
+
+	return ret;
+}
+
 static int mt9m111_g_chip_ident(struct v4l2_subdev *sd,
 				struct v4l2_dbg_chip_ident *id)
 {
@@ -765,7 +764,8 @@ static void mt9m111_restore_state(struct mt9m111 *mt9m111)
 {
 	mt9m111_set_context(mt9m111, mt9m111->ctx);
 	mt9m111_set_pixfmt(mt9m111, mt9m111->fmt->code);
-	mt9m111_setup_rect(mt9m111, &mt9m111->rect);
+	mt9m111_setup_geometry(mt9m111, &mt9m111->rect,
+			mt9m111->width, mt9m111->height, mt9m111->fmt->code);
 	v4l2_ctrl_handler_setup(&mt9m111->hdl);
 }
 
-- 
1.7.2.5

