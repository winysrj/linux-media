Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:64517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab1G2K5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:04 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id DC020189B6E
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007o5-N5
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 23/59] V4L: tw9910: remove a not really implemented cropping support
Date: Fri, 29 Jul 2011 12:56:23 +0200
Message-Id: <1311937019-29914-24-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cropping is not really correctly implemented by this driver and only
needlessly obfuscates the code. Remove it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/tw9910.c |  129 +++++++++++++++---------------------------
 1 files changed, 46 insertions(+), 83 deletions(-)

diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 742482e..686512e 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -203,6 +203,10 @@
 #define RTSEL_FIELD 0x06 /* 0110 = FIELD */
 #define RTSEL_RTCO  0x07 /* 0111 = RTCO ( Real Time Control ) */
 
+/* HSYNC start and end are constant for now */
+#define HSYNC_START	0x0260
+#define HSYNC_END	0x0300
+
 /*
  * structure
  */
@@ -220,18 +224,6 @@ struct tw9910_scale_ctrl {
 	u16             vscale;
 };
 
-struct tw9910_cropping_ctrl {
-	u16 vdelay;
-	u16 vactive;
-	u16 hdelay;
-	u16 hactive;
-};
-
-struct tw9910_hsync_ctrl {
-	u16 start;
-	u16 end;
-};
-
 struct tw9910_priv {
 	struct v4l2_subdev		subdev;
 	struct tw9910_video_info	*info;
@@ -329,11 +321,6 @@ static const struct tw9910_scale_ctrl tw9910_pal_scales[] = {
 	},
 };
 
-static const struct tw9910_hsync_ctrl tw9910_hsync_ctrl = {
-	.start = 0x0260,
-	.end   = 0x0300,
-};
-
 /*
  * general function
  */
@@ -378,21 +365,20 @@ static int tw9910_set_scale(struct i2c_client *client,
 	return ret;
 }
 
-static int tw9910_set_hsync(struct i2c_client *client,
-			    const struct tw9910_hsync_ctrl *hsync)
+static int tw9910_set_hsync(struct i2c_client *client)
 {
 	struct tw9910_priv *priv = to_tw9910(client);
 	int ret;
 
 	/* bit 10 - 3 */
 	ret = i2c_smbus_write_byte_data(client, HSBEGIN,
-					(hsync->start & 0x07F8) >> 3);
+					(HSYNC_START & 0x07F8) >> 3);
 	if (ret < 0)
 		return ret;
 
 	/* bit 10 - 3 */
 	ret = i2c_smbus_write_byte_data(client, HSEND,
-					(hsync->end & 0x07F8) >> 3);
+					(HSYNC_END & 0x07F8) >> 3);
 	if (ret < 0)
 		return ret;
 
@@ -400,8 +386,8 @@ static int tw9910_set_hsync(struct i2c_client *client,
 	/* bit 2 - 0 */
 	if (1 == priv->revision)
 		ret = tw9910_mask_set(client, HSLOWCTL, 0x77,
-				      (hsync->start & 0x0007) << 4 |
-				      (hsync->end   & 0x0007));
+				      (HSYNC_START & 0x0007) << 4 |
+				      (HSYNC_END   & 0x0007));
 
 	return ret;
 }
@@ -433,8 +419,8 @@ static int tw9910_power(struct i2c_client *client, int enable)
 	return tw9910_mask_set(client, ACNTL2, ACNTL2_PDN_MASK, acntl2);
 }
 
