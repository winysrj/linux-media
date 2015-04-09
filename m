Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:57486 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932786AbbDIKVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 06:21:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 1/7] v4l2: replace enum_mbus_fmt by enum_mbus_code
Date: Thu,  9 Apr 2015 12:21:22 +0200
Message-Id: <1428574888-46407-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace all calls to the enum_mbus_fmt video op by the pad
enum_mbus_code op and remove the duplicate video op.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/i2c/adv7170.c                        | 15 ++++++++----
 drivers/media/i2c/adv7175.c                        | 15 ++++++++----
 drivers/media/i2c/adv7183.c                        | 15 ++++++++----
 drivers/media/i2c/adv7842.c                        | 11 +++++----
 drivers/media/i2c/ak881x.c                         | 15 ++++++++----
 drivers/media/i2c/ml86v7667.c                      | 15 ++++++++----
 drivers/media/i2c/mt9v011.c                        | 15 ++++++++----
 drivers/media/i2c/ov7670.c                         | 11 +++++----
 drivers/media/i2c/soc_camera/imx074.c              | 16 +++++++++----
 drivers/media/i2c/soc_camera/mt9m001.c             | 15 ++++++++----
 drivers/media/i2c/soc_camera/mt9m111.c             | 15 ++++++++----
 drivers/media/i2c/soc_camera/mt9t031.c             | 15 ++++++++----
 drivers/media/i2c/soc_camera/mt9t112.c             | 15 ++++++++----
 drivers/media/i2c/soc_camera/mt9v022.c             | 15 ++++++++----
 drivers/media/i2c/soc_camera/ov2640.c              | 15 ++++++++----
 drivers/media/i2c/soc_camera/ov5642.c              | 15 ++++++++----
 drivers/media/i2c/soc_camera/ov6650.c              | 15 ++++++++----
 drivers/media/i2c/soc_camera/ov772x.c              | 15 ++++++++----
 drivers/media/i2c/soc_camera/ov9640.c              | 15 ++++++++----
 drivers/media/i2c/soc_camera/ov9740.c              | 19 +++++++++------
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          | 15 ++++++++----
 drivers/media/i2c/soc_camera/tw9910.c              | 15 ++++++++----
 drivers/media/i2c/sr030pc30.c                      | 16 +++++++++----
 drivers/media/i2c/tvp514x.c                        | 20 ----------------
 drivers/media/i2c/tvp5150.c                        | 15 ++++++++----
 drivers/media/i2c/tvp7002.c                        | 20 ----------------
 drivers/media/i2c/vs6624.c                         | 15 ++++++++----
 drivers/media/platform/blackfin/bfin_capture.c     | 17 +++++++++-----
 drivers/media/platform/soc_camera/atmel-isi.c      | 19 ++++++++-------
 drivers/media/platform/soc_camera/mx2_camera.c     | 27 ++++++++++++----------
 drivers/media/platform/soc_camera/mx3_camera.c     | 23 ++++++++++--------
 drivers/media/platform/soc_camera/omap1_camera.c   | 21 +++++++++--------
 drivers/media/platform/soc_camera/pxa_camera.c     | 19 ++++++++-------
 drivers/media/platform/soc_camera/rcar_vin.c       | 19 ++++++++-------
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 19 ++++++++-------
 drivers/media/platform/soc_camera/soc_camera.c     | 15 ++++++++----
 .../platform/soc_camera/soc_camera_platform.c      | 15 ++++++++----
 include/media/v4l2-subdev.h                        |  4 ----
 38 files changed, 361 insertions(+), 250 deletions(-)

diff --git a/drivers/media/i2c/adv7170.c b/drivers/media/i2c/adv7170.c
index 40a1a95..cfe963b 100644
--- a/drivers/media/i2c/adv7170.c
+++ b/drivers/media/i2c/adv7170.c
@@ -262,13 +262,14 @@ static int adv7170_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7170_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-				u32 *code)
+static int adv7170_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= ARRAY_SIZE(adv7170_codes))
+	if (code->pad || code->index >= ARRAY_SIZE(adv7170_codes))
 		return -EINVAL;
 
-	*code = adv7170_codes[index];
+	code->code = adv7170_codes[code->index];
 	return 0;
 }
 
@@ -323,11 +324,15 @@ static const struct v4l2_subdev_video_ops adv7170_video_ops = {
 	.s_routing = adv7170_s_routing,
 	.s_mbus_fmt = adv7170_s_fmt,
 	.g_mbus_fmt = adv7170_g_fmt,
-	.enum_mbus_fmt  = adv7170_enum_fmt,
+};
+
+static const struct v4l2_subdev_pad_ops adv7170_pad_ops = {
+	.enum_mbus_code = adv7170_enum_mbus_code,
 };
 
 static const struct v4l2_subdev_ops adv7170_ops = {
 	.video = &adv7170_video_ops,
+	.pad = &adv7170_pad_ops,
 };
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/i2c/adv7175.c b/drivers/media/i2c/adv7175.c
index d220af5..3f40304 100644
--- a/drivers/media/i2c/adv7175.c
+++ b/drivers/media/i2c/adv7175.c
@@ -300,13 +300,14 @@ static int adv7175_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7175_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-				u32 *code)
+static int adv7175_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= ARRAY_SIZE(adv7175_codes))
+	if (code->pad || code->index >= ARRAY_SIZE(adv7175_codes))
 		return -EINVAL;
 
-	*code = adv7175_codes[index];
+	code->code = adv7175_codes[code->index];
 	return 0;
 }
 
@@ -376,12 +377,16 @@ static const struct v4l2_subdev_video_ops adv7175_video_ops = {
 	.s_routing = adv7175_s_routing,
 	.s_mbus_fmt = adv7175_s_fmt,
 	.g_mbus_fmt = adv7175_g_fmt,
-	.enum_mbus_fmt  = adv7175_enum_fmt,
+};
+
+static const struct v4l2_subdev_pad_ops adv7175_pad_ops = {
+	.enum_mbus_code = adv7175_enum_mbus_code,
 };
 
 static const struct v4l2_subdev_ops adv7175_ops = {
 	.core = &adv7175_core_ops,
 	.video = &adv7175_video_ops,
+	.pad = &adv7175_pad_ops,
 };
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 28940cc..a0bcfef 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -420,13 +420,14 @@ static int adv7183_g_input_status(struct v4l2_subdev *sd, u32 *status)
 	return 0;
 }
 
-static int adv7183_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-				u32 *code)
+static int adv7183_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index > 0)
+	if (code->pad || code->index > 0)
 		return -EINVAL;
 
-	*code = MEDIA_BUS_FMT_UYVY8_2X8;
+	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	return 0;
 }
 
@@ -514,16 +515,20 @@ static const struct v4l2_subdev_video_ops adv7183_video_ops = {
 	.s_routing = adv7183_s_routing,
 	.querystd = adv7183_querystd,
 	.g_input_status = adv7183_g_input_status,
-	.enum_mbus_fmt = adv7183_enum_mbus_fmt,
 	.try_mbus_fmt = adv7183_try_mbus_fmt,
 	.s_mbus_fmt = adv7183_s_mbus_fmt,
 	.g_mbus_fmt = adv7183_g_mbus_fmt,
 	.s_stream = adv7183_s_stream,
 };
 
