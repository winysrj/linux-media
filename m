Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36134 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2CAXqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 18:46:39 -0500
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M0800J30CPDPV40@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Mar 2012 08:46:37 +0900 (KST)
Received: from NOYMSONG01 ([12.23.119.72])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0800BPCCPOAR70@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Fri, 02 Mar 2012 08:46:37 +0900 (KST)
From: =?ks_c_5601-1987?B?vNu/tbjx?= <ym.song@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, andrzej.p@samsung.com
Subject: [PATCH] media: jpeg: add driver for a version 2.x of jpeg H/W
Date: Fri, 02 Mar 2012 08:46:36 +0900
Message-id: <002e01ccf805$8a5c2000$9f146000$%song@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add a driver for a version 2.x of jpeg H/W
in ths Samsung Exynos5 Soc.
A jpeg H/W version of Exynos4 SoC is 3.0

1. Encoding
 - input format : V4L2_PIX_FMT_RGB565X and V4L2_PIX_FMT_YUYV

2. Decoding
 - output format : V4L2_PIX_FMT_YUYV and V4L2_PIX_FMT_YUV420

Signed-off-by: youngmok song <ym.song@samsung.com>
---
 drivers/media/video/Kconfig                   |   17 +
 drivers/media/video/s5p-jpeg/Makefile         |    5 +-
 drivers/media/video/s5p-jpeg/jpeg-core.c      |  303 +-------------------
 drivers/media/video/s5p-jpeg/jpeg-hw-common.h |   34 +++
 drivers/media/video/s5p-jpeg/jpeg-hw-v2x.h    |  387 +++++++++++++++++++++++++
 drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h  |  150 ++++++++++
 drivers/media/video/s5p-jpeg/jpeg-v2x.c       |  129 ++++++++
 drivers/media/video/s5p-jpeg/jpeg-v3.c        |  340 ++++++++++++++++++++++
 8 files changed, 1066 insertions(+), 299 deletions(-)
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-hw-common.h
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-hw-v2x.h
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-v2x.c
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-v3.c

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9adada0..551f925 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1167,6 +1167,23 @@ config VIDEO_SAMSUNG_S5P_JPEG
 	select V4L2_MEM2MEM_DEV
 	---help---
 	  This is a v4l2 driver for Samsung S5P and EXYNOS4 JPEG codec
+choice
+	prompt "JPEG V4L2 Driver"
+	default S5P_JPEG_V3
+	depends on VIDEO_SAMSUNG_S5P_JPEG
+	---help---
+	  Select version of MFC driver
+
+config S5P_JPEG_V3
+	bool "JPEG 3.x"
+	---help---
+	  Use JPEG 3.x V4L2 Driver
+
+config S5P_JPEG_V2
+	bool "JPEG 2.x"
+	---help---
+	  Use JPEG 2.x V4L2 Driver
+endchoice
 
 config VIDEO_SAMSUNG_S5P_MFC
 	tristate "Samsung S5P MFC 5.1 Video Codec"
