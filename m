Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19158 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbbCEL5V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2015 06:57:21 -0500
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/2] media: s5p-jpeg: add 5420 family support
Date: Thu, 05 Mar 2015 12:56:36 +0100
Message-id: <1425556596-3938-3-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1425556596-3938-1-git-send-email-andrzej.p@samsung.com>
References: <1425556596-3938-1-git-send-email-andrzej.p@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

JPEG IP found in Exynos5420 is similar to what is in Exynos3250, but
there are some subtle differences which this patch takes into account.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 .../bindings/media/exynos-jpeg-codec.txt           |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 69 +++++++++++++++++-----
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |  1 +
 3 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
index bf52ed4..4ef4563 100644
--- a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
+++ b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
@@ -4,7 +4,7 @@ Required properties:
 
 - compatible	: should be one of:
 		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg",
-		  "samsung,exynos3250-jpeg";
+		  "samsung,exynos3250-jpeg", "samsung,exynos5420-jpeg";
 - reg		: address and length of the JPEG codec IP register set;
 - interrupts	: specifies the JPEG codec IP interrupt;
 - clock-names   : should contain:
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 12f7452..99bf5b3 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -621,6 +621,7 @@ static int s5p_jpeg_to_user_subsampling(struct s5p_jpeg_ctx *ctx)
 			return V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
 		return ctx->subsampling;
 	case SJPEG_EXYNOS3250:
+	case SJPEG_EXYNOS5420:
 		if (ctx->subsampling > 3)
 			return V4L2_JPEG_CHROMA_SUBSAMPLING_411;
 		return exynos3250_decoded_subsampling[ctx->subsampling];
@@ -1128,6 +1129,18 @@ static struct s5p_jpeg_fmt *s5p_jpeg_find_format(struct s5p_jpeg_ctx *ctx,
 	return NULL;
 }
 
