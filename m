Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34164 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab1K2Rzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 12:55:33 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LVF00E7EOGJRCA0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Nov 2011 17:55:31 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVF00H3GOGIMY@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Nov 2011 17:55:31 +0000 (GMT)
Date: Tue, 29 Nov 2011 18:55:27 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 3/3] s5p-fimc: Add support for alpha component configuration
In-reply-to: <1322589327-4415-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1322589327-4415-4-git-send-email-s.nawrocki@samsung.com>
References: <1322589327-4415-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Exynos SoCs the FIMC IP allows to configure globally the alpha component
of all pixels for V4L2_PIX_FMT_RGB32, V4L2_PIX_FMT_RGB555 and
V4L2_PIX_FMT_RGB444 image formats. This patch adds a v4l2 control in order
to let the applications control the alpha component value.

The alpha value range depends on the pixel format, for RGB32 it's 0..255
(8-bits), for RGB555 - 0..1 (1-bit) and for RGB444 - 0..15 (4-bits). The
v4l2 control range is always 0..255 and the alpha component data width is
determined by currently set format on the V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
buffer queue. The applications need to match the alpha channel value range
and the pixel format since the driver will clamp the alpha component.
Depending on fourcc the valid alpha bits are:

 - V4L2_PIX_FMT_RGB555  [0]
 - V4L2_PIX_FMT_RGB444  [3:0]
 - V4L2_PIX_FMT_RGB32   [7:0]

When switching to a pixel format with smaller alpha component width the
currently set alpha value will be clamped to maximum value valid for current
format. When switching to a format with wider alpha the alpha value remains
unchanged.

The variant description data structure is extended with a new entry so an
additional control is created only where really supported by the hardware.

V4L2_PIX_FMT_RGB555 and V4L2_PIX_FMT_RGB444 formats are only valid for
V4L2_BUF_TYPE_VIDEO_CAPTURE buffer queue.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   16 ++++
 drivers/media/video/s5p-fimc/fimc-core.c    |  130 +++++++++++++++++++++------
 drivers/media/video/s5p-fimc/fimc-core.h    |   31 ++++++-
 drivers/media/video/s5p-fimc/fimc-reg.c     |   53 +++++++++---
 drivers/media/video/s5p-fimc/regs-fimc.h    |    5 +
 5 files changed, 193 insertions(+), 42 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 82d9ab6..8ca4d32 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -63,6 +63,8 @@ static int fimc_init_capture(struct fimc_dev *fimc)
 		fimc_hw_set_effect(ctx, false);
 		fimc_hw_set_output_path(ctx);
 		fimc_hw_set_out_dma(ctx);
+		if (fimc->variant->has_alpha)
+			fimc_hw_set_rgb_alpha(ctx);
 		clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
 	}
 	spin_unlock_irqrestore(&fimc->slock, flags);
@@ -154,6 +156,8 @@ int fimc_capture_config_update(struct fimc_ctx *ctx)
 		fimc_hw_set_rotation(ctx);
 		fimc_prepare_dma_offset(ctx, &ctx->d_frame);
 		fimc_hw_set_out_dma(ctx);
+		if (fimc->variant->has_alpha)
+			fimc_hw_set_rgb_alpha(ctx);
 		clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
 	}
 	spin_unlock(&ctx->slock);
@@ -812,6 +816,12 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 					  FIMC_SD_PAD_SOURCE);
 	if (!ff->fmt)
 		return -EINVAL;
+
+	/* Update RGB Alpha control state and value range */
+	ret = fimc_alpha_ctrl_update(ctx);
+	if (ret)
+		return ret;
+
 	/* Try to match format at the host and the sensor */
 	if (!fimc->vid_cap.user_subdev_api) {
 		mf->code   = ff->fmt->mbus_code;
@@ -1216,6 +1226,7 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct fimc_frame *ff;
 	struct fimc_fmt *ffmt;
+	int ret;
 
 	dbg("pad%d: code: 0x%x, %dx%d",
 	    fmt->pad, mf->code, mf->width, mf->height);
@@ -1235,6 +1246,11 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 		*mf = fmt->format;
 		return 0;
 	}
