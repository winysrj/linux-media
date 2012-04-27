Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36945 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997Ab2D0JxV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M34009DCU55WT00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:29 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3400I6LU4O93@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:17 +0100 (BST)
Date: Fri, 27 Apr 2012 11:53:01 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 08/13] s5p-fimc: Prefix format enumerations with FIMC_FMT_
In-reply-to: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-9-git-send-email-s.nawrocki@samsung.com>
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prefix the pixel format enumerations with FIMC_FMT_ to make it more clear,
especially when used in new IP drivers, like fimc-lite, etc. Also add IO_
prefix in the input/output enumeration.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    4 +-
 drivers/media/video/s5p-fimc/fimc-core.c    |   56 +++++++++++++--------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   45 +++++++++++----------
 drivers/media/video/s5p-fimc/fimc-m2m.c     |    4 +-
 drivers/media/video/s5p-fimc/fimc-reg.c     |   48 +++++++++++------------
 5 files changed, 81 insertions(+), 76 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index e6e5496..18f686a1 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1519,8 +1519,8 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 		return -ENOMEM;
 
 	ctx->fimc_dev	 = fimc;
-	ctx->in_path	 = FIMC_CAMERA;
-	ctx->out_path	 = FIMC_DMA;
+	ctx->in_path	 = FIMC_IO_CAMERA;
+	ctx->out_path	 = FIMC_IO_DMA;
 	ctx->state	 = FIMC_CTX_CAP;
 	ctx->s_frame.fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
 	ctx->d_frame.fmt = ctx->s_frame.fmt;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index e4c58e9..2da6638 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -40,7 +40,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "RGB565",
 		.fourcc		= V4L2_PIX_FMT_RGB565,
 		.depth		= { 16 },
-		.color		= S5P_FIMC_RGB565,
+		.color		= FIMC_FMT_RGB565,
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.flags		= FMT_FLAGS_M2M,
@@ -48,7 +48,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "BGR666",
 		.fourcc		= V4L2_PIX_FMT_BGR666,
 		.depth		= { 32 },
-		.color		= S5P_FIMC_RGB666,
+		.color		= FIMC_FMT_RGB666,
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.flags		= FMT_FLAGS_M2M,
@@ -56,7 +56,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "ARGB8888, 32 bpp",
 		.fourcc		= V4L2_PIX_FMT_RGB32,
 		.depth		= { 32 },
-		.color		= S5P_FIMC_RGB888,
+		.color		= FIMC_FMT_RGB888,
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.flags		= FMT_FLAGS_M2M | FMT_HAS_ALPHA,
@@ -64,7 +64,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "ARGB1555",
 		.fourcc		= V4L2_PIX_FMT_RGB555,
 		.depth		= { 16 },
-		.color		= S5P_FIMC_RGB555,
+		.color		= FIMC_FMT_RGB555,
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.flags		= FMT_FLAGS_M2M_OUT | FMT_HAS_ALPHA,
@@ -72,7 +72,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "ARGB4444",
 		.fourcc		= V4L2_PIX_FMT_RGB444,
 		.depth		= { 16 },
-		.color		= S5P_FIMC_RGB444,
+		.color		= FIMC_FMT_RGB444,
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.flags		= FMT_FLAGS_M2M_OUT | FMT_HAS_ALPHA,
@@ -80,7 +80,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "YUV 4:2:2 packed, YCbYCr",
 		.fourcc		= V4L2_PIX_FMT_YUYV,
 		.depth		= { 16 },
-		.color		= S5P_FIMC_YCBYCR422,
+		.color		= FIMC_FMT_YCBYCR422,
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
@@ -89,7 +89,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "YUV 4:2:2 packed, CbYCrY",
 		.fourcc		= V4L2_PIX_FMT_UYVY,
 		.depth		= { 16 },