+static inline bool is_3250_compat(struct s5p_jpeg_ctx *ctx)
+{
+	switch (ctx->jpeg->variant->version) {
+	case SJPEG_EXYNOS3250:
+	case SJPEG_EXYNOS5420:
+		return true;
+	default:
+		return false;
+	}
+	return false;
+}
+
 static void jpeg_bound_align_image(struct s5p_jpeg_ctx *ctx,
 				   u32 *w, unsigned int wmin, unsigned int wmax,
 				   unsigned int walign,
@@ -1142,13 +1155,13 @@ static void jpeg_bound_align_image(struct s5p_jpeg_ctx *ctx,
 	w_step = 1 << walign;
 	h_step = 1 << halign;
 
-	if (ctx->jpeg->variant->version == SJPEG_EXYNOS3250) {
+	if (is_3250_compat(ctx)) {
 		/*
 		 * Rightmost and bottommost pixels are cropped by the
-		 * Exynos3250 JPEG IP for RGB formats, for the specific
-		 * width and height values respectively. This assignment
-		 * will result in v4l_bound_align_image returning dimensions
-		 * reduced by 1 for the aforementioned cases.
+		 * Exynos3250/compatible JPEG IP for RGB formats, for the
+		 * specific width and height values respectively. This
+		 * assignment will result in v4l_bound_align_image returning
+		 * dimensions reduced by 1 for the aforementioned cases.
 		 */
 		if (w_step == 4 && ((width & 3) == 1)) {
 			wmax = width;
@@ -1384,12 +1397,12 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 
 	/*
 	 * Prevent downscaling to YUV420 format by more than 2
-	 * for Exynos3250 SoC as it produces broken raw image
+	 * for Exynos3250/compatible SoC as it produces broken raw image
 	 * in such cases.
 	 */
 	if (ct->mode == S5P_JPEG_DECODE &&
 	    f_type == FMT_TYPE_CAPTURE &&
-	    ct->jpeg->variant->version == SJPEG_EXYNOS3250 &&
+	    is_3250_compat(ct) &&
 	    pix->pixelformat == V4L2_PIX_FMT_YUV420 &&
 	    ct->scale_factor > 2) {
 		scale_rect.width = ct->out_q.w / 2;
@@ -1569,12 +1582,12 @@ static int s5p_jpeg_s_selection(struct file *file, void *fh,
 	if (s->target == V4L2_SEL_TGT_COMPOSE) {
 		if (ctx->mode != S5P_JPEG_DECODE)
 			return -EINVAL;
-		if (ctx->jpeg->variant->version == SJPEG_EXYNOS3250)
+		if (is_3250_compat(ctx))
 			ret = exynos3250_jpeg_try_downscale(ctx, rect);
 	} else if (s->target == V4L2_SEL_TGT_CROP) {
 		if (ctx->mode != S5P_JPEG_ENCODE)
 			return -EINVAL;
-		if (ctx->jpeg->variant->version == SJPEG_EXYNOS3250)
+		if (is_3250_compat(ctx))
 			ret = exynos3250_jpeg_try_crop(ctx, rect);
 	}
 
@@ -1604,8 +1617,9 @@ static int s5p_jpeg_adjust_subs_ctrl(struct s5p_jpeg_ctx *ctx, int *ctrl_val)
 	case SJPEG_S5P:
 		return 0;
 	case SJPEG_EXYNOS3250:
+	case SJPEG_EXYNOS5420:
 		/*
-		 * The exynos3250 device can produce JPEG image only
+		 * The exynos3250/compatible device can produce JPEG image only
 		 * of 4:4:4 subsampling when given RGB32 source image.
 		 */
 		if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB32)
@@ -1624,7 +1638,7 @@ static int s5p_jpeg_adjust_subs_ctrl(struct s5p_jpeg_ctx *ctx, int *ctrl_val)
 	}
 
 	/*
-	 * The exynos4x12 and exynos3250 devices require resulting
+	 * The exynos4x12 and exynos3250/compatible devices require resulting
 	 * jpeg subsampling not to be lower than the input raw image
 	 * subsampling.
 	 */
@@ -2017,6 +2031,15 @@ static void exynos3250_jpeg_device_run(void *priv)
 		exynos3250_jpeg_qtbl(jpeg->regs, 2, 1);
 		exynos3250_jpeg_qtbl(jpeg->regs, 3, 1);
 
+		/*
+		 * 5420 family requires setting Huffman tables before each run
+		 */
+		if (jpeg->variant->version == SJPEG_EXYNOS5420) {
+			s5p_jpeg_set_hdctbl(jpeg->regs);
+			s5p_jpeg_set_hdctblg(jpeg->regs);
+			s5p_jpeg_set_hactbl(jpeg->regs);
+			s5p_jpeg_set_hactblg(jpeg->regs);
+		}
 		/* Y, Cb, Cr use Huffman table 0 */
 		exynos3250_jpeg_htbl_ac(jpeg->regs, 1);
 		exynos3250_jpeg_htbl_dc(jpeg->regs, 1);
@@ -2098,6 +2121,12 @@ static struct v4l2_m2m_ops exynos4_jpeg_m2m_ops = {
 	.job_abort	= s5p_jpeg_job_abort,
 };
 
+static struct v4l2_m2m_ops exynos5420_jpeg_m2m_ops = {
+	.device_run	= exynos3250_jpeg_device_run,	/* intentionally 3250 */
+	.job_ready	= s5p_jpeg_job_ready,
+	.job_abort	= s5p_jpeg_job_abort,
+};
+
 /*
  * ============================================================================
  * Queue operations
@@ -2660,10 +2689,10 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
 	/*
 	 * JPEG IP allows storing two Huffman tables for each component.
 	 * We fill table 0 for each component and do this here only
-	 * for S5PC210 and Exynos3250 SoCs. Exynos4x12 SoC requires
-	 * programming its Huffman tables each time the encoding process
-	 * is initialized, and thus it is accomplished in the device_run
-	 * callback of m2m_ops.
+	 * for S5PC210 and Exynos3250 SoCs. Exynos4x12 and Exynos542x SoC
+	 * require programming their Huffman tables each time the encoding
+	 * process is initialized, and thus it is accomplished in the
+	 * device_run callback of m2m_ops.
 	 */
 	if (jpeg->variant->version == SJPEG_S5P ||
 	    jpeg->variant->version == SJPEG_EXYNOS3250) {
@@ -2723,6 +2752,13 @@ static struct s5p_jpeg_variant exynos4_jpeg_drvdata = {
 	.fmt_ver_flag	= SJPEG_FMT_FLAG_EXYNOS4,
 };
 
+static struct s5p_jpeg_variant exynos5420_jpeg_drvdata = {
+	.version	= SJPEG_EXYNOS5420,
+	.jpeg_irq	= exynos3250_jpeg_irq,		/* intentionally 3250 */
+	.m2m_ops	= &exynos5420_jpeg_m2m_ops,
+	.fmt_ver_flag	= SJPEG_FMT_FLAG_EXYNOS3250,	/* intentionally 3250 */
+};
+
 static const struct of_device_id samsung_jpeg_match[] = {
 	{
 		.compatible = "samsung,s5pv210-jpeg",
@@ -2736,6 +2772,9 @@ static const struct of_device_id samsung_jpeg_match[] = {
 	}, {
 		.compatible = "samsung,exynos4212-jpeg",
 		.data = &exynos4_jpeg_drvdata,
+	}, {
+		.compatible = "samsung,exynos5420-jpeg",
+		.data = &exynos5420_jpeg_drvdata,
 	},
 	{},
 };
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 764b32d..3bd5eba 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -71,6 +71,7 @@
 #define SJPEG_S5P		1
 #define SJPEG_EXYNOS3250	2
 #define SJPEG_EXYNOS4		3
+#define SJPEG_EXYNOS5420	4
 
 enum exynos4_jpeg_result {
 	OK_ENC_OR_DEC,
-- 
1.9.1