+	/* Update RGB Alpha control state and value range */
+	ret = fimc_alpha_ctrl_update(ctx);
+	if (ret)
+		return ret;
+
 	fimc_capture_mark_jpeg_xfer(ctx, fimc_fmt_is_jpeg(ffmt->color));
 
 	ff = fmt->pad == FIMC_SD_PAD_SINK ?
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 567e9ea..57d9e99 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -52,13 +52,29 @@ static struct fimc_fmt fimc_formats[] = {
 		.colplanes	= 1,
 		.flags		= FMT_FLAGS_M2M,
 	}, {
-		.name		= "XRGB-8-8-8-8, 32 bpp",
+		.name		= "ARGB8888, 32 bpp",
 		.fourcc		= V4L2_PIX_FMT_RGB32,
 		.depth		= { 32 },
 		.color		= S5P_FIMC_RGB888,
 		.memplanes	= 1,
 		.colplanes	= 1,
-		.flags		= FMT_FLAGS_M2M,
+		.flags		= FMT_FLAGS_M2M | FMT_HAS_ALPHA,
+	}, {
+		.name		= "ARGB1555",
+		.fourcc		= V4L2_PIX_FMT_RGB555,
+		.depth		= { 16 },
+		.color		= S5P_FIMC_RGB555,
+		.memplanes	= 1,
+		.colplanes	= 1,
+		.flags		= FMT_FLAGS_M2M_OUT | FMT_HAS_ALPHA,
+	}, {
+		.name		= "ARGB4444",
+		.fourcc		= V4L2_PIX_FMT_RGB444,
+		.depth		= { 16 },
+		.color		= S5P_FIMC_RGB444,
+		.memplanes	= 1,
+		.colplanes	= 1,
+		.flags		= FMT_FLAGS_M2M_OUT | FMT_HAS_ALPHA,
 	}, {
 		.name		= "YUV 4:2:2 packed, YCbYCr",
 		.fourcc		= V4L2_PIX_FMT_YUYV,
@@ -171,6 +187,14 @@ static struct fimc_fmt fimc_formats[] = {
 	},
 };
 
+static unsigned int get_m2m_fmt_flags(unsigned int stream_type)
+{
+	if (stream_type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return FMT_FLAGS_M2M_IN;
+	else
+		return FMT_FLAGS_M2M_OUT;
+}
+
 int fimc_check_scaler_ratio(struct fimc_ctx *ctx, int sw, int sh,
 			    int dw, int dh, int rotation)
 {
@@ -652,8 +676,11 @@ static void fimc_dma_run(void *priv)
 	if (ctx->state & (FIMC_DST_ADDR | FIMC_PARAMS))
 		fimc_hw_set_output_addr(fimc, &ctx->d_frame.paddr, -1);
 
-	if (ctx->state & FIMC_PARAMS)
+	if (ctx->state & FIMC_PARAMS) {
 		fimc_hw_set_out_dma(ctx);
+		if (fimc->variant->has_alpha)
+			fimc_hw_set_rgb_alpha(ctx);
+	}
 
 	fimc_activate_capture(ctx);
 
@@ -750,12 +777,11 @@ static struct vb2_ops fimc_qops = {
 #define ctrl_to_ctx(__ctrl) \
 	container_of((__ctrl)->handler, struct fimc_ctx, ctrl_handler)
 
-static int fimc_s_ctrl(struct v4l2_ctrl *ctrl)
+static int __fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_ctrl *ctrl)
 {
-	struct fimc_ctx *ctx = ctrl_to_ctx(ctrl);
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct samsung_fimc_variant *variant = fimc->variant;
-	unsigned long flags;
+	unsigned int flags = FIMC_DST_FMT | FIMC_SRC_FMT;
 	int ret = 0;
 
 	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
@@ -763,52 +789,63 @@ static int fimc_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_HFLIP:
-		spin_lock_irqsave(&ctx->slock, flags);
 		ctx->hflip = ctrl->val;
 		break;
 
 	case V4L2_CID_VFLIP:
-		spin_lock_irqsave(&ctx->slock, flags);
 		ctx->vflip = ctrl->val;
 		break;
 
 	case V4L2_CID_ROTATE:
 		if (fimc_capture_pending(fimc) ||
-		    fimc_ctx_state_is_set(FIMC_DST_FMT | FIMC_SRC_FMT, ctx)) {
+		    (ctx->state & flags) == flags) {
 			ret = fimc_check_scaler_ratio(ctx, ctx->s_frame.width,
 					ctx->s_frame.height, ctx->d_frame.width,
 					ctx->d_frame.height, ctrl->val);
-		}
-		if (ret) {
-			v4l2_err(fimc->m2m.vfd, "Out of scaler range\n");
-			return -EINVAL;
+			if (ret)
+				return -EINVAL;
 		}
 		if ((ctrl->val == 90 || ctrl->val == 270) &&
 		    !variant->has_out_rot)
 			return -EINVAL;
-		spin_lock_irqsave(&ctx->slock, flags);
+
 		ctx->rotation = ctrl->val;
 		break;
 
-	default:
-		v4l2_err(fimc->v4l2_dev, "Invalid control: 0x%X\n", ctrl->id);
-		return -EINVAL;
+	case V4L2_CID_ALPHA_COMPONENT:
+		ctx->d_frame.alpha = ctrl->val;
+		break;
 	}
 	ctx->state |= FIMC_PARAMS;
 	set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
-	spin_unlock_irqrestore(&ctx->slock, flags);
 	return 0;
 }
 
+static int fimc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct fimc_ctx *ctx = ctrl_to_ctx(ctrl);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ctx->slock, flags);
+	ret = __fimc_s_ctrl(ctx, ctrl);
+	spin_unlock_irqrestore(&ctx->slock, flags);
+
+	return ret;
+}
+
 static const struct v4l2_ctrl_ops fimc_ctrl_ops = {
 	.s_ctrl = fimc_s_ctrl,
 };
 
 int fimc_ctrls_create(struct fimc_ctx *ctx)
 {
+	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	unsigned int max_alpha = fimc_get_alpha_mask(ctx->d_frame.fmt);
+
 	if (ctx->ctrls_rdy)
 		return 0;
-	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 4);
 
 	ctx->ctrl_rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
 				     V4L2_CID_HFLIP, 0, 1, 1, 0);
