Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48880 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932786AbbDIKWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 06:22:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 3/7] v4l2: replace try_mbus_fmt by set_fmt
Date: Thu,  9 Apr 2015 12:21:24 +0200
Message-Id: <1428574888-46407-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The try_mbus_fmt video op is a duplicate of the pad op. Replace all uses
in sub-devices by the set_fmt() pad op.

Since try_mbus_fmt and s_mbus_fmt both map to the set_fmt pad op (but
with a different 'which' argument), this patch will replace both try_mbus_fmt
and s_mbus_fmt by set_fmt.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/i2c/adv7183.c                        | 36 ++++++++--------
 drivers/media/i2c/mt9v011.c                        | 38 ++++++++---------
 drivers/media/i2c/ov7670.c                         | 27 +++++++-----
 drivers/media/i2c/saa6752hs.c                      | 28 +++++++------
 drivers/media/i2c/soc_camera/imx074.c              | 39 ++++++++----------
 drivers/media/i2c/soc_camera/mt9m001.c             | 17 +++++---
 drivers/media/i2c/soc_camera/mt9m111.c             | 31 ++++++--------
 drivers/media/i2c/soc_camera/mt9t031.c             | 48 +++++++++++-----------
 drivers/media/i2c/soc_camera/mt9t112.c             | 15 +++++--
 drivers/media/i2c/soc_camera/mt9v022.c             | 17 +++++---
 drivers/media/i2c/soc_camera/ov2640.c              | 36 +++++-----------
 drivers/media/i2c/soc_camera/ov5642.c              | 34 +++++++--------
 drivers/media/i2c/soc_camera/ov6650.c              | 17 +++++---
 drivers/media/i2c/soc_camera/ov772x.c              | 15 +++++--
 drivers/media/i2c/soc_camera/ov9640.c              | 17 ++++++--
 drivers/media/i2c/soc_camera/ov9740.c              | 16 ++++++--
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          | 40 +++++++-----------
 drivers/media/i2c/soc_camera/tw9910.c              | 15 +++++--
 drivers/media/i2c/sr030pc30.c                      | 38 ++++++++---------
 drivers/media/i2c/vs6624.c                         | 28 ++++++-------
 drivers/media/platform/soc_camera/sh_mobile_csi2.c | 35 ++++++++--------
 21 files changed, 304 insertions(+), 283 deletions(-)

diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 9d58b75..e2dd161 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -431,10 +431,15 @@ static int adv7183_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7183_try_mbus_fmt(struct v4l2_subdev *sd,
-				struct v4l2_mbus_framefmt *fmt)
+static int adv7183_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
 	struct adv7183 *decoder = to_adv7183(sd);
+	struct v4l2_mbus_framefmt *fmt = &format->format;
+
+	if (format->pad)
+		return -EINVAL;
 
 	fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
@@ -447,16 +452,10 @@ static int adv7183_try_mbus_fmt(struct v4l2_subdev *sd,
 		fmt->width = 720;
 		fmt->height = 576;
 	}
-	return 0;
-}
-
-static int adv7183_s_mbus_fmt(struct v4l2_subdev *sd,
-				struct v4l2_mbus_framefmt *fmt)
-{
-	struct adv7183 *decoder = to_adv7183(sd);
-
-	adv7183_try_mbus_fmt(sd, fmt);
-	decoder->fmt = *fmt;
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		decoder->fmt = *fmt;
+	else
+		cfg->try_fmt = *fmt;
 	return 0;
 }
 
