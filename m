Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:31919 "EHLO
        bin-vsp-out-02.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754641AbeCGWFp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 17:05:45 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v12 16/33] rcar-vin: simplify how formats are set and reset
Date: Wed,  7 Mar 2018 23:04:54 +0100
Message-Id: <20180307220511.9826-17-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the recent cleanup of the format code to prepare for Gen3 it's
possible to simplify the Gen2 format code path as well. Clean up the
process by defining two functions to handle the set format and reset of
format when the standard is changed.

While at it replace the driver local struct rvin_source_fmt with a
struct v4l2_rect as all it's used for is keep track of the source
dimensions.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

---

* Changes since v11
- This patch where 'rcar-vin: read subdevice format for crop only when
needed'
- Keep caching the source dimensions and drop all changes to
rvin_g_selection() and rvin_s_selection().
- Inline rvin_get_vin_format_from_source() into rvin_reset_format()
which now is the only user left.
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 120 ++++++++++++----------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  14 +---
 2 files changed, 55 insertions(+), 79 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 680b25f610d1d8bb..c4be0bcb8b16f941 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -138,67 +138,60 @@ static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
  * V4L2
  */
 
-static void rvin_reset_crop_compose(struct rvin_dev *vin)
-{
-	vin->crop.top = vin->crop.left = 0;
-	vin->crop.width = vin->source.width;
-	vin->crop.height = vin->source.height;
-
-	vin->compose.top = vin->compose.left = 0;
-	vin->compose.width = vin->format.width;
-	vin->compose.height = vin->format.height;
-}
-
 static int rvin_reset_format(struct rvin_dev *vin)
 {
 	struct v4l2_subdev_format fmt = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.pad = vin->digital->source_pad,
 	};
-	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	int ret;
 
-	fmt.pad = vin->digital->source_pad;
-
 	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
 	if (ret)
 		return ret;
 
-	vin->format.width	= mf->width;
-	vin->format.height	= mf->height;
-	vin->format.colorspace	= mf->colorspace;
-	vin->format.field	= mf->field;
+	v4l2_fill_pix_format(&vin->format, &fmt.format);
 
-	rvin_reset_crop_compose(vin);
+	ret = rvin_format_align(vin, &vin->format);
+	if (ret)
+		return ret;
 
-	vin->format.bytesperline = rvin_format_bytesperline(&vin->format);
-	vin->format.sizeimage = rvin_format_sizeimage(&vin->format);
+	vin->source.top = vin->crop.top = 0;
+	vin->source.left = vin->crop.left = 0;
+	vin->source.width = vin->crop.width = vin->format.width;
+	vin->source.height = vin->crop.height = vin->format.height;
+
+	vin->compose.top = vin->compose.left = 0;
+	vin->compose.width = vin->format.width;
+	vin->compose.height = vin->format.height;
 
 	return 0;
 }
 