+static const struct v4l2_subdev_pad_ops adv7183_pad_ops = {
+	.enum_mbus_code = adv7183_enum_mbus_code,
+};
+
 static const struct v4l2_subdev_ops adv7183_ops = {
 	.core = &adv7183_core_ops,
 	.video = &adv7183_video_ops,
+	.pad = &adv7183_pad_ops,
 };
 
 static int adv7183_probe(struct i2c_client *client,
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index b5a37fe..644e910 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1867,13 +1867,14 @@ static int adv7842_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7842_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
-				 u32 *code)
+static int adv7842_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index)
+	if (code->pad || code->index)
 		return -EINVAL;
 	/* Good enough for now */
-	*code = MEDIA_BUS_FMT_FIXED;
+	code->code = MEDIA_BUS_FMT_FIXED;
 	return 0;
 }
 
@@ -2809,7 +2810,6 @@ static const struct v4l2_subdev_video_ops adv7842_video_ops = {
 	.s_dv_timings = adv7842_s_dv_timings,
 	.g_dv_timings = adv7842_g_dv_timings,
 	.query_dv_timings = adv7842_query_dv_timings,
-	.enum_mbus_fmt = adv7842_enum_mbus_fmt,
 	.g_mbus_fmt = adv7842_g_mbus_fmt,
 	.try_mbus_fmt = adv7842_g_mbus_fmt,
 	.s_mbus_fmt = adv7842_g_mbus_fmt,
@@ -2820,6 +2820,7 @@ static const struct v4l2_subdev_pad_ops adv7842_pad_ops = {
 	.set_edid = adv7842_set_edid,
 	.enum_dv_timings = adv7842_enum_dv_timings,
 	.dv_timings_cap = adv7842_dv_timings_cap,
+	.enum_mbus_code = adv7842_enum_mbus_code,
 };
 
 static const struct v4l2_subdev_ops adv7842_ops = {
diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index 69aeaf3..4428fb9 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -118,13 +118,14 @@ static int ak881x_s_mbus_fmt(struct v4l2_subdev *sd,
 	return ak881x_try_g_mbus_fmt(sd, mf);
 }
 
-static int ak881x_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
-				u32 *code)
+static int ak881x_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index)
+	if (code->pad || code->index)
 		return -EINVAL;
 
-	*code = MEDIA_BUS_FMT_YUYV8_2X8;
+	code->code = MEDIA_BUS_FMT_YUYV8_2X8;
 	return 0;
 }
 
@@ -215,14 +216,18 @@ static struct v4l2_subdev_video_ops ak881x_subdev_video_ops = {
 	.g_mbus_fmt	= ak881x_try_g_mbus_fmt,
 	.try_mbus_fmt	= ak881x_try_g_mbus_fmt,
 	.cropcap	= ak881x_cropcap,
-	.enum_mbus_fmt	= ak881x_enum_mbus_fmt,
 	.s_std_output	= ak881x_s_std_output,
 	.s_stream	= ak881x_s_stream,
 };
 
+static const struct v4l2_subdev_pad_ops ak881x_subdev_pad_ops = {
+	.enum_mbus_code = ak881x_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops ak881x_subdev_ops = {
 	.core	= &ak881x_subdev_core_ops,
 	.video	= &ak881x_subdev_video_ops,
+	.pad	= &ak881x_subdev_pad_ops,
 };
 
 static int ak881x_probe(struct i2c_client *client,
diff --git a/drivers/media/i2c/ml86v7667.c b/drivers/media/i2c/ml86v7667.c
index d730786..e7b2202 100644
--- a/drivers/media/i2c/ml86v7667.c
+++ b/drivers/media/i2c/ml86v7667.c
@@ -191,13 +191,14 @@ static int ml86v7667_g_input_status(struct v4l2_subdev *sd, u32 *status)
 	return 0;
 }
 
-static int ml86v7667_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
-				   u32 *code)
+static int ml86v7667_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index > 0)
+	if (code->pad || code->index > 0)
 		return -EINVAL;
 
-	*code = MEDIA_BUS_FMT_YUYV8_2X8;
+	code->code = MEDIA_BUS_FMT_YUYV8_2X8;
 
 	return 0;
 }
@@ -279,13 +280,16 @@ static struct v4l2_subdev_video_ops ml86v7667_subdev_video_ops = {
 	.s_std = ml86v7667_s_std,
 	.querystd = ml86v7667_querystd,
 	.g_input_status = ml86v7667_g_input_status,
-	.enum_mbus_fmt = ml86v7667_enum_mbus_fmt,
 	.try_mbus_fmt = ml86v7667_mbus_fmt,
 	.g_mbus_fmt = ml86v7667_mbus_fmt,
 	.s_mbus_fmt = ml86v7667_mbus_fmt,
 	.g_mbus_config = ml86v7667_g_mbus_config,
 };
 
+static const struct v4l2_subdev_pad_ops ml86v7667_subdev_pad_ops = {
+	.enum_mbus_code = ml86v7667_enum_mbus_code,
+};
+
 static struct v4l2_subdev_core_ops ml86v7667_subdev_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = ml86v7667_g_register,
@@ -296,6 +300,7 @@ static struct v4l2_subdev_core_ops ml86v7667_subdev_core_ops = {
 static struct v4l2_subdev_ops ml86v7667_subdev_ops = {
 	.core = &ml86v7667_subdev_core_ops,
 	.video = &ml86v7667_subdev_video_ops,
+	.pad = &ml86v7667_subdev_pad_ops,
 };
 
 static int ml86v7667_init(struct ml86v7667_priv *priv)
diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index a10f7f8..6fae8fc 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -324,13 +324,14 @@ static int mt9v011_reset(struct v4l2_subdev *sd, u32 val)
 	return 0;
 }
 
-static int mt9v011_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-					u32 *code)
+static int mt9v011_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index > 0)
+	if (code->pad || code->index > 0)
 		return -EINVAL;
 
-	*code = MEDIA_BUS_FMT_SGRBG8_1X8;
+	code->code = MEDIA_BUS_FMT_SGRBG8_1X8;
 	return 0;
 }
 
@@ -469,16 +470,20 @@ static const struct v4l2_subdev_core_ops mt9v011_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops mt9v011_video_ops = {
-	.enum_mbus_fmt = mt9v011_enum_mbus_fmt,
 	.try_mbus_fmt = mt9v011_try_mbus_fmt,
 	.s_mbus_fmt = mt9v011_s_mbus_fmt,
 	.g_parm = mt9v011_g_parm,
 	.s_parm = mt9v011_s_parm,
 };
 
+static const struct v4l2_subdev_pad_ops mt9v011_pad_ops = {
+	.enum_mbus_code = mt9v011_enum_mbus_code,
+};
+
 static const struct v4l2_subdev_ops mt9v011_ops = {
 	.core  = &mt9v011_core_ops,
 	.video = &mt9v011_video_ops,
+	.pad   = &mt9v011_pad_ops,
 };
 
 
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index b984752..1033bd7 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -899,13 +899,14 @@ static int ov7670_set_hw(struct v4l2_subdev *sd, int hstart, int hstop,
 }
 
 
-static int ov7670_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-					u32 *code)
+static int ov7670_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= N_OV7670_FMTS)
+	if (code->pad || code->index >= N_OV7670_FMTS)
 		return -EINVAL;
 
-	*code = ov7670_formats[index].mbus_code;
+	code->code = ov7670_formats[code->index].mbus_code;
 	return 0;
 }
 
