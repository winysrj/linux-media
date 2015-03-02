Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56470 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbbCBBtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2015 20:49:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>, devicetree@vger.kernel.org
Subject: [PATCH v5 7/8] v4l: xilinx: Add Video Timing Controller driver
Date: Mon,  2 Mar 2015 03:48:44 +0200
Message-Id: <1425260925-12064-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1425260925-12064-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1425260925-12064-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Video Timing Controller (VTC) includes a timing detector and/or a
timing generator. Only the generator is currently supported.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

---

Cc: devicetree@vger.kernel.org

Changes since v3:

- Use xvip_init_resources()

v1 was made of the following individual patches.

xilinx: Remove .owner field for drivers
v4l: xilinx: vtc: Rename compatible string to xlnx,v-tc
---
 .../devicetree/bindings/media/xilinx/xlnx,v-tc.txt |  33 ++
 drivers/media/platform/xilinx/Kconfig              |   6 +
 drivers/media/platform/xilinx/Makefile             |   1 +
 drivers/media/platform/xilinx/xilinx-vtc.c         | 380 +++++++++++++++++++++
 drivers/media/platform/xilinx/xilinx-vtc.h         |  42 +++
 5 files changed, 462 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,v-tc.txt
 create mode 100644 drivers/media/platform/xilinx/xilinx-vtc.c
 create mode 100644 drivers/media/platform/xilinx/xilinx-vtc.h

diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,v-tc.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,v-tc.txt
new file mode 100644
index 0000000..2aed3b4
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,v-tc.txt
@@ -0,0 +1,33 @@
+Xilinx Video Timing Controller (VTC)
+------------------------------------
+
+The Video Timing Controller is a general purpose video timing generator and
+detector.
+
+Required properties:
+
+  - compatible: Must be "xlnx,v-tc-6.1".
+
+  - reg: Physical base address and length of the registers set for the device.
+
+  - clocks: Must contain a clock specifier for the VTC core and timing
+    interfaces clock.
+
+Optional properties:
+
+  - xlnx,detector: The VTC has a timing detector
+  - xlnx,generator: The VTC has a timing generator
+
+  At least one of the xlnx,detector and xlnx,generator properties must be
+  specified.
+
+
+Example:
+
+	vtc: vtc@43c40000 {
+		compatible = "xlnx,v-tc-6.1";
+		reg = <0x43c40000 0x10000>;
+
+		clocks = <&clkc 15>;
+		xlnx,generator;
+	};
diff --git a/drivers/media/platform/xilinx/Kconfig b/drivers/media/platform/xilinx/Kconfig
index f4347e9..19db823 100644
--- a/drivers/media/platform/xilinx/Kconfig
+++ b/drivers/media/platform/xilinx/Kconfig
@@ -7,4 +7,10 @@ config VIDEO_XILINX
 
 if VIDEO_XILINX
 
+config VIDEO_XILINX_VTC
+	tristate "Xilinx Video Timing Controller"
+	depends on VIDEO_XILINX
+	---help---
+	   Driver for the Xilinx Video Timing Controller
+
 endif #VIDEO_XILINX
diff --git a/drivers/media/platform/xilinx/Makefile b/drivers/media/platform/xilinx/Makefile
index 3ef9c8e..6611e32 100644
--- a/drivers/media/platform/xilinx/Makefile
+++ b/drivers/media/platform/xilinx/Makefile
@@ -1,3 +1,4 @@
 xilinx-video-objs += xilinx-dma.o xilinx-vip.o xilinx-vipp.o
 
 obj-$(CONFIG_VIDEO_XILINX) += xilinx-video.o