@@ -816,6 +853,13 @@ int fimc_ctrls_create(struct fimc_ctx *ctx)
 				    V4L2_CID_VFLIP, 0, 1, 1, 0);
 	ctx->ctrl_vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
 				    V4L2_CID_ROTATE, 0, 270, 90, 0);
+	if (variant->has_alpha)
+		ctx->ctrl_alpha = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+				    &fimc_ctrl_ops, V4L2_CID_ALPHA_COMPONENT,
+				    0, max_alpha, 1, 0);
+	else
+		ctx->ctrl_alpha = NULL;
+
 	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
 
 	return ctx->ctrl_handler.error;
@@ -831,6 +875,8 @@ void fimc_ctrls_delete(struct fimc_ctx *ctx)
 
 void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active)
 {
+	unsigned int has_alpha = ctx->d_frame.fmt->flags & FMT_HAS_ALPHA;
+
 	if (!ctx->ctrls_rdy)
 		return;
 
@@ -838,6 +884,8 @@ void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active)
 	v4l2_ctrl_activate(ctx->ctrl_rotate, active);
 	v4l2_ctrl_activate(ctx->ctrl_hflip, active);
 	v4l2_ctrl_activate(ctx->ctrl_vflip, active);
+	if (ctx->ctrl_alpha)
+		v4l2_ctrl_activate(ctx->ctrl_alpha, active && has_alpha);
 
 	if (active) {
 		ctx->rotation = ctx->ctrl_rotate->val;
@@ -851,6 +899,23 @@ void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active)
 	mutex_unlock(&ctx->ctrl_handler.lock);
 }
 
+int fimc_alpha_ctrl_update(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct samsung_fimc_variant *variant = fimc->variant;
+	unsigned int max;
+
+	if (!variant->has_alpha)
+		return 0;
+
+	if (ctx->ctrl_alpha == NULL)
+		return -EINVAL;
+
+	max = fimc_get_alpha_mask(ctx->d_frame.fmt);
+
+	return v4l2_ctrl_update_range(ctx->ctrl_alpha, 0, max, 1, 0);
+}
+
 /*
  * V4L2 ioctl handlers
  */