@@ -519,14 +518,13 @@ static const struct v4l2_subdev_video_ops adv7183_video_ops = {
 	.s_routing = adv7183_s_routing,
 	.querystd = adv7183_querystd,
 	.g_input_status = adv7183_g_input_status,
-	.try_mbus_fmt = adv7183_try_mbus_fmt,
-	.s_mbus_fmt = adv7183_s_mbus_fmt,
 	.s_stream = adv7183_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops adv7183_pad_ops = {
 	.enum_mbus_code = adv7183_enum_mbus_code,
 	.get_fmt = adv7183_get_fmt,
+	.set_fmt = adv7183_set_fmt,
 };
 
 static const struct v4l2_subdev_ops adv7183_ops = {
@@ -542,7 +540,9 @@ static int adv7183_probe(struct i2c_client *client,
 	struct v4l2_subdev *sd;
 	struct v4l2_ctrl_handler *hdl;
 	int ret;
-	struct v4l2_mbus_framefmt fmt;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	const unsigned *pin_array;
 
 	/* Check if the adapter supports the needed features */
@@ -612,9 +612,9 @@ static int adv7183_probe(struct i2c_client *client,
 
 	adv7183_writeregs(sd, adv7183_init_regs, ARRAY_SIZE(adv7183_init_regs));
 	adv7183_s_std(sd, decoder->std);
-	fmt.width = 720;
-	fmt.height = 576;
-	adv7183_s_mbus_fmt(sd, &fmt);
+	fmt.format.width = 720;
+	fmt.format.height = 576;
+	adv7183_set_fmt(sd, NULL, &fmt);
 
 	/* initialize the hardware to the default control values */
 	ret = v4l2_ctrl_handler_setup(hdl);
diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index 6fae8fc..57132cd 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -335,9 +335,14 @@ static int mt9v011_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int mt9v011_try_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *fmt)
+static int mt9v011_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
-	if (fmt->code != MEDIA_BUS_FMT_SGRBG8_1X8)
+	struct v4l2_mbus_framefmt *fmt = &format->format;
+	struct mt9v011 *core = to_mt9v011(sd);
+
+	if (format->pad || fmt->code != MEDIA_BUS_FMT_SGRBG8_1X8)
 		return -EINVAL;
 
 	v4l_bound_align_image(&fmt->width, 48, 639, 1,
@@ -345,6 +350,15 @@ static int mt9v011_try_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefm
 	fmt->field = V4L2_FIELD_NONE;
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		core->width = fmt->width;
+		core->height = fmt->height;
+
+		set_res(sd);
+	} else {
+		cfg->try_fmt = *fmt;
+	}
+
 	return 0;
 }
 
@@ -386,23 +400,6 @@ static int mt9v011_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 	return 0;
 }
 
-static int mt9v011_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *fmt)
-{
-	struct mt9v011 *core = to_mt9v011(sd);
-	int rc;
-
-	rc = mt9v011_try_mbus_fmt(sd, fmt);
-	if (rc < 0)
-		return -EINVAL;
-
-	core->width = fmt->width;
-	core->height = fmt->height;
-
-	set_res(sd);
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9v011_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
@@ -470,14 +467,13 @@ static const struct v4l2_subdev_core_ops mt9v011_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops mt9v011_video_ops = {
-	.try_mbus_fmt = mt9v011_try_mbus_fmt,
-	.s_mbus_fmt = mt9v011_s_mbus_fmt,
 	.g_parm = mt9v011_g_parm,
 	.s_parm = mt9v011_s_parm,
 };
 
 static const struct v4l2_subdev_pad_ops mt9v011_pad_ops = {
 	.enum_mbus_code = mt9v011_enum_mbus_code,
+	.set_fmt = mt9v011_set_fmt,
 };
 
 static const struct v4l2_subdev_ops mt9v011_ops = {
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 1033bd7..23053ce 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -971,17 +971,12 @@ static int ov7670_try_fmt_internal(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov7670_try_mbus_fmt(struct v4l2_subdev *sd,
-			    struct v4l2_mbus_framefmt *fmt)
-{
-	return ov7670_try_fmt_internal(sd, fmt, NULL, NULL);
-}
-
 /*
  * Set a format.
  */
-static int ov7670_s_mbus_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *fmt)
+static int ov7670_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
 	struct ov7670_format_struct *ovfmt;
 	struct ov7670_win_size *wsize;
@@ -989,7 +984,18 @@ static int ov7670_s_mbus_fmt(struct v4l2_subdev *sd,
 	unsigned char com7;
 	int ret;
 
-	ret = ov7670_try_fmt_internal(sd, fmt, &ovfmt, &wsize);
+	if (format->pad)
+		return -EINVAL;
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		ret = ov7670_try_fmt_internal(sd, &format->format, NULL, NULL);
+		if (ret)
+			return ret;
+		cfg->try_fmt = format->format;
+		return 0;
+	}
+
+	ret = ov7670_try_fmt_internal(sd, &format->format, &ovfmt, &wsize);
 
 	if (ret)
 		return ret;
@@ -1486,8 +1492,6 @@ static const struct v4l2_subdev_core_ops ov7670_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops ov7670_video_ops = {
-	.try_mbus_fmt = ov7670_try_mbus_fmt,
-	.s_mbus_fmt = ov7670_s_mbus_fmt,
 	.s_parm = ov7670_s_parm,
 	.g_parm = ov7670_g_parm,
 };
@@ -1496,6 +1500,7 @@ static const struct v4l2_subdev_pad_ops ov7670_pad_ops = {
 	.enum_frame_interval = ov7670_enum_frame_interval,
 	.enum_frame_size = ov7670_enum_frame_size,
 	.enum_mbus_code = ov7670_enum_mbus_code,
+	.set_fmt = ov7670_set_fmt,
 };
 
 static const struct v4l2_subdev_ops ov7670_ops = {
diff --git a/drivers/media/i2c/saa6752hs.c b/drivers/media/i2c/saa6752hs.c
index b382907..ba3c415 100644
--- a/drivers/media/i2c/saa6752hs.c
+++ b/drivers/media/i2c/saa6752hs.c
@@ -574,10 +574,17 @@ static int saa6752hs_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int saa6752hs_try_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
+static int saa6752hs_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *f = &format->format;
+	struct saa6752hs_state *h = to_state(sd);
 	int dist_352, dist_480, dist_720;
 
+	if (format->pad)
+		return -EINVAL;
+
 	f->code = MEDIA_BUS_FMT_FIXED;
 
 	dist_352 = abs(f->width - 352);
@@ -598,15 +605,11 @@ static int saa6752hs_try_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_frame
 	}
 	f->field = V4L2_FIELD_INTERLACED;
 	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
-	return 0;
-}
 
-static int saa6752hs_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
-{
-	struct saa6752hs_state *h = to_state(sd);
-
-	if (f->code != MEDIA_BUS_FMT_FIXED)
-		return -EINVAL;
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = *f;
+		return 0;
+	}
 
 	/*
 	  FIXME: translate and round width/height into EMPRESS
@@ -620,7 +623,9 @@ static int saa6752hs_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefm
 	  D1     | 720x576 | 720x480
 	*/
 
-	saa6752hs_try_mbus_fmt(sd, f);
+	if (f->code != MEDIA_BUS_FMT_FIXED)
+		return -EINVAL;
+
 	if (f->width == 720)
 		h->video_format = SAA6752HS_VF_D1;
 	else if (f->width == 480)
@@ -653,12 +658,11 @@ static const struct v4l2_subdev_core_ops saa6752hs_core_ops = {
 
 static const struct v4l2_subdev_video_ops saa6752hs_video_ops = {
 	.s_std = saa6752hs_s_std,
-	.s_mbus_fmt = saa6752hs_s_mbus_fmt,
-	.try_mbus_fmt = saa6752hs_try_mbus_fmt,
 };
 
 static const struct v4l2_subdev_pad_ops saa6752hs_pad_ops = {
 	.get_fmt = saa6752hs_get_fmt,
+	.set_fmt = saa6752hs_set_fmt,
 };
 
 static const struct v4l2_subdev_ops saa6752hs_ops = {
diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index ba60ccf..f68c235 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -153,14 +153,24 @@ static int reg_read(struct i2c_client *client, const u16 addr)
 	return buf[0] & 0xff; /* no sign-extension */
 }
 
-static int imx074_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *mf)
+static int imx074_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	const struct imx074_datafmt *fmt = imx074_find_datafmt(mf->code);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct imx074 *priv = to_imx074(client);
+
+	if (format->pad)
+		return -EINVAL;
 
 	dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
 
 	if (!fmt) {
+		/* MIPI CSI could have changed the format, double-check */
+		if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
 		mf->code	= imx074_colour_fmts[0].code;
 		mf->colorspace	= imx074_colour_fmts[0].colorspace;
 	}
@@ -169,24 +179,10 @@ static int imx074_try_fmt(struct v4l2_subdev *sd,
 	mf->height	= IMX074_HEIGHT;
 	mf->field	= V4L2_FIELD_NONE;
 
-	return 0;
-}
-
-static int imx074_s_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct imx074 *priv = to_imx074(client);
-
-	dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
-
-	/* MIPI CSI could have changed the format, double-check */
-	if (!imx074_find_datafmt(mf->code))
-		return -EINVAL;
-
-	imx074_try_fmt(sd, mf);
-
-	priv->fmt = imx074_find_datafmt(mf->code);
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		priv->fmt = imx074_find_datafmt(mf->code);
+	else
+		cfg->try_fmt = *mf;
 
 	return 0;
 }
