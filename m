Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29704 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759952Ab2D0JxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:16 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M34005L3U3VM800@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:52:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3400J02U4QNO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:15 +0100 (BST)
Date: Fri, 27 Apr 2012 11:52:59 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 06/13] s5p-fimc: Add FIMC-LITE register definitions
In-reply-to: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-7-git-send-email-s.nawrocki@samsung.com>
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add register definitions and register API for FIMC-LITE devices.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-lite-reg.c |  301 ++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-lite-reg.h |  153 +++++++++++++
 drivers/media/video/s5p-fimc/fimc-lite.h     |  212 ++++++++++++++++++
 3 files changed, 666 insertions(+)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite-reg.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite-reg.h
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite.h

diff --git a/drivers/media/video/s5p-fimc/fimc-lite-reg.c b/drivers/media/video/s5p-fimc/fimc-lite-reg.c
new file mode 100644
index 0000000..7a20c45
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-lite-reg.c
@@ -0,0 +1,301 @@
+/*
+ * Register interface file for EXYNOS FIMC-LITE (camera interface) driver
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <media/s5p_fimc.h>
+
+#include "fimc-lite-reg.h"
+#include "fimc-lite.h"
+#include "fimc-core.h"
+
+#define FLITE_RESET_TIMEOUT 50 /* in ms FIXME: */
+
+void flite_hw_reset(struct fimc_lite *dev)
+{
+	unsigned long end = jiffies + msecs_to_jiffies(FLITE_RESET_TIMEOUT);
+	u32 cfg;
+
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+	cfg |= FLITE_REG_CIGCTRL_SWRST_REQ;
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+
+	while (time_is_after_jiffies(end)) {
+		cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+		if (cfg & FLITE_REG_CIGCTRL_SWRST_RDY)
+			break;
+		usleep_range(1000, 5000);
+	}
+
+	cfg |= FLITE_REG_CIGCTRL_SWRST;
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+}
+
+void flite_hw_clear_pending_irq(struct fimc_lite *dev)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CISTATUS);
+	cfg &= ~FLITE_REG_CISTATUS_IRQ_CAM;
+	writel(cfg, dev->regs + FLITE_REG_CISTATUS);
+}
+
+u32 flite_hw_get_interrupt_source(struct fimc_lite *dev)
+{
+	u32 intsrc = readl(dev->regs + FLITE_REG_CISTATUS);
+	return intsrc & FLITE_REG_CISTATUS_IRQ_MASK;
+}
+
+void flite_hw_clear_last_capture_end(struct fimc_lite *dev)
+{
+
+	u32 cfg = readl(dev->regs + FLITE_REG_CISTATUS2);
+	cfg &= ~FLITE_REG_CISTATUS2_LASTCAPEND;
+	writel(cfg, dev->regs + FLITE_REG_CISTATUS2);
+}
+
+void flite_hw_set_interrupt_mask(struct fimc_lite *dev)
+{
+	u32 cfg, intsrc;
+
+	/* Select interrupts to be enabled for each output mode */
+	if (dev->out_path == FIMC_IO_DMA) {
+		intsrc = FLITE_REG_CIGCTRL_IRQ_OVFEN |
+			 FLITE_REG_CIGCTRL_IRQ_LASTEN |
+			 /* FLITE_REG_CIGCTRL_IRQ_ENDEN0 | */
+			FLITE_REG_CIGCTRL_IRQ_STARTEN;
+	} else {
+		/* An output to the FIMC-IS */
+		intsrc = FLITE_REG_CIGCTRL_IRQ_OVFEN |
+			 FLITE_REG_CIGCTRL_IRQ_LASTEN;
+	}
+
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+	cfg |= FLITE_REG_CIGCTRL_IRQ_DISABLE_MASK;
+	cfg &= ~intsrc;
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+}
+
+void flite_hw_capture_start(struct fimc_lite *dev)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CIIMGCPT);
+	cfg |= FLITE_REG_CIIMGCPT_IMGCPTEN;
+	writel(cfg, dev->regs + FLITE_REG_CIIMGCPT);
+}
+
+void flite_hw_capture_stop(struct fimc_lite *dev)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CIIMGCPT);
+	cfg &= ~FLITE_REG_CIIMGCPT_IMGCPTEN;
+	writel(cfg, dev->regs + FLITE_REG_CIIMGCPT);
+}
+
+/*
+ * Test pattern (color bars) enable/disable. External sensor
+ * pixel clock must be active for the test pattern to work.
+ */
+void flite_hw_set_test_pattern(struct fimc_lite *dev, bool on)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+	if (on)
+		cfg |= FLITE_REG_CIGCTRL_TEST_PATTERN_COLORBAR;
+	else
+		cfg &= ~FLITE_REG_CIGCTRL_TEST_PATTERN_COLORBAR;
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+}
+
+static const u32 src_pixfmt_map[8][3] = {
+	{ V4L2_MBUS_FMT_YUYV8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_YCBYCR,
+	  FLITE_REG_CIGCTRL_YUV422_1P },
+	{ V4L2_MBUS_FMT_YVYU8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_YCRYCB,
+	  FLITE_REG_CIGCTRL_YUV422_1P },
+	{ V4L2_MBUS_FMT_UYVY8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_CBYCRY,
+	  FLITE_REG_CIGCTRL_YUV422_1P },
+	{ V4L2_MBUS_FMT_VYUY8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_CRYCBY,
+	  FLITE_REG_CIGCTRL_YUV422_1P },
+	{ V4L2_PIX_FMT_SGRBG8, 0, FLITE_REG_CIGCTRL_RAW8 },
+	{ V4L2_PIX_FMT_SGRBG10, 0, FLITE_REG_CIGCTRL_RAW10 },
+	{ V4L2_PIX_FMT_SGRBG12, 0, FLITE_REG_CIGCTRL_RAW12 },
+	{ V4L2_MBUS_FMT_JPEG_1X8, 0, FLITE_REG_CIGCTRL_USER(1) },
+};
+
+/* Set camera input pixel format and resolution */
+void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f)
+{
+	enum v4l2_mbus_pixelcode pixelcode = dev->fmt->mbus_code;
+	unsigned int i = ARRAY_SIZE(src_pixfmt_map);
+	u32 cfg;
+
+	while (i-- >= 0) {
+		if (src_pixfmt_map[i][0] == pixelcode)
+			break;
+	}
+
+	if (i == 0 && src_pixfmt_map[i][0] != pixelcode) {
+		v4l2_err(dev->vfd,
+			 "Unsupported pixel code, falling back to %#08x\n",
+			 src_pixfmt_map[i][0]);
+	}
+
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+	cfg &= ~FLITE_REG_CIGCTRL_FMT_MASK;
+	cfg |= src_pixfmt_map[i][2];
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+
+	cfg = readl(dev->regs + FLITE_REG_CISRCSIZE);
+	cfg &= ~(FLITE_REG_CISRCSIZE_ORDER422_MASK |
+		 FLITE_REG_CISRCSIZE_SIZE_CAM_MASK);
+	cfg |= (f->f_width << 16) | f->f_height;
+	cfg |= src_pixfmt_map[i][1];
+	writel(cfg, dev->regs + FLITE_REG_CISRCSIZE);
+}
+
+/* Set the camera host input window offsets (cropping) */
+void flite_hw_set_window_offset(struct fimc_lite *dev, struct flite_frame *f)
+{
+	u32 hoff2, voff2;
+	u32 cfg;
+
+	cfg = readl(dev->regs + FLITE_REG_CIWDOFST);
+	cfg &= ~FLITE_REG_CIWDOFST_OFST_MASK;
+	cfg |= (f->rect.left << 16) | f->rect.top;
+	cfg |= FLITE_REG_CIWDOFST_WINOFSEN;
+	writel(cfg, dev->regs + FLITE_REG_CIWDOFST);
+
+	hoff2 = f->f_width - f->rect.width - f->rect.left;
+	voff2 = f->f_height - f->rect.height - f->rect.top;
+
+	cfg = (hoff2 << 16) | voff2;
+	writel(cfg, dev->regs + FLITE_REG_CIWDOFST2);
+}
+
+/* Select camera port (A, B) */
+static void flite_hw_set_camera_port(struct fimc_lite *dev, int id)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CIGENERAL);
+	if (id == 0)
+		cfg &= ~FLITE_REG_CIGENERAL_CAM_B;
+	else
+		cfg |= FLITE_REG_CIGENERAL_CAM_B;
+	writel(cfg, dev->regs + FLITE_REG_CIGENERAL);
+}
+
+/* Select serial or parallel bus, camera port (A,B) and set signals polarity */
+void flite_hw_set_camera_bus(struct fimc_lite *dev,
+			     struct s5p_fimc_isp_info *s_info)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+	unsigned int flags = s_info->flags;
+
+	if (s_info->bus_type != FIMC_MIPI_CSI2) {
+		cfg &= ~(FLITE_REG_CIGCTRL_SELCAM_MIPI |
+			 FLITE_REG_CIGCTRL_INVPOLPCLK |
+			 FLITE_REG_CIGCTRL_INVPOLVSYNC |
+			 FLITE_REG_CIGCTRL_INVPOLHREF);
+
+		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+			cfg |= FLITE_REG_CIGCTRL_INVPOLPCLK;
+
+		if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+			cfg |= FLITE_REG_CIGCTRL_INVPOLVSYNC;
+
+		if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+			cfg |= FLITE_REG_CIGCTRL_INVPOLHREF;
+	} else {
+		cfg |= FLITE_REG_CIGCTRL_SELCAM_MIPI;
+	}
+
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+
+	flite_hw_set_camera_port(dev, s_info->mux_id);
+}
+
+void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
+{
+	static const u32 pixcode[4][2] = {
+		{ V4L2_MBUS_FMT_YUYV8_2X8, FLITE_REG_CIODMAFMT_YCBYCR },
+		{ V4L2_MBUS_FMT_YVYU8_2X8, FLITE_REG_CIODMAFMT_YCRYCB },
+		{ V4L2_MBUS_FMT_UYVY8_2X8, FLITE_REG_CIODMAFMT_CBYCRY },
+		{ V4L2_MBUS_FMT_VYUY8_2X8, FLITE_REG_CIODMAFMT_CRYCBY },
+	};
+	u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
+	unsigned int i = ARRAY_SIZE(pixcode);
+
+	while (i-- >= 0)
+		if (pixcode[i][0] == dev->fmt->mbus_code)
+			break;
+	cfg &= ~FLITE_REG_CIODMAFMT_YCBCR_ORDER_MASK;
+	writel(cfg | pixcode[i][1], dev->regs + FLITE_REG_CIODMAFMT);
+}
+
+void flite_hw_set_dma_window(struct fimc_lite *dev, struct flite_frame *f)
+{
+	u32 cfg;
+
+	/* Maximum output pixel size */
+	cfg = readl(dev->regs + FLITE_REG_CIOCAN);
+	cfg &= ~FLITE_REG_CIOCAN_MASK;
+	cfg = (f->f_height << 16) | f->f_width;
+	writel(cfg, dev->regs + FLITE_REG_CIOCAN);
+
+	/* DMA offsets */
+	cfg = readl(dev->regs + FLITE_REG_CIOOFF);
+	cfg &= ~FLITE_REG_CIOOFF_MASK;
+	cfg |= (f->rect.top << 16) | f->rect.left;
+	writel(cfg, dev->regs + FLITE_REG_CIOOFF);
+}
+
+/* Enable/disable output DMA, set output pixel size and offsets (composition) */
+void flite_hw_set_output_dma(struct fimc_lite *dev, struct flite_frame *f,
+			     bool enable)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+
+	if (!enable) {
+		cfg |= FLITE_REG_CIGCTRL_ODMA_DISABLE;
+		writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+		return;
+	}
+
+	cfg &= ~FLITE_REG_CIGCTRL_ODMA_DISABLE;
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+
+	flite_hw_set_out_order(dev, f);
+	flite_hw_set_dma_window(dev, f);
+}
+
+void flite_hw_dump_regs(struct fimc_lite *dev, const char *label)
+{
+	struct {
+		u32 offset;
+		const char * const name;
+	} registers[] = {
+		{ 0x00, "CISRCSIZE" },
+		{ 0x04, "CIGCTRL" },
+		{ 0x08, "CIIMGCPT" },
+		{ 0x0c, "CICPTSEQ" },
+		{ 0x10, "CIWDOFST" },
+		{ 0x14, "CIWDOFST2" },
+		{ 0x18, "CIODMAFMT" },
+		{ 0x20, "CIOCAN" },
+		{ 0x24, "CIOOFF" },
+		{ 0x30, "CIOSA" },
+		{ 0x40, "CISTATUS" },
+		{ 0x44, "CISTATUS2" },
+		{ 0xf0, "CITHOLD" },
+		{ 0xfc, "CIGENERAL" },
+	};
+	u32 i;
+
+	pr_info("--- %s ---\n", label);
+	for (i = 0; i < ARRAY_SIZE(registers); i++) {
+		u32 cfg = readl(dev->regs + registers[i].offset);
+		pr_info("%s: %s:\t0x%08x\n", __func__, registers[i].name, cfg);
+	}
+}
diff --git a/drivers/media/video/s5p-fimc/fimc-lite-reg.h b/drivers/media/video/s5p-fimc/fimc-lite-reg.h
new file mode 100644
index 0000000..44064e5
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-lite-reg.h
@@ -0,0 +1,153 @@
+/*
+ * Register interface file for EXYNOS4 FIMC-LITE (camera interface) driver
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_LITE_REG_H_
+#define FIMC_LITE_REG_H_
+
+#include "fimc-lite.h"
+
+/* Camera Source size */
+#define FLITE_REG_CISRCSIZE			0x00
+#define FLITE_REG_CISRCSIZE_ORDER422_IN_YCBYCR	(0 << 14)
+#define FLITE_REG_CISRCSIZE_ORDER422_IN_YCRYCB	(1 << 14)
+#define FLITE_REG_CISRCSIZE_ORDER422_IN_CBYCRY	(2 << 14)
+#define FLITE_REG_CISRCSIZE_ORDER422_IN_CRYCBY	(3 << 14)
+#define FLITE_REG_CISRCSIZE_ORDER422_MASK	(0x3 << 14)
+#define FLITE_REG_CISRCSIZE_SIZE_CAM_MASK	(0x3fff << 16 | 0x3fff)
+
+/* Global control */
+#define FLITE_REG_CIGCTRL			0x04
+#define FLITE_REG_CIGCTRL_YUV422_1P		(0x1e << 24)
+#define FLITE_REG_CIGCTRL_RAW8			(0x2a << 24)
+#define FLITE_REG_CIGCTRL_RAW10			(0x2b << 24)
+#define FLITE_REG_CIGCTRL_RAW12			(0x2c << 24)
+#define FLITE_REG_CIGCTRL_RAW14			(0x2d << 24)
+/* User defined formats. x = 0...15 */
+#define FLITE_REG_CIGCTRL_USER(x)		((0x30 + x - 1) << 24)
+#define FLITE_REG_CIGCTRL_FMT_MASK		(0x3f << 24)
+#define FLITE_REG_CIGCTRL_SHADOWMASK_DISABLE	(1 << 21)
+#define FLITE_REG_CIGCTRL_ODMA_DISABLE		(1 << 20)
+#define FLITE_REG_CIGCTRL_SWRST_REQ		(1 << 19)
+#define FLITE_REG_CIGCTRL_SWRST_RDY		(1 << 18)
+#define FLITE_REG_CIGCTRL_SWRST			(1 << 17)
+#define FLITE_REG_CIGCTRL_TEST_PATTERN_COLORBAR	(1 << 15)
+#define FLITE_REG_CIGCTRL_INVPOLPCLK		(1 << 14)
+#define FLITE_REG_CIGCTRL_INVPOLVSYNC		(1 << 13)
+#define FLITE_REG_CIGCTRL_INVPOLHREF		(1 << 12)
+/* Interrupts mask bits (1 disables an interrupt) */
+#define FLITE_REG_CIGCTRL_IRQ_LASTEN		(1 << 8)
+#define FLITE_REG_CIGCTRL_IRQ_ENDEN		(1 << 7)
+#define FLITE_REG_CIGCTRL_IRQ_STARTEN		(1 << 6)
+#define FLITE_REG_CIGCTRL_IRQ_OVFEN		(1 << 5)
+#define FLITE_REG_CIGCTRL_IRQ_DISABLE_MASK	(0xf << 5)
+#define FLITE_REG_CIGCTRL_SELCAM_MIPI		(1 << 3)
+
+/* Image Capture Enable */
+#define FLITE_REG_CIIMGCPT			0x08
+#define FLITE_REG_CIIMGCPT_IMGCPTEN		(1 << 31)
+#define FLITE_REG_CIIMGCPT_CPT_FREN		(1 << 25)
+#define FLITE_REG_CIIMGCPT_CPT_MOD_FRCNT	(1 << 18)
+#define FLITE_REG_CIIMGCPT_CPT_MOD_FREN		(0 << 18)
+
+/* Capture Sequence */
+#define FLITE_REG_CICPTSEQ			0x0c
+
+/* Camera Window Offset */
+#define FLITE_REG_CIWDOFST			0x10
+#define FLITE_REG_CIWDOFST_WINOFSEN		(1 << 31)
+#define FLITE_REG_CIWDOFST_CLROVIY		(1 << 31)
+#define FLITE_REG_CIWDOFST_CLROVFICB		(1 << 15)
+#define FLITE_REG_CIWDOFST_CLROVFICR		(1 << 14)
+#define FLITE_REG_CIWDOFST_OFST_MASK		((0x1fff << 16) | 0x1fff)
+
+/* Cmaera Window Offset2 */
+#define FLITE_REG_CIWDOFST2			0x14
+
+/* Camera Output DMA Format */
+#define FLITE_REG_CIODMAFMT			0x18
+#define FLITE_REG_CIODMAFMT_RAW_CON		(1 << 15)
+#define FLITE_REG_CIODMAFMT_PACK12		(1 << 14)
+#define FLITE_REG_CIODMAFMT_CRYCBY		(0 << 4)
+#define FLITE_REG_CIODMAFMT_CBYCRY		(1 << 4)
+#define FLITE_REG_CIODMAFMT_YCRYCB		(2 << 4)
+#define FLITE_REG_CIODMAFMT_YCBYCR		(3 << 4)
+#define FLITE_REG_CIODMAFMT_YCBCR_ORDER_MASK	(0x3 << 4)
+
+/* Camera Output Canvas */
+#define FLITE_REG_CIOCAN			0x20
+#define FLITE_REG_CIOCAN_MASK			((0x3fff << 16) | 0x3fff)
+
+/* Camera Output DMA Offset */
+#define FLITE_REG_CIOOFF			0x24
+#define FLITE_REG_CIOOFF_MASK			((0x3fff << 16) | 0x3fff)
+
+/* Camera Output DMA Start Address */
+#define FLITE_REG_CIOSA				0x30
+
+/* Camera Status */
+#define FLITE_REG_CISTATUS			0x40
+#define FLITE_REG_CISTATUS_MIPI_VVALID		(1 << 22)
+#define FLITE_REG_CISTATUS_MIPI_HVALID		(1 << 21)
+#define FLITE_REG_CISTATUS_MIPI_DVALID		(1 << 20)
+#define FLITE_REG_CISTATUS_ITU_VSYNC		(1 << 14)
+#define FLITE_REG_CISTATUS_ITU_HREFF		(1 << 13)
+#define FLITE_REG_CISTATUS_OVFIY		(1 << 10)
+#define FLITE_REG_CISTATUS_OVFICB		(1 << 9)
+#define FLITE_REG_CISTATUS_OVFICR		(1 << 8)
+#define FLITE_REG_CISTATUS_IRQ_SRC_OVERFLOW	(1 << 7)
+#define FLITE_REG_CISTATUS_IRQ_SRC_LASTCAPEND	(1 << 6)
+#define FLITE_REG_CISTATUS_IRQ_SRC_FRMSTART	(1 << 5)
+#define FLITE_REG_CISTATUS_IRQ_SRC_FRMEND	(1 << 4)
+#define FLITE_REG_CISTATUS_IRQ_CAM		(1 << 0)
+#define FLITE_REG_CISTATUS_IRQ_MASK		(0xf << 4)
+
+/* Camera Status2 */
+#define FLITE_REG_CISTATUS2			0x44
+#define FLITE_REG_CISTATUS2_LASTCAPEND		(1 << 1)
+#define FLITE_REG_CISTATUS2_FRMEND		(1 << 0)
+
+/* Qos Threshold */
+#define FLITE_REG_CITHOLD			0xf0
+#define FLITE_REG_CITHOLD_W_QOS_EN		(1 << 30)
+
+/* Camera General Purpose */
+#define FLITE_REG_CIGENERAL			0xfc
+/* b0: 1 - camera B, 0 - camera A */
+#define FLITE_REG_CIGENERAL_CAM_B		(1 << 0)
+
+/* ----------------------------------------------------------------------------
+ * Function declarations
+ */
+void flite_hw_reset(struct fimc_lite *dev);
+void flite_hw_clear_pending_irq(struct fimc_lite *dev);
+u32 flite_hw_get_interrupt_source(struct fimc_lite *dev);
+void flite_hw_clear_last_capture_end(struct fimc_lite *dev);
+void flite_hw_set_interrupt_mask(struct fimc_lite *dev);
+void flite_hw_capture_start(struct fimc_lite *dev);
+void flite_hw_capture_stop(struct fimc_lite *dev);
+void flite_hw_set_camera_bus(struct fimc_lite *dev,
+			     struct s5p_fimc_isp_info *s_info);
+void flite_hw_set_camera_polarity(struct fimc_lite *dev,
+				  struct s5p_fimc_isp_info *cam);
+void flite_hw_set_window_offset(struct fimc_lite *dev, struct flite_frame *f);
+void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f);
+
+void flite_hw_set_output_dma(struct fimc_lite *dev, struct flite_frame *f,
+			     bool enable);
+
+static inline void flite_hw_set_output_addr(struct fimc_lite *dev, u32 paddr)
+{
+	writel(paddr, dev->regs + FLITE_REG_CIOSA);
+}
+
+void flite_hw_dump_regs(struct fimc_lite *dev, const char *label);
+
+void flite_hw_set_dma_window(struct fimc_lite *dev, struct flite_frame *f);
+#endif /* FIMC_LITE_REG_H */
diff --git a/drivers/media/video/s5p-fimc/fimc-lite.h b/drivers/media/video/s5p-fimc/fimc-lite.h
new file mode 100644
index 0000000..99d24e8
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-lite.h
@@ -0,0 +1,212 @@
+/*
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_LITE_H_
+#define FIMC_LITE_H_
+
+#include <asm/sizes.h>
+#include <linux/io.h>
+#include <linux/irqreturn.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+#include <media/media-entity.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mediabus.h>
+#include <media/s5p_fimc.h>
+
+#include "fimc-core.h"
+
+#define FIMC_LITE_DRV_NAME	"exynos-fimc-lite"
+#define FLITE_CLK_NAME		"flite"
+#define FIMC_LITE_MAX_DEVS	2
+#define FLITE_REQ_BUFS_MIN	2
+
+/* Bit index definitions for struct fimc_lite::state */
+enum {
+	ST_FLITE_LPM,
+	ST_FLITE_PENDING,
+	ST_FLITE_RUN,
+	ST_FLITE_STREAM,
+	ST_FLITE_SUSPENDED,
+	ST_FLITE_OFF,
+	ST_FLITE_IN_USE,
+	ST_FLITE_CONFIG,
+	ST_SENSOR_STREAM,
+};
+
+#define FLITE_SD_PAD_SINK	0
+#define FLITE_SD_PAD_SOURCE	1
+#define FLITE_SD_PADS_NUM	2
+
+struct flite_variant {
+	unsigned short max_width;
+	unsigned short max_height;
+	unsigned short out_width_align;
+	unsigned short win_hor_offs_align;
+	unsigned short out_hor_offs_align;
+};
+
+struct flite_drvdata {
+	struct flite_variant *variant[FIMC_LITE_MAX_DEVS];
+	unsigned long lclk_frequency;
+};
+
+#define fimc_lite_get_drvdata(_pdev) \
+	((struct flite_drvdata *) platform_get_device_id(_pdev)->driver_data)
+
+struct fimc_lite_events {
+	unsigned int data_overflow;
+};
+
+#define FLITE_MAX_PLANES	1
+
+/**
+ * struct flite_frame - source/target frame properties
+ * @f_width: full pixel width
+ * @f_height: full pixel height
+ * @rect: crop/composition rectangle
+ */
+struct flite_frame {
+	u16 f_width;
+	u16 f_height;
+	struct v4l2_rect rect;
+};
+
+/**
+ * struct flite_buffer - video buffer structure
+ * @vb:    vb2 buffer
+ * @list:  list head for the buffers queue
+ * @paddr: precalculated physical address
+ */
+struct flite_buffer {
+	struct vb2_buffer vb;
+	struct list_head list;
+	dma_addr_t paddr;
+};
+
+/**
+ * struct fimc_lite - fimc lite structure
+ * @pdev: pointer to FIMC-LITE platform device
+ * @variant: variant information for this IP
+ * @v4l2_dev: pointer to top the level v4l2_device
+ * @vfd: video device node
+ * @fh:	v4l2 file handle
+ * @alloc_ctx: videobuf2 memory allocator context
+ * @subdev: FIMC-LITE subdev
+ * @vd_pad: media (sink) pad for the capture video node
+ * @subdev_pads: the subdev media pads
+ * @id:	FIMC-LITE platform device index
+ * @pipeline: video capture pipeline data structure
+ * @slock: spinlock protecting this data structure and the hw registers
+ * @lock: mutex serializing video device and the subdev operations
+ * @clock: FIMC-LITE gate clock
+ * @regs: memory mapped io registers
+ * @irq_queue: interrupt handler waitqueue
+ * @fmt: pointer to color format description structure
+ * @payload: image size in bytes (w x h x bpp)
+ * @inp_frame: camera input frame structure
+ * @out_frame: DMA output frame structure
+ * @out_path: output data path (DMA or FIFO)
+ * @source_subdev_grp_id: source subdev group id
+ * @state: driver state flags
+ * @pending_buf_q: pending buffers queue head
+ * @active_buf_q: the queue head of buffers scheduled in hardware
+ * @vb_queue: vb2 buffers queue
+ * @active_buf_count: number of video buffers scheduled in hardware
+ * @frame_count: the captured frames counter
+ * @reqbufs_count: the number of buffers requested with REQBUFS ioctl
+ * @ref_count: driver's private reference counter
+ */
+struct fimc_lite {
+	struct platform_device	*pdev;
+	struct flite_variant	*variant;
+	struct v4l2_device	*v4l2_dev;
+	struct video_device	*vfd;
+	struct v4l2_fh		fh;
+	struct vb2_alloc_ctx	*alloc_ctx;
+	struct v4l2_subdev	subdev;
+	struct media_pad	vd_pad;
+	struct media_pad	subdev_pads[FLITE_SD_PADS_NUM];
+	u16			id;
+	struct fimc_pipeline	pipeline;
+
+	struct mutex		lock;
+	spinlock_t		slock;
+
+	struct clk		*clock;
+	void __iomem		*regs;
+	wait_queue_head_t	irq_queue;
+
+	struct fimc_fmt		*fmt;
+	unsigned long		payload[FLITE_MAX_PLANES];
+	struct flite_frame	inp_frame;
+	struct flite_frame	out_frame;
+	enum fimc_datapath	out_path;
+	unsigned int		source_subdev_grp_id;
+
+	unsigned long		state;
+	struct list_head	pending_buf_q;
+	struct list_head	active_buf_q;
+	struct vb2_queue	vb_queue;
+	unsigned int		frame_count;
+	unsigned int		reqbufs_count;
+	int			ref_count;
+
+	struct fimc_lite_events	events;
+};
+
+#ifdef CONFIG_VIDEO_EXYNOS_FIMC_LITE
+static inline bool fimc_lite_active(struct fimc_lite *fimc)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	ret = !!(fimc->state & (1 << ST_FLITE_RUN) ||
+		 fimc->state & (1 << ST_FLITE_PENDING));
+	spin_unlock_irqrestore(&fimc->slock, flags);
+	return ret;
+}
+
+static inline void fimc_lite_active_queue_add(struct fimc_lite *dev,
+					 struct flite_buffer *buf)
+{
+	list_add_tail(&buf->list, &dev->active_buf_q);
+}
+
+static inline struct flite_buffer *fimc_lite_active_queue_pop(
+					struct fimc_lite *dev)
+{
+	struct flite_buffer *buf = list_entry(dev->active_buf_q.next,
+					      struct flite_buffer, list);
+	list_del(&buf->list);
+	return buf;
+}
+
+static inline void fimc_lite_pending_queue_add(struct fimc_lite *dev,
+					struct flite_buffer *buf)
+{
+	list_add_tail(&buf->list, &dev->pending_buf_q);
+}
+
+static inline struct flite_buffer *fimc_lite_pending_queue_pop(
+					struct fimc_lite *dev)
+{
+	struct flite_buffer *buf = list_entry(dev->pending_buf_q.next,
+					      struct flite_buffer, list);
+	list_del(&buf->list);
+	return buf;
+}
+#endif /* CONFIG_VIDEO_EXYNOS_FIMC_LITE */
+
+#endif /* FIMC_LITE_H_ */
-- 
1.7.10

