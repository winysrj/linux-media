Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37467 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750948AbZBSPSS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 10:18:18 -0500
Date: Thu, 19 Feb 2009 16:18:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: morimoto.kuninori@renesas.com
Subject: [PATCH 1/2] soc-camera: separate S_FMT and S_CROP operations
Message-ID: <Pine.LNX.4.64.0902191615000.5156@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As host and camera drivers become more complex, differences between S_FMT and
S_CROP functionality grow, this patch separates them.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c              |   19 +++-
 drivers/media/video/mt9m111.c              |   56 +++++++---
 drivers/media/video/mt9t031.c              |   84 ++++++++++------
 drivers/media/video/mt9v022.c              |   62 +++++++----
 drivers/media/video/mx3_camera.c           |  157 +++++++++++++++++-----------
 drivers/media/video/ov772x.c               |   31 +++++-
 drivers/media/video/pxa_camera.c           |   67 +++++++++---
 drivers/media/video/sh_mobile_ceu_camera.c |   17 ++-
 drivers/media/video/soc_camera.c           |   20 ++--
 drivers/media/video/soc_camera_platform.c  |    9 ++-
 drivers/media/video/tw9910.c               |   20 +++-
 include/media/soc_camera.h                 |    6 +-
 12 files changed, 369 insertions(+), 179 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 2d1034d..a6703d2 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -284,8 +284,8 @@ static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
 	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