@@ -1485,7 +1486,6 @@ static const struct v4l2_subdev_core_ops ov7670_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops ov7670_video_ops = {
-	.enum_mbus_fmt = ov7670_enum_mbus_fmt,
 	.try_mbus_fmt = ov7670_try_mbus_fmt,
 	.s_mbus_fmt = ov7670_s_mbus_fmt,
 	.s_parm = ov7670_s_parm,
@@ -1495,6 +1495,7 @@ static const struct v4l2_subdev_video_ops ov7670_video_ops = {
 static const struct v4l2_subdev_pad_ops ov7670_pad_ops = {
 	.enum_frame_interval = ov7670_enum_frame_interval,
 	.enum_frame_size = ov7670_enum_frame_size,
+	.enum_mbus_code = ov7670_enum_mbus_code,
 };
 
 static const struct v4l2_subdev_ops ov7670_ops = {
diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index ec89cfa..7a2d906 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -235,13 +235,15 @@ static int imx074_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int imx074_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   u32 *code)
+static int imx074_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if ((unsigned int)index >= ARRAY_SIZE(imx074_colour_fmts))
+	if (code->pad ||
+	    (unsigned int)code->index >= ARRAY_SIZE(imx074_colour_fmts))
 		return -EINVAL;
 
-	*code = imx074_colour_fmts[index].code;
+	code->code = imx074_colour_fmts[code->index].code;
 	return 0;
 }
 
@@ -278,7 +280,6 @@ static struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
 	.s_mbus_fmt	= imx074_s_fmt,
 	.g_mbus_fmt	= imx074_g_fmt,
 	.try_mbus_fmt	= imx074_try_fmt,
-	.enum_mbus_fmt	= imx074_enum_fmt,
 	.g_crop		= imx074_g_crop,
 	.cropcap	= imx074_cropcap,
 	.g_mbus_config	= imx074_g_mbus_config,
@@ -288,9 +289,14 @@ static struct v4l2_subdev_core_ops imx074_subdev_core_ops = {
 	.s_power	= imx074_s_power,
 };
 
+static const struct v4l2_subdev_pad_ops imx074_subdev_pad_ops = {
+	.enum_mbus_code = imx074_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops imx074_subdev_ops = {
 	.core	= &imx074_subdev_core_ops,
 	.video	= &imx074_subdev_video_ops,
+	.pad	= &imx074_subdev_pad_ops,
 };
 
 static int imx074_video_probe(struct i2c_client *client)
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 2e9a535..ba18e01 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -562,16 +562,17 @@ static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
 	.s_power	= mt9m001_s_power,
 };
 
-static int mt9m001_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			    u32 *code)
+static int mt9m001_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 
-	if (index >= mt9m001->num_fmts)
+	if (code->pad || code->index >= mt9m001->num_fmts)
 		return -EINVAL;
 
-	*code = mt9m001->fmts[index].code;
+	code->code = mt9m001->fmts[code->index].code;
 	return 0;
 }
 
@@ -617,7 +618,6 @@ static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
 	.s_crop		= mt9m001_s_crop,
 	.g_crop		= mt9m001_g_crop,
 	.cropcap	= mt9m001_cropcap,
-	.enum_mbus_fmt	= mt9m001_enum_fmt,
 	.g_mbus_config	= mt9m001_g_mbus_config,
 	.s_mbus_config	= mt9m001_s_mbus_config,
 };
@@ -626,10 +626,15 @@ static struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
 	.g_skip_top_lines	= mt9m001_g_skip_top_lines,
 };
 
+static const struct v4l2_subdev_pad_ops mt9m001_subdev_pad_ops = {
+	.enum_mbus_code = mt9m001_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops mt9m001_subdev_ops = {
 	.core	= &mt9m001_subdev_core_ops,
 	.video	= &mt9m001_subdev_video_ops,
 	.sensor	= &mt9m001_subdev_sensor_ops,
+	.pad	= &mt9m001_subdev_pad_ops,
 };
 
 static int mt9m001_probe(struct i2c_client *client,
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 441e0fd..ef8682c 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -839,13 +839,14 @@ static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
 #endif
 };
 
-static int mt9m111_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			    u32 *code)
+static int mt9m111_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= ARRAY_SIZE(mt9m111_colour_fmts))
+	if (code->code || code->index >= ARRAY_SIZE(mt9m111_colour_fmts))
 		return -EINVAL;
 
-	*code = mt9m111_colour_fmts[index].code;
+	code->code = mt9m111_colour_fmts[code->index].code;
 	return 0;
 }
 
@@ -871,13 +872,17 @@ static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 	.s_crop		= mt9m111_s_crop,
 	.g_crop		= mt9m111_g_crop,
 	.cropcap	= mt9m111_cropcap,
-	.enum_mbus_fmt	= mt9m111_enum_fmt,
 	.g_mbus_config	= mt9m111_g_mbus_config,
 };
 
+static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
+	.enum_mbus_code = mt9m111_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops mt9m111_subdev_ops = {
 	.core	= &mt9m111_subdev_core_ops,
 	.video	= &mt9m111_subdev_video_ops,
+	.pad	= &mt9m111_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 35d9c8d..15ac4dc 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -672,13 +672,14 @@ static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
 #endif
 };
 
-static int mt9t031_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			    u32 *code)
+static int mt9t031_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index)
+	if (code->pad || code->index)
 		return -EINVAL;
 
-	*code = MEDIA_BUS_FMT_SBGGR10_1X10;
+	code->code = MEDIA_BUS_FMT_SBGGR10_1X10;
 	return 0;
 }
 
@@ -718,7 +719,6 @@ static struct v4l2_subdev_video_ops mt9t031_subdev_video_ops = {
 	.s_crop		= mt9t031_s_crop,
 	.g_crop		= mt9t031_g_crop,
 	.cropcap	= mt9t031_cropcap,
-	.enum_mbus_fmt	= mt9t031_enum_fmt,
 	.g_mbus_config	= mt9t031_g_mbus_config,
 	.s_mbus_config	= mt9t031_s_mbus_config,
 };
@@ -727,10 +727,15 @@ static struct v4l2_subdev_sensor_ops mt9t031_subdev_sensor_ops = {
 	.g_skip_top_lines	= mt9t031_g_skip_top_lines,
 };
 
+static const struct v4l2_subdev_pad_ops mt9t031_subdev_pad_ops = {
+	.enum_mbus_code = mt9t031_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops mt9t031_subdev_ops = {
 	.core	= &mt9t031_subdev_core_ops,
 	.video	= &mt9t031_subdev_video_ops,
 	.sensor	= &mt9t031_subdev_sensor_ops,
+	.pad	= &mt9t031_subdev_pad_ops,
 };
 
 static int mt9t031_probe(struct i2c_client *client,
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 64f0836..8b0cfb7 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -966,16 +966,17 @@ static int mt9t112_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int mt9t112_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   u32 *code)
+static int mt9t112_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
 
-	if (index >= priv->num_formats)
+	if (code->pad || code->index >= priv->num_formats)
 		return -EINVAL;
 
-	*code = mt9t112_cfmts[index].code;
+	code->code = mt9t112_cfmts[code->index].code;
 
 	return 0;
 }
@@ -1016,17 +1017,21 @@ static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 	.cropcap	= mt9t112_cropcap,
 	.g_crop		= mt9t112_g_crop,
 	.s_crop		= mt9t112_s_crop,
-	.enum_mbus_fmt	= mt9t112_enum_fmt,
 	.g_mbus_config	= mt9t112_g_mbus_config,
 	.s_mbus_config	= mt9t112_s_mbus_config,
 };
 
