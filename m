Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:55393 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933203AbbKRQza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 11:55:30 -0500
From: Lucas Stach <l.stach@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, patchwork-lst@pengutronix.de
Subject: [PATCH 2/9] [media] tvp5150: add userspace subdev API
Date: Wed, 18 Nov 2015 17:55:21 +0100
Message-Id: <1447865728-5726-2-git-send-email-l.stach@pengutronix.de>
In-Reply-To: <1447865728-5726-1-git-send-email-l.stach@pengutronix.de>
References: <1447865728-5726-1-git-send-email-l.stach@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

This patch adds userspace V4L2 subdevice API support.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 259 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 200 insertions(+), 59 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index a7495d2856c3..8670b478dcd6 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -36,7 +36,9 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 struct tvp5150 {
 	struct v4l2_subdev sd;
+	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
+	struct v4l2_mbus_framefmt format;
 	struct v4l2_rect rect;
 	struct regmap *regmap;
 
@@ -819,38 +821,68 @@ static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
+static void tvp5150_try_crop(struct tvp5150 *decoder, struct v4l2_rect *rect,
+			       v4l2_std_id std)
 {
-	struct v4l2_mbus_framefmt *f;
-	struct tvp5150 *decoder = to_tvp5150(sd);
+	unsigned int hmax;
 
-	if (!format || format->pad)
-		return -EINVAL;
+	/* Clamp the crop rectangle boundaries to tvp5150 limits */
+	rect->left = clamp(rect->left, 0, TVP5150_MAX_CROP_LEFT);
+	rect->width = clamp(rect->width,
+			    TVP5150_H_MAX - TVP5150_MAX_CROP_LEFT - rect->left,
+			    TVP5150_H_MAX - rect->left);
+	rect->top = clamp(rect->top, 0, TVP5150_MAX_CROP_TOP);
 
-	f = &format->format;
+	/* tvp5150 has some special limits */
+	rect->left = clamp(rect->left, 0, TVP5150_MAX_CROP_LEFT);
+	rect->width = clamp_t(unsigned int, rect->width,
+			      TVP5150_H_MAX - TVP5150_MAX_CROP_LEFT - rect->left,
+			      TVP5150_H_MAX - rect->left);
+	rect->top = clamp(rect->top, 0, TVP5150_MAX_CROP_TOP);
 
-	tvp5150_reset(sd, 0);
+	/* Calculate height based on current standard */
+	if (std & V4L2_STD_525_60)
+		hmax = TVP5150_V_MAX_525_60;
+	else
+		hmax = TVP5150_V_MAX_OTHERS;
 
-	f->width = decoder->rect.width;
-	f->height = decoder->rect.height;
+	rect->height = clamp(rect->height,
+			     hmax - TVP5150_MAX_CROP_TOP - rect->top,
+			     hmax - rect->top);
+}
 
-	f->code = MEDIA_BUS_FMT_UYVY8_2X8;
-	f->field = V4L2_FIELD_SEQ_TB;
-	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
+static void tvp5150_set_crop(struct tvp5150 *decoder, struct v4l2_rect *rect,
+			       v4l2_std_id std)
+{
+	struct regmap *map = decoder->regmap;
+	unsigned int hmax;
 
-	v4l2_dbg(1, debug, sd, "width = %d, height = %d\n", f->width,
-			f->height);
-	return 0;
+	if (std & V4L2_STD_525_60)
+		hmax = TVP5150_V_MAX_525_60;
+	else
+		hmax = TVP5150_V_MAX_OTHERS;
+
+	regmap_write(map, TVP5150_VERT_BLANKING_START, rect->top);
+	regmap_write(map, TVP5150_VERT_BLANKING_STOP,
+		     rect->top + rect->height - hmax);
+	regmap_write(map, TVP5150_ACT_VD_CROP_ST_MSB,
+		     rect->left >> TVP5150_CROP_SHIFT);
+	regmap_write(map, TVP5150_ACT_VD_CROP_ST_LSB,
+		     rect->left | (1 << TVP5150_CROP_SHIFT));
+	regmap_write(map, TVP5150_ACT_VD_CROP_STP_MSB,
+		     (rect->left + rect->width - TVP5150_MAX_CROP_LEFT) >>
+		     TVP5150_CROP_SHIFT);
+	regmap_write(map, TVP5150_ACT_VD_CROP_STP_LSB,
+		     rect->left + rect->width - TVP5150_MAX_CROP_LEFT);
+
+	decoder->rect = *rect;
 }
 
 static int tvp5150_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 {
-	struct v4l2_rect rect = a->c;
 	struct tvp5150 *decoder = to_tvp5150(sd);
+	struct v4l2_rect rect = a->c;
 	v4l2_std_id std;
-	unsigned int hmax;
 
 	v4l2_dbg(1, debug, sd, "%s left=%d, top=%d, width=%d, height=%d\n",
 		__func__, rect.left, rect.top, rect.width, rect.height);
@@ -858,42 +890,13 @@ static int tvp5150_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	/* tvp5150 has some special limits */
-	rect.left = clamp(rect.left, 0, TVP5150_MAX_CROP_LEFT);
-	rect.width = clamp_t(unsigned int, rect.width,
-			     TVP5150_H_MAX - TVP5150_MAX_CROP_LEFT - rect.left,
-			     TVP5150_H_MAX - rect.left);
-	rect.top = clamp(rect.top, 0, TVP5150_MAX_CROP_TOP);
-
-	/* Calculate height based on current standard */
 	if (decoder->norm == V4L2_STD_ALL)
 		std = tvp5150_read_std(sd);
 	else
 		std = decoder->norm;
 
-	if (std & V4L2_STD_525_60)
-		hmax = TVP5150_V_MAX_525_60;
-	else
-		hmax = TVP5150_V_MAX_OTHERS;
-
-	rect.height = clamp_t(unsigned int, rect.height,
-			      hmax - TVP5150_MAX_CROP_TOP - rect.top,
-			      hmax - rect.top);
-
-	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_START, rect.top);
-	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_STOP,
-		      rect.top + rect.height - hmax);
-	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_MSB,
-		      rect.left >> TVP5150_CROP_SHIFT);
-	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_LSB,
-		      rect.left | (1 << TVP5150_CROP_SHIFT));
-	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_MSB,
-		      (rect.left + rect.width - TVP5150_MAX_CROP_LEFT) >>
-		      TVP5150_CROP_SHIFT);
-	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_LSB,
-		      rect.left + rect.width - TVP5150_MAX_CROP_LEFT);
-
-	decoder->rect = rect;
+	tvp5150_try_crop(decoder, &rect, std);
+	tvp5150_set_crop(decoder, &rect, std);
 
 	return 0;
 }
