Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:48468 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265AbaLSPCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 10:02:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 11/11] v4l2-subdev: remove g/s_crop and cropcap from video ops
Date: Fri, 19 Dec 2014 15:51:36 +0100
Message-Id: <1419000696-25202-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1419000696-25202-1-git-send-email-hverkuil@xs4all.nl>
References: <1419000696-25202-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ak881x.c                         |  32 +++--
 drivers/media/i2c/soc_camera/imx074.c              |  46 ++++----
 drivers/media/i2c/soc_camera/mt9m001.c             |  74 +++++++-----
 drivers/media/i2c/soc_camera/mt9m111.c             |  61 +++++-----
 drivers/media/i2c/soc_camera/mt9t031.c             |  56 +++++----
 drivers/media/i2c/soc_camera/mt9t112.c             |  64 +++++-----
 drivers/media/i2c/soc_camera/mt9v022.c             |  72 +++++++-----
 drivers/media/i2c/soc_camera/ov2640.c              |  45 ++++---
 drivers/media/i2c/soc_camera/ov5642.c              |  57 +++++----
 drivers/media/i2c/soc_camera/ov6650.c              |  78 +++++++------
 drivers/media/i2c/soc_camera/ov772x.c              |  48 ++++----
 drivers/media/i2c/soc_camera/ov9640.c              |  45 ++++---
 drivers/media/i2c/soc_camera/ov9740.c              |  49 ++++----
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |  56 +++++----
 drivers/media/i2c/soc_camera/tw9910.c              |  51 +++-----
 drivers/media/i2c/tvp5150.c                        |  85 +++++++-------
 drivers/media/platform/omap3isp/ispvideo.c         |  88 +++++++++-----
 drivers/media/platform/sh_vou.c                    |  13 ++-
 drivers/media/platform/soc_camera/mx2_camera.c     |  18 ++-
 drivers/media/platform/soc_camera/mx3_camera.c     |  18 ++-
 drivers/media/platform/soc_camera/omap1_camera.c   |  23 ++--
 drivers/media/platform/soc_camera/pxa_camera.c     |  17 ++-
 drivers/media/platform/soc_camera/rcar_vin.c       |  26 ++---
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  32 +++--
 drivers/media/platform/soc_camera/soc_camera.c     | 130 ++++++---------------
 .../platform/soc_camera/soc_camera_platform.c      |  49 ++++----
 drivers/media/platform/soc_camera/soc_scale_crop.c |  85 ++++++++------
 drivers/media/platform/soc_camera/soc_scale_crop.h |   6 +-
 drivers/staging/media/omap4iss/iss_video.c         |  88 +++++++++-----
 include/media/soc_camera.h                         |   7 +-
 include/media/v4l2-subdev.h                        |   3 -
 31 files changed, 805 insertions(+), 717 deletions(-)

diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index 69aeaf3..29d3b2a 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -128,21 +128,27 @@ static int ak881x_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
-static int ak881x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+static int ak881x_get_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ak881x *ak881x = to_ak881x(client);
 
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
-	a->bounds.width			= 720;
-	a->bounds.height		= ak881x->lines;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = 720;
+		sel->r.height = ak881x->lines;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int ak881x_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
@@ -214,15 +220,19 @@ static struct v4l2_subdev_video_ops ak881x_subdev_video_ops = {
 	.s_mbus_fmt	= ak881x_s_mbus_fmt,
 	.g_mbus_fmt	= ak881x_try_g_mbus_fmt,
 	.try_mbus_fmt	= ak881x_try_g_mbus_fmt,
-	.cropcap	= ak881x_cropcap,
 	.enum_mbus_fmt	= ak881x_enum_mbus_fmt,
 	.s_std_output	= ak881x_s_std_output,
 	.s_stream	= ak881x_s_stream,
 };
 
+static struct v4l2_subdev_pad_ops ak881x_subdev_pad_ops = {
+	.get_selection	= ak881x_get_selection,
+};
+
 static struct v4l2_subdev_ops ak881x_subdev_ops = {
 	.core	= &ak881x_subdev_core_ops,
 	.video	= &ak881x_subdev_video_ops,
+	.pad	= &ak881x_subdev_pad_ops,
 };
 
 static int ak881x_probe(struct i2c_client *client,
diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index ec89cfa..a5fc6d5 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -208,31 +208,26 @@ static int imx074_g_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int imx074_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int imx074_get_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_selection *sel)
 {
-	struct v4l2_rect *rect = &a->c;
-
-	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	rect->top	= 0;
-	rect->left	= 0;
-	rect->width	= IMX074_WIDTH;
-	rect->height	= IMX074_HEIGHT;
-
-	return 0;
-}
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-static int imx074_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
-	a->bounds.width			= IMX074_WIDTH;
-	a->bounds.height		= IMX074_HEIGHT;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
+	sel->r.left = 0;
+	sel->r.top = 0;
+	sel->r.width = IMX074_WIDTH;
+	sel->r.height = IMX074_HEIGHT;
 
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP:
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int imx074_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
@@ -279,8 +274,6 @@ static struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
 	.g_mbus_fmt	= imx074_g_fmt,
 	.try_mbus_fmt	= imx074_try_fmt,
 	.enum_mbus_fmt	= imx074_enum_fmt,
-	.g_crop		= imx074_g_crop,
-	.cropcap	= imx074_cropcap,
 	.g_mbus_config	= imx074_g_mbus_config,
 };
 
@@ -288,9 +281,14 @@ static struct v4l2_subdev_core_ops imx074_subdev_core_ops = {
 	.s_power	= imx074_s_power,
 };
 
+static struct v4l2_subdev_pad_ops imx074_subdev_pad_ops = {
+	.get_selection	= imx074_get_selection,
+};
+
 static struct v4l2_subdev_ops imx074_subdev_ops = {
 	.core	= &imx074_subdev_core_ops,
 	.video	= &imx074_subdev_video_ops,
+	.pad	= &imx074_subdev_pad_ops,
 };
 
 static int imx074_video_probe(struct i2c_client *client)
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 2e9a535..fe151bc 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -171,13 +171,19 @@ static int mt9m001_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int mt9m001_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
+static int mt9m001_set_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct v4l2_rect rect = a->c;
-	int ret;
+	struct v4l2_rect rect = sel->r;
 	const u16 hblank = 9, vblank = 25;
+	int ret;
+
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
 
 	if (mt9m001->fmts == mt9m001_colour_fmts)
 		/*
@@ -225,29 +231,30 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	return ret;
 }
 
-static int mt9m001_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int mt9m001_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 
-	a->c	= mt9m001->rect;
-	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	return 0;
-}
-
-static int mt9m001_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	a->bounds.left			= MT9M001_COLUMN_SKIP;
-	a->bounds.top			= MT9M001_ROW_SKIP;
-	a->bounds.width			= MT9M001_MAX_WIDTH;
-	a->bounds.height		= MT9M001_MAX_HEIGHT;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.left = MT9M001_COLUMN_SKIP;
+		sel->r.top = MT9M001_ROW_SKIP;
+		sel->r.width = MT9M001_MAX_WIDTH;
+		sel->r.height = MT9M001_MAX_HEIGHT;
+		return 0;
+	case V4L2_SEL_TGT_CROP:
+		sel->r = mt9m001->rect;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int mt9m001_g_fmt(struct v4l2_subdev *sd,
@@ -270,18 +277,18 @@ static int mt9m001_s_fmt(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct v4l2_crop a = {
-		.c = {
-			.left	= mt9m001->rect.left,
-			.top	= mt9m001->rect.top,
-			.width	= mf->width,
-			.height	= mf->height,
-		},
+	struct v4l2_subdev_selection sel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = V4L2_SEL_TGT_CROP,
+		.r.left = mt9m001->rect.left,
+		.r.top = mt9m001->rect.top,
+		.r.width = mf->width,
+		.r.height = mf->height,
 	};
 	int ret;
 
 	/* No support for scaling so far, just crop. TODO: use skipping */
-	ret = mt9m001_s_crop(sd, &a);
+	ret = mt9m001_set_selection(sd, NULL, &sel);
 	if (!ret) {
 		mf->width	= mt9m001->rect.width;
 		mf->height	= mt9m001->rect.height;
@@ -614,9 +621,6 @@ static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
 	.s_mbus_fmt	= mt9m001_s_fmt,
 	.g_mbus_fmt	= mt9m001_g_fmt,
 	.try_mbus_fmt	= mt9m001_try_fmt,
-	.s_crop		= mt9m001_s_crop,
-	.g_crop		= mt9m001_g_crop,
-	.cropcap	= mt9m001_cropcap,
 	.enum_mbus_fmt	= mt9m001_enum_fmt,
 	.g_mbus_config	= mt9m001_g_mbus_config,
 	.s_mbus_config	= mt9m001_s_mbus_config,
@@ -626,10 +630,16 @@ static struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
 	.g_skip_top_lines	= mt9m001_g_skip_top_lines,
 };
 
+static struct v4l2_subdev_pad_ops mt9m001_subdev_pad_ops = {
+	.get_selection	= mt9m001_get_selection,
+	.set_selection	= mt9m001_set_selection,
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
index 5992ea9..a5c82e1 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -383,14 +383,18 @@ static int mt9m111_reset(struct mt9m111 *mt9m111)
 	return ret;
 }
 
