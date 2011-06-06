Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:62920 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab1FFRUp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:20:45 -0400
Date: Mon, 6 Jun 2011 19:20:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: =?ISO-8859-15?Q?Teresa_G=E1mez?= <t.gamez@phytec.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 1/2] V4L: mt9m111: propagate higher level abstraction down
 in functions
Message-ID: <Pine.LNX.4.64.1106061918010.11169@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It is more convenient to propagate the higher level abstraction - the
struct mt9m111 object into functions and then retrieve a pointer to
the i2c client, if needed, than to do the reverse.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m111.c |  124 +++++++++++++++++++---------------------
 1 files changed, 59 insertions(+), 65 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index ebebed9..872c99c 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -251,9 +251,10 @@ static int mt9m111_reg_clear(struct i2c_client *client, const u16 reg,
 	return mt9m111_reg_write(client, reg, ret & ~data);
 }
 
-static int mt9m111_set_context(struct i2c_client *client,
+static int mt9m111_set_context(struct mt9m111 *mt9m111,
 			       enum mt9m111_context ctxt)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int valB = MT9M111_CTXT_CTRL_RESTART | MT9M111_CTXT_CTRL_DEFECTCOR_B
 		| MT9M111_CTXT_CTRL_RESIZE_B | MT9M111_CTXT_CTRL_CTRL2_B
 		| MT9M111_CTXT_CTRL_GAMMA_B | MT9M111_CTXT_CTRL_READ_MODE_B
@@ -267,10 +268,10 @@ static int mt9m111_set_context(struct i2c_client *client,
 		return reg_write(CONTEXT_CONTROL, valA);
 }
 
-static int mt9m111_setup_rect(struct i2c_client *client,
+static int mt9m111_setup_rect(struct mt9m111 *mt9m111,
 			      struct v4l2_rect *rect)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret, is_raw_format;
 	int width = rect->width;
 	int height = rect->height;
@@ -384,9 +385,9 @@ static int mt9m111_setfmt_yuv(struct i2c_client *client)
 	return mt9m111_setup_pixfmt(client, val);
 }
 
-static int mt9m111_enable(struct i2c_client *client)
+static int mt9m111_enable(struct mt9m111 *mt9m111)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
 
 	ret = reg_set(RESET, MT9M111_RESET_CHIP_ENABLE);
@@ -395,8 +396,9 @@ static int mt9m111_enable(struct i2c_client *client)
 	return ret;
 }
 
-static int mt9m111_reset(struct i2c_client *client)
+static int mt9m111_reset(struct mt9m111 *mt9m111)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
 
 	ret = reg_set(RESET, MT9M111_RESET_RESET_MODE);
@@ -424,11 +426,9 @@ static int mt9m111_set_bus_param(struct soc_camera_device *icd, unsigned long f)
 	return 0;
 }
 