+static const struct v4l2_subdev_pad_ops mt9t112_subdev_pad_ops = {
+	.enum_mbus_code = mt9t112_enum_mbus_code,
+};
+
 /************************************************************************
 			i2c driver
 ************************************************************************/
 static struct v4l2_subdev_ops mt9t112_subdev_ops = {
 	.core	= &mt9t112_subdev_core_ops,
 	.video	= &mt9t112_subdev_video_ops,
+	.pad	= &mt9t112_subdev_pad_ops,
 };
 
 static int mt9t112_camera_probe(struct i2c_client *client)
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index a246d4d..780c7ae 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -758,16 +758,17 @@ static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
 	.s_power	= mt9v022_s_power,
 };
 
-static int mt9v022_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			    u32 *code)
+static int mt9v022_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 
-	if (index >= mt9v022->num_fmts)
+	if (code->pad || code->index >= mt9v022->num_fmts)
 		return -EINVAL;
 
-	*code = mt9v022->fmts[index].code;
+	code->code = mt9v022->fmts[code->index].code;
 	return 0;
 }
 
@@ -845,7 +846,6 @@ static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
 	.s_crop		= mt9v022_s_crop,
 	.g_crop		= mt9v022_g_crop,
 	.cropcap	= mt9v022_cropcap,
-	.enum_mbus_fmt	= mt9v022_enum_fmt,
 	.g_mbus_config	= mt9v022_g_mbus_config,
 	.s_mbus_config	= mt9v022_s_mbus_config,
 };
@@ -854,10 +854,15 @@ static struct v4l2_subdev_sensor_ops mt9v022_subdev_sensor_ops = {
 	.g_skip_top_lines	= mt9v022_g_skip_top_lines,
 };
 
+static const struct v4l2_subdev_pad_ops mt9v022_subdev_pad_ops = {
+	.enum_mbus_code = mt9v022_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops mt9v022_subdev_ops = {
 	.core	= &mt9v022_subdev_core_ops,
 	.video	= &mt9v022_subdev_video_ops,
 	.sensor	= &mt9v022_subdev_sensor_ops,
+	.pad	= &mt9v022_subdev_pad_ops,
 };
 
 static int mt9v022_probe(struct i2c_client *client,
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index e3c907a..4327871 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -925,13 +925,14 @@ static int ov2640_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov2640_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   u32 *code)
+static int ov2640_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= ARRAY_SIZE(ov2640_codes))
+	if (code->pad || code->index >= ARRAY_SIZE(ov2640_codes))
 		return -EINVAL;
 
-	*code = ov2640_codes[index];
+	code->code = ov2640_codes[code->index];
 	return 0;
 }
 
@@ -1036,13 +1037,17 @@ static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
 	.try_mbus_fmt	= ov2640_try_fmt,
 	.cropcap	= ov2640_cropcap,
 	.g_crop		= ov2640_g_crop,
-	.enum_mbus_fmt	= ov2640_enum_fmt,
 	.g_mbus_config	= ov2640_g_mbus_config,
 };
 
+static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
+	.enum_mbus_code = ov2640_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops ov2640_subdev_ops = {
 	.core	= &ov2640_subdev_core_ops,
 	.video	= &ov2640_subdev_video_ops,
+	.pad	= &ov2640_subdev_pad_ops,
 };
 
 /* OF probe functions */
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 93ae031..fcddd0d 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -839,13 +839,14 @@ static int ov5642_g_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov5642_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   u32 *code)
+static int ov5642_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= ARRAY_SIZE(ov5642_colour_fmts))
+	if (code->pad || code->index >= ARRAY_SIZE(ov5642_colour_fmts))
 		return -EINVAL;
 
-	*code = ov5642_colour_fmts[index].code;
+	code->code = ov5642_colour_fmts[code->index].code;
 	return 0;
 }
 
@@ -942,13 +943,16 @@ static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 	.s_mbus_fmt	= ov5642_s_fmt,
 	.g_mbus_fmt	= ov5642_g_fmt,
 	.try_mbus_fmt	= ov5642_try_fmt,
-	.enum_mbus_fmt	= ov5642_enum_fmt,
 	.s_crop		= ov5642_s_crop,
 	.g_crop		= ov5642_g_crop,
 	.cropcap	= ov5642_cropcap,
 	.g_mbus_config	= ov5642_g_mbus_config,
 };
 
+static const struct v4l2_subdev_pad_ops ov5642_subdev_pad_ops = {
+	.enum_mbus_code = ov5642_enum_mbus_code,
+};
+
 static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
 	.s_power	= ov5642_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -960,6 +964,7 @@ static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
 static struct v4l2_subdev_ops ov5642_subdev_ops = {
 	.core	= &ov5642_subdev_core_ops,
 	.video	= &ov5642_subdev_video_ops,
+	.pad	= &ov5642_subdev_pad_ops,
 };
 
 static int ov5642_video_probe(struct i2c_client *client)
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index f4eef2f..99e0738 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -716,13 +716,14 @@ static int ov6650_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov6650_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   u32 *code)
+static int ov6650_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= ARRAY_SIZE(ov6650_codes))
+	if (code->pad || code->index >= ARRAY_SIZE(ov6650_codes))
 		return -EINVAL;
 
-	*code = ov6650_codes[index];
+	code->code = ov6650_codes[code->index];
 	return 0;
 }
 
@@ -932,7 +933,6 @@ static struct v4l2_subdev_video_ops ov6650_video_ops = {
 	.g_mbus_fmt	= ov6650_g_fmt,
 	.s_mbus_fmt	= ov6650_s_fmt,
 	.try_mbus_fmt	= ov6650_try_fmt,
-	.enum_mbus_fmt	= ov6650_enum_fmt,
 	.cropcap	= ov6650_cropcap,
 	.g_crop		= ov6650_g_crop,
 	.s_crop		= ov6650_s_crop,
@@ -942,9 +942,14 @@ static struct v4l2_subdev_video_ops ov6650_video_ops = {
 	.s_mbus_config	= ov6650_s_mbus_config,
 };
 
+static const struct v4l2_subdev_pad_ops ov6650_pad_ops = {
+	.enum_mbus_code = ov6650_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops ov6650_subdev_ops = {
 	.core	= &ov6650_core_ops,
 	.video	= &ov6650_video_ops,
+	.pad	= &ov6650_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 8daac88..e3a31f8 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -989,13 +989,14 @@ static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
 	.s_power	= ov772x_s_power,
 };
 
-static int ov772x_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   u32 *code)
+static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= ARRAY_SIZE(ov772x_cfmts))
+	if (code->pad || code->index >= ARRAY_SIZE(ov772x_cfmts))
 		return -EINVAL;
 
-	*code = ov772x_cfmts[index].code;
+	code->code = ov772x_cfmts[code->index].code;
 	return 0;
 }
 
@@ -1021,13 +1022,17 @@ static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 	.try_mbus_fmt	= ov772x_try_fmt,
 	.cropcap	= ov772x_cropcap,
 	.g_crop		= ov772x_g_crop,
-	.enum_mbus_fmt	= ov772x_enum_fmt,
 	.g_mbus_config	= ov772x_g_mbus_config,
 };
 