-static int mt9m111_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
+static int mt9m111_set_selection(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_selection *sel)
 {
-	struct v4l2_rect rect = a->c;
-	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct v4l2_rect rect = sel->r;
 	int width, height;
 	int ret;
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
 	if (mt9m111->fmt->code == MEDIA_BUS_FMT_SBGGR8_1X8 ||
@@ -421,30 +425,30 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	return ret;
 }
 
-static int mt9m111_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int mt9m111_get_selection(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_selection *sel)
 {
-	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
-
-	a->c	= mt9m111->rect;
-	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	return 0;
-}
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
-static int mt9m111_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
 		return -EINVAL;
 
-	a->bounds.left			= MT9M111_MIN_DARK_COLS;
-	a->bounds.top			= MT9M111_MIN_DARK_ROWS;
-	a->bounds.width			= MT9M111_MAX_WIDTH;
-	a->bounds.height		= MT9M111_MAX_HEIGHT;
-	a->defrect			= a->bounds;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
-
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.left = MT9M111_MIN_DARK_COLS;
+		sel->r.top = MT9M111_MIN_DARK_ROWS;
+		sel->r.width = MT9M111_MAX_WIDTH;
+		sel->r.height = MT9M111_MAX_HEIGHT;
+		return 0;
+	case V4L2_SEL_TGT_CROP:
+		sel->r = mt9m111->rect;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int mt9m111_g_fmt(struct v4l2_subdev *sd,
@@ -868,16 +872,19 @@ static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 	.s_mbus_fmt	= mt9m111_s_fmt,
 	.g_mbus_fmt	= mt9m111_g_fmt,
 	.try_mbus_fmt	= mt9m111_try_fmt,
-	.s_crop		= mt9m111_s_crop,
-	.g_crop		= mt9m111_g_crop,
-	.cropcap	= mt9m111_cropcap,
 	.enum_mbus_fmt	= mt9m111_enum_fmt,
 	.g_mbus_config	= mt9m111_g_mbus_config,
 };
 
+static struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
+	.get_selection	= mt9m111_get_selection,
+	.set_selection	= mt9m111_set_selection,
+};
+
 static struct v4l2_subdev_ops mt9m111_subdev_ops = {
 	.core	= &mt9m111_subdev_core_ops,
 	.video	= &mt9m111_subdev_video_ops,
+	.pad	= &mt9m111_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 35d9c8d..48ec59b 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -294,11 +294,17 @@ static int mt9t031_set_params(struct i2c_client *client,
 	return ret < 0 ? ret : 0;
 }
 
-static int mt9t031_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
+static int mt9t031_set_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
-	struct v4l2_rect rect = a->c;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
+	struct v4l2_rect rect = sel->r;
+
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
 
 	rect.width = ALIGN(rect.width, 2);
 	rect.height = ALIGN(rect.height, 2);
@@ -312,29 +318,30 @@ static int mt9t031_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	return mt9t031_set_params(client, &rect, mt9t031->xskip, mt9t031->yskip);
 }
 
-static int mt9t031_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int mt9t031_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 
-	a->c	= mt9t031->rect;
-	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	return 0;
-}
-
-static int mt9t031_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	a->bounds.left			= MT9T031_COLUMN_SKIP;
-	a->bounds.top			= MT9T031_ROW_SKIP;
-	a->bounds.width			= MT9T031_MAX_WIDTH;
-	a->bounds.height		= MT9T031_MAX_HEIGHT;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.left = MT9T031_COLUMN_SKIP;
+		sel->r.top = MT9T031_ROW_SKIP;
+		sel->r.width = MT9T031_MAX_WIDTH;
+		sel->r.height = MT9T031_MAX_HEIGHT;
+		return 0;
+	case V4L2_SEL_TGT_CROP:
+		sel->r = mt9t031->rect;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int mt9t031_g_fmt(struct v4l2_subdev *sd,
@@ -715,9 +722,6 @@ static struct v4l2_subdev_video_ops mt9t031_subdev_video_ops = {
 	.s_mbus_fmt	= mt9t031_s_fmt,
 	.g_mbus_fmt	= mt9t031_g_fmt,
 	.try_mbus_fmt	= mt9t031_try_fmt,
-	.s_crop		= mt9t031_s_crop,
-	.g_crop		= mt9t031_g_crop,
-	.cropcap	= mt9t031_cropcap,
 	.enum_mbus_fmt	= mt9t031_enum_fmt,
 	.g_mbus_config	= mt9t031_g_mbus_config,
 	.s_mbus_config	= mt9t031_s_mbus_config,
@@ -727,10 +731,16 @@ static struct v4l2_subdev_sensor_ops mt9t031_subdev_sensor_ops = {
 	.g_skip_top_lines	= mt9t031_g_skip_top_lines,
 };
 
+static struct v4l2_subdev_pad_ops mt9t031_subdev_pad_ops = {
+	.get_selection	= mt9t031_get_selection,
+	.set_selection	= mt9t031_set_selection,
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
index 64f0836..9fec271 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -867,39 +867,48 @@ static int mt9t112_set_params(struct mt9t112_priv *priv,
 	return 0;
 }
 
-static int mt9t112_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
-	a->bounds.width			= MAX_WIDTH;
-	a->bounds.height		= MAX_HEIGHT;
-	a->defrect.left			= 0;
-	a->defrect.top			= 0;
-	a->defrect.width		= VGA_WIDTH;
-	a->defrect.height		= VGA_HEIGHT;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
-
-	return 0;
-}
-
-static int mt9t112_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int mt9t112_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
 
-	a->c	= priv->frame;
-	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = MAX_WIDTH;
+		sel->r.height = MAX_HEIGHT;
+		return 0;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = VGA_WIDTH;
+		sel->r.height = VGA_HEIGHT;
+		return 0;
+	case V4L2_SEL_TGT_CROP:
+		sel->r = priv->frame;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
-static int mt9t112_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
+static int mt9t112_set_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
-	const struct v4l2_rect *rect = &a->c;
+	const struct v4l2_rect *rect = &sel->r;
+
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
 
 	return mt9t112_set_params(priv, rect, priv->format->code);
 }
@@ -1013,20 +1022,23 @@ static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 	.g_mbus_fmt	= mt9t112_g_fmt,
 	.s_mbus_fmt	= mt9t112_s_fmt,
 	.try_mbus_fmt	= mt9t112_try_fmt,
-	.cropcap	= mt9t112_cropcap,
-	.g_crop		= mt9t112_g_crop,
-	.s_crop		= mt9t112_s_crop,
 	.enum_mbus_fmt	= mt9t112_enum_fmt,
 	.g_mbus_config	= mt9t112_g_mbus_config,
 	.s_mbus_config	= mt9t112_s_mbus_config,
 };
 
+static struct v4l2_subdev_pad_ops mt9t112_subdev_pad_ops = {
+	.get_selection	= mt9t112_get_selection,
+	.set_selection	= mt9t112_set_selection,
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
index a246d4d..9f65aae 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -276,14 +276,20 @@ static int mt9v022_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int mt9v022_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
+static int mt9v022_set_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct v4l2_rect rect = a->c;
+	struct v4l2_rect rect = sel->r;
 	int min_row, min_blank;
 	int ret;
 
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
 	/* Bayer format - even size lengths */
 	if (mt9v022->fmts == mt9v022_colour_fmts) {
 		rect.width	= ALIGN(rect.width, 2);
@@ -350,29 +356,30 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	return 0;
 }
 
-static int mt9v022_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int mt9v022_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 
-	a->c	= mt9v022->rect;
-	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	return 0;
-}
-
-static int mt9v022_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	a->bounds.left			= MT9V022_COLUMN_SKIP;
-	a->bounds.top			= MT9V022_ROW_SKIP;
-	a->bounds.width			= MT9V022_MAX_WIDTH;
-	a->bounds.height		= MT9V022_MAX_HEIGHT;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.left = MT9V022_COLUMN_SKIP;
+		sel->r.top = MT9V022_ROW_SKIP;
+		sel->r.width = MT9V022_MAX_WIDTH;
+		sel->r.height = MT9V022_MAX_HEIGHT;
+		return 0;
+	case V4L2_SEL_TGT_CROP:
+		sel->r = mt9v022->rect;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int mt9v022_g_fmt(struct v4l2_subdev *sd,
@@ -395,13 +402,13 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct v4l2_crop a = {
-		.c = {
-			.left	= mt9v022->rect.left,
-			.top	= mt9v022->rect.top,
-			.width	= mf->width,
-			.height	= mf->height,
-		},
+	struct v4l2_subdev_selection sel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = V4L2_SEL_TGT_CROP,
+		.r.left = mt9v022->rect.left,
+		.r.top = mt9v022->rect.top,
+		.r.width = mf->width,
+		.r.height = mf->height,
 	};
 	int ret;
 
@@ -425,7 +432,7 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
 	}
 
 	/* No support for scaling on this camera, just crop. */
-	ret = mt9v022_s_crop(sd, &a);
+	ret = mt9v022_set_selection(sd, NULL, &sel);
 	if (!ret) {
 		mf->width	= mt9v022->rect.width;
 		mf->height	= mt9v022->rect.height;
@@ -842,9 +849,6 @@ static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
 	.s_mbus_fmt	= mt9v022_s_fmt,
 	.g_mbus_fmt	= mt9v022_g_fmt,
 	.try_mbus_fmt	= mt9v022_try_fmt,
-	.s_crop		= mt9v022_s_crop,
-	.g_crop		= mt9v022_g_crop,
-	.cropcap	= mt9v022_cropcap,
 	.enum_mbus_fmt	= mt9v022_enum_fmt,
 	.g_mbus_config	= mt9v022_g_mbus_config,
 	.s_mbus_config	= mt9v022_s_mbus_config,
@@ -854,10 +858,16 @@ static struct v4l2_subdev_sensor_ops mt9v022_subdev_sensor_ops = {
 	.g_skip_top_lines	= mt9v022_g_skip_top_lines,
 };
 
+static struct v4l2_subdev_pad_ops mt9v022_subdev_pad_ops = {
+	.get_selection	= mt9v022_get_selection,
+	.set_selection	= mt9v022_set_selection,
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
index 6f2dd90..ddd2e54 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -950,29 +950,25 @@ static int ov2640_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
-static int ov2640_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int ov2640_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
-	a->c.left	= 0;
-	a->c.top	= 0;
-	a->c.width	= W_UXGA;
-	a->c.height	= H_UXGA;
-	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	return 0;
-}
-
-static int ov2640_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
-	a->bounds.width			= W_UXGA;
-	a->bounds.height		= H_UXGA;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = W_UXGA;
+		sel->r.height = H_UXGA;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int ov2640_video_probe(struct i2c_client *client)
@@ -1049,15 +1045,18 @@ static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
 	.g_mbus_fmt	= ov2640_g_fmt,
 	.s_mbus_fmt	= ov2640_s_fmt,
 	.try_mbus_fmt	= ov2640_try_fmt,
-	.cropcap	= ov2640_cropcap,
-	.g_crop		= ov2640_g_crop,
 	.enum_mbus_fmt	= ov2640_enum_fmt,
 	.g_mbus_config	= ov2640_g_mbus_config,
 };
 
