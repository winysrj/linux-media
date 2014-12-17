Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:8533 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaLQHew (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 02:34:52 -0500
From: Tony K Nadackal <tony.kn@samsung.com>
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: mchehab@osg.samsung.com, j.anaszewski@samsung.com,
	kgene@kernel.org, k.debski@samsung.com, s.nawrocki@samsung.com,
	robh+dt@kernel.org, mark.rutland@arm.com, bhushan.r@samsung.com,
	Tony K Nadackal <tony.kn@samsung.com>
Subject: [PATCH] [media] s5p-jpeg: Adding Exynos7 Jpeg variant support
Date: Wed, 17 Dec 2014 12:57:09 +0530
Message-id: <1418801229-7532-1-git-send-email-tony.kn@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fimp_jpeg used in Exynos7 is a revised version. Some register
configurations are slightly different from Jpeg in Exynos4.
Added one more variant SJPEG_EXYNOS7 to handle these differences.

Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
---
This patch is created and tested on top of linux-next-20141210.
It can be cleanly applied on media-next and kgene/for-next.

 .../bindings/media/exynos-jpeg-codec.txt           |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 69 +++++++++++++++++++---
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |  1 +
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c  | 33 ++++++-----
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h  |  8 ++-
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        | 17 ++++--
 6 files changed, 98 insertions(+), 32 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
index bf52ed4..cd19417 100644
--- a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
+++ b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
@@ -4,7 +4,7 @@ Required properties:
 
 - compatible	: should be one of:
 		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg",
-		  "samsung,exynos3250-jpeg";
+		  "samsung,exynos3250-jpeg", "samsung,exynos7-jpeg";
 - reg		: address and length of the JPEG codec IP register set;
 - interrupts	: specifies the JPEG codec IP interrupt;
 - clock-names   : should contain:
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 54fa5d9..ad42a4e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1225,8 +1225,9 @@ static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	if ((ctx->jpeg->variant->version != SJPEG_EXYNOS4) ||
-	    (ctx->mode != S5P_JPEG_DECODE))
+	if (((ctx->jpeg->variant->version != SJPEG_EXYNOS4) &&
+		(ctx->jpeg->variant->version != SJPEG_EXYNOS7)) ||
+		(ctx->mode != S5P_JPEG_DECODE))
 		goto exit;
 
 	/*
@@ -1349,7 +1350,8 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 		 * the JPEG_IMAGE_SIZE register. In order to avoid sysmmu
 		 * page fault calculate proper buffer size in such a case.
 		 */
-		if (ct->jpeg->variant->version == SJPEG_EXYNOS4 &&
+		if (((ct->jpeg->variant->version == SJPEG_EXYNOS4) ||
+			(ct->jpeg->variant->version == SJPEG_EXYNOS7)) &&
 		    f_type == FMT_TYPE_OUTPUT && ct->mode == S5P_JPEG_ENCODE)
 			q_data->size = exynos4_jpeg_get_output_buffer_size(ct,
 							f,
@@ -1901,7 +1903,6 @@ static void exynos4_jpeg_device_run(void *priv)
 
 	if (ctx->mode == S5P_JPEG_ENCODE) {
 		exynos4_jpeg_sw_reset(jpeg->regs);
-		exynos4_jpeg_set_interrupt(jpeg->regs);
 		exynos4_jpeg_set_huf_table_enable(jpeg->regs, 1);
 
 		exynos4_jpeg_set_huff_tbl(jpeg->regs);
@@ -1918,20 +1919,60 @@ static void exynos4_jpeg_device_run(void *priv)
 		exynos4_jpeg_set_stream_size(jpeg->regs, ctx->cap_q.w,
 							ctx->cap_q.h);
 
-		exynos4_jpeg_set_enc_out_fmt(jpeg->regs, ctx->subsampling);
-		exynos4_jpeg_set_img_fmt(jpeg->regs, ctx->out_q.fmt->fourcc);
+		if (ctx->jpeg->variant->version == SJPEG_EXYNOS7) {
+			exynos4_jpeg_set_interrupt(jpeg->regs, SJPEG_EXYNOS7);
+			exynos4_jpeg_set_enc_out_fmt(jpeg->regs,
+					ctx->subsampling, EXYNOS7_ENC_FMT_MASK);
+			exynos4_jpeg_set_img_fmt(jpeg->regs,
+					ctx->out_q.fmt->fourcc,
+					EXYNOS7_SWAP_CHROMA_SHIFT);
+		} else {
+			exynos4_jpeg_set_interrupt(jpeg->regs, SJPEG_EXYNOS4);
+			exynos4_jpeg_set_enc_out_fmt(jpeg->regs,
+					ctx->subsampling, EXYNOS4_ENC_FMT_MASK);
+			exynos4_jpeg_set_img_fmt(jpeg->regs,
+					ctx->out_q.fmt->fourcc,
+					EXYNOS4_SWAP_CHROMA_SHIFT);
+		}
+
 		exynos4_jpeg_set_img_addr(ctx);
 		exynos4_jpeg_set_jpeg_addr(ctx);
 		exynos4_jpeg_set_encode_hoff_cnt(jpeg->regs,
 							ctx->out_q.fmt->fourcc);
 	} else {
 		exynos4_jpeg_sw_reset(jpeg->regs);
-		exynos4_jpeg_set_interrupt(jpeg->regs);
 		exynos4_jpeg_set_img_addr(ctx);
 		exynos4_jpeg_set_jpeg_addr(ctx);
-		exynos4_jpeg_set_img_fmt(jpeg->regs, ctx->cap_q.fmt->fourcc);
 
-		bitstream_size = DIV_ROUND_UP(ctx->out_q.size, 32);
+		if (ctx->jpeg->variant->version == SJPEG_EXYNOS7) {
+			exynos4_jpeg_set_interrupt(jpeg->regs, SJPEG_EXYNOS7);
+			exynos4_jpeg_set_huff_tbl(jpeg->regs);
+			exynos4_jpeg_set_huf_table_enable(jpeg->regs, 1);
+
+			/*
+			 * JPEG IP allows storing 4 quantization tables
+			 * We fill table 0 for luma and table 1 for chroma
+			 */
+			exynos4_jpeg_set_qtbl_lum(jpeg->regs,
+							ctx->compr_quality);
+			exynos4_jpeg_set_qtbl_chr(jpeg->regs,
+							ctx->compr_quality);
+
+			exynos4_jpeg_set_stream_size(jpeg->regs, ctx->cap_q.w,
+					ctx->cap_q.h);
+			exynos4_jpeg_set_enc_out_fmt(jpeg->regs,
+					ctx->subsampling, EXYNOS7_ENC_FMT_MASK);
+			exynos4_jpeg_set_img_fmt(jpeg->regs,
+					ctx->cap_q.fmt->fourcc,
+					EXYNOS7_SWAP_CHROMA_SHIFT);
+			bitstream_size = DIV_ROUND_UP(ctx->out_q.size, 16);
+		} else {
+			exynos4_jpeg_set_interrupt(jpeg->regs, SJPEG_EXYNOS4);
+			exynos4_jpeg_set_img_fmt(jpeg->regs,
+					ctx->cap_q.fmt->fourcc,
+					EXYNOS4_SWAP_CHROMA_SHIFT);
+			bitstream_size = DIV_ROUND_UP(ctx->out_q.size, 32);
+		}
 
 		exynos4_jpeg_set_dec_bitstream_size(jpeg->regs, bitstream_size);
 	}
@@ -2729,6 +2770,13 @@ static struct s5p_jpeg_variant exynos4_jpeg_drvdata = {
 	.fmt_ver_flag	= SJPEG_FMT_FLAG_EXYNOS4,
 };
 
+static struct s5p_jpeg_variant exynos7_jpeg_drvdata = {
+	.version	= SJPEG_EXYNOS7,
+	.jpeg_irq	= exynos4_jpeg_irq,
+	.m2m_ops	= &exynos4_jpeg_m2m_ops,
+	.fmt_ver_flag	= SJPEG_FMT_FLAG_EXYNOS4,
+};
+
 static const struct of_device_id samsung_jpeg_match[] = {
 	{
 		.compatible = "samsung,s5pv210-jpeg",
@@ -2742,6 +2790,9 @@ static const struct of_device_id samsung_jpeg_match[] = {
 	}, {
 		.compatible = "samsung,exynos4212-jpeg",
 		.data = &exynos4_jpeg_drvdata,
+	}, {
+		.compatible = "samsung,exynos7-jpeg",
+		.data = &exynos7_jpeg_drvdata,
 	},
 	{},
 };
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 764b32d..734710a 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -71,6 +71,7 @@
 #define SJPEG_S5P		1
 #define SJPEG_EXYNOS3250	2
 #define SJPEG_EXYNOS4		3
+#define SJPEG_EXYNOS7		4
 
 enum exynos4_jpeg_result {
 	OK_ENC_OR_DEC,
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index e53f13a..2611259 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -49,7 +49,8 @@ void exynos4_jpeg_set_enc_dec_mode(void __iomem *base, unsigned int mode)
 	}
 }
 
-void exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt)
+void exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt,
+					unsigned int shift)
 {
 	unsigned int reg;
 
@@ -71,48 +72,48 @@ void exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt)
 	case V4L2_PIX_FMT_NV24:
 		reg = reg | EXYNOS4_ENC_YUV_444_IMG |
 				EXYNOS4_YUV_444_IP_YUV_444_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CBCR;
+				EXYNOS_SWAP_CHROMA_CBCR(shift);
 		break;
 	case V4L2_PIX_FMT_NV42:
 		reg = reg | EXYNOS4_ENC_YUV_444_IMG |
 				EXYNOS4_YUV_444_IP_YUV_444_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CRCB;
+				EXYNOS_SWAP_CHROMA_CRCB(shift);
 		break;
 	case V4L2_PIX_FMT_YUYV:
 		reg = reg | EXYNOS4_DEC_YUV_422_IMG |
 				EXYNOS4_YUV_422_IP_YUV_422_1P_IMG |
-				EXYNOS4_SWAP_CHROMA_CBCR;
+				EXYNOS_SWAP_CHROMA_CBCR(shift);
 		break;
 
 	case V4L2_PIX_FMT_YVYU:
 		reg = reg | EXYNOS4_DEC_YUV_422_IMG |
 				EXYNOS4_YUV_422_IP_YUV_422_1P_IMG |
-				EXYNOS4_SWAP_CHROMA_CRCB;
+				EXYNOS_SWAP_CHROMA_CRCB(shift);
 		break;
 	case V4L2_PIX_FMT_NV16:
 		reg = reg | EXYNOS4_DEC_YUV_422_IMG |
 				EXYNOS4_YUV_422_IP_YUV_422_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CBCR;
+				EXYNOS_SWAP_CHROMA_CBCR(shift);
 		break;
 	case V4L2_PIX_FMT_NV61:
 		reg = reg | EXYNOS4_DEC_YUV_422_IMG |
 				EXYNOS4_YUV_422_IP_YUV_422_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CRCB;
+				EXYNOS_SWAP_CHROMA_CRCB(shift);
 		break;
 	case V4L2_PIX_FMT_NV12:
 		reg = reg | EXYNOS4_DEC_YUV_420_IMG |
 				EXYNOS4_YUV_420_IP_YUV_420_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CBCR;
+				EXYNOS_SWAP_CHROMA_CBCR(shift);
 		break;
 	case V4L2_PIX_FMT_NV21:
 		reg = reg | EXYNOS4_DEC_YUV_420_IMG |
 				EXYNOS4_YUV_420_IP_YUV_420_2P_IMG |
-				EXYNOS4_SWAP_CHROMA_CRCB;
+				EXYNOS_SWAP_CHROMA_CRCB(shift);
 		break;
 	case V4L2_PIX_FMT_YUV420:
 		reg = reg | EXYNOS4_DEC_YUV_420_IMG |
 				EXYNOS4_YUV_420_IP_YUV_420_3P_IMG |
-				EXYNOS4_SWAP_CHROMA_CBCR;
+				EXYNOS_SWAP_CHROMA_CBCR(shift);
 		break;
 	default:
 		break;
@@ -122,12 +123,13 @@ void exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt)
 	writel(reg, base + EXYNOS4_IMG_FMT_REG);
 }
 