-static int mt9m111_make_rect(struct i2c_client *client,
+static int mt9m111_make_rect(struct mt9m111 *mt9m111,
 			     struct v4l2_rect *rect)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
-
 	if (mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
 	    mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
 		/* Bayer format - even size lengths */
@@ -444,14 +444,14 @@ static int mt9m111_make_rect(struct i2c_client *client,
 	soc_camera_limit_side(&rect->top, &rect->height,
 		     MT9M111_MIN_DARK_ROWS, 2, MT9M111_MAX_HEIGHT);
 
-	return mt9m111_setup_rect(client, rect);
+	return mt9m111_setup_rect(mt9m111, rect);
 }
 
 static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	struct v4l2_rect rect = a->c;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 	int ret;
 
 	dev_dbg(&client->dev, "%s left=%d, top=%d, width=%d, height=%d\n",
@@ -460,7 +460,7 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	ret = mt9m111_make_rect(client, &rect);
+	ret = mt9m111_make_rect(mt9m111, &rect);
 	if (!ret)
 		mt9m111->rect = rect;
 	return ret;
@@ -468,8 +468,7 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 
 static int mt9m111_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 
 	a->c	= mt9m111->rect;
 	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -496,8 +495,7 @@ static int mt9m111_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 static int mt9m111_g_fmt(struct v4l2_subdev *sd,
 			 struct v4l2_mbus_framefmt *mf)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 
 	mf->width	= mt9m111->rect.width;
 	mf->height	= mt9m111->rect.height;
@@ -508,10 +506,10 @@ static int mt9m111_g_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int mt9m111_set_pixfmt(struct i2c_client *client,
+static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
 			      enum v4l2_mbus_pixelcode code)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
 
 	switch (code) {
@@ -561,7 +559,7 @@ static int mt9m111_s_fmt(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	const struct mt9m111_datafmt *fmt;
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 	struct v4l2_rect rect = {
 		.left	= mt9m111->rect.left,
 		.top	= mt9m111->rect.top,
@@ -579,9 +577,9 @@ static int mt9m111_s_fmt(struct v4l2_subdev *sd,
 		"%s code=%x left=%d, top=%d, width=%d, height=%d\n", __func__,
 		mf->code, rect.left, rect.top, rect.width, rect.height);
 
-	ret = mt9m111_make_rect(client, &rect);
+	ret = mt9m111_make_rect(mt9m111, &rect);
 	if (!ret)
-		ret = mt9m111_set_pixfmt(client, mf->code);
+		ret = mt9m111_set_pixfmt(mt9m111, mf->code);
 	if (!ret) {
 		mt9m111->rect	= rect;
 		mt9m111->fmt	= fmt;
@@ -594,8 +592,7 @@ static int mt9m111_s_fmt(struct v4l2_subdev *sd,
 static int mt9m111_try_fmt(struct v4l2_subdev *sd,
 			   struct v4l2_mbus_framefmt *mf)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 	const struct mt9m111_datafmt *fmt;
 	bool bayer = mf->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
 		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE;
@@ -635,7 +632,7 @@ static int mt9m111_g_chip_ident(struct v4l2_subdev *sd,
 				struct v4l2_dbg_chip_ident *id)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 
 	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
 		return -EINVAL;
@@ -738,9 +735,9 @@ static struct soc_camera_ops mt9m111_ops = {
 	.num_controls		= ARRAY_SIZE(mt9m111_controls),
 };
 
-static int mt9m111_set_flip(struct i2c_client *client, int flip, int mask)
+static int mt9m111_set_flip(struct mt9m111 *mt9m111, int flip, int mask)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
 
 	if (mt9m111->context == HIGHPOWER) {
@@ -758,8 +755,9 @@ static int mt9m111_set_flip(struct i2c_client *client, int flip, int mask)
 	return ret;
 }
 
-static int mt9m111_get_global_gain(struct i2c_client *client)
+static int mt9m111_get_global_gain(struct mt9m111 *mt9m111)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int data;
 
 	data = reg_read(GLOBAL_GAIN);
@@ -769,9 +767,9 @@ static int mt9m111_get_global_gain(struct i2c_client *client)
 	return data;
 }
 
-static int mt9m111_set_global_gain(struct i2c_client *client, int gain)
+static int mt9m111_set_global_gain(struct mt9m111 *mt9m111, int gain)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	u16 val;
 
 	if (gain > 63 * 2 * 2)
@@ -788,9 +786,9 @@ static int mt9m111_set_global_gain(struct i2c_client *client, int gain)
 	return reg_write(GLOBAL_GAIN, val);
 }
 
-static int mt9m111_set_autoexposure(struct i2c_client *client, int on)
+static int mt9m111_set_autoexposure(struct mt9m111 *mt9m111, int on)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
 
 	if (on)
@@ -804,9 +802,9 @@ static int mt9m111_set_autoexposure(struct i2c_client *client, int on)
 	return ret;
 }
 
-static int mt9m111_set_autowhitebalance(struct i2c_client *client, int on)
+static int mt9m111_set_autowhitebalance(struct mt9m111 *mt9m111, int on)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
 
 	if (on)
@@ -823,7 +821,7 @@ static int mt9m111_set_autowhitebalance(struct i2c_client *client, int on)
 static int mt9m111_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 	int data;
 
 	switch (ctrl->id) {
@@ -848,7 +846,7 @@ static int mt9m111_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		ctrl->value = !!(data & MT9M111_RMB_MIRROR_COLS);
 		break;
 	case V4L2_CID_GAIN:
-		data = mt9m111_get_global_gain(client);
+		data = mt9m111_get_global_gain(mt9m111);
 		if (data < 0)
 			return data;
 		ctrl->value = data;
@@ -865,8 +863,7 @@ static int mt9m111_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 
 static int mt9m111_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 	const struct v4l2_queryctrl *qctrl;
 	int ret;
 
@@ -877,22 +874,22 @@ static int mt9m111_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
 		mt9m111->vflip = ctrl->value;
-		ret = mt9m111_set_flip(client, ctrl->value,
+		ret = mt9m111_set_flip(mt9m111, ctrl->value,
 					MT9M111_RMB_MIRROR_ROWS);
 		break;
 	case V4L2_CID_HFLIP:
 		mt9m111->hflip = ctrl->value;
-		ret = mt9m111_set_flip(client, ctrl->value,
+		ret = mt9m111_set_flip(mt9m111, ctrl->value,
 					MT9M111_RMB_MIRROR_COLS);
 		break;
 	case V4L2_CID_GAIN:
-		ret = mt9m111_set_global_gain(client, ctrl->value);
+		ret = mt9m111_set_global_gain(mt9m111, ctrl->value);
 		break;
 	case V4L2_CID_EXPOSURE_AUTO:
-		ret =  mt9m111_set_autoexposure(client, ctrl->value);
+		ret =  mt9m111_set_autoexposure(mt9m111, ctrl->value);
 		break;
 	case V4L2_CID_AUTO_WHITE_BALANCE:
-		ret =  mt9m111_set_autowhitebalance(client, ctrl->value);
+		ret =  mt9m111_set_autowhitebalance(mt9m111, ctrl->value);
 		break;
 	default:
 		ret = -EINVAL;
@@ -906,24 +903,21 @@ static int mt9m111_suspend(struct soc_camera_device *icd, pm_message_t state)
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
-	mt9m111->gain = mt9m111_get_global_gain(client);
+	mt9m111->gain = mt9m111_get_global_gain(mt9m111);
 
 	return 0;
 }
 
-static int mt9m111_restore_state(struct i2c_client *client)
+static void mt9m111_restore_state(struct mt9m111 *mt9m111)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
-
-	mt9m111_set_context(client, mt9m111->context);
-	mt9m111_set_pixfmt(client, mt9m111->fmt->code);
-	mt9m111_setup_rect(client, &mt9m111->rect);
-	mt9m111_set_flip(client, mt9m111->hflip, MT9M111_RMB_MIRROR_COLS);
-	mt9m111_set_flip(client, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
-	mt9m111_set_global_gain(client, mt9m111->gain);
-	mt9m111_set_autoexposure(client, mt9m111->autoexposure);
-	mt9m111_set_autowhitebalance(client, mt9m111->autowhitebalance);
-	return 0;
+	mt9m111_set_context(mt9m111, mt9m111->context);
+	mt9m111_set_pixfmt(mt9m111, mt9m111->fmt->code);
+	mt9m111_setup_rect(mt9m111, &mt9m111->rect);
+	mt9m111_set_flip(mt9m111, mt9m111->hflip, MT9M111_RMB_MIRROR_COLS);
+	mt9m111_set_flip(mt9m111, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
+	mt9m111_set_global_gain(mt9m111, mt9m111->gain);
+	mt9m111_set_autoexposure(mt9m111, mt9m111->autoexposure);
+	mt9m111_set_autowhitebalance(mt9m111, mt9m111->autowhitebalance);
 }
 
 static int mt9m111_resume(struct soc_camera_device *icd)
@@ -933,28 +927,28 @@ static int mt9m111_resume(struct soc_camera_device *icd)
 	int ret = 0;
 
 	if (mt9m111->powered) {
-		ret = mt9m111_enable(client);
+		ret = mt9m111_enable(mt9m111);
 		if (!ret)
-			ret = mt9m111_reset(client);
+			ret = mt9m111_reset(mt9m111);
 		if (!ret)
-			ret = mt9m111_restore_state(client);
+			mt9m111_restore_state(mt9m111);
 	}
 	return ret;
 }
 
-static int mt9m111_init(struct i2c_client *client)
+static int mt9m111_init(struct mt9m111 *mt9m111)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
 
 	mt9m111->context = HIGHPOWER;
-	ret = mt9m111_enable(client);
+	ret = mt9m111_enable(mt9m111);
 	if (!ret)
-		ret = mt9m111_reset(client);
+		ret = mt9m111_reset(mt9m111);
 	if (!ret)
-		ret = mt9m111_set_context(client, mt9m111->context);
+		ret = mt9m111_set_context(mt9m111, mt9m111->context);
 	if (!ret)
-		ret = mt9m111_set_autoexposure(client, mt9m111->autoexposure);
+		ret = mt9m111_set_autoexposure(mt9m111, mt9m111->autoexposure);
 	if (ret)
 		dev_err(&client->dev, "mt9m111 init failed: %d\n", ret);
 	return ret;
@@ -1005,7 +999,7 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 		goto ei2c;
 	}
 
-	ret = mt9m111_init(client);
+	ret = mt9m111_init(mt9m111);
 
 ei2c:
 	return ret;
-- 
1.7.2.5

