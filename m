Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56330 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab3LROtz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 09:49:55 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY000KP9BV51K80@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Dec 2013 23:49:53 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v3 1/8] s5p-jpeg: Split jpeg-hw.h to jpeg-hw-s5p.c and
 jpeg-hw-s5p.c
Date: Wed, 18 Dec 2013 15:49:28 +0100
Message-id: <1387378175-23399-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
References: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move function definitions from jpeg-hw.h to jpeg-hw-s5p.c,
add "s5p" prefix and put function declarations in the jpeg-hw-s5p.h.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/Makefile           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   99 ++++++++++----------
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |    5 +
 .../platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} |   82 +++++++---------
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h      |   63 +++++++++++++
 5 files changed, 154 insertions(+), 97 deletions(-)
 rename drivers/media/platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} (70%)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h

diff --git a/drivers/media/platform/s5p-jpeg/Makefile b/drivers/media/platform/s5p-jpeg/Makefile
index d18cb5e..faf6398 100644
--- a/drivers/media/platform/s5p-jpeg/Makefile
+++ b/drivers/media/platform/s5p-jpeg/Makefile
@@ -1,2 +1,2 @@
-s5p-jpeg-objs := jpeg-core.o
+s5p-jpeg-objs := jpeg-core.o jpeg-hw-s5p.o
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG) += s5p-jpeg.o
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index e907738..bfacaec 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -29,7 +29,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "jpeg-core.h"
-#include "jpeg-hw.h"
+#include "jpeg-hw-s5p.h"
 
 static struct s5p_jpeg_fmt formats_enc[] = {
 	{
@@ -951,34 +951,36 @@ static void s5p_jpeg_device_run(void *priv)
 	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
 	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
 
-	jpeg_reset(jpeg->regs);
-	jpeg_poweron(jpeg->regs);
-	jpeg_proc_mode(jpeg->regs, ctx->mode);
+	s5p_jpeg_reset(jpeg->regs);
+	s5p_jpeg_poweron(jpeg->regs);
+	s5p_jpeg_proc_mode(jpeg->regs, ctx->mode);
 	if (ctx->mode == S5P_JPEG_ENCODE) {
 		if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB565)
-			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_565);
+			s5p_jpeg_input_raw_mode(jpeg->regs,
+							S5P_JPEG_RAW_IN_565);
 		else
-			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_422);
-		jpeg_subsampling_mode(jpeg->regs, ctx->subsampling);
-		jpeg_dri(jpeg->regs, ctx->restart_interval);
-		jpeg_x(jpeg->regs, ctx->out_q.w);
-		jpeg_y(jpeg->regs, ctx->out_q.h);
-		jpeg_imgadr(jpeg->regs, src_addr);
-		jpeg_jpgadr(jpeg->regs, dst_addr);
+			s5p_jpeg_input_raw_mode(jpeg->regs,
+							S5P_JPEG_RAW_IN_422);
+		s5p_jpeg_subsampling_mode(jpeg->regs, ctx->subsampling);
+		s5p_jpeg_dri(jpeg->regs, ctx->restart_interval);
+		s5p_jpeg_x(jpeg->regs, ctx->out_q.w);
+		s5p_jpeg_y(jpeg->regs, ctx->out_q.h);
+		s5p_jpeg_imgadr(jpeg->regs, src_addr);
+		s5p_jpeg_jpgadr(jpeg->regs, dst_addr);
 
 		/* ultimately comes from sizeimage from userspace */
-		jpeg_enc_stream_int(jpeg->regs, ctx->cap_q.size);
+		s5p_jpeg_enc_stream_int(jpeg->regs, ctx->cap_q.size);
 
 		/* JPEG RGB to YCbCr conversion matrix */