+static const struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
+	.enum_mbus_code = ov772x_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops ov772x_subdev_ops = {
 	.core	= &ov772x_subdev_core_ops,
 	.video	= &ov772x_subdev_video_ops,
+	.pad	= &ov772x_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index aa93d2e..899b4d9 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -540,13 +540,14 @@ static int ov9640_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov9640_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   u32 *code)
+static int ov9640_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= ARRAY_SIZE(ov9640_codes))
+	if (code->pad || code->index >= ARRAY_SIZE(ov9640_codes))
 		return -EINVAL;
 
-	*code = ov9640_codes[index];
+	code->code = ov9640_codes[code->index];
 	return 0;
 }
 
@@ -658,15 +659,19 @@ static struct v4l2_subdev_video_ops ov9640_video_ops = {
 	.s_stream	= ov9640_s_stream,
 	.s_mbus_fmt	= ov9640_s_fmt,
 	.try_mbus_fmt	= ov9640_try_fmt,
-	.enum_mbus_fmt	= ov9640_enum_fmt,
 	.cropcap	= ov9640_cropcap,
 	.g_crop		= ov9640_g_crop,
 	.g_mbus_config	= ov9640_g_mbus_config,
 };
 
+static const struct v4l2_subdev_pad_ops ov9640_pad_ops = {
+	.enum_mbus_code = ov9640_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops ov9640_subdev_ops = {
 	.core	= &ov9640_core_ops,
 	.video	= &ov9640_video_ops,
+	.pad	= &ov9640_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 841dc55..5d9b249 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -716,13 +716,14 @@ static int ov9740_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov9740_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   u32 *code)
+static int ov9740_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= ARRAY_SIZE(ov9740_codes))
+	if (code->pad || code->index >= ARRAY_SIZE(ov9740_codes))
 		return -EINVAL;
 
-	*code = ov9740_codes[index];
+	code->code = ov9740_codes[code->index];
 
 	return 0;
 }
@@ -906,7 +907,6 @@ static struct v4l2_subdev_video_ops ov9740_video_ops = {
 	.s_stream	= ov9740_s_stream,
 	.s_mbus_fmt	= ov9740_s_fmt,
 	.try_mbus_fmt	= ov9740_try_fmt,
-	.enum_mbus_fmt	= ov9740_enum_fmt,
 	.cropcap	= ov9740_cropcap,
 	.g_crop		= ov9740_g_crop,
 	.g_mbus_config	= ov9740_g_mbus_config,
@@ -920,9 +920,14 @@ static struct v4l2_subdev_core_ops ov9740_core_ops = {
 #endif
 };
 
+static const struct v4l2_subdev_pad_ops ov9740_pad_ops = {
+	.enum_mbus_code = ov9740_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops ov9740_subdev_ops = {
-	.core			= &ov9740_core_ops,
-	.video			= &ov9740_video_ops,
+	.core	= &ov9740_core_ops,
+	.video	= &ov9740_video_ops,
+	.pad	= &ov9740_pad_ops,
 };
 
 static const struct v4l2_ctrl_ops ov9740_ctrl_ops = {
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 1752428..4927a76 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -485,13 +485,14 @@ static int reg_write_multiple(struct i2c_client *client,
 	return 0;
 }
 
-static int rj54n1_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   u32 *code)
+static int rj54n1_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= ARRAY_SIZE(rj54n1_colour_fmts))
+	if (code->pad || code->index >= ARRAY_SIZE(rj54n1_colour_fmts))
 		return -EINVAL;
 
-	*code = rj54n1_colour_fmts[index].code;
+	code->code = rj54n1_colour_fmts[code->index].code;
 	return 0;
 }
 
@@ -1252,7 +1253,6 @@ static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 	.s_mbus_fmt	= rj54n1_s_fmt,
 	.g_mbus_fmt	= rj54n1_g_fmt,
 	.try_mbus_fmt	= rj54n1_try_fmt,
-	.enum_mbus_fmt	= rj54n1_enum_fmt,
 	.g_crop		= rj54n1_g_crop,
 	.s_crop		= rj54n1_s_crop,
 	.cropcap	= rj54n1_cropcap,
@@ -1260,9 +1260,14 @@ static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 	.s_mbus_config	= rj54n1_s_mbus_config,
 };
 
+static const struct v4l2_subdev_pad_ops rj54n1_subdev_pad_ops = {
+	.enum_mbus_code = rj54n1_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops rj54n1_subdev_ops = {
 	.core	= &rj54n1_subdev_core_ops,
 	.video	= &rj54n1_subdev_video_ops,
+	.pad	= &rj54n1_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 9b85321..f8c0c71 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -821,13 +821,14 @@ static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
 	.s_power	= tw9910_s_power,
 };
 
-static int tw9910_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   u32 *code)
+static int tw9910_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index)
+	if (code->pad || code->index)
 		return -EINVAL;
 
-	*code = MEDIA_BUS_FMT_UYVY8_2X8;
+	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	return 0;
 }
 
@@ -885,15 +886,19 @@ static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.try_mbus_fmt	= tw9910_try_fmt,
 	.cropcap	= tw9910_cropcap,
 	.g_crop		= tw9910_g_crop,
-	.enum_mbus_fmt	= tw9910_enum_fmt,
 	.g_mbus_config	= tw9910_g_mbus_config,
 	.s_mbus_config	= tw9910_s_mbus_config,
 	.g_tvnorms	= tw9910_g_tvnorms,
 };
 
+static const struct v4l2_subdev_pad_ops tw9910_subdev_pad_ops = {
+	.enum_mbus_code = tw9910_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops tw9910_subdev_ops = {
 	.core	= &tw9910_subdev_core_ops,
 	.video	= &tw9910_subdev_video_ops,
+	.pad	= &tw9910_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index 10c735c..0a0a188 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -471,13 +471,15 @@ static int sr030pc30_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-static int sr030pc30_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			      u32 *code)
+static int sr030pc30_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (!code || index >= ARRAY_SIZE(sr030pc30_formats))
+	if (!code || code->pad ||
+	    code->index >= ARRAY_SIZE(sr030pc30_formats))
 		return -EINVAL;
 
-	*code = sr030pc30_formats[index].code;
+	code->code = sr030pc30_formats[code->index].code;
 	return 0;
 }
 
