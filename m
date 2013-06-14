Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:39775 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab3FNSJm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 14:09:42 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	Arun Kumar K <arun.kk@samsung.com>
Subject: [PATCH] exynos4-is: Add Exynos5250 SoC support to fimc-lite driver
Date: Fri, 14 Jun 2013 20:09:30 +0200
Message-id: <1371233370-4684-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the Exynos5250 SoC variant of the FIMC-LITE
IP. A 'compatible' string is added for Exynos5250 compatible devices
and the capture DMA handling is reworked to use the FLITE_REG_CIFCNTSEQ
register, masking output DMA buffer address slots. The frame interrupt
is enabled so there are now 2 interrupts per frame. This likely can be
optimized in future by using any status registers that allow to figure
out what the last and the currently written frame buffer is. It would
also be more reliable in cases where there are high interrupt service
latencies.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com
---
 .../devicetree/bindings/media/exynos-fimc-lite.txt |    6 ++-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |   53 ++++++++++++++++++--
 drivers/media/platform/exynos4-is/fimc-lite-reg.h  |   10 +++-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   50 +++++++++++++++---
 drivers/media/platform/exynos4-is/fimc-lite.h      |   22 +++++++-
 5 files changed, 125 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/exynos-fimc-lite.txt b/Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
index 3f62adf..0bf6fb7 100644
--- a/Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
+++ b/Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
@@ -2,8 +2,10 @@ Exynos4x12/Exynos5 SoC series camera host interface (FIMC-LITE)
 
 Required properties:
 
-- compatible	: should be "samsung,exynos4212-fimc" for Exynos4212 and
-		  Exynos4412 SoCs;
+- compatible	: should be one of:
+		  "samsung,exynos4212-fimc-lite" for Exynos4212/4412 SoCs,
+		  "samsung,exynos5250-fimc-lite" for Exynos5250 compatible
+		   devices;
 - reg		: physical base address and size of the device memory mapped
 		  registers;
 - interrupts	: should contain FIMC-LITE interrupt;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index eb4f763..72a343e 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -2,15 +2,16 @@
  * Register interface file for EXYNOS FIMC-LITE (camera interface) driver
  *
  * Copyright (C) 2012 Samsung Electronics Co., Ltd.
- * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
 */
 
-#include <linux/io.h>
+#include <linux/bitops.h>
 #include <linux/delay.h>
+#include <linux/io.h>
 #include <media/s5p_fimc.h>
 
 #include "fimc-lite-reg.h"
