Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51547 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098Ab3CZSix (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 14:38:53 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 3/5] exynos4-is: Allow colorspace conversion at fimc-lite
Date: Tue, 26 Mar 2013 19:38:17 +0100
Message-id: <1364323101-22046-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
References: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FIMC-LITE output DMA allows to configure different YUV order
than the order at the camera input interface. Thus there is some
limited colorspace conversion possible. This patch makes the
color format variable be per FIMC-LITE input/output, rather than
a global per device. This also fixes incorrect behavior where
color format at the FIMC-LITE.N subdev's source pad is modified
by VIDIOC_S_FMT ioctl on the related video node.

YUV order definitions are corrected so that we use notation:

         | byte3 | byte2 | byte1 | byte0
  -------+-------+-------+-------+------
  YCBYCR | CR    | Y     | CB    | Y
  YCRYCB | CB    | Y     | CR    | Y
  CBYCRY | Y     | CR    | Y     | CB
  CRYCBY | Y     | CB    | Y     | CR

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite-reg.c |    4 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.h |    8 +--
 drivers/media/platform/exynos4-is/fimc-lite.c     |   76 ++++++++++++++-------
 drivers/media/platform/exynos4-is/fimc-lite.h     |    4 +-
 include/media/s5p_fimc.h                          |    2 +
 5 files changed, 61 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index ac9663c..8cc0d39 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -127,7 +127,7 @@ static const u32 src_pixfmt_map[8][3] = {
 /* Set camera input pixel format and resolution */
 void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f)
 {
-	enum v4l2_mbus_pixelcode pixelcode = dev->fmt->mbus_code;
+	enum v4l2_mbus_pixelcode pixelcode = f->fmt->mbus_code;
 	int i = ARRAY_SIZE(src_pixfmt_map);
 	u32 cfg;
 
@@ -227,7 +227,7 @@ static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
 	int i = ARRAY_SIZE(pixcode);
 
 	while (--i >= 0)
-		if (pixcode[i][0] == dev->fmt->mbus_code)
+		if (pixcode[i][0] == f->fmt->mbus_code)
 			break;
 	cfg &= ~FLITE_REG_CIODMAFMT_YCBCR_ORDER_MASK;
 	writel(cfg | pixcode[i][1], dev->regs + FLITE_REG_CIODMAFMT);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.h b/drivers/media/platform/exynos4-is/fimc-lite-reg.h
index 0e34584..3903839 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.h
@@ -72,10 +72,10 @@
 #define FLITE_REG_CIODMAFMT			0x18
 #define FLITE_REG_CIODMAFMT_RAW_CON		(1 << 15)
 #define FLITE_REG_CIODMAFMT_PACK12		(1 << 14)
-#define FLITE_REG_CIODMAFMT_CRYCBY		(0 << 4)
-#define FLITE_REG_CIODMAFMT_CBYCRY		(1 << 4)
-#define FLITE_REG_CIODMAFMT_YCRYCB		(2 << 4)
-#define FLITE_REG_CIODMAFMT_YCBYCR		(3 << 4)
+#define FLITE_REG_CIODMAFMT_YCBYCR		(0 << 4)
+#define FLITE_REG_CIODMAFMT_YCRYCB		(1 << 4)
+#define FLITE_REG_CIODMAFMT_CBYCRY		(2 << 4)
+#define FLITE_REG_CIODMAFMT_CRYCBY		(3 << 4)
 #define FLITE_REG_CIODMAFMT_YCBCR_ORDER_MASK	(0x3 << 4)
 
 /* Camera Output Canvas */
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index ba35328..b11e358 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -46,6 +46,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.color		= FIMC_FMT_YCBYCR422,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.flags		= FMT_FLAGS_YUV,
 	}, {
 		.name		= "YUV 4:2:2 packed, CbYCrY",
 		.fourcc		= V4L2_PIX_FMT_UYVY,
@@ -53,6 +54,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.color		= FIMC_FMT_CBYCRY422,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+		.flags		= FMT_FLAGS_YUV,
 	}, {
 		.name		= "YUV 4:2:2 packed, CrYCbY",
 		.fourcc		= V4L2_PIX_FMT_VYUY,
@@ -60,6 +62,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.color		= FIMC_FMT_CRYCBY422,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_VYUY8_2X8,
+		.flags		= FMT_FLAGS_YUV,
 	}, {
 		.name		= "YUV 4:2:2 packed, YCrYCb",
 		.fourcc		= V4L2_PIX_FMT_YVYU,
@@ -67,6 +70,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.color		= FIMC_FMT_YCRYCB422,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
+		.flags		= FMT_FLAGS_YUV,
 	}, {
 		.name		= "RAW8 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG8,
@@ -74,6 +78,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.color		= FIMC_FMT_RAW8,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_SGRBG8_1X8,
+		.flags		= FMT_FLAGS_RAW_BAYER,
 	}, {
 		.name		= "RAW10 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG10,
@@ -81,6 +86,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.color		= FIMC_FMT_RAW10,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_SGRBG10_1X10,
+		.flags		= FMT_FLAGS_RAW_BAYER,
 	}, {
 		.name		= "RAW12 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG12,
@@ -88,6 +94,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.color		= FIMC_FMT_RAW12,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_SGRBG12_1X12,
+		.flags		= FMT_FLAGS_RAW_BAYER,
 	},
 };
 
