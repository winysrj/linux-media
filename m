Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55615 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3KSO14 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:27:56 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWI00M2MLI2NH40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Nov 2013 23:27:54 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 09/16] s5p-jpeg: Split jpeg-hw.h to jpeg-hw-s5p.c and
 jpeg-hw-s5p.c
Date: Tue, 19 Nov 2013 15:27:01 +0100
Message-id: <1384871228-6648-10-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move function definitions from jpeg-hw.h to jpeg-hw-s5p.c
and put function declarations in the jpeg-hw-s5p.h.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/Makefile           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |    5 ++
 .../platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} |   82 ++++++++------------
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h      |   63 +++++++++++++++
 5 files changed, 104 insertions(+), 50 deletions(-)
 rename drivers/media/platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} (71%)
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
index b82e3fa..4e874ad 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -29,7 +29,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "jpeg-core.h"
-#include "jpeg-hw.h"
+#include "jpeg-hw-s5p.h"
 
 static struct s5p_jpeg_fmt formats_enc[] = {
 	{
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
similarity index 71%
rename from drivers/media/platform/s5p-jpeg/jpeg-hw.h
rename to drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
index b47e887..6a1164c 100644
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
+void jpeg_reset(void __iomem *regs)
 {
 	unsigned long reg;
 
@@ -42,12 +30,12 @@ static inline void jpeg_reset(void __iomem *regs)
 	}
 }
 
-static inline void jpeg_poweron(void __iomem *regs)
+void jpeg_poweron(void __iomem *regs)
 {
 	writel(S5P_POWER_ON, regs + S5P_JPGCLKCON);
 }
 
-static inline void jpeg_input_raw_mode(void __iomem *regs, unsigned long mode)
+void jpeg_input_raw_mode(void __iomem *regs, unsigned long mode)
 {
 	unsigned long reg, m;
 
@@ -63,7 +51,7 @@ static inline void jpeg_input_raw_mode(void __iomem *regs, unsigned long mode)
 	writel(reg, regs + S5P_JPGCMOD);
 }
 
-static inline void jpeg_input_raw_y16(void __iomem *regs, bool y16)
+void jpeg_input_raw_y16(void __iomem *regs, bool y16)
 {
 	unsigned long reg;
 
@@ -75,7 +63,7 @@ static inline void jpeg_input_raw_y16(void __iomem *regs, bool y16)
 	writel(reg, regs + S5P_JPGCMOD);
 }
 
-static inline void jpeg_proc_mode(void __iomem *regs, unsigned long mode)
+void jpeg_proc_mode(void __iomem *regs, unsigned long mode)
 {
 	unsigned long reg, m;
 
@@ -90,7 +78,7 @@ static inline void jpeg_proc_mode(void __iomem *regs, unsigned long mode)
 	writel(reg, regs + S5P_JPGMOD);
 }
 
-static inline void jpeg_subsampling_mode(void __iomem *regs, unsigned int mode)
+void jpeg_subsampling_mode(void __iomem *regs, unsigned int mode)
 {
 	unsigned long reg, m;
 
@@ -105,12 +93,12 @@ static inline void jpeg_subsampling_mode(void __iomem *regs, unsigned int mode)
 	writel(reg, regs + S5P_JPGMOD);
 }
 
-static inline unsigned int jpeg_get_subsampling_mode(void __iomem *regs)
+unsigned int jpeg_get_subsampling_mode(void __iomem *regs)
 {
 	return readl(regs + S5P_JPGMOD) & S5P_SUBSAMPLING_MODE_MASK;
 }
 
-static inline void jpeg_dri(void __iomem *regs, unsigned int dri)
+void jpeg_dri(void __iomem *regs, unsigned int dri)
 {
 	unsigned long reg;
 
@@ -125,7 +113,7 @@ static inline void jpeg_dri(void __iomem *regs, unsigned int dri)
 	writel(reg, regs + S5P_JPGDRI_L);
 }
 
-static inline void jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n)
+void jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n)
 {
 	unsigned long reg;
 
@@ -135,7 +123,7 @@ static inline void jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n)
 	writel(reg, regs + S5P_JPG_QTBL);
 }
 
-static inline void jpeg_htbl_ac(void __iomem *regs, unsigned int t)
+void jpeg_htbl_ac(void __iomem *regs, unsigned int t)
 {
 	unsigned long reg;
 
@@ -146,7 +134,7 @@ static inline void jpeg_htbl_ac(void __iomem *regs, unsigned int t)
 	writel(reg, regs + S5P_JPG_HTBL);
 }
 
-static inline void jpeg_htbl_dc(void __iomem *regs, unsigned int t)
+void jpeg_htbl_dc(void __iomem *regs, unsigned int t)
 {
 	unsigned long reg;
 
@@ -157,7 +145,7 @@ static inline void jpeg_htbl_dc(void __iomem *regs, unsigned int t)
 	writel(reg, regs + S5P_JPG_HTBL);
 }
 