+static struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
+	.get_selection	= ov2640_get_selection,
+};
+
 static struct v4l2_subdev_ops ov2640_subdev_ops = {
 	.core	= &ov2640_subdev_core_ops,
 	.video	= &ov2640_subdev_video_ops,
+	.pad	= &ov2640_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 93ae031..43f0b29 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -849,13 +849,19 @@ static int ov5642_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
-static int ov5642_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
+static int ov5642_set_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov5642 *priv = to_ov5642(client);
-	struct v4l2_rect rect = a->c;
+	struct v4l2_rect rect = sel->r;
 	int ret;
 
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
 	v4l_bound_align_image(&rect.width, 48, OV5642_MAX_WIDTH, 1,
 			      &rect.height, 32, OV5642_MAX_HEIGHT, 1, 0);
 
@@ -877,32 +883,30 @@ static int ov5642_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	return ret;
 }
 
-static int ov5642_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int ov5642_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov5642 *priv = to_ov5642(client);
-	struct v4l2_rect *rect = &a->c;
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
 		return -EINVAL;
 
-	*rect = priv->crop_rect;
-
-	return 0;
-}
-
-static int ov5642_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
-	a->bounds.width			= OV5642_MAX_WIDTH;
-	a->bounds.height		= OV5642_MAX_HEIGHT;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
-
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = OV5642_MAX_WIDTH;
+		sel->r.height = OV5642_MAX_HEIGHT;
+		return 0;
+	case V4L2_SEL_TGT_CROP:
+		sel->r = priv->crop_rect;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int ov5642_g_mbus_config(struct v4l2_subdev *sd,
@@ -943,9 +947,6 @@ static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 	.g_mbus_fmt	= ov5642_g_fmt,
 	.try_mbus_fmt	= ov5642_try_fmt,
 	.enum_mbus_fmt	= ov5642_enum_fmt,
-	.s_crop		= ov5642_s_crop,
-	.g_crop		= ov5642_g_crop,
-	.cropcap	= ov5642_cropcap,
 	.g_mbus_config	= ov5642_g_mbus_config,
 };
 
@@ -957,9 +958,15 @@ static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
 #endif
 };
 
+static struct v4l2_subdev_pad_ops ov5642_subdev_pad_ops = {
+	.get_selection	= ov5642_get_selection,
+	.set_selection	= ov5642_set_selection,
+};
+
 static struct v4l2_subdev_ops ov5642_subdev_ops = {
 	.core	= &ov5642_subdev_core_ops,
 	.video	= &ov5642_subdev_video_ops,
+	.pad	= &ov5642_subdev_pad_ops,
 };
 
 static int ov5642_video_probe(struct i2c_client *client)
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index f4eef2f..cee61eb 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -432,25 +432,43 @@ static int ov6650_s_power(struct v4l2_subdev *sd, int on)
 	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
 }
 
-static int ov6650_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int ov6650_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
 
-	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->c = priv->rect;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.left = DEF_HSTRT << 1;
+		sel->r.top = DEF_VSTRT << 1;
+		sel->r.width = W_CIF;
+		sel->r.height = H_CIF;
+		return 0;
+	case V4L2_SEL_TGT_CROP:
+		sel->r = priv->rect;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
-static int ov6650_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
+static int ov6650_set_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
-	struct v4l2_rect rect = a->c;
+	struct v4l2_rect rect = sel->r;
 	int ret;
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
 	rect.left   = ALIGN(rect.left,   2);
@@ -483,22 +501,6 @@ static int ov6650_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	return ret;
 }
 
-static int ov6650_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	a->bounds.left			= DEF_HSTRT << 1;
-	a->bounds.top			= DEF_VSTRT << 1;
-	a->bounds.width			= W_CIF;
-	a->bounds.height		= H_CIF;
-	a->defrect			= a->bounds;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
-
-	return 0;
-}
-
 static int ov6650_g_fmt(struct v4l2_subdev *sd,
 			 struct v4l2_mbus_framefmt *mf)
 {
@@ -544,16 +546,15 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 	struct soc_camera_sense *sense = icd->sense;
 	struct ov6650 *priv = to_ov6650(client);
 	bool half_scale = !is_unscaled_ok(mf->width, mf->height, &priv->rect);
-	struct v4l2_crop a = {
-		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
-		.c = {
-			.left	= priv->rect.left + (priv->rect.width >> 1) -
-					(mf->width >> (1 - half_scale)),
-			.top	= priv->rect.top + (priv->rect.height >> 1) -
-					(mf->height >> (1 - half_scale)),
-			.width	= mf->width << half_scale,
-			.height	= mf->height << half_scale,
-		},
+	struct v4l2_subdev_selection sel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = V4L2_SEL_TGT_CROP,
+		.r.left = priv->rect.left + (priv->rect.width >> 1) -
+			(mf->width >> (1 - half_scale)),
+		.r.top = priv->rect.top + (priv->rect.height >> 1) -
+			(mf->height >> (1 - half_scale)),
+		.r.width = mf->width << half_scale,
+		.r.height = mf->height << half_scale,
 	};
 	u32 code = mf->code;
 	unsigned long mclk, pclk;
@@ -667,7 +668,7 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 	dev_dbg(&client->dev, "pixel clock divider: %ld.%ld\n",
 			mclk / pclk, 10 * mclk % pclk / pclk);
 
-	ret = ov6650_s_crop(sd, &a);
+	ret = ov6650_set_selection(sd, NULL, &sel);
 	if (!ret)
 		ret = ov6650_reg_rmw(client, REG_COMA, coma_set, coma_mask);
 	if (!ret)
@@ -933,18 +934,21 @@ static struct v4l2_subdev_video_ops ov6650_video_ops = {
 	.s_mbus_fmt	= ov6650_s_fmt,
 	.try_mbus_fmt	= ov6650_try_fmt,
 	.enum_mbus_fmt	= ov6650_enum_fmt,
-	.cropcap	= ov6650_cropcap,
-	.g_crop		= ov6650_g_crop,
-	.s_crop		= ov6650_s_crop,
 	.g_parm		= ov6650_g_parm,
 	.s_parm		= ov6650_s_parm,
 	.g_mbus_config	= ov6650_g_mbus_config,
 	.s_mbus_config	= ov6650_s_mbus_config,
 };
 
+static struct v4l2_subdev_pad_ops ov6650_subdev_pad_ops = {
+	.get_selection	= ov6650_get_selection,
+	.set_selection	= ov6650_set_selection,
+};
+
 static struct v4l2_subdev_ops ov6650_subdev_ops = {
 	.core	= &ov6650_core_ops,
 	.video	= &ov6650_video_ops,
+	.pad	= &ov6650_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 8daac88..08ea114 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -851,29 +851,28 @@ ov772x_set_fmt_error:
 	return ret;
 }
 
-static int ov772x_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int ov772x_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
-	a->c.left	= 0;
-	a->c.top	= 0;
-	a->c.width	= VGA_WIDTH;
-	a->c.height	= VGA_HEIGHT;
-	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	return 0;
-}
-
-static int ov772x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
-	a->bounds.width			= OV772X_MAX_WIDTH;
-	a->bounds.height		= OV772X_MAX_HEIGHT;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	sel->r.left = 0;
+	sel->r.top = 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.width = OV772X_MAX_WIDTH;
+		sel->r.height = OV772X_MAX_HEIGHT;
+		return 0;
+	case V4L2_SEL_TGT_CROP:
+		sel->r.width = VGA_WIDTH;
+		sel->r.height = VGA_HEIGHT;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int ov772x_g_fmt(struct v4l2_subdev *sd,
@@ -1019,15 +1018,18 @@ static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 	.g_mbus_fmt	= ov772x_g_fmt,
 	.s_mbus_fmt	= ov772x_s_fmt,
 	.try_mbus_fmt	= ov772x_try_fmt,
-	.cropcap	= ov772x_cropcap,
-	.g_crop		= ov772x_g_crop,
 	.enum_mbus_fmt	= ov772x_enum_fmt,
 	.g_mbus_config	= ov772x_g_mbus_config,
 };
 
+static struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
+	.get_selection	= ov772x_get_selection,
+};
+
 static struct v4l2_subdev_ops ov772x_subdev_ops = {
 	.core	= &ov772x_subdev_core_ops,
 	.video	= &ov772x_subdev_video_ops,
+	.pad	= &ov772x_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index aa93d2e..be69c2f 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -550,29 +550,25 @@ static int ov9640_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
-static int ov9640_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int ov9640_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
-	a->c.left	= 0;
-	a->c.top	= 0;
-	a->c.width	= W_SXGA;
-	a->c.height	= H_SXGA;
-	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	return 0;
-}
-
-static int ov9640_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
-	a->bounds.width			= W_SXGA;
-	a->bounds.height		= H_SXGA;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	sel->r.left = 0;
+	sel->r.top = 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP:
+		sel->r.width = W_SXGA;
+		sel->r.height = H_SXGA;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int ov9640_video_probe(struct i2c_client *client)
@@ -659,14 +655,17 @@ static struct v4l2_subdev_video_ops ov9640_video_ops = {
 	.s_mbus_fmt	= ov9640_s_fmt,
 	.try_mbus_fmt	= ov9640_try_fmt,
 	.enum_mbus_fmt	= ov9640_enum_fmt,
-	.cropcap	= ov9640_cropcap,
-	.g_crop		= ov9640_g_crop,
 	.g_mbus_config	= ov9640_g_mbus_config,
 };
 