@@ -640,12 +642,16 @@ static const struct v4l2_subdev_video_ops sr030pc30_video_ops = {
 	.g_mbus_fmt	= sr030pc30_g_fmt,
 	.s_mbus_fmt	= sr030pc30_s_fmt,
 	.try_mbus_fmt	= sr030pc30_try_fmt,
-	.enum_mbus_fmt	= sr030pc30_enum_fmt,
+};
+
+static const struct v4l2_subdev_pad_ops sr030pc30_pad_ops = {
+	.enum_mbus_code = sr030pc30_enum_mbus_code,
 };
 
 static const struct v4l2_subdev_ops sr030pc30_ops = {
 	.core	= &sr030pc30_core_ops,
 	.video	= &sr030pc30_video_ops,
+	.pad	= &sr030pc30_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 1c6bc30..a822d15 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -747,25 +747,6 @@ static int tvp514x_s_ctrl(struct v4l2_ctrl *ctrl)
 }
 
 /**
- * tvp514x_enum_mbus_fmt() - V4L2 decoder interface handler for enum_mbus_fmt
- * @sd: pointer to standard V4L2 sub-device structure
- * @index: index of pixelcode to retrieve
- * @code: receives the pixelcode
- *
- * Enumerates supported mediabus formats
- */
-static int
-tvp514x_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-					u32 *code)
-{
-	if (index)
-		return -EINVAL;
-
-	*code = MEDIA_BUS_FMT_YUYV10_2X10;
-	return 0;
-}
-
-/**
  * tvp514x_mbus_fmt() - V4L2 decoder interface handler for try/s/g_mbus_fmt
  * @sd: pointer to standard V4L2 sub-device structure
  * @f: pointer to the mediabus format structure
@@ -1016,7 +997,6 @@ static const struct v4l2_subdev_video_ops tvp514x_video_ops = {
 	.s_std = tvp514x_s_std,
 	.s_routing = tvp514x_s_routing,
 	.querystd = tvp514x_querystd,
-	.enum_mbus_fmt = tvp514x_enum_mbus_fmt,
 	.g_mbus_fmt = tvp514x_mbus_fmt,
 	.try_mbus_fmt = tvp514x_mbus_fmt,
 	.s_mbus_fmt = tvp514x_mbus_fmt,
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 68cdab9..f2f87b7 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -817,13 +817,14 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
 	}
 }
 
-static int tvp5150_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-						u32 *code)
+static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index)
+	if (code->pad || code->index)
 		return -EINVAL;
 
-	*code = MEDIA_BUS_FMT_UYVY8_2X8;
+	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	return 0;
 }
 
@@ -1068,7 +1069,6 @@ static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
 static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_std = tvp5150_s_std,
 	.s_routing = tvp5150_s_routing,
-	.enum_mbus_fmt = tvp5150_enum_mbus_fmt,
 	.s_mbus_fmt = tvp5150_mbus_fmt,
 	.try_mbus_fmt = tvp5150_mbus_fmt,
 	.g_mbus_fmt = tvp5150_mbus_fmt,
@@ -1084,11 +1084,16 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
 	.s_raw_fmt = tvp5150_s_raw_fmt,
 };
 
+static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
+	.enum_mbus_code = tvp5150_enum_mbus_code,
+};
+
 static const struct v4l2_subdev_ops tvp5150_ops = {
 	.core = &tvp5150_core_ops,
 	.tuner = &tvp5150_tuner_ops,
 	.video = &tvp5150_video_ops,
 	.vbi = &tvp5150_vbi_ops,
+	.pad = &tvp5150_pad_ops,
 };
 
 
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 787cdfb..d21fa1a 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -747,25 +747,6 @@ static int tvp7002_s_register(struct v4l2_subdev *sd,
 #endif
 
 /*
- * tvp7002_enum_mbus_fmt() - Enum supported mediabus formats
- * @sd: pointer to standard V4L2 sub-device structure
- * @index: format index
- * @code: pointer to mediabus format
- *
- * Enumerate supported mediabus formats.
- */
-
-static int tvp7002_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-					u32 *code)
-{
-	/* Check requested format index is within range */
-	if (index)
-		return -EINVAL;
-	*code = MEDIA_BUS_FMT_YUYV10_1X20;
-	return 0;
-}
-
-/*
  * tvp7002_s_stream() - V4L2 decoder i/f handler for s_stream
  * @sd: pointer to standard V4L2 sub-device structure
  * @enable: streaming enable or disable
@@ -927,7 +908,6 @@ static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
 	.g_mbus_fmt = tvp7002_mbus_fmt,
 	.try_mbus_fmt = tvp7002_mbus_fmt,
 	.s_mbus_fmt = tvp7002_mbus_fmt,
-	.enum_mbus_fmt = tvp7002_enum_mbus_fmt,
 };
 
 /* media pad related operation handlers */
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 00e7f04..b1d0a1b 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -557,13 +557,14 @@ static int vs6624_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-static int vs6624_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-				u32 *code)
+static int vs6624_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index >= ARRAY_SIZE(vs6624_formats))
+	if (code->pad || code->index >= ARRAY_SIZE(vs6624_formats))
 		return -EINVAL;
 
-	*code = vs6624_formats[index].mbus_code;
+	code->code = vs6624_formats[code->index].mbus_code;
 	return 0;
 }
 
@@ -738,7 +739,6 @@ static const struct v4l2_subdev_core_ops vs6624_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops vs6624_video_ops = {
-	.enum_mbus_fmt = vs6624_enum_mbus_fmt,
 	.try_mbus_fmt = vs6624_try_mbus_fmt,
 	.s_mbus_fmt = vs6624_s_mbus_fmt,
 	.g_mbus_fmt = vs6624_g_mbus_fmt,
@@ -747,9 +747,14 @@ static const struct v4l2_subdev_video_ops vs6624_video_ops = {
 	.s_stream = vs6624_s_stream,
 };
 
+static const struct v4l2_subdev_pad_ops vs6624_pad_ops = {
+	.enum_mbus_code = vs6624_enum_mbus_code,
+};
+
 static const struct v4l2_subdev_ops vs6624_ops = {
 	.core = &vs6624_core_ops,
 	.video = &vs6624_video_ops,
+	.pad = &vs6624_pad_ops,
 };
 
 static int vs6624_probe(struct i2c_client *client,
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 6a437f8..6ea11b1 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -156,14 +156,18 @@ static struct bcap_buffer *to_bcap_vb(struct vb2_buffer *vb)
 
 static int bcap_init_sensor_formats(struct bcap_device *bcap_dev)
 {
-	u32 code;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	struct bcap_format *sf;
 	unsigned int num_formats = 0;
 	int i, j;
 
-	while (!v4l2_subdev_call(bcap_dev->sd, video,
-				enum_mbus_fmt, num_formats, &code))
+	while (!v4l2_subdev_call(bcap_dev->sd, pad,
+				enum_mbus_code, NULL, &code)) {
 		num_formats++;
+		code.index++;
+	}
 	if (!num_formats)
 		return -ENXIO;
 
@@ -172,10 +176,11 @@ static int bcap_init_sensor_formats(struct bcap_device *bcap_dev)
 		return -ENOMEM;
 
 	for (i = 0; i < num_formats; i++) {
-		v4l2_subdev_call(bcap_dev->sd, video,
-				enum_mbus_fmt, i, &code);
+		code.index = i;
+		v4l2_subdev_call(bcap_dev->sd, pad,
+				enum_mbus_code, NULL, &code);
 		for (j = 0; j < BCAP_MAX_FMTS; j++)
-			if (code == bcap_formats[j].mbus_code)
+			if (code.code == bcap_formats[j].mbus_code)
 				break;
 		if (j == BCAP_MAX_FMTS) {
 			/* we don't allow this sensor working with our bridge */
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 8526bf5..cbf83d9 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -648,19 +648,22 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int formats = 0, ret;
 	/* sensor format */
-	u32 code;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.index = idx,
+	};
 	/* soc camera host format */
 	const struct soc_mbus_pixelfmt *fmt;
 
-	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
 	if (ret < 0)
 		/* No more formats */
 		return 0;
 
-	fmt = soc_mbus_get_fmtdesc(code);
+	fmt = soc_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
 		dev_err(icd->parent,
-			"Invalid format code #%u: %d\n", idx, code);
+			"Invalid format code #%u: %d\n", idx, code.code);
 		return 0;
 	}
 
@@ -672,7 +675,7 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 		return 0;
 	}
 
-	switch (code) {
+	switch (code.code) {
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 	case MEDIA_BUS_FMT_VYUY8_2X8:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
@@ -680,10 +683,10 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 		formats++;
 		if (xlate) {
 			xlate->host_fmt	= &isi_camera_formats[0];
-			xlate->code	= code;
+			xlate->code	= code.code;
 			xlate++;
 			dev_dbg(icd->parent, "Providing format %s using code %d\n",
-				isi_camera_formats[0].name, code);
+				isi_camera_formats[0].name, code.code);
 		}
 		break;
 	default:
@@ -699,7 +702,7 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 	formats++;
 	if (xlate) {
 		xlate->host_fmt	= fmt;
-		xlate->code	= code;
+		xlate->code	= code.code;
 		xlate++;
 	}
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 192377f..b891b7f 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -943,22 +943,25 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_mbus_pixelfmt *fmt;
 	struct device *dev = icd->parent;
-	u32 code;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.index = idx,
+	};
 	int ret, formats = 0;
 
-	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
 	if (ret < 0)
 		/* no more formats */
 		return 0;
 
-	fmt = soc_mbus_get_fmtdesc(code);
+	fmt = soc_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
-		dev_err(dev, "Invalid format code #%u: %d\n", idx, code);
+		dev_err(dev, "Invalid format code #%u: %d\n", idx, code.code);
 		return 0;
 	}
 