-static const struct tw9910_scale_ctrl*
-tw9910_select_norm(struct soc_camera_device *icd, u32 width, u32 height)
+static const struct tw9910_scale_ctrl *tw9910_select_norm(struct soc_camera_device *icd,
+							  u32 width, u32 height)
 {
 	const struct tw9910_scale_ctrl *scale;
 	const struct tw9910_scale_ctrl *ret = NULL;
@@ -510,10 +496,13 @@ static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
 static int tw9910_set_bus_param(struct soc_camera_device *icd,
 				unsigned long flags)
 {
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	u8 val = VSSL_VVALID | HSSL_DVALID;
 
+	flags = soc_camera_apply_sensor_flags(icl, flags);
+
 	/*
 	 * set OUTCTR1
 	 *
@@ -600,19 +589,18 @@ static int tw9910_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static int tw9910_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
 {
-	struct v4l2_rect *rect = &a->c;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
-	int                 ret  = -EINVAL;
-	u8                  val;
+	int ret = -EINVAL;
+	u8 val;
 
 	/*
 	 * select suitable norm
 	 */
-	priv->scale = tw9910_select_norm(icd, rect->width, rect->height);
+	priv->scale = tw9910_select_norm(icd, *width, *height);
 	if (!priv->scale)
 		goto tw9910_set_fmt_error;
 
@@ -670,14 +658,12 @@ static int tw9910_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	/*
 	 * set hsync
 	 */
-	ret = tw9910_set_hsync(client, &tw9910_hsync_ctrl);
+	ret = tw9910_set_hsync(client);
 	if (ret < 0)
 		goto tw9910_set_fmt_error;
 
-	rect->width = priv->scale->width;
-	rect->height = priv->scale->height;
-	rect->left = 0;
-	rect->top = 0;
+	*width = priv->scale->width;
+	*height = priv->scale->height;
 
 	return ret;
 
@@ -692,27 +678,17 @@ tw9910_set_fmt_error:
 static int tw9910_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct tw9910_priv *priv = to_tw9910(client);
-
-	if (!priv->scale) {
-		int ret;
-		struct v4l2_crop crop = {
-			.c = {
-				.left	= 0,
-				.top	= 0,
-				.width	= 640,
-				.height	= 480,
-			},
-		};
-		ret = tw9910_s_crop(sd, &crop);
-		if (ret < 0)
-			return ret;
-	}
+	struct soc_camera_device *icd = client->dev.platform_data;
 
 	a->c.left	= 0;
 	a->c.top	= 0;
-	a->c.width	= priv->scale->width;
-	a->c.height	= priv->scale->height;
+	if (icd->vdev->current_norm & V4L2_STD_NTSC) {
+		a->c.width	= 640;
+		a->c.height	= 480;
+	} else {
+		a->c.width	= 768;
+		a->c.height	= 576;
+	}
 	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	return 0;
@@ -720,14 +696,19 @@ static int tw9910_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 
 static int tw9910_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+
 	a->bounds.left			= 0;
 	a->bounds.top			= 0;
-	a->bounds.width			= 768;
-	a->bounds.height		= 576;
-	a->defrect.left			= 0;
-	a->defrect.top			= 0;
-	a->defrect.width		= 640;
-	a->defrect.height		= 480;
+	if (icd->vdev->current_norm & V4L2_STD_NTSC) {
+		a->bounds.width		= 640;
+		a->bounds.height	= 480;
+	} else {
+		a->bounds.width		= 768;
+		a->bounds.height	= 576;
+	}
+	a->defrect			= a->bounds;
 	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	a->pixelaspect.numerator	= 1;
 	a->pixelaspect.denominator	= 1;
@@ -743,15 +724,8 @@ static int tw9910_g_fmt(struct v4l2_subdev *sd,
 
 	if (!priv->scale) {
 		int ret;
-		struct v4l2_crop crop = {
-			.c = {
-				.left	= 0,
-				.top	= 0,
-				.width	= 640,
-				.height	= 480,
-			},
-		};
-		ret = tw9910_s_crop(sd, &crop);
+		u32 width = 640, height = 480;
+		ret = tw9910_set_frame(sd, &width, &height);
 		if (ret < 0)
 			return ret;
 	}
@@ -768,17 +742,7 @@ static int tw9910_g_fmt(struct v4l2_subdev *sd,
 static int tw9910_s_fmt(struct v4l2_subdev *sd,
 			struct v4l2_mbus_framefmt *mf)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct tw9910_priv *priv = to_tw9910(client);
-	/* See tw9910_s_crop() - no proper cropping support */
-	struct v4l2_crop a = {
-		.c = {
-			.left	= 0,
-			.top	= 0,
-			.width	= mf->width,
-			.height	= mf->height,
-		},
-	};
+	u32 width = mf->width, height = mf->height;
 	int ret;
 
 	WARN_ON(mf->field != V4L2_FIELD_ANY &&
@@ -792,10 +756,10 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
 
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
 
-	ret = tw9910_s_crop(sd, &a);
+	ret = tw9910_set_frame(sd, &width, &height);
 	if (!ret) {
-		mf->width	= priv->scale->width;
-		mf->height	= priv->scale->height;
+		mf->width	= width;
+		mf->height	= height;
 	}
 	return ret;
 }
@@ -905,7 +869,6 @@ static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.try_mbus_fmt	= tw9910_try_fmt,
 	.cropcap	= tw9910_cropcap,
 	.g_crop		= tw9910_g_crop,
-	.s_crop		= tw9910_s_crop,
 	.enum_mbus_fmt	= tw9910_enum_fmt,
 };
 
-- 
1.7.2.5