+static struct v4l2_subdev_pad_ops ov9640_subdev_pad_ops = {
+	.get_selection	= ov9640_get_selection,
+};
+
 static struct v4l2_subdev_ops ov9640_subdev_ops = {
 	.core	= &ov9640_core_ops,
 	.video	= &ov9640_video_ops,
+	.pad	= &ov9640_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 841dc55..8c1c225 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -727,29 +727,25 @@ static int ov9740_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
-static int ov9740_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+static int ov9740_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
-	a->bounds.left		= 0;
-	a->bounds.top		= 0;
-	a->bounds.width		= OV9740_MAX_WIDTH;
-	a->bounds.height	= OV9740_MAX_HEIGHT;
-	a->defrect		= a->bounds;
-	a->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
-
-	return 0;
-}
-
-static int ov9740_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
-{
-	a->c.left		= 0;
-	a->c.top		= 0;
-	a->c.width		= OV9740_MAX_WIDTH;
-	a->c.height		= OV9740_MAX_HEIGHT;
-	a->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = OV9740_MAX_WIDTH;
+		sel->r.height = OV9740_MAX_HEIGHT;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 /* Set status of additional camera capabilities */
@@ -907,8 +903,6 @@ static struct v4l2_subdev_video_ops ov9740_video_ops = {
 	.s_mbus_fmt	= ov9740_s_fmt,
 	.try_mbus_fmt	= ov9740_try_fmt,
 	.enum_mbus_fmt	= ov9740_enum_fmt,
-	.cropcap	= ov9740_cropcap,
-	.g_crop		= ov9740_g_crop,
 	.g_mbus_config	= ov9740_g_mbus_config,
 };
 
@@ -920,9 +914,14 @@ static struct v4l2_subdev_core_ops ov9740_core_ops = {
 #endif
 };
 
+static struct v4l2_subdev_pad_ops ov9740_subdev_pad_ops = {
+	.get_selection	= ov9740_get_selection,
+};
+
 static struct v4l2_subdev_ops ov9740_subdev_ops = {
-	.core			= &ov9740_core_ops,
-	.video			= &ov9740_video_ops,
+	.core	= &ov9740_core_ops,
+	.video	= &ov9740_video_ops,
+	.pad	= &ov9740_subdev_pad_ops,
 };
 
 static const struct v4l2_ctrl_ops ov9740_ctrl_ops = {
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 1752428..48f436c 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -537,15 +537,21 @@ static int rj54n1_commit(struct i2c_client *client)
 static int rj54n1_sensor_scale(struct v4l2_subdev *sd, s32 *in_w, s32 *in_h,
 			       s32 *out_w, s32 *out_h);
 
-static int rj54n1_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
+static int rj54n1_set_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	const struct v4l2_rect *rect = &a->c;
+	const struct v4l2_rect *rect = &sel->r;
 	int dummy = 0, output_w, output_h,
 		input_w = rect->width, input_h = rect->height;
 	int ret;
 
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
 	/* arbitrary minimum width and height, edges unimportant */
 	soc_camera_limit_side(&dummy, &input_w,
 		     RJ54N1_COLUMN_SKIP, 8, RJ54N1_MAX_WIDTH);
@@ -572,29 +578,30 @@ static int rj54n1_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	return 0;
 }
 
-static int rj54n1_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int rj54n1_get_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 
-	a->c	= rj54n1->rect;
-	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	return 0;
-}
-
-static int rj54n1_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	a->bounds.left			= RJ54N1_COLUMN_SKIP;
-	a->bounds.top			= RJ54N1_ROW_SKIP;
-	a->bounds.width			= RJ54N1_MAX_WIDTH;
-	a->bounds.height		= RJ54N1_MAX_HEIGHT;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.left = RJ54N1_COLUMN_SKIP;
+		sel->r.top = RJ54N1_ROW_SKIP;
+		sel->r.width = RJ54N1_MAX_WIDTH;
+		sel->r.height = RJ54N1_MAX_HEIGHT;
+		return 0;
+	case V4L2_SEL_TGT_CROP:
+		sel->r = rj54n1->rect;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int rj54n1_g_fmt(struct v4l2_subdev *sd,
@@ -1253,16 +1260,19 @@ static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 	.g_mbus_fmt	= rj54n1_g_fmt,
 	.try_mbus_fmt	= rj54n1_try_fmt,
 	.enum_mbus_fmt	= rj54n1_enum_fmt,
-	.g_crop		= rj54n1_g_crop,
-	.s_crop		= rj54n1_s_crop,
-	.cropcap	= rj54n1_cropcap,
 	.g_mbus_config	= rj54n1_g_mbus_config,
 	.s_mbus_config	= rj54n1_s_mbus_config,
 };
 
+static struct v4l2_subdev_pad_ops rj54n1_subdev_pad_ops = {
+	.get_selection	= rj54n1_get_selection,
+	.set_selection	= rj54n1_set_selection,
+};
+
 static struct v4l2_subdev_ops rj54n1_subdev_ops = {
 	.core	= &rj54n1_subdev_core_ops,
 	.video	= &rj54n1_subdev_video_ops,
+	.pad	= &rj54n1_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 9b85321..c7b44df 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -650,44 +650,28 @@ tw9910_set_fmt_error:
 	return ret;
 }
 
-static int tw9910_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int tw9910_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
 
-	a->c.left	= 0;
-	a->c.top	= 0;
-	if (priv->norm & V4L2_STD_NTSC) {
-		a->c.width	= 640;
-		a->c.height	= 480;
-	} else {
-		a->c.width	= 768;
-		a->c.height	= 576;
-	}
-	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	return 0;
-}
-
-static int tw9910_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct tw9910_priv *priv = to_tw9910(client);
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
+	/* Only CROP, CROP_DEFAULT and CROP_BOUNDS are supported */
+	if (sel->target > V4L2_SEL_TGT_CROP_BOUNDS)
+		return -EINVAL;
 
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
+	sel->r.left	= 0;
+	sel->r.top	= 0;
 	if (priv->norm & V4L2_STD_NTSC) {
-		a->bounds.width		= 640;
-		a->bounds.height	= 480;
+		sel->r.width	= 640;
+		sel->r.height	= 480;
 	} else {
-		a->bounds.width		= 768;
-		a->bounds.height	= 576;
+		sel->r.width	= 768;
+		sel->r.height	= 576;
 	}
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
-
 	return 0;
 }
 
@@ -883,17 +867,20 @@ static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.g_mbus_fmt	= tw9910_g_fmt,
 	.s_mbus_fmt	= tw9910_s_fmt,
 	.try_mbus_fmt	= tw9910_try_fmt,
-	.cropcap	= tw9910_cropcap,
-	.g_crop		= tw9910_g_crop,
 	.enum_mbus_fmt	= tw9910_enum_fmt,
 	.g_mbus_config	= tw9910_g_mbus_config,
 	.s_mbus_config	= tw9910_s_mbus_config,
 	.g_tvnorms	= tw9910_g_tvnorms,
 };
 
+static struct v4l2_subdev_pad_ops tw9910_subdev_pad_ops = {
+	.get_selection	= tw9910_get_selection,
+};
+
 static struct v4l2_subdev_ops tw9910_subdev_ops = {
 	.core	= &tw9910_subdev_core_ops,
 	.video	= &tw9910_subdev_video_ops,
+	.pad	= &tw9910_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 68cdab9..397bb12 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -849,19 +849,22 @@ static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int tvp5150_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
+static int tvp5150_set_selection(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_selection *sel)
 {
-	struct v4l2_rect rect = a->c;
 	struct tvp5150 *decoder = to_tvp5150(sd);
+	struct v4l2_rect rect = sel->r;
 	v4l2_std_id std;
-	unsigned int hmax;
+	int hmax;
+
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
 
 	v4l2_dbg(1, debug, sd, "%s left=%d, top=%d, width=%d, height=%d\n",
 		__func__, rect.left, rect.top, rect.width, rect.height);
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
 	/* tvp5150 has some special limits */
 	rect.left = clamp(rect.left, 0, TVP5150_MAX_CROP_LEFT);
 	rect.width = clamp_t(unsigned int, rect.width,
@@ -902,44 +905,39 @@ static int tvp5150_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	return 0;
 }
 
-static int tvp5150_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
-{
-	struct tvp5150 *decoder = to_tvp5150(sd);
-
-	a->c	= decoder->rect;
-	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	return 0;
-}
-
-static int tvp5150_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+static int tvp5150_get_selection(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_selection *sel)
 {
-	struct tvp5150 *decoder = to_tvp5150(sd);
+	struct tvp5150 *decoder = container_of(sd, struct tvp5150, sd);
 	v4l2_std_id std;
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
 		return -EINVAL;
 
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
-	a->bounds.width			= TVP5150_H_MAX;
-
-	/* Calculate height based on current standard */
-	if (decoder->norm == V4L2_STD_ALL)
-		std = tvp5150_read_std(sd);
-	else
-		std = decoder->norm;
-
-	if (std & V4L2_STD_525_60)
-		a->bounds.height = TVP5150_V_MAX_525_60;
-	else
-		a->bounds.height = TVP5150_V_MAX_OTHERS;
-
-	a->defrect			= a->bounds;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
-
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = TVP5150_H_MAX;
+
+		/* Calculate height based on current standard */
+		if (decoder->norm == V4L2_STD_ALL)
+			std = tvp5150_read_std(sd);
+		else
+			std = decoder->norm;
+		if (std & V4L2_STD_525_60)
+			sel->r.height = TVP5150_V_MAX_525_60;
+		else
+			sel->r.height = TVP5150_V_MAX_OTHERS;
+		return 0;
+	case V4L2_SEL_TGT_CROP:
+		sel->r = decoder->rect;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 /****************************************************************************
@@ -1072,9 +1070,11 @@ static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_mbus_fmt = tvp5150_mbus_fmt,
 	.try_mbus_fmt = tvp5150_mbus_fmt,
 	.g_mbus_fmt = tvp5150_mbus_fmt,
-	.s_crop = tvp5150_s_crop,
-	.g_crop = tvp5150_g_crop,
-	.cropcap = tvp5150_cropcap,
+};
+
+static struct v4l2_subdev_pad_ops tvp5150_subdev_pad_ops = {
+	.get_selection = tvp5150_get_selection,
+	.set_selection = tvp5150_set_selection,
 };
 
 static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
@@ -1089,6 +1089,7 @@ static const struct v4l2_subdev_ops tvp5150_ops = {
 	.tuner = &tvp5150_tuner_ops,
 	.video = &tvp5150_video_ops,
 	.vbi = &tvp5150_vbi_ops,
+	.pad = &tvp5150_subdev_pad_ops,
 };
 
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index b463fe1..55945e6 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -713,40 +713,45 @@ isp_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
 }
 
 static int
-isp_video_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropcap)
-{
-	struct isp_video *video = video_drvdata(file);
-	struct v4l2_subdev *subdev;
-	int ret;
-
-	subdev = isp_video_remote_subdev(video, NULL);
-	if (subdev == NULL)
-		return -EINVAL;
-
-	mutex_lock(&video->mutex);
-	ret = v4l2_subdev_call(subdev, video, cropcap, cropcap);
-	mutex_unlock(&video->mutex);
-
-	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
-}
-
-static int
-isp_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+isp_video_get_selection(struct file *file, void *fh, struct v4l2_selection *sel)
 {
 	struct isp_video *video = video_drvdata(file);
 	struct v4l2_subdev_format format;
 	struct v4l2_subdev *subdev;
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = sel->target,
+	};
 	u32 pad;
 	int ret;
 
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			return -EINVAL;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
 	subdev = isp_video_remote_subdev(video, &pad);
 	if (subdev == NULL)
 		return -EINVAL;
 
-	/* Try the get crop operation first and fallback to get format if not
+	/* Try the get selection operation first and fallback to get format if not
 	 * implemented.
 	 */
-	ret = v4l2_subdev_call(subdev, video, g_crop, crop);
+	sdsel.pad = pad;
+	ret = v4l2_subdev_call(subdev, pad, get_selection, NULL, &sdsel);
+	if (!ret)
+		sel->r = sdsel.r;
 	if (ret != -ENOIOCTLCMD)
 		return ret;
 
@@ -756,28 +761,50 @@ isp_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
 	if (ret < 0)
 		return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
 
-	crop->c.left = 0;
-	crop->c.top = 0;
-	crop->c.width = format.format.width;
-	crop->c.height = format.format.height;
+	sel->r.left = 0;
+	sel->r.top = 0;
+	sel->r.width = format.format.width;
+	sel->r.height = format.format.height;
 
 	return 0;
 }
 
 static int
-isp_video_set_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
+isp_video_set_selection(struct file *file, void *fh, struct v4l2_selection *sel)
 {
 	struct isp_video *video = video_drvdata(file);
 	struct v4l2_subdev *subdev;
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = sel->target,
+		.flags = sel->flags,
+		.r = sel->r,
+	};
+	u32 pad;
 	int ret;
 
-	subdev = isp_video_remote_subdev(video, NULL);
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			return -EINVAL;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+	subdev = isp_video_remote_subdev(video, &pad);
 	if (subdev == NULL)
 		return -EINVAL;
 
+	sdsel.pad = pad;
 	mutex_lock(&video->mutex);
-	ret = v4l2_subdev_call(subdev, video, s_crop, crop);
+	ret = v4l2_subdev_call(subdev, pad, set_selection, NULL, &sdsel);
 	mutex_unlock(&video->mutex);
+	if (!ret)
+		sel->r = sdsel.r;
 
 	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
 }
@@ -1205,9 +1232,8 @@ static const struct v4l2_ioctl_ops isp_video_ioctl_ops = {
 	.vidioc_g_fmt_vid_out		= isp_video_get_format,
 	.vidioc_s_fmt_vid_out		= isp_video_set_format,
 	.vidioc_try_fmt_vid_out		= isp_video_try_format,
-	.vidioc_cropcap			= isp_video_cropcap,
-	.vidioc_g_crop			= isp_video_get_crop,
-	.vidioc_s_crop			= isp_video_set_crop,
+	.vidioc_g_selection		= isp_video_get_selection,
+	.vidioc_s_selection		= isp_video_set_selection,
 	.vidioc_g_parm			= isp_video_get_param,
 	.vidioc_s_parm			= isp_video_set_param,
 	.vidioc_reqbufs			= isp_video_reqbufs,
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 154ef0b..0600ac3 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -939,7 +939,10 @@ static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 	struct v4l2_crop a_writable = *a;
 	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct v4l2_rect *rect = &a_writable.c;
-	struct v4l2_crop sd_crop = {.type = V4L2_BUF_TYPE_VIDEO_OUTPUT};
+	struct v4l2_subdev_selection sd_sel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = V4L2_SEL_TGT_COMPOSE,
+	};
 	struct v4l2_pix_format *pix = &vou_dev->pix;
 	struct sh_vou_geometry geo;
 	struct v4l2_mbus_framefmt mbfmt = {
@@ -976,14 +979,14 @@ static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 	geo.in_height = pix->height;
 
 	/* Configure the encoder one-to-one, position at 0, ignore errors */
-	sd_crop.c.width = geo.output.width;
-	sd_crop.c.height = geo.output.height;
+	sd_sel.r.width = geo.output.width;
+	sd_sel.r.height = geo.output.height;
 	/*
 	 * We first issue a S_CROP, so that the subsequent S_FMT delivers the
 	 * final encoder configuration.
 	 */
-	v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, video,
-				   s_crop, &sd_crop);
+	v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, pad,
+				   set_selection, NULL, &sd_sel);
 	mbfmt.width = geo.output.width;
 	mbfmt.height = geo.output.height;
 	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, video,
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index ce72bd2..db86f2a 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -906,21 +906,27 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 	return 0;
 }
 