-	if (code == MEDIA_BUS_FMT_YUYV8_2X8 ||
-	    code == MEDIA_BUS_FMT_UYVY8_2X8) {
+	if (code.code == MEDIA_BUS_FMT_YUYV8_2X8 ||
+	    code.code == MEDIA_BUS_FMT_UYVY8_2X8) {
 		formats++;
 		if (xlate) {
 			/*
@@ -967,21 +970,21 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 			 */
 			xlate->host_fmt =
 				soc_mbus_get_fmtdesc(MEDIA_BUS_FMT_YUYV8_1_5X8);
-			xlate->code	= code;
+			xlate->code	= code.code;
 			dev_dbg(dev, "Providing host format %s for sensor code %d\n",
-			       xlate->host_fmt->name, code);
+			       xlate->host_fmt->name, code.code);
 			xlate++;
 		}
 	}
 
-	if (code == MEDIA_BUS_FMT_UYVY8_2X8) {
+	if (code.code == MEDIA_BUS_FMT_UYVY8_2X8) {
 		formats++;
 		if (xlate) {
 			xlate->host_fmt =
 				soc_mbus_get_fmtdesc(MEDIA_BUS_FMT_YUYV8_2X8);
-			xlate->code	= code;
+			xlate->code	= code.code;
 			dev_dbg(dev, "Providing host format %s for sensor code %d\n",
-				xlate->host_fmt->name, code);
+				xlate->host_fmt->name, code.code);
 			xlate++;
 		}
 	}
@@ -990,7 +993,7 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 	formats++;
 	if (xlate) {
 		xlate->host_fmt = fmt;
-		xlate->code	= code;
+		xlate->code	= code.code;
 		xlate++;
 	}
 	return formats;
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 3435fd2..a298489 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -659,18 +659,21 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
 	int formats = 0, ret;
-	u32 code;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.index = idx,
+	};
 	const struct soc_mbus_pixelfmt *fmt;
 
-	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
 	if (ret < 0)
 		/* No more formats */
 		return 0;
 
-	fmt = soc_mbus_get_fmtdesc(code);
+	fmt = soc_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
 		dev_warn(icd->parent,
-			 "Unsupported format code #%u: 0x%x\n", idx, code);
+			 "Unsupported format code #%u: 0x%x\n", idx, code.code);
 		return 0;
 	}
 
@@ -679,25 +682,25 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	if (ret < 0)
 		return 0;
 
-	switch (code) {
+	switch (code.code) {
 	case MEDIA_BUS_FMT_SBGGR10_1X10:
 		formats++;
 		if (xlate) {
 			xlate->host_fmt	= &mx3_camera_formats[0];
-			xlate->code	= code;
+			xlate->code	= code.code;
 			xlate++;
 			dev_dbg(dev, "Providing format %s using code 0x%x\n",
-				mx3_camera_formats[0].name, code);
+				mx3_camera_formats[0].name, code.code);
 		}
 		break;
 	case MEDIA_BUS_FMT_Y10_1X10:
 		formats++;
 		if (xlate) {
 			xlate->host_fmt	= &mx3_camera_formats[1];
-			xlate->code	= code;
+			xlate->code	= code.code;
 			xlate++;
 			dev_dbg(dev, "Providing format %s using code 0x%x\n",
-				mx3_camera_formats[1].name, code);
+				mx3_camera_formats[1].name, code.code);
 		}
 		break;
 	default:
@@ -709,7 +712,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	formats++;
 	if (xlate) {
 		xlate->host_fmt	= fmt;
-		xlate->code	= code;
+		xlate->code	= code.code;
 		dev_dbg(dev, "Providing format %c%c%c%c in pass-through mode\n",
 			(fmt->fourcc >> (0*8)) & 0xFF,
 			(fmt->fourcc >> (1*8)) & 0xFF,
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index 16f65ec..3f25076 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -1068,18 +1068,21 @@ static int omap1_cam_get_formats(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
 	int formats = 0, ret;
-	u32 code;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.index = idx,
+	};
 	const struct soc_mbus_pixelfmt *fmt;
 
-	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
 	if (ret < 0)
 		/* No more formats */
 		return 0;
 
-	fmt = soc_mbus_get_fmtdesc(code);
+	fmt = soc_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
 		dev_warn(dev, "%s: unsupported format code #%d: %d\n", __func__,
-				idx, code);
+				idx, code.code);
 		return 0;
 	}
 