@@ -68,7 +69,8 @@ void flite_hw_set_interrupt_mask(struct fimc_lite *dev)
 	if (atomic_read(&dev->out_path) == FIMC_IO_DMA) {
 		intsrc = FLITE_REG_CIGCTRL_IRQ_OVFEN |
 			 FLITE_REG_CIGCTRL_IRQ_LASTEN |
-			 FLITE_REG_CIGCTRL_IRQ_STARTEN;
+			 FLITE_REG_CIGCTRL_IRQ_STARTEN |
+			 FLITE_REG_CIGCTRL_IRQ_ENDEN;
 	} else {
 		/* An output to the FIMC-IS */
 		intsrc = FLITE_REG_CIGCTRL_IRQ_OVFEN |
@@ -215,6 +217,18 @@ void flite_hw_set_camera_bus(struct fimc_lite *dev,
 	flite_hw_set_camera_port(dev, si->mux_id);
 }
 
+static void flite_hw_set_pack12(struct fimc_lite *dev, int on)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
+
+	cfg &= ~FLITE_REG_CIODMAFMT_PACK12;
+
+	if (on)
+		cfg |= FLITE_REG_CIODMAFMT_PACK12;
+
+	writel(cfg, dev->regs + FLITE_REG_CIODMAFMT);
+}
+
 static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
 {
 	static const u32 pixcode[4][2] = {
@@ -250,6 +264,38 @@ void flite_hw_set_dma_window(struct fimc_lite *dev, struct flite_frame *f)
 	writel(cfg, dev->regs + FLITE_REG_CIOOFF);
 }
 
+void flite_hw_set_dma_buffer(struct fimc_lite *dev, struct flite_buffer *buf)
+{
+	unsigned int index;
+	u32 cfg;
+
+	if (dev->dd->max_dma_bufs == 1)
+		index = 0;
+	else
+		index = buf->index;
+
+	if (index == 0)
+		writel(buf->paddr, dev->regs + FLITE_REG_CIOSA);
+	else
+		writel(buf->paddr, dev->regs + FLITE_REG_CIOSAN(index - 1));
+
+	cfg = readl(dev->regs + FLITE_REG_CIFCNTSEQ);
+	cfg |= BIT(index);
+	writel(cfg, dev->regs + FLITE_REG_CIFCNTSEQ);
+}
+
+void flite_hw_mask_dma_buffer(struct fimc_lite *dev, u32 index)
+{
+	u32 cfg;
+
+	if (dev->dd->max_dma_bufs == 1)
+		index = 0;
+
+	cfg = readl(dev->regs + FLITE_REG_CIFCNTSEQ);
+	cfg &= ~BIT(index);
+	writel(cfg, dev->regs + FLITE_REG_CIFCNTSEQ);
+}
+
 /* Enable/disable output DMA, set output pixel size and offsets (composition) */
 void flite_hw_set_output_dma(struct fimc_lite *dev, struct flite_frame *f,
 			     bool enable)
@@ -267,6 +313,7 @@ void flite_hw_set_output_dma(struct fimc_lite *dev, struct flite_frame *f,
 
 	flite_hw_set_out_order(dev, f);
 	flite_hw_set_dma_window(dev, f);
+	flite_hw_set_pack12(dev, 0);
 }
 
 void flite_hw_dump_regs(struct fimc_lite *dev, const char *label)
diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.h b/drivers/media/platform/exynos4-is/fimc-lite-reg.h
index 3903839..10a7d7b 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.h
@@ -120,6 +120,9 @@
 /* b0: 1 - camera B, 0 - camera A */
 #define FLITE_REG_CIGENERAL_CAM_B		(1 << 0)
 
+#define FLITE_REG_CIFCNTSEQ			0x100
+#define FLITE_REG_CIOSAN(x)			(0x200 + (4 * (x)))
+
 /* ----------------------------------------------------------------------------
  * Function declarations
  */
@@ -142,9 +145,12 @@ void flite_hw_set_output_dma(struct fimc_lite *dev, struct flite_frame *f,
 void flite_hw_set_dma_window(struct fimc_lite *dev, struct flite_frame *f);
 void flite_hw_set_test_pattern(struct fimc_lite *dev, bool on);
 void flite_hw_dump_regs(struct fimc_lite *dev, const char *label);
+void flite_hw_set_dma_buffer(struct fimc_lite *dev, struct flite_buffer *buf);
+void flite_hw_mask_dma_buffer(struct fimc_lite *dev, u32 index);
 
-static inline void flite_hw_set_output_addr(struct fimc_lite *dev, u32 paddr)
+static inline void flite_hw_set_dma_buf_mask(struct fimc_lite *dev, u32 mask)
 {
-	writel(paddr, dev->regs + FLITE_REG_CIOSA);
+	writel(mask, dev->regs + FLITE_REG_CIFCNTSEQ);
 }
+
 #endif /* FIMC_LITE_REG_H */
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 00c525c..07767c8 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -153,6 +153,7 @@ static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
 	flite_hw_set_camera_bus(fimc, si);
 	flite_hw_set_source_format(fimc, &fimc->inp_frame);
 	flite_hw_set_window_offset(fimc, &fimc->inp_frame);
+	flite_hw_set_dma_buf_mask(fimc, 0);
 	flite_hw_set_output_dma(fimc, &fimc->out_frame, !isp_output);
 	flite_hw_set_interrupt_mask(fimc);
 	flite_hw_set_test_pattern(fimc, fimc->test_pattern->val);
@@ -276,19 +277,23 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 
 	if ((intsrc & FLITE_REG_CISTATUS_IRQ_SRC_FRMSTART) &&
 	    test_bit(ST_FLITE_RUN, &fimc->state) &&
-	    !list_empty(&fimc->active_buf_q) &&
 	    !list_empty(&fimc->pending_buf_q)) {
+		vbuf = fimc_lite_pending_queue_pop(fimc);
+		flite_hw_set_dma_buffer(fimc, vbuf);
+		fimc_lite_active_queue_add(fimc, vbuf);
+	}
+
+	if ((intsrc & FLITE_REG_CISTATUS_IRQ_SRC_FRMEND) &&
+	    test_bit(ST_FLITE_RUN, &fimc->state) &&
+	    !list_empty(&fimc->active_buf_q)) {
 		vbuf = fimc_lite_active_queue_pop(fimc);
 		ktime_get_ts(&ts);
 		tv = &vbuf->vb.v4l2_buf.timestamp;
 		tv->tv_sec = ts.tv_sec;
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
+		flite_hw_mask_dma_buffer(fimc, vbuf->index);
 		vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
-
-		vbuf = fimc_lite_pending_queue_pop(fimc);
-		flite_hw_set_output_addr(fimc, vbuf->paddr);
-		fimc_lite_active_queue_add(fimc, vbuf);
 	}
 
 	if (test_bit(ST_FLITE_CONFIG, &fimc->state))
@@ -307,10 +312,16 @@ done:
 static int start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct fimc_lite *fimc = q->drv_priv;
+	unsigned long flags;
 	int ret;
 
+	spin_lock_irqsave(&fimc->slock, flags);
+
+	fimc->buf_index = 0;
 	fimc->frame_count = 0;
 
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
 	ret = fimc_lite_hw_init(fimc, false);
 	if (ret) {
 		fimc_lite_reinit(fimc, false);
@@ -412,10 +423,14 @@ static void buffer_queue(struct vb2_buffer *vb)
 	spin_lock_irqsave(&fimc->slock, flags);
 	buf->paddr = vb2_dma_contig_plane_dma_addr(vb, 0);
 
+	buf->index = fimc->buf_index++;
+	if (fimc->buf_index >= fimc->reqbufs_count)
+		fimc->buf_index = 0;
+
 	if (!test_bit(ST_FLITE_SUSPENDED, &fimc->state) &&
 	    !test_bit(ST_FLITE_STREAM, &fimc->state) &&
 	    list_empty(&fimc->active_buf_q)) {
-		flite_hw_set_output_addr(fimc, buf->paddr);
+		flite_hw_set_dma_buffer(fimc, buf);
 		fimc_lite_active_queue_add(fimc, buf);
 	} else {
 		fimc_lite_pending_queue_add(fimc, buf);
@@ -1451,8 +1466,12 @@ static int fimc_lite_probe(struct platform_device *pdev)
 		fimc->index = of_alias_get_id(dev->of_node, "fimc-lite");
 	}
 
-	if (!drv_data || fimc->index < 0 || fimc->index >= FIMC_LITE_MAX_DEVS)
+	if (!drv_data || fimc->index >= drv_data->num_instances ||
+						fimc->index < 0) {
+		dev_err(dev, "Wrong %s node alias\n",
+					dev->of_node->full_name);
 		return -EINVAL;
+	}
 
 	fimc->dd = drv_data;
 	fimc->pdev = pdev;
@@ -1609,6 +1628,19 @@ static struct flite_drvdata fimc_lite_drvdata_exynos4 = {
 	.out_width_align	= 8,
 	.win_hor_offs_align	= 2,
 	.out_hor_offs_align	= 8,
+	.max_dma_bufs		= 1,
+	.num_instances		= 2,
+};
+
+/* EXYNOS5250 */
+static struct flite_drvdata fimc_lite_drvdata_exynos5 = {
+	.max_width		= 8192,
+	.max_height		= 8192,
+	.out_width_align	= 8,
+	.win_hor_offs_align	= 2,
+	.out_hor_offs_align	= 8,
+	.max_dma_bufs		= 32,
+	.num_instances		= 3,
 };
 
 static const struct of_device_id flite_of_match[] = {
@@ -1616,6 +1648,10 @@ static const struct of_device_id flite_of_match[] = {
 		.compatible = "samsung,exynos4212-fimc-lite",
 		.data = &fimc_lite_drvdata_exynos4,
 	},
+	{
+		.compatible = "samsung,exynos5250-fimc-lite",
+		.data = &fimc_lite_drvdata_exynos5,
+	},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, flite_of_match);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 4b10684..c98f3da 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -27,7 +27,7 @@
 
 #define FIMC_LITE_DRV_NAME	"exynos-fimc-lite"
 #define FLITE_CLK_NAME		"flite"
-#define FIMC_LITE_MAX_DEVS	2
+#define FIMC_LITE_MAX_DEVS	3
 #define FLITE_REQ_BUFS_MIN	2
 
 /* Bit index definitions for struct fimc_lite::state */
@@ -48,12 +48,26 @@ enum {
 #define FLITE_SD_PAD_SOURCE_ISP	2
 #define FLITE_SD_PADS_NUM	3
 
+/**
+ * struct flite_drvdata - FIMC-LITE IP variant data structure
+ * @max_width: maximum camera interface input width in pixels
+ * @max_height: maximum camera interface input height in pixels
+ * @out_width_align: minimum output width alignment in pixels
+ * @win_hor_offs_align: minimum camera interface crop window horizontal
+ * 			offset alignment in pixels
+ * @out_hor_offs_align: minimum output DMA compose rectangle horizontal
+ * 			offset alignment in pixels
+ * @max_dma_bufs: number of output DMA buffer start address registers
+ * @num_instances: total number of FIMC-LITE IP instances available
+ */
 struct flite_drvdata {
 	unsigned short max_width;
 	unsigned short max_height;
 	unsigned short out_width_align;
 	unsigned short win_hor_offs_align;
 	unsigned short out_hor_offs_align;
+	unsigned short max_dma_bufs;
+	unsigned short num_instances;
 };
 
 struct fimc_lite_events {
@@ -80,12 +94,14 @@ struct flite_frame {
  * struct flite_buffer - video buffer structure
  * @vb:    vb2 buffer
  * @list:  list head for the buffers queue
- * @paddr: precalculated physical address
+ * @paddr: DMA buffer start address
+ * @index: DMA start address register's index
  */
 struct flite_buffer {
 	struct vb2_buffer vb;
 	struct list_head list;
 	dma_addr_t paddr;
+	unsigned short index;
 };
 
 /**
@@ -119,6 +135,7 @@ struct flite_buffer {
  * @pending_buf_q: pending buffers queue head
  * @active_buf_q: the queue head of buffers scheduled in hardware
  * @vb_queue: vb2 buffers queue
+ * @buf_index: helps to keep track of the DMA start address register index
  * @active_buf_count: number of video buffers scheduled in hardware
  * @frame_count: the captured frames counter
  * @reqbufs_count: the number of buffers requested with REQBUFS ioctl
@@ -155,6 +172,7 @@ struct fimc_lite {
 	struct list_head	pending_buf_q;
 	struct list_head	active_buf_q;
 	struct vb2_queue	vb_queue;
+	unsigned short		buf_index;
 	unsigned int		frame_count;
 	unsigned int		reqbufs_count;
 
-- 
1.7.9.5

