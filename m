Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:16097 "EHLO
        bin-vsp-out-03.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751522AbeA2QfX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 11:35:23 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v10 09/30] rcar-vin: read subdevice format for crop only when needed
Date: Mon, 29 Jan 2018 17:34:14 +0100
Message-Id: <20180129163435.24936-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of caching the subdevice format each time the video device
format is set read it directly when it's needed. As it turns out the
format is only needed when figuring out the max rectangle for cropping.

This simplifies the code and makes it clearer what the source format is
used for.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 112 +++++++++++++++-------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  12 ---
 2 files changed, 61 insertions(+), 63 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index c2265324c7c96308..4d5be2d0c79c9c9a 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -90,35 +90,54 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
  * V4L2
  */
 
-static void rvin_reset_crop_compose(struct rvin_dev *vin)
+static int rvin_get_source_format(struct rvin_dev *vin,
+				  struct v4l2_mbus_framefmt *mbus_fmt)
 {
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.pad = vin->digital->source_pad,
+	};
+	int ret;
+
+	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
+	if (ret)
+		return ret;
+
+	memcpy(mbus_fmt, &fmt.format, sizeof(*mbus_fmt));
+
+	return 0;
+}
+
+static int rvin_reset_crop_compose(struct rvin_dev *vin)
+{
+	struct v4l2_mbus_framefmt source_fmt;
+	int ret;
+
+	ret = rvin_get_source_format(vin, &source_fmt);
+	if (ret)
+		return ret;
+
 	vin->crop.top = vin->crop.left = 0;
-	vin->crop.width = vin->source.width;
-	vin->crop.height = vin->source.height;
+	vin->crop.width = source_fmt.width;
+	vin->crop.height = source_fmt.height;
 
 	vin->compose.top = vin->compose.left = 0;
 	vin->compose.width = vin->format.width;
 	vin->compose.height = vin->format.height;
+
+	return 0;
 }
 
 static int rvin_reset_format(struct rvin_dev *vin)
 {
-	struct v4l2_subdev_format fmt = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	struct v4l2_mbus_framefmt source_fmt;
 	int ret;
 
-	fmt.pad = vin->digital->source_pad;
-
-	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
+	ret = rvin_get_source_format(vin, &source_fmt);
 	if (ret)
 		return ret;
 
-	vin->format.width	= mf->width;
-	vin->format.height	= mf->height;
-	vin->format.colorspace	= mf->colorspace;
-	vin->format.field	= mf->field;
+	v4l2_fill_pix_format(&vin->format, &source_fmt);
 
 	/*
 	 * If the subdevice uses ALTERNATE field mode and G_STD is
@@ -147,7 +166,9 @@ static int rvin_reset_format(struct rvin_dev *vin)
 		break;
 	}
 
-	rvin_reset_crop_compose(vin);
+	ret = rvin_reset_crop_compose(vin);
+	if (ret)
+		return ret;
 
 	vin->format.bytesperline = rvin_format_bytesperline(&vin->format);
 	vin->format.sizeimage = rvin_format_sizeimage(&vin->format);
@@ -156,9 +177,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
 }
 
 static int __rvin_try_format_source(struct rvin_dev *vin,
-				    u32 which,
-				    struct v4l2_pix_format *pix,
-				    struct rvin_source_fmt *source)
+				    u32 which, struct v4l2_pix_format *pix)
 {
 	struct v4l2_subdev *sd;
 	struct v4l2_subdev_pad_config *pad_cfg;
@@ -190,25 +209,16 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	v4l2_fill_pix_format(pix, &format.format);
 
-	source->width = pix->width;
-	source->height = pix->height;
-
 	pix->field = field;
 	pix->width = width;
 	pix->height = height;
-
-	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
-		source->height);
-
 done:
 	v4l2_subdev_free_pad_config(pad_cfg);
 	return ret;
 }
 
 static int __rvin_try_format(struct rvin_dev *vin,
-			     u32 which,
-			     struct v4l2_pix_format *pix,
-			     struct rvin_source_fmt *source)
+			     u32 which, struct v4l2_pix_format *pix)
 {
 	u32 walign;
 	int ret;
@@ -229,7 +239,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	pix->sizeimage = 0;
 
 	/* Limit to source capabilities */
-	ret = __rvin_try_format_source(vin, which, pix, source);
+	ret = __rvin_try_format_source(vin, which, pix);
 	if (ret)
 		return ret;
 
@@ -238,7 +248,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	case V4L2_FIELD_BOTTOM:
 	case V4L2_FIELD_ALTERNATE:
 		pix->height /= 2;
-		source->height /= 2;
 		break;
 	case V4L2_FIELD_NONE:
 	case V4L2_FIELD_INTERLACED_TB:
@@ -290,35 +299,26 @@ static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct rvin_source_fmt source;
 
-	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
-				 &source);
+	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix);
 }
 
 static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
 			      struct v4l2_format *f)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct rvin_source_fmt source;
 	int ret;
 
 	if (vb2_is_busy(&vin->queue))
 		return -EBUSY;
 