@@ -1087,7 +1090,7 @@ static int omap1_cam_get_formats(struct soc_camera_device *icd,
 	if (fmt->bits_per_sample != 8)
 		return 0;
 
-	switch (code) {
+	switch (code.code) {
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 	case MEDIA_BUS_FMT_YVYU8_2X8:
 	case MEDIA_BUS_FMT_UYVY8_2X8:
@@ -1098,14 +1101,14 @@ static int omap1_cam_get_formats(struct soc_camera_device *icd,
 	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		formats++;
 		if (xlate) {
-			xlate->host_fmt	= soc_mbus_find_fmtdesc(code,
+			xlate->host_fmt	= soc_mbus_find_fmtdesc(code.code,
 						omap1_cam_formats,
 						ARRAY_SIZE(omap1_cam_formats));
-			xlate->code	= code;
+			xlate->code	= code.code;
 			xlate++;
 			dev_dbg(dev,
 				"%s: providing format %s as byte swapped code #%d\n",
-				__func__, xlate->host_fmt->name, code);
+				__func__, xlate->host_fmt->name, code.code);
 		}
 	default:
 		if (xlate)
@@ -1116,7 +1119,7 @@ static int omap1_cam_get_formats(struct soc_camera_device *icd,
 	formats++;
 	if (xlate) {
 		xlate->host_fmt	= fmt;
-		xlate->code	= code;
+		xlate->code	= code.code;
 		xlate++;
 	}
 
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 8d6e343..f6fa0ac 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1253,17 +1253,20 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	struct device *dev = icd->parent;
 	int formats = 0, ret;
 	struct pxa_cam *cam;
-	u32 code;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.index = idx,
+	};
 	const struct soc_mbus_pixelfmt *fmt;
 
-	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
 	if (ret < 0)
 		/* No more formats */
 		return 0;
 
-	fmt = soc_mbus_get_fmtdesc(code);
+	fmt = soc_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
-		dev_err(dev, "Invalid format code #%u: %d\n", idx, code);
+		dev_err(dev, "Invalid format code #%u: %d\n", idx, code.code);
 		return 0;
 	}
 
@@ -1282,15 +1285,15 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 		cam = icd->host_priv;
 	}
 
-	switch (code) {
+	switch (code.code) {
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		formats++;
 		if (xlate) {
 			xlate->host_fmt	= &pxa_camera_formats[0];
-			xlate->code	= code;
+			xlate->code	= code.code;
 			xlate++;
 			dev_dbg(dev, "Providing format %s using code %d\n",
-				pxa_camera_formats[0].name, code);
+				pxa_camera_formats[0].name, code.code);
 		}
 	case MEDIA_BUS_FMT_VYUY8_2X8:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
@@ -1314,7 +1317,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	formats++;
 	if (xlate) {
 		xlate->host_fmt	= fmt;
-		xlate->code	= code;
+		xlate->code	= code.code;
 		xlate++;
 	}
 
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 9351f64..8796bdc 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1318,16 +1318,19 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 	int ret, k, n;
 	int formats = 0;
 	struct rcar_vin_cam *cam;
-	u32 code;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.index = idx,
+	};
 	const struct soc_mbus_pixelfmt *fmt;
 
-	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
 	if (ret < 0)
 		return 0;
 
-	fmt = soc_mbus_get_fmtdesc(code);
+	fmt = soc_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
-		dev_warn(dev, "unsupported format code #%u: %d\n", idx, code);
+		dev_warn(dev, "unsupported format code #%u: %d\n", idx, code.code);
 		return 0;
 	}
 
@@ -1408,7 +1411,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 	if (!idx)
 		cam->extra_fmt = NULL;
 
-	switch (code) {
+	switch (code.code) {
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 	case MEDIA_BUS_FMT_YUYV10_2X10:
@@ -1422,9 +1425,9 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 		formats += n;
 		for (k = 0; xlate && k < n; k++, xlate++) {
 			xlate->host_fmt = &rcar_vin_formats[k];
-			xlate->code = code;
+			xlate->code = code.code;
 			dev_dbg(dev, "Providing format %s using code %d\n",
-				rcar_vin_formats[k].name, code);
+				rcar_vin_formats[k].name, code.code);
 		}
 		break;
 	default:
@@ -1440,7 +1443,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 	formats++;
 	if (xlate) {
 		xlate->host_fmt = fmt;
-		xlate->code = code;
+		xlate->code = code.code;
 		xlate++;
 	}
 
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 9ce202f..b4faf8f 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1048,17 +1048,20 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 	int ret, k, n;
 	int formats = 0;
 	struct sh_mobile_ceu_cam *cam;
-	u32 code;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.index = idx,
+	};
 	const struct soc_mbus_pixelfmt *fmt;
 
-	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
 	if (ret < 0)
 		/* No more formats */
 		return 0;
 
-	fmt = soc_mbus_get_fmtdesc(code);
+	fmt = soc_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
-		dev_warn(dev, "unsupported format code #%u: %d\n", idx, code);
+		dev_warn(dev, "unsupported format code #%u: %d\n", idx, code.code);
 		return 0;
 	}
 
@@ -1140,7 +1143,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 	if (!idx)
 		cam->extra_fmt = NULL;
 
-	switch (code) {
+	switch (code.code) {
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 	case MEDIA_BUS_FMT_VYUY8_2X8:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
@@ -1163,10 +1166,10 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		formats += n;
 		for (k = 0; xlate && k < n; k++) {
 			xlate->host_fmt	= &sh_mobile_ceu_formats[k];
-			xlate->code	= code;
+			xlate->code	= code.code;
 			xlate++;
 			dev_dbg(dev, "Providing format %s using code %d\n",
-				sh_mobile_ceu_formats[k].name, code);
+				sh_mobile_ceu_formats[k].name, code.code);
 		}
 		break;
 	default:
@@ -1178,7 +1181,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 	formats++;
 	if (xlate) {
 		xlate->host_fmt	= fmt;
-		xlate->code	= code;
+		xlate->code	= code.code;
 		xlate++;
 		dev_dbg(dev, "Providing format %s in pass-through mode\n",
 			fmt->name);
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 7825132..ac889b9 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -484,10 +484,14 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	unsigned int i, fmts = 0, raw_fmts = 0;
 	int ret;
-	u32 code;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 
-	while (!v4l2_subdev_call(sd, video, enum_mbus_fmt, raw_fmts, &code))
+	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
 		raw_fmts++;
+		code.index++;
+	}
 
 	if (!ici->ops->get_formats)
 		/*
@@ -521,11 +525,12 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 	fmts = 0;
 	for (i = 0; i < raw_fmts; i++)
 		if (!ici->ops->get_formats) {
-			v4l2_subdev_call(sd, video, enum_mbus_fmt, i, &code);
+			code.index = i;
+			v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
 			icd->user_formats[fmts].host_fmt =
-				soc_mbus_get_fmtdesc(code);
+				soc_mbus_get_fmtdesc(code.code);
 			if (icd->user_formats[fmts].host_fmt)
-				icd->user_formats[fmts++].code = code;
+				icd->user_formats[fmts++].code = code.code;
 		} else {
 			ret = ici->ops->get_formats(icd, i,
 						    &icd->user_formats[fmts]);
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index f535910..934b918 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -61,15 +61,16 @@ static struct v4l2_subdev_core_ops platform_subdev_core_ops = {
 	.s_power = soc_camera_platform_s_power,
 };
 
-static int soc_camera_platform_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-					u32 *code)
+static int soc_camera_platform_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
 
-	if (index)
+	if (code->pad || code->index)
 		return -EINVAL;
 
-	*code = p->format.code;
+	code->code = p->format.code;
 	return 0;
 }
 
@@ -117,7 +118,6 @@ static int soc_camera_platform_g_mbus_config(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
 	.s_stream	= soc_camera_platform_s_stream,
-	.enum_mbus_fmt	= soc_camera_platform_enum_fmt,
 	.cropcap	= soc_camera_platform_cropcap,
 	.g_crop		= soc_camera_platform_g_crop,
 	.try_mbus_fmt	= soc_camera_platform_fill_fmt,
@@ -126,9 +126,14 @@ static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
 	.g_mbus_config	= soc_camera_platform_g_mbus_config,
 };
 
+static const struct v4l2_subdev_pad_ops platform_subdev_pad_ops = {
+	.enum_mbus_code = soc_camera_platform_enum_mbus_code,
+};
+
 static struct v4l2_subdev_ops platform_subdev_ops = {
 	.core	= &platform_subdev_core_ops,
 	.video	= &platform_subdev_video_ops,
+	.pad	= &platform_subdev_pad_ops,
 };
 
 static int soc_camera_platform_probe(struct platform_device *pdev)
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 2f0a345..c2eed99 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -293,8 +293,6 @@ struct v4l2_mbus_frame_desc {
 
    g_dv_timings(): Get custom dv timings in the sub device.
 
-   enum_mbus_fmt: enumerate pixel formats, provided by a video data source
-
    g_mbus_fmt: get the current pixel format, provided by a video data source
 
    try_mbus_fmt: try to set a pixel format on a video data source
@@ -338,8 +336,6 @@ struct v4l2_subdev_video_ops {
 			struct v4l2_dv_timings *timings);
 	int (*query_dv_timings)(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings);
-	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
-			     u32 *code);
 	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
 			  struct v4l2_mbus_framefmt *fmt);
 	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
-- 
2.1.4