-static inline void jpeg_y(void __iomem *regs, unsigned int y)
+void jpeg_y(void __iomem *regs, unsigned int y)
 {
 	unsigned long reg;
 
@@ -172,7 +160,7 @@ static inline void jpeg_y(void __iomem *regs, unsigned int y)
 	writel(reg, regs + S5P_JPGY_L);
 }
 
-static inline void jpeg_x(void __iomem *regs, unsigned int x)
+void jpeg_x(void __iomem *regs, unsigned int x)
 {
 	unsigned long reg;
 
@@ -187,7 +175,7 @@ static inline void jpeg_x(void __iomem *regs, unsigned int x)
 	writel(reg, regs + S5P_JPGX_L);
 }
 
-static inline void jpeg_rst_int_enable(void __iomem *regs, bool enable)
+void jpeg_rst_int_enable(void __iomem *regs, bool enable)
 {
 	unsigned long reg;
 
@@ -198,7 +186,7 @@ static inline void jpeg_rst_int_enable(void __iomem *regs, bool enable)
 	writel(reg, regs + S5P_JPGINTSE);
 }
 
-static inline void jpeg_data_num_int_enable(void __iomem *regs, bool enable)
+void jpeg_data_num_int_enable(void __iomem *regs, bool enable)
 {
 	unsigned long reg;
 
@@ -209,7 +197,7 @@ static inline void jpeg_data_num_int_enable(void __iomem *regs, bool enable)
 	writel(reg, regs + S5P_JPGINTSE);
 }
 
-static inline void jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl)
+void jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl)
 {
 	unsigned long reg;
 
@@ -220,7 +208,7 @@ static inline void jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl)
 	writel(reg, regs + S5P_JPGINTSE);
 }
 
-static inline void jpeg_timer_enable(void __iomem *regs, unsigned long val)
+void jpeg_timer_enable(void __iomem *regs, unsigned long val)
 {
 	unsigned long reg;
 
@@ -231,7 +219,7 @@ static inline void jpeg_timer_enable(void __iomem *regs, unsigned long val)
 	writel(reg, regs + S5P_JPG_TIMER_SE);
 }
 
-static inline void jpeg_timer_disable(void __iomem *regs)
+void jpeg_timer_disable(void __iomem *regs)
 {
 	unsigned long reg;
 
@@ -240,13 +228,13 @@ static inline void jpeg_timer_disable(void __iomem *regs)
 	writel(reg, regs + S5P_JPG_TIMER_SE);
 }
 
-static inline int jpeg_timer_stat(void __iomem *regs)
+int jpeg_timer_stat(void __iomem *regs)
 {
 	return (int)((readl(regs + S5P_JPG_TIMER_ST) & S5P_TIMER_INT_STAT_MASK)
 		     >> S5P_TIMER_INT_STAT_SHIFT);
 }
 
-static inline void jpeg_clear_timer_stat(void __iomem *regs)
+void jpeg_clear_timer_stat(void __iomem *regs)
 {
 	unsigned long reg;
 
@@ -255,7 +243,7 @@ static inline void jpeg_clear_timer_stat(void __iomem *regs)
 	writel(reg, regs + S5P_JPG_TIMER_SE);
 }
 
-static inline void jpeg_enc_stream_int(void __iomem *regs, unsigned long size)
+void jpeg_enc_stream_int(void __iomem *regs, unsigned long size)
 {
 	unsigned long reg;
 
@@ -266,13 +254,13 @@ static inline void jpeg_enc_stream_int(void __iomem *regs, unsigned long size)
 	writel(reg, regs + S5P_JPG_ENC_STREAM_INTSE);
 }
 
-static inline int jpeg_enc_stream_stat(void __iomem *regs)
+int jpeg_enc_stream_stat(void __iomem *regs)
 {
 	return (int)(readl(regs + S5P_JPG_ENC_STREAM_INTST) &
 		     S5P_ENC_STREAM_INT_STAT_MASK);
 }
 
-static inline void jpeg_clear_enc_stream_stat(void __iomem *regs)
+void jpeg_clear_enc_stream_stat(void __iomem *regs)
 {
 	unsigned long reg;
 
@@ -281,7 +269,7 @@ static inline void jpeg_clear_enc_stream_stat(void __iomem *regs)
 	writel(reg, regs + S5P_JPG_ENC_STREAM_INTSE);
 }
 
-static inline void jpeg_outform_raw(void __iomem *regs, unsigned long format)
+void jpeg_outform_raw(void __iomem *regs, unsigned long format)
 {
 	unsigned long reg, f;
 
@@ -296,17 +284,17 @@ static inline void jpeg_outform_raw(void __iomem *regs, unsigned long format)
 	writel(reg, regs + S5P_JPG_OUTFORM);
 }
 