-		.color		= S5P_FIMC_CBYCRY422,
+		.color		= FIMC_FMT_CBYCRY422,
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
@@ -98,7 +98,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "YUV 4:2:2 packed, CrYCbY",
 		.fourcc		= V4L2_PIX_FMT_VYUY,
 		.depth		= { 16 },
-		.color		= S5P_FIMC_CRYCBY422,
+		.color		= FIMC_FMT_CRYCBY422,
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_VYUY8_2X8,
@@ -107,7 +107,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "YUV 4:2:2 packed, YCrYCb",
 		.fourcc		= V4L2_PIX_FMT_YVYU,
 		.depth		= { 16 },
-		.color		= S5P_FIMC_YCRYCB422,
+		.color		= FIMC_FMT_YCRYCB422,
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
@@ -116,7 +116,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "YUV 4:2:2 planar, Y/Cb/Cr",
 		.fourcc		= V4L2_PIX_FMT_YUV422P,
 		.depth		= { 12 },
-		.color		= S5P_FIMC_YCBYCR422,
+		.color		= FIMC_FMT_YCBYCR422,
 		.memplanes	= 1,
 		.colplanes	= 3,
 		.flags		= FMT_FLAGS_M2M,
@@ -124,7 +124,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "YUV 4:2:2 planar, Y/CbCr",
 		.fourcc		= V4L2_PIX_FMT_NV16,
 		.depth		= { 16 },
-		.color		= S5P_FIMC_YCBYCR422,
+		.color		= FIMC_FMT_YCBYCR422,
 		.memplanes	= 1,
 		.colplanes	= 2,
 		.flags		= FMT_FLAGS_M2M,
@@ -132,7 +132,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "YUV 4:2:2 planar, Y/CrCb",
 		.fourcc		= V4L2_PIX_FMT_NV61,
 		.depth		= { 16 },
-		.color		= S5P_FIMC_YCRYCB422,
+		.color		= FIMC_FMT_YCRYCB422,
 		.memplanes	= 1,
 		.colplanes	= 2,
 		.flags		= FMT_FLAGS_M2M,
@@ -140,7 +140,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "YUV 4:2:0 planar, YCbCr",
 		.fourcc		= V4L2_PIX_FMT_YUV420,
 		.depth		= { 12 },
-		.color		= S5P_FIMC_YCBCR420,
+		.color		= FIMC_FMT_YCBCR420,
 		.memplanes	= 1,
 		.colplanes	= 3,
 		.flags		= FMT_FLAGS_M2M,
@@ -148,14 +148,14 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "YUV 4:2:0 planar, Y/CbCr",
 		.fourcc		= V4L2_PIX_FMT_NV12,
 		.depth		= { 12 },