-		jpeg_coef(jpeg->regs, 1, 1, S5P_JPEG_COEF11);
-		jpeg_coef(jpeg->regs, 1, 2, S5P_JPEG_COEF12);
-		jpeg_coef(jpeg->regs, 1, 3, S5P_JPEG_COEF13);
-		jpeg_coef(jpeg->regs, 2, 1, S5P_JPEG_COEF21);
-		jpeg_coef(jpeg->regs, 2, 2, S5P_JPEG_COEF22);
-		jpeg_coef(jpeg->regs, 2, 3, S5P_JPEG_COEF23);
-		jpeg_coef(jpeg->regs, 3, 1, S5P_JPEG_COEF31);
-		jpeg_coef(jpeg->regs, 3, 2, S5P_JPEG_COEF32);
-		jpeg_coef(jpeg->regs, 3, 3, S5P_JPEG_COEF33);
+		s5p_jpeg_coef(jpeg->regs, 1, 1, S5P_JPEG_COEF11);
+		s5p_jpeg_coef(jpeg->regs, 1, 2, S5P_JPEG_COEF12);
+		s5p_jpeg_coef(jpeg->regs, 1, 3, S5P_JPEG_COEF13);
+		s5p_jpeg_coef(jpeg->regs, 2, 1, S5P_JPEG_COEF21);
+		s5p_jpeg_coef(jpeg->regs, 2, 2, S5P_JPEG_COEF22);
+		s5p_jpeg_coef(jpeg->regs, 2, 3, S5P_JPEG_COEF23);
+		s5p_jpeg_coef(jpeg->regs, 3, 1, S5P_JPEG_COEF31);
+		s5p_jpeg_coef(jpeg->regs, 3, 2, S5P_JPEG_COEF32);
+		s5p_jpeg_coef(jpeg->regs, 3, 3, S5P_JPEG_COEF33);
 
 		/*
 		 * JPEG IP allows storing 4 quantization tables
@@ -987,31 +989,31 @@ static void s5p_jpeg_device_run(void *priv)
 		s5p_jpeg_set_qtbl_lum(jpeg->regs, ctx->compr_quality);
 		s5p_jpeg_set_qtbl_chr(jpeg->regs, ctx->compr_quality);
 		/* use table 0 for Y */
-		jpeg_qtbl(jpeg->regs, 1, 0);
+		s5p_jpeg_qtbl(jpeg->regs, 1, 0);
 		/* use table 1 for Cb and Cr*/
-		jpeg_qtbl(jpeg->regs, 2, 1);
-		jpeg_qtbl(jpeg->regs, 3, 1);
+		s5p_jpeg_qtbl(jpeg->regs, 2, 1);
+		s5p_jpeg_qtbl(jpeg->regs, 3, 1);
 
 		/* Y, Cb, Cr use Huffman table 0 */
-		jpeg_htbl_ac(jpeg->regs, 1);
-		jpeg_htbl_dc(jpeg->regs, 1);
-		jpeg_htbl_ac(jpeg->regs, 2);
-		jpeg_htbl_dc(jpeg->regs, 2);
-		jpeg_htbl_ac(jpeg->regs, 3);
-		jpeg_htbl_dc(jpeg->regs, 3);
+		s5p_jpeg_htbl_ac(jpeg->regs, 1);
+		s5p_jpeg_htbl_dc(jpeg->regs, 1);
+		s5p_jpeg_htbl_ac(jpeg->regs, 2);
+		s5p_jpeg_htbl_dc(jpeg->regs, 2);
+		s5p_jpeg_htbl_ac(jpeg->regs, 3);
+		s5p_jpeg_htbl_dc(jpeg->regs, 3);
 	} else { /* S5P_JPEG_DECODE */
-		jpeg_rst_int_enable(jpeg->regs, true);
-		jpeg_data_num_int_enable(jpeg->regs, true);
-		jpeg_final_mcu_num_int_enable(jpeg->regs, true);
+		s5p_jpeg_rst_int_enable(jpeg->regs, true);
+		s5p_jpeg_data_num_int_enable(jpeg->regs, true);
+		s5p_jpeg_final_mcu_num_int_enable(jpeg->regs, true);
 		if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV)
-			jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_422);
+			s5p_jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_422);
 		else
-			jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_420);
-		jpeg_jpgadr(jpeg->regs, src_addr);
-		jpeg_imgadr(jpeg->regs, dst_addr);
+			s5p_jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_420);
+		s5p_jpeg_jpgadr(jpeg->regs, src_addr);
+		s5p_jpeg_imgadr(jpeg->regs, dst_addr);
 	}
 
-	jpeg_start(jpeg->regs);
+	s5p_jpeg_start(jpeg->regs);
 
 	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
 }
@@ -1203,22 +1205,23 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
 
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
-		enc_jpeg_too_large = jpeg_enc_stream_stat(jpeg->regs);
-	timer_elapsed = jpeg_timer_stat(jpeg->regs);
-	op_completed = jpeg_result_stat_ok(jpeg->regs);
+		enc_jpeg_too_large = s5p_jpeg_enc_stream_stat(jpeg->regs);
+	timer_elapsed = s5p_jpeg_timer_stat(jpeg->regs);
+	op_completed = s5p_jpeg_result_stat_ok(jpeg->regs);
 	if (curr_ctx->mode == S5P_JPEG_DECODE)