@@ -282,8 +278,6 @@ static int imx074_g_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
 	.s_stream	= imx074_s_stream,
-	.s_mbus_fmt	= imx074_s_fmt,
-	.try_mbus_fmt	= imx074_try_fmt,
 	.g_crop		= imx074_g_crop,
 	.cropcap	= imx074_cropcap,
 	.g_mbus_config	= imx074_g_mbus_config,
@@ -296,6 +290,7 @@ static struct v4l2_subdev_core_ops imx074_subdev_core_ops = {
 static const struct v4l2_subdev_pad_ops imx074_subdev_pad_ops = {
 	.enum_mbus_code = imx074_enum_mbus_code,
 	.get_fmt	= imx074_get_fmt,
+	.set_fmt	= imx074_set_fmt,
 };
 
 static struct v4l2_subdev_ops imx074_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 06f4e11..4fbdd1e 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -205,7 +205,7 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 
 	/*
 	 * The caller provides a supported format, as verified per
-	 * call to .try_mbus_fmt()
+	 * call to .set_fmt(FORMAT_TRY).
 	 */
 	if (!ret)
 		ret = reg_write(client, MT9M001_COLUMN_START, rect.left);
@@ -298,13 +298,18 @@ static int mt9m001_s_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int mt9m001_try_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_mbus_framefmt *mf)
+static int mt9m001_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	const struct mt9m001_datafmt *fmt;
 
+	if (format->pad)
+		return -EINVAL;
+
 	v4l_bound_align_image(&mf->width, MT9M001_MIN_WIDTH,
 		MT9M001_MAX_WIDTH, 1,
 		&mf->height, MT9M001_MIN_HEIGHT + mt9m001->y_skip_top,
@@ -322,6 +327,9 @@ static int mt9m001_try_fmt(struct v4l2_subdev *sd,
 
 	mf->colorspace	= fmt->colorspace;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return mt9m001_s_fmt(sd, mf);
+	cfg->try_fmt = *mf;
 	return 0;
 }
 
@@ -617,8 +625,6 @@ static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
 	.s_stream	= mt9m001_s_stream,
-	.s_mbus_fmt	= mt9m001_s_fmt,
-	.try_mbus_fmt	= mt9m001_try_fmt,
 	.s_crop		= mt9m001_s_crop,
 	.g_crop		= mt9m001_g_crop,
 	.cropcap	= mt9m001_cropcap,
@@ -633,6 +639,7 @@ static struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
 static const struct v4l2_subdev_pad_ops mt9m001_subdev_pad_ops = {
 	.enum_mbus_code = mt9m001_enum_mbus_code,
 	.get_fmt	= mt9m001_get_fmt,
+	.set_fmt	= mt9m001_set_fmt,
 };
 
 static struct v4l2_subdev_ops mt9m001_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 22e9c76..2f4369b 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -536,14 +536,20 @@ static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
 	return ret;
 }
 
-static int mt9m111_try_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_mbus_framefmt *mf)
+static int mt9m111_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 	const struct mt9m111_datafmt *fmt;
 	struct v4l2_rect *rect = &mt9m111->rect;
 	bool bayer;
+	int ret;
+
+	if (format->pad)
+		return -EINVAL;
 
 	fmt = mt9m111_find_datafmt(mt9m111, mf->code);
 
@@ -577,20 +583,10 @@ static int mt9m111_try_fmt(struct v4l2_subdev *sd,
 	mf->code = fmt->code;
 	mf->colorspace = fmt->colorspace;
 
-	return 0;
-}
-
-static int mt9m111_s_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
-{
-	const struct mt9m111_datafmt *fmt;
-	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
-	struct v4l2_rect *rect = &mt9m111->rect;
-	int ret;
-
-	mt9m111_try_fmt(sd, mf);
-	fmt = mt9m111_find_datafmt(mt9m111, mf->code);
-	/* try_fmt() guarantees fmt != NULL && fmt->code == mf->code */
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = *mf;
+		return 0;
+	}
 
 	ret = mt9m111_setup_geometry(mt9m111, rect, mf->width, mf->height, mf->code);
 	if (!ret)