diff --git a/drivers/media/video/s5p-jpeg/Makefile b/drivers/media/video/s5p-jpeg/Makefile
index ddc2900..446d07f 100644
--- a/drivers/media/video/s5p-jpeg/Makefile
+++ b/drivers/media/video/s5p-jpeg/Makefile
@@ -1,2 +1,5 @@
-s5p-jpeg-objs := jpeg-core.o
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG) := s5p-jpeg.o
+
+s5p-jpeg-objs := jpeg-core.o
+obj-$(CONFIG_S5P_JPEG_V3) += jpeg-v3.o
+obj-$(CONFIG_S5P_JPEG_V2) += jpeg-v2x.o
diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index 1105a87..cf917cd 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -28,7 +28,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "jpeg-core.h"
-#include "jpeg-hw.h"
+#include "jpeg-hw-common.h"
 
 static struct s5p_jpeg_fmt formats_enc[] = {
 	{
@@ -83,182 +83,6 @@ static struct s5p_jpeg_fmt formats_dec[] = {
 };
 #define NUM_FORMATS_DEC ARRAY_SIZE(formats_dec)
 
-static const unsigned char qtbl_luminance[4][64] = {
-	{/* level 1 - high quality */
-		 8,  6,  6,  8, 12, 14, 16, 17,
-		 6,  6,  6,  8, 10, 13, 12, 15,
-		 6,  6,  7,  8, 13, 14, 18, 24,
-		 8,  8,  8, 14, 13, 19, 24, 35,
-		12, 10, 13, 13, 20, 26, 34, 39,
-		14, 13, 14, 19, 26, 34, 39, 39,
-		16, 12, 18, 24, 34, 39, 39, 39,
-		17, 15, 24, 35, 39, 39, 39, 39
-	},
-	{/* level 2 */
-		12,  8,  8, 12, 17, 21, 24, 23,
-		 8,  9,  9, 11, 15, 19, 18, 23,
-		 8,  9, 10, 12, 19, 20, 27, 36,
-		12, 11, 12, 21, 20, 28, 36, 53,
-		17, 15, 19, 20, 30, 39, 51, 59,
-		21, 19, 20, 28, 39, 51, 59, 59,
-		24, 18, 27, 36, 51, 59, 59, 59,
-		23, 23, 36, 53, 59, 59, 59, 59
-	},
-	{/* level 3 */
-		16, 11, 11, 16, 23, 27, 31, 30,
-		11, 12, 12, 15, 20, 23, 23, 30,
-		11, 12, 13, 16, 23, 26, 35, 47,
-		16, 15, 16, 23, 26, 37, 47, 64,
-		23, 20, 23, 26, 39, 51, 64, 64,
-		27, 23, 26, 37, 51, 64, 64, 64,
-		31, 23, 35, 47, 64, 64, 64, 64,
-		30, 30, 47, 64, 64, 64, 64, 64
-	},
-	{/*level 4 - low quality */
-		20, 16, 25, 39, 50, 46, 62, 68,
-		16, 18, 23, 38, 38, 53, 65, 68,
-		25, 23, 31, 38, 53, 65, 68, 68,
-		39, 38, 38, 53, 65, 68, 68, 68,
-		50, 38, 53, 65, 68, 68, 68, 68,
-		46, 53, 65, 68, 68, 68, 68, 68,
-		62, 65, 68, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68
-	}
-};
-
-static const unsigned char qtbl_chrominance[4][64] = {
-	{/* level 1 - high quality */
-		 9,  8,  9, 11, 14, 17, 19, 24,
-		 8, 10,  9, 11, 14, 13, 17, 22,
-		 9,  9, 13, 14, 13, 15, 23, 26,
-		11, 11, 14, 14, 15, 20, 26, 33,
-		14, 14, 13, 15, 20, 24, 33, 39,
-		17, 13, 15, 20, 24, 32, 39, 39,
-		19, 17, 23, 26, 33, 39, 39, 39,
-		24, 22, 26, 33, 39, 39, 39, 39
-	},
-	{/* level 2 */
-		13, 11, 13, 16, 20, 20, 29, 37,
-		11, 14, 14, 14, 16, 20, 26, 32,
-		13, 14, 15, 17, 20, 23, 35, 40,
-		16, 14, 17, 21, 23, 30, 40, 50,
-		20, 16, 20, 23, 30, 37, 50, 59,
-		20, 20, 23, 30, 37, 48, 59, 59,
-		29, 26, 35, 40, 50, 59, 59, 59,
-		37, 32, 40, 50, 59, 59, 59, 59
-	},
-	{/* level 3 */
-		17, 15, 17, 21, 20, 26, 38, 48,
-		15, 19, 18, 17, 20, 26, 35, 43,
-		17, 18, 20, 22, 26, 30, 46, 53,
-		21, 17, 22, 28, 30, 39, 53, 64,
-		20, 20, 26, 30, 39, 48, 64, 64,
-		26, 26, 30, 39, 48, 63, 64, 64,
-		38, 35, 46, 53, 64, 64, 64, 64,
-		48, 43, 53, 64, 64, 64, 64, 64
-	},
-	{/*level 4 - low quality */
-		21, 25, 32, 38, 54, 68, 68, 68,
-		25, 28, 24, 38, 54, 68, 68, 68,
-		32, 24, 32, 43, 66, 68, 68, 68,
-		38, 38, 43, 53, 68, 68, 68, 68,
-		54, 54, 66, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68
-	}
-};
-
-static const unsigned char hdctbl0[16] = {
-	0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0
-};
-
-static const unsigned char hdctblg0[12] = {
-	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0xa, 0xb
-};
-static const unsigned char hactbl0[16] = {
-	0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 0x7d
-};
-static const unsigned char hactblg0[162] = {
-	0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
-	0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
-	0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
-	0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
-	0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
-	0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
-	0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
-	0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
-	0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
-	0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
-	0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
-	0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
-	0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
-	0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
-	0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
-	0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
-	0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
-	0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
-	0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
-	0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
-	0xf9, 0xfa
-};
-
-static inline void jpeg_set_qtbl(void __iomem *regs, const unsigned char *qtbl,
-		   unsigned long tab, int len)
-{
-	int i;
-
-	for (i = 0; i < len; i++)
-		writel((unsigned int)qtbl[i], regs + tab + (i * 0x04));
-}
-
-static inline void jpeg_set_qtbl_lum(void __iomem *regs, int quality)
-{
-	/* this driver fills quantisation table 0 with data for luma */
-	jpeg_set_qtbl(regs, qtbl_luminance[quality], S5P_JPG_QTBL_CONTENT(0),
-		      ARRAY_SIZE(qtbl_luminance[quality]));
-}
-
-static inline void jpeg_set_qtbl_chr(void __iomem *regs, int quality)
-{
-	/* this driver fills quantisation table 1 with data for chroma */
-	jpeg_set_qtbl(regs, qtbl_chrominance[quality], S5P_JPG_QTBL_CONTENT(1),
-		      ARRAY_SIZE(qtbl_chrominance[quality]));
-}
-
-static inline void jpeg_set_htbl(void __iomem *regs, const unsigned char *htbl,
-		   unsigned long tab, int len)
-{
-	int i;
-
-	for (i = 0; i < len; i++)
-		writel((unsigned int)htbl[i], regs + tab + (i * 0x04));
-}
-
-static inline void jpeg_set_hdctbl(void __iomem *regs)
-{
-	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hdctbl0, S5P_JPG_HDCTBL(0), ARRAY_SIZE(hdctbl0));
-}
-
-static inline void jpeg_set_hdctblg(void __iomem *regs)
-{
-	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hdctblg0, S5P_JPG_HDCTBLG(0), ARRAY_SIZE(hdctblg0));
-}
-
-static inline void jpeg_set_hactbl(void __iomem *regs)
-{
-	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hactbl0, S5P_JPG_HACTBL(0), ARRAY_SIZE(hactbl0));
-}
-
-static inline void jpeg_set_hactblg(void __iomem *regs)
-{
-	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hactblg0, S5P_JPG_HACTBLG(0), ARRAY_SIZE(hactblg0));
-}
-
 /*
  * ============================================================================
  * Device file operations
@@ -890,78 +714,7 @@ static const struct v4l2_ioctl_ops s5p_jpeg_ioctl_ops = {
 
 static void s5p_jpeg_device_run(void *priv)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
-	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *src_buf, *dst_buf;
-	unsigned long src_addr, dst_addr;
-
-	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
-	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
-
-	jpeg_reset(jpeg->regs);
-	jpeg_poweron(jpeg->regs);
-	jpeg_proc_mode(jpeg->regs, ctx->mode);
-	if (ctx->mode == S5P_JPEG_ENCODE) {
-		if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB565)
-			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_565);
-		else
-			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_422);
-		if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV)
-			jpeg_subsampling_mode(jpeg->regs,
-					      S5P_JPEG_SUBSAMPLING_422);
-		else
-			jpeg_subsampling_mode(jpeg->regs,
-					      S5P_JPEG_SUBSAMPLING_420);
-		jpeg_dri(jpeg->regs, 0);
-		jpeg_x(jpeg->regs, ctx->out_q.w);
-		jpeg_y(jpeg->regs, ctx->out_q.h);
-		jpeg_imgadr(jpeg->regs, src_addr);
-		jpeg_jpgadr(jpeg->regs, dst_addr);
-
-		/* ultimately comes from sizeimage from userspace */
-		jpeg_enc_stream_int(jpeg->regs, ctx->cap_q.size);
-
-		/* JPEG RGB to YCbCr conversion matrix */
-		jpeg_coef(jpeg->regs, 1, 1, S5P_JPEG_COEF11);
-		jpeg_coef(jpeg->regs, 1, 2, S5P_JPEG_COEF12);
-		jpeg_coef(jpeg->regs, 1, 3, S5P_JPEG_COEF13);
-		jpeg_coef(jpeg->regs, 2, 1, S5P_JPEG_COEF21);
-		jpeg_coef(jpeg->regs, 2, 2, S5P_JPEG_COEF22);
-		jpeg_coef(jpeg->regs, 2, 3, S5P_JPEG_COEF23);
-		jpeg_coef(jpeg->regs, 3, 1, S5P_JPEG_COEF31);
-		jpeg_coef(jpeg->regs, 3, 2, S5P_JPEG_COEF32);
-		jpeg_coef(jpeg->regs, 3, 3, S5P_JPEG_COEF33);
-
-		/*
-		 * JPEG IP allows storing 4 quantization tables
-		 * We fill table 0 for luma and table 1 for chroma
-		 */
-		jpeg_set_qtbl_lum(jpeg->regs, ctx->compr_quality);
-		jpeg_set_qtbl_chr(jpeg->regs, ctx->compr_quality);
-		/* use table 0 for Y */
-		jpeg_qtbl(jpeg->regs, 1, 0);
-		/* use table 1 for Cb and Cr*/
-		jpeg_qtbl(jpeg->regs, 2, 1);
-		jpeg_qtbl(jpeg->regs, 3, 1);
-
-		/* Y, Cb, Cr use Huffman table 0 */
-		jpeg_htbl_ac(jpeg->regs, 1);
-		jpeg_htbl_dc(jpeg->regs, 1);
-		jpeg_htbl_ac(jpeg->regs, 2);
-		jpeg_htbl_dc(jpeg->regs, 2);
-		jpeg_htbl_ac(jpeg->regs, 3);
-		jpeg_htbl_dc(jpeg->regs, 3);
-	} else {
-		jpeg_rst_int_enable(jpeg->regs, true);
-		jpeg_data_num_int_enable(jpeg->regs, true);
-		jpeg_final_mcu_num_int_enable(jpeg->regs, true);
-		jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_422);
-		jpeg_jpgadr(jpeg->regs, src_addr);
-		jpeg_imgadr(jpeg->regs, dst_addr);
-	}
-	jpeg_start(jpeg->regs);
+	s5p_jpeg_execute(priv);
 }
 
 static int s5p_jpeg_job_ready(void *priv)