-void exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt)
+void exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt,
+					unsigned int mask)
 {
 	unsigned int reg;
 
 	reg = readl(base + EXYNOS4_IMG_FMT_REG) &
-			~EXYNOS4_ENC_FMT_MASK; /* clear enc format */
+			~EXYNOS_ENC_FMT_MASK(mask); /* clear enc format */
 
 	switch (out_fmt) {
 	case V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY:
@@ -153,9 +155,12 @@ void exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt)
 	writel(reg, base + EXYNOS4_IMG_FMT_REG);
 }
 
-void exynos4_jpeg_set_interrupt(void __iomem *base)
+void exynos4_jpeg_set_interrupt(void __iomem *base, unsigned int version)
 {
-	writel(EXYNOS4_INT_EN_ALL, base + EXYNOS4_INT_EN_REG);
+	unsigned int reg;
+
+	reg = readl(base + EXYNOS4_INT_EN_REG) & ~EXYNOS4_INT_EN_MASK(version);
+	writel(EXYNOS4_INT_EN_ALL(version), base + EXYNOS4_INT_EN_REG);
 }
 
 unsigned int exynos4_jpeg_get_int_status(void __iomem *base)
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h
index c228d28..b425199 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h
@@ -15,10 +15,12 @@
 
 void exynos4_jpeg_sw_reset(void __iomem *base);
 void exynos4_jpeg_set_enc_dec_mode(void __iomem *base, unsigned int mode);