@@ -871,8 +867,6 @@ static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
-	.s_mbus_fmt	= mt9m111_s_fmt,
-	.try_mbus_fmt	= mt9m111_try_fmt,
 	.s_crop		= mt9m111_s_crop,
 	.g_crop		= mt9m111_g_crop,
 	.cropcap	= mt9m111_cropcap,
@@ -882,6 +876,7 @@ static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
 	.enum_mbus_code = mt9m111_enum_mbus_code,
 	.get_fmt	= mt9m111_get_fmt,
+	.set_fmt	= mt9m111_set_fmt,
 };
 
 static struct v4l2_subdev_ops mt9m111_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 97193e4..3b6eeed 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -264,7 +264,7 @@ static int mt9t031_set_params(struct i2c_client *client,
 
 	/*
 	 * The caller provides a supported format, as guaranteed by
-	 * .try_mbus_fmt(), soc_camera_s_crop() and soc_camera_cropcap()
+	 * .set_fmt(FORMAT_TRY), soc_camera_s_crop() and soc_camera_cropcap()
 	 */
 	if (ret >= 0)
 		ret = reg_write(client, MT9T031_COLUMN_START, rect->left);
@@ -357,16 +357,36 @@ static int mt9t031_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int mt9t031_s_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
+/*
+ * If a user window larger than sensor window is requested, we'll increase the
+ * sensor window.
+ */
+static int mt9t031_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	u16 xskip, yskip;
 	struct v4l2_rect rect = mt9t031->rect;
 
+	if (format->pad)
+		return -EINVAL;
+
+	mf->code	= MEDIA_BUS_FMT_SBGGR10_1X10;
+	mf->colorspace	= V4L2_COLORSPACE_SRGB;
+	v4l_bound_align_image(
+			&mf->width, MT9T031_MIN_WIDTH, MT9T031_MAX_WIDTH, 1,
+			&mf->height, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT, 1, 0);
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = *mf;
+		return 0;
+	}
+
 	/*
-	 * try_fmt has put width and height within limits.
+	 * Width and height are within limits.
 	 * S_FMT: use binning and skipping for scaling
 	 */
 	xskip = mt9t031_skip(&rect.width, mf->width, MT9T031_MAX_WIDTH);
@@ -379,23 +399,6 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd,
 	return mt9t031_set_params(client, &rect, xskip, yskip);
 }
 