-static int mx2_camera_set_crop(struct soc_camera_device *icd,
-				const struct v4l2_crop *a)
+static int mx2_camera_set_selection(struct soc_camera_device *icd,
+				    struct v4l2_selection *sel)
 {
-	struct v4l2_crop a_writable = *a;
-	struct v4l2_rect *rect = &a_writable.c;
+	struct v4l2_rect *rect = &sel->r;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = sel->target,
+		.flags = sel->flags,
+		.r = sel->r,
+	};
 	int ret;
 
 	soc_camera_limit_side(&rect->left, &rect->width, 0, 2, 4096);
 	soc_camera_limit_side(&rect->top, &rect->height, 0, 2, 4096);
 
-	ret = v4l2_subdev_call(sd, video, s_crop, a);
+	ret = v4l2_subdev_call(sd, pad, set_selection, NULL, &sdsel);
 	if (ret < 0)
 		return ret;
+	*rect = sdsel.r;
 
 	/* The capture device might have changed its output  */
 	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
@@ -1275,7 +1281,7 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
 	.clock_start	= mx2_camera_clock_start,
 	.clock_stop	= mx2_camera_clock_stop,
 	.set_fmt	= mx2_camera_set_fmt,
-	.set_crop	= mx2_camera_set_crop,
+	.set_selection	= mx2_camera_set_selection,
 	.get_formats	= mx2_camera_get_formats,
 	.try_fmt	= mx2_camera_try_fmt,
 	.init_videobuf2	= mx2_camera_init_videobuf,
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 8e52ccc..51ea37b 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -790,23 +790,29 @@ static inline void stride_align(__u32 *width)
  * As long as we don't implement host-side cropping and scaling, we can use
  * default g_crop and cropcap from soc_camera.c
  */
-static int mx3_camera_set_crop(struct soc_camera_device *icd,
-			       const struct v4l2_crop *a)
+static int mx3_camera_set_selection(struct soc_camera_device *icd,
+				    struct v4l2_selection *sel)
 {
-	struct v4l2_crop a_writable = *a;
-	struct v4l2_rect *rect = &a_writable.c;
+	struct v4l2_rect *rect = &sel->r;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = sel->target,
+		.flags = sel->flags,
+		.r = sel->r,
+	};
 	int ret;
 
 	soc_camera_limit_side(&rect->left, &rect->width, 0, 2, 4096);
 	soc_camera_limit_side(&rect->top, &rect->height, 0, 2, 4096);
 
-	ret = v4l2_subdev_call(sd, video, s_crop, a);
+	ret = v4l2_subdev_call(sd, pad, set_selection, NULL, &sdsel);
 	if (ret < 0)
 		return ret;
+	sel->r = sdsel.r;
 
 	/* The capture device might have changed its output sizes */
 	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
