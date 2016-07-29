Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:41710 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbcG2Rkg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2016 13:40:36 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 2/6] media: rcar-vin: fix bug in scaling
Date: Fri, 29 Jul 2016 19:40:08 +0200
Message-Id: <20160729174012.14331-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was not possible to scale beyond the image size of the video source
limitation. The output frame would be bigger but the captured image was
limited to the size of the video source.

The error was that the crop boundary was set after the requested frame
size and not the video source size. This patch breaks out the resetting
of the crop, compose and format to separate functions so the error wont
creep back.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 105 ++++++++++++++--------------
 1 file changed, 54 insertions(+), 51 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 346339f..b8c3836 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -92,6 +92,54 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
  * V4L2
  */
 
+static void rvin_reset_crop_compose(struct rvin_dev *vin)
+{
+	vin->crop.top = vin->crop.left = 0;
+	vin->crop.width = vin->source.width;
+	vin->crop.height = vin->source.height;
+
+	vin->compose.top = vin->compose.left = 0;
+	vin->compose.width = vin->format.width;
+	vin->compose.height = vin->format.height;
+}
+
+static int rvin_reset_format(struct rvin_dev *vin)
+{
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	int ret;
+
+	fmt.pad = vin->src_pad_idx;
+
+	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
+	if (ret)
+		return ret;
+
+	vin->format.width	= mf->width;
+	vin->format.height	= mf->height;
+	vin->format.colorspace	= mf->colorspace;
+	vin->format.field	= mf->field;
+
+	switch (vin->format.field) {
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_NONE:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_INTERLACED:
+		break;
+	default:
+		vin->format.field = V4L2_FIELD_NONE;
+		break;
+	}
+
+	rvin_reset_crop_compose(vin);
+
+	return 0;
+}
+
 static int __rvin_try_format_source(struct rvin_dev *vin,
 					u32 which,
 					struct v4l2_pix_format *pix,
@@ -247,6 +295,8 @@ static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
 
 	vin->format = f->fmt.pix;
 
+	rvin_reset_crop_compose(vin);
+
 	return 0;
 }
 
@@ -438,35 +488,14 @@ static int rvin_querystd(struct file *file, void *priv, v4l2_std_id *a)
 static int rvin_s_std(struct file *file, void *priv, v4l2_std_id a)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
-	struct v4l2_subdev_format fmt = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct v4l2_mbus_framefmt *mf = &fmt.format;
-	int ret = v4l2_subdev_call(sd, video, s_std, a);
+	int ret;
 
+	ret = v4l2_subdev_call(vin_to_source(vin), video, s_std, a);
 	if (ret < 0)
 		return ret;
 
 	/* Changing the standard will change the width/height */
-	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
-	if (ret) {
-		vin_err(vin, "Failed to get initial format\n");
-		return ret;
-	}
-
-	vin->format.width = mf->width;
-	vin->format.height = mf->height;
-
-	vin->crop.top = vin->crop.left = 0;
-	vin->crop.width = mf->width;
-	vin->crop.height = mf->height;
-
-	vin->compose.top = vin->compose.left = 0;
-	vin->compose.width = mf->width;
-	vin->compose.height = mf->height;
-
-	return 0;
+	return rvin_reset_format(vin);
 }
 
 static int rvin_g_std(struct file *file, void *priv, v4l2_std_id *a)
@@ -772,10 +801,6 @@ static void rvin_notify(struct v4l2_subdev *sd,
 
 int rvin_v4l2_probe(struct rvin_dev *vin)
 {
-	struct v4l2_subdev_format fmt = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	struct video_device *vdev = &vin->vdev;
 	struct v4l2_subdev *sd = vin_to_source(vin);
 #if defined(CONFIG_MEDIA_CONTROLLER)
@@ -838,31 +863,9 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 
 	vin->src_pad_idx = pad_idx;
 #endif
-	fmt.pad = vin->src_pad_idx;
-
-	/* Try to improve our guess of a reasonable window format */
-	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
-	if (ret) {
-		vin_err(vin, "Failed to get initial format\n");
-		return ret;
-	}
 
-	/* Set default format */
-	vin->format.width	= mf->width;
-	vin->format.height	= mf->height;
-	vin->format.colorspace	= mf->colorspace;
-	vin->format.field	= mf->field;
 	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
-
-
-	/* Set initial crop and compose */
-	vin->crop.top = vin->crop.left = 0;
-	vin->crop.width = mf->width;
-	vin->crop.height = mf->height;
-
-	vin->compose.top = vin->compose.left = 0;
-	vin->compose.width = mf->width;
-	vin->compose.height = mf->height;
+	rvin_reset_format(vin);
 
 	ret = video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret) {
-- 
2.9.0