-/*
- * If a user window larger than sensor window is requested, we'll increase the
- * sensor window.
- */
-static int mt9t031_try_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_mbus_framefmt *mf)
-{
-	v4l_bound_align_image(
-		&mf->width, MT9T031_MIN_WIDTH, MT9T031_MAX_WIDTH, 1,
-		&mf->height, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT, 1, 0);
-
-	mf->code	= MEDIA_BUS_FMT_SBGGR10_1X10;
-	mf->colorspace	= V4L2_COLORSPACE_SRGB;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9t031_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
@@ -718,8 +721,6 @@ static int mt9t031_s_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops mt9t031_subdev_video_ops = {
 	.s_stream	= mt9t031_s_stream,
-	.s_mbus_fmt	= mt9t031_s_fmt,
-	.try_mbus_fmt	= mt9t031_try_fmt,
 	.s_crop		= mt9t031_s_crop,
 	.g_crop		= mt9t031_g_crop,
 	.cropcap	= mt9t031_cropcap,
@@ -734,6 +735,7 @@ static struct v4l2_subdev_sensor_ops mt9t031_subdev_sensor_ops = {
 static const struct v4l2_subdev_pad_ops mt9t031_subdev_pad_ops = {
 	.enum_mbus_code = mt9t031_enum_mbus_code,
 	.get_fmt	= mt9t031_get_fmt,
+	.set_fmt	= mt9t031_set_fmt,
 };
 
 static struct v4l2_subdev_ops mt9t031_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 889e98e..de10a76 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -945,14 +945,19 @@ static int mt9t112_s_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int mt9t112_try_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_mbus_framefmt *mf)
+static int mt9t112_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
 	unsigned int top, left;
 	int i;
 
+	if (format->pad)
+		return -EINVAL;
+
 	for (i = 0; i < priv->num_formats; i++)
 		if (mt9t112_cfmts[i].code == mf->code)
 			break;
@@ -968,6 +973,9 @@ static int mt9t112_try_fmt(struct v4l2_subdev *sd,
 
 	mf->field = V4L2_FIELD_NONE;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return mt9t112_s_fmt(sd, mf);
+	cfg->try_fmt = *mf;
 	return 0;
 }
 
@@ -1016,8 +1024,6 @@ static int mt9t112_s_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 	.s_stream	= mt9t112_s_stream,
-	.s_mbus_fmt	= mt9t112_s_fmt,
-	.try_mbus_fmt	= mt9t112_try_fmt,
 	.cropcap	= mt9t112_cropcap,
 	.g_crop		= mt9t112_g_crop,
 	.s_crop		= mt9t112_s_crop,
@@ -1028,6 +1034,7 @@ static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 static const struct v4l2_subdev_pad_ops mt9t112_subdev_pad_ops = {
 	.enum_mbus_code = mt9t112_enum_mbus_code,
 	.get_fmt	= mt9t112_get_fmt,
+	.set_fmt	= mt9t112_set_fmt,
 };
 
 /************************************************************************
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index b4ba3c5..f313774 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -412,7 +412,7 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
 
 	/*
 	 * The caller provides a supported format, as verified per call to
-	 * .try_mbus_fmt(), datawidth is from our supported format list
+	 * .set_fmt(FORMAT_TRY), datawidth is from our supported format list
 	 */
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_Y8_1X8:
@@ -442,15 +442,20 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int mt9v022_try_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_mbus_framefmt *mf)
+static int mt9v022_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	const struct mt9v022_datafmt *fmt;
 	int align = mf->code == MEDIA_BUS_FMT_SBGGR8_1X8 ||
 		mf->code == MEDIA_BUS_FMT_SBGGR10_1X10;
 
+	if (format->pad)
+		return -EINVAL;
+
 	v4l_bound_align_image(&mf->width, MT9V022_MIN_WIDTH,
 		MT9V022_MAX_WIDTH, align,
 		&mf->height, MT9V022_MIN_HEIGHT + mt9v022->y_skip_top,
@@ -465,6 +470,9 @@ static int mt9v022_try_fmt(struct v4l2_subdev *sd,
 
 	mf->colorspace	= fmt->colorspace;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return mt9v022_s_fmt(sd, mf);
+	cfg->try_fmt = *mf;
 	return 0;
 }
 
@@ -845,8 +853,6 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
 	.s_stream	= mt9v022_s_stream,
-	.s_mbus_fmt	= mt9v022_s_fmt,
-	.try_mbus_fmt	= mt9v022_try_fmt,
 	.s_crop		= mt9v022_s_crop,
 	.g_crop		= mt9v022_g_crop,
 	.cropcap	= mt9v022_cropcap,
@@ -861,6 +867,7 @@ static struct v4l2_subdev_sensor_ops mt9v022_subdev_sensor_ops = {
 static const struct v4l2_subdev_pad_ops mt9v022_subdev_pad_ops = {
 	.enum_mbus_code = mt9v022_enum_mbus_code,
 	.get_fmt	= mt9v022_get_fmt,
+	.set_fmt	= mt9v022_set_fmt,
 };
 
 static struct v4l2_subdev_ops mt9v022_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 0dffc63..9b4f5de 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -881,33 +881,16 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov2640_s_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int ov2640_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int ret;
-
 
-	switch (mf->code) {
-	case MEDIA_BUS_FMT_RGB565_2X8_BE:
-	case MEDIA_BUS_FMT_RGB565_2X8_LE:
-		mf->colorspace = V4L2_COLORSPACE_SRGB;
-		break;
-	default:
-		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
-	case MEDIA_BUS_FMT_YUYV8_2X8:
-	case MEDIA_BUS_FMT_UYVY8_2X8:
-		mf->colorspace = V4L2_COLORSPACE_JPEG;
-	}
-
-	ret = ov2640_set_params(client, &mf->width, &mf->height, mf->code);
-
-	return ret;
-}
+	if (format->pad)
+		return -EINVAL;
 
-static int ov2640_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *mf)
-{
 	/*
 	 * select suitable win, but don't store it
 	 */
@@ -927,6 +910,10 @@ static int ov2640_try_fmt(struct v4l2_subdev *sd,
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	}
 
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return ov2640_set_params(client, &mf->width,
+					 &mf->height, mf->code);
+	cfg->try_fmt = *mf;
 	return 0;
 }
 
@@ -1037,8 +1024,6 @@ static int ov2640_g_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
 	.s_stream	= ov2640_s_stream,
-	.s_mbus_fmt	= ov2640_s_fmt,
-	.try_mbus_fmt	= ov2640_try_fmt,
 	.cropcap	= ov2640_cropcap,
 	.g_crop		= ov2640_g_crop,
 	.g_mbus_config	= ov2640_g_mbus_config,
@@ -1047,6 +1032,7 @@ static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
 static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
 	.enum_mbus_code = ov2640_enum_mbus_code,
 	.get_fmt	= ov2640_get_fmt,
+	.set_fmt	= ov2640_set_fmt,
 };
 
 static struct v4l2_subdev_ops ov2640_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index a88397f..bab9ac0 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -786,39 +786,34 @@ static int ov5642_set_resolution(struct v4l2_subdev *sd)
 	return ret;
 }
 
-static int ov5642_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *mf)
+static int ov5642_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov5642 *priv = to_ov5642(client);
 	const struct ov5642_datafmt *fmt = ov5642_find_datafmt(mf->code);
 
+	if (format->pad)
+		return -EINVAL;
+
 	mf->width = priv->crop_rect.width;
 	mf->height = priv->crop_rect.height;
 
 	if (!fmt) {
+		if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
 		mf->code	= ov5642_colour_fmts[0].code;
 		mf->colorspace	= ov5642_colour_fmts[0].colorspace;
 	}
 
 	mf->field	= V4L2_FIELD_NONE;
 
-	return 0;
-}
-
-static int ov5642_s_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov5642 *priv = to_ov5642(client);
-
-	/* MIPI CSI could have changed the format, double-check */
-	if (!ov5642_find_datafmt(mf->code))
-		return -EINVAL;
-
-	ov5642_try_fmt(sd, mf);
-	priv->fmt = ov5642_find_datafmt(mf->code);
-
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		priv->fmt = ov5642_find_datafmt(mf->code);
+	else
+		cfg->try_fmt = *mf;
 	return 0;
 }
 
@@ -945,8 +940,6 @@ static int ov5642_s_power(struct v4l2_subdev *sd, int on)
 }
 
 static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
-	.s_mbus_fmt	= ov5642_s_fmt,
-	.try_mbus_fmt	= ov5642_try_fmt,
 	.s_crop		= ov5642_s_crop,
 	.g_crop		= ov5642_g_crop,
 	.cropcap	= ov5642_cropcap,
@@ -956,6 +949,7 @@ static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 static const struct v4l2_subdev_pad_ops ov5642_subdev_pad_ops = {
 	.enum_mbus_code = ov5642_enum_mbus_code,
 	.get_fmt	= ov5642_get_fmt,
+	.set_fmt	= ov5642_set_fmt,
 };
 
 static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 29f73a5..1f8af1e 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -685,16 +685,20 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		mf->width = priv->rect.width >> half_scale;
 		mf->height = priv->rect.height >> half_scale;
 	}
