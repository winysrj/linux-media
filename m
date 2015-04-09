Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:57486 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932786AbbDIKVz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 06:21:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 2/7] v4l2: replace video op g_mbus_fmt by pad op get_fmt
Date: Thu,  9 Apr 2015 12:21:23 +0200
Message-Id: <1428574888-46407-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The g_mbus_fmt video op is a duplicate of the pad op. Replace all uses
by the get_fmt pad op and remove the video op.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/i2c/adv7170.c                        | 11 +++--
 drivers/media/i2c/adv7175.c                        | 11 +++--
 drivers/media/i2c/adv7183.c                        | 12 +++--
 drivers/media/i2c/adv7842.c                        | 14 ++++--
 drivers/media/i2c/ak881x.c                         | 24 ++++------
 drivers/media/i2c/ml86v7667.c                      | 14 ++++--
 drivers/media/i2c/saa6752hs.c                      | 14 +++++-
 drivers/media/i2c/soc_camera/imx074.c              | 11 +++--
 drivers/media/i2c/soc_camera/mt9m001.c             | 11 +++--
 drivers/media/i2c/soc_camera/mt9m111.c             | 11 +++--
 drivers/media/i2c/soc_camera/mt9t031.c             | 11 +++--
 drivers/media/i2c/soc_camera/mt9t112.c             | 11 +++--
 drivers/media/i2c/soc_camera/mt9v022.c             | 11 +++--
 drivers/media/i2c/soc_camera/ov2640.c              | 11 +++--
 drivers/media/i2c/soc_camera/ov5642.c              | 11 +++--
 drivers/media/i2c/soc_camera/ov6650.c              | 11 +++--
 drivers/media/i2c/soc_camera/ov772x.c              | 11 +++--
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          | 11 +++--
 drivers/media/i2c/soc_camera/tw9910.c              | 11 +++--
 drivers/media/i2c/sr030pc30.c                      | 12 +++--
 drivers/media/i2c/tvp514x.c                        | 35 ++------------
 drivers/media/i2c/tvp5150.c                        | 15 +++---
 drivers/media/i2c/tvp7002.c                        | 28 -----------
 drivers/media/i2c/vs6624.c                         | 12 +++--
 drivers/media/pci/saa7134/saa7134-empress.c        |  9 ++--
 drivers/media/platform/am437x/am437x-vpfe.c        |  6 +--
 drivers/media/platform/davinci/vpfe_capture.c      | 19 ++++----
 drivers/media/platform/s5p-tv/hdmi_drv.c           | 12 +++--
 drivers/media/platform/s5p-tv/mixer_drv.c          | 15 ++++--
 drivers/media/platform/s5p-tv/sdo_drv.c            | 14 ++++--
 drivers/media/platform/soc_camera/mx2_camera.c     | 13 ++++--
 drivers/media/platform/soc_camera/mx3_camera.c     | 25 +++++-----
 drivers/media/platform/soc_camera/omap1_camera.c   | 17 ++++---
 drivers/media/platform/soc_camera/pxa_camera.c     | 21 +++++----
 drivers/media/platform/soc_camera/rcar_vin.c       | 46 ++++++++++--------
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 54 ++++++++++++----------
 drivers/media/platform/soc_camera/soc_camera.c     | 15 +++---
 .../platform/soc_camera/soc_camera_platform.c      |  9 ++--
 include/media/v4l2-subdev.h                        |  4 --
 39 files changed, 352 insertions(+), 261 deletions(-)

diff --git a/drivers/media/i2c/adv7170.c b/drivers/media/i2c/adv7170.c
index cfe963b..58d0a3c 100644
--- a/drivers/media/i2c/adv7170.c
+++ b/drivers/media/i2c/adv7170.c
@@ -273,11 +273,16 @@ static int adv7170_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7170_g_fmt(struct v4l2_subdev *sd,
-				struct v4l2_mbus_framefmt *mf)
+static int adv7170_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	u8 val = adv7170_read(sd, 0x7);
 
+	if (format->pad)
+		return -EINVAL;
+
 	if ((val & 0x40) == (1 << 6))
 		mf->code = MEDIA_BUS_FMT_UYVY8_1X16;
 	else