-void exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt);
-void exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt);
+void exynos4_jpeg_set_img_fmt(void __iomem *base, unsigned int img_fmt,
+					unsigned int shift);
+void exynos4_jpeg_set_enc_out_fmt(void __iomem *base, unsigned int out_fmt,
+							unsigned int mask);
 void exynos4_jpeg_set_enc_tbl(void __iomem *base);
-void exynos4_jpeg_set_interrupt(void __iomem *base);
+void exynos4_jpeg_set_interrupt(void __iomem *base, unsigned int variant);
 unsigned int exynos4_jpeg_get_int_status(void __iomem *base);
 void exynos4_jpeg_set_huf_table_enable(void __iomem *base, int value);
 void exynos4_jpeg_set_sys_int_enable(void __iomem *base, int value);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-regs.h b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
index 050fc44..08bef4e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-regs.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
@@ -230,13 +230,15 @@
 #define EXYNOS4_SOFT_RESET_HI		(1 << 29)
 
 /* JPEG INT Register bit */
-#define EXYNOS4_INT_EN_MASK		(0x1f << 0)
+#define EXYNOS4_INT_EN_MASK(version)	(((version) == SJPEG_EXYNOS7) \
+						? (0x1ff << 0) : (0x1f << 0))
 #define EXYNOS4_PROT_ERR_INT_EN		(1 << 0)
 #define EXYNOS4_IMG_COMPLETION_INT_EN	(1 << 1)
 #define EXYNOS4_DEC_INVALID_FORMAT_EN	(1 << 2)
 #define EXYNOS4_MULTI_SCAN_ERROR_EN	(1 << 3)
 #define EXYNOS4_FRAME_ERR_EN		(1 << 4)