-
 	return ret;
 }
 
-static int ov6650_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *mf)
+static int ov6650_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
 
+	if (format->pad)
+		return -EINVAL;
+
 	if (is_unscaled_ok(mf->width, mf->height, &priv->rect))
 		v4l_bound_align_image(&mf->width, 2, W_CIF, 1,
 				&mf->height, 2, H_CIF, 1, 0);
@@ -718,6 +722,10 @@ static int ov6650_try_fmt(struct v4l2_subdev *sd,
 		break;
 	}
 
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return ov6650_s_fmt(sd, mf);
+	cfg->try_fmt = *mf;
+
 	return 0;
 }
 
@@ -935,8 +943,6 @@ static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops ov6650_video_ops = {
 	.s_stream	= ov6650_s_stream,
-	.s_mbus_fmt	= ov6650_s_fmt,
-	.try_mbus_fmt	= ov6650_try_fmt,
 	.cropcap	= ov6650_cropcap,
 	.g_crop		= ov6650_g_crop,
 	.s_crop		= ov6650_s_crop,
@@ -949,6 +955,7 @@ static struct v4l2_subdev_video_ops ov6650_video_ops = {
 static const struct v4l2_subdev_pad_ops ov6650_pad_ops = {
 	.enum_mbus_code = ov6650_enum_mbus_code,
 	.get_fmt	= ov6650_get_fmt,
+	.set_fmt	= ov6650_set_fmt,
 };
 
 static struct v4l2_subdev_ops ov6650_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 1db2044..f150a8b 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -920,12 +920,17 @@ static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 	return 0;
 }
 
-static int ov772x_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *mf)
+static int ov772x_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size *win;
 
+	if (format->pad)
+		return -EINVAL;
+
 	ov772x_select_params(mf, &cfmt, &win);
 
 	mf->code = cfmt->code;
@@ -934,6 +939,9 @@ static int ov772x_try_fmt(struct v4l2_subdev *sd,
 	mf->field = V4L2_FIELD_NONE;
 	mf->colorspace = cfmt->colorspace;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return ov772x_s_fmt(sd, mf);
+	cfg->try_fmt = *mf;
 	return 0;
 }
 
@@ -1022,8 +1030,6 @@ static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 	.s_stream	= ov772x_s_stream,
-	.s_mbus_fmt	= ov772x_s_fmt,
-	.try_mbus_fmt	= ov772x_try_fmt,
 	.cropcap	= ov772x_cropcap,
 	.g_crop		= ov772x_g_crop,
 	.g_mbus_config	= ov772x_g_mbus_config,
@@ -1032,6 +1038,7 @@ static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 static const struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
 	.enum_mbus_code = ov772x_enum_mbus_code,
 	.get_fmt	= ov772x_get_fmt,
+	.set_fmt	= ov772x_set_fmt,
 };
 
 static struct v4l2_subdev_ops ov772x_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 899b4d9..8caae1c 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -519,9 +519,15 @@ static int ov9640_s_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int ov9640_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *mf)
+static int ov9640_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
+
+	if (format->pad)
+		return -EINVAL;
+
 	ov9640_res_roundup(&mf->width, &mf->height);
 
 	mf->field = V4L2_FIELD_NONE;
@@ -537,6 +543,10 @@ static int ov9640_try_fmt(struct v4l2_subdev *sd,
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	}
 
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return ov9640_s_fmt(sd, mf);
+
+	cfg->try_fmt = *mf;
 	return 0;
 }
 
@@ -657,8 +667,6 @@ static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops ov9640_video_ops = {
 	.s_stream	= ov9640_s_stream,
-	.s_mbus_fmt	= ov9640_s_fmt,
-	.try_mbus_fmt	= ov9640_try_fmt,
 	.cropcap	= ov9640_cropcap,
 	.g_crop		= ov9640_g_crop,
 	.g_mbus_config	= ov9640_g_mbus_config,
@@ -666,6 +674,7 @@ static struct v4l2_subdev_video_ops ov9640_video_ops = {
 
 static const struct v4l2_subdev_pad_ops ov9640_pad_ops = {
 	.enum_mbus_code = ov9640_enum_mbus_code,
+	.set_fmt	= ov9640_set_fmt,
 };
 
 static struct v4l2_subdev_ops ov9640_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 5d9b249..03a7fc7 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -704,15 +704,24 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int ov9740_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *mf)
+static int ov9740_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
+
+	if (format->pad)
+		return -EINVAL;
+
 	ov9740_res_roundup(&mf->width, &mf->height);
 
 	mf->field = V4L2_FIELD_NONE;
 	mf->code = MEDIA_BUS_FMT_YUYV8_2X8;
 	mf->colorspace = V4L2_COLORSPACE_SRGB;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return ov9740_s_fmt(sd, mf);
+	cfg->try_fmt = *mf;
 	return 0;
 }
 