@@ -1049,6 +1052,138 @@ static int tvp5150_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 
 /* ----------------------------------------------------------------------- */
 
+static struct v4l2_mbus_framefmt *
+tvp5150_get_pad_format(struct tvp5150 *decoder, struct v4l2_subdev *sd,
+			 struct v4l2_subdev_pad_config *cfg, unsigned int pad,
+			 enum v4l2_subdev_format_whence which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(sd, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &decoder->format;
+	default:
+		return NULL;
+	}
+}
+
+static struct v4l2_rect *
+tvp5150_get_pad_crop(struct tvp5150 *decoder, struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg, unsigned int pad,
+		       enum v4l2_subdev_format_whence which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_crop(sd, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &decoder->rect;
+	default:
+		return NULL;
+	}
+}
+
+static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	v4l2_std_id std;
+
+	if (fse->index > 0 || fse->code != MEDIA_BUS_FMT_UYVY8_2X8)
+		return -EINVAL;
+
+	fse->min_width = TVP5150_H_MAX - TVP5150_MAX_CROP_LEFT;
+	fse->max_width = TVP5150_H_MAX;
+
+	/* Calculate height based on current standard */
+	if (decoder->norm == V4L2_STD_ALL)
+		std = tvp5150_read_std(sd);
+	else
+		std = decoder->norm;
+
+	if (std & V4L2_STD_525_60) {
+		fse->min_height = TVP5150_V_MAX_525_60 - TVP5150_MAX_CROP_TOP;
+		fse->max_height = TVP5150_V_MAX_525_60;
+	} else {
+		fse->min_height = TVP5150_V_MAX_OTHERS - TVP5150_MAX_CROP_TOP;
+		fse->max_height = TVP5150_V_MAX_OTHERS;
+	}
+
+	return 0;
+}
+
+static int tvp5150_get_format(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_format *format)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+
+	format->format = *tvp5150_get_pad_format(decoder, sd, cfg,
+						   format->pad, format->which);
+	return 0;
+}
+
+static int tvp5150_set_format(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_format *format)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	struct v4l2_mbus_framefmt *mbus_format;
+	struct v4l2_rect *crop;
+
+	crop = tvp5150_get_pad_crop(decoder, sd, cfg, format->pad,
+					format->which);
+	mbus_format = tvp5150_get_pad_format(decoder, sd, cfg, format->pad,
+					    format->which);
+	mbus_format->width = crop->width;
+	mbus_format->height = crop->height;
+
+	format->format = *mbus_format;
+
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		tvp5150_reset(sd, 0);
+
+	v4l2_dbg(1, debug, sd, "width = %d, height = %d\n", mbus_format->width,
+			mbus_format->height);
+
+	return 0;
+}
+
+static void tvp5150_set_default(v4l2_std_id std, struct v4l2_rect *crop,
+				struct v4l2_mbus_framefmt *format)
+{
+	crop->left = 0;
+	crop->width = TVP5150_H_MAX;
+	crop->top = 0;
+	if (std & V4L2_STD_525_60)
+		crop->height = TVP5150_V_MAX_525_60;
+	else
+		crop->height = TVP5150_V_MAX_OTHERS;
+
+	format->width = crop->width;
+	format->height = crop->height;
+	format->code = MEDIA_BUS_FMT_UYVY8_2X8;
+	format->field = V4L2_FIELD_SEQ_TB;
+	format->colorspace = V4L2_COLORSPACE_SMPTE170M;
+}
+
+static int tvp5150_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	v4l2_std_id std;
+
+	if (decoder->norm == V4L2_STD_ALL)
+		std = tvp5150_read_std(sd);
+	else
+		std = decoder->norm;
+
+	tvp5150_set_default(std, v4l2_subdev_get_try_crop(fh, 0),
+				 v4l2_subdev_get_try_format(fh, 0));
+	return 0;
+}
+
+/* ----------------------------------------------------------------------- */
+
 static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
 	.s_ctrl = tvp5150_s_ctrl,
 };