@@ -1153,46 +906,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 
 static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 {
-	struct s5p_jpeg *jpeg = dev_id;
-	struct s5p_jpeg_ctx *curr_ctx;
-	struct vb2_buffer *src_buf, *dst_buf;
-	unsigned long payload_size = 0;
-	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
-	bool enc_jpeg_too_large = false;
-	bool timer_elapsed = false;
-	bool op_completed = false;
-
-	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
-
-	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
-	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
-
-	if (curr_ctx->mode == S5P_JPEG_ENCODE)
-		enc_jpeg_too_large = jpeg_enc_stream_stat(jpeg->regs);
-	timer_elapsed = jpeg_timer_stat(jpeg->regs);
-	op_completed = jpeg_result_stat_ok(jpeg->regs);
-	if (curr_ctx->mode == S5P_JPEG_DECODE)
-		op_completed = op_completed && jpeg_stream_stat_ok(jpeg->regs);
-
-	if (enc_jpeg_too_large) {
-		state = VB2_BUF_STATE_ERROR;
-		jpeg_clear_enc_stream_stat(jpeg->regs);
-	} else if (timer_elapsed) {
-		state = VB2_BUF_STATE_ERROR;
-		jpeg_clear_timer_stat(jpeg->regs);
-	} else if (!op_completed) {
-		state = VB2_BUF_STATE_ERROR;
-	} else {
-		payload_size = jpeg_compressed_size(jpeg->regs);
-	}
-
-	v4l2_m2m_buf_done(src_buf, state);
-	if (curr_ctx->mode == S5P_JPEG_ENCODE)
-		vb2_set_plane_payload(dst_buf, 0, payload_size);
-	v4l2_m2m_buf_done(dst_buf, state);
-	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->m2m_ctx);
-
-	jpeg_clear_int(jpeg->regs);
+	s5p_jpeg_irq_execute(dev_id);
 
 	return IRQ_HANDLED;
 }