@@ -905,8 +914,6 @@ static int ov9740_g_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops ov9740_video_ops = {
 	.s_stream	= ov9740_s_stream,
-	.s_mbus_fmt	= ov9740_s_fmt,
-	.try_mbus_fmt	= ov9740_try_fmt,
 	.cropcap	= ov9740_cropcap,
 	.g_crop		= ov9740_g_crop,
 	.g_mbus_config	= ov9740_g_mbus_config,
@@ -922,6 +929,7 @@ static struct v4l2_subdev_core_ops ov9740_core_ops = {
 
 static const struct v4l2_subdev_pad_ops ov9740_pad_ops = {
 	.enum_mbus_code = ov9740_enum_mbus_code,
+	.set_fmt	= ov9740_set_fmt,
 };
 
 static struct v4l2_subdev_ops ov9740_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 8787142..c769cf6 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -965,17 +965,25 @@ static int rj54n1_reg_init(struct i2c_client *client)
 	return ret;
 }
 
-static int rj54n1_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *mf)
+static int rj54n1_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	const struct rj54n1_datafmt *fmt;
+	int output_w, output_h, max_w, max_h,
+		input_w = rj54n1->rect.width, input_h = rj54n1->rect.height;
 	int align = mf->code == MEDIA_BUS_FMT_SBGGR10_1X10 ||
 		mf->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE ||
 		mf->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE ||
 		mf->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE ||
 		mf->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE;
+	int ret;
+
+	if (format->pad)
+		return -EINVAL;
 
 	dev_dbg(&client->dev, "%s: code = %d, width = %u, height = %u\n",
 		__func__, mf->code, mf->width, mf->height);
@@ -993,24 +1001,10 @@ static int rj54n1_try_fmt(struct v4l2_subdev *sd,
 	v4l_bound_align_image(&mf->width, 112, RJ54N1_MAX_WIDTH, align,
 			      &mf->height, 84, RJ54N1_MAX_HEIGHT, align, 0);
 
-	return 0;
-}
-
-static int rj54n1_s_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	const struct rj54n1_datafmt *fmt;
-	int output_w, output_h, max_w, max_h,
-		input_w = rj54n1->rect.width, input_h = rj54n1->rect.height;
-	int ret;
-
-	/*
-	 * The host driver can call us without .try_fmt(), so, we have to take
-	 * care ourseleves
-	 */
-	rj54n1_try_fmt(sd, mf);
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = *mf;
+		return 0;
+	}
 
 	/*
 	 * Verify if the sensor has just been powered on. TODO: replace this
@@ -1026,9 +1020,6 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd,
 			return ret;
 	}
 
-	dev_dbg(&client->dev, "%s: code = %d, width = %u, height = %u\n",
-		__func__, mf->code, mf->width, mf->height);
-
 	/* RA_SEL_UL is only relevant for raw modes, ignored otherwise. */
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_YUYV8_2X8:
@@ -1255,8 +1246,6 @@ static int rj54n1_s_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 	.s_stream	= rj54n1_s_stream,
-	.s_mbus_fmt	= rj54n1_s_fmt,
-	.try_mbus_fmt	= rj54n1_try_fmt,
 	.g_crop		= rj54n1_g_crop,
 	.s_crop		= rj54n1_s_crop,
 	.cropcap	= rj54n1_cropcap,
@@ -1267,6 +1256,7 @@ static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 static const struct v4l2_subdev_pad_ops rj54n1_subdev_pad_ops = {
 	.enum_mbus_code = rj54n1_enum_mbus_code,
 	.get_fmt	= rj54n1_get_fmt,
+	.set_fmt	= rj54n1_set_fmt,
 };
 
 static struct v4l2_subdev_ops rj54n1_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 9583795..42bec9b 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -742,13 +742,18 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int tw9910_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *mf)
+static int tw9910_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
 	const struct tw9910_scale_ctrl *scale;
 
+	if (format->pad)
+		return -EINVAL;
+
 	if (V4L2_FIELD_ANY == mf->field) {
 		mf->field = V4L2_FIELD_INTERLACED_BT;
 	} else if (V4L2_FIELD_INTERLACED_BT != mf->field) {
@@ -769,6 +774,9 @@ static int tw9910_try_fmt(struct v4l2_subdev *sd,
 	mf->width	= scale->width;
 	mf->height	= scale->height;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return tw9910_s_fmt(sd, mf);
+	cfg->try_fmt = *mf;
 	return 0;
 }
 
@@ -886,8 +894,6 @@ static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.s_std		= tw9910_s_std,
 	.g_std		= tw9910_g_std,
 	.s_stream	= tw9910_s_stream,
-	.s_mbus_fmt	= tw9910_s_fmt,
-	.try_mbus_fmt	= tw9910_try_fmt,
 	.cropcap	= tw9910_cropcap,
 	.g_crop		= tw9910_g_crop,
 	.g_mbus_config	= tw9910_g_mbus_config,
@@ -898,6 +904,7 @@ static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 static const struct v4l2_subdev_pad_ops tw9910_subdev_pad_ops = {
 	.enum_mbus_code = tw9910_enum_mbus_code,
 	.get_fmt	= tw9910_get_fmt,
+	.set_fmt	= tw9910_set_fmt,
 };
 
 static struct v4l2_subdev_ops tw9910_subdev_ops = {
diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index c0fa945..b62b6dd 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -529,25 +529,28 @@ static const struct sr030pc30_format *try_fmt(struct v4l2_subdev *sd,
 }
 
 /* Return nearest media bus frame format. */
-static int sr030pc30_try_fmt(struct v4l2_subdev *sd,
-			     struct v4l2_mbus_framefmt *mf)
+static int sr030pc30_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
-	if (!sd || !mf)
-		return -EINVAL;
-
-	try_fmt(sd, mf);
-	return 0;
-}
+	struct sr030pc30_info *info = sd ? to_sr030pc30(sd) : NULL;
+	const struct sr030pc30_format *fmt;
+	struct v4l2_mbus_framefmt *mf;
 
-static int sr030pc30_s_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_mbus_framefmt *mf)
-{
-	struct sr030pc30_info *info = to_sr030pc30(sd);
+	if (!sd || !format)
+		return -EINVAL;
 
-	if (!sd || !mf)
+	mf = &format->format;
+	if (format->pad)
 		return -EINVAL;
 
-	info->curr_fmt = try_fmt(sd, mf);
+	fmt = try_fmt(sd, mf);
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = *mf;
+		return 0;
+	}
+
+	info->curr_fmt = fmt;
 
 	return sr030pc30_set_params(sd);
 }