-		.color		= S5P_FIMC_YCBCR420,
+		.color		= FIMC_FMT_YCBCR420,
 		.memplanes	= 1,
 		.colplanes	= 2,
 		.flags		= FMT_FLAGS_M2M,
 	}, {
 		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr",
 		.fourcc		= V4L2_PIX_FMT_NV12M,
-		.color		= S5P_FIMC_YCBCR420,
+		.color		= FIMC_FMT_YCBCR420,
 		.depth		= { 8, 4 },
 		.memplanes	= 2,
 		.colplanes	= 2,
@@ -163,7 +163,7 @@ static struct fimc_fmt fimc_formats[] = {
 	}, {
 		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cb/Cr",
 		.fourcc		= V4L2_PIX_FMT_YUV420M,
-		.color		= S5P_FIMC_YCBCR420,
+		.color		= FIMC_FMT_YCBCR420,
 		.depth		= { 8, 2, 2 },
 		.memplanes	= 3,
 		.colplanes	= 3,
@@ -171,7 +171,7 @@ static struct fimc_fmt fimc_formats[] = {
 	}, {
 		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr, tiled",
 		.fourcc		= V4L2_PIX_FMT_NV12MT,
-		.color		= S5P_FIMC_YCBCR420,
+		.color		= FIMC_FMT_YCBCR420,
 		.depth		= { 8, 4 },
 		.memplanes	= 2,
 		.colplanes	= 2,
@@ -179,7 +179,7 @@ static struct fimc_fmt fimc_formats[] = {
 	}, {
 		.name		= "JPEG encoded data",
 		.fourcc		= V4L2_PIX_FMT_JPEG,
-		.color		= S5P_FIMC_JPEG,
+		.color		= FIMC_FMT_JPEG,
 		.depth		= { 8 },
 		.memplanes	= 1,
 		.colplanes	= 1,
@@ -359,7 +359,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		case 3:
 			paddr->cb = (u32)(paddr->y + pix_size);
 			/* decompose Y into Y/Cb/Cr */
-			if (S5P_FIMC_YCBCR420 == frame->fmt->color)
+			if (FIMC_FMT_YCBCR420 == frame->fmt->color)
 				paddr->cr = (u32)(paddr->cb
 						+ (pix_size >> 2));
 			else /* 422 */
@@ -392,16 +392,16 @@ void fimc_set_yuv_order(struct fimc_ctx *ctx)
 
 	/* Set order for 1 plane input formats. */
 	switch (ctx->s_frame.fmt->color) {
-	case S5P_FIMC_YCRYCB422:
+	case FIMC_FMT_YCRYCB422:
 		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_CBYCRY;
 		break;
-	case S5P_FIMC_CBYCRY422:
+	case FIMC_FMT_CBYCRY422:
 		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_YCRYCB;
 		break;
-	case S5P_FIMC_CRYCBY422:
+	case FIMC_FMT_CRYCBY422:
 		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_YCBYCR;
 		break;
-	case S5P_FIMC_YCBYCR422:
+	case FIMC_FMT_YCBYCR422:
 	default:
 		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_CRYCBY;
 		break;
@@ -409,16 +409,16 @@ void fimc_set_yuv_order(struct fimc_ctx *ctx)
 	dbg("ctx->in_order_1p= %d", ctx->in_order_1p);
 
 	switch (ctx->d_frame.fmt->color) {
-	case S5P_FIMC_YCRYCB422:
+	case FIMC_FMT_YCRYCB422:
 		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_CBYCRY;
 		break;
-	case S5P_FIMC_CBYCRY422:
+	case FIMC_FMT_CBYCRY422:
 		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_YCRYCB;
 		break;
-	case S5P_FIMC_CRYCBY422:
+	case FIMC_FMT_CRYCBY422:
 		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_YCBYCR;
 		break;
-	case S5P_FIMC_YCBYCR422:
+	case FIMC_FMT_YCBYCR422:
 	default:
 		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_CRYCBY;
 		break;
@@ -451,7 +451,7 @@ void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 			f->dma_offset.cb_h >>= 1;
 			f->dma_offset.cr_h >>= 1;
 		}
-		if (f->fmt->color == S5P_FIMC_YCBCR420) {
+		if (f->fmt->color == FIMC_FMT_YCBCR420) {
 			f->dma_offset.cb_v >>= 1;
 			f->dma_offset.cr_v >>= 1;
 		}
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 25a3917..e3078d3 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -76,26 +76,31 @@ enum fimc_dev_flags {
 #define fimc_capture_busy(dev) test_bit(ST_CAPT_BUSY, &(dev)->state)
 
 enum fimc_datapath {
-	FIMC_CAMERA,
-	FIMC_DMA,
-	FIMC_LCDFIFO,
-	FIMC_WRITEBACK
+	FIMC_IO_NONE,
+	FIMC_IO_CAMERA,
+	FIMC_IO_DMA,
+	FIMC_IO_LCDFIFO,
+	FIMC_IO_WRITEBACK,
+	FIMC_IO_ISP,
 };
 
 enum fimc_color_fmt {
-	S5P_FIMC_RGB444 = 0x10,
-	S5P_FIMC_RGB555,
-	S5P_FIMC_RGB565,
-	S5P_FIMC_RGB666,
-	S5P_FIMC_RGB888,
-	S5P_FIMC_RGB30_LOCAL,
-	S5P_FIMC_YCBCR420 = 0x20,
-	S5P_FIMC_YCBYCR422,
-	S5P_FIMC_YCRYCB422,
-	S5P_FIMC_CBYCRY422,
-	S5P_FIMC_CRYCBY422,
-	S5P_FIMC_YCBCR444_LOCAL,
-	S5P_FIMC_JPEG = 0x40,
+	FIMC_FMT_RGB444 = 0x10,
+	FIMC_FMT_RGB555,
+	FIMC_FMT_RGB565,
+	FIMC_FMT_RGB666,
+	FIMC_FMT_RGB888,
+	FIMC_FMT_RGB30_LOCAL,
+	FIMC_FMT_YCBCR420 = 0x20,
+	FIMC_FMT_YCBYCR422,
+	FIMC_FMT_YCRYCB422,
+	FIMC_FMT_CBYCRY422,
+	FIMC_FMT_CRYCBY422,
+	FIMC_FMT_YCBCR444_LOCAL,
+	FIMC_FMT_JPEG = 0x40,
+	FIMC_FMT_RAW8 = 0x80,
+	FIMC_FMT_RAW10,
+	FIMC_FMT_RAW12,
 };
 
 #define fimc_fmt_is_rgb(x) (!!((x) & 0x10))
@@ -559,9 +564,9 @@ static inline int tiled_fmt(struct fimc_fmt *fmt)
 static inline int fimc_get_alpha_mask(struct fimc_fmt *fmt)
 {
 	switch (fmt->color) {
-	case S5P_FIMC_RGB444:	return 0x0f;
-	case S5P_FIMC_RGB555:	return 0x01;
-	case S5P_FIMC_RGB888:	return 0xff;
+	case FIMC_FMT_RGB444:	return 0x0f;
+	case FIMC_FMT_RGB555:	return 0x01;
+	case FIMC_FMT_RGB888:	return 0xff;
 	default:		return 0;
 	};
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-m2m.c b/drivers/media/video/s5p-fimc/fimc-m2m.c
index a693bed..0f15b26 100644
--- a/drivers/media/video/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/video/s5p-fimc/fimc-m2m.c
@@ -676,8 +676,8 @@ static int fimc_m2m_open(struct file *file)
 	/* Setup the device context for memory-to-memory mode */
 	ctx->state = FIMC_CTX_M2M;
 	ctx->flags = 0;
-	ctx->in_path = FIMC_DMA;
-	ctx->out_path = FIMC_DMA;
+	ctx->in_path = FIMC_IO_DMA;
+	ctx->out_path = FIMC_IO_DMA;
 
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(fimc->m2m.m2m_dev, ctx, queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 9af3c83..78c95d7 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -84,13 +84,13 @@ void fimc_hw_set_rotation(struct fimc_ctx *ctx)
 	 * in direct fifo output mode.
 	 */
 	if (ctx->rotation == 90 || ctx->rotation == 270) {
-		if (ctx->out_path == FIMC_LCDFIFO)
+		if (ctx->out_path == FIMC_IO_LCDFIFO)
 			cfg |= FIMC_REG_CITRGFMT_INROT90;
 		else
 			cfg |= FIMC_REG_CITRGFMT_OUTROT90;
 	}
 
-	if (ctx->out_path == FIMC_DMA) {
+	if (ctx->out_path == FIMC_IO_DMA) {
 		cfg |= fimc_hw_get_target_flip(ctx);
 		writel(cfg, dev->regs + FIMC_REG_CITRGFMT);
 	} else {
@@ -116,13 +116,13 @@ void fimc_hw_set_target_format(struct fimc_ctx *ctx)
 		 FIMC_REG_CITRGFMT_VSIZE_MASK);
 
 	switch (frame->fmt->color) {
-	case S5P_FIMC_RGB444...S5P_FIMC_RGB888:
+	case FIMC_FMT_RGB444...FIMC_FMT_RGB888:
 		cfg |= FIMC_REG_CITRGFMT_RGB;
 		break;
-	case S5P_FIMC_YCBCR420:
+	case FIMC_FMT_YCBCR420:
 		cfg |= FIMC_REG_CITRGFMT_YCBCR420;
 		break;
-	case S5P_FIMC_YCBYCR422...S5P_FIMC_CRYCBY422:
+	case FIMC_FMT_YCBYCR422...FIMC_FMT_CRYCBY422:
 		if (frame->fmt->colplanes == 1)
 			cfg |= FIMC_REG_CITRGFMT_YCBCR422_1P;
 		else
@@ -199,11 +199,11 @@ void fimc_hw_set_out_dma(struct fimc_ctx *ctx)
 	else if (fmt->colplanes == 3)
 		cfg |= FIMC_REG_CIOCTRL_YCBCR_3PLANE;
 
-	if (fmt->color == S5P_FIMC_RGB565)
+	if (fmt->color == FIMC_FMT_RGB565)
 		cfg |= FIMC_REG_CIOCTRL_RGB565;
-	else if (fmt->color == S5P_FIMC_RGB555)
+	else if (fmt->color == FIMC_FMT_RGB555)
 		cfg |= FIMC_REG_CIOCTRL_ARGB1555;
-	else if (fmt->color == S5P_FIMC_RGB444)
+	else if (fmt->color == FIMC_FMT_RGB444)
 		cfg |= FIMC_REG_CIOCTRL_ARGB4444;
 
 	writel(cfg, dev->regs + FIMC_REG_CIOCTRL);
@@ -276,28 +276,28 @@ static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 	if (sc->copy_mode)
 		cfg |= FIMC_REG_CISCCTRL_ONE2ONE;
 
-	if (ctx->in_path == FIMC_DMA) {
+	if (ctx->in_path == FIMC_IO_DMA) {
 		switch (src_frame->fmt->color) {
-		case S5P_FIMC_RGB565:
+		case FIMC_FMT_RGB565:
 			cfg |= FIMC_REG_CISCCTRL_INRGB_FMT_RGB565;
 			break;
-		case S5P_FIMC_RGB666:
+		case FIMC_FMT_RGB666:
 			cfg |= FIMC_REG_CISCCTRL_INRGB_FMT_RGB666;
 			break;
-		case S5P_FIMC_RGB888:
+		case FIMC_FMT_RGB888:
 			cfg |= FIMC_REG_CISCCTRL_INRGB_FMT_RGB888;
 			break;
 		}
 	}
 
-	if (ctx->out_path == FIMC_DMA) {
+	if (ctx->out_path == FIMC_IO_DMA) {
 		u32 color = dst_frame->fmt->color;
 
-		if (color >= S5P_FIMC_RGB444 && color <= S5P_FIMC_RGB565)
+		if (color >= FIMC_FMT_RGB444 && color <= FIMC_FMT_RGB565)
 			cfg |= FIMC_REG_CISCCTRL_OUTRGB_FMT_RGB565;
-		else if (color == S5P_FIMC_RGB666)
+		else if (color == FIMC_FMT_RGB666)
 			cfg |= FIMC_REG_CISCCTRL_OUTRGB_FMT_RGB666;
-		else if (color == S5P_FIMC_RGB888)
+		else if (color == FIMC_FMT_RGB888)
 			cfg |= FIMC_REG_CISCCTRL_OUTRGB_FMT_RGB888;
 	} else {
 		cfg |= FIMC_REG_CISCCTRL_OUTRGB_FMT_RGB888;
@@ -350,7 +350,7 @@ void fimc_hw_en_capture(struct fimc_ctx *ctx)
 
 	u32 cfg = readl(dev->regs + FIMC_REG_CIIMGCPT);
 
-	if (ctx->out_path == FIMC_DMA) {
+	if (ctx->out_path == FIMC_IO_DMA) {
 		/* one shot mode */
 		cfg |= FIMC_REG_CIIMGCPT_CPT_FREN_ENABLE |
 			FIMC_REG_CIIMGCPT_IMGCPTEN;
@@ -407,7 +407,7 @@ static void fimc_hw_set_in_dma_size(struct fimc_ctx *ctx)
 	u32 cfg_o = 0;
 	u32 cfg_r = 0;
 
-	if (FIMC_LCDFIFO == ctx->out_path)
+	if (FIMC_IO_LCDFIFO == ctx->out_path)
 		cfg_r |= FIMC_REG_CIREAL_ISIZE_AUTOLOAD_EN;
 
 	cfg_o |= (frame->f_height << 16) | frame->f_width;
@@ -438,7 +438,7 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 	fimc_hw_set_in_dma_size(ctx);
 
 	/* Use DMA autoload only in FIFO mode. */
-	fimc_hw_en_autoload(dev, ctx->out_path == FIMC_LCDFIFO);
+	fimc_hw_en_autoload(dev, ctx->out_path == FIMC_IO_LCDFIFO);
 
 	/* Set the input DMA to process single frame only. */
 	cfg = readl(dev->regs + FIMC_REG_MSCTRL);
@@ -453,10 +453,10 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 		| FIMC_REG_MSCTRL_FIFO_CTRL_FULL);
 
 	switch (frame->fmt->color) {
-	case S5P_FIMC_RGB565...S5P_FIMC_RGB888:
+	case FIMC_FMT_RGB565...FIMC_FMT_RGB888:
 		cfg |= FIMC_REG_MSCTRL_INFORMAT_RGB;
 		break;
-	case S5P_FIMC_YCBCR420:
+	case FIMC_FMT_YCBCR420:
 		cfg |= FIMC_REG_MSCTRL_INFORMAT_YCBCR420;
 
 		if (frame->fmt->colplanes == 2)
@@ -465,7 +465,7 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 			cfg |= FIMC_REG_MSCTRL_C_INT_IN_3PLANE;
 
 		break;
-	case S5P_FIMC_YCBYCR422...S5P_FIMC_CRYCBY422:
+	case FIMC_FMT_YCBYCR422...FIMC_FMT_CRYCBY422:
 		if (frame->fmt->colplanes == 1) {
 			cfg |= ctx->in_order_1p
 				| FIMC_REG_MSCTRL_INFORMAT_YCBCR422_1P;
@@ -506,7 +506,7 @@ void fimc_hw_set_input_path(struct fimc_ctx *ctx)
 	u32 cfg = readl(dev->regs + FIMC_REG_MSCTRL);
 	cfg &= ~FIMC_REG_MSCTRL_INPUT_MASK;
 
-	if (ctx->in_path == FIMC_DMA)
+	if (ctx->in_path == FIMC_IO_DMA)
 		cfg |= FIMC_REG_MSCTRL_INPUT_MEMORY;
 	else
 		cfg |= FIMC_REG_MSCTRL_INPUT_EXTCAM;
@@ -520,7 +520,7 @@ void fimc_hw_set_output_path(struct fimc_ctx *ctx)
 
 	u32 cfg = readl(dev->regs + FIMC_REG_CISCCTRL);
 	cfg &= ~FIMC_REG_CISCCTRL_LCDPATHEN_FIFO;
-	if (ctx->out_path == FIMC_LCDFIFO)
+	if (ctx->out_path == FIMC_IO_LCDFIFO)
 		cfg |= FIMC_REG_CISCCTRL_LCDPATHEN_FIFO;
 	writel(cfg, dev->regs + FIMC_REG_CISCCTRL);
 }
-- 
1.7.10