@@ -95,10 +102,11 @@ static const struct fimc_fmt fimc_lite_formats[] = {
  * fimc_lite_find_format - lookup fimc color format by fourcc or media bus code
  * @pixelformat: fourcc to match, ignored if null
  * @mbus_code: media bus code to match, ignored if null
+ * @mask: the color format flags to match
  * @index: index to the fimc_lite_formats array, ignored if negative
  */
 static const struct fimc_fmt *fimc_lite_find_format(const u32 *pixelformat,
-					const u32 *mbus_code, int index)
+			const u32 *mbus_code, unsigned int mask, int index)
 {
 	const struct fimc_fmt *fmt, *def_fmt = NULL;
 	unsigned int i;
@@ -109,6 +117,8 @@ static const struct fimc_fmt *fimc_lite_find_format(const u32 *pixelformat,
 
 	for (i = 0; i < ARRAY_SIZE(fimc_lite_formats); ++i) {
 		fmt = &fimc_lite_formats[i];
+		if (mask && !(fmt->flags & mask))
+			continue;
 		if (pixelformat && fmt->fourcc == *pixelformat)
 			return fmt;
 		if (mbus_code && fmt->mbus_code == *mbus_code)
@@ -132,7 +142,7 @@ static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
 	if (sensor == NULL)
 		return -ENXIO;
 
-	if (fimc->fmt == NULL)
+	if (fimc->inp_frame.fmt == NULL || fimc->out_frame.fmt == NULL)
 		return -EINVAL;
 
 	/* Get sensor configuration data from the sensor subdev */
@@ -339,13 +349,13 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	const struct v4l2_pix_format_mplane *pixm = NULL;
 	struct fimc_lite *fimc = vq->drv_priv;
 	struct flite_frame *frame = &fimc->out_frame;
-	const struct fimc_fmt *fmt = fimc->fmt;
+	const struct fimc_fmt *fmt = frame->fmt;
 	unsigned long wh;
 	int i;
 
 	if (pfmt) {
 		pixm = &pfmt->fmt.pix_mp;
-		fmt = fimc_lite_find_format(&pixm->pixelformat, NULL, -1);
+		fmt = fimc_lite_find_format(&pixm->pixelformat, NULL, 0, -1);
 		wh = pixm->width * pixm->height;
 	} else {
 		wh = frame->f_width * frame->f_height;
@@ -374,10 +384,10 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	struct fimc_lite *fimc = vq->drv_priv;
 	int i;
 
-	if (fimc->fmt == NULL)
+	if (fimc->out_frame.fmt == NULL)
 		return -EINVAL;
 
-	for (i = 0; i < fimc->fmt->memplanes; i++) {
+	for (i = 0; i < fimc->out_frame.fmt->memplanes; i++) {
 		unsigned long size = fimc->payload[i];
 
 		if (vb2_plane_size(vb, i) < size) {
@@ -530,15 +540,7 @@ static const struct fimc_fmt *fimc_lite_try_format(struct fimc_lite *fimc,
 {
 	struct flite_drvdata *dd = fimc->dd;
 	const struct fimc_fmt *fmt;
-
-	fmt = fimc_lite_find_format(fourcc, code, 0);
-	if (WARN_ON(!fmt))
-		return NULL;
-
-	if (code)
-		*code = fmt->mbus_code;
-	if (fourcc)
-		*fourcc = fmt->fourcc;
+	unsigned int flags = 0;
 
 	if (pad == FLITE_SD_PAD_SINK) {
 		v4l_bound_align_image(width, 8, dd->max_width,
@@ -549,8 +551,18 @@ static const struct fimc_fmt *fimc_lite_try_format(struct fimc_lite *fimc,
 				      ffs(dd->out_width_align) - 1,
 				      height, 0, fimc->inp_frame.rect.height,
 				      0, 0);
+		flags = fimc->inp_frame.fmt->flags;
 	}
 
+	fmt = fimc_lite_find_format(fourcc, code, flags, 0);
+	if (WARN_ON(!fmt))
+		return NULL;
+
+	if (code)
+		*code = fmt->mbus_code;
+	if (fourcc)
+		*fourcc = fmt->fourcc;
+
 	v4l2_dbg(1, debug, &fimc->subdev, "code: 0x%x, %dx%d\n",
 		 code ? *code : 0, *width, *height);
 
@@ -629,7 +641,7 @@ static int fimc_lite_g_fmt_mplane(struct file *file, void *fh,
 	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
 	struct v4l2_plane_pix_format *plane_fmt = &pixm->plane_fmt[0];
 	struct flite_frame *frame = &fimc->out_frame;
-	const struct fimc_fmt *fmt = fimc->fmt;
+	const struct fimc_fmt *fmt = frame->fmt;
 
 	plane_fmt->bytesperline = (frame->f_width * fmt->depth[0]) / 8;
 	plane_fmt->sizeimage = plane_fmt->bytesperline * frame->f_height;
@@ -649,9 +661,22 @@ static int fimc_lite_try_fmt(struct fimc_lite *fimc,
 {
 	u32 bpl = pixm->plane_fmt[0].bytesperline;
 	struct flite_drvdata *dd = fimc->dd;
+	const struct fimc_fmt *inp_fmt = fimc->inp_frame.fmt;
 	const struct fimc_fmt *fmt;
 
-	fmt = fimc_lite_find_format(&pixm->pixelformat, NULL, 0);
+	if (WARN_ON(inp_fmt == NULL))
+		return -EINVAL;
+	/*
+	 * We allow some flexibility only for YUV formats. In case of raw
+	 * raw Bayer the FIMC-LITE's output format must match its camera
+	 * interface input format.
+	 */
+	if (inp_fmt->flags & FMT_FLAGS_YUV)
+		fmt = fimc_lite_find_format(&pixm->pixelformat, NULL,
+						inp_fmt->flags, 0);
+	else
+		fmt = inp_fmt;
+
 	if (WARN_ON(fmt == NULL))
 		return -EINVAL;
 	if (ffmt)
@@ -697,7 +722,7 @@ static int fimc_lite_s_fmt_mplane(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	fimc->fmt = fmt;
+	frame->fmt = fmt;
 	fimc->payload[0] = max((pixm->width * pixm->height * fmt->depth[0]) / 8,
 			       pixm->plane_fmt[0].sizeimage);
 	frame->f_width = pixm->width;
@@ -723,7 +748,7 @@ static int fimc_pipeline_validate(struct fimc_lite *fimc)
 			struct flite_frame *ff = &fimc->out_frame;
 			sink_fmt.format.width = ff->f_width;
 			sink_fmt.format.height = ff->f_height;
-			sink_fmt.format.code = fimc->fmt->mbus_code;
+			sink_fmt.format.code = fimc->inp_frame.fmt->mbus_code;
 		} else {
 			sink_fmt.pad = pad->index;
 			sink_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
@@ -991,7 +1016,7 @@ static int fimc_lite_subdev_enum_mbus_code(struct v4l2_subdev *sd,
 {
 	const struct fimc_fmt *fmt;
 
-	fmt = fimc_lite_find_format(NULL, NULL, code->index);
+	fmt = fimc_lite_find_format(NULL, NULL, 0, code->index);
 	if (!fmt)
 		return -EINVAL;
 	code->code = fmt->mbus_code;
@@ -1004,7 +1029,7 @@ static int fimc_lite_subdev_get_fmt(struct v4l2_subdev *sd,
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *mf = &fmt->format;
-	struct flite_frame *f = &fimc->out_frame;
+	struct flite_frame *f = &fimc->inp_frame;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
@@ -1014,7 +1039,7 @@ static int fimc_lite_subdev_get_fmt(struct v4l2_subdev *sd,
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
 
 	mutex_lock(&fimc->lock);
-	mf->code = fimc->fmt->mbus_code;
+	mf->code = f->fmt->mbus_code;
 
 	if (fmt->pad == FLITE_SD_PAD_SINK) {
 		/* full camera input frame size */
@@ -1066,7 +1091,7 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 	if (fmt->pad == FLITE_SD_PAD_SINK) {
 		sink->f_width = mf->width;
 		sink->f_height = mf->height;
-		fimc->fmt = ffmt;
+		sink->fmt = ffmt;
 		/* Set sink crop rectangle */
 		sink->rect.width = mf->width;
 		sink->rect.height = mf->height;
@@ -1078,7 +1103,7 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 		source->f_height = mf->height;
 	} else {
 		/* Allow changing format only on sink pad */
-		mf->code = fimc->fmt->mbus_code;
+		mf->code = sink->fmt->mbus_code;
 		mf->width = sink->rect.width;
 		mf->height = sink->rect.height;
 	}
@@ -1219,7 +1244,8 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 
 	memset(vfd, 0, sizeof(*vfd));
 
-	fimc->fmt = &fimc_lite_formats[0];
+	fimc->inp_frame.fmt = &fimc_lite_formats[0];
+	fimc->out_frame.fmt = &fimc_lite_formats[0];
 	atomic_set(&fimc->out_path, FIMC_IO_DMA);
 
 	snprintf(vfd->name, sizeof(vfd->name), "fimc-lite.%d.capture",
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 0b6380b..8a8d26f 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -70,11 +70,13 @@ struct fimc_lite_events {
  * @f_width: full pixel width
  * @f_height: full pixel height
  * @rect: crop/composition rectangle
+ * @fmt: pointer to pixel format description data structure
  */
 struct flite_frame {
 	u16 f_width;
 	u16 f_height;
 	struct v4l2_rect rect;
+	const struct fimc_fmt *fmt;
 };
 
 /**
@@ -111,7 +113,6 @@ struct flite_buffer {
  * @clock: FIMC-LITE gate clock
  * @regs: memory mapped io registers
  * @irq_queue: interrupt handler waitqueue
- * @fmt: pointer to color format description structure
  * @payload: image size in bytes (w x h x bpp)
  * @inp_frame: camera input frame structure
  * @out_frame: DMA output frame structure
@@ -150,7 +151,6 @@ struct fimc_lite {
 	void __iomem		*regs;
 	wait_queue_head_t	irq_queue;
 
-	const struct fimc_fmt	*fmt;
 	unsigned long		payload[FLITE_MAX_PLANES];
 	struct flite_frame	inp_frame;
 	struct flite_frame	out_frame;
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index 2363aff..e316d15 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -125,6 +125,8 @@ struct fimc_fmt {
 #define FMT_HAS_ALPHA		(1 << 3)
 #define FMT_FLAGS_COMPRESSED	(1 << 4)
 #define FMT_FLAGS_WRITEBACK	(1 << 5)
+#define FMT_FLAGS_RAW_BAYER	(1 << 6)
+#define FMT_FLAGS_YUV		(1 << 7)
 };
 
 enum fimc_subdev_index {
-- 
1.7.9.5