@@ -323,11 +328,11 @@ static const struct v4l2_subdev_video_ops adv7170_video_ops = {
 	.s_std_output = adv7170_s_std_output,
 	.s_routing = adv7170_s_routing,
 	.s_mbus_fmt = adv7170_s_fmt,
-	.g_mbus_fmt = adv7170_g_fmt,
 };
 
 static const struct v4l2_subdev_pad_ops adv7170_pad_ops = {
 	.enum_mbus_code = adv7170_enum_mbus_code,
+	.get_fmt = adv7170_get_fmt,
 };
 
 static const struct v4l2_subdev_ops adv7170_ops = {
diff --git a/drivers/media/i2c/adv7175.c b/drivers/media/i2c/adv7175.c
index 3f40304..f744345 100644
--- a/drivers/media/i2c/adv7175.c
+++ b/drivers/media/i2c/adv7175.c
@@ -311,11 +311,16 @@ static int adv7175_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7175_g_fmt(struct v4l2_subdev *sd,
-				struct v4l2_mbus_framefmt *mf)
+static int adv7175_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	u8 val = adv7175_read(sd, 0x7);
 
+	if (format->pad)
+		return -EINVAL;
+
 	if ((val & 0x40) == (1 << 6))
 		mf->code = MEDIA_BUS_FMT_UYVY8_1X16;
 	else
@@ -376,11 +381,11 @@ static const struct v4l2_subdev_video_ops adv7175_video_ops = {
 	.s_std_output = adv7175_s_std_output,
 	.s_routing = adv7175_s_routing,
 	.s_mbus_fmt = adv7175_s_fmt,
-	.g_mbus_fmt = adv7175_g_fmt,
 };
 
 static const struct v4l2_subdev_pad_ops adv7175_pad_ops = {
 	.enum_mbus_code = adv7175_enum_mbus_code,
+	.get_fmt = adv7175_get_fmt,
 };
 
 static const struct v4l2_subdev_ops adv7175_ops = {
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index a0bcfef..9d58b75 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -460,12 +460,16 @@ static int adv7183_s_mbus_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7183_g_mbus_fmt(struct v4l2_subdev *sd,
-				struct v4l2_mbus_framefmt *fmt)
+static int adv7183_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
 	struct adv7183 *decoder = to_adv7183(sd);
 
-	*fmt = decoder->fmt;
+	if (format->pad)
+		return -EINVAL;
+
+	format->format = decoder->fmt;
 	return 0;
 }
 
@@ -517,12 +521,12 @@ static const struct v4l2_subdev_video_ops adv7183_video_ops = {
 	.g_input_status = adv7183_g_input_status,
 	.try_mbus_fmt = adv7183_try_mbus_fmt,
 	.s_mbus_fmt = adv7183_s_mbus_fmt,
-	.g_mbus_fmt = adv7183_g_mbus_fmt,
 	.s_stream = adv7183_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops adv7183_pad_ops = {
 	.enum_mbus_code = adv7183_enum_mbus_code,
+	.get_fmt = adv7183_get_fmt,
 };
 
 static const struct v4l2_subdev_ops adv7183_ops = {
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 644e910..86e65a8 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1878,11 +1878,16 @@ static int adv7842_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7842_g_mbus_fmt(struct v4l2_subdev *sd,
-			      struct v4l2_mbus_framefmt *fmt)
+static int adv7842_fill_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *fmt = &format->format;
 	struct adv7842_state *state = to_state(sd);
 
+	if (format->pad)
+		return -EINVAL;
+
 	fmt->width = state->timings.bt.width;
 	fmt->height = state->timings.bt.height;
 	fmt->code = MEDIA_BUS_FMT_FIXED;
@@ -2810,9 +2815,6 @@ static const struct v4l2_subdev_video_ops adv7842_video_ops = {
 	.s_dv_timings = adv7842_s_dv_timings,
 	.g_dv_timings = adv7842_g_dv_timings,
 	.query_dv_timings = adv7842_query_dv_timings,
-	.g_mbus_fmt = adv7842_g_mbus_fmt,
-	.try_mbus_fmt = adv7842_g_mbus_fmt,
-	.s_mbus_fmt = adv7842_g_mbus_fmt,
 };
 
 static const struct v4l2_subdev_pad_ops adv7842_pad_ops = {
@@ -2821,6 +2823,8 @@ static const struct v4l2_subdev_pad_ops adv7842_pad_ops = {
 	.enum_dv_timings = adv7842_enum_dv_timings,
 	.dv_timings_cap = adv7842_dv_timings_cap,
 	.enum_mbus_code = adv7842_enum_mbus_code,
+	.get_fmt = adv7842_fill_fmt,
+	.set_fmt = adv7842_fill_fmt,
 };
 
 static const struct v4l2_subdev_ops adv7842_ops = {
diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index 4428fb9..2984624 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -93,12 +93,17 @@ static int ak881x_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static int ak881x_try_g_mbus_fmt(struct v4l2_subdev *sd,
-				 struct v4l2_mbus_framefmt *mf)
+static int ak881x_fill_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ak881x *ak881x = to_ak881x(client);
 
+	if (format->pad)
+		return -EINVAL;
+
 	v4l_bound_align_image(&mf->width, 0, 720, 2,
 			      &mf->height, 0, ak881x->lines, 1, 0);
 	mf->field	= V4L2_FIELD_INTERLACED;
@@ -108,16 +113,6 @@ static int ak881x_try_g_mbus_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ak881x_s_mbus_fmt(struct v4l2_subdev *sd,
-			     struct v4l2_mbus_framefmt *mf)
-{
-	if (mf->field != V4L2_FIELD_INTERLACED ||
-	    mf->code != MEDIA_BUS_FMT_YUYV8_2X8)
-		return -EINVAL;
-
-	return ak881x_try_g_mbus_fmt(sd, mf);
-}
-
 static int ak881x_enum_mbus_code(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_mbus_code_enum *code)
@@ -212,9 +207,6 @@ static struct v4l2_subdev_core_ops ak881x_subdev_core_ops = {
 };
 
 static struct v4l2_subdev_video_ops ak881x_subdev_video_ops = {
-	.s_mbus_fmt	= ak881x_s_mbus_fmt,
-	.g_mbus_fmt	= ak881x_try_g_mbus_fmt,
-	.try_mbus_fmt	= ak881x_try_g_mbus_fmt,
 	.cropcap	= ak881x_cropcap,
 	.s_std_output	= ak881x_s_std_output,
 	.s_stream	= ak881x_s_stream,
@@ -222,6 +214,8 @@ static struct v4l2_subdev_video_ops ak881x_subdev_video_ops = {
 
 static const struct v4l2_subdev_pad_ops ak881x_subdev_pad_ops = {
 	.enum_mbus_code = ak881x_enum_mbus_code,
+	.set_fmt	= ak881x_fill_fmt,
+	.get_fmt	= ak881x_fill_fmt,
 };
 
 static struct v4l2_subdev_ops ak881x_subdev_ops = {
diff --git a/drivers/media/i2c/ml86v7667.c b/drivers/media/i2c/ml86v7667.c
index e7b2202..af5eaf2 100644
--- a/drivers/media/i2c/ml86v7667.c
+++ b/drivers/media/i2c/ml86v7667.c
@@ -203,10 +203,15 @@ static int ml86v7667_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ml86v7667_mbus_fmt(struct v4l2_subdev *sd,
-			      struct v4l2_mbus_framefmt *fmt)
+static int ml86v7667_fill_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
 	struct ml86v7667_priv *priv = to_ml86v7667(sd);
+	struct v4l2_mbus_framefmt *fmt = &format->format;
+
+	if (format->pad)
+		return -EINVAL;
 
 	fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
@@ -280,14 +285,13 @@ static struct v4l2_subdev_video_ops ml86v7667_subdev_video_ops = {
 	.s_std = ml86v7667_s_std,
 	.querystd = ml86v7667_querystd,
 	.g_input_status = ml86v7667_g_input_status,
-	.try_mbus_fmt = ml86v7667_mbus_fmt,
-	.g_mbus_fmt = ml86v7667_mbus_fmt,
-	.s_mbus_fmt = ml86v7667_mbus_fmt,
 	.g_mbus_config = ml86v7667_g_mbus_config,
 };
 
 static const struct v4l2_subdev_pad_ops ml86v7667_subdev_pad_ops = {
 	.enum_mbus_code = ml86v7667_enum_mbus_code,
+	.get_fmt = ml86v7667_fill_fmt,
+	.set_fmt = ml86v7667_fill_fmt,
 };
 
 static struct v4l2_subdev_core_ops ml86v7667_subdev_core_ops = {
diff --git a/drivers/media/i2c/saa6752hs.c b/drivers/media/i2c/saa6752hs.c
index f14c0e6..b382907 100644
--- a/drivers/media/i2c/saa6752hs.c
+++ b/drivers/media/i2c/saa6752hs.c
@@ -554,10 +554,16 @@ static int saa6752hs_init(struct v4l2_subdev *sd, u32 leading_null_bytes)
 	return 0;
 }
 
-static int saa6752hs_g_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
+static int saa6752hs_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *f = &format->format;
 	struct saa6752hs_state *h = to_state(sd);
 
+	if (format->pad)
+		return -EINVAL;
+
 	if (h->video_format == SAA6752HS_VF_UNKNOWN)
 		h->video_format = SAA6752HS_VF_D1;
 	f->width = v4l2_format_table[h->video_format].fmt.pix.width;
@@ -649,12 +655,16 @@ static const struct v4l2_subdev_video_ops saa6752hs_video_ops = {
 	.s_std = saa6752hs_s_std,
 	.s_mbus_fmt = saa6752hs_s_mbus_fmt,
 	.try_mbus_fmt = saa6752hs_try_mbus_fmt,
-	.g_mbus_fmt = saa6752hs_g_mbus_fmt,
+};
+
+static const struct v4l2_subdev_pad_ops saa6752hs_pad_ops = {
+	.get_fmt = saa6752hs_get_fmt,
 };
 
 static const struct v4l2_subdev_ops saa6752hs_ops = {
 	.core = &saa6752hs_core_ops,
 	.video = &saa6752hs_video_ops,
+	.pad = &saa6752hs_pad_ops,
 };
 
 static int saa6752hs_probe(struct i2c_client *client,
diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index 7a2d906..ba60ccf 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -191,14 +191,19 @@ static int imx074_s_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int imx074_g_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int imx074_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct imx074 *priv = to_imx074(client);
 
 	const struct imx074_datafmt *fmt = priv->fmt;
 
+	if (format->pad)
+		return -EINVAL;
+
 	mf->code	= fmt->code;
 	mf->colorspace	= fmt->colorspace;
 	mf->width	= IMX074_WIDTH;
@@ -278,7 +283,6 @@ static int imx074_g_mbus_config(struct v4l2_subdev *sd,
 static struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
 	.s_stream	= imx074_s_stream,
 	.s_mbus_fmt	= imx074_s_fmt,
-	.g_mbus_fmt	= imx074_g_fmt,
 	.try_mbus_fmt	= imx074_try_fmt,
 	.g_crop		= imx074_g_crop,
 	.cropcap	= imx074_cropcap,
@@ -291,6 +295,7 @@ static struct v4l2_subdev_core_ops imx074_subdev_core_ops = {
 
 static const struct v4l2_subdev_pad_ops imx074_subdev_pad_ops = {
 	.enum_mbus_code = imx074_enum_mbus_code,
+	.get_fmt	= imx074_get_fmt,
 };
 
 static struct v4l2_subdev_ops imx074_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index ba18e01..06f4e11 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -250,11 +250,16 @@ static int mt9m001_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9m001_g_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
+static int mt9m001_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
+	struct v4l2_mbus_framefmt *mf = &format->format;
+
+	if (format->pad)
+		return -EINVAL;
 
 	mf->width	= mt9m001->rect.width;
 	mf->height	= mt9m001->rect.height;
@@ -613,7 +618,6 @@ static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
 static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
 	.s_stream	= mt9m001_s_stream,
 	.s_mbus_fmt	= mt9m001_s_fmt,
-	.g_mbus_fmt	= mt9m001_g_fmt,
 	.try_mbus_fmt	= mt9m001_try_fmt,
 	.s_crop		= mt9m001_s_crop,
 	.g_crop		= mt9m001_g_crop,
@@ -628,6 +632,7 @@ static struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
 
 static const struct v4l2_subdev_pad_ops mt9m001_subdev_pad_ops = {
 	.enum_mbus_code = mt9m001_enum_mbus_code,
+	.get_fmt	= mt9m001_get_fmt,
 };
 
 static struct v4l2_subdev_ops mt9m001_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index ef8682c..22e9c76 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -447,11 +447,16 @@ static int mt9m111_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9m111_g_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
+static int mt9m111_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 
+	if (format->pad)
+		return -EINVAL;
+
 	mf->width	= mt9m111->width;
 	mf->height	= mt9m111->height;
 	mf->code	= mt9m111->fmt->code;
@@ -867,7 +872,6 @@ static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 	.s_mbus_fmt	= mt9m111_s_fmt,
-	.g_mbus_fmt	= mt9m111_g_fmt,
 	.try_mbus_fmt	= mt9m111_try_fmt,
 	.s_crop		= mt9m111_s_crop,
 	.g_crop		= mt9m111_g_crop,
@@ -877,6 +881,7 @@ static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 
 static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
 	.enum_mbus_code = mt9m111_enum_mbus_code,
+	.get_fmt	= mt9m111_get_fmt,
 };
 
 static struct v4l2_subdev_ops mt9m111_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 15ac4dc..97193e4 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -337,12 +337,17 @@ static int mt9t031_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9t031_g_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
+static int mt9t031_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 
+	if (format->pad)
+		return -EINVAL;
+
 	mf->width	= mt9t031->rect.width / mt9t031->xskip;
 	mf->height	= mt9t031->rect.height / mt9t031->yskip;
 	mf->code	= MEDIA_BUS_FMT_SBGGR10_1X10;
@@ -714,7 +719,6 @@ static int mt9t031_s_mbus_config(struct v4l2_subdev *sd,
 static struct v4l2_subdev_video_ops mt9t031_subdev_video_ops = {
 	.s_stream	= mt9t031_s_stream,
 	.s_mbus_fmt	= mt9t031_s_fmt,
-	.g_mbus_fmt	= mt9t031_g_fmt,
 	.try_mbus_fmt	= mt9t031_try_fmt,
 	.s_crop		= mt9t031_s_crop,
 	.g_crop		= mt9t031_g_crop,
@@ -729,6 +733,7 @@ static struct v4l2_subdev_sensor_ops mt9t031_subdev_sensor_ops = {
 
 static const struct v4l2_subdev_pad_ops mt9t031_subdev_pad_ops = {
 	.enum_mbus_code = mt9t031_enum_mbus_code,
+	.get_fmt	= mt9t031_get_fmt,
 };
 
 static struct v4l2_subdev_ops mt9t031_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 8b0cfb7..889e98e 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -904,12 +904,17 @@ static int mt9t112_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	return mt9t112_set_params(priv, rect, priv->format->code);
 }
 
-static int mt9t112_g_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
+static int mt9t112_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
 
+	if (format->pad)
+		return -EINVAL;
+
 	mf->width	= priv->frame.width;
 	mf->height	= priv->frame.height;
 	mf->colorspace	= priv->format->colorspace;
@@ -1011,7 +1016,6 @@ static int mt9t112_s_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 	.s_stream	= mt9t112_s_stream,
-	.g_mbus_fmt	= mt9t112_g_fmt,
 	.s_mbus_fmt	= mt9t112_s_fmt,
 	.try_mbus_fmt	= mt9t112_try_fmt,
 	.cropcap	= mt9t112_cropcap,
@@ -1023,6 +1027,7 @@ static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 
 static const struct v4l2_subdev_pad_ops mt9t112_subdev_pad_ops = {
 	.enum_mbus_code = mt9t112_enum_mbus_code,
+	.get_fmt	= mt9t112_get_fmt,
 };
 
 /************************************************************************
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 780c7ae..b4ba3c5 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -375,12 +375,17 @@ static int mt9v022_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9v022_g_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
+static int mt9v022_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 
+	if (format->pad)
+		return -EINVAL;
+
 	mf->width	= mt9v022->rect.width;
 	mf->height	= mt9v022->rect.height;
 	mf->code	= mt9v022->fmt->code;
@@ -841,7 +846,6 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
 static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
 	.s_stream	= mt9v022_s_stream,
 	.s_mbus_fmt	= mt9v022_s_fmt,
-	.g_mbus_fmt	= mt9v022_g_fmt,
 	.try_mbus_fmt	= mt9v022_try_fmt,
 	.s_crop		= mt9v022_s_crop,
 	.g_crop		= mt9v022_g_crop,
@@ -856,6 +860,7 @@ static struct v4l2_subdev_sensor_ops mt9v022_subdev_sensor_ops = {
 
 static const struct v4l2_subdev_pad_ops mt9v022_subdev_pad_ops = {
 	.enum_mbus_code = mt9v022_enum_mbus_code,
+	.get_fmt	= mt9v022_get_fmt,
 };
 
 static struct v4l2_subdev_ops mt9v022_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 4327871..0dffc63 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -845,12 +845,17 @@ err:
 	return ret;
 }
 
-static int ov2640_g_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int ov2640_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client  *client = v4l2_get_subdevdata(sd);
 	struct ov2640_priv *priv = to_ov2640(client);
 
+	if (format->pad)
+		return -EINVAL;
+
 	if (!priv->win) {
 		u32 width = SVGA_WIDTH, height = SVGA_HEIGHT;
 		priv->win = ov2640_select_win(&width, &height);
@@ -1032,7 +1037,6 @@ static int ov2640_g_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
 	.s_stream	= ov2640_s_stream,
-	.g_mbus_fmt	= ov2640_g_fmt,
 	.s_mbus_fmt	= ov2640_s_fmt,
 	.try_mbus_fmt	= ov2640_try_fmt,
 	.cropcap	= ov2640_cropcap,
@@ -1042,6 +1046,7 @@ static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
 
 static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
 	.enum_mbus_code = ov2640_enum_mbus_code,
+	.get_fmt	= ov2640_get_fmt,
 };
 
 static struct v4l2_subdev_ops ov2640_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index fcddd0d..a88397f 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -822,14 +822,19 @@ static int ov5642_s_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov5642_g_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int ov5642_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov5642 *priv = to_ov5642(client);
 
 	const struct ov5642_datafmt *fmt = priv->fmt;
 
+	if (format->pad)
+		return -EINVAL;
+
 	mf->code	= fmt->code;
 	mf->colorspace	= fmt->colorspace;
 	mf->width	= priv->crop_rect.width;
@@ -941,7 +946,6 @@ static int ov5642_s_power(struct v4l2_subdev *sd, int on)
 
 static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 	.s_mbus_fmt	= ov5642_s_fmt,
-	.g_mbus_fmt	= ov5642_g_fmt,
 	.try_mbus_fmt	= ov5642_try_fmt,
 	.s_crop		= ov5642_s_crop,
 	.g_crop		= ov5642_g_crop,
@@ -951,6 +955,7 @@ static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 
 static const struct v4l2_subdev_pad_ops ov5642_subdev_pad_ops = {
 	.enum_mbus_code = ov5642_enum_mbus_code,
+	.get_fmt	= ov5642_get_fmt,
 };
 
 static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 99e0738..29f73a5 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -499,12 +499,17 @@ static int ov6650_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int ov6650_g_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
+static int ov6650_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
 
+	if (format->pad)
+		return -EINVAL;
+
 	mf->width	= priv->rect.width >> priv->half_scale;
 	mf->height	= priv->rect.height >> priv->half_scale;
 	mf->code	= priv->code;
@@ -930,7 +935,6 @@ static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops ov6650_video_ops = {
 	.s_stream	= ov6650_s_stream,
-	.g_mbus_fmt	= ov6650_g_fmt,
 	.s_mbus_fmt	= ov6650_s_fmt,
 	.try_mbus_fmt	= ov6650_try_fmt,
 	.cropcap	= ov6650_cropcap,
@@ -944,6 +948,7 @@ static struct v4l2_subdev_video_ops ov6650_video_ops = {
 
 static const struct v4l2_subdev_pad_ops ov6650_pad_ops = {
 	.enum_mbus_code = ov6650_enum_mbus_code,
+	.get_fmt	= ov6650_get_fmt,
 };
 
 static struct v4l2_subdev_ops ov6650_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index e3a31f8..1db2044 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -876,11 +876,16 @@ static int ov772x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int ov772x_g_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int ov772x_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct ov772x_priv *priv = to_ov772x(sd);
 
+	if (format->pad)
+		return -EINVAL;
+
 	mf->width	= priv->win->rect.width;
 	mf->height	= priv->win->rect.height;
 	mf->code	= priv->cfmt->code;
@@ -1017,7 +1022,6 @@ static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 	.s_stream	= ov772x_s_stream,
-	.g_mbus_fmt	= ov772x_g_fmt,
 	.s_mbus_fmt	= ov772x_s_fmt,
 	.try_mbus_fmt	= ov772x_try_fmt,
 	.cropcap	= ov772x_cropcap,
@@ -1027,6 +1031,7 @@ static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 
 static const struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
 	.enum_mbus_code = ov772x_enum_mbus_code,
+	.get_fmt	= ov772x_get_fmt,
 };
 
 static struct v4l2_subdev_ops ov772x_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 4927a76..8787142 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -598,12 +598,17 @@ static int rj54n1_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int rj54n1_g_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int rj54n1_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 
+	if (format->pad)
+		return -EINVAL;
+
 	mf->code	= rj54n1->fmt->code;
 	mf->colorspace	= rj54n1->fmt->colorspace;
 	mf->field	= V4L2_FIELD_NONE;
@@ -1251,7 +1256,6 @@ static int rj54n1_s_mbus_config(struct v4l2_subdev *sd,
 static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 	.s_stream	= rj54n1_s_stream,
 	.s_mbus_fmt	= rj54n1_s_fmt,
-	.g_mbus_fmt	= rj54n1_g_fmt,
 	.try_mbus_fmt	= rj54n1_try_fmt,
 	.g_crop		= rj54n1_g_crop,
 	.s_crop		= rj54n1_s_crop,
@@ -1262,6 +1266,7 @@ static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 
 static const struct v4l2_subdev_pad_ops rj54n1_subdev_pad_ops = {
 	.enum_mbus_code = rj54n1_enum_mbus_code,
+	.get_fmt	= rj54n1_get_fmt,
 };
 
 static struct v4l2_subdev_ops rj54n1_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index f8c0c71..9583795 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -691,12 +691,17 @@ static int tw9910_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int tw9910_g_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int tw9910_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
 
+	if (format->pad)
+		return -EINVAL;
+
 	if (!priv->scale) {
 		priv->scale = tw9910_select_norm(priv->norm, 640, 480);
 		if (!priv->scale)
@@ -881,7 +886,6 @@ static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.s_std		= tw9910_s_std,
 	.g_std		= tw9910_g_std,
 	.s_stream	= tw9910_s_stream,
-	.g_mbus_fmt	= tw9910_g_fmt,
 	.s_mbus_fmt	= tw9910_s_fmt,
 	.try_mbus_fmt	= tw9910_try_fmt,
 	.cropcap	= tw9910_cropcap,
@@ -893,6 +897,7 @@ static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 
 static const struct v4l2_subdev_pad_ops tw9910_subdev_pad_ops = {
 	.enum_mbus_code = tw9910_enum_mbus_code,
+	.get_fmt	= tw9910_get_fmt,
 };
 
 static struct v4l2_subdev_ops tw9910_subdev_ops = {
diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index 0a0a188..c0fa945 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -483,15 +483,19 @@ static int sr030pc30_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int sr030pc30_g_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_mbus_framefmt *mf)
+static int sr030pc30_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf;
 	struct sr030pc30_info *info = to_sr030pc30(sd);
 	int ret;
 
-	if (!mf)
+	if (!format || format->pad)
 		return -EINVAL;
 
+	mf = &format->format;
+
 	if (!info->curr_win || !info->curr_fmt) {
 		ret = sr030pc30_set_params(sd);
 		if (ret)
@@ -639,13 +643,13 @@ static const struct v4l2_subdev_core_ops sr030pc30_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops sr030pc30_video_ops = {
-	.g_mbus_fmt	= sr030pc30_g_fmt,
 	.s_mbus_fmt	= sr030pc30_s_fmt,
 	.try_mbus_fmt	= sr030pc30_try_fmt,
 };
 
 static const struct v4l2_subdev_pad_ops sr030pc30_pad_ops = {
 	.enum_mbus_code = sr030pc30_enum_mbus_code,
+	.get_fmt	= sr030pc30_get_fmt,
 };
 
 static const struct v4l2_subdev_ops sr030pc30_ops = {
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index a822d15..24e4727 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -747,35 +747,6 @@ static int tvp514x_s_ctrl(struct v4l2_ctrl *ctrl)
 }
 
 /**
- * tvp514x_mbus_fmt() - V4L2 decoder interface handler for try/s/g_mbus_fmt
- * @sd: pointer to standard V4L2 sub-device structure
- * @f: pointer to the mediabus format structure
- *
- * Negotiates the image capture size and mediabus format.
- */
-static int
-tvp514x_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
-{
-	struct tvp514x_decoder *decoder = to_decoder(sd);
-	enum tvp514x_std current_std;
-
-	if (f == NULL)
-		return -EINVAL;
-
-	/* Calculate height and width based on current standard */
-	current_std = decoder->current_std;
-
-	f->code = MEDIA_BUS_FMT_YUYV8_2X8;
-	f->width = decoder->std_list[current_std].width;
-	f->height = decoder->std_list[current_std].height;
-	f->field = V4L2_FIELD_INTERLACED;
-	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
-	v4l2_dbg(1, debug, sd, "MBUS_FMT: Width - %d, Height - %d\n",
-			f->width, f->height);
-	return 0;
-}
-
-/**
  * tvp514x_g_parm() - V4L2 decoder interface handler for g_parm
  * @sd: pointer to standard V4L2 sub-device structure
  * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
@@ -943,6 +914,9 @@ static int tvp514x_get_pad_format(struct v4l2_subdev *sd,
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 	__u32 which = format->which;
 
+	if (format->pad)
+		return -EINVAL;
+
 	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		format->format = decoder->format;
 		return 0;
@@ -997,9 +971,6 @@ static const struct v4l2_subdev_video_ops tvp514x_video_ops = {
 	.s_std = tvp514x_s_std,
 	.s_routing = tvp514x_s_routing,
 	.querystd = tvp514x_querystd,
-	.g_mbus_fmt = tvp514x_mbus_fmt,
-	.try_mbus_fmt = tvp514x_mbus_fmt,
-	.s_mbus_fmt = tvp514x_mbus_fmt,
 	.g_parm = tvp514x_g_parm,
 	.s_parm = tvp514x_s_parm,
 	.s_stream = tvp514x_s_stream,
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index f2f87b7..e4fa074 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -828,14 +828,18 @@ static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
-			    struct v4l2_mbus_framefmt *f)
+static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *f;
 	struct tvp5150 *decoder = to_tvp5150(sd);
 
-	if (f == NULL)
+	if (!format || format->pad)
 		return -EINVAL;
 
+	f = &format->format;
+
 	tvp5150_reset(sd, 0);
 
 	f->width = decoder->rect.width;
@@ -1069,9 +1073,6 @@ static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
 static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_std = tvp5150_s_std,
 	.s_routing = tvp5150_s_routing,
-	.s_mbus_fmt = tvp5150_mbus_fmt,
-	.try_mbus_fmt = tvp5150_mbus_fmt,
-	.g_mbus_fmt = tvp5150_mbus_fmt,
 	.s_crop = tvp5150_s_crop,
 	.g_crop = tvp5150_g_crop,
 	.cropcap = tvp5150_cropcap,
@@ -1086,6 +1087,8 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
 
 static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
 	.enum_mbus_code = tvp5150_enum_mbus_code,
+	.set_fmt = tvp5150_fill_fmt,
+	.get_fmt = tvp5150_fill_fmt,
 };
 
 static const struct v4l2_subdev_ops tvp5150_ops = {
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index d21fa1a..05077cf 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -611,31 +611,6 @@ static int tvp7002_s_ctrl(struct v4l2_ctrl *ctrl)
 }
 
 /*
- * tvp7002_mbus_fmt() - V4L2 decoder interface handler for try/s/g_mbus_fmt
- * @sd: pointer to standard V4L2 sub-device structure
- * @f: pointer to mediabus format structure
- *
- * Negotiate the image capture size and mediabus format.
- * There is only one possible format, so this single function works for
- * get, set and try.
- */
-static int tvp7002_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
-{
-	struct tvp7002 *device = to_tvp7002(sd);
-	const struct v4l2_bt_timings *bt = &device->current_timings->timings.bt;
-
-	f->width = bt->width;
-	f->height = bt->height;
-	f->code = MEDIA_BUS_FMT_YUYV10_1X20;
-	f->field = device->current_timings->scanmode;
-	f->colorspace = device->current_timings->color_space;
-
-	v4l2_dbg(1, debug, sd, "MBUS_FMT: Width - %d, Height - %d",
-			f->width, f->height);
-	return 0;
-}
-
-/*
  * tvp7002_query_dv() - query DV timings
  * @sd: pointer to standard V4L2 sub-device structure
  * @index: index into the tvp7002_timings array
@@ -905,9 +880,6 @@ static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
 	.s_dv_timings = tvp7002_s_dv_timings,
 	.query_dv_timings = tvp7002_query_dv_timings,
 	.s_stream = tvp7002_s_stream,
-	.g_mbus_fmt = tvp7002_mbus_fmt,
-	.try_mbus_fmt = tvp7002_mbus_fmt,
-	.s_mbus_fmt = tvp7002_mbus_fmt,
 };
 
 /* media pad related operation handlers */
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index b1d0a1b..59f7335 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -649,12 +649,16 @@ static int vs6624_s_mbus_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int vs6624_g_mbus_fmt(struct v4l2_subdev *sd,
-				struct v4l2_mbus_framefmt *fmt)
+static int vs6624_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
 	struct vs6624 *sensor = to_vs6624(sd);
 
-	*fmt = sensor->fmt;
+	if (format->pad)
+		return -EINVAL;
+
+	format->format = sensor->fmt;
 	return 0;
 }
 
@@ -741,7 +745,6 @@ static const struct v4l2_subdev_core_ops vs6624_core_ops = {
 static const struct v4l2_subdev_video_ops vs6624_video_ops = {
 	.try_mbus_fmt = vs6624_try_mbus_fmt,
 	.s_mbus_fmt = vs6624_s_mbus_fmt,
-	.g_mbus_fmt = vs6624_g_mbus_fmt,
 	.s_parm = vs6624_s_parm,
 	.g_parm = vs6624_g_parm,
 	.s_stream = vs6624_s_stream,
@@ -749,6 +752,7 @@ static const struct v4l2_subdev_video_ops vs6624_video_ops = {
 
 static const struct v4l2_subdev_pad_ops vs6624_pad_ops = {
 	.enum_mbus_code = vs6624_enum_mbus_code,
+	.get_fmt = vs6624_get_fmt,
 };
 
 static const struct v4l2_subdev_ops vs6624_ops = {
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 594dc3a..22632f9 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -121,11 +121,14 @@ static int empress_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mbus_fmt = &fmt.format;
 
-	saa_call_all(dev, video, g_mbus_fmt, &mbus_fmt);
+	saa_call_all(dev, pad, get_fmt, NULL, &fmt);
 
-	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
+	v4l2_fill_pix_format(&f->fmt.pix, mbus_fmt);
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
 	f->fmt.pix.bytesperline = 0;
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 4899924..d4195ff 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1095,7 +1095,7 @@ static int vpfe_config_ccdc_image_format(struct vpfe_device *vpfe)
  * For a given standard, this functions sets up the default
  * pix format & crop values in the vpfe device and ccdc.  It first
  * starts with defaults based values from the standard table.
- * It then checks if sub device support g_mbus_fmt and then override the
+ * It then checks if sub device supports get_fmt and then override the
  * values based on that.Sets crop values to match with scan resolution
  * starting at 0,0. It calls vpfe_config_ccdc_image_format() set the
  * values in ccdc
@@ -1432,8 +1432,8 @@ static int __vpfe_get_format(struct vpfe_device *vpfe,
 	} else {
 		ret = v4l2_device_call_until_err(&vpfe->v4l2_dev,
 						 sdinfo->grp_id,
-						 video, g_mbus_fmt,
-						 &mbus_fmt);
+						 pad, get_fmt,
+						 NULL, &fmt);
 		if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
 			return ret;
 		v4l2_fill_pix_format(&format->fmt.pix, &mbus_fmt);
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index ccfcf3f..7767e07 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -370,7 +370,7 @@ static int vpfe_config_ccdc_image_format(struct vpfe_device *vpfe_dev)
  * For a given standard, this functions sets up the default
  * pix format & crop values in the vpfe device and ccdc.  It first
  * starts with defaults based values from the standard table.
- * It then checks if sub device support g_mbus_fmt and then override the
+ * It then checks if sub device supports get_fmt and then override the
  * values based on that.Sets crop values to match with scan resolution
  * starting at 0,0. It calls vpfe_config_ccdc_image_format() set the
  * values in ccdc
@@ -379,7 +379,10 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
 				    v4l2_std_id std_id)
 {
 	struct vpfe_subdev_info *sdinfo = vpfe_dev->current_subdev;
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mbus_fmt = &fmt.format;
 	struct v4l2_pix_format *pix = &vpfe_dev->fmt.fmt.pix;
 	int i, ret = 0;
 
@@ -413,26 +416,26 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
 		pix->field = V4L2_FIELD_INTERLACED;
 		/* assume V4L2_PIX_FMT_UYVY as default */
 		pix->pixelformat = V4L2_PIX_FMT_UYVY;
-		v4l2_fill_mbus_format(&mbus_fmt, pix,
+		v4l2_fill_mbus_format(mbus_fmt, pix,
 				MEDIA_BUS_FMT_YUYV10_2X10);
 	} else {
 		pix->field = V4L2_FIELD_NONE;
 		/* assume V4L2_PIX_FMT_SBGGR8 */
 		pix->pixelformat = V4L2_PIX_FMT_SBGGR8;
-		v4l2_fill_mbus_format(&mbus_fmt, pix,
+		v4l2_fill_mbus_format(mbus_fmt, pix,
 				MEDIA_BUS_FMT_SBGGR8_1X8);
 	}
 
-	/* if sub device supports g_mbus_fmt, override the defaults */
+	/* if sub device supports get_fmt, override the defaults */
 	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
-			sdinfo->grp_id, video, g_mbus_fmt, &mbus_fmt);
+			sdinfo->grp_id, pad, get_fmt, NULL, &fmt);
 
 	if (ret && ret != -ENOIOCTLCMD) {
 		v4l2_err(&vpfe_dev->v4l2_dev,
-			"error in getting g_mbus_fmt from sub device\n");
+			"error in getting get_fmt from sub device\n");
 		return ret;
 	}
-	v4l2_fill_pix_format(pix, &mbus_fmt);
+	v4l2_fill_pix_format(pix, mbus_fmt);
 	pix->bytesperline = pix->width * 2;
 	pix->sizeimage = pix->bytesperline * pix->height;
 
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 0e74aab..618ecd1 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -648,15 +648,20 @@ static int hdmi_g_dv_timings(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
-	  struct v4l2_mbus_framefmt *fmt)
+static int hdmi_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *fmt = &format->format;
 	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
 	const struct hdmi_timings *t = hdev->cur_conf;
 
 	dev_dbg(hdev->dev, "%s\n", __func__);
 	if (!hdev->cur_conf)
 		return -EINVAL;
+	if (format->pad)
+		return -EINVAL;
+
 	memset(fmt, 0, sizeof(*fmt));
 	fmt->width = t->hact.end - t->hact.beg;
 	fmt->height = t->vact[0].end - t->vact[0].beg;
@@ -712,18 +717,19 @@ static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
 static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
 	.s_dv_timings = hdmi_s_dv_timings,
 	.g_dv_timings = hdmi_g_dv_timings,
-	.g_mbus_fmt = hdmi_g_mbus_fmt,
 	.s_stream = hdmi_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops hdmi_sd_pad_ops = {
 	.enum_dv_timings = hdmi_enum_dv_timings,
 	.dv_timings_cap = hdmi_dv_timings_cap,
+	.get_fmt = hdmi_get_fmt,
 };
 
 static const struct v4l2_subdev_ops hdmi_sd_ops = {
 	.core = &hdmi_sd_core_ops,
 	.video = &hdmi_sd_video_ops,
+	.pad = &hdmi_sd_pad_ops,
 };
 
 static int hdmi_runtime_suspend(struct device *dev)
diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 2a9501d..5ef6777 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -46,11 +46,15 @@ void mxr_get_mbus_fmt(struct mxr_device *mdev,
 	struct v4l2_mbus_framefmt *mbus_fmt)
 {
 	struct v4l2_subdev *sd;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int ret;
 
 	mutex_lock(&mdev->mutex);
 	sd = to_outsd(mdev);
-	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, mbus_fmt);
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
+	*mbus_fmt = fmt.format;
 	WARN(ret, "failed to get mbus_fmt for output %s\n", sd->name);
 	mutex_unlock(&mdev->mutex);
 }
@@ -62,7 +66,10 @@ void mxr_streamer_get(struct mxr_device *mdev)
 	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
 	if (mdev->n_streamer == 1) {
 		struct v4l2_subdev *sd = to_outsd(mdev);
-		struct v4l2_mbus_framefmt mbus_fmt;
+		struct v4l2_subdev_format fmt = {
+			.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		};
+		struct v4l2_mbus_framefmt *mbus_fmt = &fmt.format;
 		struct mxr_resources *res = &mdev->res;
 		int ret;
 
@@ -72,12 +79,12 @@ void mxr_streamer_get(struct mxr_device *mdev)
 			clk_set_parent(res->sclk_mixer, res->sclk_hdmi);
 		mxr_reg_s_output(mdev, to_output(mdev)->cookie);
 
-		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mbus_fmt);
+		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 		WARN(ret, "failed to get mbus_fmt for output %s\n", sd->name);
 		ret = v4l2_subdev_call(sd, video, s_stream, 1);
 		WARN(ret, "starting stream failed for output %s\n", sd->name);
 
-		mxr_reg_set_mbus_fmt(mdev, &mbus_fmt);
+		mxr_reg_set_mbus_fmt(mdev, mbus_fmt);
 		mxr_reg_streamon(mdev);
 		ret = mxr_reg_wait4vsync(mdev);
 		WARN(ret, "failed to get vsync (%d) from output\n", ret);
diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index 3621af9..c75d435 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -160,13 +160,17 @@ static int sdo_g_std_output(struct v4l2_subdev *sd, v4l2_std_id *std)
 	return 0;
 }
 
-static int sdo_g_mbus_fmt(struct v4l2_subdev *sd,
-	struct v4l2_mbus_framefmt *fmt)
+static int sdo_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *fmt = &format->format;
 	struct sdo_device *sdev = sd_to_sdev(sd);
 
 	if (!sdev->fmt)
 		return -ENXIO;
+	if (format->pad)
+		return -EINVAL;
 	/* all modes are 720 pixels wide */
 	fmt->width = 720;
 	fmt->height = sdev->fmt->height;
@@ -256,13 +260,17 @@ static const struct v4l2_subdev_video_ops sdo_sd_video_ops = {
 	.s_std_output = sdo_s_std_output,
 	.g_std_output = sdo_g_std_output,
 	.g_tvnorms_output = sdo_g_tvnorms_output,
-	.g_mbus_fmt = sdo_g_mbus_fmt,
 	.s_stream = sdo_s_stream,
 };
 
+static const struct v4l2_subdev_pad_ops sdo_sd_pad_ops = {
+	.get_fmt = sdo_get_fmt,
+};
+
 static const struct v4l2_subdev_ops sdo_sd_ops = {
 	.core = &sdo_sd_core_ops,
 	.video = &sdo_sd_video_ops,
+	.pad = &sdo_sd_pad_ops,
 };
 
 static int sdo_runtime_suspend(struct device *dev)
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index b891b7f..a1b4264 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -912,7 +912,10 @@ static int mx2_camera_set_crop(struct soc_camera_device *icd,
 	struct v4l2_crop a_writable = *a;
 	struct v4l2_rect *rect = &a_writable.c;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	int ret;
 
 	soc_camera_limit_side(&rect->left, &rect->width, 0, 2, 4096);
@@ -923,15 +926,15 @@ static int mx2_camera_set_crop(struct soc_camera_device *icd,
 		return ret;
 
 	/* The capture device might have changed its output  */
-	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 	if (ret < 0)
 		return ret;
 
 	dev_dbg(icd->parent, "Sensor cropped %dx%d\n",
-		mf.width, mf.height);
+		mf->width, mf->height);
 
-	icd->user_width		= mf.width;
-	icd->user_height	= mf.height;
+	icd->user_width		= mf->width;
+	icd->user_height	= mf->height;
 
 	return ret;
 }
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index a298489..6c34dbb 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -804,7 +804,10 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	int ret;
 
 	soc_camera_limit_side(&rect->left, &rect->width, 0, 2, 4096);
@@ -815,30 +818,30 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 		return ret;
 
 	/* The capture device might have changed its output sizes */
-	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 	if (ret < 0)
 		return ret;
 
-	if (mf.code != icd->current_fmt->code)
+	if (mf->code != icd->current_fmt->code)
 		return -EINVAL;
 
-	if (mf.width & 7) {
+	if (mf->width & 7) {
 		/* Ouch! We can only handle 8-byte aligned width... */
-		stride_align(&mf.width);
-		ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+		stride_align(&mf->width);
+		ret = v4l2_subdev_call(sd, video, s_mbus_fmt, mf);
 		if (ret < 0)
 			return ret;
 	}
 
-	if (mf.width != icd->user_width || mf.height != icd->user_height)
-		configure_geometry(mx3_cam, mf.width, mf.height,
+	if (mf->width != icd->user_width || mf->height != icd->user_height)
+		configure_geometry(mx3_cam, mf->width, mf->height,
 				   icd->current_fmt->host_fmt);
 
 	dev_dbg(icd->parent, "Sensor cropped %dx%d\n",
-		mf.width, mf.height);
+		mf->width, mf->height);
 
-	icd->user_width		= mf.width;
-	icd->user_height	= mf.height;
+	icd->user_width		= mf->width;
+	icd->user_height	= mf->height;
 
 	return ret;
 }
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index 3f25076..6663645 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -1224,7 +1224,10 @@ static int omap1_cam_set_crop(struct soc_camera_device *icd,
 	struct device *dev = icd->parent;
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct omap1_cam_dev *pcdev = ici->priv;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	int ret;
 
 	ret = subdev_call_with_sense(pcdev, dev, icd, sd, s_crop, crop);
@@ -1234,32 +1237,32 @@ static int omap1_cam_set_crop(struct soc_camera_device *icd,
 		return ret;
 	}
 
-	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 	if (ret < 0) {
 		dev_warn(dev, "%s: failed to fetch current format\n", __func__);
 		return ret;
 	}
 
-	ret = dma_align(&mf.width, &mf.height, xlate->host_fmt, pcdev->vb_mode,
+	ret = dma_align(&mf->width, &mf->height, xlate->host_fmt, pcdev->vb_mode,
 			false);
 	if (ret < 0) {
 		dev_err(dev, "%s: failed to align %ux%u %s with DMA\n",
-				__func__, mf.width, mf.height,
+				__func__, mf->width, mf->height,
 				xlate->host_fmt->name);
 		return ret;
 	}
 
 	if (!ret) {
 		/* sensor returned geometry not DMA aligned, trying to fix */
-		ret = set_mbus_format(pcdev, dev, icd, sd, &mf, xlate);
+		ret = set_mbus_format(pcdev, dev, icd, sd, mf, xlate);
 		if (ret < 0) {
 			dev_err(dev, "%s: failed to set format\n", __func__);
 			return ret;
 		}
 	}
 
-	icd->user_width	 = mf.width;
-	icd->user_height = mf.height;
+	icd->user_width	 = mf->width;
+	icd->user_height = mf->height;
 
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index f6fa0ac..48999f3 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1349,7 +1349,10 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		.master_clock = pcdev->mclk,
 		.pixel_clock_max = pcdev->ciclk / 4,
 	};
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	struct pxa_cam *cam = icd->host_priv;
 	u32 fourcc = icd->current_fmt->host_fmt->fourcc;
 	int ret;
@@ -1368,23 +1371,23 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		return ret;
 	}
 
-	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 	if (ret < 0)
 		return ret;
 
-	if (pxa_camera_check_frame(mf.width, mf.height)) {
+	if (pxa_camera_check_frame(mf->width, mf->height)) {
 		/*
 		 * Camera cropping produced a frame beyond our capabilities.
 		 * FIXME: just extract a subframe, that we can process.
 		 */
-		v4l_bound_align_image(&mf.width, 48, 2048, 1,
-			&mf.height, 32, 2048, 0,
+		v4l_bound_align_image(&mf->width, 48, 2048, 1,
+			&mf->height, 32, 2048, 0,
 			fourcc == V4L2_PIX_FMT_YUV422P ? 4 : 0);
-		ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+		ret = v4l2_subdev_call(sd, video, s_mbus_fmt, mf);
 		if (ret < 0)
 			return ret;
 
-		if (pxa_camera_check_frame(mf.width, mf.height)) {
+		if (pxa_camera_check_frame(mf->width, mf->height)) {
 			dev_warn(icd->parent,
 				 "Inconsistent state. Use S_FMT to repair\n");
 			return -EINVAL;
@@ -1401,8 +1404,8 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
 	}
 
-	icd->user_width		= mf.width;
-	icd->user_height	= mf.height;
+	icd->user_width		= mf->width;
+	icd->user_height	= mf->height;
 
 	pxa_camera_setup_cicr(icd, cam->flags, fourcc);
 
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 8796bdc..08fa610 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1339,12 +1339,15 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 		return 0;
 
 	if (!icd->host_priv) {
-		struct v4l2_mbus_framefmt mf;
+		struct v4l2_subdev_format fmt = {
+			.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		};
+		struct v4l2_mbus_framefmt *mf = &fmt.format;
 		struct v4l2_rect rect;
 		struct device *dev = icd->parent;
 		int shift;
 
-		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 		if (ret < 0)
 			return ret;
 
@@ -1354,8 +1357,8 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 			/* Sensor driver doesn't support cropping */
 			rect.left = 0;
 			rect.top = 0;
-			rect.width = mf.width;
-			rect.height = mf.height;
+			rect.width = mf->width;
+			rect.height = mf->height;
 		} else if (ret < 0) {
 			return ret;
 		}
@@ -1365,16 +1368,16 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 		 * 1280x960, 640x480, 320x240
 		 */
 		for (shift = 0; shift < 3; shift++) {
-			if (mf.width <= VIN_MAX_WIDTH &&
-			    mf.height <= VIN_MAX_HEIGHT)
+			if (mf->width <= VIN_MAX_WIDTH &&
+			    mf->height <= VIN_MAX_HEIGHT)
 				break;
 
-			mf.width = 1280 >> shift;
-			mf.height = 960 >> shift;
+			mf->width = 1280 >> shift;
+			mf->height = 960 >> shift;
 			ret = v4l2_device_call_until_err(sd->v4l2_dev,
 							 soc_camera_grp_id(icd),
 							 video, s_mbus_fmt,
-							 &mf);
+							 mf);
 			if (ret < 0)
 				return ret;
 		}
@@ -1382,11 +1385,11 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 		if (shift == 3) {
 			dev_err(dev,
 				"Failed to configure the client below %ux%u\n",
-				mf.width, mf.height);
+				mf->width, mf->height);
 			return -EIO;
 		}
 
-		dev_dbg(dev, "camera fmt %ux%u\n", mf.width, mf.height);
+		dev_dbg(dev, "camera fmt %ux%u\n", mf->width, mf->height);
 
 		cam = kzalloc(sizeof(*cam), GFP_KERNEL);
 		if (!cam)
@@ -1397,10 +1400,10 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 		 */
 		cam->rect = rect;
 		cam->subrect = rect;
-		cam->width = mf.width;
-		cam->height = mf.height;
-		cam->out_width	= mf.width;
-		cam->out_height	= mf.height;
+		cam->width = mf->width;
+		cam->height = mf->height;
+		cam->out_width	= mf->width;
+		cam->out_height	= mf->height;
 
 		icd->host_priv = cam;
 	} else {
@@ -1468,7 +1471,10 @@ static int rcar_vin_set_crop(struct soc_camera_device *icd,
 	struct v4l2_rect *cam_rect = &cam_crop.c;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	u32 vnmc;
 	int ret, i;
 
@@ -1492,16 +1498,16 @@ static int rcar_vin_set_crop(struct soc_camera_device *icd,
 	/* On success cam_crop contains current camera crop */
 
 	/* Retrieve camera output window */
-	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 	if (ret < 0)
 		return ret;
 
-	if (mf.width > VIN_MAX_WIDTH || mf.height > VIN_MAX_HEIGHT)
+	if (mf->width > VIN_MAX_WIDTH || mf->height > VIN_MAX_HEIGHT)
 		return -EINVAL;
 
 	/* Cache camera output window */
-	cam->width = mf.width;
-	cam->height = mf.height;
+	cam->width = mf->width;
+	cam->height = mf->height;
 
 	icd->user_width  = cam->width;
 	icd->user_height = cam->height;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index b4faf8f..566fd74 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1073,7 +1073,10 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 	}
 
 	if (!icd->host_priv) {
-		struct v4l2_mbus_framefmt mf;
+		struct v4l2_subdev_format fmt = {
+			.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		};
+		struct v4l2_mbus_framefmt *mf = &fmt.format;
 		struct v4l2_rect rect;
 		int shift = 0;
 
@@ -1091,7 +1094,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 			return ret;
 
 		/* First time */
-		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 		if (ret < 0)
 			return ret;
 
@@ -1102,14 +1105,14 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		 * sizes, just try VGA multiples. If needed, this can be
 		 * adjusted in the future.
 		 */
-		while ((mf.width > pcdev->max_width ||
-			mf.height > pcdev->max_height) && shift < 4) {
+		while ((mf->width > pcdev->max_width ||
+			mf->height > pcdev->max_height) && shift < 4) {
 			/* Try 2560x1920, 1280x960, 640x480, 320x240 */
-			mf.width	= 2560 >> shift;
-			mf.height	= 1920 >> shift;
+			mf->width	= 2560 >> shift;
+			mf->height	= 1920 >> shift;
 			ret = v4l2_device_call_until_err(sd->v4l2_dev,
 					soc_camera_grp_id(icd), video,
-					s_mbus_fmt, &mf);
+					s_mbus_fmt, mf);
 			if (ret < 0)
 				return ret;
 			shift++;
@@ -1117,11 +1120,11 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 
 		if (shift == 4) {
 			dev_err(dev, "Failed to configure the client below %ux%x\n",
-				mf.width, mf.height);
+				mf->width, mf->height);
 			return -EIO;
 		}
 
-		dev_geo(dev, "camera fmt %ux%u\n", mf.width, mf.height);
+		dev_geo(dev, "camera fmt %ux%u\n", mf->width, mf->height);
 
 		cam = kzalloc(sizeof(*cam), GFP_KERNEL);
 		if (!cam)
@@ -1131,8 +1134,8 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		cam->rect	= rect;
 		cam->subrect	= rect;
 
-		cam->width	= mf.width;
-		cam->height	= mf.height;
+		cam->width	= mf->width;
+		cam->height	= mf->height;
 
 		icd->host_priv = cam;
 	} else {
@@ -1217,7 +1220,10 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_rect *cam_rect = &cam_crop.c;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	unsigned int scale_cam_h, scale_cam_v, scale_ceu_h, scale_ceu_v,
 		out_width, out_height;
 	int interm_width, interm_height;
@@ -1247,16 +1253,16 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	/* On success cam_crop contains current camera crop */
 
 	/* 3. Retrieve camera output window */
-	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 	if (ret < 0)
 		return ret;
 
-	if (mf.width > pcdev->max_width || mf.height > pcdev->max_height)
+	if (mf->width > pcdev->max_width || mf->height > pcdev->max_height)
 		return -EINVAL;
 
 	/* 4. Calculate camera scales */
-	scale_cam_h	= calc_generic_scale(cam_rect->width, mf.width);
-	scale_cam_v	= calc_generic_scale(cam_rect->height, mf.height);
+	scale_cam_h	= calc_generic_scale(cam_rect->width, mf->width);
+	scale_cam_v	= calc_generic_scale(cam_rect->height, mf->height);
 
 	/* Calculate intermediate window */
 	interm_width	= scale_down(rect->width, scale_cam_h);
@@ -1267,7 +1273,7 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 
 		new_scale_h = calc_generic_scale(rect->width, icd->user_width);
 
-		mf.width = scale_down(cam_rect->width, new_scale_h);
+		mf->width = scale_down(cam_rect->width, new_scale_h);
 	}
 
 	if (interm_height < icd->user_height) {
@@ -1275,26 +1281,26 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 
 		new_scale_v = calc_generic_scale(rect->height, icd->user_height);
 
-		mf.height = scale_down(cam_rect->height, new_scale_v);
+		mf->height = scale_down(cam_rect->height, new_scale_v);
 	}
 
 	if (interm_width < icd->user_width || interm_height < icd->user_height) {
 		ret = v4l2_device_call_until_err(sd->v4l2_dev,
 					soc_camera_grp_id(icd), video,
-					s_mbus_fmt, &mf);
+					s_mbus_fmt, mf);
 		if (ret < 0)
 			return ret;
 
-		dev_geo(dev, "New camera output %ux%u\n", mf.width, mf.height);
-		scale_cam_h	= calc_generic_scale(cam_rect->width, mf.width);
-		scale_cam_v	= calc_generic_scale(cam_rect->height, mf.height);
+		dev_geo(dev, "New camera output %ux%u\n", mf->width, mf->height);
+		scale_cam_h	= calc_generic_scale(cam_rect->width, mf->width);
+		scale_cam_v	= calc_generic_scale(cam_rect->height, mf->height);
 		interm_width	= scale_down(rect->width, scale_cam_h);
 		interm_height	= scale_down(rect->height, scale_cam_v);
 	}
 
 	/* Cache camera output window */
-	cam->width	= mf.width;
-	cam->height	= mf.height;
+	cam->width	= mf->width;
+	cam->height	= mf->height;
 
 	if (pcdev->image_mode) {
 		out_width	= min(interm_width, icd->user_width);
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index ac889b9..a954386 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1289,7 +1289,10 @@ static struct soc_camera_device *soc_camera_add_pdev(struct soc_camera_async_cli
 static int soc_camera_probe_finish(struct soc_camera_device *icd)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	int ret;
 
 	sd->grp_id = soc_camera_grp_id(icd);
@@ -1319,11 +1322,11 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
 		goto evidstart;
 
 	/* Try to improve our guess of a reasonable window format */
-	if (!v4l2_subdev_call(sd, video, g_mbus_fmt, &mf)) {
-		icd->user_width		= mf.width;
-		icd->user_height	= mf.height;
-		icd->colorspace		= mf.colorspace;
-		icd->field		= mf.field;
+	if (!v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt)) {
+		icd->user_width		= mf->width;
+		icd->user_height	= mf->height;
+		icd->colorspace		= mf->colorspace;
+		icd->field		= mf->field;
 	}
 	soc_camera_remove_device(icd);
 
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index 934b918..cc8eb07 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -37,9 +37,11 @@ static int soc_camera_platform_s_stream(struct v4l2_subdev *sd, int enable)
 }
 
 static int soc_camera_platform_fill_fmt(struct v4l2_subdev *sd,
-					struct v4l2_mbus_framefmt *mf)
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf = &format->format;
 
 	mf->width	= p->format.width;
 	mf->height	= p->format.height;
@@ -120,14 +122,13 @@ static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
 	.s_stream	= soc_camera_platform_s_stream,
 	.cropcap	= soc_camera_platform_cropcap,
 	.g_crop		= soc_camera_platform_g_crop,
-	.try_mbus_fmt	= soc_camera_platform_fill_fmt,
-	.g_mbus_fmt	= soc_camera_platform_fill_fmt,
-	.s_mbus_fmt	= soc_camera_platform_fill_fmt,
 	.g_mbus_config	= soc_camera_platform_g_mbus_config,
 };
 
 static const struct v4l2_subdev_pad_ops platform_subdev_pad_ops = {
 	.enum_mbus_code = soc_camera_platform_enum_mbus_code,
+	.get_fmt	= soc_camera_platform_fill_fmt,
+	.set_fmt	= soc_camera_platform_fill_fmt,
 };
 
 static struct v4l2_subdev_ops platform_subdev_ops = {
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index c2eed99..67a8e4e 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -293,8 +293,6 @@ struct v4l2_mbus_frame_desc {
 
    g_dv_timings(): Get custom dv timings in the sub device.
 
-   g_mbus_fmt: get the current pixel format, provided by a video data source
-
    try_mbus_fmt: try to set a pixel format on a video data source
 
    s_mbus_fmt: set a pixel format on a video data source
@@ -336,8 +334,6 @@ struct v4l2_subdev_video_ops {
 			struct v4l2_dv_timings *timings);
 	int (*query_dv_timings)(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings);
-	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *fmt);
 	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
 			    struct v4l2_mbus_framefmt *fmt);
 	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
-- 
2.1.4