+obj-$(CONFIG_VIDEO_XILINX_VTC) += xilinx-vtc.o
diff --git a/drivers/media/platform/xilinx/xilinx-vtc.c b/drivers/media/platform/xilinx/xilinx-vtc.c
new file mode 100644
index 0000000..194bdf2
--- /dev/null
+++ b/drivers/media/platform/xilinx/xilinx-vtc.c
@@ -0,0 +1,380 @@
+/*
+ * Xilinx Video Timing Controller
+ *
+ * Copyright (C) 2013-2014 Ideas on Board
+ * Copyright (C) 2013-2014 Xilinx, Inc.
+ *
+ * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
+ *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "xilinx-vip.h"
+#include "xilinx-vtc.h"
+
+#define XVTC_CONTROL_FIELD_ID_POL_SRC		(1 << 26)
+#define XVTC_CONTROL_ACTIVE_CHROMA_POL_SRC	(1 << 25)
+#define XVTC_CONTROL_ACTIVE_VIDEO_POL_SRC	(1 << 24)
+#define XVTC_CONTROL_HSYNC_POL_SRC		(1 << 23)
+#define XVTC_CONTROL_VSYNC_POL_SRC		(1 << 22)
+#define XVTC_CONTROL_HBLANK_POL_SRC		(1 << 21)
+#define XVTC_CONTROL_VBLANK_POL_SRC		(1 << 20)
+#define XVTC_CONTROL_CHROMA_SRC			(1 << 18)
+#define XVTC_CONTROL_VBLANK_HOFF_SRC		(1 << 17)
+#define XVTC_CONTROL_VSYNC_END_SRC		(1 << 16)
+#define XVTC_CONTROL_VSYNC_START_SRC		(1 << 15)
+#define XVTC_CONTROL_ACTIVE_VSIZE_SRC		(1 << 14)
+#define XVTC_CONTROL_FRAME_VSIZE_SRC		(1 << 13)
+#define XVTC_CONTROL_HSYNC_END_SRC		(1 << 11)
+#define XVTC_CONTROL_HSYNC_START_SRC		(1 << 10)
+#define XVTC_CONTROL_ACTIVE_HSIZE_SRC		(1 << 9)
+#define XVTC_CONTROL_FRAME_HSIZE_SRC		(1 << 8)
+#define XVTC_CONTROL_SYNC_ENABLE		(1 << 5)
+#define XVTC_CONTROL_DET_ENABLE			(1 << 3)
+#define XVTC_CONTROL_GEN_ENABLE			(1 << 2)
+
+#define XVTC_STATUS_FSYNC(n)			((n) << 16)
+#define XVTC_STATUS_GEN_ACTIVE_VIDEO		(1 << 13)
+#define XVTC_STATUS_GEN_VBLANK			(1 << 12)
+#define XVTC_STATUS_DET_ACTIVE_VIDEO		(1 << 11)
+#define XVTC_STATUS_DET_VBLANK			(1 << 10)
+#define XVTC_STATUS_LOCK_LOSS			(1 << 9)
+#define XVTC_STATUS_LOCK			(1 << 8)
+
+#define XVTC_ERROR_ACTIVE_CHROMA_LOCK		(1 << 21)
+#define XVTC_ERROR_ACTIVE_VIDEO_LOCK		(1 << 20)
+#define XVTC_ERROR_HSYNC_LOCK			(1 << 19)
+#define XVTC_ERROR_VSYNC_LOCK			(1 << 18)
+#define XVTC_ERROR_HBLANK_LOCK			(1 << 17)
+#define XVTC_ERROR_VBLANK_LOCK			(1 << 16)
+
+#define XVTC_IRQ_ENABLE_FSYNC(n)		((n) << 16)
+#define XVTC_IRQ_ENABLE_GEN_ACTIVE_VIDEO	(1 << 13)
+#define XVTC_IRQ_ENABLE_GEN_VBLANK		(1 << 12)
+#define XVTC_IRQ_ENABLE_DET_ACTIVE_VIDEO	(1 << 11)
+#define XVTC_IRQ_ENABLE_DET_VBLANK		(1 << 10)
+#define XVTC_IRQ_ENABLE_LOCK_LOSS		(1 << 9)
+#define XVTC_IRQ_ENABLE_LOCK			(1 << 8)
+
+/*
+ * The following registers exist in two blocks, one at 0x0020 for the detector
+ * and one at 0x0060 for the generator.
+ */
+
+#define XVTC_DETECTOR_OFFSET			0x0020
+#define XVTC_GENERATOR_OFFSET			0x0060
+
+#define XVTC_ACTIVE_SIZE			0x0000
+#define XVTC_ACTIVE_VSIZE_SHIFT			16
+#define XVTC_ACTIVE_VSIZE_MASK			(0x1fff << 16)
+#define XVTC_ACTIVE_HSIZE_SHIFT			0
+#define XVTC_ACTIVE_HSIZE_MASK			(0x1fff << 0)
+
+#define XVTC_TIMING_STATUS			0x0004
+#define XVTC_TIMING_STATUS_ACTIVE_VIDEO		(1 << 2)
+#define XVTC_TIMING_STATUS_VBLANK		(1 << 1)
+#define XVTC_TIMING_STATUS_LOCKED		(1 << 0)
+
+#define XVTC_ENCODING				0x0008
+#define XVTC_ENCODING_CHROMA_PARITY_SHIFT	8
+#define XVTC_ENCODING_CHROMA_PARITY_MASK	(3 << 8)
+#define XVTC_ENCODING_CHROMA_PARITY_EVEN_ALL	(0 << 8)
+#define XVTC_ENCODING_CHROMA_PARITY_ODD_ALL	(1 << 8)
+#define XVTC_ENCODING_CHROMA_PARITY_EVEN_EVEN	(2 << 8)
+#define XVTC_ENCODING_CHROMA_PARITY_ODD_EVEN	(3 << 8)
+#define XVTC_ENCODING_VIDEO_FORMAT_SHIFT	0
+#define XVTC_ENCODING_VIDEO_FORMAT_MASK		(0xf << 0)
+#define XVTC_ENCODING_VIDEO_FORMAT_YUV422	(0 << 0)
+#define XVTC_ENCODING_VIDEO_FORMAT_YUV444	(1 << 0)
+#define XVTC_ENCODING_VIDEO_FORMAT_RGB		(2 << 0)
+#define XVTC_ENCODING_VIDEO_FORMAT_YUV420	(3 << 0)
+
+#define XVTC_POLARITY				0x000c
+#define XVTC_POLARITY_ACTIVE_CHROMA_POL		(1 << 5)
+#define XVTC_POLARITY_ACTIVE_VIDEO_POL		(1 << 4)
+#define XVTC_POLARITY_HSYNC_POL			(1 << 3)
+#define XVTC_POLARITY_VSYNC_POL			(1 << 2)
+#define XVTC_POLARITY_HBLANK_POL		(1 << 1)
+#define XVTC_POLARITY_VBLANK_POL		(1 << 0)
+
+#define XVTC_HSIZE				0x0010
+#define XVTC_HSIZE_MASK				(0x1fff << 0)
+
+#define XVTC_VSIZE				0x0014
+#define XVTC_VSIZE_MASK				(0x1fff << 0)
+
+#define XVTC_HSYNC				0x0018
+#define XVTC_HSYNC_END_SHIFT			16
+#define XVTC_HSYNC_END_MASK			(0x1fff << 16)
+#define XVTC_HSYNC_START_SHIFT			0
+#define XVTC_HSYNC_START_MASK			(0x1fff << 0)
+
+#define XVTC_F0_VBLANK_H			0x001c
+#define XVTC_F0_VBLANK_HEND_SHIFT		16
+#define XVTC_F0_VBLANK_HEND_MASK		(0x1fff << 16)
+#define XVTC_F0_VBLANK_HSTART_SHIFT		0
+#define XVTC_F0_VBLANK_HSTART_MASK		(0x1fff << 0)
+
+#define XVTC_F0_VSYNC_V				0x0020
+#define XVTC_F0_VSYNC_VEND_SHIFT		16
+#define XVTC_F0_VSYNC_VEND_MASK			(0x1fff << 16)
+#define XVTC_F0_VSYNC_VSTART_SHIFT		0
+#define XVTC_F0_VSYNC_VSTART_MASK		(0x1fff << 0)
+
+#define XVTC_F0_VSYNC_H				0x0024
+#define XVTC_F0_VSYNC_HEND_SHIFT		16
+#define XVTC_F0_VSYNC_HEND_MASK			(0x1fff << 16)
+#define XVTC_F0_VSYNC_HSTART_SHIFT		0
+#define XVTC_F0_VSYNC_HSTART_MASK		(0x1fff << 0)
+
+#define XVTC_FRAME_SYNC_CONFIG(n)		(0x0100 + 4 * (n))
+#define XVTC_FRAME_SYNC_V_START_SHIFT		16
+#define XVTC_FRAME_SYNC_V_START_MASK		(0x1fff << 16)
+#define XVTC_FRAME_SYNC_H_START_SHIFT		0
+#define XVTC_FRAME_SYNC_H_START_MASK		(0x1fff << 0)
+
+#define XVTC_GENERATOR_GLOBAL_DELAY		0x0104
+
+/**
+ * struct xvtc_device - Xilinx Video Timing Controller device structure
+ * @xvip: Xilinx Video IP device
+ * @list: entry in the global VTC list
+ * @has_detector: the VTC has a timing detector
+ * @has_generator: the VTC has a timing generator
+ * @config: generator timings configuration
+ */
+struct xvtc_device {
+	struct xvip_device xvip;
+	struct list_head list;
+
+	bool has_detector;
+	bool has_generator;
+
+	struct xvtc_config config;
+};
+
+static LIST_HEAD(xvtc_list);
+static DEFINE_MUTEX(xvtc_lock);
+
+static inline void xvtc_gen_write(struct xvtc_device *xvtc, u32 addr, u32 value)
+{
+	xvip_write(&xvtc->xvip, XVTC_GENERATOR_OFFSET + addr, value);
+}
+
+/* -----------------------------------------------------------------------------
+ * Generator Operations
+ */
+
+int xvtc_generator_start(struct xvtc_device *xvtc,
+			 const struct xvtc_config *config)
+{
+	int ret;
+
+	if (!xvtc->has_generator)
+		return -ENXIO;
+
+	ret = clk_prepare_enable(xvtc->xvip.clk);
+	if (ret < 0)
+		return ret;
+
+	/* We don't care about the chroma active signal, encoding parameters are
+	 * not important for now.
+	 */
+	xvtc_gen_write(xvtc, XVTC_POLARITY,
+		       XVTC_POLARITY_ACTIVE_CHROMA_POL |
+		       XVTC_POLARITY_ACTIVE_VIDEO_POL |
+		       XVTC_POLARITY_HSYNC_POL | XVTC_POLARITY_VSYNC_POL |
+		       XVTC_POLARITY_HBLANK_POL | XVTC_POLARITY_VBLANK_POL);
+
+	/* Hardcode the polarity to active high, as required by the video in to
+	 * AXI4-stream core.
+	 */
+	xvtc_gen_write(xvtc, XVTC_ENCODING, 0);
+
+	/* Configure the timings. The VBLANK and VSYNC signals assertion and
+	 * deassertion are hardcoded to the first pixel of the line.
+	 */
+	xvtc_gen_write(xvtc, XVTC_ACTIVE_SIZE,
+		       (config->vblank_start << XVTC_ACTIVE_VSIZE_SHIFT) |
+		       (config->hblank_start << XVTC_ACTIVE_HSIZE_SHIFT));
+	xvtc_gen_write(xvtc, XVTC_HSIZE, config->hsize);
+	xvtc_gen_write(xvtc, XVTC_VSIZE, config->vsize);
+	xvtc_gen_write(xvtc, XVTC_HSYNC,
+		       (config->hsync_end << XVTC_HSYNC_END_SHIFT) |
+		       (config->hsync_start << XVTC_HSYNC_START_SHIFT));
+	xvtc_gen_write(xvtc, XVTC_F0_VBLANK_H, 0);
+	xvtc_gen_write(xvtc, XVTC_F0_VSYNC_V,
+		       (config->vsync_end << XVTC_F0_VSYNC_VEND_SHIFT) |
+		       (config->vsync_start << XVTC_F0_VSYNC_VSTART_SHIFT));
+	xvtc_gen_write(xvtc, XVTC_F0_VSYNC_H, 0);
+
+	/* Enable the generator. Set the source of all generator parameters to
+	 * generator registers.
+	 */
+	xvip_write(&xvtc->xvip, XVIP_CTRL_CONTROL,
+		   XVTC_CONTROL_ACTIVE_CHROMA_POL_SRC |
+		   XVTC_CONTROL_ACTIVE_VIDEO_POL_SRC |
+		   XVTC_CONTROL_HSYNC_POL_SRC | XVTC_CONTROL_VSYNC_POL_SRC |
+		   XVTC_CONTROL_HBLANK_POL_SRC | XVTC_CONTROL_VBLANK_POL_SRC |
+		   XVTC_CONTROL_CHROMA_SRC | XVTC_CONTROL_VBLANK_HOFF_SRC |
+		   XVTC_CONTROL_VSYNC_END_SRC | XVTC_CONTROL_VSYNC_START_SRC |
+		   XVTC_CONTROL_ACTIVE_VSIZE_SRC |
+		   XVTC_CONTROL_FRAME_VSIZE_SRC | XVTC_CONTROL_HSYNC_END_SRC |
+		   XVTC_CONTROL_HSYNC_START_SRC |
+		   XVTC_CONTROL_ACTIVE_HSIZE_SRC |
+		   XVTC_CONTROL_FRAME_HSIZE_SRC | XVTC_CONTROL_GEN_ENABLE |
+		   XVIP_CTRL_CONTROL_REG_UPDATE);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xvtc_generator_start);
+
+int xvtc_generator_stop(struct xvtc_device *xvtc)
+{
+	if (!xvtc->has_generator)
+		return -ENXIO;
+
+	xvip_write(&xvtc->xvip, XVIP_CTRL_CONTROL, 0);
+
+	clk_disable_unprepare(xvtc->xvip.clk);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xvtc_generator_stop);
+
+struct xvtc_device *xvtc_of_get(struct device_node *np)
+{
+	struct device_node *xvtc_node;
+	struct xvtc_device *found = NULL;
+	struct xvtc_device *xvtc;
+
+	if (!of_find_property(np, "xlnx,vtc", NULL))
+		return NULL;
+
+	xvtc_node = of_parse_phandle(np, "xlnx,vtc", 0);
+	if (xvtc_node == NULL)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&xvtc_lock);
+	list_for_each_entry(xvtc, &xvtc_list, list) {
+		if (xvtc->xvip.dev->of_node == xvtc_node) {
+			found = xvtc;
+			break;
+		}
+	}
+	mutex_unlock(&xvtc_lock);
+
+	of_node_put(xvtc_node);
+
+	if (!found)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	return found;
+}
+EXPORT_SYMBOL_GPL(xvtc_of_get);
+
+void xvtc_put(struct xvtc_device *xvtc)
+{
+}
+EXPORT_SYMBOL_GPL(xvtc_put);
+
+/* -----------------------------------------------------------------------------
+ * Registration and Unregistration
+ */
+
+static void xvtc_register_device(struct xvtc_device *xvtc)
+{
+	mutex_lock(&xvtc_lock);
+	list_add_tail(&xvtc->list, &xvtc_list);
+	mutex_unlock(&xvtc_lock);
+}
+
+static void xvtc_unregister_device(struct xvtc_device *xvtc)
+{
+	mutex_lock(&xvtc_lock);
+	list_del(&xvtc->list);
+	mutex_unlock(&xvtc_lock);
+}
+
+/* -----------------------------------------------------------------------------
+ * Platform Device Driver
+ */
+
+static int xvtc_parse_of(struct xvtc_device *xvtc)
+{
+	struct device_node *node = xvtc->xvip.dev->of_node;
+
+	xvtc->has_detector = of_property_read_bool(node, "xlnx,detector");
+	xvtc->has_generator = of_property_read_bool(node, "xlnx,generator");
+
+	return 0;
+}
+
+static int xvtc_probe(struct platform_device *pdev)
+{
+	struct xvtc_device *xvtc;
+	int ret;
+
+	xvtc = devm_kzalloc(&pdev->dev, sizeof(*xvtc), GFP_KERNEL);
+	if (!xvtc)
+		return -ENOMEM;
+
+	xvtc->xvip.dev = &pdev->dev;
+
+	ret = xvtc_parse_of(xvtc);
+	if (ret < 0)
+		return ret;
+
+	ret = xvip_init_resources(&xvtc->xvip);
+	if (ret < 0)
+		return ret;
+
+	platform_set_drvdata(pdev, xvtc);
+
+	xvip_print_version(&xvtc->xvip);
+
+	xvtc_register_device(xvtc);
+
+	return 0;
+}
+
+static int xvtc_remove(struct platform_device *pdev)
+{
+	struct xvtc_device *xvtc = platform_get_drvdata(pdev);
+
+	xvtc_unregister_device(xvtc);
+
+	xvip_cleanup_resources(&xvtc->xvip);
+
+	return 0;
+}
+
+static const struct of_device_id xvtc_of_id_table[] = {
+	{ .compatible = "xlnx,v-tc-6.1" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, xvtc_of_id_table);
+
+static struct platform_driver xvtc_driver = {
+	.driver = {
+		.name = "xilinx-vtc",
+		.of_match_table = xvtc_of_id_table,
+	},
+	.probe = xvtc_probe,
+	.remove = xvtc_remove,
+};
+
+module_platform_driver(xvtc_driver);
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("Xilinx Video Timing Controller Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/xilinx/xilinx-vtc.h b/drivers/media/platform/xilinx/xilinx-vtc.h
new file mode 100644
index 0000000..da632fe
--- /dev/null
+++ b/drivers/media/platform/xilinx/xilinx-vtc.h
@@ -0,0 +1,42 @@
+/*
+ * Xilinx Video Timing Controller
+ *
+ * Copyright (C) 2013-2014 Ideas on Board
+ * Copyright (C) 2013-2014 Xilinx, Inc.
+ *
+ * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
+ *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __XILINX_VTC_H__
+#define __XILINX_VTC_H__
+
+struct device_node;
+struct xvtc_device;
+
+#define XVTC_MAX_HSIZE			8191
+#define XVTC_MAX_VSIZE			8191
+
+struct xvtc_config {
+	unsigned int hblank_start;
+	unsigned int hsync_start;
+	unsigned int hsync_end;
+	unsigned int hsize;
+	unsigned int vblank_start;
+	unsigned int vsync_start;
+	unsigned int vsync_end;
+	unsigned int vsize;
+};
+
+struct xvtc_device *xvtc_of_get(struct device_node *np);
+void xvtc_put(struct xvtc_device *xvtc);
+
+int xvtc_generator_start(struct xvtc_device *xvtc,
+			 const struct xvtc_config *config);
+int xvtc_generator_stop(struct xvtc_device *xvtc);
+
+#endif /* __XILINX_VTC_H__ */
-- 
2.0.5

