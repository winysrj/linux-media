Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:56064 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752801AbdHVX2p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 19:28:45 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v6 10/25] rcar-vin: read subdevice format for crop only when needed
Date: Wed, 23 Aug 2017 01:26:25 +0200
Message-Id: <20170822232640.26147-11-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of caching the subdevice format each time the video device
format is set read it directly when its needed. As it turns out the
format is only needed when figuring out the max rectangle for cropping.

This simplify the code and makes it clearer what the source format is
used for.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 88 ++++++++++++++---------------
 drivers/media/platform/rcar-vin/rcar-vin.h  | 12 ----
 2 files changed, 42 insertions(+), 58 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 305a74d033b2d9c5..c8c764188b85a926 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -90,24 +90,30 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
  * V4L2
  */
 
-int rvin_reset_format(struct rvin_dev *vin)
+static int rvin_get_sd_format(struct rvin_dev *vin, struct v4l2_pix_format *pix)
 {
 	struct v4l2_subdev_format fmt = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.pad = vin->digital.source_pad,
 	};
-	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	int ret;
 
-	fmt.pad = vin->digital.source_pad;
-
 	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
 	if (ret)
 		return ret;
 
-	vin->format.width	= mf->width;
-	vin->format.height	= mf->height;
-	vin->format.colorspace	= mf->colorspace;
-	vin->format.field	= mf->field;
+	v4l2_fill_pix_format(pix, &fmt.format);
+
+	return 0;
+}
+
+int rvin_reset_format(struct rvin_dev *vin)
+{
+	int ret;
+
+	ret = rvin_get_sd_format(vin, &vin->format);
+	if (ret)
+		return ret;
 
 	/*
 	 * If the subdevice uses ALTERNATE field mode and G_STD is
@@ -137,12 +143,12 @@ int rvin_reset_format(struct rvin_dev *vin)
 	}
 
 	vin->crop.top = vin->crop.left = 0;
-	vin->crop.width = mf->width;
-	vin->crop.height = mf->height;
+	vin->crop.width = vin->format.width;
+	vin->crop.height = vin->format.height;
 
 	vin->compose.top = vin->compose.left = 0;
-	vin->compose.width = mf->width;
-	vin->compose.height = mf->height;
+	vin->compose.width = vin->format.width;
+	vin->compose.height = vin->format.height;
 
 	vin->format.bytesperline = rvin_format_bytesperline(&vin->format);
 	vin->format.sizeimage = rvin_format_sizeimage(&vin->format);
@@ -151,9 +157,7 @@ int rvin_reset_format(struct rvin_dev *vin)
 }
 
 static int __rvin_try_format_source(struct rvin_dev *vin,
-				    u32 which,
-				    struct v4l2_pix_format *pix,
-				    struct rvin_source_fmt *source)
+				    u32 which, struct v4l2_pix_format *pix)
 {
 	struct v4l2_subdev *sd;
 	struct v4l2_subdev_pad_config *pad_cfg;
@@ -186,25 +190,15 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	v4l2_fill_pix_format(pix, &format.format);
 
 	pix->field = field;
-
-	source->width = pix->width;
-	source->height = pix->height;
-
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
@@ -225,7 +219,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	pix->sizeimage = 0;
 
 	/* Limit to source capabilities */
-	ret = __rvin_try_format_source(vin, which, pix, source);
+	ret = __rvin_try_format_source(vin, which, pix);
 	if (ret)
 		return ret;
 
@@ -234,7 +228,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	case V4L2_FIELD_BOTTOM:
 	case V4L2_FIELD_ALTERNATE:
 		pix->height /= 2;
-		source->height /= 2;
 		break;
 	case V4L2_FIELD_NONE:
 	case V4L2_FIELD_INTERLACED_TB:
@@ -286,30 +279,23 @@ static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
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
 
 	return 0;
@@ -340,6 +326,8 @@ static int rvin_g_selection(struct file *file, void *fh,
 			    struct v4l2_selection *s)
 {
 	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_pix_format pix;
+	int ret;
 
 	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -347,9 +335,12 @@ static int rvin_g_selection(struct file *file, void *fh,
 	switch (s->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
 	case V4L2_SEL_TGT_CROP_DEFAULT:
+		ret = rvin_get_sd_format(vin, &pix);
+		if (ret)
+			return ret;
 		s->r.left = s->r.top = 0;
-		s->r.width = vin->source.width;
-		s->r.height = vin->source.height;
+		s->r.width = pix.width;
+		s->r.height = pix.height;
 		break;
 	case V4L2_SEL_TGT_CROP:
 		s->r = vin->crop;
@@ -375,12 +366,14 @@ static int rvin_s_selection(struct file *file, void *fh,
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	const struct rvin_video_format *fmt;
+	struct v4l2_pix_format pix;
 	struct v4l2_rect r = s->r;
 	struct v4l2_rect max_rect;
 	struct v4l2_rect min_rect = {
 		.width = 6,
 		.height = 2,
 	};
+	int ret;
 
 	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -390,22 +383,25 @@ static int rvin_s_selection(struct file *file, void *fh,
 	switch (s->target) {
 	case V4L2_SEL_TGT_CROP:
 		/* Can't crop outside of source input */
+		ret = rvin_get_sd_format(vin, &pix);
+		if (ret)
+			return ret;
 		max_rect.top = max_rect.left = 0;
-		max_rect.width = vin->source.width;
-		max_rect.height = vin->source.height;
+		max_rect.width = pix.width;
+		max_rect.height = pix.height;
 		v4l2_rect_map_inside(&r, &max_rect);
 
-		v4l_bound_align_image(&r.width, 2, vin->source.width, 1,
-				      &r.height, 4, vin->source.height, 2, 0);
+		v4l_bound_align_image(&r.width, 2, pix.width, 1,
+				      &r.height, 4, pix.height, 2, 0);
 
-		r.top  = clamp_t(s32, r.top, 0, vin->source.height - r.height);
-		r.left = clamp_t(s32, r.left, 0, vin->source.width - r.width);
+		r.top  = clamp_t(s32, r.top, 0, pix.height - r.height);
+		r.left = clamp_t(s32, r.left, 0, pix.width - r.width);
 
 		vin->crop = s->r = r;
 
 		vin_dbg(vin, "Cropped %dx%d@%d:%d of %dx%d\n",
 			r.width, r.height, r.left, r.top,
-			vin->source.width, vin->source.height);
+			pix.width, pix.height);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
 		/* Make sure compose rect fits inside output format */
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index fc70ded462ed3244..cd8d9a96f78f3267 100644
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
@@ -125,7 +115,6 @@ struct rvin_info {
  * @sequence:		V4L2 buffers sequence number
  * @state:		keeps track of operation state
  *
- * @source:		active format from the video source
  * @format:		active V4L2 pixel format
  *
  * @crop:		active cropping
@@ -152,7 +141,6 @@ struct rvin_dev {
 	unsigned int sequence;
 	enum rvin_dma_state state;
 
-	struct rvin_source_fmt source;
 	struct v4l2_pix_format format;
 
 	struct v4l2_rect crop;
-- 
2.14.0