-#define EXYNOS4_INT_EN_ALL		(0x1f << 0)
+#define EXYNOS4_INT_EN_ALL(version)    (((version) == SJPEG_EXYNOS7) \
+						? (0x1b6 << 0) : (0x1f << 0))
 
 #define EXYNOS4_MOD_REG_PROC_ENC	(0 << 3)
 #define EXYNOS4_MOD_REG_PROC_DEC	(1 << 3)
@@ -294,8 +296,11 @@
 #define EXYNOS4_YUV_420_IP_YUV_420_2P_IMG	(4 << EXYNOS4_YUV_420_IP_SHIFT)
 #define EXYNOS4_YUV_420_IP_YUV_420_3P_IMG	(5 << EXYNOS4_YUV_420_IP_SHIFT)
 
+#define EXYNOS4_ENC_FMT_MASK			3
+#define EXYNOS7_ENC_FMT_MASK			7
 #define EXYNOS4_ENC_FMT_SHIFT			24
-#define EXYNOS4_ENC_FMT_MASK			(3 << EXYNOS4_ENC_FMT_SHIFT)
+#define EXYNOS_ENC_FMT_MASK(mask)		((mask) \
+						<< EXYNOS4_ENC_FMT_SHIFT)
 #define EXYNOS4_ENC_FMT_GRAY			(0 << EXYNOS4_ENC_FMT_SHIFT)
 #define EXYNOS4_ENC_FMT_YUV_444			(1 << EXYNOS4_ENC_FMT_SHIFT)
 #define EXYNOS4_ENC_FMT_YUV_422			(2 << EXYNOS4_ENC_FMT_SHIFT)
@@ -303,8 +308,10 @@
 
 #define EXYNOS4_JPEG_DECODED_IMG_FMT_MASK	0x03
 
-#define EXYNOS4_SWAP_CHROMA_CRCB		(1 << 26)
-#define EXYNOS4_SWAP_CHROMA_CBCR		(0 << 26)
+#define EXYNOS7_SWAP_CHROMA_SHIFT		27
+#define EXYNOS4_SWAP_CHROMA_SHIFT		26
+#define EXYNOS_SWAP_CHROMA_CRCB(shift)		(1 << (shift))
+#define EXYNOS_SWAP_CHROMA_CBCR(shift)		(0 << (shift))
 
 /* JPEG HUFF count Register bit */
 #define EXYNOS4_HUFF_COUNT_MASK			0xffff
-- 
2.2.0