@@ -1425,15 +1139,8 @@ static int s5p_jpeg_runtime_suspend(struct device *dev)
 
 static int s5p_jpeg_runtime_resume(struct device *dev)
 {
-	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
-	/*
-	 * JPEG IP allows storing two Huffman tables for each component
-	 * We fill table 0 for each component
-	 */
-	jpeg_set_hdctbl(jpeg->regs);
-	jpeg_set_hdctblg(jpeg->regs);
-	jpeg_set_hactbl(jpeg->regs);
-	jpeg_set_hactblg(jpeg->regs);
+	s5p_jpeg_runtime_resume_execute(dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-jpeg/jpeg-hw-common.h b/drivers/media/video/s5p-jpeg/jpeg-hw-common.h
new file mode 100644
index 0000000..c649598
--- /dev/null
+++ b/drivers/media/video/s5p-jpeg/jpeg-hw-common.h
@@ -0,0 +1,34 @@
+/* linux/drivers/media/video/s5p-jpeg/jpeg-hw.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef JPEG_HW_COMMON_H_
+#define JPEG_HW_COMMON_H_
+
+#include <linux/io.h>
+#include <linux/delay.h>
+
+void s5p_jpeg_execute(void *priv);
+void s5p_jpeg_irq_execute(void *dev_id);
+void s5p_jpeg_runtime_resume_execute(struct device *dev);
+
+#define S5P_JPEG_MIN_WIDTH		32
+#define S5P_JPEG_MIN_HEIGHT		32
+#define S5P_JPEG_MAX_WIDTH		8192
+#define S5P_JPEG_MAX_HEIGHT		8192
+#define S5P_JPEG_ENCODE			0
+#define S5P_JPEG_DECODE			1
+#define S5P_JPEG_RAW_IN_565		0
+#define S5P_JPEG_RAW_IN_422		1
+#define S5P_JPEG_SUBSAMPLING_422	0
+#define S5P_JPEG_SUBSAMPLING_420	1
+#define S5P_JPEG_RAW_OUT_422		0
+#define S5P_JPEG_RAW_OUT_420		1
+#endif /* JPEG_HW_COMMON_H_ */
diff --git a/drivers/media/video/s5p-jpeg/jpeg-hw-v2x.h b/drivers/media/video/s5p-jpeg/jpeg-hw-v2x.h
new file mode 100644
index 0000000..90bd60b
--- /dev/null
+++ b/drivers/media/video/s5p-jpeg/jpeg-hw-v2x.h
@@ -0,0 +1,387 @@
+/* linux/drivers/media/video/s5p-jpeg/jpeg-hw-v2x.h
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef JPEG_HW_V2X_H_
+#define JPEG_HW_V2X_H_
+
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include "jpeg-regs-v2x.h"
+
+#define S5P_JPEG_MIN_WIDTH		32
+#define S5P_JPEG_MIN_HEIGHT		32
+#define S5P_JPEG_MAX_WIDTH		8192
+#define S5P_JPEG_MAX_HEIGHT		8192
+#define S5P_JPEG_ENCODE			0
+#define S5P_JPEG_DECODE			1
+#define S5P_JPEG_RAW_IN_565		0
+#define S5P_JPEG_RAW_IN_422		1
+#define S5P_JPEG_SUBSAMPLING_422	0
+#define S5P_JPEG_SUBSAMPLING_420	1
+#define S5P_JPEG_RAW_OUT_422		0
+#define S5P_JPEG_RAW_OUT_420		1
+
+/* Q-table for JPEG */
+/*  ITU standard Q-table */
+static unsigned int ITU_Q_tbl[4][16] = {
+	{
+	0x01010101, 0x01020303, 0x01010101, 0x01030303, /* Y */
+	0x01010101, 0x02030303, 0x01010101, 0x03040403,
+	0x01010203, 0x03050504, 0x01020303, 0x04050605,
+	0x02030404, 0x05060605, 0x04050505, 0x06050505
+	} , {
+	0x01010102, 0x05050505, 0x01010103, 0x05050505, /* CbCr */
+	0x01010503, 0x05050505, 0x02030505, 0x05050505,
+	0x05050505, 0x05050505, 0x05050505, 0x05050505,
+	0x05050505, 0x05050505, 0x05050505, 0x05050505
+	} , {
+	0x05020205, 0x0a161e25, 0x02020307, 0x0c232521, /* Y */
+	0x0302050a, 0x16222b22, 0x0305090e, 0x1e393326,
+	0x06091422, 0x2a384431, 0x0a122118, 0x34454b3c,
+	0x1d283238, 0x44525142, 0x2d3c3e40, 0x4a424441
+	} , {
+	0x05020205, 0x251e160a, 0x07030202, 0x2125230c, /* CbCr */
+	0x0a050203, 0x222b2216, 0x0e090503, 0x2633391e,
+	0x22140906, 0x3144382a, 0x1821120a, 0x3c4b4534,
+	0x3832281d, 0x42515244, 0x403e3c2d, 0x4144424a
+	}
+};
+
+/* ITU Luminace Huffman Table */
+static unsigned int ITU_H_tbl_len_DC_luminance[4] = {
+	0x01050100, 0x01010101, 0x00000001, 0x00000000
+};
+static unsigned int ITU_H_tbl_val_DC_luminance[3] = {
+	0x03020100, 0x07060504, 0x0b0a0908
+};
+
+/* ITU Chrominace Huffman Table */
+static unsigned int ITU_H_tbl_len_DC_chrominance[4] = {
+	0x01010300, 0x01010101, 0x00010101, 0x00000000
+};
+static unsigned int ITU_H_tbl_val_DC_chrominance[3] = {
+	0x03020100, 0x07060504, 0x0b0a0908
+};
+
+static unsigned int ITU_H_tbl_len_AC_luminance[4] = {
+	0x03010200, 0x03040203, 0x04040505, 0x7d010000
+};
+
+static unsigned int ITU_H_tbl_val_AC_luminance[41] = {
+	0x00030201, 0x12051104, 0x06413121, 0x07615113,
+	0x32147122, 0x08a19181, 0xc1b14223, 0xf0d15215,
+	0x72623324, 0x160a0982, 0x1a191817, 0x28272625,
+	0x35342a29, 0x39383736, 0x4544433a, 0x49484746,
+	0x5554534a, 0x59585756, 0x6564635a, 0x69686766,
+	0x7574736a, 0x79787776, 0x8584837a, 0x89888786,
+	0x9493928a, 0x98979695, 0xa3a29a99, 0xa7a6a5a4,
+	0xb2aaa9a8, 0xb6b5b4b3, 0xbab9b8b7, 0xc5c4c3c2,
+	0xc9c8c7c6, 0xd4d3d2ca, 0xd8d7d6d5, 0xe2e1dad9,
+	0xe6e5e4e3, 0xeae9e8e7, 0xf4f3f2f1, 0xf8f7f6f5,
+	0x0000faf9
+};
+
+static u32 ITU_H_tbl_len_AC_chrominance[4] = {
+	0x02010200, 0x04030404, 0x04040507, 0x77020100
+};
+static u32 ITU_H_tbl_val_AC_chrominance[41] = {
+	0x03020100, 0x21050411, 0x41120631, 0x71610751,
+	0x81322213, 0x91421408, 0x09c1b1a1, 0xf0523323,
+	0xd1726215, 0x3424160a, 0x17f125e1, 0x261a1918,
+	0x2a292827, 0x38373635, 0x44433a39, 0x48474645,
+	0x54534a49, 0x58575655, 0x64635a59, 0x68676665,
+	0x74736a69, 0x78777675, 0x83827a79, 0x87868584,
+	0x928a8988, 0x96959493, 0x9a999897, 0xa5a4a3a2,
+	0xa9a8a7a6, 0xb4b3b2aa, 0xb8b7b6b5, 0xc3c2bab9,
+	0xc7c6c5c4, 0xd2cac9c8, 0xd6d5d4d3, 0xdad9d8d7,
+	0xe5e4e3e2, 0xe9e8e7e6, 0xf4f3f2ea, 0xf8f7f6f5,
+	0x0000faf9
+};
+
+static inline void jpeg_reset(void __iomem *regs)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPEG_CNTL_REG);
+	writel(reg & ~S5P_JPEG_SOFT_RESET_HI,
+			regs + S5P_JPEG_CNTL_REG);
+
+	ndelay(100000);
+
+	writel(reg | S5P_JPEG_SOFT_RESET_HI,
+			regs + S5P_JPEG_CNTL_REG);
+
+}
+
+static inline void jpeg_input_raw_mode(void __iomem *regs, unsigned long mode)
+{
+	unsigned long reg, m;
+
+	if (mode == S5P_JPEG_RAW_IN_565)
+		m = S5P_JPEG_ENC_RGB_IMG |
+				S5P_JPEG_RGB_IP_RGB_16BIT_IMG;
+	else if (mode == S5P_JPEG_RAW_IN_422)
+		m = S5P_JPEG_ENC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_1P_IMG;
+
+	reg = readl(regs + S5P_JPEG_IMG_FMT_REG) &
+			S5P_JPEG_ENC_IN_FMT_MASK; /* clear except enc format */
+	reg |= m;
+
+	writel(reg, regs + S5P_JPEG_IMG_FMT_REG);
+}
+
+static inline void jpeg_proc_mode(void __iomem *regs, unsigned long mode)
+{
+	unsigned int reg, m;
+
+	m = S5P_JPEG_DEC_MODE;
+	if (mode == S5P_JPEG_ENCODE)
+		m = S5P_JPEG_ENC_MODE;
+	else
+		m = S5P_JPEG_DEC_MODE;
+
+	reg = readl(regs + S5P_JPEG_CNTL_REG);
+	reg &= S5P_JPEG_ENC_DEC_MODE_MASK;
+	reg |= m;
+
+	writel(reg, regs + S5P_JPEG_CNTL_REG);
+}
+
+static inline void jpeg_set_dec_bitstream_size(void __iomem *regs, u32 size)
+{
+	writel(size, regs + S5P_JPEG_BITSTREAM_SIZE_REG);
+}
+
+static inline void jpeg_subsampling_mode(void __iomem *regs, unsigned long mode)
+{
+	unsigned long reg, m;
+
+	m = S5P_JPEG_ENC_FMT_YUV_422;
+	if (mode == S5P_JPEG_SUBSAMPLING_422)
+		m = S5P_JPEG_ENC_FMT_YUV_422;
+	else if (mode == S5P_JPEG_SUBSAMPLING_420)
+		m = S5P_JPEG_ENC_FMT_YUV_420;
+
+	reg = readl(regs + S5P_JPEG_IMG_FMT_REG);
+	reg &= ~S5P_JPEG_ENC_FMT_MASK;
+	reg |= m;
+
+	writel(reg, regs + S5P_JPEG_IMG_FMT_REG);
+}
+
+static void jpeg_set_encode_tbl_select(void __iomem *regs,
+		int quality)
+{
+	unsigned int	reg;
+
+	switch (quality) {
+	case 0:
+		reg = S5P_JPEG_Q_TBL_COMP1_0 | S5P_JPEG_Q_TBL_COMP2_1 |
+			S5P_JPEG_Q_TBL_COMP3_1 |
+			S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1;
+		break;
+	case 1:
+		reg = S5P_JPEG_Q_TBL_COMP1_0 | S5P_JPEG_Q_TBL_COMP2_3 |
+			S5P_JPEG_Q_TBL_COMP3_3 |
+			S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1;
+		break;
+	case 2:
+		reg = S5P_JPEG_Q_TBL_COMP1_2 | S5P_JPEG_Q_TBL_COMP2_1 |
+			S5P_JPEG_Q_TBL_COMP3_1 |
+			S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1;
+		break;
+	case 3:
+		reg = S5P_JPEG_Q_TBL_COMP1_2 | S5P_JPEG_Q_TBL_COMP2_3 |
+			S5P_JPEG_Q_TBL_COMP3_3 |
+			S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1;
+		break;
+	default:
+		reg = S5P_JPEG_Q_TBL_COMP1_0 | S5P_JPEG_Q_TBL_COMP2_1 |
+			S5P_JPEG_Q_TBL_COMP3_1 |
+			S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1;
+		break;
+	}
+	writel(reg, regs + S5P_JPEG_TBL_SEL_REG);
+}
+
+static inline void jpeg_x_y(void __iomem *regs, unsigned int x, unsigned int y)
+{
+	writel(0x0, regs + S5P_JPEG_IMG_SIZE_REG); /* clear */
+	writel(S5P_JPEG_X_SIZE(x) | S5P_JPEG_Y_SIZE(y),
+			regs + S5P_JPEG_IMG_SIZE_REG);
+}
+
+static inline void jpeg_set_dec_scaling(void __iomem *regs,
+		int x_value, int y_value)
+{
+	unsigned int	reg;
+
+	reg = readl(regs + S5P_JPEG_CNTL_REG) &
+			~(S5P_JPEG_HOR_SCALING_MASK |
+				S5P_JPEG_VER_SCALING_MASK);
+
+	writel(reg | S5P_JPEG_HOR_SCALING(x_value) |
+			S5P_JPEG_VER_SCALING(y_value),
+				regs + S5P_JPEG_CNTL_REG);
+}
+
+static inline void jpeg_outform_raw(void __iomem *regs, unsigned long format)
+{
+	unsigned long reg;
+
+	writel(0, regs + S5P_JPEG_IMG_FMT_REG); /* clear */
+
+	if (format == S5P_JPEG_RAW_OUT_422)
+		reg = S5P_JPEG_DEC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_1P_IMG;
+	else if (format == S5P_JPEG_RAW_OUT_420)
+		reg = S5P_JPEG_DEC_YUV_420_IMG |
+				S5P_JPEG_YUV_420_IP_YUV_420_3P_IMG;
+
+	writel(reg, regs + S5P_JPEG_IMG_FMT_REG);
+}
+
+static inline void jpeg_jpgadr(void __iomem *regs, unsigned long addr)
+{
+	writel(addr, regs + S5P_JPEG_OUT_MEM_BASE_REG);
+}
+
+static inline void jpeg_dec_imgadr(void __iomem *regs, unsigned long addr,
+			unsigned long format, u32 width, u32 height)
+{
+	if (format == S5P_JPEG_RAW_OUT_422) {
+		writel(addr, regs + S5P_JPEG_IMG_BA_PLANE_1_REG);
+		writel(0, regs + S5P_JPEG_IMG_BA_PLANE_2_REG);
+		writel(0, regs + S5P_JPEG_IMG_BA_PLANE_3_REG);
+	} else if (format == S5P_JPEG_RAW_OUT_420) {
+		writel(addr, regs + S5P_JPEG_IMG_BA_PLANE_1_REG);
+		writel(addr + width * height,
+			regs + S5P_JPEG_IMG_BA_PLANE_2_REG);
+		writel(addr + width * height + (width * height / 4),
+			regs + S5P_JPEG_IMG_BA_PLANE_3_REG);
+	}
+}
+
+static inline void jpeg_enc_imgadr(void __iomem *regs, unsigned long addr)
+{
+	writel(addr, regs + S5P_JPEG_IMG_BA_PLANE_1_REG);
+}
+
+static unsigned int jpeg_get_int_status(void __iomem *regs)
+{
+	return readl(regs + S5P_JPEG_INT_STATUS_REG);
+}
+
+static void jpeg_set_interrupt(void __iomem *regs)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPEG_INT_EN_REG) & ~S5P_JPEG_INT_EN_MASK;
+	writel(S5P_JPEG_INT_EN_ALL, regs + S5P_JPEG_INT_EN_REG);
+}
+
+static void jpeg_set_huf_table_enable(void __iomem *regs, int value)
+{
+	unsigned long	reg;
+
+	reg = readl(regs + S5P_JPEG_CNTL_REG) & ~S5P_JPEG_HUF_TBL_EN;
+
+	if (value == 1)
+		writel(reg | S5P_JPEG_HUF_TBL_EN, regs + S5P_JPEG_CNTL_REG);
+	else
+		writel(reg | ~S5P_JPEG_HUF_TBL_EN, regs + S5P_JPEG_CNTL_REG);
+}
+
+static inline void jpeg_qtbl(void __iomem *regs)
+{
+	int i;
+
+	for (i = 0; i < 16; i++)
+		writel((unsigned int)ITU_Q_tbl[0][i],
+			regs + S5P_JPEG_QUAN_TBL_ENTRY_REG + (i*0x04));
+
+	for (i = 0; i < 16; i++)
+		writel((unsigned int)ITU_Q_tbl[1][i],
+			regs + S5P_JPEG_QUAN_TBL_ENTRY_REG + 0x40 + (i*0x04));
+
+	for (i = 0; i < 16; i++)
+		writel((unsigned int)ITU_Q_tbl[2][i],
+			regs + S5P_JPEG_QUAN_TBL_ENTRY_REG + 0x80 + (i*0x04));
+
+	for (i = 0; i < 16; i++)
+		writel((unsigned int)ITU_Q_tbl[3][i],
+			regs + S5P_JPEG_QUAN_TBL_ENTRY_REG + 0xc0 + (i*0x04));
+}
+
+static inline void jpeg_htbl_ac(void __iomem *regs)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		writel((unsigned int)ITU_H_tbl_len_AC_luminance[i],
+			regs + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x40 + (i*0x04));
+
+	for (i = 0; i < 41; i++)
+		writel((unsigned int)ITU_H_tbl_val_AC_luminance[i],
+			regs + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x50 + (i*0x04));
+
+	for (i = 0; i < 4; i++)
+		writel((unsigned int)ITU_H_tbl_len_AC_chrominance[i],
+			regs + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x100 + (i*0x04));
+
+	for (i = 0; i < 41; i++)
+		writel((unsigned int)ITU_H_tbl_val_AC_chrominance[i],
+			regs + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x110 + (i*0x04));
+}
+
+static inline void jpeg_htbl_dc(void __iomem *regs)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		writel((unsigned int)ITU_H_tbl_len_DC_luminance[i],
+			regs + S5P_JPEG_HUFF_TBL_ENTRY_REG + (i*0x04));
+
+	for (i = 0; i < 3; i++)
+		writel((unsigned int)ITU_H_tbl_val_DC_luminance[i],
+			regs + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x10 + (i*0x04));
+
+	for (i = 0; i < 4; i++)
+		writel((unsigned int)ITU_H_tbl_len_DC_chrominance[i],
+			regs + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x20 + (i*0x04));
+
+	for (i = 0; i < 3; i++)
+		writel((unsigned int)ITU_H_tbl_val_DC_chrominance[i],
+			regs + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x30 + (i*0x04));
+}
+
+static void jpeg_set_encode_hoff_cnt(void __iomem *regs)
+{
+	writel(0x1a2, regs + S5P_JPEG_HUFF_CNT_REG);
+}
+
+static unsigned int jpeg_compressed_size(void __iomem *regs)
+{
+	return readl(regs + S5P_JPEG_BITSTREAM_SIZE_REG);
+}
+
+#endif /* JPEG_HW_V2X_H_ */
diff --git a/drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h b/drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h
new file mode 100644
index 0000000..8305475
--- /dev/null
+++ b/drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h
@@ -0,0 +1,150 @@
+/* linux/drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h
+ *
+ * Register definition file for Samsung JPEG codec driver
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http:www.samsung.com
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef JPEG_REGS_H_
+#define JPEG_REGS_H_
+
+/* JPEG Codec Control Registers */
+#define S5P_JPEG_CNTL_REG		0x00
+#define S5P_JPEG_INT_EN_REG		0x04
+#define S5P_JPEG_INT_STATUS_REG		0x0c
+#define S5P_JPEG_OUT_MEM_BASE_REG		0x10
+#define S5P_JPEG_IMG_SIZE_REG		0x14
+#define S5P_JPEG_IMG_BA_PLANE_1_REG		0x18
+#define S5P_JPEG_IMG_BA_PLANE_2_REG		0x24
+#define S5P_JPEG_IMG_BA_PLANE_3_REG		0x30
+
+#define S5P_JPEG_TBL_SEL_REG		0x3c
+
+#define S5P_JPEG_IMG_FMT_REG		0x40
+
+#define S5P_JPEG_BITSTREAM_SIZE_REG		0x44
+#define S5P_JPEG_HUFF_CNT_REG		0x4c
+
+#define S5P_JPEG_QUAN_TBL_ENTRY_REG		0x100
+#define S5P_JPEG_HUFF_TBL_ENTRY_REG		0x200
+
+
+/****************************************************************/
+/* Bit definition part												*/
+/****************************************************************/
+
+/* JPEG CNTL Register bit */
+#define S5P_JPEG_ENC_DEC_MODE_MASK			(0xfffffffc << 0)
+#define S5P_JPEG_DEC_MODE			(1 << 0)
+#define S5P_JPEG_ENC_MODE			(1 << 1)
+#define S5P_JPEG_HUF_TBL_EN			(1 << 19)
+#define S5P_JPEG_HOR_SCALING_SHIFT		20
+#define S5P_JPEG_HOR_SCALING_MASK		\
+			(3 << S5P_JPEG_HOR_SCALING_SHIFT)
+#define S5P_JPEG_HOR_SCALING(x)			\
+			(((x) & 0x3) << S5P_JPEG_HOR_SCALING_SHIFT)
+#define S5P_JPEG_VER_SCALING_SHIFT		22
+#define S5P_JPEG_VER_SCALING_MASK		\
+			(3 << S5P_JPEG_VER_SCALING_SHIFT)
+#define S5P_JPEG_VER_SCALING(x)			\
+			(((x) & 0x3) << S5P_JPEG_VER_SCALING_SHIFT)
+#define S5P_JPEG_SOFT_RESET_HI			(1 << 29)
+
+/* JPEG INT Register bit */
+#define S5P_JPEG_INT_EN_MASK			(0x1f << 0)
+#define S5P_JPEG_INT_EN_ALL			(0x1f << 0)
+
+/* JPEG IMAGE SIZE Register bit */
+#define S5P_JPEG_X_SIZE_SHIFT		0
+#define S5P_JPEG_X_SIZE_MASK		(0xffff << S5P_JPEG_X_SIZE_SHIFT)
+#define S5P_JPEG_X_SIZE(x)			\
+			(((x) & 0xffff) << S5P_JPEG_X_SIZE_SHIFT)
+#define S5P_JPEG_Y_SIZE_SHIFT		16
+#define S5P_JPEG_Y_SIZE_MASK		(0xffff << S5P_JPEG_Y_SIZE_SHIFT)
+#define S5P_JPEG_Y_SIZE(x)			\
+			(((x) & 0xffff) << S5P_JPEG_Y_SIZE_SHIFT)
+
+/* JPEG IMAGE FORMAT Register bit */
+#define S5P_JPEG_ENC_IN_FMT_MASK		0xffff0000
+#define S5P_JPEG_ENC_RGB_IMG		(1 << 0)
+#define S5P_JPEG_RGB_IP_SHIFT		6
+#define S5P_JPEG_RGB_IP_RGB_16BIT_IMG		(4 << S5P_JPEG_RGB_IP_SHIFT)
+#define S5P_JPEG_ENC_YUV_422_IMG		(3 << 0)
+
+/* JPEG IMAGE FORMAT Register bit */
+#define S5P_JPEG_ENC_IN_FMT_MASK		0xffff0000
+#define S5P_JPEG_DEC_YUV_422_IMG		(3 << 0)
+#define S5P_JPEG_DEC_YUV_420_IMG		(4 << 0)
+
+#define S5P_JPEG_YUV_422_IP_SHIFT		12
+#define S5P_JPEG_YUV_422_IP_MASK		(7 << S5P_JPEG_YUV_422_IP_SHIFT)
+#define S5P_JPEG_YUV_422_IP_YUV_422_1P_IMG		\
+			(4 << S5P_JPEG_YUV_422_IP_SHIFT)
+
+#define S5P_JPEG_YUV_420_IP_SHIFT		15
+#define S5P_JPEG_YUV_420_IP_MASK		(7 << S5P_JPEG_YUV_420_IP_SHIFT)
+#define S5P_JPEG_YUV_420_IP_YUV_420_3P_IMG		\
+			(5 << S5P_JPEG_YUV_420_IP_SHIFT)
+
+#define S5P_JPEG_ENC_FMT_SHIFT		24
+#define S5P_JPEG_ENC_FMT_MASK		(3 << S5P_JPEG_ENC_FMT_SHIFT)
+#define S5P_JPEG_ENC_FMT_YUV_444		(1 << S5P_JPEG_ENC_FMT_SHIFT)
+#define S5P_JPEG_ENC_FMT_YUV_422		(2 << S5P_JPEG_ENC_FMT_SHIFT)
+#define S5P_JPEG_ENC_FMT_YUV_420		(3 << S5P_JPEG_ENC_FMT_SHIFT)
+
+/* JPEG TBL SEL Register bit */
+#define S5P_JPEG_Q_TBL_COMP1_SHIFT	0
+#define S5P_JPEG_Q_TBL_COMP1_0		(0 << S5P_JPEG_Q_TBL_COMP1_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP1_1		(1 << S5P_JPEG_Q_TBL_COMP1_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP1_2		(2 << S5P_JPEG_Q_TBL_COMP1_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP1_3		(3 << S5P_JPEG_Q_TBL_COMP1_SHIFT)
+
+#define S5P_JPEG_Q_TBL_COMP2_SHIFT	2
+#define S5P_JPEG_Q_TBL_COMP2_0		(0 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP2_1		(1 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP2_2		(2 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP2_3		(3 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+
+#define S5P_JPEG_Q_TBL_COMP3_SHIFT	4
+#define S5P_JPEG_Q_TBL_COMP3_0		(0 << S5P_JPEG_Q_TBL_COMP3_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP3_1		(1 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP3_2		(2 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP3_3		(3 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+
+#define S5P_JPEG_HUFF_TBL_COMP1_SHIFT			6
+#define S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_0		\
+			(0 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_1		\
+			(1 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP1_AC_1_DC_0		\
+			(2 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP1_AC_1_DC_1		\
+			(3 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
+
+#define S5P_JPEG_HUFF_TBL_COMP2_SHIFT			8
+#define S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0		\
+			(0 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_1		\
+			(1 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP2_AC_1_DC_0		\
+			(2 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP2_AC_1_DC_1		\
+			(3 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
+
+#define S5P_JPEG_HUFF_TBL_COMP3_SHIFT			10
+#define S5P_JPEG_HUFF_TBL_COMP3_AC_0_DC_0		\
+			(0 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP3_AC_0_DC_1		\
+			(1 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_0		\
+			(2 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1		\
+			(3 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
+
+#endif /* JPEG_REGS_H_ */
diff --git a/drivers/media/video/s5p-jpeg/jpeg-v2x.c b/drivers/media/video/s5p-jpeg/jpeg-v2x.c
new file mode 100644
index 0000000..71bd38b
--- /dev/null
+++ b/drivers/media/video/s5p-jpeg/jpeg-v2x.c
@@ -0,0 +1,129 @@
+/* linux/drivers/media/video/s5p-jpeg/jpeg-v2x.c
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "jpeg-core.h"
+#include "jpeg-hw-v2x.h"
+
+/*
+ * ============================================================================
+ * mem2mem callbacks
+ * ============================================================================
+ */
+
+void s5p_jpeg_irq_execute(void *dev_id)
+{
+	struct s5p_jpeg *jpeg = dev_id;
+	struct s5p_jpeg_ctx *curr_ctx;
+	struct vb2_buffer *src_buf, *dst_buf;
+	unsigned long payload_size = 0;
+	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
+
+	unsigned int int_status;
+
+	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
+
+	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
+
+	int_status = jpeg_get_int_status(jpeg->regs);
+
+	if (int_status != 0x2)
+		state = VB2_BUF_STATE_ERROR;
+
+	v4l2_m2m_buf_done(src_buf, state);
+	if (curr_ctx->mode == S5P_JPEG_ENCODE && int_status == 0x2) {
+		payload_size = jpeg_compressed_size(jpeg->regs);
+		vb2_set_plane_payload(dst_buf, 0, payload_size);
+	}
+	v4l2_m2m_buf_done(dst_buf, state);
+	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->m2m_ctx);
+}
+
+void s5p_jpeg_execute(void *priv)
+{
+	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	struct vb2_buffer *src_buf, *dst_buf;
+	unsigned long src_addr, dst_addr;
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+
+	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+
+	jpeg_reset(jpeg->regs);
+	jpeg_set_interrupt(jpeg->regs);
+
+	if (ctx->mode == S5P_JPEG_ENCODE) {
+		jpeg_set_huf_table_enable(jpeg->regs, 1);
+		jpeg_qtbl(jpeg->regs);
+		jpeg_htbl_ac(jpeg->regs);
+		jpeg_htbl_dc(jpeg->regs);
+		jpeg_set_encode_tbl_select(jpeg->regs, ctx->compr_quality);
+		jpeg_x_y(jpeg->regs, ctx->out_q.w, ctx->out_q.h);
+
+		if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB565)
+			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_565);
+		else
+			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_422);
+		if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV)
+			jpeg_subsampling_mode(jpeg->regs,
+					      S5P_JPEG_SUBSAMPLING_422);
+		else
+			jpeg_subsampling_mode(jpeg->regs,
+					      S5P_JPEG_SUBSAMPLING_420);
+
+		jpeg_enc_imgadr(jpeg->regs, src_addr);
+		jpeg_jpgadr(jpeg->regs, dst_addr);
+		jpeg_set_encode_hoff_cnt(jpeg->regs);
+	} else {
+		jpeg_set_encode_tbl_select(jpeg->regs, 0);
+		jpeg_set_dec_scaling(jpeg->regs, 0, 0);
+		jpeg_jpgadr(jpeg->regs, src_addr);
+		if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV) {
+			jpeg_dec_imgadr(jpeg->regs, dst_addr,
+						S5P_JPEG_RAW_OUT_422,
+						ctx->out_q.w, ctx->out_q.h);
+			jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_422);
+		} else {
+			jpeg_dec_imgadr(jpeg->regs, dst_addr,
+						S5P_JPEG_RAW_OUT_420,
+						ctx->out_q.w, ctx->out_q.h);
+			jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_420);
+		}
+		jpeg_set_dec_bitstream_size(jpeg->regs,
+						ctx->out_q.size / 32 + 1);
+	}
+	jpeg_proc_mode(jpeg->regs, ctx->mode);
+}
+
+void s5p_jpeg_runtime_resume_execute(struct device *dev)
+{
+
+}
diff --git a/drivers/media/video/s5p-jpeg/jpeg-v3.c b/drivers/media/video/s5p-jpeg/jpeg-v3.c
new file mode 100644
index 0000000..41a5038
--- /dev/null
+++ b/drivers/media/video/s5p-jpeg/jpeg-v3.c
@@ -0,0 +1,340 @@
+/* linux/drivers/media/video/s5p-jpeg/jpeg-v3.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "jpeg-core.h"
+#include "jpeg-hw.h"
+
+static const unsigned char qtbl_luminance[4][64] = {
+	{/* level 1 - high quality */
+		 8,  6,  6,  8, 12, 14, 16, 17,
+		 6,  6,  6,  8, 10, 13, 12, 15,
+		 6,  6,  7,  8, 13, 14, 18, 24,
+		 8,  8,  8, 14, 13, 19, 24, 35,
+		12, 10, 13, 13, 20, 26, 34, 39,
+		14, 13, 14, 19, 26, 34, 39, 39,
+		16, 12, 18, 24, 34, 39, 39, 39,
+		17, 15, 24, 35, 39, 39, 39, 39
+	},
+	{/* level 2 */
+		12,  8,  8, 12, 17, 21, 24, 23,
+		 8,  9,  9, 11, 15, 19, 18, 23,
+		 8,  9, 10, 12, 19, 20, 27, 36,
+		12, 11, 12, 21, 20, 28, 36, 53,
+		17, 15, 19, 20, 30, 39, 51, 59,
+		21, 19, 20, 28, 39, 51, 59, 59,
+		24, 18, 27, 36, 51, 59, 59, 59,
+		23, 23, 36, 53, 59, 59, 59, 59
+	},
+	{/* level 3 */
+		16, 11, 11, 16, 23, 27, 31, 30,
+		11, 12, 12, 15, 20, 23, 23, 30,
+		11, 12, 13, 16, 23, 26, 35, 47,
+		16, 15, 16, 23, 26, 37, 47, 64,
+		23, 20, 23, 26, 39, 51, 64, 64,
+		27, 23, 26, 37, 51, 64, 64, 64,
+		31, 23, 35, 47, 64, 64, 64, 64,
+		30, 30, 47, 64, 64, 64, 64, 64
+	},
+	{/*level 4 - low quality */
+		20, 16, 25, 39, 50, 46, 62, 68,
+		16, 18, 23, 38, 38, 53, 65, 68,
+		25, 23, 31, 38, 53, 65, 68, 68,
+		39, 38, 38, 53, 65, 68, 68, 68,
+		50, 38, 53, 65, 68, 68, 68, 68,
+		46, 53, 65, 68, 68, 68, 68, 68,
+		62, 65, 68, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68
+	}
+};
+
+static const unsigned char qtbl_chrominance[4][64] = {
+	{/* level 1 - high quality */
+		 9,  8,  9, 11, 14, 17, 19, 24,
+		 8, 10,  9, 11, 14, 13, 17, 22,
+		 9,  9, 13, 14, 13, 15, 23, 26,
+		11, 11, 14, 14, 15, 20, 26, 33,
+		14, 14, 13, 15, 20, 24, 33, 39,
+		17, 13, 15, 20, 24, 32, 39, 39,
+		19, 17, 23, 26, 33, 39, 39, 39,
+		24, 22, 26, 33, 39, 39, 39, 39
+	},
+	{/* level 2 */
+		13, 11, 13, 16, 20, 20, 29, 37,
+		11, 14, 14, 14, 16, 20, 26, 32,
+		13, 14, 15, 17, 20, 23, 35, 40,
+		16, 14, 17, 21, 23, 30, 40, 50,
+		20, 16, 20, 23, 30, 37, 50, 59,
+		20, 20, 23, 30, 37, 48, 59, 59,
+		29, 26, 35, 40, 50, 59, 59, 59,
+		37, 32, 40, 50, 59, 59, 59, 59
+	},
+	{/* level 3 */
+		17, 15, 17, 21, 20, 26, 38, 48,
+		15, 19, 18, 17, 20, 26, 35, 43,
+		17, 18, 20, 22, 26, 30, 46, 53,
+		21, 17, 22, 28, 30, 39, 53, 64,
+		20, 20, 26, 30, 39, 48, 64, 64,
+		26, 26, 30, 39, 48, 63, 64, 64,
+		38, 35, 46, 53, 64, 64, 64, 64,
+		48, 43, 53, 64, 64, 64, 64, 64
+	},
+	{/*level 4 - low quality */
+		21, 25, 32, 38, 54, 68, 68, 68,
+		25, 28, 24, 38, 54, 68, 68, 68,
+		32, 24, 32, 43, 66, 68, 68, 68,
+		38, 38, 43, 53, 68, 68, 68, 68,
+		54, 54, 66, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68
+	}
+};
+
+static const unsigned char hdctbl0[16] = {
+	0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0
+};
+
+static const unsigned char hdctblg0[12] = {
+	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0xa, 0xb
+};
+static const unsigned char hactbl0[16] = {
+	0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 0x7d
+};
+static const unsigned char hactblg0[162] = {
+	0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
+	0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
+	0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
+	0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
+	0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
+	0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
+	0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
+	0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
+	0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
+	0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
+	0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
+	0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
+	0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
+	0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
+	0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
+	0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
+	0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
+	0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
+	0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
+	0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
+	0xf9, 0xfa
+};
+
+static inline void jpeg_set_qtbl(void __iomem *regs, const unsigned char *qtbl,
+		   unsigned long tab, int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		writel((unsigned int)qtbl[i], regs + tab + (i * 0x04));
+}
+
+static inline void jpeg_set_qtbl_lum(void __iomem *regs, int quality)
+{
+	/* this driver fills quantisation table 0 with data for luma */
+	jpeg_set_qtbl(regs, qtbl_luminance[quality], S5P_JPG_QTBL_CONTENT(0),
+		      ARRAY_SIZE(qtbl_luminance[quality]));
+}
+
+static inline void jpeg_set_qtbl_chr(void __iomem *regs, int quality)
+{
+	/* this driver fills quantisation table 1 with data for chroma */
+	jpeg_set_qtbl(regs, qtbl_chrominance[quality], S5P_JPG_QTBL_CONTENT(1),
+		      ARRAY_SIZE(qtbl_chrominance[quality]));
+}
+
+static inline void jpeg_set_htbl(void __iomem *regs, const unsigned char *htbl,
+		   unsigned long tab, int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		writel((unsigned int)htbl[i], regs + tab + (i * 0x04));
+}
+
+static inline void jpeg_set_hdctbl(void __iomem *regs)
+{
+	/* this driver fills table 0 for this component */
+	jpeg_set_htbl(regs, hdctbl0, S5P_JPG_HDCTBL(0), ARRAY_SIZE(hdctbl0));
+}
+
+static inline void jpeg_set_hdctblg(void __iomem *regs)
+{
+	/* this driver fills table 0 for this component */
+	jpeg_set_htbl(regs, hdctblg0, S5P_JPG_HDCTBLG(0), ARRAY_SIZE(hdctblg0));
+}
+
+static inline void jpeg_set_hactbl(void __iomem *regs)
+{
+	/* this driver fills table 0 for this component */
+	jpeg_set_htbl(regs, hactbl0, S5P_JPG_HACTBL(0), ARRAY_SIZE(hactbl0));
+}
+
+static inline void jpeg_set_hactblg(void __iomem *regs)
+{
+	/* this driver fills table 0 for this component */
+	jpeg_set_htbl(regs, hactblg0, S5P_JPG_HACTBLG(0), ARRAY_SIZE(hactblg0));
+}
+
+void s5p_jpeg_irq_execute(void *dev_id)
+{
+	struct s5p_jpeg *jpeg = dev_id;
+	struct s5p_jpeg_ctx *curr_ctx;
+	struct vb2_buffer *src_buf, *dst_buf;
+	unsigned long payload_size = 0;
+	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
+	bool enc_jpeg_too_large = false;
+	bool timer_elapsed = false;
+	bool op_completed = false;
+
+	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
+
+	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
+
+	if (curr_ctx->mode == S5P_JPEG_ENCODE)
+		enc_jpeg_too_large = jpeg_enc_stream_stat(jpeg->regs);
+	timer_elapsed = jpeg_timer_stat(jpeg->regs);
+	op_completed = jpeg_result_stat_ok(jpeg->regs);
+	if (curr_ctx->mode == S5P_JPEG_DECODE)
+		op_completed = op_completed && jpeg_stream_stat_ok(jpeg->regs);
+
+	if (enc_jpeg_too_large) {
+		state = VB2_BUF_STATE_ERROR;
+		jpeg_clear_enc_stream_stat(jpeg->regs);
+	} else if (timer_elapsed) {
+		state = VB2_BUF_STATE_ERROR;
+		jpeg_clear_timer_stat(jpeg->regs);
+	} else if (!op_completed) {
+		state = VB2_BUF_STATE_ERROR;
+	} else {
+		payload_size = jpeg_compressed_size(jpeg->regs);
+	}
+
+	v4l2_m2m_buf_done(src_buf, state);
+	if (curr_ctx->mode == S5P_JPEG_ENCODE)
+		vb2_set_plane_payload(dst_buf, 0, payload_size);
+	v4l2_m2m_buf_done(dst_buf, state);
+	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->m2m_ctx);
+
+	jpeg_clear_int(jpeg->regs);
+}
+
+void s5p_jpeg_execute(void *priv)
+{
+	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	struct vb2_buffer *src_buf, *dst_buf;
+	unsigned long src_addr, dst_addr;
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+
+	jpeg_reset(jpeg->regs);
+	jpeg_poweron(jpeg->regs);
+	jpeg_proc_mode(jpeg->regs, ctx->mode);
+	if (ctx->mode == S5P_JPEG_ENCODE) {
+		if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB565)
+			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_565);
+		else
+			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_422);
+		if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV)
+			jpeg_subsampling_mode(jpeg->regs,
+					      S5P_JPEG_SUBSAMPLING_422);
+		else
+			jpeg_subsampling_mode(jpeg->regs,
+					      S5P_JPEG_SUBSAMPLING_420);
+		jpeg_dri(jpeg->regs, 0);
+		jpeg_x(jpeg->regs, ctx->out_q.w);
+		jpeg_y(jpeg->regs, ctx->out_q.h);
+		jpeg_imgadr(jpeg->regs, src_addr);
+		jpeg_jpgadr(jpeg->regs, dst_addr);
+
+		/* ultimately comes from sizeimage from userspace */
+		jpeg_enc_stream_int(jpeg->regs, ctx->cap_q.size);
+
+		/* JPEG RGB to YCbCr conversion matrix */
+		jpeg_coef(jpeg->regs, 1, 1, S5P_JPEG_COEF11);
+		jpeg_coef(jpeg->regs, 1, 2, S5P_JPEG_COEF12);
+		jpeg_coef(jpeg->regs, 1, 3, S5P_JPEG_COEF13);
+		jpeg_coef(jpeg->regs, 2, 1, S5P_JPEG_COEF21);
+		jpeg_coef(jpeg->regs, 2, 2, S5P_JPEG_COEF22);
+		jpeg_coef(jpeg->regs, 2, 3, S5P_JPEG_COEF23);
+		jpeg_coef(jpeg->regs, 3, 1, S5P_JPEG_COEF31);
+		jpeg_coef(jpeg->regs, 3, 2, S5P_JPEG_COEF32);
+		jpeg_coef(jpeg->regs, 3, 3, S5P_JPEG_COEF33);
+
+		/*
+		 * JPEG IP allows storing 4 quantization tables
+		 * We fill table 0 for luma and table 1 for chroma
+		 */
+		jpeg_set_qtbl_lum(jpeg->regs, ctx->compr_quality);
+		jpeg_set_qtbl_chr(jpeg->regs, ctx->compr_quality);
+		/* use table 0 for Y */
+		jpeg_qtbl(jpeg->regs, 1, 0);
+		/* use table 1 for Cb and Cr*/
+		jpeg_qtbl(jpeg->regs, 2, 1);
+		jpeg_qtbl(jpeg->regs, 3, 1);
+
+		/* Y, Cb, Cr use Huffman table 0 */
+		jpeg_htbl_ac(jpeg->regs, 1);
+		jpeg_htbl_dc(jpeg->regs, 1);
+		jpeg_htbl_ac(jpeg->regs, 2);
+		jpeg_htbl_dc(jpeg->regs, 2);
+		jpeg_htbl_ac(jpeg->regs, 3);
+		jpeg_htbl_dc(jpeg->regs, 3);
+	} else {
+		jpeg_rst_int_enable(jpeg->regs, true);
+		jpeg_data_num_int_enable(jpeg->regs, true);
+		jpeg_final_mcu_num_int_enable(jpeg->regs, true);
+		jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_422);
+		jpeg_jpgadr(jpeg->regs, src_addr);
+		jpeg_imgadr(jpeg->regs, dst_addr);
+	}
+	jpeg_start(jpeg->regs);
+}
+
+void s5p_jpeg_runtime_resume_execute(struct device *dev)
+{
+	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
+	/*
+	 * JPEG IP allows storing two Huffman tables for each component
+	 * We fill table 0 for each component
+	 */
+	jpeg_set_hdctbl(jpeg->regs);
+	jpeg_set_hdctblg(jpeg->regs);
+	jpeg_set_hactbl(jpeg->regs);
+	jpeg_set_hactblg(jpeg->regs);
+}
-- 
1.7.1