@@ -1126,7 +1132,7 @@ static struct soc_camera_host_ops mx3_soc_camera_host_ops = {
 	.remove		= mx3_camera_remove_device,
 	.clock_start	= mx3_camera_clock_start,
 	.clock_stop	= mx3_camera_clock_stop,
-	.set_crop	= mx3_camera_set_crop,
+	.set_selection	= mx3_camera_set_selection,
 	.set_fmt	= mx3_camera_set_fmt,
 	.try_fmt	= mx3_camera_try_fmt,
 	.get_formats	= mx3_camera_get_formats,
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index e6b9328..5c3cf1d 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -1154,7 +1154,7 @@ static int dma_align(int *width, int *height,
 	return 1;
 }
 
-#define subdev_call_with_sense(pcdev, dev, icd, sd, function, args...)		     \
+#define subdev_call_with_sense(pcdev, dev, icd, sd, class, function, args...)	     \
 ({										     \
 	struct soc_camera_sense sense = {					     \
 		.master_clock		= pcdev->camexclk,			     \
@@ -1165,7 +1165,7 @@ static int dma_align(int *width, int *height,
 	if (pcdev->pdata)							     \
 		sense.pixel_clock_max = pcdev->pdata->lclk_khz_max * 1000;	     \
 	icd->sense = &sense;							     \
-	__ret = v4l2_subdev_call(sd, video, function, ##args);			     \
+	__ret = v4l2_subdev_call(sd, class, function, ##args);			     \
 	icd->sense = NULL;							     \
 										     \
 	if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {				     \
@@ -1185,7 +1185,7 @@ static int set_mbus_format(struct omap1_cam_dev *pcdev, struct device *dev,
 		const struct soc_camera_format_xlate *xlate)
 {
 	s32 bytes_per_line;
-	int ret = subdev_call_with_sense(pcdev, dev, icd, sd, s_mbus_fmt, mf);
+	int ret = subdev_call_with_sense(pcdev, dev, icd, sd, video, s_mbus_fmt, mf);
 
 	if (ret < 0) {
 		dev_err(dev, "%s: s_mbus_fmt failed\n", __func__);
@@ -1212,24 +1212,31 @@ static int set_mbus_format(struct omap1_cam_dev *pcdev, struct device *dev,
 	return 0;
 }
 
-static int omap1_cam_set_crop(struct soc_camera_device *icd,
-			       const struct v4l2_crop *crop)
+static int omap1_cam_set_selection(struct soc_camera_device *icd,
+				   struct v4l2_selection *sel)
 {
-	const struct v4l2_rect *rect = &crop->c;
+	struct v4l2_rect *rect = &sel->r;
 	const struct soc_camera_format_xlate *xlate = icd->current_fmt;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = sel->target,
+		.flags = sel->flags,
+		.r = sel->r,
+	};
 	int ret;
 
-	ret = subdev_call_with_sense(pcdev, dev, icd, sd, s_crop, crop);
+	ret = subdev_call_with_sense(pcdev, dev, icd, sd, pad, set_selection, NULL, &sdsel);
 	if (ret < 0) {
 		dev_warn(dev, "%s: failed to crop to %ux%u@%u:%u\n", __func__,
 			 rect->width, rect->height, rect->left, rect->top);
 		return ret;
 	}
+	*rect = sdsel.r;
 
 	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
 	if (ret < 0) {
@@ -1535,7 +1542,7 @@ static struct soc_camera_host_ops omap1_host_ops = {
 	.clock_start	= omap1_cam_clock_start,
 	.clock_stop	= omap1_cam_clock_stop,
 	.get_formats	= omap1_cam_get_formats,
-	.set_crop	= omap1_cam_set_crop,
+	.set_selection	= omap1_cam_set_selection,
 	.set_fmt	= omap1_cam_set_fmt,
 	.try_fmt	= omap1_cam_try_fmt,
 	.init_videobuf	= omap1_cam_init_videobuf,
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 951226a..ff74a3a 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1334,10 +1334,10 @@ static int pxa_camera_check_frame(u32 width, u32 height)
 		(width & 0x01);
 }
 
-static int pxa_camera_set_crop(struct soc_camera_device *icd,
-			       const struct v4l2_crop *a)
+static int pxa_camera_set_selection(struct soc_camera_device *icd,
+				    struct v4l2_selection *sel)
 {
-	const struct v4l2_rect *rect = &a->c;
+	const struct v4l2_rect *rect = &sel->r;
 	struct device *dev = icd->parent;
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct pxa_camera_dev *pcdev = ici->priv;
@@ -1349,13 +1349,19 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 	struct v4l2_mbus_framefmt mf;
 	struct pxa_cam *cam = icd->host_priv;
 	u32 fourcc = icd->current_fmt->host_fmt->fourcc;
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = sel->target,
+		.flags = sel->flags,
+		.r = sel->r,
+	};
 	int ret;
 
 	/* If PCLK is used to latch data from the sensor, check sense */
 	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
 		icd->sense = &sense;
 
-	ret = v4l2_subdev_call(sd, video, s_crop, a);
+	ret = v4l2_subdev_call(sd, pad, set_selection, NULL, &sdsel);
 
 	icd->sense = NULL;
 
@@ -1364,6 +1370,7 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 			 rect->width, rect->height, rect->left, rect->top);
 		return ret;
 	}
+	sel->r = sdsel.r;
 
 	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
 	if (ret < 0)
@@ -1639,7 +1646,7 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.remove		= pxa_camera_remove_device,
 	.clock_start	= pxa_camera_clock_start,
 	.clock_stop	= pxa_camera_clock_stop,
-	.set_crop	= pxa_camera_set_crop,
+	.set_selection	= pxa_camera_set_selection,
 	.get_formats	= pxa_camera_get_formats,
 	.put_formats	= pxa_camera_put_formats,
 	.set_fmt	= pxa_camera_set_fmt,
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 44461c5..5c40588 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1489,16 +1489,15 @@ static void rcar_vin_put_formats(struct soc_camera_device *icd)
 	icd->host_priv = NULL;
 }
 
-static int rcar_vin_set_crop(struct soc_camera_device *icd,
-			     const struct v4l2_crop *a)
+static int rcar_vin_set_selection(struct soc_camera_device *icd,
+				  struct v4l2_selection *sel)
 {
-	struct v4l2_crop a_writable = *a;
-	const struct v4l2_rect *rect = &a_writable.c;
+	const struct v4l2_rect *rect = &sel->r;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
-	struct v4l2_crop cam_crop;
+	struct v4l2_selection cam_sel;
 	struct rcar_vin_cam *cam = icd->host_priv;
-	struct v4l2_rect *cam_rect = &cam_crop.c;
+	struct v4l2_rect *cam_rect = &cam_sel.r;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
 	struct v4l2_mbus_framefmt mf;
@@ -1512,8 +1511,8 @@ static int rcar_vin_set_crop(struct soc_camera_device *icd,
 	capture_stop_preserve(priv, &vnmc);
 	dev_dbg(dev, "VNMC_REG 0x%x\n", vnmc);
 
-	/* Apply iterative camera S_CROP for new input window. */
-	ret = soc_camera_client_s_crop(sd, &a_writable, &cam_crop,
+	/* Apply iterative camera S_SELECTION for new input window. */
+	ret = soc_camera_client_s_selection(sd, sel, &cam_sel,
 				       &cam->rect, &cam->subrect);
 	if (ret < 0)
 		return ret;
@@ -1566,13 +1565,12 @@ static int rcar_vin_set_crop(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int rcar_vin_get_crop(struct soc_camera_device *icd,
-			     struct v4l2_crop *a)
+static int rcar_vin_get_selection(struct soc_camera_device *icd,
+				  struct v4l2_selection *sel)
 {
 	struct rcar_vin_cam *cam = icd->host_priv;
 
-	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->c = cam->subrect;
+	sel->r = cam->subrect;
 
 	return 0;
 }
@@ -1825,8 +1823,8 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
 	.clock_stop	= rcar_vin_clock_stop,
 	.get_formats	= rcar_vin_get_formats,
 	.put_formats	= rcar_vin_put_formats,
-	.get_crop	= rcar_vin_get_crop,
-	.set_crop	= rcar_vin_set_crop,
+	.get_selection	= rcar_vin_get_selection,
+	.set_selection	= rcar_vin_set_selection,
 	.try_fmt	= rcar_vin_try_fmt,
 	.set_fmt	= rcar_vin_set_fmt,
 	.poll		= rcar_vin_poll,
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 5f58ed9..9a92450 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1202,17 +1202,16 @@ static void sh_mobile_ceu_put_formats(struct soc_camera_device *icd)
  * Documentation/video4linux/sh_mobile_ceu_camera.txt for a description of
  * scaling and cropping algorithms and for the meaning of referenced here steps.
  */
-static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
-				  const struct v4l2_crop *a)
+static int sh_mobile_ceu_set_selection(struct soc_camera_device *icd,
+				       struct v4l2_selection *sel)
 {
-	struct v4l2_crop a_writable = *a;
-	const struct v4l2_rect *rect = &a_writable.c;
+	struct v4l2_rect *rect = &sel->r;
 	struct device *dev = icd->parent;
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct v4l2_crop cam_crop;
+	struct v4l2_selection cam_sel;
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct v4l2_rect *cam_rect = &cam_crop.c;
+	struct v4l2_rect *cam_rect = &cam_sel.r;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct v4l2_mbus_framefmt mf;
 	unsigned int scale_cam_h, scale_cam_v, scale_ceu_h, scale_ceu_v,
@@ -1232,7 +1231,7 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	 * 1. - 2. Apply iterative camera S_CROP for new input window, read back
 	 * actual camera rectangle.
 	 */
-	ret = soc_camera_client_s_crop(sd, &a_writable, &cam_crop,
+	ret = soc_camera_client_s_selection(sd, sel, &cam_sel,
 				       &cam->rect, &cam->subrect);
 	if (ret < 0)
 		return ret;
@@ -1341,13 +1340,12 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int sh_mobile_ceu_get_crop(struct soc_camera_device *icd,
-				  struct v4l2_crop *a)
+static int sh_mobile_ceu_get_selection(struct soc_camera_device *icd,
+				       struct v4l2_selection *sel)
 {
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 
-	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->c = cam->subrect;
+	sel->r = cam->subrect;
 
 	return 0;
 }
@@ -1585,8 +1583,8 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
-				      const struct v4l2_crop *a)
+static int sh_mobile_ceu_set_liveselection(struct soc_camera_device *icd,
+					   struct v4l2_selection *sel)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -1605,7 +1603,7 @@ static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
 			 "Client failed to stop the stream: %d\n", ret);
 	else
 		/* Do the crop, if it fails, there's nothing more we can do */
-		sh_mobile_ceu_set_crop(icd, a);
+		sh_mobile_ceu_set_selection(icd, sel);
 
 	dev_geo(icd->parent, "Output after crop: %ux%u\n", icd->user_width, icd->user_height);
 
@@ -1678,9 +1676,9 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.clock_stop	= sh_mobile_ceu_clock_stop,
 	.get_formats	= sh_mobile_ceu_get_formats,
 	.put_formats	= sh_mobile_ceu_put_formats,
-	.get_crop	= sh_mobile_ceu_get_crop,
-	.set_crop	= sh_mobile_ceu_set_crop,
-	.set_livecrop	= sh_mobile_ceu_set_livecrop,
+	.get_selection	= sh_mobile_ceu_get_selection,
+	.set_selection	= sh_mobile_ceu_set_selection,
+	.set_liveselection	= sh_mobile_ceu_set_liveselection,
 	.set_fmt	= sh_mobile_ceu_set_fmt,
 	.try_fmt	= sh_mobile_ceu_try_fmt,
 	.poll		= sh_mobile_ceu_poll,
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index fccfa45..bafaeaf 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -544,7 +544,7 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 	dev_dbg(icd->pdev, "S_FMT(%c%c%c%c, %ux%u)\n",
 		pixfmtstr(pix->pixelformat), pix->width, pix->height);
 
-	/* We always call try_fmt() before set_fmt() or set_crop() */
+	/* We always call try_fmt() before set_fmt() or set_selection() */
 	ret = soc_camera_try_fmt(icd, f);
 	if (ret < 0)
 		return ret;
@@ -1009,72 +1009,6 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	return 0;
 }
 
-static int soc_camera_cropcap(struct file *file, void *fh,
-			      struct v4l2_cropcap *a)
-{
-	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-
-	return ici->ops->cropcap(icd, a);
-}
-
-static int soc_camera_g_crop(struct file *file, void *fh,
-			     struct v4l2_crop *a)
-{
-	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	int ret;
-
-	ret = ici->ops->get_crop(icd, a);
-
-	return ret;
-}
-
-/*
- * According to the V4L2 API, drivers shall not update the struct v4l2_crop
- * argument with the actual geometry, instead, the user shall use G_CROP to
- * retrieve it.
- */
-static int soc_camera_s_crop(struct file *file, void *fh,
-			     const struct v4l2_crop *a)
-{
-	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	const struct v4l2_rect *rect = &a->c;
-	struct v4l2_crop current_crop;
-	int ret;
-
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	dev_dbg(icd->pdev, "S_CROP(%ux%u@%u:%u)\n",
-		rect->width, rect->height, rect->left, rect->top);
-
-	current_crop.type = a->type;
-
-	/* If get_crop fails, we'll let host and / or client drivers decide */
-	ret = ici->ops->get_crop(icd, &current_crop);
-
-	/* Prohibit window size change with initialised buffers */
-	if (ret < 0) {
-		dev_err(icd->pdev,
-			"S_CROP denied: getting current crop failed\n");
-	} else if ((a->c.width == current_crop.c.width &&
-		    a->c.height == current_crop.c.height) ||
-		   !is_streaming(ici, icd)) {
-		/* same size or not streaming - use .set_crop() */
-		ret = ici->ops->set_crop(icd, a);
-	} else if (ici->ops->set_livecrop) {
-		ret = ici->ops->set_livecrop(icd, a);
-	} else {
-		dev_err(icd->pdev,
-			"S_CROP denied: queue initialised and sizes differ\n");
-		ret = -EBUSY;
-	}
-
-	return ret;
-}
-
 static int soc_camera_g_selection(struct file *file, void *fh,
 				  struct v4l2_selection *s)
 {
@@ -1085,9 +1019,6 @@ static int soc_camera_g_selection(struct file *file, void *fh,
 	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	if (!ici->ops->get_selection)
-		return -ENOTTY;
-
 	return ici->ops->get_selection(icd, s);
 }
 
@@ -1119,10 +1050,11 @@ static int soc_camera_s_selection(struct file *file, void *fh,
 			return -EBUSY;
 	}
 
-	if (!ici->ops->set_selection)
-		return -ENOTTY;
-
-	ret = ici->ops->set_selection(icd, s);
+	if (s->target == V4L2_SEL_TGT_CROP && is_streaming(ici, icd) &&
+	    ici->ops->set_liveselection)
+		ret = ici->ops->set_liveselection(icd, s);
+	else
+		ret = ici->ops->set_selection(icd, s);
 	if (!ret &&
 	    s->target == V4L2_SEL_TGT_COMPOSE) {
 		icd->user_width = s->r.width;
@@ -1867,23 +1799,40 @@ static int soc_camera_remove(struct soc_camera_device *icd)
 	return 0;
 }
 
-static int default_cropcap(struct soc_camera_device *icd,
-			   struct v4l2_cropcap *a)
+static int default_g_selection(struct soc_camera_device *icd,
+			       struct v4l2_selection *sel)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	return v4l2_subdev_call(sd, video, cropcap, a);
-}
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = sel->target,
+	};
+	int ret;
 
-static int default_g_crop(struct soc_camera_device *icd, struct v4l2_crop *a)
-{
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	return v4l2_subdev_call(sd, video, g_crop, a);
+	ret = v4l2_subdev_call(sd, pad, get_selection, NULL, &sdsel);
+	if (ret)
+		return ret;
+	sel->r = sdsel.r;
+	return 0;
 }
 
-static int default_s_crop(struct soc_camera_device *icd, const struct v4l2_crop *a)
+static int default_s_selection(struct soc_camera_device *icd,
+			       struct v4l2_selection *sel)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	return v4l2_subdev_call(sd, video, s_crop, a);
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = sel->target,
+		.flags = sel->flags,
+		.r = sel->r,
+	};
+	int ret;
+
+	ret = v4l2_subdev_call(sd, pad, set_selection, NULL, &sdsel);
+	if (ret)
+		return ret;
+	sel->r = sdsel.r;
+	return 0;
 }
 
 static int default_g_parm(struct soc_camera_device *icd,
@@ -1956,12 +1905,10 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	    !ici->v4l2_dev.dev)
 		return -EINVAL;
 
-	if (!ici->ops->set_crop)
-		ici->ops->set_crop = default_s_crop;
-	if (!ici->ops->get_crop)
-		ici->ops->get_crop = default_g_crop;
-	if (!ici->ops->cropcap)
-		ici->ops->cropcap = default_cropcap;
+	if (!ici->ops->set_selection)
+		ici->ops->set_selection = default_s_selection;
+	if (!ici->ops->get_selection)
+		ici->ops->get_selection = default_g_selection;
 	if (!ici->ops->set_parm)
 		ici->ops->set_parm = default_s_parm;
 	if (!ici->ops->get_parm)
@@ -2114,9 +2061,6 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_expbuf		 = soc_camera_expbuf,
 	.vidioc_streamon	 = soc_camera_streamon,
 	.vidioc_streamoff	 = soc_camera_streamoff,
-	.vidioc_cropcap		 = soc_camera_cropcap,
-	.vidioc_g_crop		 = soc_camera_g_crop,
-	.vidioc_s_crop		 = soc_camera_s_crop,
 	.vidioc_g_selection	 = soc_camera_g_selection,
 	.vidioc_s_selection	 = soc_camera_s_selection,
 	.vidioc_g_parm		 = soc_camera_g_parm,
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index f2ce1ab..f64b546 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -73,35 +73,27 @@ static int soc_camera_platform_enum_fmt(struct v4l2_subdev *sd, unsigned int ind
 	return 0;
 }
 
-static int soc_camera_platform_g_crop(struct v4l2_subdev *sd,
-				      struct v4l2_crop *a)
+static int soc_camera_platform_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
 
-	a->c.left	= 0;
-	a->c.top	= 0;
-	a->c.width	= p->format.width;
-	a->c.height	= p->format.height;
-	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	return 0;
-}
-
-static int soc_camera_platform_cropcap(struct v4l2_subdev *sd,
-				       struct v4l2_cropcap *a)
-{
-	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
-
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
-	a->bounds.width			= p->format.width;
-	a->bounds.height		= p->format.height;
-	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
 
-	return 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = p->format.width;
+		sel->r.height = p->format.height;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int soc_camera_platform_g_mbus_config(struct v4l2_subdev *sd,
@@ -118,17 +110,20 @@ static int soc_camera_platform_g_mbus_config(struct v4l2_subdev *sd,
 static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
 	.s_stream	= soc_camera_platform_s_stream,
 	.enum_mbus_fmt	= soc_camera_platform_enum_fmt,
-	.cropcap	= soc_camera_platform_cropcap,
-	.g_crop		= soc_camera_platform_g_crop,
 	.try_mbus_fmt	= soc_camera_platform_fill_fmt,
 	.g_mbus_fmt	= soc_camera_platform_fill_fmt,
 	.s_mbus_fmt	= soc_camera_platform_fill_fmt,
 	.g_mbus_config	= soc_camera_platform_g_mbus_config,
 };
 
+static struct v4l2_subdev_pad_ops platform_subdev_pad_ops = {
+	.get_selection	= soc_camera_platform_get_selection,
+};
+
 static struct v4l2_subdev_ops platform_subdev_ops = {
 	.core	= &platform_subdev_core_ops,
 	.video	= &platform_subdev_video_ops,
+	.pad	= &platform_subdev_pad_ops,
 };
 
 static int soc_camera_platform_probe(struct platform_device *pdev)
diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index 8e74fb7..fd1c8e4 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -40,24 +40,22 @@ static bool is_inside(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
 /* Get and store current client crop */
 int soc_camera_client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
 {
-	struct v4l2_crop crop;
-	struct v4l2_cropcap cap;
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = V4L2_SEL_TGT_CROP,
+	};
 	int ret;
 
-	crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = v4l2_subdev_call(sd, video, g_crop, &crop);
+	ret = v4l2_subdev_call(sd, pad, get_selection, NULL, &sdsel);
 	if (!ret) {
-		*rect = crop.c;
+		*rect = sdsel.r;
 		return ret;
 	}
 
-	/* Camera driver doesn't support .g_crop(), assume default rectangle */
-	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
+	sdsel.target = V4L2_SEL_TGT_CROP_DEFAULT;
+	ret = v4l2_subdev_call(sd, pad, get_selection, NULL, &sdsel);
 	if (!ret)
-		*rect = cap.defrect;
+		*rect = sdsel.r;
 
 	return ret;
 }
@@ -93,17 +91,27 @@ static void update_subrect(struct v4l2_rect *rect, struct v4l2_rect *subrect)
  * 2. if (1) failed, try to double the client image until we get one big enough
  * 3. if (2) failed, try to request the maximum image
  */
-int soc_camera_client_s_crop(struct v4l2_subdev *sd,
-			struct v4l2_crop *crop, struct v4l2_crop *cam_crop,
+int soc_camera_client_s_selection(struct v4l2_subdev *sd,
+			struct v4l2_selection *sel, struct v4l2_selection *cam_sel,
 			struct v4l2_rect *target_rect, struct v4l2_rect *subrect)
 {
-	struct v4l2_rect *rect = &crop->c, *cam_rect = &cam_crop->c;
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = sel->target,
+		.flags = sel->flags,
+		.r = sel->r,
+	};
+	struct v4l2_subdev_selection bounds = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = V4L2_SEL_TGT_CROP_BOUNDS,
+	};
+	struct v4l2_rect *rect = &sel->r, *cam_rect = &cam_sel->r;
 	struct device *dev = sd->v4l2_dev->dev;
-	struct v4l2_cropcap cap;
 	int ret;
 	unsigned int width, height;
 
-	v4l2_subdev_call(sd, video, s_crop, crop);
+	v4l2_subdev_call(sd, pad, set_selection, NULL, &sdsel);
+	sel->r = sdsel.r;
 	ret = soc_camera_client_g_rect(sd, cam_rect);
 	if (ret < 0)
 		return ret;
@@ -127,15 +135,15 @@ int soc_camera_client_s_crop(struct v4l2_subdev *sd,
 		rect->width, rect->height, rect->left, rect->top);
 
 	/* We need sensor maximum rectangle */
-	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
+	ret = v4l2_subdev_call(sd, pad, get_selection, NULL, &bounds);
 	if (ret < 0)
 		return ret;
 
 	/* Put user requested rectangle within sensor bounds */
-	soc_camera_limit_side(&rect->left, &rect->width, cap.bounds.left, 2,
-			      cap.bounds.width);
-	soc_camera_limit_side(&rect->top, &rect->height, cap.bounds.top, 4,
-			      cap.bounds.height);
+	soc_camera_limit_side(&rect->left, &rect->width, sdsel.r.left, 2,
+			      bounds.r.width);
+	soc_camera_limit_side(&rect->top, &rect->height, sdsel.r.top, 4,
+			      bounds.r.height);
 
 	/*
 	 * Popular special case - some cameras can only handle fixed sizes like
@@ -150,7 +158,7 @@ int soc_camera_client_s_crop(struct v4l2_subdev *sd,
 	 */
 	while (!ret && (is_smaller(cam_rect, rect) ||
 			is_inside(cam_rect, rect)) &&
-	       (cap.bounds.width > width || cap.bounds.height > height)) {
+	       (bounds.r.width > width || bounds.r.height > height)) {
 
 		width *= 2;
 		height *= 2;
@@ -168,20 +176,22 @@ int soc_camera_client_s_crop(struct v4l2_subdev *sd,
 		 * Instead we just drop to the left and top bounds.
 		 */
 		if (cam_rect->left > rect->left)
-			cam_rect->left = cap.bounds.left;
+			cam_rect->left = bounds.r.left;
 
 		if (cam_rect->left + cam_rect->width < rect->left + rect->width)
 			cam_rect->width = rect->left + rect->width -
 				cam_rect->left;
 
 		if (cam_rect->top > rect->top)
-			cam_rect->top = cap.bounds.top;
+			cam_rect->top = bounds.r.top;
 
 		if (cam_rect->top + cam_rect->height < rect->top + rect->height)
 			cam_rect->height = rect->top + rect->height -
 				cam_rect->top;
 
-		v4l2_subdev_call(sd, video, s_crop, cam_crop);
+		sdsel.r = *cam_rect;
+		v4l2_subdev_call(sd, pad, set_selection, NULL, &sdsel);
+		*cam_rect = sdsel.r;
 		ret = soc_camera_client_g_rect(sd, cam_rect);
 		dev_geo(dev, "Camera S_CROP %d for %dx%d@%d:%d\n", ret,
 			cam_rect->width, cam_rect->height,
@@ -194,8 +204,10 @@ int soc_camera_client_s_crop(struct v4l2_subdev *sd,
 		 * The camera failed to configure a suitable cropping,
 		 * we cannot use the current rectangle, set to max
 		 */
-		*cam_rect = cap.bounds;
-		v4l2_subdev_call(sd, video, s_crop, cam_crop);
+		sdsel.r = bounds.r;
+		v4l2_subdev_call(sd, pad, set_selection, NULL, &sdsel);
+		*cam_rect = sdsel.r;
+
 		ret = soc_camera_client_g_rect(sd, cam_rect);
 		dev_geo(dev, "Camera S_CROP %d for max %dx%d@%d:%d\n", ret,
 			cam_rect->width, cam_rect->height,
@@ -209,7 +221,7 @@ int soc_camera_client_s_crop(struct v4l2_subdev *sd,
 
 	return ret;
 }
-EXPORT_SYMBOL(soc_camera_client_s_crop);
+EXPORT_SYMBOL(soc_camera_client_s_selection);
 
 /* Iterative s_mbus_fmt, also updates cached client crop on success */
 static int client_s_fmt(struct soc_camera_device *icd,
@@ -220,7 +232,10 @@ static int client_s_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
 	unsigned int width = mf->width, height = mf->height, tmp_w, tmp_h;
-	struct v4l2_cropcap cap;
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = V4L2_SEL_TGT_CROP_BOUNDS,
+	};
 	bool host_1to1;
 	int ret;
 
@@ -242,16 +257,14 @@ static int client_s_fmt(struct soc_camera_device *icd,
 	if (!host_can_scale)
 		goto update_cache;
 
-	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
+	ret = v4l2_subdev_call(sd, pad, get_selection, NULL, &sdsel);
 	if (ret < 0)
 		return ret;
 
-	if (max_width > cap.bounds.width)
-		max_width = cap.bounds.width;
-	if (max_height > cap.bounds.height)
-		max_height = cap.bounds.height;
+	if (max_width > sdsel.r.width)
+		max_width = sdsel.r.width;
+	if (max_height > sdsel.r.height)
+		max_height = sdsel.r.height;
 
 	/* Camera set a format, but geometry is not precise, try to improve */
 	tmp_w = mf->width;
diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.h b/drivers/media/platform/soc_camera/soc_scale_crop.h
index 184a30d..9ca4693 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.h
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.h
@@ -16,7 +16,7 @@
 
 struct soc_camera_device;
 
-struct v4l2_crop;
+struct v4l2_selection;
 struct v4l2_mbus_framefmt;
 struct v4l2_pix_format;
 struct v4l2_rect;
@@ -31,8 +31,8 @@ static inline unsigned int soc_camera_shift_scale(unsigned int size,
 #define soc_camera_calc_scale(in, shift, out) soc_camera_shift_scale(in, shift, out)
 
 int soc_camera_client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect);
-int soc_camera_client_s_crop(struct v4l2_subdev *sd,
-			struct v4l2_crop *crop, struct v4l2_crop *cam_crop,
+int soc_camera_client_s_selection(struct v4l2_subdev *sd,
+			struct v4l2_selection *sel, struct v4l2_selection *cam_sel,
 			struct v4l2_rect *target_rect, struct v4l2_rect *subrect);
 int soc_camera_client_scale(struct soc_camera_device *icd,
 			struct v4l2_rect *rect, struct v4l2_rect *subrect,
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index cdee596..65dd272 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -643,40 +643,45 @@ iss_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
 }
 
 static int
-iss_video_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropcap)
-{
-	struct iss_video *video = video_drvdata(file);
-	struct v4l2_subdev *subdev;
-	int ret;
-
-	subdev = iss_video_remote_subdev(video, NULL);
-	if (subdev == NULL)
-		return -EINVAL;
-
-	mutex_lock(&video->mutex);
-	ret = v4l2_subdev_call(subdev, video, cropcap, cropcap);
-	mutex_unlock(&video->mutex);
-
-	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
-}
-
-static int
-iss_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+iss_video_get_selection(struct file *file, void *fh, struct v4l2_selection *sel)
 {
 	struct iss_video *video = video_drvdata(file);
 	struct v4l2_subdev_format format;
 	struct v4l2_subdev *subdev;
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = sel->target,
+	};
 	u32 pad;
 	int ret;
 
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			return -EINVAL;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
 	subdev = iss_video_remote_subdev(video, &pad);
 	if (subdev == NULL)
 		return -EINVAL;
 
-	/* Try the get crop operation first and fallback to get format if not
+	/* Try the get selection operation first and fallback to get format if not
 	 * implemented.
 	 */
-	ret = v4l2_subdev_call(subdev, video, g_crop, crop);
+	sdsel.pad = pad;
+	ret = v4l2_subdev_call(subdev, pad, get_selection, NULL, &sdsel);
+	if (!ret)
+		sel->r = sdsel.r;
 	if (ret != -ENOIOCTLCMD)
 		return ret;
 
@@ -686,28 +691,50 @@ iss_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
 	if (ret < 0)
 		return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
 
-	crop->c.left = 0;
-	crop->c.top = 0;
-	crop->c.width = format.format.width;
-	crop->c.height = format.format.height;
+	sel->r.left = 0;
+	sel->r.top = 0;
+	sel->r.width = format.format.width;
+	sel->r.height = format.format.height;
 
 	return 0;
 }
 
 static int
-iss_video_set_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
+iss_video_set_selection(struct file *file, void *fh, struct v4l2_selection *sel)
 {
 	struct iss_video *video = video_drvdata(file);
 	struct v4l2_subdev *subdev;
+	struct v4l2_subdev_selection sdsel = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.target = sel->target,
+		.flags = sel->flags,
+		.r = sel->r,
+	};
+	u32 pad;
 	int ret;
 
-	subdev = iss_video_remote_subdev(video, NULL);
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			return -EINVAL;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+	subdev = iss_video_remote_subdev(video, &pad);
 	if (subdev == NULL)
 		return -EINVAL;
 
+	sdsel.pad = pad;
 	mutex_lock(&video->mutex);
-	ret = v4l2_subdev_call(subdev, video, s_crop, crop);
+	ret = v4l2_subdev_call(subdev, pad, set_selection, NULL, &sdsel);
 	mutex_unlock(&video->mutex);
+	if (!ret)
+		sel->r = sdsel.r;
 
 	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
 }
@@ -1013,9 +1040,8 @@ static const struct v4l2_ioctl_ops iss_video_ioctl_ops = {
 	.vidioc_g_fmt_vid_out		= iss_video_get_format,
 	.vidioc_s_fmt_vid_out		= iss_video_set_format,
 	.vidioc_try_fmt_vid_out		= iss_video_try_format,
-	.vidioc_cropcap			= iss_video_cropcap,
-	.vidioc_g_crop			= iss_video_get_crop,
-	.vidioc_s_crop			= iss_video_set_crop,
+	.vidioc_g_selection		= iss_video_get_selection,
+	.vidioc_s_selection		= iss_video_set_selection,
 	.vidioc_g_parm			= iss_video_get_param,
 	.vidioc_s_parm			= iss_video_set_param,
 	.vidioc_reqbufs			= iss_video_reqbufs,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 2f6261f..1c2f51a 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -105,16 +105,13 @@ struct soc_camera_host_ops {
 	int (*get_formats)(struct soc_camera_device *, unsigned int,
 			   struct soc_camera_format_xlate *);
 	void (*put_formats)(struct soc_camera_device *);
-	int (*cropcap)(struct soc_camera_device *, struct v4l2_cropcap *);
-	int (*get_crop)(struct soc_camera_device *, struct v4l2_crop *);
-	int (*set_crop)(struct soc_camera_device *, const struct v4l2_crop *);
 	int (*get_selection)(struct soc_camera_device *, struct v4l2_selection *);
 	int (*set_selection)(struct soc_camera_device *, struct v4l2_selection *);
 	/*
-	 * The difference to .set_crop() is, that .set_livecrop is not allowed
+	 * The difference to .set_selection() is, that .set_liveselection is not allowed
 	 * to change the output sizes
 	 */
-	int (*set_livecrop)(struct soc_camera_device *, const struct v4l2_crop *);
+	int (*set_liveselection)(struct soc_camera_device *, struct v4l2_selection *);
 	int (*set_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	void (*init_videobuf)(struct videobuf_queue *,
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 7ac6273..b7f7426 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -323,9 +323,6 @@ struct v4l2_subdev_video_ops {
 	int (*g_tvnorms_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*g_input_status)(struct v4l2_subdev *sd, u32 *status);
 	int (*s_stream)(struct v4l2_subdev *sd, int enable);
-	int (*cropcap)(struct v4l2_subdev *sd, struct v4l2_cropcap *cc);
-	int (*g_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
-	int (*s_crop)(struct v4l2_subdev *sd, const struct v4l2_crop *crop);
 	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*g_frame_interval)(struct v4l2_subdev *sd,
-- 
2.1.3