@@ -874,7 +939,8 @@ static int fimc_m2m_enum_fmt_mplane(struct file *file, void *priv,
 {
 	struct fimc_fmt *fmt;
 
-	fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_M2M, f->index);
+	fmt = fimc_find_format(NULL, NULL, get_m2m_fmt_flags(f->type),
+			       f->index);
 	if (!fmt)
 		return -EINVAL;
 
@@ -938,6 +1004,7 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
 	pix->colorspace	= V4L2_COLORSPACE_JPEG;
 	pix->field = V4L2_FIELD_NONE;
 	pix->num_planes = fmt->memplanes;
+	pix->pixelformat = fmt->fourcc;
 	pix->height = height;
 	pix->width = width;
 
@@ -1017,7 +1084,8 @@ static int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
 
 	dbg("w: %d, h: %d", pix->width, pix->height);
 
-	fmt = fimc_find_format(&pix->pixelformat, NULL, FMT_FLAGS_M2M, 0);
+	fmt = fimc_find_format(&pix->pixelformat, NULL,
+			       get_m2m_fmt_flags(f->type), 0);
 	if (WARN(fmt == NULL, "Pixel format lookup failed"))
 		return -EINVAL;
 
@@ -1087,9 +1155,15 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 
 	pix = &f->fmt.pix_mp;
 	frame->fmt = fimc_find_format(&pix->pixelformat, NULL,
-				      FMT_FLAGS_M2M, 0);
+				      get_m2m_fmt_flags(f->type), 0);
 	if (!frame->fmt)
 		return -EINVAL;