@@ -1083,8 +1218,9 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
 
 static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
 	.enum_mbus_code = tvp5150_enum_mbus_code,
-	.set_fmt = tvp5150_fill_fmt,
-	.get_fmt = tvp5150_fill_fmt,
+	.enum_frame_size = tvp5150_enum_frame_size,
+	.get_fmt = tvp5150_get_format,
+	.set_fmt = tvp5150_set_format,
 };
 
 static const struct v4l2_subdev_ops tvp5150_ops = {
@@ -1095,6 +1231,9 @@ static const struct v4l2_subdev_ops tvp5150_ops = {
 	.pad = &tvp5150_pad_ops,
 };
 
+static const struct v4l2_subdev_internal_ops tvp5150_internal_ops = {
+	.open = tvp5150_open,
+};
 
 /****************************************************************************
 			I2C Client & Driver
@@ -1196,6 +1335,13 @@ static int tvp5150_probe(struct i2c_client *c,
 	core->regmap = map;
 	sd = &core->sd;
 	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
+	sd->internal_ops = &tvp5150_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
+	core->pad.flags = MEDIA_PAD_FL_SOURCE;
+	res = media_entity_init(&sd->entity, 1, &core->pad, 0);
+	if (res < 0)
+		return res;
 
 	/* 
 	 * Read consequent registers - TVP5150_MSB_DEV_ID, TVP5150_LSB_DEV_ID,
@@ -1250,14 +1396,9 @@ static int tvp5150_probe(struct i2c_client *c,
 	v4l2_ctrl_handler_setup(&core->hdl);
 
 	/* Default is no cropping */
-	core->rect.top = 0;
-	if (tvp5150_read_std(sd) & V4L2_STD_525_60)
-		core->rect.height = TVP5150_V_MAX_525_60;
-	else
-		core->rect.height = TVP5150_V_MAX_OTHERS;
-	core->rect.left = 0;
-	core->rect.width = TVP5150_H_MAX;
+	tvp5150_set_default(tvp5150_read_std(sd), &core->rect, &core->format);
 
+	sd->dev = &c->dev;
 	res = v4l2_async_register_subdev(sd);
 	if (res < 0)
 		goto err;
-- 
2.6.2