-static inline void jpeg_jpgadr(void __iomem *regs, unsigned long addr)
+void jpeg_jpgadr(void __iomem *regs, unsigned long addr)
 {
 	writel(addr, regs + S5P_JPG_JPGADR);
 }
 
-static inline void jpeg_imgadr(void __iomem *regs, unsigned long addr)
+void jpeg_imgadr(void __iomem *regs, unsigned long addr)
 {
 	writel(addr, regs + S5P_JPG_IMGADR);
 }
 
-static inline void jpeg_coef(void __iomem *regs, unsigned int i,
+void jpeg_coef(void __iomem *regs, unsigned int i,
 			     unsigned int j, unsigned int coef)
 {
 	unsigned long reg;
@@ -317,24 +305,24 @@ static inline void jpeg_coef(void __iomem *regs, unsigned int i,
 	writel(reg, regs + S5P_JPG_COEF(i));
 }
 
-static inline void jpeg_start(void __iomem *regs)
+void jpeg_start(void __iomem *regs)
 {
 	writel(1, regs + S5P_JSTART);
 }
 
-static inline int jpeg_result_stat_ok(void __iomem *regs)
+int jpeg_result_stat_ok(void __iomem *regs)
 {
 	return (int)((readl(regs + S5P_JPGINTST) & S5P_RESULT_STAT_MASK)
 		     >> S5P_RESULT_STAT_SHIFT);
 }
 
-static inline int jpeg_stream_stat_ok(void __iomem *regs)
+int jpeg_stream_stat_ok(void __iomem *regs)
 {
 	return !(int)((readl(regs + S5P_JPGINTST) & S5P_STREAM_STAT_MASK)
 		      >> S5P_STREAM_STAT_SHIFT);
 }
 
-static inline void jpeg_clear_int(void __iomem *regs)
+void jpeg_clear_int(void __iomem *regs)
 {
 	unsigned long reg;
 
@@ -343,7 +331,7 @@ static inline void jpeg_clear_int(void __iomem *regs)
 	reg = readl(regs + S5P_JPGOPR);
 }
 
-static inline unsigned int jpeg_compressed_size(void __iomem *regs)
+unsigned int jpeg_compressed_size(void __iomem *regs)
 {
 	unsigned long jpeg_size = 0;
 
@@ -353,5 +341,3 @@ static inline unsigned int jpeg_compressed_size(void __iomem *regs)
 
 	return (unsigned int)jpeg_size;
 }
-
-#endif /* JPEG_HW_H_ */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h
new file mode 100644
index 0000000..ff6f5f0
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
+void jpeg_reset(void __iomem *regs);
+void jpeg_poweron(void __iomem *regs);
+void jpeg_input_raw_mode(void __iomem *regs, unsigned long mode);
+void jpeg_input_raw_y16(void __iomem *regs, bool y16);
+void jpeg_proc_mode(void __iomem *regs, unsigned long mode);
+void jpeg_subsampling_mode(void __iomem *regs, unsigned int mode);
+unsigned int jpeg_get_subsampling_mode(void __iomem *regs);
+void jpeg_dri(void __iomem *regs, unsigned int dri);
+void jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n);
+void jpeg_htbl_ac(void __iomem *regs, unsigned int t);
+void jpeg_htbl_dc(void __iomem *regs, unsigned int t);
+void jpeg_y(void __iomem *regs, unsigned int y);
+void jpeg_x(void __iomem *regs, unsigned int x);
+void jpeg_rst_int_enable(void __iomem *regs, bool enable);
+void jpeg_data_num_int_enable(void __iomem *regs, bool enable);
+void jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl);
+void jpeg_timer_enable(void __iomem *regs, unsigned long val);
+void jpeg_timer_disable(void __iomem *regs);
+int jpeg_timer_stat(void __iomem *regs);
+void jpeg_clear_timer_stat(void __iomem *regs);
+void jpeg_enc_stream_int(void __iomem *regs, unsigned long size);
+int jpeg_enc_stream_stat(void __iomem *regs);
+void jpeg_clear_enc_stream_stat(void __iomem *regs);
+void jpeg_outform_raw(void __iomem *regs, unsigned long format);
+void jpeg_jpgadr(void __iomem *regs, unsigned long addr);
+void jpeg_imgadr(void __iomem *regs, unsigned long addr);
+void jpeg_coef(void __iomem *regs, unsigned int i,
+			     unsigned int j, unsigned int coef);
+void jpeg_start(void __iomem *regs);
+int jpeg_result_stat_ok(void __iomem *regs);
+int jpeg_stream_stat_ok(void __iomem *regs);
+void jpeg_clear_int(void __iomem *regs);
+unsigned int jpeg_compressed_size(void __iomem *regs);
+
+#endif /* JPEG_HW_S5P_H_ */
-- 
1.7.9.5