+	frame->fmt->fourcc = pix->pixelformat;
+
+	/* Update RGB Alpha control state and value range */
+	ret = fimc_alpha_ctrl_update(ctx);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < frame->fmt->colplanes; i++) {
 		frame->payload[i] =
@@ -1374,6 +1448,12 @@ static int fimc_m2m_open(struct file *file)
 	if (!ctx)
 		return -ENOMEM;
 	v4l2_fh_init(&ctx->fh, fimc->m2m.vfd);
+	ctx->fimc_dev = fimc;
+
+	/* Default color format */
+	ctx->s_frame.fmt = &fimc_formats[0];
+	ctx->d_frame.fmt = &fimc_formats[0];
+
 	ret = fimc_ctrls_create(ctx);
 	if (ret)
 		goto error_fh;
@@ -1383,10 +1463,6 @@ static int fimc_m2m_open(struct file *file)
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
 
-	ctx->fimc_dev = fimc;
-	/* Default color format */
-	ctx->s_frame.fmt = &fimc_formats[0];
-	ctx->d_frame.fmt = &fimc_formats[0];
 	/* Setup the device context for memory-to-memory mode */
 	ctx->state = FIMC_CTX_M2M;
 	ctx->flags = 0;
@@ -1892,6 +1968,7 @@ static struct samsung_fimc_variant fimc0_variant_exynos4 = {
 	.has_cam_if	 = 1,
 	.has_cistatus2	 = 1,
 	.has_mainscaler_ext = 1,
+	.has_alpha	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 2,
@@ -1905,6 +1982,7 @@ static struct samsung_fimc_variant fimc3_variant_exynos4 = {
 	.has_cam_if	 = 1,
 	.has_cistatus2	 = 1,
 	.has_mainscaler_ext = 1,
+	.has_alpha	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 2,
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index c7f01c4..21e4ad4 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -85,11 +85,14 @@ enum fimc_datapath {
 };
 
 enum fimc_color_fmt {
-	S5P_FIMC_RGB565 = 0x10,
+	S5P_FIMC_RGB444 = 0x10,
+	S5P_FIMC_RGB555,
+	S5P_FIMC_RGB565,
 	S5P_FIMC_RGB666,
 	S5P_FIMC_RGB888,
 	S5P_FIMC_RGB30_LOCAL,
 	S5P_FIMC_YCBCR420 = 0x20,
+	S5P_FIMC_YCBCR422,
 	S5P_FIMC_YCBYCR422,
 	S5P_FIMC_YCRYCB422,
 	S5P_FIMC_CBYCRY422,
@@ -160,8 +163,11 @@ struct fimc_fmt {
 	u16	colplanes;
 	u8	depth[VIDEO_MAX_PLANES];
 	u16	flags;
-#define FMT_FLAGS_CAM	(1 << 0)
-#define FMT_FLAGS_M2M	(1 << 1)
+#define FMT_FLAGS_CAM		(1 << 0)
+#define FMT_FLAGS_M2M_IN	(1 << 1)
+#define FMT_FLAGS_M2M_OUT	(1 << 2)
+#define FMT_FLAGS_M2M		(1 << 1 | 1 << 2)
+#define FMT_HAS_ALPHA		(1 << 3)
 };
 
 /**
@@ -283,6 +289,7 @@ struct fimc_frame {
 	struct fimc_addr	paddr;
 	struct fimc_dma_offset	dma_offset;
 	struct fimc_fmt		*fmt;
+	u8			alpha;
 };
 
 /**
@@ -387,6 +394,7 @@ struct samsung_fimc_variant {
 	unsigned int	has_cistatus2:1;
 	unsigned int	has_mainscaler_ext:1;
 	unsigned int	has_cam_if:1;
+	unsigned int	has_alpha:1;
 	struct fimc_pix_limit *pix_limit;
 	u16		min_inp_pixsize;
 	u16		min_out_pixsize;
@@ -482,7 +490,8 @@ struct fimc_dev {
  * @ctrl_handler:	v4l2 controls handler
  * @ctrl_rotate		image rotation control
  * @ctrl_hflip		horizontal flip control
- * @ctrl_vflip		vartical flip control
+ * @ctrl_vflip		vertical flip control
+ * @ctrl_alpha		RGB alpha control
  * @ctrls_rdy:		true if the control handler is initialized
  */
 struct fimc_ctx {
@@ -509,6 +518,7 @@ struct fimc_ctx {
 	struct v4l2_ctrl	*ctrl_rotate;
 	struct v4l2_ctrl	*ctrl_hflip;
 	struct v4l2_ctrl	*ctrl_vflip;
+	struct v4l2_ctrl	*ctrl_alpha;
 	bool			ctrls_rdy;
 };
 
@@ -578,6 +588,17 @@ static inline int tiled_fmt(struct fimc_fmt *fmt)
 	return fmt->fourcc == V4L2_PIX_FMT_NV12MT;
 }
 
+/* Return the alpha component bit mask */
+static inline int fimc_get_alpha_mask(struct fimc_fmt *fmt)
+{
+	switch (fmt->color) {
+	case S5P_FIMC_RGB444: 	return 0x0f;
+	case S5P_FIMC_RGB555: 	return 0x01;
+	case S5P_FIMC_RGB888: 	return 0xff;
+	default: 		return 0;
+	};
+}
+
 static inline void fimc_hw_clear_irq(struct fimc_dev *dev)
 {
 	u32 cfg = readl(dev->regs + S5P_CIGCTRL);
@@ -674,6 +695,7 @@ void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
 void fimc_hw_set_mainscaler(struct fimc_ctx *ctx);
 void fimc_hw_en_capture(struct fimc_ctx *ctx);
 void fimc_hw_set_effect(struct fimc_ctx *ctx, bool active);
+void fimc_hw_set_rgb_alpha(struct fimc_ctx *ctx);
 void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
 void fimc_hw_set_input_path(struct fimc_ctx *ctx);
 void fimc_hw_set_output_path(struct fimc_ctx *ctx);
@@ -695,6 +717,7 @@ int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
 int fimc_ctrls_create(struct fimc_ctx *ctx);
 void fimc_ctrls_delete(struct fimc_ctx *ctx);
 void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active);
+int fimc_alpha_ctrl_update(struct fimc_ctx *ctx);
 int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f);
 void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
 			       struct v4l2_pix_format_mplane *pix);
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 44f5c2d..15466d0 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -117,7 +117,7 @@ void fimc_hw_set_target_format(struct fimc_ctx *ctx)
 		  S5P_CITRGFMT_VSIZE_MASK);
 
 	switch (frame->fmt->color) {
-	case S5P_FIMC_RGB565...S5P_FIMC_RGB888:
+	case S5P_FIMC_RGB444...S5P_FIMC_RGB888:
 		cfg |= S5P_CITRGFMT_RGB;
 		break;
 	case S5P_FIMC_YCBCR420:
@@ -175,6 +175,7 @@ void fimc_hw_set_out_dma(struct fimc_ctx *ctx)
 	struct fimc_dev *dev = ctx->fimc_dev;
 	struct fimc_frame *frame = &ctx->d_frame;
 	struct fimc_dma_offset *offset = &frame->dma_offset;
+	struct fimc_fmt *fmt = frame->fmt;
 
 	/* Set the input dma offsets. */
 	cfg = 0;
@@ -198,15 +199,22 @@ void fimc_hw_set_out_dma(struct fimc_ctx *ctx)
 	cfg = readl(dev->regs + S5P_CIOCTRL);
 
 	cfg &= ~(S5P_CIOCTRL_ORDER2P_MASK | S5P_CIOCTRL_ORDER422_MASK |
-		 S5P_CIOCTRL_YCBCR_PLANE_MASK);
+		 S5P_CIOCTRL_YCBCR_PLANE_MASK | S5P_CIOCTRL_RGB16FMT_MASK);
 
-	if (frame->fmt->colplanes == 1)
+	if (fmt->colplanes == 1)
 		cfg |= ctx->out_order_1p;
-	else if (frame->fmt->colplanes == 2)
+	else if (fmt->colplanes == 2)
 		cfg |= ctx->out_order_2p | S5P_CIOCTRL_YCBCR_2PLANE;
-	else if (frame->fmt->colplanes == 3)
+	else if (fmt->colplanes == 3)
 		cfg |= S5P_CIOCTRL_YCBCR_3PLANE;
 
+	if (fmt->color == S5P_FIMC_RGB565)
+		cfg |= S5P_CIOCTRL_RGB565;
+	else if (fmt->color == S5P_FIMC_RGB555)
+		cfg |= S5P_CIOCTRL_ARGB1555;
+	else if (fmt->color == S5P_FIMC_RGB444)
+		cfg |= S5P_CIOCTRL_ARGB4444;
+
 	writel(cfg, dev->regs + S5P_CIOCTRL);
 }
 