-static int __rvin_try_format_source(struct rvin_dev *vin,
-				    u32 which,
-				    struct v4l2_pix_format *pix,
-				    struct rvin_source_fmt *source)
+static int rvin_try_format(struct rvin_dev *vin, u32 which,
+			   struct v4l2_pix_format *pix,
+			   struct v4l2_rect *crop, struct v4l2_rect *compose)
 {
-	struct v4l2_subdev *sd;
+	struct v4l2_subdev *sd = vin_to_source(vin);
 	struct v4l2_subdev_pad_config *pad_cfg;
 	struct v4l2_subdev_format format = {
 		.which = which,
+		.pad = vin->digital->source_pad,
 	};
 	enum v4l2_field field;
 	u32 width, height;
 	int ret;
 
-	sd = vin_to_source(vin);
-
-	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
-
 	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
 	if (pad_cfg == NULL)
 		return -ENOMEM;
 
-	format.pad = vin->digital->source_pad;
+	if (!rvin_format_from_pixel(pix->pixelformat) ||
+	    (vin->info->model == RCAR_M1 &&
+	     pix->pixelformat == V4L2_PIX_FMT_XBGR32))
+		pix->pixelformat = RVIN_DEFAULT_FORMAT;
+
+	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
 
 	/* Allow the video device to override field and to scale */
 	field = pix->field;
@@ -211,39 +204,34 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	v4l2_fill_pix_format(pix, &format.format);
 
-	source->width = pix->width;
-	source->height = pix->height;
+	crop->top = crop->left = 0;
+	crop->width = pix->width;
+	crop->height = pix->height;
+
+	/*
+	 * If source is ALTERNATE the driver will use the VIN hardware
+	 * to INTERLACE it. The crop height then needs to be doubled.
+	 */
+	if (pix->field == V4L2_FIELD_ALTERNATE)
+		crop->height *= 2;
+
+	if (field != V4L2_FIELD_ANY)
+		pix->field = field;
 
-	pix->field = field;
 	pix->width = width;
 	pix->height = height;
 
-	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
-		source->height);
+	ret = rvin_format_align(vin, pix);
+	if (ret)
+		return ret;
 
+	compose->top = compose->left = 0;
+	compose->width = pix->width;
+	compose->height = pix->height;
 done:
 	v4l2_subdev_free_pad_config(pad_cfg);
-	return ret;
-}
 
-static int __rvin_try_format(struct rvin_dev *vin,
-			     u32 which,
-			     struct v4l2_pix_format *pix,
-			     struct rvin_source_fmt *source)
-{
-	int ret;
-
-	if (!rvin_format_from_pixel(pix->pixelformat) ||
-	    (vin->info->model == RCAR_M1 &&
-	     pix->pixelformat == V4L2_PIX_FMT_XBGR32))
-		pix->pixelformat = RVIN_DEFAULT_FORMAT;
-
-	/* Limit to source capabilities */
-	ret = __rvin_try_format_source(vin, which, pix, source);
-	if (ret)
-		return ret;
-
-	return rvin_format_align(vin, pix);
+	return 0;
 }
 
 static int rvin_querycap(struct file *file, void *priv,
@@ -262,33 +250,31 @@ static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct rvin_source_fmt source;
+	struct v4l2_rect crop, compose;
 
-	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
-				 &source);
+	return rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix, &crop,
+			       &compose);
 }
 
 static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
 			      struct v4l2_format *f)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct rvin_source_fmt source;
+	struct v4l2_rect crop, compose;
 	int ret;
 
 	if (vb2_is_busy(&vin->queue))
 		return -EBUSY;
 
-	ret = __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
-				&source);
+	ret = rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
+			      &crop, &compose);
 	if (ret)
 		return ret;
 
-	vin->source.width = source.width;
-	vin->source.height = source.height;
-
 	vin->format = f->fmt.pix;
-
-	rvin_reset_crop_compose(vin);
+	vin->crop = crop;
+	vin->compose = compose;
+	vin->source = crop;
 
 	return 0;
 }
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 8daba9db0e927a49..7fcf984f21466855 100644
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
@@ -124,11 +114,11 @@ struct rvin_info {
  * @sequence:		V4L2 buffers sequence number
  * @state:		keeps track of operation state
  *
- * @source:		active format from the video source
  * @format:		active V4L2 pixel format
  *
  * @crop:		active cropping
  * @compose:		active composing
+ * @source:		active size of the video source
  */
 struct rvin_dev {
 	struct device *dev;
@@ -151,11 +141,11 @@ struct rvin_dev {
 	unsigned int sequence;
 	enum rvin_dma_state state;
 
-	struct rvin_source_fmt source;
 	struct v4l2_pix_format format;
 
 	struct v4l2_rect crop;
 	struct v4l2_rect compose;
+	struct v4l2_rect source;
 };
 
 #define vin_to_source(vin)		((vin)->digital->subdev)
-- 
2.16.2