-	ret = __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
-				&source);
+	ret = __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix);
 	if (ret)
 		return ret;
 
-	vin->source.width = source.width;
-	vin->source.height = source.height;
-
 	vin->format = f->fmt.pix;
 
-	rvin_reset_crop_compose(vin);
-
-	return 0;
+	return rvin_reset_crop_compose(vin);
 }
 
 static int rvin_g_fmt_vid_cap(struct file *file, void *priv,
@@ -346,6 +346,8 @@ static int rvin_g_selection(struct file *file, void *fh,
 			    struct v4l2_selection *s)
 {
 	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_mbus_framefmt source_fmt;
+	int ret;
 
 	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -353,9 +355,12 @@ static int rvin_g_selection(struct file *file, void *fh,
 	switch (s->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
 	case V4L2_SEL_TGT_CROP_DEFAULT:
+		ret = rvin_get_source_format(vin, &source_fmt);
+		if (ret)
+			return ret;
 		s->r.left = s->r.top = 0;
-		s->r.width = vin->source.width;
-		s->r.height = vin->source.height;
+		s->r.width = source_fmt.width;
+		s->r.height = source_fmt.height;
 		break;
 	case V4L2_SEL_TGT_CROP:
 		s->r = vin->crop;
@@ -380,6 +385,7 @@ static int rvin_s_selection(struct file *file, void *fh,
 			    struct v4l2_selection *s)
 {
 	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_mbus_framefmt source_fmt;
 	const struct rvin_video_format *fmt;
 	struct v4l2_rect r = s->r;
 	struct v4l2_rect max_rect;
@@ -387,6 +393,7 @@ static int rvin_s_selection(struct file *file, void *fh,
 		.width = 6,
 		.height = 2,
 	};
+	int ret;
 
 	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -396,22 +403,25 @@ static int rvin_s_selection(struct file *file, void *fh,
 	switch (s->target) {
 	case V4L2_SEL_TGT_CROP:
 		/* Can't crop outside of source input */
+		ret = rvin_get_source_format(vin, &source_fmt);
+		if (ret)
+			return ret;
 		max_rect.top = max_rect.left = 0;
-		max_rect.width = vin->source.width;
-		max_rect.height = vin->source.height;
+		max_rect.width = source_fmt.width;
+		max_rect.height = source_fmt.height;
 		v4l2_rect_map_inside(&r, &max_rect);
 
-		v4l_bound_align_image(&r.width, 2, vin->source.width, 1,
-				      &r.height, 4, vin->source.height, 2, 0);
+		v4l_bound_align_image(&r.width, 2, source_fmt.width, 1,
+				      &r.height, 4, source_fmt.height, 2, 0);
 
-		r.top  = clamp_t(s32, r.top, 0, vin->source.height - r.height);
-		r.left = clamp_t(s32, r.left, 0, vin->source.width - r.width);
+		r.top  = clamp_t(s32, r.top, 0, source_fmt.height - r.height);
+		r.left = clamp_t(s32, r.left, 0, source_fmt.width - r.width);
 
 		vin->crop = s->r = r;
 
 		vin_dbg(vin, "Cropped %dx%d@%d:%d of %dx%d\n",
 			r.width, r.height, r.left, r.top,
-			vin->source.width, vin->source.height);
+			source_fmt.width, source_fmt.height);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
 		/* Make sure compose rect fits inside output format */
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 8daba9db0e927a49..39051da31650bd79 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -48,16 +48,6 @@ enum rvin_dma_state {
 	STOPPING,
 };
 
-/**
- * struct rvin_source_fmt - Source information
- * @width:	Width from source
- * @height:	Height from source
- */
-struct rvin_source_fmt {
-	u32 width;
-	u32 height;
-};
-
 /**
  * struct rvin_video_format - Data format stored in memory
  * @fourcc:	Pixelformat
@@ -124,7 +114,6 @@ struct rvin_info {
  * @sequence:		V4L2 buffers sequence number
  * @state:		keeps track of operation state
  *
- * @source:		active format from the video source
  * @format:		active V4L2 pixel format
  *
  * @crop:		active cropping
@@ -151,7 +140,6 @@ struct rvin_dev {
 	unsigned int sequence;
 	enum rvin_dma_state state;
 
-	struct rvin_source_fmt source;
 	struct v4l2_pix_format format;
 
 	struct v4l2_rect crop;
-- 
2.16.1