@@ -278,22 +286,28 @@ static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 	if (sc->copy_mode)
 		cfg |= S5P_CISCCTRL_ONE2ONE;
 
-
 	if (ctx->in_path == FIMC_DMA) {
-		if (src_frame->fmt->color == S5P_FIMC_RGB565)
+		switch (src_frame->fmt->color) {
+		case S5P_FIMC_RGB565:
 			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB565;
-		else if (src_frame->fmt->color == S5P_FIMC_RGB666)
+			break;
+		case S5P_FIMC_RGB666:
 			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB666;
-		else if (src_frame->fmt->color == S5P_FIMC_RGB888)
+			break;
+		case S5P_FIMC_RGB888:
 			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB888;
+			break;
+		}
 	}
 
 	if (ctx->out_path == FIMC_DMA) {
-		if (dst_frame->fmt->color == S5P_FIMC_RGB565)
+		u32 color = dst_frame->fmt->color;
+
+		if (color >= S5P_FIMC_RGB444 && color <= S5P_FIMC_RGB565)
 			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB565;
-		else if (dst_frame->fmt->color == S5P_FIMC_RGB666)
+		else if (color == S5P_FIMC_RGB666)
 			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB666;
-		else if (dst_frame->fmt->color == S5P_FIMC_RGB888)
+		else if (color == S5P_FIMC_RGB888)
 			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB888;
 	} else {
 		cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB888;
@@ -379,6 +393,21 @@ void fimc_hw_set_effect(struct fimc_ctx *ctx, bool active)
 	writel(cfg, dev->regs + S5P_CIIMGEFF);
 }
 
+void fimc_hw_set_rgb_alpha(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *frame = &ctx->d_frame;
+	u32 cfg;
+
+	if (!(frame->fmt->flags & FMT_HAS_ALPHA))
+		return;
+
+	cfg = readl(dev->regs + S5P_CIOCTRL);
+	cfg &= ~S5P_CIOCTRL_ALPHA_OUT_MASK;
+	cfg |= (frame->alpha << 4);
+	writel(cfg, dev->regs + S5P_CIOCTRL);
+}
+
 static void fimc_hw_set_in_dma_size(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
index c8e3b94..c7a5bc5 100644
--- a/drivers/media/video/s5p-fimc/regs-fimc.h
+++ b/drivers/media/video/s5p-fimc/regs-fimc.h
@@ -107,6 +107,11 @@
 #define S5P_CIOCTRL_YCBCR_3PLANE	(0 << 3)
 #define S5P_CIOCTRL_YCBCR_2PLANE	(1 << 3)
 #define S5P_CIOCTRL_YCBCR_PLANE_MASK	(1 << 3)
+#define S5P_CIOCTRL_ALPHA_OUT_MASK	(0xff << 4)
+#define S5P_CIOCTRL_RGB16FMT_MASK	(3 << 16)
+#define S5P_CIOCTRL_RGB565		(0 << 16)
+#define S5P_CIOCTRL_ARGB1555		(1 << 16)
+#define S5P_CIOCTRL_ARGB4444		(2 << 16)
 #define S5P_CIOCTRL_ORDER2P_SHIFT	(24)
 #define S5P_CIOCTRL_ORDER2P_MASK	(3 << 24)
 #define S5P_CIOCTRL_ORDER422_2P_LSB_CRCB (0 << 24)
-- 
1.7.7.2