-static int mt9m001_set_fmt(struct soc_camera_device *icd,
-			   __u32 pixfmt, struct v4l2_rect *rect)
+static int mt9m001_set_crop(struct soc_camera_device *icd,
+			    struct v4l2_rect *rect)
 {
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
 	int ret;
@@ -324,6 +324,20 @@ static int mt9m001_set_fmt(struct soc_camera_device *icd,
 	return ret;
 }
 
+static int mt9m001_set_fmt(struct soc_camera_device *icd,
+			   struct v4l2_format *f)
+{
+	struct v4l2_rect rect = {
+		.left	= icd->x_current,
+		.top	= icd->y_current,
+		.width	= f->fmt.pix.width,
+		.height	= f->fmt.pix.height,
+	};
+
+	/* No support for scaling so far, just crop. TODO: use skipping */
+	return mt9m001_set_crop(icd, &rect);
+}
+
 static int mt9m001_try_fmt(struct soc_camera_device *icd,
 			   struct v4l2_format *f)
 {
@@ -449,6 +463,7 @@ static struct soc_camera_ops mt9m001_ops = {
 	.release		= mt9m001_release,
 	.start_capture		= mt9m001_start_capture,
 	.stop_capture		= mt9m001_stop_capture,
+	.set_crop		= mt9m001_set_crop,
 	.set_fmt		= mt9m001_set_fmt,
 	.try_fmt		= mt9m001_try_fmt,
 	.set_bus_param		= mt9m001_set_bus_param,
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 7e6be36..cdd1ddb 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -152,7 +152,7 @@ struct mt9m111 {
 	struct soc_camera_device icd;
 	int model;	/* V4L2_IDENT_MT9M11x* codes from v4l2-chip-ident.h */
 	enum mt9m111_context context;
-	unsigned int left, top, width, height;
+	struct v4l2_rect rect;
 	u32 pixfmt;
 	unsigned char autoexposure;
 	unsigned char datawidth;
@@ -249,12 +249,13 @@ static int mt9m111_set_context(struct soc_camera_device *icd,
 		return reg_write(CONTEXT_CONTROL, valA);
 }
 
-static int mt9m111_setup_rect(struct soc_camera_device *icd)
+static int mt9m111_setup_rect(struct soc_camera_device *icd,
+			      struct v4l2_rect *rect)
 {
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
 	int ret, is_raw_format;
-	int width = mt9m111->width;
-	int height = mt9m111->height;
+	int width = rect->width;
+	int height = rect->height;
 
 	if ((mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR8)
 	    || (mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR16))
@@ -262,9 +263,9 @@ static int mt9m111_setup_rect(struct soc_camera_device *icd)
 	else
 		is_raw_format = 0;
 
-	ret = reg_write(COLUMN_START, mt9m111->left);
+	ret = reg_write(COLUMN_START, rect->left);
 	if (!ret)
-		ret = reg_write(ROW_START, mt9m111->top);
+		ret = reg_write(ROW_START, rect->top);
 
 	if (is_raw_format) {
 		if (!ret)
@@ -436,6 +437,22 @@ static int mt9m111_set_bus_param(struct soc_camera_device *icd, unsigned long f)
 	return 0;
 }
 
+static int mt9m111_set_crop(struct soc_camera_device *icd,
+			    struct v4l2_rect *rect)
+{
+	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	int ret;
+
+	dev_dbg(&icd->dev, "%s left=%d, top=%d, width=%d, height=%d\n",
+		__func__, rect->left, rect->top, rect->width,
+		rect->height);
+
+	ret = mt9m111_setup_rect(icd, rect);
+	if (!ret)
+		mt9m111->rect = *rect;
+	return ret;
+}
+
 static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
 {
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
@@ -486,23 +503,27 @@ static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
 }
 
 static int mt9m111_set_fmt(struct soc_camera_device *icd,
-			   __u32 pixfmt, struct v4l2_rect *rect)
+			   struct v4l2_format *f)
 {
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_rect rect = {
+		.left	= mt9m111->rect.left,
+		.top	= mt9m111->rect.top,
+		.width	= pix->width,
+		.height	= pix->height,
+	};
 	int ret;
 
-	mt9m111->left = rect->left;
-	mt9m111->top = rect->top;
-	mt9m111->width = rect->width;
-	mt9m111->height = rect->height;
-
 	dev_dbg(&icd->dev, "%s fmt=%x left=%d, top=%d, width=%d, height=%d\n",
-		__func__, pixfmt, mt9m111->left, mt9m111->top, mt9m111->width,
-		mt9m111->height);
+		__func__, pix->pixelformat, rect.left, rect.top, rect.width,
+		rect.height);
 
-	ret = mt9m111_setup_rect(icd);
+	ret = mt9m111_setup_rect(icd, &rect);
+	if (!ret)
+		ret = mt9m111_set_pixfmt(icd, pix->pixelformat);
 	if (!ret)
-		ret = mt9m111_set_pixfmt(icd, pixfmt);
+		mt9m111->rect = rect;
 	return ret;
 }
 
@@ -633,6 +654,7 @@ static struct soc_camera_ops mt9m111_ops = {
 	.release		= mt9m111_release,
 	.start_capture		= mt9m111_start_capture,
 	.stop_capture		= mt9m111_stop_capture,
+	.set_crop		= mt9m111_set_crop,
 	.set_fmt		= mt9m111_set_fmt,
 	.try_fmt		= mt9m111_try_fmt,
 	.query_bus_param	= mt9m111_query_bus_param,
@@ -817,7 +839,7 @@ static int mt9m111_restore_state(struct soc_camera_device *icd)
 
 	mt9m111_set_context(icd, mt9m111->context);
 	mt9m111_set_pixfmt(icd, mt9m111->pixfmt);
-	mt9m111_setup_rect(icd);
+	mt9m111_setup_rect(icd, &mt9m111->rect);
 	mt9m111_set_flip(icd, mt9m111->hflip, MT9M111_RMB_MIRROR_COLS);
 	mt9m111_set_flip(icd, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
 	mt9m111_set_global_gain(icd, icd->gain);
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index acc1fa9..677be18 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -213,36 +213,14 @@ static void recalculate_limits(struct soc_camera_device *icd,
 	icd->height_max = MT9T031_MAX_HEIGHT / yskip;
 }
 
-static int mt9t031_set_fmt(struct soc_camera_device *icd,
-			   __u32 pixfmt, struct v4l2_rect *rect)
+static int mt9t031_set_params(struct soc_camera_device *icd,
+			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
 {
 	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
 	int ret;
+	u16 xbin, ybin, width, height, left, top;
 	const u16 hblank = MT9T031_HORIZONTAL_BLANK,
 		vblank = MT9T031_VERTICAL_BLANK;
-	u16 xbin, xskip, ybin, yskip, width, height, left, top;
-
-	if (pixfmt) {
-		/*
-		 * try_fmt has put rectangle within limits.
-		 * S_FMT - use binning and skipping for scaling, recalculate
-		 * limits, used for cropping
-		 */
-		/* Is this more optimal than just a division? */
-		for (xskip = 8; xskip > 1; xskip--)
-			if (rect->width * xskip <= MT9T031_MAX_WIDTH)
-				break;
-
-		for (yskip = 8; yskip > 1; yskip--)
-			if (rect->height * yskip <= MT9T031_MAX_HEIGHT)
-				break;
-
-		recalculate_limits(icd, xskip, yskip);
-	} else {
-		/* CROP - no change in scaling, or in limits */
-		xskip = mt9t031->xskip;
-		yskip = mt9t031->yskip;
-	}
 
 	/* Make sure we don't exceed sensor limits */
 	if (rect->left + rect->width > icd->width_max)
@@ -289,7 +267,7 @@ static int mt9t031_set_fmt(struct soc_camera_device *icd,
 	if (ret >= 0)
 		ret = reg_write(icd, MT9T031_VERTICAL_BLANKING, vblank);
 
-	if (pixfmt) {
+	if (yskip != mt9t031->yskip || xskip != mt9t031->xskip) {
 		/* Binning, skipping */
 		if (ret >= 0)
 			ret = reg_write(icd, MT9T031_COLUMN_ADDRESS_MODE,
@@ -325,15 +303,58 @@ static int mt9t031_set_fmt(struct soc_camera_device *icd,
 		}
 	}
 
-	if (!ret && pixfmt) {
+	/* Re-enable register update, commit all changes */
+	if (ret >= 0)
+		ret = reg_clear(icd, MT9T031_OUTPUT_CONTROL, 1);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int mt9t031_set_crop(struct soc_camera_device *icd,
+			    struct v4l2_rect *rect)
+{
+	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+
+	/* CROP - no change in scaling, or in limits */
+	return mt9t031_set_params(icd, rect, mt9t031->xskip, mt9t031->yskip);
+}
+
+static int mt9t031_set_fmt(struct soc_camera_device *icd,
+			   struct v4l2_format *f)
+{
+	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	int ret;
+	u16 xskip, yskip;
+	struct v4l2_rect rect = {
+		.left	= icd->x_current,
+		.top	= icd->y_current,
+		.width	= f->fmt.pix.width,
+		.height	= f->fmt.pix.height,
+	};
+
+	/*
+	 * try_fmt has put rectangle within limits.
+	 * S_FMT - use binning and skipping for scaling, recalculate
+	 * limits, used for cropping
+	 */
+	/* Is this more optimal than just a division? */
+	for (xskip = 8; xskip > 1; xskip--)
+		if (rect.width * xskip <= MT9T031_MAX_WIDTH)
+			break;
+
+	for (yskip = 8; yskip > 1; yskip--)
+		if (rect.height * yskip <= MT9T031_MAX_HEIGHT)
+			break;
+
+	recalculate_limits(icd, xskip, yskip);
+
+	ret = mt9t031_set_params(icd, &rect, xskip, yskip);
+	if (!ret) {
 		mt9t031->xskip = xskip;
 		mt9t031->yskip = yskip;
 	}
 
-	/* Re-enable register update, commit all changes */
-	reg_clear(icd, MT9T031_OUTPUT_CONTROL, 1);
-
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 static int mt9t031_try_fmt(struct soc_camera_device *icd,
@@ -470,6 +491,7 @@ static struct soc_camera_ops mt9t031_ops = {
 	.release		= mt9t031_release,
 	.start_capture		= mt9t031_start_capture,
 	.stop_capture		= mt9t031_stop_capture,
+	.set_crop		= mt9t031_set_crop,
 	.set_fmt		= mt9t031_set_fmt,
 	.try_fmt		= mt9t031_try_fmt,
 	.set_bus_param		= mt9t031_set_bus_param,
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 6eb4b3a..3871d4a 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -340,32 +340,11 @@ static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
 		width_flag;
 }
 
-static int mt9v022_set_fmt(struct soc_camera_device *icd,
-			   __u32 pixfmt, struct v4l2_rect *rect)
+static int mt9v022_set_crop(struct soc_camera_device *icd,
+			    struct v4l2_rect *rect)
 {
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
 	int ret;
 
-	/* The caller provides a supported format, as verified per call to
-	 * icd->try_fmt(), datawidth is from our supported format list */
-	switch (pixfmt) {
-	case V4L2_PIX_FMT_GREY:
-	case V4L2_PIX_FMT_Y16:
-		if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATM)
-			return -EINVAL;
-		break;
-	case V4L2_PIX_FMT_SBGGR8:
-	case V4L2_PIX_FMT_SBGGR16:
-		if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATC)
-			return -EINVAL;
-		break;
-	case 0:
-		/* No format change, only geometry */
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	/* Like in example app. Contradicts the datasheet though */
 	ret = reg_read(icd, MT9V022_AEC_AGC_ENABLE);
 	if (ret >= 0) {
@@ -403,6 +382,42 @@ static int mt9v022_set_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
+static int mt9v022_set_fmt(struct soc_camera_device *icd,
+			   struct v4l2_format *f)
+{
+	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_rect rect = {
+		.left	= icd->x_current,
+		.top	= icd->y_current,
+		.width	= pix->width,
+		.height	= pix->height,
+	};
+
+	/* The caller provides a supported format, as verified per call to
+	 * icd->try_fmt(), datawidth is from our supported format list */
+	switch (pix->pixelformat) {
+	case V4L2_PIX_FMT_GREY:
+	case V4L2_PIX_FMT_Y16:
+		if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATM)
+			return -EINVAL;
+		break;
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SBGGR16:
+		if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATC)
+			return -EINVAL;
+		break;
+	case 0:
+		/* No format change, only geometry */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* No support for scaling on this camera, just crop. */
+	return mt9v022_set_crop(icd, &rect);
+}
+
 static int mt9v022_try_fmt(struct soc_camera_device *icd,
 			   struct v4l2_format *f)
 {
@@ -544,6 +559,7 @@ static struct soc_camera_ops mt9v022_ops = {
 	.release		= mt9v022_release,
 	.start_capture		= mt9v022_start_capture,
 	.stop_capture		= mt9v022_stop_capture,
+	.set_crop		= mt9v022_set_crop,
 	.set_fmt		= mt9v022_set_fmt,
 	.try_fmt		= mt9v022_try_fmt,
 	.set_bus_param		= mt9v022_set_bus_param,
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index a925d09..70629e1 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -544,16 +544,14 @@ static void mx3_camera_remove_device(struct soc_camera_device *icd)
 }
 
 static bool channel_change_requested(struct soc_camera_device *icd,
-				     const struct soc_camera_format_xlate *xlate,
-				     __u32 pixfmt, struct v4l2_rect *rect)
+				     struct v4l2_rect *rect)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
 
-	/* So far only one configuration is supported */
-	return pixfmt || (ichan && rect->width * rect->height > 
-			  icd->width * icd->height);
+	/* Do buffers have to be re-allocated or channel re-configured? */
+	return ichan && rect->width * rect->height > icd->width * icd->height;
 }
 
 static int test_platform_param(struct mx3_camera_dev *mx3_cam,
@@ -733,61 +731,10 @@ passthrough:
 	return formats;
 }
 
-static int mx3_camera_set_fmt(struct soc_camera_device *icd,
-			      __u32 pixfmt, struct v4l2_rect *rect)
+static void configure_geometry(struct mx3_camera_dev *mx3_cam,
+			       struct v4l2_rect *rect)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct mx3_camera_dev *mx3_cam = ici->priv;
-	const struct soc_camera_format_xlate *xlate;
 	u32 ctrl, width_field, height_field;
-	int ret;
-
-	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
-	if (pixfmt && !xlate) {
-		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
-		return -EINVAL;
-	}
-
-	/*
-	 * We now know pixel formats and can decide upon DMA-channel(s)
-	 * So far only direct camera-to-memory is supported
-	 */
-	if (channel_change_requested(icd, xlate, pixfmt, rect)) {
-		dma_cap_mask_t mask;
-		struct dma_chan *chan;
-		struct idmac_channel **ichan = &mx3_cam->idmac_channel[0];
-		/* We have to use IDMAC_IC_7 for Bayer / generic data */
-		struct dma_chan_request rq = {.mx3_cam = mx3_cam,
-					      .id = IDMAC_IC_7};
-
-		if (*ichan) {
-			struct videobuf_buffer *vb, *_vb;
-			dma_release_channel(&(*ichan)->dma_chan);
-			*ichan = NULL;
-			mx3_cam->active = NULL;
-			list_for_each_entry_safe(vb, _vb, &mx3_cam->capture, queue) {
-				list_del_init(&vb->queue);
-				vb->state = VIDEOBUF_ERROR;
-				wake_up(&vb->done);
-			}
-		}
-
-		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
-		dma_cap_set(DMA_PRIVATE, mask);
-		chan = dma_request_channel(mask, chan_filter, &rq);
-		if (!chan)
-			return -EBUSY;
-
-		*ichan = to_idmac_chan(chan);
-		(*ichan)->client = mx3_cam;
-	}
-
-	/*
-	 * Might have to perform a complete interface initialisation like in
-	 * ipu_csi_init_interface() in mxc_v4l2_s_param(). Also consider
-	 * mxc_v4l2_s_fmt()
-	 */
 
 	/* Setup frame size - this cannot be changed on-the-fly... */
 	width_field = rect->width - 1;
@@ -808,9 +755,98 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	 * No need to free resources here if we fail, we'll see if we need to
 	 * do this next time we are called
 	 */
+}
+
+static int acquire_dma_channel(struct mx3_camera_dev *mx3_cam)
+{
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+	struct idmac_channel **ichan = &mx3_cam->idmac_channel[0];
+	/* We have to use IDMAC_IC_7 for Bayer / generic data */
+	struct dma_chan_request rq = {.mx3_cam = mx3_cam,
+				      .id = IDMAC_IC_7};
+
+	if (*ichan) {
+		struct videobuf_buffer *vb, *_vb;
+		dma_release_channel(&(*ichan)->dma_chan);
+		*ichan = NULL;
+		mx3_cam->active = NULL;
+		list_for_each_entry_safe(vb, _vb, &mx3_cam->capture, queue) {
+			list_del_init(&vb->queue);
+			vb->state = VIDEOBUF_ERROR;
+			wake_up(&vb->done);
+		}
+	}
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_PRIVATE, mask);
+	chan = dma_request_channel(mask, chan_filter, &rq);
+	if (!chan)
+		return -EBUSY;
+
+	*ichan = to_idmac_chan(chan);
+	(*ichan)->client = mx3_cam;
+
+	return 0;
+}
+
+static int mx3_camera_set_crop(struct soc_camera_device *icd,
+			       struct v4l2_rect *rect)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
+
+	/*
+	 * We now know pixel formats and can decide upon DMA-channel(s)
+	 * So far only direct camera-to-memory is supported
+	 */
+	if (channel_change_requested(icd, rect)) {
+		int ret = acquire_dma_channel(mx3_cam);
+		if (ret < 0)
+			return ret;
+	}
+
+	configure_geometry(mx3_cam, rect);
+
+	return icd->ops->set_crop(icd, rect);
+}
+
+static int mx3_camera_set_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_rect rect = {
+		.left	= icd->x_current,
+		.top	= icd->y_current,
+		.width	= pix->width,
+		.height	= pix->height,
+	};
+	int ret;
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		dev_warn(&ici->dev, "Format %x not found\n", pix->pixelformat);
+		return -EINVAL;
+	}
+
+	ret = acquire_dma_channel(mx3_cam);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Might have to perform a complete interface initialisation like in
+	 * ipu_csi_init_interface() in mxc_v4l2_s_param(). Also consider
+	 * mxc_v4l2_s_fmt()
+	 */
+
+	configure_geometry(mx3_cam, &rect);
 
-	ret = icd->ops->set_fmt(icd, pixfmt ? xlate->cam_fmt->fourcc : 0, rect);
-	if (pixfmt && !ret) {
+	ret = icd->ops->set_fmt(icd, f);
+	if (!ret) {
 		icd->buswidth = xlate->buswidth;
 		icd->current_fmt = xlate->host_fmt;
 	}
@@ -1031,6 +1067,7 @@ static struct soc_camera_host_ops mx3_soc_camera_host_ops = {
 	.suspend	= mx3_camera_suspend,
 	.resume		= mx3_camera_resume,
 #endif
+	.set_crop	= mx3_camera_set_crop,
 	.set_fmt	= mx3_camera_set_fmt,
 	.try_fmt	= mx3_camera_try_fmt,
 	.get_formats	= mx3_camera_get_formats,
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 880e51f..8dd93b3 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -781,11 +781,9 @@ ov772x_select_win(u32 width, u32 height)
 	return win;
 }
 
-static int ov772x_set_fmt(struct soc_camera_device *icd,
-			  __u32                     pixfmt,
-			  struct v4l2_rect         *rect)
+static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
+			     u32 pixfmt)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
 	int ret = -EINVAL;
 	u8  val;
 	int i;
@@ -806,7 +804,7 @@ static int ov772x_set_fmt(struct soc_camera_device *icd,
 	/*
 	 * select win
 	 */
-	priv->win = ov772x_select_win(rect->width, rect->height);
+	priv->win = ov772x_select_win(width, height);
 
 	/*
 	 * reset hardware
@@ -870,6 +868,28 @@ ov772x_set_fmt_error:
 	return ret;
 }
 
+static int ov772x_set_crop(struct soc_camera_device *icd,
+			   struct v4l2_rect *rect)
+{
+	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+
+	if (!priv->fmt)
+		return -EINVAL;
+
+	return ov772x_set_params(priv, rect->width, rect->height,
+				 priv->fmt->fourcc);
+}
+
+static int ov772x_set_fmt(struct soc_camera_device *icd,
+			  struct v4l2_format *f)
+{
+	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	return ov772x_set_params(priv, pix->width, pix->height,
+				 pix->pixelformat);
+}
+
 static int ov772x_try_fmt(struct soc_camera_device *icd,
 			  struct v4l2_format       *f)
 {
@@ -959,6 +979,7 @@ static struct soc_camera_ops ov772x_ops = {
 	.release		= ov772x_release,
 	.start_capture		= ov772x_start_capture,
 	.stop_capture		= ov772x_stop_capture,
+	.set_crop		= ov772x_set_crop,
 	.set_fmt		= ov772x_set_fmt,
 	.try_fmt		= ov772x_try_fmt,
 	.set_bus_param		= ov772x_set_bus_param,
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 7b71b9c..a30747f 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1151,8 +1151,43 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 	return formats;
 }
 
+static int pxa_camera_set_crop(struct soc_camera_device *icd,
+			       struct v4l2_rect *rect)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	struct soc_camera_sense sense = {
+		.master_clock = pcdev->mclk,
+		.pixel_clock_max = pcdev->ciclk / 4,
+	};
+	int ret;
+
+	/* If PCLK is used to latch data from the sensor, check sense */
+	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
+		icd->sense = &sense;
+
+	ret = icd->ops->set_crop(icd, rect);
+
+	icd->sense = NULL;
+
+	if (ret < 0) {
+		dev_warn(&ici->dev, "Failed to crop to %ux%u@%u:%u\n",
+			 rect->width, rect->height, rect->left, rect->top);
+	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
+		if (sense.pixel_clock > sense.pixel_clock_max) {
+			dev_err(&ici->dev,
+				"pixel clock %lu set by the camera too high!",
+				sense.pixel_clock);
+			return -EIO;
+		}
+		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
+	}
+
+	return ret;
+}
+
 static int pxa_camera_set_fmt(struct soc_camera_device *icd,
-			      __u32 pixfmt, struct v4l2_rect *rect)
+			      struct v4l2_format *f)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
@@ -1162,35 +1197,30 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 		.master_clock = pcdev->mclk,
 		.pixel_clock_max = pcdev->ciclk / 4,
 	};
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_format cam_f = *f;
 	int ret;
 
-	if (pixfmt) {
-		xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
-		if (!xlate) {
-			dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
-			return -EINVAL;
-		}
-
-		cam_fmt = xlate->cam_fmt;
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		dev_warn(&ici->dev, "Format %x not found\n", pix->pixelformat);
+		return -EINVAL;
 	}
 
+	cam_fmt = xlate->cam_fmt;
+
 	/* If PCLK is used to latch data from the sensor, check sense */
 	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
 		icd->sense = &sense;
 
-	switch (pixfmt) {
-	case 0:				/* Only geometry change */
-		ret = icd->ops->set_fmt(icd, pixfmt, rect);
-		break;
-	default:
-		ret = icd->ops->set_fmt(icd, cam_fmt->fourcc, rect);
-	}
+	cam_f.fmt.pix.pixelformat = cam_fmt->fourcc;
+	ret = icd->ops->set_fmt(icd, &cam_f);
 
 	icd->sense = NULL;
 
 	if (ret < 0) {
 		dev_warn(&ici->dev, "Failed to configure for format %x\n",
-			 pixfmt);
+			 pix->pixelformat);
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
 			dev_err(&ici->dev,
@@ -1201,7 +1231,7 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
 	}
 
-	if (pixfmt && !ret) {
+	if (!ret) {
 		icd->buswidth = xlate->buswidth;
 		icd->current_fmt = xlate->host_fmt;
 	}
@@ -1365,6 +1395,7 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.remove		= pxa_camera_remove_device,
 	.suspend	= pxa_camera_suspend,
 	.resume		= pxa_camera_resume,
+	.set_crop	= pxa_camera_set_crop,
 	.get_formats	= pxa_camera_get_formats,
 	.set_fmt	= pxa_camera_set_fmt,
 	.try_fmt	= pxa_camera_try_fmt,
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index b8234c7..59bbefd 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -637,24 +637,30 @@ add_single_format:
 	return formats;
 }
 
+static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
+				  struct v4l2_rect *rect)
+{
+	return icd->ops->set_crop(icd, rect);
+}
+
 static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
-				 __u32 pixfmt, struct v4l2_rect *rect)
+				 struct v4l2_format *f)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	__u32 pixfmt = f->fmt.pix.pixelformat;
 	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_format cam_f = *f;
 	int ret;
 
-	if (!pixfmt)
-		return icd->ops->set_fmt(icd, pixfmt, rect);
-
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
 		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
-	ret = icd->ops->set_fmt(icd, xlate->cam_fmt->fourcc, rect);
+	cam_f.fmt.pix.pixelformat = xlate->cam_fmt->fourcc;
+	ret = icd->ops->set_fmt(icd, &cam_f);
 
 	if (!ret) {
 		icd->buswidth = xlate->buswidth;
@@ -786,6 +792,7 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.add		= sh_mobile_ceu_add_device,
 	.remove		= sh_mobile_ceu_remove_device,
 	.get_formats	= sh_mobile_ceu_get_formats,
+	.set_crop	= sh_mobile_ceu_set_crop,
 	.set_fmt	= sh_mobile_ceu_set_fmt,
 	.try_fmt	= sh_mobile_ceu_try_fmt,
 	.reqbufs	= sh_mobile_ceu_reqbufs,
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index fcb05f0..9939b04 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -417,9 +417,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	struct soc_camera_device *icd = icf->icd;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	__u32 pixfmt = pix->pixelformat;
 	int ret;
-	struct v4l2_rect rect;
 
 	WARN_ON(priv != file->private_data);
 
@@ -435,23 +433,19 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 		goto unlock;
 	}
 
-	rect.left	= icd->x_current;
-	rect.top	= icd->y_current;
-	rect.width	= pix->width;
-	rect.height	= pix->height;
-	ret = ici->ops->set_fmt(icd, pix->pixelformat, &rect);
+	ret = ici->ops->set_fmt(icd, f);
 	if (ret < 0) {
 		goto unlock;
 	} else if (!icd->current_fmt ||
-		   icd->current_fmt->fourcc != pixfmt) {
+		   icd->current_fmt->fourcc != pix->pixelformat) {
 		dev_err(&ici->dev,
 			"Host driver hasn't set up current format correctly!\n");
 		ret = -EINVAL;
 		goto unlock;
 	}
 
-	icd->width		= rect.width;
-	icd->height		= rect.height;
+	icd->width		= f->fmt.pix.width;
+	icd->height		= f->fmt.pix.height;
 	icf->vb_vidq.field	= pix->field;
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
@@ -461,7 +455,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 		icd->width, icd->height);
 
 	/* set physical bus parameters */
-	ret = ici->ops->set_bus_param(icd, pixfmt);
+	ret = ici->ops->set_bus_param(icd, pix->pixelformat);
 
 unlock:
 	mutex_unlock(&icf->vb_vidq.vb_lock);
@@ -685,7 +679,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	/* Cropping is allowed during a running capture, guard consistency */
 	mutex_lock(&icf->vb_vidq.vb_lock);
 
-	ret = ici->ops->set_fmt(icd, 0, &a->c);
+	ret = ici->ops->set_crop(icd, &a->c);
 	if (!ret) {
 		icd->width	= a->c.width;
 		icd->height	= a->c.height;
@@ -918,6 +912,7 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	if (!ici || !ici->ops ||
 	    !ici->ops->try_fmt ||
 	    !ici->ops->set_fmt ||
+	    !ici->ops->set_crop ||
 	    !ici->ops->set_bus_param ||
 	    !ici->ops->querycap ||
 	    !ici->ops->init_videobuf ||
@@ -998,6 +993,7 @@ int soc_camera_device_register(struct soc_camera_device *icd)
 	    !icd->ops->release ||
 	    !icd->ops->start_capture ||
 	    !icd->ops->stop_capture ||
+	    !icd->ops->set_crop ||
 	    !icd->ops->set_fmt ||
 	    !icd->ops->try_fmt ||
 	    !icd->ops->query_bus_param ||
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index 013ab06..c486763 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -79,8 +79,14 @@ soc_camera_platform_query_bus_param(struct soc_camera_device *icd)
 	return p->bus_param;
 }
 
+static int soc_camera_platform_set_crop(struct soc_camera_device *icd,
+					struct v4l2_rect *rect)
+{
+	return 0;
+}
+
 static int soc_camera_platform_set_fmt(struct soc_camera_device *icd,
-				       __u32 pixfmt, struct v4l2_rect *rect)
+				       struct v4l2_format *f)
 {
 	return 0;
 }
@@ -125,6 +131,7 @@ static struct soc_camera_ops soc_camera_platform_ops = {
 	.release		= soc_camera_platform_release,
 	.start_capture		= soc_camera_platform_start_capture,
 	.stop_capture		= soc_camera_platform_stop_capture,
+	.set_crop		= soc_camera_platform_set_crop,
 	.set_fmt		= soc_camera_platform_set_fmt,
 	.try_fmt		= soc_camera_platform_try_fmt,
 	.set_bus_param		= soc_camera_platform_set_bus_param,
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 17d8205..5e03d65 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -641,8 +641,8 @@ static int tw9910_set_register(struct soc_camera_device *icd,
 }
 #endif
 
-static int tw9910_set_fmt(struct soc_camera_device *icd, __u32 pixfmt,
-			      struct v4l2_rect *rect)
+static int tw9910_set_crop(struct soc_camera_device *icd,
+			   struct v4l2_rect *rect)
 {
 	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
 	int                 ret  = -EINVAL;
@@ -733,8 +733,21 @@ tw9910_set_fmt_error:
 	return ret;
 }
 
+static int tw9910_set_fmt(struct soc_camera_device *icd,
+			  struct v4l2_format *f)
+{
+	struct v4l2_rect rect = {
+		.left	= icd->x_current,
+		.top	= icd->y_current,
+		.width	= f->fmt.pix.width,
+		.height	= f->fmt.pix.height,
+	};
+
+	return tw9910_set_crop(icd, &rect);
+}
+
 static int tw9910_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+			  struct v4l2_format *f)
 {
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	const struct tw9910_scale_ctrl *scale;
@@ -822,6 +835,7 @@ static struct soc_camera_ops tw9910_ops = {
 	.release		= tw9910_release,
 	.start_capture		= tw9910_start_capture,
 	.stop_capture		= tw9910_stop_capture,
+	.set_crop		= tw9910_set_crop,
 	.set_fmt		= tw9910_set_fmt,
 	.try_fmt		= tw9910_try_fmt,
 	.set_bus_param		= tw9910_set_bus_param,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index c63a340..e9eb607 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -74,7 +74,8 @@ struct soc_camera_host_ops {
 	int (*resume)(struct soc_camera_device *);
 	int (*get_formats)(struct soc_camera_device *, int,
 			   struct soc_camera_format_xlate *);
-	int (*set_fmt)(struct soc_camera_device *, __u32, struct v4l2_rect *);
+	int (*set_crop)(struct soc_camera_device *, struct v4l2_rect *);
+	int (*set_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	void (*init_videobuf)(struct videobuf_queue *,
 			      struct soc_camera_device *);
@@ -159,7 +160,8 @@ struct soc_camera_ops {
 	int (*release)(struct soc_camera_device *);
 	int (*start_capture)(struct soc_camera_device *);
 	int (*stop_capture)(struct soc_camera_device *);
-	int (*set_fmt)(struct soc_camera_device *, __u32, struct v4l2_rect *);
+	int (*set_crop)(struct soc_camera_device *, struct v4l2_rect *);
+	int (*set_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	unsigned long (*query_bus_param)(struct soc_camera_device *);
 	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
-- 
1.5.4