-		op_completed = op_completed && jpeg_stream_stat_ok(jpeg->regs);
+		op_completed = op_completed &&
+					s5p_jpeg_stream_stat_ok(jpeg->regs);
 
 	if (enc_jpeg_too_large) {
 		state = VB2_BUF_STATE_ERROR;
-		jpeg_clear_enc_stream_stat(jpeg->regs);
+		s5p_jpeg_clear_enc_stream_stat(jpeg->regs);
 	} else if (timer_elapsed) {
 		state = VB2_BUF_STATE_ERROR;
-		jpeg_clear_timer_stat(jpeg->regs);
+		s5p_jpeg_clear_timer_stat(jpeg->regs);
 	} else if (!op_completed) {
 		state = VB2_BUF_STATE_ERROR;
 	} else {
-		payload_size = jpeg_compressed_size(jpeg->regs);
+		payload_size = s5p_jpeg_compressed_size(jpeg->regs);
 	}
 
 	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
@@ -1230,10 +1233,10 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 	v4l2_m2m_buf_done(dst_buf, state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 
-	curr_ctx->subsampling = jpeg_get_subsampling_mode(jpeg->regs);
+	curr_ctx->subsampling = s5p_jpeg_get_subsampling_mode(jpeg->regs);
 	spin_unlock(&jpeg->slock);
 
-	jpeg_clear_int(jpeg->regs);
+	s5p_jpeg_clear_int(jpeg->regs);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 4a4776b..7baadf3 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -42,10 +42,15 @@
 #define EOI				0xd9
 #define DHP				0xde
 
+#define S5P_JPEG_ENCODE		0
+#define S5P_JPEG_DECODE		1
+
 /* Flags that indicate a format can be used for capture/output */
 #define MEM2MEM_CAPTURE			(1 << 0)
 #define MEM2MEM_OUTPUT			(1 << 1)
 
+
+
 /**
  * struct s5p_jpeg - JPEG IP abstraction
  * @lock:		the mutex protecting this structure
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
similarity index 70%
rename from drivers/media/platform/s5p-jpeg/jpeg-hw.h
rename to drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
index b47e887..52407d7 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
@@ -9,27 +9,15 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#ifndef JPEG_HW_H_
-#define JPEG_HW_H_
 
 #include <linux/io.h>
 #include <linux/videodev2.h>
 
-#include "jpeg-hw.h"
+#include "jpeg-core.h"
 #include "jpeg-regs.h"
+#include "jpeg-hw-s5p.h"
 
-#define S5P_JPEG_MIN_WIDTH		32
-#define S5P_JPEG_MIN_HEIGHT		32
-#define S5P_JPEG_MAX_WIDTH		8192
-#define S5P_JPEG_MAX_HEIGHT		8192
-#define S5P_JPEG_ENCODE			0
-#define S5P_JPEG_DECODE			1
-#define S5P_JPEG_RAW_IN_565		0
-#define S5P_JPEG_RAW_IN_422		1
-#define S5P_JPEG_RAW_OUT_422		0
-#define S5P_JPEG_RAW_OUT_420		1
-
-static inline void jpeg_reset(void __iomem *regs)
+void s5p_jpeg_reset(void __iomem *regs)
 {
 	unsigned long reg;
 
@@ -42,12 +30,12 @@ static inline void jpeg_reset(void __iomem *regs)
 	}
 }
 
-static inline void jpeg_poweron(void __iomem *regs)
+void s5p_jpeg_poweron(void __iomem *regs)
 {
 	writel(S5P_POWER_ON, regs + S5P_JPGCLKCON);
 }
 
-static inline void jpeg_input_raw_mode(void __iomem *regs, unsigned long mode)
+void s5p_jpeg_input_raw_mode(void __iomem *regs, unsigned long mode)
 {
 	unsigned long reg, m;
 
@@ -63,7 +51,7 @@ static inline void jpeg_input_raw_mode(void __iomem *regs, unsigned long mode)
 	writel(reg, regs + S5P_JPGCMOD);
 }
 
-static inline void jpeg_input_raw_y16(void __iomem *regs, bool y16)
+void s5p_jpeg_input_raw_y16(void __iomem *regs, bool y16)
 {
 	unsigned long reg;
 
@@ -75,7 +63,7 @@ static inline void jpeg_input_raw_y16(void __iomem *regs, bool y16)
 	writel(reg, regs + S5P_JPGCMOD);
 }
 
-static inline void jpeg_proc_mode(void __iomem *regs, unsigned long mode)
+void s5p_jpeg_proc_mode(void __iomem *regs, unsigned long mode)
 {
 	unsigned long reg, m;
 
@@ -90,7 +78,7 @@ static inline void jpeg_proc_mode(void __iomem *regs, unsigned long mode)
 	writel(reg, regs + S5P_JPGMOD);
 }
 
-static inline void jpeg_subsampling_mode(void __iomem *regs, unsigned int mode)
+void s5p_jpeg_subsampling_mode(void __iomem *regs, unsigned int mode)
 {
 	unsigned long reg, m;
 
@@ -105,12 +93,12 @@ static inline void jpeg_subsampling_mode(void __iomem *regs, unsigned int mode)
 	writel(reg, regs + S5P_JPGMOD);
 }
 
-static inline unsigned int jpeg_get_subsampling_mode(void __iomem *regs)
+unsigned int s5p_jpeg_get_subsampling_mode(void __iomem *regs)
 {
 	return readl(regs + S5P_JPGMOD) & S5P_SUBSAMPLING_MODE_MASK;
 }
 
-static inline void jpeg_dri(void __iomem *regs, unsigned int dri)
+void s5p_jpeg_dri(void __iomem *regs, unsigned int dri)
 {
 	unsigned long reg;
 
@@ -125,7 +113,7 @@ static inline void jpeg_dri(void __iomem *regs, unsigned int dri)
 	writel(reg, regs + S5P_JPGDRI_L);
 }
 
-static inline void jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n)
+void s5p_jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n)
 {
 	unsigned long reg;
 
@@ -135,7 +123,7 @@ static inline void jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n)
 	writel(reg, regs + S5P_JPG_QTBL);
 }
 
-static inline void jpeg_htbl_ac(void __iomem *regs, unsigned int t)
+void s5p_jpeg_htbl_ac(void __iomem *regs, unsigned int t)
 {
 	unsigned long reg;
 
@@ -146,7 +134,7 @@ static inline void jpeg_htbl_ac(void __iomem *regs, unsigned int t)
 	writel(reg, regs + S5P_JPG_HTBL);
 }
 
-static inline void jpeg_htbl_dc(void __iomem *regs, unsigned int t)
+void s5p_jpeg_htbl_dc(void __iomem *regs, unsigned int t)
 {
 	unsigned long reg;
 
@@ -157,7 +145,7 @@ static inline void jpeg_htbl_dc(void __iomem *regs, unsigned int t)
 	writel(reg, regs + S5P_JPG_HTBL);
 }
 
-static inline void jpeg_y(void __iomem *regs, unsigned int y)
+void s5p_jpeg_y(void __iomem *regs, unsigned int y)
 {
 	unsigned long reg;
 
@@ -172,7 +160,7 @@ static inline void jpeg_y(void __iomem *regs, unsigned int y)
 	writel(reg, regs + S5P_JPGY_L);
 }
 
-static inline void jpeg_x(void __iomem *regs, unsigned int x)
+void s5p_jpeg_x(void __iomem *regs, unsigned int x)
 {
 	unsigned long reg;
 
@@ -187,7 +175,7 @@ static inline void jpeg_x(void __iomem *regs, unsigned int x)
 	writel(reg, regs + S5P_JPGX_L);
 }
 
-static inline void jpeg_rst_int_enable(void __iomem *regs, bool enable)
+void s5p_jpeg_rst_int_enable(void __iomem *regs, bool enable)
 {
 	unsigned long reg;
 
@@ -198,7 +186,7 @@ static inline void jpeg_rst_int_enable(void __iomem *regs, bool enable)
 	writel(reg, regs + S5P_JPGINTSE);
 }
 
-static inline void jpeg_data_num_int_enable(void __iomem *regs, bool enable)
+void s5p_jpeg_data_num_int_enable(void __iomem *regs, bool enable)
 {
 	unsigned long reg;
 
@@ -209,7 +197,7 @@ static inline void jpeg_data_num_int_enable(void __iomem *regs, bool enable)
 	writel(reg, regs + S5P_JPGINTSE);
 }
 
-static inline void jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl)
+void s5p_jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl)
 {
 	unsigned long reg;
 
@@ -220,7 +208,7 @@ static inline void jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl)
 	writel(reg, regs + S5P_JPGINTSE);
 }
 
-static inline void jpeg_timer_enable(void __iomem *regs, unsigned long val)
+void s5p_jpeg_timer_enable(void __iomem *regs, unsigned long val)
 {
 	unsigned long reg;
 
@@ -231,7 +219,7 @@ static inline void jpeg_timer_enable(void __iomem *regs, unsigned long val)
 	writel(reg, regs + S5P_JPG_TIMER_SE);
 }
 
-static inline void jpeg_timer_disable(void __iomem *regs)
+void s5p_jpeg_timer_disable(void __iomem *regs)
 {
 	unsigned long reg;
 
@@ -240,13 +228,13 @@ static inline void jpeg_timer_disable(void __iomem *regs)
 	writel(reg, regs + S5P_JPG_TIMER_SE);
 }
 
-static inline int jpeg_timer_stat(void __iomem *regs)
+int s5p_jpeg_timer_stat(void __iomem *regs)
 {
 	return (int)((readl(regs + S5P_JPG_TIMER_ST) & S5P_TIMER_INT_STAT_MASK)
 		     >> S5P_TIMER_INT_STAT_SHIFT);
 }
 
-static inline void jpeg_clear_timer_stat(void __iomem *regs)
+void s5p_jpeg_clear_timer_stat(void __iomem *regs)
 {
 	unsigned long reg;
 
@@ -255,7 +243,7 @@ static inline void jpeg_clear_timer_stat(void __iomem *regs)
 	writel(reg, regs + S5P_JPG_TIMER_SE);
 }
 
-static inline void jpeg_enc_stream_int(void __iomem *regs, unsigned long size)
+void s5p_jpeg_enc_stream_int(void __iomem *regs, unsigned long size)
 {
 	unsigned long reg;
 
@@ -266,13 +254,13 @@ static inline void jpeg_enc_stream_int(void __iomem *regs, unsigned long size)
 	writel(reg, regs + S5P_JPG_ENC_STREAM_INTSE);
 }
 
-static inline int jpeg_enc_stream_stat(void __iomem *regs)
+int s5p_jpeg_enc_stream_stat(void __iomem *regs)
 {
 	return (int)(readl(regs + S5P_JPG_ENC_STREAM_INTST) &
 		     S5P_ENC_STREAM_INT_STAT_MASK);
 }
 
-static inline void jpeg_clear_enc_stream_stat(void __iomem *regs)
+void s5p_jpeg_clear_enc_stream_stat(void __iomem *regs)
 {
 	unsigned long reg;
 
@@ -281,7 +269,7 @@ static inline void jpeg_clear_enc_stream_stat(void __iomem *regs)
 	writel(reg, regs + S5P_JPG_ENC_STREAM_INTSE);
 }
 
-static inline void jpeg_outform_raw(void __iomem *regs, unsigned long format)
+void s5p_jpeg_outform_raw(void __iomem *regs, unsigned long format)
 {
 	unsigned long reg, f;
 
@@ -296,17 +284,17 @@ static inline void jpeg_outform_raw(void __iomem *regs, unsigned long format)
 	writel(reg, regs + S5P_JPG_OUTFORM);
 }
 
-static inline void jpeg_jpgadr(void __iomem *regs, unsigned long addr)
+void s5p_jpeg_jpgadr(void __iomem *regs, unsigned long addr)
 {
 	writel(addr, regs + S5P_JPG_JPGADR);
 }
 
-static inline void jpeg_imgadr(void __iomem *regs, unsigned long addr)
+void s5p_jpeg_imgadr(void __iomem *regs, unsigned long addr)
 {
 	writel(addr, regs + S5P_JPG_IMGADR);
 }
 
-static inline void jpeg_coef(void __iomem *regs, unsigned int i,
+void s5p_jpeg_coef(void __iomem *regs, unsigned int i,
 			     unsigned int j, unsigned int coef)
 {
 	unsigned long reg;
@@ -317,24 +305,24 @@ static inline void jpeg_coef(void __iomem *regs, unsigned int i,
 	writel(reg, regs + S5P_JPG_COEF(i));
 }
 
-static inline void jpeg_start(void __iomem *regs)
+void s5p_jpeg_start(void __iomem *regs)
 {
 	writel(1, regs + S5P_JSTART);
 }
 
-static inline int jpeg_result_stat_ok(void __iomem *regs)
+int s5p_jpeg_result_stat_ok(void __iomem *regs)
 {
 	return (int)((readl(regs + S5P_JPGINTST) & S5P_RESULT_STAT_MASK)
 		     >> S5P_RESULT_STAT_SHIFT);
 }
 
-static inline int jpeg_stream_stat_ok(void __iomem *regs)
+int s5p_jpeg_stream_stat_ok(void __iomem *regs)
 {
 	return !(int)((readl(regs + S5P_JPGINTST) & S5P_STREAM_STAT_MASK)
 		      >> S5P_STREAM_STAT_SHIFT);
 }
 
-static inline void jpeg_clear_int(void __iomem *regs)
+void s5p_jpeg_clear_int(void __iomem *regs)
 {
 	unsigned long reg;
 
@@ -343,7 +331,7 @@ static inline void jpeg_clear_int(void __iomem *regs)
 	reg = readl(regs + S5P_JPGOPR);
 }
 
-static inline unsigned int jpeg_compressed_size(void __iomem *regs)
+unsigned int s5p_jpeg_compressed_size(void __iomem *regs)
 {
 	unsigned long jpeg_size = 0;
 
@@ -353,5 +341,3 @@ static inline unsigned int jpeg_compressed_size(void __iomem *regs)
 
 	return (unsigned int)jpeg_size;
 }
-
-#endif /* JPEG_HW_H_ */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h
new file mode 100644
index 0000000..c11ebe8
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h
@@ -0,0 +1,63 @@
+/* linux/drivers/media/platform/s5p-jpeg/jpeg-hw.h
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
+#ifndef JPEG_HW_S5P_H_
+#define JPEG_HW_S5P_H_
+
+#include <linux/io.h>
+#include <linux/videodev2.h>
+
+#include "jpeg-regs.h"
+
+#define S5P_JPEG_MIN_WIDTH		32
+#define S5P_JPEG_MIN_HEIGHT		32
+#define S5P_JPEG_MAX_WIDTH		8192
+#define S5P_JPEG_MAX_HEIGHT		8192
+#define S5P_JPEG_RAW_IN_565		0
+#define S5P_JPEG_RAW_IN_422		1
+#define S5P_JPEG_RAW_OUT_422		0
+#define S5P_JPEG_RAW_OUT_420		1
+
+void s5p_jpeg_reset(void __iomem *regs);
+void s5p_jpeg_poweron(void __iomem *regs);
+void s5p_jpeg_input_raw_mode(void __iomem *regs, unsigned long mode);
+void s5p_jpeg_input_raw_y16(void __iomem *regs, bool y16);
+void s5p_jpeg_proc_mode(void __iomem *regs, unsigned long mode);
+void s5p_jpeg_subsampling_mode(void __iomem *regs, unsigned int mode);
+unsigned int s5p_jpeg_get_subsampling_mode(void __iomem *regs);
+void s5p_jpeg_dri(void __iomem *regs, unsigned int dri);
+void s5p_jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n);
+void s5p_jpeg_htbl_ac(void __iomem *regs, unsigned int t);
+void s5p_jpeg_htbl_dc(void __iomem *regs, unsigned int t);
+void s5p_jpeg_y(void __iomem *regs, unsigned int y);
+void s5p_jpeg_x(void __iomem *regs, unsigned int x);
+void s5p_jpeg_rst_int_enable(void __iomem *regs, bool enable);
+void s5p_jpeg_data_num_int_enable(void __iomem *regs, bool enable);
+void s5p_jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl);
+void s5p_jpeg_timer_enable(void __iomem *regs, unsigned long val);
+void s5p_jpeg_timer_disable(void __iomem *regs);
+int s5p_jpeg_timer_stat(void __iomem *regs);
+void s5p_jpeg_clear_timer_stat(void __iomem *regs);
+void s5p_jpeg_enc_stream_int(void __iomem *regs, unsigned long size);
+int s5p_jpeg_enc_stream_stat(void __iomem *regs);
+void s5p_jpeg_clear_enc_stream_stat(void __iomem *regs);
+void s5p_jpeg_outform_raw(void __iomem *regs, unsigned long format);
+void s5p_jpeg_jpgadr(void __iomem *regs, unsigned long addr);
+void s5p_jpeg_imgadr(void __iomem *regs, unsigned long addr);
+void s5p_jpeg_coef(void __iomem *regs, unsigned int i,
+			     unsigned int j, unsigned int coef);
+void s5p_jpeg_start(void __iomem *regs);
+int s5p_jpeg_result_stat_ok(void __iomem *regs);
+int s5p_jpeg_stream_stat_ok(void __iomem *regs);
+void s5p_jpeg_clear_int(void __iomem *regs);
+unsigned int s5p_jpeg_compressed_size(void __iomem *regs);
+
+#endif /* JPEG_HW_S5P_H_ */
-- 
1.7.9.5