@@ -642,19 +645,14 @@ static const struct v4l2_subdev_core_ops sr030pc30_core_ops = {
 	.querymenu = v4l2_subdev_querymenu,
 };
 
-static const struct v4l2_subdev_video_ops sr030pc30_video_ops = {
-	.s_mbus_fmt	= sr030pc30_s_fmt,
-	.try_mbus_fmt	= sr030pc30_try_fmt,
-};
-
 static const struct v4l2_subdev_pad_ops sr030pc30_pad_ops = {
 	.enum_mbus_code = sr030pc30_enum_mbus_code,
 	.get_fmt	= sr030pc30_get_fmt,
+	.set_fmt	= sr030pc30_set_fmt,
 };
 
 static const struct v4l2_subdev_ops sr030pc30_ops = {
 	.core	= &sr030pc30_core_ops,
-	.video	= &sr030pc30_video_ops,
 	.pad	= &sr030pc30_pad_ops,
 };
 
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 59f7335..4c72a18 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -568,11 +568,17 @@ static int vs6624_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int vs6624_try_mbus_fmt(struct v4l2_subdev *sd,
-				struct v4l2_mbus_framefmt *fmt)
+static int vs6624_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *fmt = &format->format;
+	struct vs6624 *sensor = to_vs6624(sd);
 	int index;
 
+	if (format->pad)
+		return -EINVAL;
+
 	for (index = 0; index < ARRAY_SIZE(vs6624_formats); index++)
 		if (vs6624_formats[index].mbus_code == fmt->code)
 			break;
@@ -591,18 +597,11 @@ static int vs6624_try_mbus_fmt(struct v4l2_subdev *sd,
 	fmt->height = fmt->height & (~3);
 	fmt->field = V4L2_FIELD_NONE;
 	fmt->colorspace = vs6624_formats[index].colorspace;
-	return 0;
-}
 
-static int vs6624_s_mbus_fmt(struct v4l2_subdev *sd,
-				struct v4l2_mbus_framefmt *fmt)
-{
-	struct vs6624 *sensor = to_vs6624(sd);
-	int ret;
-
-	ret = vs6624_try_mbus_fmt(sd, fmt);
-	if (ret)
-		return ret;
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = *fmt;
+		return 0;
+	}
 
 	/* set image format */
 	switch (fmt->code) {
@@ -743,8 +742,6 @@ static const struct v4l2_subdev_core_ops vs6624_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops vs6624_video_ops = {
-	.try_mbus_fmt = vs6624_try_mbus_fmt,
-	.s_mbus_fmt = vs6624_s_mbus_fmt,
 	.s_parm = vs6624_s_parm,
 	.g_parm = vs6624_g_parm,
 	.s_stream = vs6624_s_stream,
@@ -753,6 +750,7 @@ static const struct v4l2_subdev_video_ops vs6624_video_ops = {
 static const struct v4l2_subdev_pad_ops vs6624_pad_ops = {
 	.enum_mbus_code = vs6624_enum_mbus_code,
 	.get_fmt = vs6624_get_fmt,
+	.set_fmt = vs6624_set_fmt,
 };
 
 static const struct v4l2_subdev_ops vs6624_ops = {
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index cd93241..12d3626 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -45,11 +45,17 @@ struct sh_csi2 {
 
 static void sh_csi2_hwinit(struct sh_csi2 *priv);
 
-static int sh_csi2_try_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_mbus_framefmt *mf)
+static int sh_csi2_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
 	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
 	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
+	struct v4l2_mbus_framefmt *mf = &format->format;
+	u32 tmp = (priv->client->channel & 3) << 8;
+
+	if (format->pad)
+		return -EINVAL;
 
 	if (mf->width > 8188)
 		mf->width = 8188;
@@ -85,21 +91,11 @@ static int sh_csi2_try_fmt(struct v4l2_subdev *sd,
 		break;
 	}
 
-	return 0;
-}
-
-/*
- * We have done our best in try_fmt to try and tell the sensor, which formats
- * we support. If now the configuration is unsuitable for us we can only
- * error out.
- */
-static int sh_csi2_s_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
-{
-	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
-	u32 tmp = (priv->client->channel & 3) << 8;
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = *mf;
+		return 0;
+	}
 
-	dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
 	if (mf->width > 8188 || mf->width & 1)
 		return -EINVAL;
 
@@ -211,12 +207,14 @@ static int sh_csi2_s_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops sh_csi2_subdev_video_ops = {
-	.s_mbus_fmt	= sh_csi2_s_fmt,
-	.try_mbus_fmt	= sh_csi2_try_fmt,
 	.g_mbus_config	= sh_csi2_g_mbus_config,
 	.s_mbus_config	= sh_csi2_s_mbus_config,
 };
 
+static struct v4l2_subdev_pad_ops sh_csi2_subdev_pad_ops = {
+	.set_fmt	= sh_csi2_set_fmt,
+};
+
 static void sh_csi2_hwinit(struct sh_csi2 *priv)
 {
 	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
@@ -313,6 +311,7 @@ static struct v4l2_subdev_core_ops sh_csi2_subdev_core_ops = {
 static struct v4l2_subdev_ops sh_csi2_subdev_ops = {
 	.core	= &sh_csi2_subdev_core_ops,
 	.video	= &sh_csi2_subdev_video_ops,
+	.pad	= &sh_csi2_subdev_pad_ops,
 };
 
 static int sh_csi2_probe(struct platform_device *pdev)
-- 
2.1.4

