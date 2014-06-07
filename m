Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54777 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaFGV5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:43 -0400
Received: by mail-pd0-f171.google.com with SMTP id y13so3830824pdi.30
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:42 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>,
	Jiada Wang <jiada_wang@mentor.com>,
	Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: [PATCH 39/43] media: Add new camera interface driver for i.MX6
Date: Sat,  7 Jun 2014 14:56:41 -0700
Message-Id: <1402178205-22697-40-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a V4L2 camera interface driver for i.MX6. See
Documentation/video4linux/mx6_camera.txt.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Signed-off-by: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
---
 Documentation/video4linux/mx6_camera.txt         |  188 ++
 drivers/staging/media/Kconfig                    |    2 +
 drivers/staging/media/Makefile                   |    1 +
 drivers/staging/media/imx6/Kconfig               |   25 +
 drivers/staging/media/imx6/Makefile              |    1 +
 drivers/staging/media/imx6/capture/Kconfig       |   11 +
 drivers/staging/media/imx6/capture/Makefile      |    4 +
 drivers/staging/media/imx6/capture/mipi-csi2.c   |  322 ++++
 drivers/staging/media/imx6/capture/mx6-camif.c   | 2235 ++++++++++++++++++++++
 drivers/staging/media/imx6/capture/mx6-camif.h   |  197 ++
 drivers/staging/media/imx6/capture/mx6-encode.c  |  775 ++++++++
 drivers/staging/media/imx6/capture/mx6-preview.c |  748 ++++++++
 include/media/imx6.h                             |   18 +
 13 files changed, 4527 insertions(+)
 create mode 100644 Documentation/video4linux/mx6_camera.txt
 create mode 100644 drivers/staging/media/imx6/Kconfig
 create mode 100644 drivers/staging/media/imx6/Makefile
 create mode 100644 drivers/staging/media/imx6/capture/Kconfig
 create mode 100644 drivers/staging/media/imx6/capture/Makefile
 create mode 100644 drivers/staging/media/imx6/capture/mipi-csi2.c
 create mode 100644 drivers/staging/media/imx6/capture/mx6-camif.c
 create mode 100644 drivers/staging/media/imx6/capture/mx6-camif.h
 create mode 100644 drivers/staging/media/imx6/capture/mx6-encode.c
 create mode 100644 drivers/staging/media/imx6/capture/mx6-preview.c
 create mode 100644 include/media/imx6.h

diff --git a/Documentation/video4linux/mx6_camera.txt b/Documentation/video4linux/mx6_camera.txt
new file mode 100644
index 0000000..d712f91
--- /dev/null
+++ b/Documentation/video4linux/mx6_camera.txt
@@ -0,0 +1,188 @@
+                         i.MX6 Video Capture Driver
+                         ==========================
+
+Introduction
+------------
+
+The Freescale i.MX6 contains an Image Processing Unit (IPU), which
+handles the flow of image frames to and from capture devices and
+display devices.
+
+For image capture, the IPU contains the following subunits:
+
+- Image DMA Controller (IDMAC)
+- Camera Serial Interface (CSI)
+- Image Converter (IC)
+- Sensor Multi-FIFO Controller (SMFC)
+- Image Rotator (IRT)
+- Video De-Interlace Controller (VDIC)
+
+The IDMAC is the DMA controller for transfer of image frames to and from
+memory. Various dedicated DMA channels exist for both video capture and
+display paths.
+
+The CSI is the frontend capture unit that interfaces directly with
+capture devices over Parallel, BT.656, and MIPI CSI-2 busses.
+
+The IC handles color-space conversion, resizing, and rotation
+operations.
+
+The SMFC is used to send image frames directly to memory, bypassing the
+IC. The SMFC is used when no color-space conversion or resizing is
+required, i.e. the requested V4L2 formats and color-space are identical
+to raw frames from the capture device.
+
+The IRT carries out 90 and 270 degree image rotation operations.
+
+Finally, the VDIC handles the conversion of interlaced video to
+progressive, with support for different motion compensation modes (low
+and high).
+
+For more info, refer to the latest versions of the i.MX6 reference
+manuals listed under References.
+
+
+Features
+--------
+
+Some of the features of this driver include:
+
+- Supports parallel, BT.565, and MIPI CSI-2 interfaces.
+
+- Camera Preview mode.
+
+- Multiple subdev sensors can be registered and controlled by a single
+  interface driver instance. Input enumeration will list every registered
+  sensor's inputs and input names, and setting an input will switch to
+  a different sensor if the input index is handled by a different sensor.
+
+- Simultaneous streaming from two separate sensors is possible with two
+  interface driver instances, each instance controlling a different
+  sensor. This is currently possible with the SabreSD reference board
+  with OV5642 and MIPI CSI-2 OV5640 sensors.
+
+- Separate rotation control for both streaming and preview. Streaming
+  rotation control is via main video device node, and preview rotation
+  control via subdevice node.
+
+- Scaling and color-space conversion for both streaming and preview.
+
+- Many pixel formats supported (RGB, packed and planar YUV, partial
+  planar YUV).
+
+- Full device-tree support using OF graph bindings.
+
+- Analog decoder input video source hot-swap support (during streaming)
+  via decoder status change subdev notification.
+
+- MMAP, USERPTR, and DMABUF importer/exporter buffers supported.
+
+- De-interlacing is supported via simple even/odd line interleaving
+  which is a facility of the IDMAC. The VDIC is not yet supported, but
+  plans are in the works to allow more advanced motion compensation.
+
+
+
+Usage Notes
+-----------
+
+The i.MX6 capture driver is a standardized driver that supports the
+following community V4L2 tools:
+
+- v4l2-ctl
+- v4l2-cap
+- v4l2src gstreamer plugin
+
+
+The following platforms have been tested:
+
+
+SabreLite with parallel-interface OV5642
+----------------------------------------
+
+This platform requires the OmniVision OV5642 module with a parallel
+camera interface from Boundary Devices for the SabreLite
+(http://boundarydevices.com/products/nit6x_5mp/).
+
+There is a pin conflict between OV5642 and ethernet devices on this
+platform, so by default video capture is disabled in the device tree. To
+enable video capture, edit arch/arm/boot/dts/imx6qdl-sabrelite.dtsi and
+uncomment the macro __OV5642_CAPTURE__.
+
+
+SabreAuto with ADV7180 decoder
+------------------------------
+
+This platform accepts Composite Video analog inputs on Ain1 (connector
+J42) and Ain3 (connector J43).
+
+To switch to Ain1:
+
+# v4l2-ctl -i0
+
+To switch to Ain3:
+
+# v4l2-ctl -i1
+
+
+SabreSD with MIPI CSI-2 OV5640
+------------------------------
+
+The default device tree for SabreSD includes endpoints for both the
+parallel OV5642 and the MIPI CSI-2 OV5640, but as of this writing only
+the MIPI CSI-2 OV5640 has been tested. The OV5640 module connects to
+MIPI connector J5 (sorry I don't have the compatible module part number
+or URL).
+
+Inputs are registered for both the OV5642 and OV5640, and by default the
+OV5642 is selected. To switch to the OV5640:
+
+# v4l2-ctl -i1
+
+
+Preview Notes
+-------------
+
+Preview accepts a framebuffer physaddr via standard VIDIOC_S_FBUF. The
+driver is agnostic about the source of this framebuffer, it could come
+from a DRM-based background or overlay plane, or from legacy fbdev.
+
+Preview is implemented as a sub-device, and exports controls to
+allow preview horizontal/vertical flip and rotation settings independent
+of the same settings for streaming. These controls are available on
+/dev/v4l-subdev0.
+
+
+Known Issues
+------------
+
+There is one currently known issue. When using 90 or 270 degree rotation
+control at capture resolutions near the IC resizer limit of 1024x1024,
+and combined with planar pixel formats (YUV420, YUV422p), frame capture
+will often fail with no end-of-frame interrupts from the IDMAC channel.
+To work around this, use lower resolution and/or packed formats (YUYV,
+RGB3, etc.) when 90 or 270 rotations are needed.
+
+
+File list
+---------
+
+drivers/staging/media/imx6/capture/
+include/media/imx6.h
+
+
+References
+----------
+
+[1] "i.MX 6Dual/6Quad Applications Processor Reference Manual"
+[2] "i.MX 6Solo/6DualLite Applications Processor Reference Manual"
+
+
+Authors
+-------
+Steve Longerbeam <steve_longerbeam@mentor.com>
+Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
+Jiada Wang <jiada_wang@mentor.com>
+Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
+
+Copyright (C) 2012-2014 Mentor Graphics Inc.
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index a9f2e63..fd94c05 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -31,6 +31,8 @@ source "drivers/staging/media/dt3155v4l/Kconfig"
 
 source "drivers/staging/media/go7007/Kconfig"
 
+source "drivers/staging/media/imx6/Kconfig"
+
 source "drivers/staging/media/msi3101/Kconfig"
 
 source "drivers/staging/media/omap24xx/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 8e2c5d2..6faee43 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_SOLO6X10)		+= solo6x10/
 obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l/
 obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
+obj-$(CONFIG_VIDEO_IMX6)	+= imx6/
 obj-$(CONFIG_USB_MSI3101)	+= msi3101/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
diff --git a/drivers/staging/media/imx6/Kconfig b/drivers/staging/media/imx6/Kconfig
new file mode 100644
index 0000000..6d94f3f
--- /dev/null
+++ b/drivers/staging/media/imx6/Kconfig
@@ -0,0 +1,25 @@
+config VIDEO_IMX6
+	tristate "i.MX6 V4L2 devices"
+	depends on VIDEO_V4L2 && ARCH_MXC && DRM_IMX_IPUV3_CORE
+	default y
+	---help---
+	  Say yes here to enable support for video4linux capture for
+	  the i.MX6 SOC.
+
+config VIDEO_IMX6_CAMERA
+	tristate "i.MX6 Camera Interface driver"
+	depends on VIDEO_IMX6 && VIDEO_DEV && I2C
+	select VIDEOBUF2_DMA_CONTIG
+	default y
+	---help---
+	  A video4linux capture driver for i.MX6 SOC. Some of the
+	  features of this driver include simultaneous streaming
+	  and preview (overlay) support, MIPI CSI-2 sensor support,
+	  separate rotation control for both streaming and preview,
+	  scaling and colorspace conversion, simultaneous capture
+	  from separate sensors, dmabuf importer/exporter, and full
+	  devicetree support.
+
+if VIDEO_IMX6_CAMERA
+source "drivers/staging/media/imx6/capture/Kconfig"
+endif
diff --git a/drivers/staging/media/imx6/Makefile b/drivers/staging/media/imx6/Makefile
new file mode 100644
index 0000000..e0ed058
--- /dev/null
+++ b/drivers/staging/media/imx6/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_IMX6_CAMERA) += capture/
diff --git a/drivers/staging/media/imx6/capture/Kconfig b/drivers/staging/media/imx6/capture/Kconfig
new file mode 100644
index 0000000..ee4f017
--- /dev/null
+++ b/drivers/staging/media/imx6/capture/Kconfig
@@ -0,0 +1,11 @@
+menu "i.MX6 Camera Sensors"
+
+config IMX6_MIPI_CSI2
+       tristate "MIPI CSI2 Receiver Driver"
+       depends on VIDEO_IMX6_CAMERA
+       default y
+       ---help---
+         MIPI CSI-2 Receiver driver support. This driver is required
+	 for sensor drivers with a MIPI CSI2 interface.
+
+endmenu
diff --git a/drivers/staging/media/imx6/capture/Makefile b/drivers/staging/media/imx6/capture/Makefile
new file mode 100644
index 0000000..832d75d
--- /dev/null
+++ b/drivers/staging/media/imx6/capture/Makefile
@@ -0,0 +1,4 @@
+mx6-camera-objs := mx6-camif.o mx6-encode.o mx6-preview.o
+
+obj-$(CONFIG_VIDEO_IMX6_CAMERA) += mx6-camera.o
+obj-$(CONFIG_IMX6_MIPI_CSI2) += mipi-csi2.o
diff --git a/drivers/staging/media/imx6/capture/mipi-csi2.c b/drivers/staging/media/imx6/capture/mipi-csi2.c
new file mode 100644
index 0000000..4e2aadd
--- /dev/null
+++ b/drivers/staging/media/imx6/capture/mipi-csi2.c
@@ -0,0 +1,322 @@
+/*
+ * MIPI CSI-2 Receiver Subdev for Freescale i.MX6 SOC.
+ *
+ * Copyright (c) 2012-2014 Mentor Graphics Inc.
+ * Copyright 2004-2012 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/list.h>
+#include <linux/irq.h>
+#include <linux/of_device.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-subdev.h>
+#include <asm/mach/irq.h>
+#include <linux/platform_data/imx-ipu-v3.h>
+
+struct mx6csi2_dev {
+	struct device          *dev;
+	struct v4l2_subdev      sd;
+	struct clk             *dphy_clk;
+	struct clk             *cfg_clk;
+	void __iomem           *base;
+	int                     intr1;
+	int                     intr2;
+	struct v4l2_of_bus_mipi_csi2 bus;
+	spinlock_t              lock;
+	bool                    on;
+};
+
+#define DEVICE_NAME "imx6-mipi-csi2"
+
+/* Register offsets */
+#define CSI2_VERSION            0x000
+#define CSI2_N_LANES            0x004
+#define CSI2_PHY_SHUTDOWNZ      0x008
+#define CSI2_DPHY_RSTZ          0x00c
+#define CSI2_RESETN             0x010
+#define CSI2_PHY_STATE          0x014
+#define CSI2_DATA_IDS_1         0x018
+#define CSI2_DATA_IDS_2         0x01c
+#define CSI2_ERR1               0x020
+#define CSI2_ERR2               0x024
+#define CSI2_MSK1               0x028
+#define CSI2_MSK2               0x02c
+#define CSI2_PHY_TST_CTRL0      0x030
+#define CSI2_PHY_TST_CTRL1      0x034
+#define CSI2_SFT_RESET          0xf00
+
+static inline struct mx6csi2_dev *sd_to_dev(struct v4l2_subdev *sdev)
+{
+	return container_of(sdev, struct mx6csi2_dev, sd);
+}
+
+static inline u32 mx6csi2_read(struct mx6csi2_dev *csi2, unsigned regoff)
+{
+	return readl(csi2->base + regoff);
+}
+
+static inline void mx6csi2_write(struct mx6csi2_dev *csi2, u32 val,
+				 unsigned regoff)
+{
+	writel(val, csi2->base + regoff);
+}
+
+static void mx6csi2_set_lanes(struct mx6csi2_dev *csi2)
+{
+	int lanes = csi2->bus.num_data_lanes;
+	unsigned long flags;
+
+	spin_lock_irqsave(&csi2->lock, flags);
+
+	mx6csi2_write(csi2, lanes - 1, CSI2_N_LANES);
+
+	spin_unlock_irqrestore(&csi2->lock, flags);
+}
+
+static void __mx6csi2_enable(struct mx6csi2_dev *csi2, bool enable)
+{
+	if (enable) {
+		mx6csi2_write(csi2, 0xffffffff, CSI2_PHY_SHUTDOWNZ);
+		mx6csi2_write(csi2, 0xffffffff, CSI2_DPHY_RSTZ);
+		mx6csi2_write(csi2, 0xffffffff, CSI2_RESETN);
+	} else {
+		mx6csi2_write(csi2, 0x0, CSI2_PHY_SHUTDOWNZ);
+		mx6csi2_write(csi2, 0x0, CSI2_DPHY_RSTZ);
+		mx6csi2_write(csi2, 0x0, CSI2_RESETN);
+	}
+}
+
+static void mx6csi2_enable(struct mx6csi2_dev *csi2, bool enable)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&csi2->lock, flags);
+	__mx6csi2_enable(csi2, enable);
+	spin_unlock_irqrestore(&csi2->lock, flags);
+}
+
+static void mx6csi2_reset(struct mx6csi2_dev *csi2)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&csi2->lock, flags);
+
+	__mx6csi2_enable(csi2, false);
+
+	mx6csi2_write(csi2, 0x00000001, CSI2_PHY_TST_CTRL0);
+	mx6csi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL1);
+	mx6csi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
+	mx6csi2_write(csi2, 0x00000002, CSI2_PHY_TST_CTRL0);
+	mx6csi2_write(csi2, 0x00010044, CSI2_PHY_TST_CTRL1);
+	mx6csi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
+	mx6csi2_write(csi2, 0x00000014, CSI2_PHY_TST_CTRL1);
+	mx6csi2_write(csi2, 0x00000002, CSI2_PHY_TST_CTRL0);
+	mx6csi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
+
+	__mx6csi2_enable(csi2, true);
+
+	spin_unlock_irqrestore(&csi2->lock, flags);
+}
+
+static int mx6csi2_dphy_wait(struct mx6csi2_dev *csi2)
+{
+	u32 reg;
+	int i;
+
+	/* wait for mipi sensor ready */
+	for (i = 0; i < 50; i++) {
+		reg = mx6csi2_read(csi2, CSI2_PHY_STATE);
+		if (reg != 0x200)
+			break;
+		usleep_range(10000, 10001);
+	}
+
+	if (i >= 50) {
+		v4l2_err(&csi2->sd,
+			"wait for clock lane timeout, phy_state = 0x%08x\n",
+			reg);
+		return -ETIME;
+	}
+
+	/* wait for mipi stable */
+	for (i = 0; i < 50; i++) {
+		reg = mx6csi2_read(csi2, CSI2_ERR1);
+		if (reg == 0x0)
+			break;
+		usleep_range(10000, 10001);
+	}
+
+	if (i >= 50) {
+		v4l2_err(&csi2->sd,
+			"wait for controller timeout, err1 = 0x%08x\n",
+			reg);
+		return -ETIME;
+	}
+
+	v4l2_info(&csi2->sd, "ready, dphy version 0x%x\n",
+		  mx6csi2_read(csi2, CSI2_VERSION));
+	return 0;
+}
+
+/*
+ * V4L2 subdev operations
+ */
+static int mx6csi2_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct mx6csi2_dev *csi2 = sd_to_dev(sd);
+	int ret = 0;
+
+	if (on && !csi2->on) {
+		v4l2_info(&csi2->sd, "power on\n");
+		clk_prepare_enable(csi2->cfg_clk);
+		clk_prepare_enable(csi2->dphy_clk);
+		mx6csi2_set_lanes(csi2);
+		mx6csi2_reset(csi2);
+		ret = mx6csi2_dphy_wait(csi2);
+	} else if (!on && csi2->on) {
+		v4l2_info(&csi2->sd, "power off\n");
+		mx6csi2_enable(csi2, false);
+		clk_disable_unprepare(csi2->dphy_clk);
+		clk_disable_unprepare(csi2->cfg_clk);
+	}
+
+	csi2->on = on;
+	return ret;
+}
+
+static struct v4l2_subdev_core_ops mx6csi2_core_ops = {
+	.s_power = mx6csi2_s_power,
+};
+
+static struct v4l2_subdev_ops mx6csi2_subdev_ops = {
+	.core = &mx6csi2_core_ops,
+};
+
+static int mx6csi2_parse_endpoints(struct mx6csi2_dev *csi2)
+{
+	struct device_node *node = csi2->dev->of_node;
+	struct device_node *epnode;
+	struct v4l2_of_endpoint ep;
+	int ret = 0;
+
+	epnode = of_graph_get_next_endpoint(node, NULL);
+	if (!epnode) {
+		v4l2_err(&csi2->sd, "failed to get endpoint node\n");
+		return -EINVAL;
+	}
+
+	v4l2_of_parse_endpoint(epnode, &ep);
+	if (ep.bus_type != V4L2_MBUS_CSI2) {
+		v4l2_err(&csi2->sd, "invalid bus type, must be MIPI CSI2\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	csi2->bus = ep.bus.mipi_csi2;
+
+	v4l2_info(&csi2->sd, "data lanes: %d\n", csi2->bus.num_data_lanes);
+	v4l2_info(&csi2->sd, "flags: 0x%08x\n", csi2->bus.flags);
+out:
+	of_node_put(epnode);
+	return ret;
+}
+
+static int mx6csi2_probe(struct platform_device *pdev)
+{
+	struct mx6csi2_dev *csi2;
+	struct resource *res;
+	int ret;
+
+	csi2 = devm_kzalloc(&pdev->dev, sizeof(*csi2), GFP_KERNEL);
+	if (!csi2)
+		return -ENOMEM;
+
+	csi2->dev = &pdev->dev;
+	spin_lock_init(&csi2->lock);
+
+	v4l2_subdev_init(&csi2->sd, &mx6csi2_subdev_ops);
+	csi2->sd.owner = THIS_MODULE;
+	strcpy(csi2->sd.name, DEVICE_NAME);
+
+	ret = mx6csi2_parse_endpoints(csi2);
+	if (ret)
+		return ret;
+
+	csi2->cfg_clk = devm_clk_get(&pdev->dev, "cfg_clk");
+	if (IS_ERR(csi2->cfg_clk)) {
+		v4l2_err(&csi2->sd, "failed to get cfg clock\n");
+		ret = PTR_ERR(csi2->cfg_clk);
+		return ret;
+	}
+
+	csi2->dphy_clk = devm_clk_get(&pdev->dev, "dphy_clk");
+	if (IS_ERR(csi2->dphy_clk)) {
+		v4l2_err(&csi2->sd, "failed to get dphy clock\n");
+		ret = PTR_ERR(csi2->dphy_clk);
+		return ret;
+	}
+
+	csi2->intr1 = platform_get_irq(pdev, 0);
+	csi2->intr2 = platform_get_irq(pdev, 1);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!res || csi2->intr1 < 0 || csi2->intr2 < 0) {
+		v4l2_err(&csi2->sd, "failed to get platform resources\n");
+		return -ENODEV;
+	}
+
+	csi2->base = devm_ioremap(&pdev->dev, res->start, PAGE_SIZE);
+	if (!csi2->base) {
+		v4l2_err(&csi2->sd, "failed to map CSI-2 registers\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, &csi2->sd);
+
+	return 0;
+}
+
+static int mx6csi2_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+
+	return mx6csi2_s_power(sd, 0);
+}
+
+static const struct of_device_id mx6csi2_dt_ids[] = {
+	{ .compatible = "fsl,imx6-mipi-csi2", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, mx6csi2_dt_ids);
+
+static struct platform_driver mx6csi2_driver = {
+	.driver = {
+		.name = DEVICE_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = mx6csi2_dt_ids,
+	},
+	.probe = mx6csi2_probe,
+	.remove = mx6csi2_remove,
+};
+
+module_platform_driver(mx6csi2_driver);
+
+MODULE_DESCRIPTION("i.MX6 MIPI CSI-2 Receiver driver");
+MODULE_AUTHOR("Mentor Graphics Inc.");
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/staging/media/imx6/capture/mx6-camif.c b/drivers/staging/media/imx6/capture/mx6-camif.c
new file mode 100644
index 0000000..0c70aa9
--- /dev/null
+++ b/drivers/staging/media/imx6/capture/mx6-camif.c
@@ -0,0 +1,2235 @@
+/*
+ * Video Camera Capture driver for Freescale i.MX6 SOC
+ *
+ * Copyright (c) 2012-2014 Mentor Graphics Inc.
+ * Copyright 2004-2012 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/of_platform.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <linux/platform_data/imx-ipu-v3.h>
+#include <media/imx6.h>
+#include "mx6-camif.h"
+
+/*
+ * Min/Max supported width and heights.
+ */
+#define MIN_W       176
+#define MIN_H       144
+#define MAX_W      4096
+#define MAX_H      4096
+#define MAX_W_IC   1024
+#define MAX_H_IC   1024
+
+#define H_ALIGN    1 /* multiple of 2 */
+#define S_ALIGN    1 /* multiple of 2 */
+
+#define DEVICE_NAME "mx6-camera"
+
+/* In bytes, per queue */
+#define VID_MEM_LIMIT	SZ_64M
+
+static struct vb2_ops mx6cam_qops;
+
+/*
+ * The Gstreamer v4l2src plugin appears to have a bug, it doesn't handle
+ * frame sizes of type V4L2_FRMSIZE_TYPE_STEPWISE correctly. Set this
+ * module param to get around this bug. We can remove once v4l2src handles
+ * stepwise frame sizes correctly.
+ */
+static int v4l2src_compat = 1;
+module_param(v4l2src_compat, int, 0644);
+MODULE_PARM_DESC(v4l2src_compat,
+		 "Gstreamer v4l2src plugin compatibility (default: 1)");
+
+static inline struct mx6cam_dev *sd2dev(struct v4l2_subdev *sd)
+{
+	return container_of(sd->v4l2_dev, struct mx6cam_dev, v4l2_dev);
+}
+
+static inline struct mx6cam_ctx *file2ctx(struct file *file)
+{
+	return container_of(file->private_data, struct mx6cam_ctx, fh);
+}
+
+/* Supported pixel formats */
+static struct mx6cam_pixfmt mx6cam_pixformats[] = {
+	{
+		.name	= "RGB565",
+		.fourcc	= V4L2_PIX_FMT_RGB565,
+		.depth  = 16,
+	}, {
+		.name	= "RGB24",
+		.fourcc	= V4L2_PIX_FMT_RGB24,
+		.depth  = 24,
+	}, {
+		.name	= "BGR24",
+		.fourcc	= V4L2_PIX_FMT_BGR24,
+		.depth  = 24,
+	}, {
+		.name	= "RGB32",
+		.fourcc	= V4L2_PIX_FMT_RGB32,
+		.depth  = 32,
+	}, {
+		.name	= "BGR32",
+		.fourcc	= V4L2_PIX_FMT_BGR32,
+		.depth  = 32,
+	}, {
+		.name	= "4:2:2 packed, YUYV",
+		.fourcc	= V4L2_PIX_FMT_YUYV,
+		.depth  = 16,
+	}, {
+		.name	= "4:2:2 packed, UYVY",
+		.fourcc	= V4L2_PIX_FMT_UYVY,
+		.depth  = 16,
+	}, {
+		.name	= "4:2:0 planar, YUV",
+		.fourcc	= V4L2_PIX_FMT_YUV420,
+		.depth  = 12,
+		.y_depth = 8,
+	}, {
+		.name   = "4:2:0 planar, YVU",
+		.fourcc = V4L2_PIX_FMT_YVU420,
+		.depth  = 12,
+		.y_depth = 8,
+	}, {
+		.name   = "4:2:2 planar, YUV",
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+		.depth  = 16,
+		.y_depth = 8,
+	}, {
+		.name   = "4:2:0 planar, Y/CbCr",
+		.fourcc = V4L2_PIX_FMT_NV12,
+		.depth  = 12,
+		.y_depth = 8,
+	},
+};
+#define NUM_FORMATS ARRAY_SIZE(mx6cam_pixformats)
+
+static struct mx6cam_pixfmt *mx6cam_get_format(u32 fourcc)
+{
+	struct mx6cam_pixfmt *ret = NULL;
+	int i;
+
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (mx6cam_pixformats[i].fourcc == fourcc) {
+			ret = &mx6cam_pixformats[i];
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/* Support functions */
+
+static const char *mx6cam_v4l2_std_to_string(v4l2_std_id std)
+{
+	switch (std) {
+	case V4L2_STD_PAL:
+		return "PAL";
+	case V4L2_STD_PAL_N:
+		return "PAL N";
+	case V4L2_STD_NTSC:
+		return "NTSC";
+	case V4L2_STD_NTSC_443:
+		return "NTSC 4.43";
+	case V4L2_STD_PAL_M:
+		return "PAL M";
+	case V4L2_STD_PAL_60:
+		return "PAL 60";
+	case V4L2_STD_UNKNOWN:
+		return "UNKNOWN";
+	case V4L2_STD_ALL:
+		return "ALL";
+	default:
+		return "Unsupported";
+	}
+}
+
+/* find the endpoint that is handling this input index */
+static struct mx6cam_endpoint *find_ep_by_input_index(struct mx6cam_dev *dev,
+						      int input_idx)
+{
+	struct mx6cam_endpoint *ep;
+	int i;
+
+	for (i = 0; i < dev->num_eps; i++) {
+		ep = &dev->eplist[i];
+		if (!ep->sd)
+			continue;
+
+		if (input_idx >= ep->sensor_input.first &&
+		    input_idx <= ep->sensor_input.last)
+			break;
+	}
+
+	return (i < dev->num_eps) ? ep : NULL;
+}
+
+/*
+ * Query sensor and update signal lock status. Returns true if lock
+ * status has changed.
+ */
+static bool update_signal_lock_status(struct mx6cam_dev *dev)
+{
+	bool locked, changed;
+	u32 status;
+	int ret;
+
+	ret = v4l2_subdev_call(dev->ep->sd, video, g_input_status, &status);
+	if (ret)
+		return false;
+
+	locked = ((status & V4L2_IN_ST_NO_SYNC) == 0);
+	changed = (dev->signal_locked != locked);
+	dev->signal_locked = locked;
+
+	return changed;
+}
+
+/*
+ * Return true if the current capture parameters require the use of
+ * the Image Converter. We need the IC for scaling, colorspace conversion,
+ * preview, and rotation.
+ */
+static bool need_ic(struct mx6cam_dev *dev,
+		    struct v4l2_mbus_framefmt *sf,
+		    struct v4l2_format *uf,
+		    struct v4l2_rect *crop)
+{
+	struct v4l2_pix_format *user_fmt = &uf->fmt.pix;
+	enum ipu_color_space sensor_cs, user_cs;
+	bool ret;
+
+	sensor_cs = ipu_mbus_code_to_colorspace(sf->code);
+	user_cs = ipu_pixelformat_to_colorspace(user_fmt->pixelformat);
+
+	ret = (user_fmt->width != crop->width ||
+	       user_fmt->height != crop->height ||
+	       user_cs != sensor_cs ||
+	       dev->preview_on ||
+	       dev->rot_mode != IPU_ROTATE_NONE);
+
+	return ret;
+}
+
+/*
+ * Return true if user and sensor formats currently meet the IC
+ * restrictions:
+ *     o the parallel CSI bus cannot be 16-bit wide.
+ *     o the endpoint id must be 0 (for MIPI CSI2, the endpoint id is the
+ *       virtual channel number, and only VC0 can pass through the IC).
+ *     o the resizer output size must be at or below 1024x1024.
+ */
+static bool can_use_ic(struct mx6cam_dev *dev,
+		       struct v4l2_mbus_framefmt *sf,
+		       struct v4l2_format *uf)
+{
+	struct mx6cam_endpoint *ep = dev->ep;
+	struct ipu_csi_signal_cfg csicfg;
+
+	ipu_csi_mbus_fmt_to_sig_cfg(&csicfg, sf->code);
+
+	return ((ep->ep.bus_type == V4L2_MBUS_CSI2 ||
+		 csicfg.data_width != IPU_CSI_DATA_WIDTH_16) &&
+		ep->ep.base.id == 0 &&
+		uf->fmt.pix.width <= MAX_W_IC &&
+		uf->fmt.pix.height <= MAX_H_IC);
+}
+
+/*
+ * Adjusts passed width and height to meet IC resizer limits.
+ */
+static void adjust_to_resizer_limits(struct mx6cam_dev *dev,
+				     struct v4l2_format *uf,
+				     struct v4l2_rect *crop)
+{
+	u32 *width, *height;
+
+	if (uf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		width = &uf->fmt.pix.width;
+		height = &uf->fmt.pix.height;
+	} else {
+		width = &uf->fmt.win.w.width;
+		height = &uf->fmt.win.w.height;
+	}
+
+	/* output of resizer can't be above 1024x1024 */
+	*width = min_t(__u32, *width, MAX_W_IC);
+	*height = min_t(__u32, *height, MAX_H_IC);
+
+	/* resizer cannot downsize more than 8:1 */
+	if (dev->rot_mode >= IPU_ROTATE_90_RIGHT) {
+		*height = max_t(__u32, *height, crop->width / 8);
+		*width = max_t(__u32, *width, crop->height / 8);
+	} else {
+		*width = max_t(__u32, *width, crop->width / 8);
+		*height = max_t(__u32, *height, crop->height / 8);
+	}
+}
+
+static void adjust_user_fmt(struct mx6cam_dev *dev,
+			    struct v4l2_mbus_framefmt *sf,
+			    struct v4l2_format *uf,
+			    struct v4l2_rect *crop)
+{
+	/*
+	 * Make sure resolution is within IC resizer limits
+	 * if we need the Image Converter.
+	 */
+	if (need_ic(dev, sf, uf, crop))
+		adjust_to_resizer_limits(dev, uf, crop);
+
+	/*
+	 * Force the resolution to match crop window if
+	 * we can't use the Image Converter.
+	 */
+	if (!can_use_ic(dev, sf, uf)) {
+		uf->fmt.pix.width = crop->width;
+		uf->fmt.pix.height = crop->height;
+	}
+
+	uf->fmt.pix.bytesperline =
+		(uf->fmt.pix.width *
+		 ipu_bits_per_pixel(uf->fmt.pix.pixelformat)) >> 3;
+	uf->fmt.pix.sizeimage = uf->fmt.pix.height * uf->fmt.pix.bytesperline;
+}
+
+/*
+ * Calculate what the default active crop window should be. Ask
+ * the sensor via g_crop. This crop window will be stored to dev->crop.
+ */
+static void calc_default_crop(struct mx6cam_dev *dev,
+			      struct v4l2_rect *rect,
+			      struct v4l2_mbus_framefmt *sf)
+{
+	struct v4l2_crop crop;
+	int ret;
+
+	crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ret = v4l2_subdev_call(dev->ep->sd, video, g_crop, &crop);
+	if (ret) {
+		/* sensor doesn't support .g_crop(), assume sensor frame */
+		rect->top = rect->left = 0;
+		rect->width = sf->width;
+		rect->height = sf->height;
+	} else
+		*rect = crop.c;
+
+	/* adjust crop window to h/w alignment restrictions */
+	rect->width &= ~0x7;
+	rect->left &= ~0x3;
+}
+
+/*
+ * Use the parsed endpoint info and sensor format to fill
+ * ipu_csi_signal_cfg.
+ */
+static void fill_csi_signal_cfg(struct mx6cam_dev *dev)
+{
+	struct ipu_csi_signal_cfg *csicfg = &dev->ep->csi_sig_cfg;
+	struct v4l2_of_endpoint *ep = &dev->ep->ep;
+
+	memset(csicfg, 0, sizeof(*csicfg));
+
+	ipu_csi_mbus_fmt_to_sig_cfg(csicfg, dev->sensor_fmt.code);
+
+	switch (ep->bus_type) {
+	case V4L2_MBUS_PARALLEL:
+		csicfg->ext_vsync = 0;
+		csicfg->vsync_pol = (ep->bus.parallel.flags &
+				     V4L2_MBUS_VSYNC_ACTIVE_LOW) ? 1 : 0;
+		csicfg->hsync_pol = (ep->bus.parallel.flags &
+				     V4L2_MBUS_HSYNC_ACTIVE_LOW) ? 1 : 0;
+		csicfg->pixclk_pol = (ep->bus.parallel.flags &
+				      V4L2_MBUS_PCLK_SAMPLE_FALLING) ? 1 : 0;
+		csicfg->clk_mode = IPU_CSI_CLK_MODE_GATED_CLK;
+		break;
+	case V4L2_MBUS_BT656:
+		csicfg->ext_vsync = 1;
+		if (dev->sensor_fmt.field == V4L2_FIELD_INTERLACED)
+			csicfg->clk_mode = IPU_CSI_CLK_MODE_CCIR656_INTERLACED;
+		else
+			csicfg->clk_mode = IPU_CSI_CLK_MODE_CCIR656_PROGRESSIVE;
+		break;
+	case V4L2_MBUS_CSI2:
+		/*
+		 * MIPI CSI-2 requires non gated clock mode, all other
+		 * parameters are not applicable for MIPI CSI-2 bus.
+		 */
+		csicfg->clk_mode = IPU_CSI_CLK_MODE_NONGATED_CLK;
+		break;
+	default:
+		/* will never get here, keep compiler quiet */
+		break;
+	}
+}
+
+static int update_sensor_std(struct mx6cam_dev *dev)
+{
+	return v4l2_subdev_call(dev->ep->sd, video, querystd,
+				&dev->current_std);
+}
+
+static int update_sensor_fmt(struct mx6cam_dev *dev)
+{
+	int ret;
+
+	ret = v4l2_subdev_call(dev->ep->sd, video, g_mbus_fmt,
+			       &dev->sensor_fmt);
+	if (ret)
+		return ret;
+
+	fill_csi_signal_cfg(dev);
+
+	/* update sensor crop bounds */
+	dev->crop_bounds.top = dev->crop_bounds.left = 0;
+	dev->crop_bounds.width = dev->sensor_fmt.width;
+	dev->crop_bounds.height = dev->sensor_fmt.height;
+	dev->crop_defrect = dev->crop_bounds;
+
+	return 0;
+}
+
+/*
+ * Turn current sensor power on/off according to power_count.
+ */
+static int sensor_set_power(struct mx6cam_dev *dev, int on)
+{
+	struct mx6cam_endpoint *ep = dev->ep;
+	struct v4l2_subdev *sd = ep->sd;
+	int ret;
+
+	if (on && ep->power_count++ > 0)
+		return 0;
+	else if (!on && (ep->power_count == 0 || --ep->power_count > 0))
+		return 0;
+
+	ret = v4l2_subdev_call(sd, core, s_power, on);
+	return ret != -ENOIOCTLCMD ? ret : 0;
+}
+
+/*
+ * Turn current sensor streaming on/off according to stream_count.
+ */
+static int sensor_set_stream(struct mx6cam_dev *dev, int on)
+{
+	struct mx6cam_endpoint *ep = dev->ep;
+	struct v4l2_subdev *sd = ep->sd;
+	int ret;
+
+	if (on && ep->stream_count++ > 0)
+		return 0;
+	else if (!on && (ep->stream_count == 0 || --ep->stream_count > 0))
+		return 0;
+
+	ret = v4l2_subdev_call(sd, video, s_stream, on);
+	return ret != -ENOIOCTLCMD ? ret : 0;
+}
+
+/*
+ * Start the encoder for buffer streaming. There must be at least two
+ * frames in the vb2 queue.
+ */
+static int start_encoder(struct mx6cam_dev *dev)
+{
+	int ret;
+
+	if (dev->encoder_on)
+		return 0;
+
+	/* sensor stream on */
+	ret = sensor_set_stream(dev, 1);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "sensor stream on failed\n");
+		return ret;
+	}
+
+	/* encoder stream on */
+	ret = v4l2_subdev_call(dev->encoder_sd, video, s_stream, 1);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "encoder stream on failed\n");
+		return ret;
+	}
+
+	dev->encoder_on = true;
+	return 0;
+}
+
+/*
+ * Stop the encoder.
+ */
+static int stop_encoder(struct mx6cam_dev *dev)
+{
+	int ret;
+
+	if (!dev->encoder_on)
+		return 0;
+
+	/* encoder off */
+	ret = v4l2_subdev_call(dev->encoder_sd, video, s_stream, 0);
+	if (ret)
+		v4l2_err(&dev->v4l2_dev, "encoder stream off failed\n");
+
+	/* sensor stream off */
+	ret = sensor_set_stream(dev, 0);
+	if (ret)
+		v4l2_err(&dev->v4l2_dev, "sensor stream off failed\n");
+
+	dev->encoder_on = false;
+	return ret;
+}
+
+/*
+ * Start preview.
+ */
+static int start_preview(struct mx6cam_dev *dev)
+{
+	int ret;
+
+	if (atomic_read(&dev->status_change)) {
+		update_signal_lock_status(dev);
+		update_sensor_std(dev);
+		update_sensor_fmt(dev);
+		/* reset active crop window */
+		calc_default_crop(dev, &dev->crop, &dev->sensor_fmt);
+		atomic_set(&dev->status_change, 0);
+		v4l2_info(&dev->v4l2_dev, "at preview on: %s, %s\n",
+			  mx6cam_v4l2_std_to_string(dev->current_std),
+			  dev->signal_locked ? "signal locked" : "no signal");
+	}
+
+	/* sensor stream on */
+	ret = sensor_set_stream(dev, 1);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "sensor stream on failed\n");
+		return ret;
+	}
+
+	/* preview stream on */
+	ret = v4l2_subdev_call(dev->preview_sd, video, s_stream, 1);
+	if (ret)
+		v4l2_err(&dev->v4l2_dev, "preview stream on failed\n");
+
+	return ret;
+}
+
+/*
+ * Stop preview.
+ */
+static int stop_preview(struct mx6cam_dev *dev)
+{
+	int ret;
+
+	/* preview stream off */
+	ret = v4l2_subdev_call(dev->preview_sd, video, s_stream, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "preview stream off failed\n");
+		return ret;
+	}
+
+	/* sensor stream off */
+	ret = sensor_set_stream(dev, 0);
+	if (ret)
+		v4l2_err(&dev->v4l2_dev, "sensor stream off failed\n");
+
+	return ret;
+}
+
+/*
+ * Start/Stop streaming.
+ */
+static int set_stream(struct mx6cam_ctx *ctx, bool on)
+{
+	struct mx6cam_dev *dev = ctx->dev;
+	int ret = 0;
+
+	if (on) {
+		if (atomic_read(&dev->status_change)) {
+			update_signal_lock_status(dev);
+			update_sensor_std(dev);
+			update_sensor_fmt(dev);
+			/* reset active crop window */
+			calc_default_crop(dev, &dev->crop, &dev->sensor_fmt);
+			atomic_set(&dev->status_change, 0);
+			v4l2_info(&dev->v4l2_dev, "at stream on: %s, %s\n",
+				  mx6cam_v4l2_std_to_string(dev->current_std),
+				  dev->signal_locked ?
+				  "signal locked" : "no signal");
+		}
+
+		dev->using_ic =
+			(need_ic(dev, &dev->sensor_fmt, &dev->user_fmt,
+				 &dev->crop) &&
+			 can_use_ic(dev, &dev->sensor_fmt, &dev->user_fmt));
+
+		if (dev->preview_on)
+			stop_preview(dev);
+
+		/*
+		 * If there are two or more frames in the queue, we can start
+		 * the encoder now. Otherwise the encoding will start once
+		 * two frames have been queued.
+		 */
+		if (!list_empty(&ctx->ready_q) &&
+		    !list_is_singular(&ctx->ready_q))
+			ret = start_encoder(dev);
+
+		if (dev->preview_on)
+			start_preview(dev);
+	} else {
+		ret = stop_encoder(dev);
+	}
+
+	return ret;
+}
+
+/*
+ * Restart work handler. This is called in three cases during active
+ * streaming and/or preview:
+ *
+ * o NFB4EOF errors
+ * o A decoder's signal lock status or autodetected video standard changes
+ * o End-of-Frame timeouts
+ */
+static void restart_work_handler(struct work_struct *w)
+{
+	struct mx6cam_ctx *ctx = container_of(w, struct mx6cam_ctx,
+					      restart_work);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	mutex_lock(&dev->mutex);
+
+	if (!vb2_is_streaming(&dev->buffer_queue)) {
+		/* just restart preview if on */
+		if (dev->preview_on) {
+			v4l2_warn(&dev->v4l2_dev, "restarting preview\n");
+			stop_preview(dev);
+			start_preview(dev);
+		}
+		goto out_unlock;
+	}
+
+	v4l2_warn(&dev->v4l2_dev, "restarting\n");
+
+	set_stream(ctx, false);
+	set_stream(ctx, true);
+
+out_unlock:
+	mutex_unlock(&dev->mutex);
+}
+
+/*
+ * Stop work handler. Not currently needed but keep around.
+ */
+static void stop_work_handler(struct work_struct *w)
+{
+	struct mx6cam_ctx *ctx = container_of(w, struct mx6cam_ctx,
+					      stop_work);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	mutex_lock(&dev->mutex);
+
+	if (dev->preview_on) {
+		v4l2_err(&dev->v4l2_dev, "stopping preview\n");
+		stop_preview(dev);
+		dev->preview_on = false;
+	}
+
+	if (vb2_is_streaming(&dev->buffer_queue)) {
+		v4l2_err(&dev->v4l2_dev, "stopping\n");
+		vb2_streamoff(&dev->buffer_queue, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	}
+
+	mutex_unlock(&dev->mutex);
+}
+
+/*
+ * Restart timer function. Schedules a restart.
+ */
+static void mx6cam_restart_timeout(unsigned long data)
+{
+	struct mx6cam_ctx *ctx = (struct mx6cam_ctx *)data;
+
+	schedule_work(&ctx->restart_work);
+}
+
+/* Controls */
+static int mx6cam_set_rotation(struct mx6cam_dev *dev,
+			       int rotation, bool hflip, bool vflip)
+{
+	enum ipu_rotate_mode rot_mode;
+	int ret;
+
+	ret = ipu_degrees_to_rot_mode(&rot_mode, rotation,
+				      hflip, vflip);
+	if (ret)
+		return ret;
+
+	if (rot_mode != dev->rot_mode) {
+		/* can't change rotation mid-streaming */
+		if (vb2_is_streaming(&dev->buffer_queue)) {
+			v4l2_err(&dev->v4l2_dev,
+				 "%s: not allowed while streaming\n",
+				 __func__);
+			return -EBUSY;
+		}
+
+		if (rot_mode != IPU_ROTATE_NONE &&
+		    !can_use_ic(dev, &dev->sensor_fmt, &dev->user_fmt)) {
+			v4l2_err(&dev->v4l2_dev,
+				"%s: current format does not allow rotation\n",
+				 __func__);
+			return -EINVAL;
+		}
+	}
+
+	dev->rot_mode = rot_mode;
+	dev->rotation = rotation;
+	dev->hflip = hflip;
+	dev->vflip = vflip;
+
+	return 0;
+}
+
+static int mx6cam_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct mx6cam_dev *dev = container_of(ctrl->handler,
+					      struct mx6cam_dev, ctrl_hdlr);
+	bool hflip, vflip;
+	int rotation;
+
+	rotation = dev->rotation;
+	hflip = dev->hflip;
+	vflip = dev->vflip;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		hflip = (ctrl->val == 1);
+		break;
+	case V4L2_CID_VFLIP:
+		vflip = (ctrl->val == 1);
+		break;
+	case V4L2_CID_ROTATE:
+		rotation = ctrl->val;
+		break;
+	default:
+		v4l2_err(&dev->v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+
+	return mx6cam_set_rotation(dev, rotation, hflip, vflip);
+}
+
+static const struct v4l2_ctrl_ops mx6cam_ctrl_ops = {
+	.s_ctrl = mx6cam_s_ctrl,
+};
+
+static int mx6cam_init_controls(struct mx6cam_dev *dev)
+{
+	struct v4l2_ctrl_handler *hdlr = &dev->ctrl_hdlr;
+	int ret;
+
+	v4l2_ctrl_handler_init(hdlr, 3);
+
+	v4l2_ctrl_new_std(hdlr, &mx6cam_ctrl_ops, V4L2_CID_HFLIP,
+			  0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdlr, &mx6cam_ctrl_ops, V4L2_CID_VFLIP,
+			  0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdlr, &mx6cam_ctrl_ops, V4L2_CID_ROTATE,
+			  0, 270, 90, 0);
+
+	if (hdlr->error) {
+		ret = hdlr->error;
+		v4l2_ctrl_handler_free(hdlr);
+		return ret;
+	}
+
+	dev->v4l2_dev.ctrl_handler = hdlr;
+	dev->vfd->ctrl_handler = hdlr;
+
+	v4l2_ctrl_handler_setup(hdlr);
+
+	return 0;
+}
+
+
+/*
+ * Video ioctls follow
+ */
+
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, DEVICE_NAME, sizeof(cap->driver) - 1);
+	strncpy(cap->card, DEVICE_NAME, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OVERLAY;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	struct mx6cam_pixfmt *fmt;
+
+	if (f->index >= NUM_FORMATS)
+		return -EINVAL;
+
+	fmt = &mx6cam_pixformats[f->index];
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_overlay(struct file *file, void *priv,
+				       struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt_vid_cap(file, priv, f);
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	f->fmt.pix = dev->user_fmt.fmt.pix;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_overlay(struct file *file, void *priv,
+				    struct v4l2_format *f)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	f->fmt.win = dev->win;
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct v4l2_mbus_framefmt mbus_fmt;
+	struct mx6cam_pixfmt *fmt;
+	unsigned int width_align;
+	struct v4l2_rect crop;
+	int ret;
+
+	fmt = mx6cam_get_format(f->fmt.pix.pixelformat);
+	if (!fmt) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	/*
+	 * We have to adjust the width such that the physaddrs and U and
+	 * U and V plane offsets are multiples of 8 bytes as required by
+	 * the IPU DMA Controller. For the planar formats, this corresponds
+	 * to a pixel alignment of 16. For all the packed formats, 8 is
+	 * good enough.
+	 */
+	width_align = ipu_pixelformat_is_planar(fmt->fourcc) ? 4 : 3;
+
+	v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W,
+			      width_align, &f->fmt.pix.height,
+			      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
+
+	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, 0);
+	ret = v4l2_subdev_call(dev->ep->sd, video, try_mbus_fmt, &mbus_fmt);
+	if (ret)
+		return ret;
+
+	/*
+	 * calculate what the optimal crop window will be for this
+	 * sensor format and make any user format adjustments.
+	 */
+	calc_default_crop(dev, &crop, &mbus_fmt);
+	adjust_user_fmt(dev, &mbus_fmt, f, &crop);
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_overlay(struct file *file, void *priv,
+				      struct v4l2_format *f)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct v4l2_window *win = &f->fmt.win;
+	unsigned int width_align;
+
+	width_align = ipu_pixelformat_is_planar(dev->fbuf.fmt.pixelformat) ?
+		4 : 3;
+
+	v4l_bound_align_image(&win->w.width, MIN_W, MAX_W_IC,
+			      width_align, &win->w.height,
+			      MIN_H, MAX_H_IC, H_ALIGN, S_ALIGN);
+
+	adjust_to_resizer_limits(dev, f, &dev->crop);
+
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct v4l2_mbus_framefmt mbus_fmt;
+	int ret;
+
+	if (vb2_is_busy(&dev->buffer_queue)) {
+		v4l2_err(&dev->v4l2_dev, "%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
+	ret = vidioc_try_fmt_vid_cap(file, priv, f);
+	if (ret)
+		return ret;
+
+	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, 0);
+	ret = v4l2_subdev_call(dev->ep->sd, video, s_mbus_fmt, &mbus_fmt);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "%s s_mbus_fmt failed\n", __func__);
+		return ret;
+	}
+
+	ret = update_sensor_fmt(dev);
+	if (ret)
+		return ret;
+
+	/* reset active crop window */
+	calc_default_crop(dev, &dev->crop, &dev->sensor_fmt);
+
+	dev->user_fmt = *f;
+
+	return 0;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *priv,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct mx6cam_pixfmt *fmt;
+	struct v4l2_format uf;
+	int ret = 0;
+
+	fmt = mx6cam_get_format(fsize->pixel_format);
+	if (!fmt)
+		return -EINVAL;
+
+	if (!v4l2src_compat) {
+		if (fsize->index)
+			return -EINVAL;
+
+		fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+		fsize->stepwise.min_width = MIN_W;
+		fsize->stepwise.step_width =
+			ipu_pixelformat_is_planar(fmt->fourcc) ? 16 : 8;
+		fsize->stepwise.min_height = MIN_H;
+		fsize->stepwise.step_height = 1 << H_ALIGN;
+
+		uf = dev->user_fmt;
+		uf.fmt.pix.pixelformat = fmt->fourcc;
+
+		if (need_ic(dev, &dev->sensor_fmt, &uf, &dev->crop)) {
+			fsize->stepwise.max_width = MAX_W_IC;
+			fsize->stepwise.max_height = MAX_H_IC;
+		} else {
+			fsize->stepwise.max_width = MAX_W;
+			fsize->stepwise.max_height = MAX_H;
+		}
+	} else {
+		ret = v4l2_subdev_call(dev->ep->sd, video,
+				       enum_framesizes, fsize);
+	}
+
+	return ret;
+}
+
+static int vidioc_enum_frameintervals(struct file *file, void *priv,
+				      struct v4l2_frmivalenum *fival)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct mx6cam_pixfmt *fmt;
+
+	fmt = mx6cam_get_format(fival->pixel_format);
+	if (!fmt)
+		return -EINVAL;
+
+	return v4l2_subdev_call(dev->ep->sd, video, enum_frameintervals, fival);
+}
+
+static int vidioc_s_fmt_vid_overlay(struct file *file, void *priv,
+				    struct v4l2_format *f)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct v4l2_window *win = &f->fmt.win;
+	int ret;
+
+	ret = vidioc_try_fmt_vid_overlay(file, priv, f);
+	if (ret)
+		return ret;
+
+	if (dev->preview_on)
+		stop_preview(dev);
+
+	dev->win = *win;
+
+	if (dev->preview_on)
+		start_preview(dev);
+
+	return 0;
+}
+
+static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	int ret;
+
+	ret = update_sensor_std(dev);
+	if (!ret)
+		*std = dev->current_std;
+	return ret;
+}
+
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	*std = dev->current_std;
+	return 0;
+}
+
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id std)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	int ret;
+
+	if (vb2_is_busy(&dev->buffer_queue))
+		return -EBUSY;
+
+	ret = v4l2_subdev_call(dev->ep->sd, video, s_std, std);
+	if (ret < 0)
+		return ret;
+
+	dev->current_std = std;
+	return 0;
+}
+
+static int vidioc_enum_input(struct file *file, void *priv,
+			     struct v4l2_input *input)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct mx6cam_sensor_input *epinput;
+	struct mx6cam_endpoint *ep;
+	int sensor_input;
+
+	/* find the endpoint that is handling this input */
+	ep = find_ep_by_input_index(dev, input->index);
+	if (!ep)
+		return -EINVAL;
+
+	epinput = &ep->sensor_input;
+	sensor_input = input->index - epinput->first;
+
+	input->type = V4L2_INPUT_TYPE_CAMERA;
+	input->capabilities = epinput->caps[sensor_input];
+	strncpy(input->name, epinput->name[sensor_input], sizeof(input->name));
+
+	if (input->index == dev->current_input) {
+		v4l2_subdev_call(ep->sd, video, g_input_status, &input->status);
+		update_sensor_std(dev);
+		input->std = dev->current_std;
+	} else {
+		input->status = V4L2_IN_ST_NO_SIGNAL;
+		input->std = V4L2_STD_UNKNOWN;
+	}
+
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *index)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	*index = dev->current_input;
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct mx6cam_sensor_input *epinput;
+	struct mx6cam_endpoint *ep;
+	int ret, sensor_input;
+
+	if (index == dev->current_input)
+		return 0;
+
+	/* find the endpoint that is handling this input */
+	ep = find_ep_by_input_index(dev, index);
+	if (!ep)
+		return -EINVAL;
+
+	if (dev->ep != ep) {
+		/*
+		 * don't allow switching sensors if there are queued buffers,
+		 * preview is on, or there are other users of the current
+		 * sensor besides us.
+		 */
+		if (vb2_is_busy(&dev->buffer_queue) || dev->preview_on ||
+		    dev->ep->power_count > 1)
+			return -EBUSY;
+
+		v4l2_info(&dev->v4l2_dev, "switching to sensor %s\n",
+			  ep->sd->name);
+
+		/* power down current sensor before enabling new one */
+		ret = sensor_set_power(dev, 0);
+		if (ret)
+			v4l2_warn(&dev->v4l2_dev, "sensor power off failed\n");
+
+		/* set new endpoint */
+		dev->ep = ep;
+
+		/* power-on the new sensor */
+		ret = sensor_set_power(dev, 1);
+		if (ret)
+			v4l2_warn(&dev->v4l2_dev, "sensor power on failed\n");
+
+		/* power-on the csi2 receiver */
+		if (dev->ep->ep.bus_type == V4L2_MBUS_CSI2 && dev->csi2_sd) {
+			ret = v4l2_subdev_call(dev->csi2_sd, core, s_power,
+					       true);
+			if (ret)
+				v4l2_err(&dev->v4l2_dev,
+					 "csi2 power on failed\n");
+		}
+	}
+
+	/* finally select the sensor's input */
+	epinput = &ep->sensor_input;
+	sensor_input = index - epinput->first;
+	ret = v4l2_subdev_call(dev->ep->sd, video, s_routing,
+			       epinput->value[sensor_input], 0, 0);
+
+	dev->current_input = index;
+
+	/*
+	 * sometimes on switching video input on video decoder devices
+	 * no lock status change event is generated, but vertical sync
+	 * is messed up nevertheless. So schedule a restart to correct it.
+	 */
+	if (ctx->io_allowed)
+		mod_timer(&ctx->restart_timer,
+			  jiffies + msecs_to_jiffies(MX6CAM_RESTART_DELAY));
+
+	return 0;
+}
+
+static int vidioc_g_parm(struct file *file, void *fh,
+			 struct v4l2_streamparm *a)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	return v4l2_subdev_call(dev->ep->sd, video, g_parm, a);
+}
+
+static int vidioc_s_parm(struct file *file, void *fh,
+			 struct v4l2_streamparm *a)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	return v4l2_subdev_call(dev->ep->sd, video, s_parm, a);
+}
+
+static int vidioc_cropcap(struct file *file, void *priv,
+			  struct v4l2_cropcap *cropcap)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    cropcap->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
+		return -EINVAL;
+
+	cropcap->bounds = dev->crop_bounds;
+	cropcap->defrect = dev->crop_defrect;
+	cropcap->pixelaspect.numerator = 1;
+	cropcap->pixelaspect.denominator = 1;
+	return 0;
+}
+
+static int vidioc_g_crop(struct file *file, void *priv,
+			 struct v4l2_crop *crop)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    crop->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
+		return -EINVAL;
+
+	crop->c = dev->crop;
+	return 0;
+}
+
+static int vidioc_s_crop(struct file *file, void *priv,
+			 const struct v4l2_crop *crop)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct v4l2_rect *bounds = &dev->crop_bounds;
+
+	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    crop->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
+		return -EINVAL;
+
+	if (vb2_is_busy(&dev->buffer_queue))
+		return -EBUSY;
+
+	/* make sure crop window is within bounds */
+	if (crop->c.top < 0 || crop->c.left < 0 ||
+	    crop->c.left + crop->c.width > bounds->width ||
+	    crop->c.top + crop->c.height > bounds->height)
+		return -EINVAL;
+
+	/*
+	 * FIXME: the IPU currently does not setup the CCIR code
+	 * registers properly to handle arbitrary crop windows. So
+	 * ignore this request if the sensor bus is BT.656.
+	 */
+	if (dev->ep->ep.bus_type == V4L2_MBUS_BT656)
+		return 0;
+
+	dev->crop = crop->c;
+
+	/* adjust crop window to h/w alignment restrictions */
+	dev->crop.width &= ~0x7;
+	dev->crop.left &= ~0x3;
+
+	/*
+	 * Crop window has changed, we need to adjust the user
+	 * width/height to meet new IC resizer restrictions or to
+	 * match the new crop window if the IC can't be used.
+	 */
+	adjust_user_fmt(dev, &dev->sensor_fmt, &dev->user_fmt,
+			&dev->crop);
+
+	return 0;
+}
+
+static int vidioc_s_fbuf(struct file *file, void *priv,
+			 const struct v4l2_framebuffer *fbuf)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct mx6cam_pixfmt *fmt;
+
+	if (fbuf->flags != V4L2_FBUF_FLAG_OVERLAY || !fbuf->base)
+		return -EINVAL;
+
+	fmt = mx6cam_get_format(fbuf->fmt.pixelformat);
+	if (!fmt) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 fbuf->fmt.pixelformat);
+		return -EINVAL;
+	}
+
+	if (dev->preview_on)
+		stop_preview(dev);
+
+	dev->fbuf = *fbuf;
+
+	if (dev->preview_on)
+		start_preview(dev);
+
+	return 0;
+}
+
+static int vidioc_g_fbuf(struct file *file, void *priv,
+			 struct v4l2_framebuffer *fbuf)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	*fbuf = dev->fbuf;
+
+	return 0;
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct vb2_queue *vq = &dev->buffer_queue;
+	int ret;
+
+	if (vb2_is_busy(vq))
+		return -EBUSY;
+
+	ctx->alloc_ctx = vb2_dma_contig_init_ctx(dev->dev);
+	if (IS_ERR(ctx->alloc_ctx)) {
+		v4l2_err(&dev->v4l2_dev, "failed to alloc vb2 context\n");
+		return PTR_ERR(ctx->alloc_ctx);
+	}
+
+	INIT_LIST_HEAD(&ctx->ready_q);
+	INIT_WORK(&ctx->restart_work, restart_work_handler);
+	INIT_WORK(&ctx->stop_work, stop_work_handler);
+	init_timer(&ctx->restart_timer);
+	ctx->restart_timer.data = (unsigned long)ctx;
+	ctx->restart_timer.function = mx6cam_restart_timeout;
+
+	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	vq->drv_priv = ctx;
+	vq->buf_struct_size = sizeof(struct mx6cam_buffer);
+	vq->ops = &mx6cam_qops;
+	vq->mem_ops = &vb2_dma_contig_memops;
+	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	ret = vb2_queue_init(vq);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "vb2_queue_init failed\n");
+		goto alloc_ctx_free;
+	}
+
+	ctx->io_allowed = true;
+	dev->io_ctx = ctx;
+
+	return vb2_reqbufs(vq, reqbufs);
+
+alloc_ctx_free:
+	vb2_dma_contig_cleanup_ctx(ctx->alloc_ctx);
+	return ret;
+}
+
+static int vidioc_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	return vb2_querybuf(vq, buf);
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	if (!ctx->io_allowed)
+		return -EBUSY;
+
+	return vb2_qbuf(vq, buf);
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	if (!ctx->io_allowed)
+		return -EBUSY;
+
+	return vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+}
+
+static int vidioc_expbuf(struct file *file, void *priv,
+			 struct v4l2_exportbuffer *eb)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	if (!ctx->io_allowed)
+		return -EBUSY;
+
+	return vb2_expbuf(vq, eb);
+}
+
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	if (!ctx->io_allowed)
+		return -EBUSY;
+
+	return vb2_streamon(vq, type);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	if (!ctx->io_allowed)
+		return -EBUSY;
+
+	return vb2_streamoff(vq, type);
+}
+
+static int vidioc_overlay(struct file *file, void *priv,
+			  unsigned int enable)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	int ret = 0;
+
+	if (!ctx->io_allowed)
+		return -EBUSY;
+
+	if (enable && !dev->preview_on) {
+		if (vb2_is_streaming(&dev->buffer_queue) && !dev->using_ic) {
+			v4l2_err(&dev->v4l2_dev,
+				 "%s: not allowed while streaming w/o IC\n",
+				 __func__);
+			return -EBUSY;
+		}
+
+		if (!can_use_ic(dev, &dev->sensor_fmt, &dev->user_fmt)) {
+			v4l2_err(&dev->v4l2_dev,
+				 "%s: current format does not allow preview\n",
+				 __func__);
+			return -EINVAL;
+		}
+
+		ret = start_preview(dev);
+		if (!ret)
+			dev->preview_on = true;
+	} else if (!enable && dev->preview_on) {
+		ret = stop_preview(dev);
+		dev->preview_on = false;
+	}
+
+	return ret;
+}
+
+static const struct v4l2_ioctl_ops mx6cam_ioctl_ops = {
+	.vidioc_querycap	= vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap        = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap           = vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap         = vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap           = vidioc_s_fmt_vid_cap,
+
+	.vidioc_enum_framesizes         = vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals     = vidioc_enum_frameintervals,
+
+	.vidioc_enum_fmt_vid_overlay    = vidioc_enum_fmt_vid_overlay,
+	.vidioc_g_fmt_vid_overlay	= vidioc_g_fmt_vid_overlay,
+	.vidioc_try_fmt_vid_overlay	= vidioc_try_fmt_vid_overlay,
+	.vidioc_s_fmt_vid_overlay	= vidioc_s_fmt_vid_overlay,
+
+	.vidioc_querystd        = vidioc_querystd,
+	.vidioc_g_std           = vidioc_g_std,
+	.vidioc_s_std           = vidioc_s_std,
+
+	.vidioc_enum_input      = vidioc_enum_input,
+	.vidioc_g_input         = vidioc_g_input,
+	.vidioc_s_input         = vidioc_s_input,
+
+	.vidioc_g_parm          = vidioc_g_parm,
+	.vidioc_s_parm          = vidioc_s_parm,
+
+	.vidioc_g_fbuf          = vidioc_g_fbuf,
+	.vidioc_s_fbuf          = vidioc_s_fbuf,
+
+	.vidioc_cropcap         = vidioc_cropcap,
+	.vidioc_g_crop          = vidioc_g_crop,
+	.vidioc_s_crop          = vidioc_s_crop,
+
+	.vidioc_reqbufs		= vidioc_reqbufs,
+	.vidioc_querybuf	= vidioc_querybuf,
+	.vidioc_qbuf		= vidioc_qbuf,
+	.vidioc_dqbuf		= vidioc_dqbuf,
+	.vidioc_expbuf		= vidioc_expbuf,
+
+	.vidioc_streamon	= vidioc_streamon,
+	.vidioc_streamoff	= vidioc_streamoff,
+	.vidioc_overlay         = vidioc_overlay,
+};
+
+
+/*
+ * Queue operations
+ */
+
+static int mx6cam_queue_setup(struct vb2_queue *vq,
+			      const struct v4l2_format *fmt,
+			      unsigned int *nbuffers, unsigned int *nplanes,
+			      unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct mx6cam_ctx *ctx = vb2_get_drv_priv(vq);
+	struct mx6cam_dev *dev = ctx->dev;
+	unsigned int count = *nbuffers;
+	u32 sizeimage = dev->user_fmt.fmt.pix.sizeimage;
+
+	if (vq->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	while (sizeimage * count > VID_MEM_LIMIT)
+		count--;
+
+	*nplanes = 1;
+	*nbuffers = count;
+	sizes[0] = sizeimage;
+
+	alloc_ctxs[0] = ctx->alloc_ctx;
+
+	dprintk(dev, "get %d buffer(s) of size %d each.\n", count, sizeimage);
+
+	return 0;
+}
+
+static int mx6cam_buf_init(struct vb2_buffer *vb)
+{
+	struct mx6cam_buffer *buf = to_mx6cam_vb(vb);
+	INIT_LIST_HEAD(&buf->list);
+	return 0;
+}
+
+static int mx6cam_buf_prepare(struct vb2_buffer *vb)
+{
+	struct mx6cam_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	if (vb2_plane_size(vb, 0) < dev->user_fmt.fmt.pix.sizeimage) {
+		v4l2_err(&dev->v4l2_dev,
+			 "data will not fit into plane (%lu < %lu)\n",
+			 vb2_plane_size(vb, 0),
+			 (long)dev->user_fmt.fmt.pix.sizeimage);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, dev->user_fmt.fmt.pix.sizeimage);
+
+	return 0;
+}
+
+static void mx6cam_buf_queue(struct vb2_buffer *vb)
+{
+	struct mx6cam_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct mx6cam_buffer *buf = to_mx6cam_vb(vb);
+	unsigned long flags;
+	bool kickstart;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	list_add_tail(&buf->list, &ctx->ready_q);
+
+	/* kickstart DMA chain if we have two frames in active q */
+	kickstart = (vb2_is_streaming(vb->vb2_queue) &&
+		     !(list_empty(&ctx->ready_q) ||
+		       list_is_singular(&ctx->ready_q)));
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	if (kickstart)
+		start_encoder(dev);
+}
+
+static void mx6cam_lock(struct vb2_queue *vq)
+{
+	struct mx6cam_ctx *ctx = vb2_get_drv_priv(vq);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	mutex_lock(&dev->mutex);
+}
+
+static void mx6cam_unlock(struct vb2_queue *vq)
+{
+	struct mx6cam_ctx *ctx = vb2_get_drv_priv(vq);
+	struct mx6cam_dev *dev = ctx->dev;
+
+	mutex_unlock(&dev->mutex);
+}
+
+static int mx6cam_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct mx6cam_ctx *ctx = vb2_get_drv_priv(vq);
+
+	if (vb2_is_streaming(vq))
+		return 0;
+
+	return set_stream(ctx, true);
+}
+
+static void mx6cam_stop_streaming(struct vb2_queue *vq)
+{
+	struct mx6cam_ctx *ctx = vb2_get_drv_priv(vq);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct mx6cam_buffer *frame;
+	unsigned long flags;
+
+	if (!vb2_is_streaming(vq))
+		return;
+
+	set_stream(ctx, false);
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	/* release all active buffers */
+	while (!list_empty(&ctx->ready_q)) {
+		frame = list_entry(ctx->ready_q.next,
+				   struct mx6cam_buffer, list);
+		list_del(&frame->list);
+		vb2_buffer_done(&frame->vb, VB2_BUF_STATE_ERROR);
+	}
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+}
+
+static struct vb2_ops mx6cam_qops = {
+	.queue_setup	 = mx6cam_queue_setup,
+	.buf_init        = mx6cam_buf_init,
+	.buf_prepare	 = mx6cam_buf_prepare,
+	.buf_queue	 = mx6cam_buf_queue,
+	.wait_prepare	 = mx6cam_unlock,
+	.wait_finish	 = mx6cam_lock,
+	.start_streaming = mx6cam_start_streaming,
+	.stop_streaming  = mx6cam_stop_streaming,
+};
+
+/*
+ * File operations
+ */
+static int mx6cam_open(struct file *file)
+{
+	struct mx6cam_dev *dev = video_drvdata(file);
+	struct mx6cam_ctx *ctx;
+	int ret;
+
+	if (mutex_lock_interruptible(&dev->mutex))
+		return -ERESTARTSYS;
+
+	if (!dev->ep || !dev->ep->sd) {
+		v4l2_err(&dev->v4l2_dev, "no subdevice registered\n");
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	ctx->dev = dev;
+	v4l2_fh_add(&ctx->fh);
+	ctx->io_allowed = false;
+
+	ret = sensor_set_power(dev, 1);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "sensor power on failed\n");
+		goto ctx_free;
+	}
+
+	if (dev->ep->ep.bus_type == V4L2_MBUS_CSI2 && dev->csi2_sd) {
+		ret = v4l2_subdev_call(dev->csi2_sd, core, s_power, true);
+		if (ret) {
+			v4l2_err(&dev->v4l2_dev, "csi2 power on failed\n");
+			goto sensor_off;
+		}
+	}
+
+	/* update the sensor's current format */
+	update_sensor_fmt(dev);
+	/* and init crop window if needed */
+	if (!dev->crop.width || !dev->crop.height)
+		calc_default_crop(dev, &dev->crop, &dev->sensor_fmt);
+
+	mutex_unlock(&dev->mutex);
+	return 0;
+
+sensor_off:
+	sensor_set_power(dev, 0);
+ctx_free:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+unlock:
+	mutex_unlock(&dev->mutex);
+	return ret;
+}
+
+static int mx6cam_release(struct file *file)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	int ret = 0;
+
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	mutex_lock(&dev->mutex);
+
+	if (ctx->io_allowed) {
+		BUG_ON(dev->io_ctx != ctx);
+
+		vb2_queue_release(&dev->buffer_queue);
+		vb2_dma_contig_cleanup_ctx(ctx->alloc_ctx);
+
+		if (dev->preview_on) {
+			stop_preview(dev);
+			dev->preview_on = false;
+		}
+
+		dev->io_ctx = NULL;
+	}
+
+	if (dev->ep == NULL || dev->ep->sd == NULL) {
+		v4l2_warn(&dev->v4l2_dev, "lost the slave?\n");
+		goto unlock;
+	}
+
+	ret = sensor_set_power(dev, 0);
+	if (ret)
+		v4l2_err(&dev->v4l2_dev, "sensor power off failed\n");
+
+unlock:
+	mutex_unlock(&dev->mutex);
+	kfree(ctx);
+	return ret;
+}
+
+static unsigned int mx6cam_poll(struct file *file,
+				 struct poll_table_struct *wait)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct vb2_queue *vq = &dev->buffer_queue;
+	int ret;
+
+	if (mutex_lock_interruptible(&dev->mutex))
+		return -ERESTARTSYS;
+
+	ret = vb2_poll(vq, file, wait);
+
+	mutex_unlock(&dev->mutex);
+	return ret;
+}
+
+static int mx6cam_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct mx6cam_ctx *ctx = file2ctx(file);
+	struct mx6cam_dev *dev = ctx->dev;
+	struct vb2_queue *vq = &dev->buffer_queue;
+	int ret;
+
+	if (mutex_lock_interruptible(&dev->mutex))
+		return -ERESTARTSYS;
+
+	ret = vb2_mmap(vq, vma);
+
+	mutex_unlock(&dev->mutex);
+	return ret;
+}
+
+static const struct v4l2_file_operations mx6cam_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mx6cam_open,
+	.release	= mx6cam_release,
+	.poll		= mx6cam_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= mx6cam_mmap,
+};
+
+static struct video_device mx6cam_videodev = {
+	.name		= DEVICE_NAME,
+	.fops		= &mx6cam_fops,
+	.ioctl_ops	= &mx6cam_ioctl_ops,
+	.minor		= -1,
+	.release	= video_device_release,
+	.vfl_dir	= VFL_DIR_RX,
+	.tvnorms	= V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM,
+};
+
+/*
+ * Handle notifications from the subdevs.
+ */
+static void mx6cam_subdev_notification(struct v4l2_subdev *sd,
+				       unsigned int notification,
+				       void *arg)
+{
+	struct mx6cam_dev *dev;
+	struct mx6cam_ctx *ctx;
+
+	if (sd == NULL)
+		return;
+
+	dev = sd2dev(sd);
+	ctx = dev->io_ctx;
+
+	switch (notification) {
+	case MX6CAM_NFB4EOF_NOTIFY:
+		if (ctx)
+			mod_timer(&ctx->restart_timer, jiffies +
+				  msecs_to_jiffies(MX6CAM_RESTART_DELAY));
+		break;
+	case DECODER_STATUS_CHANGE_NOTIFY:
+		atomic_set(&dev->status_change, 1);
+		if (ctx) {
+			v4l2_warn(&dev->v4l2_dev, "decoder status change\n");
+			mod_timer(&ctx->restart_timer, jiffies +
+				  msecs_to_jiffies(MX6CAM_RESTART_DELAY));
+		}
+		break;
+	case MX6CAM_EOF_TIMEOUT_NOTIFY:
+		if (ctx) {
+			/* cancel a running restart timer since we are
+			   restarting now anyway */
+			del_timer_sync(&ctx->restart_timer);
+			/* and restart now */
+			schedule_work(&ctx->restart_work);
+		}
+		break;
+	}
+}
+
+static int mx6cam_add_sensor(struct mx6cam_dev *dev,
+			     struct device_node *remote,
+			     struct mx6cam_endpoint *ep)
+{
+	struct i2c_client *client;
+	int ret = 0;
+
+	client = of_find_i2c_device_by_node(remote);
+	if (!client)
+		return -EPROBE_DEFER;
+
+	device_lock(&client->dev);
+
+	if (!client->dev.driver ||
+	    !try_module_get(client->dev.driver->owner)) {
+		ret = -EPROBE_DEFER;
+		v4l2_info(&dev->v4l2_dev, "No driver found for %s\n",
+			  remote->full_name);
+		goto unlock;
+	}
+
+	ep->sd = i2c_get_clientdata(client);
+	ret = v4l2_device_register_subdev(&dev->v4l2_dev, ep->sd);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev, "failed to register subdev %s\n",
+			 ep->sd->name);
+		goto mod_put;
+	}
+
+	v4l2_info(&dev->v4l2_dev, "Registered sensor subdev %s on CSI%d\n",
+		  ep->sd->name, ep->ep.base.port);
+	ret = 0;
+
+mod_put:
+	module_put(client->dev.driver->owner);
+unlock:
+	device_unlock(&client->dev);
+	put_device(&client->dev);
+	return ret;
+}
+
+static int mx6cam_add_csi2_receiver(struct mx6cam_dev *dev)
+{
+	struct platform_device *pdev;
+	struct device_node *node;
+	int ret = -EPROBE_DEFER;
+
+	node = of_find_compatible_node(NULL, NULL, "fsl,imx6-mipi-csi2");
+	if (!node)
+		return 0;
+
+	pdev = of_find_device_by_node(node);
+	of_node_put(node);
+	if (!pdev)
+		return 0;
+
+	/* Lock to ensure dev->driver won't change. */
+	device_lock(&pdev->dev);
+
+	if (!pdev->dev.driver || !try_module_get(pdev->dev.driver->owner))
+		goto dev_unlock;
+
+	dev->csi2_sd = dev_get_drvdata(&pdev->dev);
+
+	ret = v4l2_device_register_subdev(&dev->v4l2_dev, dev->csi2_sd);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "failed to register mipi_csi2!\n");
+		goto mod_put;
+	}
+
+	v4l2_info(&dev->v4l2_dev, "Registered subdev %s\n",
+		  dev->csi2_sd->name);
+mod_put:
+	module_put(pdev->dev.driver->owner);
+dev_unlock:
+	device_unlock(&pdev->dev);
+	if (ret == -EPROBE_DEFER)
+		v4l2_info(&dev->v4l2_dev,
+			  "deferring mipi_csi2 registration\n");
+	else if (ret < 0)
+		v4l2_err(&dev->v4l2_dev,
+			 "mipi_csi2 registration failed (%d)\n", ret);
+	return ret;
+}
+
+/* parse inputs property from v4l2_of_endpoint node */
+static int mx6cam_parse_inputs(struct mx6cam_dev *dev,
+			       struct device_node *node,
+			       int next_input,
+			       struct mx6cam_endpoint *ep)
+{
+	struct mx6cam_sensor_input *epinput = &ep->sensor_input;
+	int ret, i;
+
+	for (i = 0; i < MX6CAM_MAX_INPUTS; i++) {
+		const char *input_name;
+		u32 val;
+
+		ret = of_property_read_u32_index(node, "inputs", i, &val);
+		if (ret)
+			break;
+
+		epinput->value[i] = val;
+
+		ret = of_property_read_string_index(node, "input-names", i,
+						    &input_name);
+		if (!ret)
+			strncpy(epinput->name[i], input_name,
+				sizeof(epinput->name[i]));
+		else
+			snprintf(epinput->name[i], sizeof(epinput->name[i]),
+				 "%s-%d", ep->sd->name, i);
+
+		val = 0;
+		ret = of_property_read_u32_index(node, "input-caps", i, &val);
+		epinput->caps[i] = val;
+	}
+
+	epinput->num = i;
+
+	/* if no inputs provided just assume a single input */
+	if (epinput->num == 0) {
+		epinput->num = 1;
+		epinput->caps[0] = 0;
+		strncpy(epinput->name[0], ep->sd->name,
+			sizeof(epinput->name[0]));
+	}
+
+	epinput->first = next_input;
+	epinput->last = next_input + epinput->num - 1;
+	return epinput->last + 1;
+}
+
+static int mx6cam_parse_endpoints(struct mx6cam_dev *dev,
+				  struct device_node *node)
+{
+	struct device_node *remote, *epnode = NULL;
+	struct v4l2_of_endpoint ep;
+	int ret, next_input = 0;
+
+	while (dev->num_eps < MX6CAM_MAX_ENDPOINTS) {
+		epnode = of_graph_get_next_endpoint(node, epnode);
+		if (!epnode)
+			break;
+
+		v4l2_of_parse_endpoint(epnode, &ep);
+
+		if (ep.base.port > 1) {
+			v4l2_err(&dev->v4l2_dev, "invalid port %d\n",
+				 ep.base.port);
+			of_node_put(epnode);
+			return -EINVAL;
+		}
+
+		remote = of_graph_get_remote_port_parent(epnode);
+		if (!remote) {
+			v4l2_err(&dev->v4l2_dev,
+				 "failed to find remote port parent\n");
+			of_node_put(epnode);
+			return -EINVAL;
+		}
+
+		dev->eplist[dev->num_eps].ep = ep;
+		ret = mx6cam_add_sensor(dev, remote,
+					&dev->eplist[dev->num_eps]);
+		if (ret)
+			goto out;
+
+		next_input = mx6cam_parse_inputs(dev, epnode, next_input,
+						 &dev->eplist[dev->num_eps]);
+
+		dev->num_eps++;
+
+		of_node_put(remote);
+		of_node_put(epnode);
+	}
+
+	if (!dev->num_eps) {
+		v4l2_err(&dev->v4l2_dev, "no endpoints defined!\n");
+		return -EINVAL;
+	}
+
+	dev->ep = &dev->eplist[0];
+	return 0;
+out:
+	of_node_put(remote);
+	of_node_put(epnode);
+	return ret;
+}
+
+static void mx6cam_unregister_subdevs(struct mx6cam_dev *dev)
+{
+	struct i2c_adapter *adapter;
+	struct i2c_client *client;
+	struct mx6cam_endpoint *ep;
+	int i;
+
+	if (!IS_ERR_OR_NULL(dev->encoder_sd))
+		v4l2_device_unregister_subdev(dev->encoder_sd);
+
+	if (!IS_ERR_OR_NULL(dev->preview_sd))
+		v4l2_device_unregister_subdev(dev->preview_sd);
+
+	if (!IS_ERR_OR_NULL(dev->csi2_sd))
+		v4l2_device_unregister_subdev(dev->csi2_sd);
+
+	for (i = 0; i < dev->num_eps; i++) {
+		ep = &dev->eplist[i];
+		if (!ep->sd)
+			continue;
+		client = v4l2_get_subdevdata(ep->sd);
+		if (!client)
+			continue;
+
+		v4l2_device_unregister_subdev(ep->sd);
+
+		if (!client->dev.of_node) {
+			adapter = client->adapter;
+			i2c_unregister_device(client);
+			if (adapter)
+				i2c_put_adapter(adapter);
+		}
+	}
+}
+
+static int mx6cam_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct mx6cam_dev *dev;
+	struct video_device *vfd;
+	struct pinctrl *pinctrl;
+	int ret;
+
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->dev = &pdev->dev;
+	mutex_init(&dev->mutex);
+	spin_lock_init(&dev->irqlock);
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		return ret;
+
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+
+	/* get our parent IPU */
+	dev->ipu = dev_get_drvdata(pdev->dev.parent);
+	if (IS_ERR(dev->ipu)) {
+		v4l2_err(&dev->v4l2_dev, "could not get parent ipu\n");
+		ret = -ENODEV;
+		goto unreg_dev;
+	}
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto unreg_dev;
+	}
+
+	*vfd = mx6cam_videodev;
+	vfd->lock = &dev->mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	dev->v4l2_dev.notify = mx6cam_subdev_notification;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto unreg_vdev;
+	}
+
+	video_set_drvdata(vfd, dev);
+	snprintf(vfd->name, sizeof(vfd->name), "%s", mx6cam_videodev.name);
+	dev->vfd = vfd;
+
+	platform_set_drvdata(pdev, dev);
+
+	/* Get any pins needed */
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+
+	/* setup some defaults */
+	dev->user_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dev->user_fmt.fmt.pix.width = 640;
+	dev->user_fmt.fmt.pix.height = 480;
+	dev->user_fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420;
+	dev->user_fmt.fmt.pix.bytesperline = (640 * 12) >> 3;
+	dev->user_fmt.fmt.pix.sizeimage =
+		(480 * dev->user_fmt.fmt.pix.bytesperline);
+	dev->current_std = V4L2_STD_ALL;
+
+	/* init our controls */
+	ret = mx6cam_init_controls(dev);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "init controls failed\n");
+		goto unreg_vdev;
+	}
+
+	/* find and register mipi csi2 receiver subdev */
+	ret = mx6cam_add_csi2_receiver(dev);
+	if (ret)
+		goto free_ctrls;
+
+	/* parse and register all sensor endpoints */
+	ret = mx6cam_parse_endpoints(dev, node);
+	if (ret)
+		goto unreg_subdevs;
+
+	dev->encoder_sd = mx6cam_encoder_init(dev);
+	if (IS_ERR(dev->encoder_sd)) {
+		ret = PTR_ERR(dev->encoder_sd);
+		goto unreg_subdevs;
+	}
+
+	dev->preview_sd = mx6cam_preview_init(dev);
+	if (IS_ERR(dev->preview_sd)) {
+		ret = PTR_ERR(dev->preview_sd);
+		goto unreg_subdevs;
+	}
+
+	ret = v4l2_device_register_subdev(&dev->v4l2_dev, dev->encoder_sd);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev,
+			 "failed to register encoder subdev\n");
+		goto unreg_subdevs;
+	}
+	v4l2_info(&dev->v4l2_dev, "Registered subdev %s\n",
+		  dev->encoder_sd->name);
+
+	ret = v4l2_device_register_subdev(&dev->v4l2_dev, dev->preview_sd);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev,
+			 "failed to register preview subdev\n");
+		goto unreg_subdevs;
+	}
+	v4l2_info(&dev->v4l2_dev, "Registered subdev %s\n",
+		  dev->preview_sd->name);
+
+	ret = v4l2_device_register_subdev_nodes(&dev->v4l2_dev);
+	if (ret)
+		goto unreg_subdevs;
+
+	v4l2_info(&dev->v4l2_dev,
+		  "Device registered as /dev/video%d, parent is ipu%d\n",
+		  vfd->num, ipu_get_num(dev->ipu));
+
+	return 0;
+
+unreg_subdevs:
+	mx6cam_unregister_subdevs(dev);
+free_ctrls:
+	v4l2_ctrl_handler_free(&dev->ctrl_hdlr);
+unreg_vdev:
+	video_unregister_device(dev->vfd);
+unreg_dev:
+	v4l2_device_unregister(&dev->v4l2_dev);
+	return ret;
+}
+
+static int mx6cam_remove(struct platform_device *pdev)
+{
+	struct mx6cam_dev *dev =
+		(struct mx6cam_dev *)platform_get_drvdata(pdev);
+
+	v4l2_info(&dev->v4l2_dev, "Removing " DEVICE_NAME "\n");
+	v4l2_ctrl_handler_free(&dev->ctrl_hdlr);
+	video_unregister_device(dev->vfd);
+	mx6cam_unregister_subdevs(dev);
+	v4l2_device_unregister(&dev->v4l2_dev);
+
+	return 0;
+}
+
+static struct of_device_id mx6cam_dt_ids[] = {
+	{ .compatible = "fsl,imx6-v4l2-capture" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, mx6cam_dt_ids);
+
+static struct platform_driver mx6cam_pdrv = {
+	.probe		= mx6cam_probe,
+	.remove		= mx6cam_remove,
+	.driver		= {
+		.name	= DEVICE_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table	= mx6cam_dt_ids,
+	},
+};
+
+module_platform_driver(mx6cam_pdrv);
+
+MODULE_DESCRIPTION("i.MX6 v4l2 capture driver");
+MODULE_AUTHOR("Mentor Graphics Inc.");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/imx6/capture/mx6-camif.h b/drivers/staging/media/imx6/capture/mx6-camif.h
new file mode 100644
index 0000000..6ebcec6
--- /dev/null
+++ b/drivers/staging/media/imx6/capture/mx6-camif.h
@@ -0,0 +1,197 @@
+/*
+ * Video Capture driver for Freescale i.MX6 SOC
+ *
+ * Copyright (c) 2012-2014 Mentor Graphics Inc.
+ * Copyright 2004-2012 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef _MX6_CAMIF_H
+#define _MX6_CAMIF_H
+
+#define dprintk(dev, fmt, arg...)					\
+	v4l2_dbg(1, 1, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
+
+/*
+ * There can be a maximum of 5 endpoints (and 5 sensors attached to those
+ * endpoints): 1 parallel endpoints, and 4 MIPI-CSI2 endpoints for each
+ * virtual channel.
+ */
+#define MX6CAM_MAX_ENDPOINTS 5
+
+/*
+ * How long before no EOF interrupts cause a stream/preview
+ * restart, or a buffer dequeue timeout, in msec. The dequeue
+ * timeout should be longer than the EOF timeout.
+ */
+#define MX6CAM_EOF_TIMEOUT       1000
+#define MX6CAM_DQ_TIMEOUT        5000
+
+/*
+ * How long to delay a restart on ADV718x status changes or NFB4EOF,
+ * in msec.
+ */
+#define MX6CAM_RESTART_DELAY      200
+
+/*
+ * Internal subdev notifications
+ */
+#define MX6CAM_NFB4EOF_NOTIFY      _IO('6', 0)
+#define MX6CAM_EOF_TIMEOUT_NOTIFY  _IO('6', 1)
+
+struct mx6cam_buffer {
+	struct vb2_buffer vb; /* v4l buffer must be first */
+	struct list_head  list;
+};
+
+static inline struct mx6cam_buffer *to_mx6cam_vb(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct mx6cam_buffer, vb);
+}
+
+struct mx6cam_pixfmt {
+	char	*name;
+	u32	fourcc;
+	int     depth;   /* total bpp */
+	int     y_depth; /* depth of first Y plane for planar formats */
+};
+
+struct mx6cam_dma_buf {
+	void          *virt;
+	dma_addr_t     phys;
+	unsigned long  len;
+};
+
+/*
+ * A sensor's inputs parsed from v4l2_of_endpoint nodes in devicetree
+ */
+#define MX6CAM_MAX_INPUTS 16
+
+struct mx6cam_sensor_input {
+	/* input values passed to s_routing */
+	u32 value[MX6CAM_MAX_INPUTS];
+	/* input capabilities (V4L2_IN_CAP_*) */
+	u32 caps[MX6CAM_MAX_INPUTS];
+	/* input names */
+	char name[MX6CAM_MAX_INPUTS][32];
+
+	/* number of inputs */
+	int num;
+	/* first and last input indexes from mx6cam perspective */
+	int first;
+	int last;
+};
+
+/*
+ * Everything to describe a V4L2 endpoint. Endpoints are handled by
+ * one of the two CSI's, and connect to exactly one remote sensor.
+ */
+struct mx6cam_endpoint {
+	struct v4l2_of_endpoint ep;      /* the parsed DT endpoint info */
+	struct v4l2_subdev     *sd;      /* the remote sensor when attached
+					    to this endpoint */
+	struct mx6cam_sensor_input sensor_input;
+	struct ipu_csi_signal_cfg csi_sig_cfg;
+	int power_count;                 /* power use counter */
+	int stream_count;                /* stream use counter */
+};
+
+struct mx6cam_ctx;
+
+struct mx6cam_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vfd;
+	struct device           *dev;
+
+	struct mutex		mutex;
+	spinlock_t		irqlock;
+
+	/* buffer queue used in videobuf2 */
+	struct vb2_queue        buffer_queue;
+
+	/* v4l2 controls */
+	struct v4l2_ctrl_handler ctrl_hdlr;
+	int                      rotation; /* degrees */
+	bool                     hflip;
+	bool                     vflip;
+	/* derived from rotation, hflip, vflip controls */
+	enum ipu_rotate_mode     rot_mode;
+
+	/* the format from sensor and from userland */
+	struct v4l2_format        user_fmt;
+	struct v4l2_mbus_framefmt sensor_fmt;
+
+	/*
+	 * win (from s_fmt_vid_cap_overlay) holds global alpha, chromakey,
+	 * and interlace info for the preview overlay.
+	 */
+	struct v4l2_window      win;
+
+	/*
+	 * info about the overlay framebuffer for preview (base address,
+	 * width/height, pix format).
+	 */
+	struct v4l2_framebuffer fbuf;
+
+	/*
+	 * the crop rectangle (from s_crop) specifies the crop dimensions
+	 * and position over the raw capture frame boundaries.
+	 */
+	struct v4l2_rect        crop_bounds;
+	struct v4l2_rect        crop_defrect;
+	struct v4l2_rect        crop;
+
+	/* misc status */
+	int                     current_input; /* the current input */
+	v4l2_std_id             current_std;   /* current video standard */
+	atomic_t                status_change; /* sensor status change */
+	bool                    signal_locked; /* sensor signal lock */
+	bool                    encoder_on;    /* encode is on */
+	bool                    preview_on;    /* preview is on */
+	bool                    using_ic;      /* IC is being used for encode */
+
+	/* encoder, preview, and mipi csi2 subdevices */
+	struct v4l2_subdev     *encoder_sd;
+	struct v4l2_subdev     *preview_sd;
+	struct v4l2_subdev     *csi2_sd;
+
+	/* sensor endpoints */
+	struct mx6cam_endpoint  eplist[MX6CAM_MAX_ENDPOINTS];
+	struct mx6cam_endpoint  *ep; /* the current active endpoint */
+	int                     num_eps;
+
+	/*
+	 * the current open context that is doing IO (there can only
+	 * be one allowed IO context at a time).
+	 */
+	struct mx6cam_ctx       *io_ctx;
+
+	/* parent IPU */
+	struct ipu_soc          *ipu;
+};
+
+struct mx6cam_ctx {
+	struct v4l2_fh          fh;
+	struct mx6cam_dev       *dev;
+
+	struct vb2_alloc_ctx    *alloc_ctx;
+
+	/* streaming buffer queue */
+	struct list_head        ready_q;
+
+	/* stream/preview stop and restart handling */
+	struct work_struct      restart_work;
+	struct work_struct      stop_work;
+	struct timer_list       restart_timer;
+
+	/* is this ctx allowed to do IO */
+	bool                    io_allowed;
+};
+
+struct v4l2_subdev *mx6cam_encoder_init(struct mx6cam_dev *dev);
+struct v4l2_subdev *mx6cam_preview_init(struct mx6cam_dev *dev);
+
+#endif /* _MX6_CAMIF_H */
diff --git a/drivers/staging/media/imx6/capture/mx6-encode.c b/drivers/staging/media/imx6/capture/mx6-encode.c
new file mode 100644
index 0000000..fad36aa
--- /dev/null
+++ b/drivers/staging/media/imx6/capture/mx6-encode.c
@@ -0,0 +1,775 @@
+/*
+ * V4L2 Capture Encoder Subdev for Freescale i.MX6 SOC
+ *
+ * Copyright (c) 2012-2014 Mentor Graphics Inc.
+ * Copyright 2004-2012 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <linux/platform_data/imx-ipu-v3.h>
+#include <media/imx6.h>
+#include "mx6-camif.h"
+
+struct encoder_priv {
+	struct mx6cam_dev    *dev;
+	struct v4l2_subdev    sd;
+
+	struct ipuv3_channel *enc_ch;
+	struct ipuv3_channel *enc_rot_in_ch;
+	struct ipuv3_channel *enc_rot_out_ch;
+	struct ipu_ic *ic_enc;
+	struct ipu_irt *irt;
+	struct ipu_smfc *smfc;
+	struct ipu_csi *csi;
+
+	/* active (undergoing DMA) buffers, one for each IPU buffer */
+	struct mx6cam_buffer *active_frame[2];
+
+	struct mx6cam_dma_buf rot_buf[2];
+	struct mx6cam_dma_buf underrun_buf;
+	int buf_num;
+
+	struct timer_list eof_timeout_timer;
+	int eof_irq;
+	int nfb4eof_irq;
+
+	bool last_eof;  /* waiting for last EOF at encoder off */
+	struct completion last_eof_comp;
+};
+
+/*
+ * Update the CSI whole sensor and active windows, and initialize
+ * the CSI interface and muxes.
+ */
+static void encoder_setup_csi(struct encoder_priv *priv)
+{
+	struct mx6cam_dev *dev = priv->dev;
+
+	ipu_csi_set_window_size(priv->csi, dev->crop.width, dev->crop.height);
+	ipu_csi_set_window_pos(priv->csi, dev->crop.left, dev->crop.top);
+	ipu_csi_init_interface(priv->csi, dev->crop_bounds.width,
+			       dev->crop_bounds.height, &dev->ep->csi_sig_cfg);
+
+	if (dev->ep->ep.bus_type == V4L2_MBUS_CSI2)
+		ipu_csi_set_mipi_datatype(priv->csi, dev->ep->ep.base.id,
+					  &dev->ep->csi_sig_cfg);
+
+	/* select either parallel or MIPI-CSI2 as input to our CSI */
+	ipu_csi_set_src(priv->csi, dev->ep->ep.base.id,
+			dev->ep->ep.bus_type == V4L2_MBUS_CSI2);
+	/* set CSI destination to IC or direct to mem via SMFC */
+	ipu_csi_set_dest(priv->csi, dev->using_ic);
+}
+
+static void encoder_put_ipu_resources(struct encoder_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->irt))
+		ipu_irt_put(priv->irt);
+	priv->irt = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->ic_enc))
+		ipu_ic_put(priv->ic_enc);
+	priv->ic_enc = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->enc_ch))
+		ipu_idmac_put(priv->enc_ch);
+	priv->enc_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->enc_rot_in_ch))
+		ipu_idmac_put(priv->enc_rot_in_ch);
+	priv->enc_rot_in_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->enc_rot_out_ch))
+		ipu_idmac_put(priv->enc_rot_out_ch);
+	priv->enc_rot_out_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->smfc))
+		ipu_smfc_put(priv->smfc);
+	priv->smfc = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->csi))
+		ipu_csi_put(priv->csi);
+	priv->csi = NULL;
+}
+
+static int encoder_get_ipu_resources(struct encoder_priv *priv)
+{
+	struct mx6cam_dev *dev = priv->dev;
+	int csi_id, csi_ch_num, err;
+
+	csi_id = dev->ep->ep.base.port;
+	priv->csi = ipu_csi_get(dev->ipu, csi_id);
+	if (IS_ERR(priv->csi)) {
+		v4l2_err(&priv->sd, "failed to get CSI %d\n", csi_id);
+		return PTR_ERR(priv->csi);
+	}
+
+	if (dev->using_ic) {
+		priv->ic_enc = ipu_ic_get(dev->ipu, IC_TASK_ENCODER);
+		if (IS_ERR(priv->ic_enc)) {
+			v4l2_err(&priv->sd, "failed to get IC ENC\n");
+			err = PTR_ERR(priv->ic_enc);
+			goto out;
+		}
+
+		priv->irt = ipu_irt_get(dev->ipu);
+		if (IS_ERR(priv->irt)) {
+			v4l2_err(&priv->sd, "failed to get IRT\n");
+			err = PTR_ERR(priv->irt);
+			goto out;
+		}
+
+		priv->enc_ch = ipu_idmac_get(dev->ipu,
+					     IPUV3_CHANNEL_IC_PRP_ENC_MEM);
+		if (IS_ERR(priv->enc_ch)) {
+			v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+				 IPUV3_CHANNEL_IC_PRP_ENC_MEM);
+			err = PTR_ERR(priv->enc_ch);
+			goto out;
+		}
+
+		priv->enc_rot_in_ch = ipu_idmac_get(dev->ipu,
+						    IPUV3_CHANNEL_MEM_ROT_ENC);
+		if (IS_ERR(priv->enc_rot_in_ch)) {
+			v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+				 IPUV3_CHANNEL_MEM_ROT_ENC);
+			err = PTR_ERR(priv->enc_rot_in_ch);
+			goto out;
+		}
+
+		priv->enc_rot_out_ch = ipu_idmac_get(dev->ipu,
+						     IPUV3_CHANNEL_ROT_ENC_MEM);
+		if (IS_ERR(priv->enc_rot_out_ch)) {
+			v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+				 IPUV3_CHANNEL_ROT_ENC_MEM);
+			err = PTR_ERR(priv->enc_rot_out_ch);
+			goto out;
+		}
+	} else {
+		priv->smfc = ipu_smfc_get(dev->ipu);
+		if (IS_ERR(priv->smfc)) {
+			v4l2_err(&priv->sd, "failed to get SMFC\n");
+			err = PTR_ERR(priv->smfc);
+			goto out;
+		}
+
+		/*
+		 * Choose the direct CSI-->SMFC-->MEM channel corresponding
+		 * to the IPU and CSI IDs.
+		 */
+		csi_ch_num = IPUV3_CHANNEL_CSI0 +
+			(ipu_get_num(dev->ipu) << 1) + csi_id;
+
+		priv->enc_ch = ipu_idmac_get(dev->ipu, csi_ch_num);
+		if (IS_ERR(priv->enc_ch)) {
+			v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+				 csi_ch_num);
+			err = PTR_ERR(priv->enc_ch);
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	encoder_put_ipu_resources(priv);
+	return err;
+}
+
+static irqreturn_t encoder_eof_interrupt(int irq, void *dev_id)
+{
+	struct encoder_priv *priv = dev_id;
+	struct mx6cam_dev *dev = priv->dev;
+	struct mx6cam_ctx *ctx = dev->io_ctx;
+	struct mx6cam_buffer *frame;
+	struct ipuv3_channel *channel;
+	enum vb2_buffer_state state;
+	struct timeval cur_time;
+	unsigned long flags;
+	dma_addr_t phys;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	/* timestamp and return the completed frame */
+	frame = priv->active_frame[priv->buf_num];
+	if (frame) {
+		do_gettimeofday(&cur_time);
+		frame->vb.v4l2_buf.timestamp = cur_time;
+		state = dev->signal_locked ?
+			VB2_BUF_STATE_DONE : VB2_BUF_STATE_ERROR;
+		vb2_buffer_done(&frame->vb, state);
+	}
+
+	if (priv->last_eof) {
+		complete(&priv->last_eof_comp);
+		priv->active_frame[priv->buf_num] = NULL;
+		priv->last_eof = false;
+		goto unlock;
+	}
+
+	/* bump the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(MX6CAM_EOF_TIMEOUT));
+
+	if (!list_empty(&ctx->ready_q)) {
+		frame = list_entry(ctx->ready_q.next,
+				   struct mx6cam_buffer, list);
+		phys = vb2_dma_contig_plane_dma_addr(&frame->vb, 0);
+		list_del(&frame->list);
+		priv->active_frame[priv->buf_num] = frame;
+	} else {
+		phys = priv->underrun_buf.phys;
+		priv->active_frame[priv->buf_num] = NULL;
+	}
+
+	channel = (dev->rot_mode >= IPU_ROTATE_90_RIGHT) ?
+		priv->enc_rot_out_ch : priv->enc_ch;
+
+	if (ipu_idmac_buffer_is_ready(channel, priv->buf_num))
+		ipu_idmac_clear_buffer(channel, priv->buf_num);
+
+	ipu_cpmem_set_buffer(channel, priv->buf_num, phys);
+	ipu_idmac_select_buffer(channel, priv->buf_num);
+
+	priv->buf_num ^= 1;
+
+unlock:
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t encoder_nfb4eof_interrupt(int irq, void *dev_id)
+{
+	struct encoder_priv *priv = dev_id;
+	struct mx6cam_dev *dev = priv->dev;
+
+	v4l2_err(&priv->sd, "NFB4EOF\n");
+
+	/*
+	 * It has been discovered that with rotation, encoder disable
+	 * creates a single NFB4EOF event which is 100% repeatable. So
+	 * scheduling a restart here causes an endless NFB4EOF-->restart
+	 * cycle. The error itself seems innocuous, capture is not adversely
+	 * affected.
+	 *
+	 * So don't schedule a restart on NFB4EOF error. If the source
+	 * of the NFB4EOF event on disable is ever found, it can
+	 * be re-enabled, but is probably not necessary. Detecting the
+	 * interrupt (and clearing the irq status in the IPU) seems to
+	 * be enough.
+	 */
+	if (!dev->using_ic)
+		v4l2_subdev_notify(&priv->sd, MX6CAM_NFB4EOF_NOTIFY, NULL);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * EOF timeout timer function.
+ */
+static void encoder_eof_timeout(unsigned long data)
+{
+	struct encoder_priv *priv = (struct encoder_priv *)data;
+
+	v4l2_err(&priv->sd, "encoder EOF timeout\n");
+
+	v4l2_subdev_notify(&priv->sd, MX6CAM_EOF_TIMEOUT_NOTIFY, NULL);
+}
+
+static void encoder_free_dma_buf(struct encoder_priv *priv,
+				 struct mx6cam_dma_buf *buf)
+{
+	struct mx6cam_dev *dev = priv->dev;
+
+	if (buf->virt)
+		dma_free_coherent(dev->dev, buf->len, buf->virt, buf->phys);
+
+	buf->virt = NULL;
+	buf->phys = 0;
+}
+
+static int encoder_alloc_dma_buf(struct encoder_priv *priv,
+				 struct mx6cam_dma_buf *buf,
+				 int size)
+{
+	struct mx6cam_dev *dev = priv->dev;
+
+	encoder_free_dma_buf(priv, buf);
+
+	buf->len = PAGE_ALIGN(size);
+	buf->virt = dma_alloc_coherent(dev->dev, buf->len, &buf->phys,
+				       GFP_DMA | GFP_KERNEL);
+	if (!buf->virt) {
+		v4l2_err(&priv->sd, "failed to alloc dma buffer\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void encoder_setup_channel(struct encoder_priv *priv,
+				  struct ipuv3_channel *channel,
+				  struct v4l2_pix_format *f,
+				  enum ipu_rotate_mode rot_mode,
+				  dma_addr_t addr0, dma_addr_t addr1,
+				  bool rot_swap_width_height)
+{
+	struct mx6cam_dev *dev = priv->dev;
+	u32 width, height, stride;
+	unsigned int burst_size;
+	struct ipu_image image;
+
+	if (dev->using_ic && rot_swap_width_height) {
+		width = f->height;
+		height = f->width;
+	} else {
+		width = f->width;
+		height = f->height;
+	}
+	stride = ipu_stride_to_bytes(width, f->pixelformat);
+
+	ipu_cpmem_zero(channel);
+
+	memset(&image, 0, sizeof(image));
+	image.pix.width = image.rect.width = width;
+	image.pix.height = image.rect.height = height;
+	image.pix.bytesperline = stride;
+	image.pix.pixelformat = f->pixelformat;
+	image.phys0 = addr0;
+	image.phys1 = addr1;
+	ipu_cpmem_set_image(channel, &image);
+
+	if (channel == priv->enc_rot_in_ch ||
+	    channel == priv->enc_rot_out_ch) {
+		burst_size = 8;
+		ipu_cpmem_set_block_mode(channel);
+	} else
+		burst_size = (width % 16) ? 8 : 16;
+
+	ipu_cpmem_set_burstsize(channel, burst_size);
+
+	if (!dev->using_ic) {
+		int csi_id = ipu_csi_get_num(priv->csi);
+		bool passthrough;
+
+		/*
+		 * If the sensor uses 16-bit parallel CSI bus, we must handle
+		 * the data internally in the IPU as 16-bit generic, aka
+		 * passthrough mode.
+		 */
+		passthrough = (dev->ep->ep.bus_type != V4L2_MBUS_CSI2 &&
+			       dev->ep->csi_sig_cfg.data_width ==
+			       IPU_CSI_DATA_WIDTH_16);
+
+		if (passthrough)
+			ipu_cpmem_set_format_passthrough(channel, 16);
+
+		if (dev->ep->ep.bus_type == V4L2_MBUS_CSI2)
+			ipu_smfc_map(priv->smfc, channel, csi_id,
+				     dev->ep->ep.base.id);
+		else
+			ipu_smfc_map(priv->smfc, channel, csi_id, 0);
+
+		/*
+		 * Set the channel for the direct CSI-->memory via SMFC
+		 * use-case to very high priority, by enabling the watermark
+		 * signal in the SMFC, enabling WM in the channel, and setting
+		 * the channel priority to high.
+		 *
+		 * Refer to the iMx6 rev. D TRM Table 36-8: Calculated priority
+		 * value.
+		 *
+		 * The WM's are set very low by intention here to ensure that
+		 * the SMFC FIFOs do not overflow.
+		 */
+		ipu_smfc_set_wmc(priv->smfc, channel, false, 0x01);
+		ipu_smfc_set_wmc(priv->smfc, channel, true, 0x02);
+		ipu_cpmem_set_high_priority(channel);
+		ipu_idmac_enable_watermark(channel, true);
+		ipu_cpmem_set_axi_id(channel, 0);
+		ipu_idmac_lock_enable(channel, 8);
+
+		ipu_smfc_set_burst_size(priv->smfc, channel,
+					burst_size, passthrough);
+	}
+
+	if (rot_mode)
+		ipu_cpmem_set_rotation(channel, rot_mode);
+
+	if (ipu_csi_is_interlaced(priv->csi) && channel == priv->enc_ch)
+		ipu_cpmem_interlaced_scan(channel, stride);
+
+	if (dev->using_ic) {
+		ipu_ic_task_idma_init(priv->ic_enc, channel, width, height,
+				      burst_size, rot_mode);
+		ipu_cpmem_set_axi_id(channel, 1);
+	}
+
+	ipu_idmac_set_double_buffer(channel, true);
+}
+
+static int encoder_setup_rotation(struct encoder_priv *priv,
+				  dma_addr_t phys0, dma_addr_t phys1,
+				  struct v4l2_mbus_framefmt *inf,
+				  struct v4l2_pix_format *outf)
+{
+	struct mx6cam_dev *dev = priv->dev;
+	enum ipu_color_space in_cs, out_cs;
+	int out_size = (outf->width * outf->height *
+			ipu_bits_per_pixel(outf->pixelformat)) >> 3;
+	int err;
+
+	err = encoder_alloc_dma_buf(priv, &priv->underrun_buf, out_size);
+	if (err) {
+		v4l2_err(&priv->sd, "failed to alloc underrun_buf, %d\n", err);
+		return err;
+	}
+
+	err = encoder_alloc_dma_buf(priv, &priv->rot_buf[0], out_size);
+	if (err) {
+		v4l2_err(&priv->sd, "failed to alloc rot_buf[0], %d\n", err);
+		goto free_underrun;
+	}
+	err = encoder_alloc_dma_buf(priv, &priv->rot_buf[1], out_size);
+	if (err) {
+		v4l2_err(&priv->sd, "failed to alloc rot_buf[1], %d\n", err);
+		goto free_rot0;
+	}
+
+	in_cs = ipu_mbus_code_to_colorspace(inf->code);
+	out_cs = ipu_pixelformat_to_colorspace(outf->pixelformat);
+
+	err = ipu_ic_task_init(priv->ic_enc,
+			       inf->width, inf->height,
+			       outf->height, outf->width,
+			       in_cs, out_cs);
+	if (err) {
+		v4l2_err(&priv->sd, "ipu_ic_task_init failed, %d\n", err);
+		goto free_rot1;
+	}
+
+	/* init the IC ENC-->MEM IDMAC channel */
+	encoder_setup_channel(priv, priv->enc_ch, outf,
+			      IPU_ROTATE_NONE,
+			      priv->rot_buf[0].phys,
+			      priv->rot_buf[1].phys,
+			      true);
+
+	/* init the MEM-->IC ENC ROT IDMAC channel */
+	encoder_setup_channel(priv, priv->enc_rot_in_ch, outf,
+			      dev->rot_mode,
+			      priv->rot_buf[0].phys,
+			      priv->rot_buf[1].phys,
+			      true);
+
+	/* init the destination IC ENC ROT-->MEM IDMAC channel */
+	encoder_setup_channel(priv, priv->enc_rot_out_ch, outf,
+			      IPU_ROTATE_NONE,
+			      phys0, phys1,
+			      false);
+
+	/* now link IC PRP-->MEM to MEM-->IC PRP ROT */
+	ipu_link_prp_enc_rot_enc(dev->ipu);
+
+	/* enable the IC and IRT */
+	ipu_ic_enable(priv->ic_enc);
+	ipu_irt_enable(priv->irt);
+
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->enc_ch, 0);
+	ipu_idmac_select_buffer(priv->enc_ch, 1);
+	ipu_idmac_select_buffer(priv->enc_rot_out_ch, 0);
+	ipu_idmac_select_buffer(priv->enc_rot_out_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->enc_ch);
+	ipu_idmac_enable_channel(priv->enc_rot_in_ch);
+	ipu_idmac_enable_channel(priv->enc_rot_out_ch);
+
+	/* and finally enable the IC PRPENC task */
+	ipu_ic_task_enable(priv->ic_enc);
+
+	return 0;
+
+free_rot1:
+	encoder_free_dma_buf(priv, &priv->rot_buf[1]);
+free_rot0:
+	encoder_free_dma_buf(priv, &priv->rot_buf[0]);
+free_underrun:
+	encoder_free_dma_buf(priv, &priv->underrun_buf);
+	return err;
+}
+
+static int encoder_setup_norotation(struct encoder_priv *priv,
+				    dma_addr_t phys0, dma_addr_t phys1,
+				    struct v4l2_mbus_framefmt *inf,
+				    struct v4l2_pix_format *outf)
+{
+	struct mx6cam_dev *dev = priv->dev;
+	enum ipu_color_space in_cs, out_cs;
+	int out_size = (outf->width * outf->height *
+			ipu_bits_per_pixel(outf->pixelformat)) >> 3;
+	int err;
+
+	err = encoder_alloc_dma_buf(priv, &priv->underrun_buf, out_size);
+	if (err) {
+		v4l2_err(&priv->sd, "failed to alloc underrun_buf, %d\n", err);
+		return err;
+	}
+
+	in_cs = ipu_mbus_code_to_colorspace(inf->code);
+	out_cs = ipu_pixelformat_to_colorspace(outf->pixelformat);
+
+	if (dev->using_ic) {
+		err = ipu_ic_task_init(priv->ic_enc,
+				       inf->width, inf->height,
+				       outf->width, outf->height,
+				       in_cs, out_cs);
+		if (err) {
+			v4l2_err(&priv->sd, "ipu_ic_task_init failed, %d\n",
+				 err);
+			goto free_underrun;
+		}
+	}
+
+	/* init the IC PRP-->MEM IDMAC channel */
+	encoder_setup_channel(priv, priv->enc_ch, outf,
+			      dev->rot_mode, phys0, phys1, false);
+
+	if (dev->using_ic)
+		ipu_ic_enable(priv->ic_enc);
+	else
+		ipu_smfc_enable(priv->smfc);
+
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->enc_ch, 0);
+	ipu_idmac_select_buffer(priv->enc_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->enc_ch);
+
+	if (dev->using_ic) {
+		/* enable the IC ENCODE task */
+		ipu_ic_task_enable(priv->ic_enc);
+	}
+
+	return 0;
+
+free_underrun:
+	encoder_free_dma_buf(priv, &priv->underrun_buf);
+	return err;
+}
+
+static int encoder_start(struct encoder_priv *priv)
+{
+	struct mx6cam_dev *dev = priv->dev;
+	struct mx6cam_ctx *ctx = dev->io_ctx;
+	struct v4l2_mbus_framefmt inf;
+	struct v4l2_pix_format outf;
+	struct mx6cam_buffer *frame, *tmp;
+	dma_addr_t phys[2];
+	int i = 0, err;
+
+	err = encoder_get_ipu_resources(priv);
+	if (err)
+		return err;
+
+	phys[0] = phys[1] = 0;
+	list_for_each_entry_safe(frame, tmp, &ctx->ready_q, list) {
+		phys[i] = vb2_dma_contig_plane_dma_addr(&frame->vb, 0);
+		list_del(&frame->list);
+		priv->active_frame[i++] = frame;
+		if (i >= 2)
+			break;
+	}
+
+	/* if preview is enabled it has already setup the CSI */
+	if (!dev->preview_on)
+		encoder_setup_csi(priv);
+
+	inf = dev->sensor_fmt;
+	inf.width = dev->crop.width;
+	inf.height = dev->crop.height;
+	outf = dev->user_fmt.fmt.pix;
+
+	priv->buf_num = 0;
+
+	if (dev->rot_mode >= IPU_ROTATE_90_RIGHT)
+		err = encoder_setup_rotation(priv, phys[0], phys[1],
+					     &inf, &outf);
+	else
+		err = encoder_setup_norotation(priv, phys[0], phys[1],
+					       &inf, &outf);
+	if (err)
+		goto out_put_ipu;
+
+	priv->nfb4eof_irq = ipu_idmac_channel_irq(dev->ipu,
+						 priv->enc_ch,
+						 IPU_IRQ_NFB4EOF);
+	err = devm_request_irq(dev->dev, priv->nfb4eof_irq,
+			       encoder_nfb4eof_interrupt, 0,
+			       "mx6cam-enc-nfb4eof", priv);
+	if (err) {
+		v4l2_err(&priv->sd,
+			 "Error registering encode NFB4EOF irq: %d\n", err);
+		goto out_put_ipu;
+	}
+
+	if (dev->rot_mode >= IPU_ROTATE_90_RIGHT)
+		priv->eof_irq = ipu_idmac_channel_irq(
+			dev->ipu, priv->enc_rot_out_ch, IPU_IRQ_EOF);
+	else
+		priv->eof_irq = ipu_idmac_channel_irq(
+			dev->ipu, priv->enc_ch, IPU_IRQ_EOF);
+
+	err = devm_request_irq(dev->dev, priv->eof_irq,
+			       encoder_eof_interrupt, 0,
+			       "mx6cam-enc-eof", priv);
+	if (err) {
+		v4l2_err(&priv->sd,
+			 "Error registering encode eof irq: %d\n", err);
+		goto out_free_nfb4eof_irq;
+	}
+
+	err = ipu_csi_enable(priv->csi);
+	if (err) {
+		v4l2_err(&priv->sd, "CSI enable error: %d\n", err);
+		goto out_free_eof_irq;
+	}
+
+	/* start the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(MX6CAM_EOF_TIMEOUT));
+
+	return 0;
+
+out_free_eof_irq:
+	devm_free_irq(dev->dev, priv->eof_irq, priv);
+out_free_nfb4eof_irq:
+	devm_free_irq(dev->dev, priv->nfb4eof_irq, priv);
+out_put_ipu:
+	encoder_put_ipu_resources(priv);
+	return err;
+}
+
+static int encoder_stop(struct encoder_priv *priv)
+{
+	struct mx6cam_dev *dev = priv->dev;
+	struct mx6cam_buffer *frame;
+	struct timeval cur_time;
+	int i, ret;
+
+	/* stop the EOF timeout timer */
+	del_timer_sync(&priv->eof_timeout_timer);
+
+	/*
+	 * Mark next EOF interrupt as the last before encoder off,
+	 * and then wait for interrupt handler to mark completion.
+	 */
+	init_completion(&priv->last_eof_comp);
+	priv->last_eof = true;
+	ret = wait_for_completion_timeout(&priv->last_eof_comp,
+					  msecs_to_jiffies(MX6CAM_EOF_TIMEOUT));
+	if (ret == 0)
+		v4l2_warn(&priv->sd, "wait last encode EOF timeout\n");
+
+	ipu_csi_disable(priv->csi);
+
+	devm_free_irq(dev->dev, priv->eof_irq, priv);
+	devm_free_irq(dev->dev, priv->nfb4eof_irq, priv);
+
+	/* disable IC tasks and the channels */
+	if (dev->using_ic)
+		ipu_ic_task_disable(priv->ic_enc);
+
+	ipu_idmac_disable_channel(priv->enc_ch);
+	if (dev->rot_mode >= IPU_ROTATE_90_RIGHT) {
+		ipu_idmac_disable_channel(priv->enc_rot_in_ch);
+		ipu_idmac_disable_channel(priv->enc_rot_out_ch);
+	}
+
+	if (dev->rot_mode >= IPU_ROTATE_90_RIGHT)
+		ipu_unlink_prp_enc_rot_enc(dev->ipu);
+
+	if (dev->using_ic)
+		ipu_ic_disable(priv->ic_enc);
+	else
+		ipu_smfc_disable(priv->smfc);
+
+	if (dev->rot_mode >= IPU_ROTATE_90_RIGHT)
+		ipu_irt_disable(priv->irt);
+
+	encoder_free_dma_buf(priv, &priv->rot_buf[0]);
+	encoder_free_dma_buf(priv, &priv->rot_buf[1]);
+	encoder_free_dma_buf(priv, &priv->underrun_buf);
+
+	encoder_put_ipu_resources(priv);
+
+	/* return any remaining active frames with error */
+	for (i = 0; i < 2; i++) {
+		frame = priv->active_frame[i];
+		if (frame && frame->vb.state == VB2_BUF_STATE_ACTIVE) {
+			do_gettimeofday(&cur_time);
+			frame->vb.v4l2_buf.timestamp = cur_time;
+			vb2_buffer_done(&frame->vb, VB2_BUF_STATE_ERROR);
+		}
+	}
+
+	return 0;
+}
+
+static int encoder_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct encoder_priv *priv = v4l2_get_subdevdata(sd);
+
+	if (enable)
+		return encoder_start(priv);
+	else
+		return encoder_stop(priv);
+}
+
+static struct v4l2_subdev_video_ops encoder_video_ops = {
+	.s_stream = encoder_s_stream,
+};
+
+static struct v4l2_subdev_ops encoder_subdev_ops = {
+	.video = &encoder_video_ops,
+};
+
+struct v4l2_subdev *mx6cam_encoder_init(struct mx6cam_dev *dev)
+{
+	struct encoder_priv *priv;
+
+	priv = devm_kzalloc(dev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	init_timer(&priv->eof_timeout_timer);
+	priv->eof_timeout_timer.data = (unsigned long)priv;
+	priv->eof_timeout_timer.function = encoder_eof_timeout;
+
+	v4l2_subdev_init(&priv->sd, &encoder_subdev_ops);
+	strlcpy(priv->sd.name, "mx6-camera-encoder", sizeof(priv->sd.name));
+	v4l2_set_subdevdata(&priv->sd, priv);
+
+	priv->dev = dev;
+	return &priv->sd;
+}
diff --git a/drivers/staging/media/imx6/capture/mx6-preview.c b/drivers/staging/media/imx6/capture/mx6-preview.c
new file mode 100644
index 0000000..01d1e54
--- /dev/null
+++ b/drivers/staging/media/imx6/capture/mx6-preview.c
@@ -0,0 +1,748 @@
+/*
+ * V4L2 Preview Subdev for Freescale i.MX6 SOC
+ *
+ * Copyright (c) 2012-2014 Mentor Graphics Inc.
+ * Copyright 2004-2012 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <linux/platform_data/imx-ipu-v3.h>
+#include <media/imx6.h>
+#include "mx6-camif.h"
+
+struct preview_priv {
+	struct mx6cam_dev    *dev;
+	struct v4l2_subdev    sd;
+	struct v4l2_ctrl_handler ctrl_hdlr;
+
+	struct ipuv3_channel *preview_ch;
+	struct ipuv3_channel *preview_rot_in_ch;
+	struct ipuv3_channel *preview_rot_out_ch;
+	struct ipu_ic *ic_vf;
+	struct ipu_irt *irt;
+	struct ipu_csi *csi;
+
+	/* v4l2 controls */
+	int                   rotation; /* degrees */
+	bool                  hflip;
+	bool                  vflip;
+	/* derived from rotation, hflip, vflip controls */
+	enum ipu_rotate_mode  rot_mode;
+
+	struct timer_list eof_timeout_timer;
+	int eof_irq;
+	int nfb4eof_irq;
+
+	struct mx6cam_dma_buf rot_buf[2];
+	int buf_num;
+
+	bool preview_active;
+	bool last_eof;  /* waiting for last EOF at preview off */
+	struct completion last_eof_comp;
+};
+
+/*
+ * Update the CSI whole sensor and active windows, and initialize
+ * the CSI interface and muxes.
+ */
+static void preview_setup_csi(struct preview_priv *priv)
+{
+	struct mx6cam_dev *dev = priv->dev;
+
+	ipu_csi_set_window_size(priv->csi, dev->crop.width, dev->crop.height);
+	ipu_csi_set_window_pos(priv->csi, dev->crop.left, dev->crop.top);
+	ipu_csi_init_interface(priv->csi, dev->crop_bounds.width,
+			       dev->crop_bounds.height, &dev->ep->csi_sig_cfg);
+
+	if (dev->ep->ep.bus_type == V4L2_MBUS_CSI2)
+		ipu_csi_set_mipi_datatype(priv->csi, dev->ep->ep.base.id,
+					  &dev->ep->csi_sig_cfg);
+
+	/* select either parallel or MIPI-CSI2 as input to our CSI */
+	ipu_csi_set_src(priv->csi, dev->ep->ep.base.id,
+			dev->ep->ep.bus_type == V4L2_MBUS_CSI2);
+	/* set CSI destination to IC */
+	ipu_csi_set_dest(priv->csi, true);
+}
+
+static void preview_put_ipu_resources(struct preview_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->irt))
+		ipu_irt_put(priv->irt);
+	priv->irt = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->ic_vf))
+		ipu_ic_put(priv->ic_vf);
+	priv->ic_vf = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->preview_ch))
+		ipu_idmac_put(priv->preview_ch);
+	priv->preview_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->preview_rot_in_ch))
+		ipu_idmac_put(priv->preview_rot_in_ch);
+	priv->preview_rot_in_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->preview_rot_out_ch))
+		ipu_idmac_put(priv->preview_rot_out_ch);
+	priv->preview_rot_out_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->csi))
+		ipu_csi_put(priv->csi);
+	priv->csi = NULL;
+}
+
+static int preview_get_ipu_resources(struct preview_priv *priv)
+{
+	struct mx6cam_dev *dev = priv->dev;
+	int csi_id, err;
+
+	csi_id = dev->ep->ep.base.port;
+	priv->csi = ipu_csi_get(dev->ipu, csi_id);
+	if (IS_ERR(priv->csi)) {
+		v4l2_err(&priv->sd, "failed to get CSI %d\n", csi_id);
+		return PTR_ERR(priv->csi);
+	}
+
+	priv->ic_vf = ipu_ic_get(dev->ipu, IC_TASK_VIEWFINDER);
+	if (IS_ERR(priv->ic_vf)) {
+		v4l2_err(&priv->sd, "failed to get IC VF\n");
+		err = PTR_ERR(priv->ic_vf);
+		goto out;
+	}
+
+	priv->irt = ipu_irt_get(dev->ipu);
+	if (IS_ERR(priv->irt)) {
+		v4l2_err(&priv->sd, "failed to get IRT\n");
+		err = PTR_ERR(priv->irt);
+		goto out;
+	}
+
+	priv->preview_ch = ipu_idmac_get(dev->ipu,
+					 IPUV3_CHANNEL_IC_PRP_VF_MEM);
+	if (IS_ERR(priv->preview_ch)) {
+		v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+			 IPUV3_CHANNEL_IC_PRP_VF_MEM);
+		err = PTR_ERR(priv->preview_ch);
+		goto out;
+	}
+
+	priv->preview_rot_in_ch = ipu_idmac_get(dev->ipu,
+						IPUV3_CHANNEL_MEM_ROT_VF);
+	if (IS_ERR(priv->preview_rot_in_ch)) {
+		v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+			 IPUV3_CHANNEL_MEM_ROT_ENC);
+		err = PTR_ERR(priv->preview_rot_in_ch);
+		goto out;
+	}
+
+	priv->preview_rot_out_ch = ipu_idmac_get(dev->ipu,
+						 IPUV3_CHANNEL_ROT_VF_MEM);
+	if (IS_ERR(priv->preview_rot_out_ch)) {
+		v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+			 IPUV3_CHANNEL_ROT_ENC_MEM);
+		err = PTR_ERR(priv->preview_rot_out_ch);
+		goto out;
+	}
+
+	return 0;
+out:
+	preview_put_ipu_resources(priv);
+	return err;
+}
+
+static irqreturn_t preview_eof_interrupt(int irq, void *dev_id)
+{
+	struct preview_priv *priv = dev_id;
+
+	if (priv->last_eof) {
+		complete(&priv->last_eof_comp);
+		priv->last_eof = false;
+		return IRQ_HANDLED;
+	}
+
+	/* bump the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(MX6CAM_EOF_TIMEOUT));
+
+	if (priv->rot_mode >= IPU_ROTATE_90_RIGHT)
+		ipu_idmac_select_buffer(priv->preview_rot_out_ch,
+					priv->buf_num);
+	else
+		ipu_idmac_select_buffer(priv->preview_ch, priv->buf_num);
+
+	priv->buf_num ^= 1;
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t preview_nfb4eof_interrupt(int irq, void *dev_id)
+{
+	struct preview_priv *priv = dev_id;
+
+	v4l2_err(&priv->sd, "preview NFB4EOF\n");
+
+	/*
+	 * It has been discovered that with rotation, preview disable
+	 * creates a single NFB4EOF event which is 100% repeatable. So
+	 * scheduling a restart here causes an endless NFB4EOF-->restart
+	 * cycle. The error itself seems innocuous, capture is not adversely
+	 * affected.
+	 *
+	 * So don't schedule a restart on NFB4EOF error. If the source
+	 * of the NFB4EOF event on preview disable is ever found, it can
+	 * be re-enabled, but is probably not necessary. Detecting the
+	 * interrupt (and clearing the irq status in the IPU) seems to
+	 * be enough.
+	 */
+#if 0
+	v4l2_subdev_notify(&priv->sd, MX6CAM_NFB4EOF_NOTIFY, NULL);
+#endif
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * EOF timeout timer function.
+ */
+static void preview_eof_timeout(unsigned long data)
+{
+	struct preview_priv *priv = (struct preview_priv *)data;
+
+	v4l2_err(&priv->sd, "preview EOF timeout\n");
+
+	v4l2_subdev_notify(&priv->sd, MX6CAM_EOF_TIMEOUT_NOTIFY, NULL);
+}
+
+static void preview_free_dma_buf(struct preview_priv *priv,
+				 struct mx6cam_dma_buf *buf)
+{
+	struct mx6cam_dev *dev = priv->dev;
+
+	if (buf->virt)
+		dma_free_coherent(dev->dev, buf->len, buf->virt, buf->phys);
+
+	buf->virt = NULL;
+	buf->phys = 0;
+}
+
+static int preview_alloc_dma_buf(struct preview_priv *priv,
+				 struct mx6cam_dma_buf *buf,
+				 int size)
+{
+	struct mx6cam_dev *dev = priv->dev;
+
+	preview_free_dma_buf(priv, buf);
+
+	buf->len = PAGE_ALIGN(size);
+	buf->virt = dma_alloc_coherent(dev->dev, buf->len, &buf->phys,
+				       GFP_DMA | GFP_KERNEL);
+	if (!buf->virt) {
+		v4l2_err(&priv->sd, "failed to alloc dma buffer\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void preview_setup_channel(struct preview_priv *priv,
+				  struct ipuv3_channel *channel,
+				  struct v4l2_pix_format *f,
+				  enum ipu_rotate_mode rot_mode,
+				  dma_addr_t addr0, dma_addr_t addr1,
+				  bool rot_swap_width_height)
+{
+	unsigned int burst_size;
+	u32 width, height, stride;
+	struct ipu_image image;
+
+	if (rot_swap_width_height) {
+		width = f->height;
+		height = f->width;
+	} else {
+		width = f->width;
+		height = f->height;
+	}
+	stride = ipu_stride_to_bytes(width, f->pixelformat);
+
+	ipu_cpmem_zero(channel);
+
+	memset(&image, 0, sizeof(image));
+	image.pix.width = image.rect.width = width;
+	image.pix.height = image.rect.height = height;
+	image.pix.bytesperline = stride;
+	image.pix.pixelformat = f->pixelformat;
+	image.phys0 = addr0;
+	image.phys1 = addr1;
+	ipu_cpmem_set_image(channel, &image);
+
+	if (rot_mode)
+		ipu_cpmem_set_rotation(channel, rot_mode);
+
+	if (channel == priv->preview_rot_in_ch ||
+	    channel == priv->preview_rot_out_ch) {
+		burst_size = 8;
+		ipu_cpmem_set_block_mode(channel);
+	} else
+		burst_size = (width % 16) ? 8 : 16;
+
+	ipu_cpmem_set_burstsize(channel, burst_size);
+
+	if (ipu_csi_is_interlaced(priv->csi) && channel == priv->preview_ch)
+		ipu_cpmem_interlaced_scan(channel, stride);
+
+	ipu_ic_task_idma_init(priv->ic_vf, channel, width, height,
+			      burst_size, rot_mode);
+
+	ipu_cpmem_set_axi_id(channel, 1);
+
+	ipu_idmac_set_double_buffer(channel, true);
+}
+
+static int preview_setup_rotation(struct preview_priv *priv,
+				  dma_addr_t phys0, dma_addr_t phys1,
+				  struct v4l2_mbus_framefmt *inf,
+				  struct v4l2_pix_format *outf)
+{
+	struct mx6cam_dev *dev = priv->dev;
+	enum ipu_color_space in_cs, out_cs;
+	int out_size = (outf->width * outf->height *
+			ipu_bits_per_pixel(outf->pixelformat)) >> 3;
+	int err;
+
+	err = preview_alloc_dma_buf(priv, &priv->rot_buf[0], out_size);
+	if (err) {
+		v4l2_err(&priv->sd, "failed to alloc rot_buf[0], %d\n", err);
+		return err;
+	}
+	err = preview_alloc_dma_buf(priv, &priv->rot_buf[1], out_size);
+	if (err) {
+		v4l2_err(&priv->sd, "failed to alloc rot_buf[1], %d\n", err);
+		goto free_rot0;
+	}
+
+	in_cs = ipu_mbus_code_to_colorspace(inf->code);
+	out_cs = ipu_pixelformat_to_colorspace(outf->pixelformat);
+
+	err = ipu_ic_task_init(priv->ic_vf,
+			       inf->width, inf->height,
+			       outf->height, outf->width,
+			       in_cs, out_cs);
+	if (err) {
+		v4l2_err(&priv->sd, "ipu_ic_task_init failed, %d\n", err);
+		goto free_rot1;
+	}
+
+	/* init the IC PREVIEW-->MEM IDMAC channel */
+	preview_setup_channel(priv, priv->preview_ch, outf,
+			      IPU_ROTATE_NONE,
+			      priv->rot_buf[0].phys,
+			      priv->rot_buf[1].phys,
+			      true);
+
+	/* init the MEM-->IC PREVIEW ROT IDMAC channel */
+	preview_setup_channel(priv, priv->preview_rot_in_ch, outf,
+			      priv->rot_mode,
+			      priv->rot_buf[0].phys,
+			      priv->rot_buf[1].phys,
+			      true);
+
+	/* init the destination IC PREVIEW ROT-->MEM IDMAC channel */
+	preview_setup_channel(priv, priv->preview_rot_out_ch, outf,
+			      IPU_ROTATE_NONE,
+			      phys0, phys1,
+			      false);
+
+	/* now link IC PREVIEW-->MEM to MEM-->IC PREVIEW ROT */
+	ipu_link_prpvf_rot_prpvf(dev->ipu);
+
+	/* enable the IC and IRT */
+	ipu_ic_enable(priv->ic_vf);
+	ipu_irt_enable(priv->irt);
+
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->preview_ch, 0);
+	ipu_idmac_select_buffer(priv->preview_ch, 1);
+	ipu_idmac_select_buffer(priv->preview_rot_out_ch, 0);
+	ipu_idmac_select_buffer(priv->preview_rot_out_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->preview_ch);
+	ipu_idmac_enable_channel(priv->preview_rot_in_ch);
+	ipu_idmac_enable_channel(priv->preview_rot_out_ch);
+
+	/* and finally enable the IC PREVIEW task */
+	ipu_ic_task_enable(priv->ic_vf);
+
+	return 0;
+
+free_rot1:
+	preview_free_dma_buf(priv, &priv->rot_buf[1]);
+free_rot0:
+	preview_free_dma_buf(priv, &priv->rot_buf[0]);
+	return err;
+}
+
+static int preview_setup_norotation(struct preview_priv *priv,
+				    dma_addr_t phys0, dma_addr_t phys1,
+				    struct v4l2_mbus_framefmt *inf,
+				    struct v4l2_pix_format *outf)
+{
+	enum ipu_color_space in_cs, out_cs;
+	int err;
+
+	in_cs = ipu_mbus_code_to_colorspace(inf->code);
+	out_cs = ipu_pixelformat_to_colorspace(outf->pixelformat);
+
+	err = ipu_ic_task_init(priv->ic_vf,
+			       inf->width, inf->height,
+			       outf->width, outf->height,
+			       in_cs, out_cs);
+	if (err) {
+		v4l2_err(&priv->sd, "ipu_ic_task_init failed, %d\n", err);
+		return err;
+	}
+
+	/* init the IC PREVIEW-->MEM IDMAC channel */
+	preview_setup_channel(priv, priv->preview_ch, outf,
+			      priv->rot_mode, phys0, phys1, false);
+
+	ipu_ic_enable(priv->ic_vf);
+
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->preview_ch, 0);
+	ipu_idmac_select_buffer(priv->preview_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->preview_ch);
+
+	/* and finally enable the IC PREVIEW task */
+	ipu_ic_task_enable(priv->ic_vf);
+
+	return 0;
+}
+
+static int preview_start(struct preview_priv *priv)
+{
+	struct mx6cam_dev *dev = priv->dev;
+	struct v4l2_mbus_framefmt inf;
+	struct v4l2_pix_format outf;
+	dma_addr_t fb_buf;
+	int err = 0;
+
+	if (priv->preview_active) {
+		v4l2_warn(&priv->sd, "preview already started\n");
+		return 0;
+	}
+
+	err = preview_get_ipu_resources(priv);
+	if (err)
+		return err;
+
+	/* if encoder is enabled it has already setup the CSI */
+	if (!dev->encoder_on)
+		preview_setup_csi(priv);
+
+	inf = dev->sensor_fmt;
+	inf.width = dev->crop.width;
+	inf.height = dev->crop.height;
+	outf.width = dev->win.w.width;
+	outf.height = dev->win.w.height;
+	outf.pixelformat = dev->fbuf.fmt.pixelformat;
+
+	fb_buf = (dma_addr_t)dev->fbuf.base;
+
+	priv->buf_num = 0;
+
+	if (priv->rot_mode >= IPU_ROTATE_90_RIGHT)
+		err = preview_setup_rotation(priv, fb_buf, fb_buf,
+					     &inf, &outf);
+	else
+		err = preview_setup_norotation(priv, fb_buf, fb_buf,
+					       &inf, &outf);
+	if (err)
+		goto out_put_ipu;
+
+	priv->nfb4eof_irq = ipu_idmac_channel_irq(dev->ipu,
+						  priv->preview_ch,
+						  IPU_IRQ_NFB4EOF);
+	err = devm_request_irq(dev->dev, priv->nfb4eof_irq,
+			       preview_nfb4eof_interrupt, 0,
+			       "mx6cam-preview-nfb4eof", priv);
+	if (err) {
+		v4l2_err(&priv->sd,
+			 "Error registering preview NFB4EOF irq: %d\n", err);
+		goto out_put_ipu;
+	}
+
+	if (priv->rot_mode >= IPU_ROTATE_90_RIGHT)
+		priv->eof_irq = ipu_idmac_channel_irq(dev->ipu,
+						      priv->preview_rot_out_ch,
+						      IPU_IRQ_EOF);
+	else
+		priv->eof_irq = ipu_idmac_channel_irq(dev->ipu,
+						      priv->preview_ch,
+						      IPU_IRQ_EOF);
+
+	err = devm_request_irq(dev->dev, priv->eof_irq,
+			       preview_eof_interrupt, 0,
+			       "mx6cam-preview-eof", priv);
+	if (err) {
+		v4l2_err(&priv->sd,
+			 "Error registering preview eof irq: %d\n", err);
+		goto out_free_nfb4eof_irq;
+	}
+
+	err = ipu_csi_enable(priv->csi);
+	if (err) {
+		v4l2_err(&priv->sd, "CSI enable error: %d\n", err);
+		goto out_free_eof_irq;
+	}
+
+	priv->preview_active = true;
+
+	/* start the VF EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(MX6CAM_EOF_TIMEOUT));
+
+	return 0;
+
+out_free_eof_irq:
+	devm_free_irq(dev->dev, priv->eof_irq, priv);
+out_free_nfb4eof_irq:
+	devm_free_irq(dev->dev, priv->nfb4eof_irq, priv);
+out_put_ipu:
+	preview_put_ipu_resources(priv);
+	return err;
+}
+
+static int preview_stop(struct preview_priv *priv)
+{
+	struct mx6cam_dev *dev = priv->dev;
+	int ret;
+
+	if (!priv->preview_active)
+		return 0;
+
+	/* stop the VF EOF timeout timer */
+	del_timer_sync(&priv->eof_timeout_timer);
+
+	/*
+	 * Mark next EOF interrupt as the last before preview off,
+	 * and then wait for interrupt handler to mark completion.
+	 */
+	init_completion(&priv->last_eof_comp);
+	priv->last_eof = true;
+	ret = wait_for_completion_timeout(&priv->last_eof_comp,
+					  msecs_to_jiffies(MX6CAM_EOF_TIMEOUT));
+	if (ret == 0)
+		v4l2_warn(&priv->sd, "wait last preview EOF timeout\n");
+
+	ipu_csi_disable(priv->csi);
+
+	devm_free_irq(dev->dev, priv->eof_irq, priv);
+	devm_free_irq(dev->dev, priv->nfb4eof_irq, priv);
+
+	/* disable IC tasks and the channels */
+	ipu_ic_task_disable(priv->ic_vf);
+
+	ipu_idmac_disable_channel(priv->preview_ch);
+	if (priv->rot_mode >= IPU_ROTATE_90_RIGHT) {
+		ipu_idmac_disable_channel(priv->preview_rot_in_ch);
+		ipu_idmac_disable_channel(priv->preview_rot_out_ch);
+	}
+
+	if (priv->rot_mode >= IPU_ROTATE_90_RIGHT)
+		ipu_unlink_prpvf_rot_prpvf(dev->ipu);
+
+	ipu_ic_disable(priv->ic_vf);
+	if (priv->rot_mode >= IPU_ROTATE_90_RIGHT)
+		ipu_irt_disable(priv->irt);
+
+	preview_free_dma_buf(priv, &priv->rot_buf[0]);
+	preview_free_dma_buf(priv, &priv->rot_buf[1]);
+
+	preview_put_ipu_resources(priv);
+
+	priv->preview_active = false;
+	return 0;
+}
+
+static int preview_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct preview_priv *priv = v4l2_get_subdevdata(sd);
+
+	if (enable)
+		return preview_start(priv);
+	else
+		return preview_stop(priv);
+}
+
+static void preview_unregistered(struct v4l2_subdev *sd)
+{
+	struct preview_priv *priv = v4l2_get_subdevdata(sd);
+
+	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+}
+
+/* Controls */
+
+static int preview_set_rotation(struct preview_priv *priv,
+				int rotation, bool hflip, bool vflip)
+{
+	struct mx6cam_dev *dev = priv->dev;
+	enum ipu_rotate_mode rot_mode;
+	int ret;
+
+	ret = ipu_degrees_to_rot_mode(&rot_mode, rotation,
+				      hflip, vflip);
+	if (ret)
+		return ret;
+
+	priv->rotation = rotation;
+	priv->hflip = hflip;
+	priv->vflip = vflip;
+
+	if (rot_mode != priv->rot_mode) {
+		if (dev->preview_on)
+			preview_stop(priv);
+		priv->rot_mode = rot_mode;
+		if (dev->preview_on)
+			preview_start(priv);
+	}
+
+	return 0;
+}
+
+static int preview_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct preview_priv *priv = container_of(ctrl->handler,
+						 struct preview_priv,
+						 ctrl_hdlr);
+	struct mx6cam_dev *dev = priv->dev;
+	bool hflip, vflip;
+	int rotation;
+
+	rotation = priv->rotation;
+	hflip = priv->hflip;
+	vflip = priv->vflip;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		hflip = (ctrl->val == 1);
+		break;
+	case V4L2_CID_VFLIP:
+		vflip = (ctrl->val == 1);
+		break;
+	case V4L2_CID_ROTATE:
+		rotation = ctrl->val;
+		break;
+	default:
+
+		v4l2_err(&dev->v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+
+	return preview_set_rotation(priv, rotation, hflip, vflip);
+}
+
+static const struct v4l2_ctrl_ops preview_ctrl_ops = {
+	.s_ctrl = preview_s_ctrl,
+};
+
+static int preview_setup_controls(struct preview_priv *priv)
+{
+	struct v4l2_ctrl_handler *hdlr = &priv->ctrl_hdlr;
+	int ret;
+
+	v4l2_ctrl_handler_init(hdlr, 3);
+
+	v4l2_ctrl_new_std(hdlr, &preview_ctrl_ops, V4L2_CID_HFLIP,
+			  0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdlr, &preview_ctrl_ops, V4L2_CID_VFLIP,
+			  0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdlr, &preview_ctrl_ops, V4L2_CID_ROTATE,
+			  0, 270, 90, 0);
+
+	priv->sd.ctrl_handler = hdlr;
+
+	if (hdlr->error) {
+		ret = hdlr->error;
+		v4l2_ctrl_handler_free(hdlr);
+		return ret;
+	}
+
+	v4l2_ctrl_handler_setup(hdlr);
+
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops preview_core_ops = {
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
+};
+
+static struct v4l2_subdev_video_ops preview_video_ops = {
+	.s_stream = preview_s_stream,
+};
+
+static struct v4l2_subdev_ops preview_subdev_ops = {
+	.core = &preview_core_ops,
+	.video = &preview_video_ops,
+};
+
+static struct v4l2_subdev_internal_ops preview_internal_ops = {
+	.unregistered = preview_unregistered,
+};
+
+struct v4l2_subdev *mx6cam_preview_init(struct mx6cam_dev *dev)
+{
+	struct preview_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(dev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	init_timer(&priv->eof_timeout_timer);
+	priv->eof_timeout_timer.data = (unsigned long)priv;
+	priv->eof_timeout_timer.function = preview_eof_timeout;
+
+	v4l2_subdev_init(&priv->sd, &preview_subdev_ops);
+	strlcpy(priv->sd.name, "mx6-camera-preview", sizeof(priv->sd.name));
+	v4l2_set_subdevdata(&priv->sd, priv);
+	priv->sd.internal_ops = &preview_internal_ops;
+	priv->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	ret = preview_setup_controls(priv);
+	if (ret) {
+		kfree(priv);
+		return ERR_PTR(ret);
+	}
+
+	priv->dev = dev;
+	return &priv->sd;
+}
diff --git a/include/media/imx6.h b/include/media/imx6.h
new file mode 100644
index 0000000..232378b
--- /dev/null
+++ b/include/media/imx6.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (c) 2014 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#ifndef __MEDIA_IMX6_H__
+#define __MEDIA_IMX6_H__
+
+/*
+ * Analog decoder status change notifications
+ */
+#define DECODER_STATUS_CHANGE_NOTIFY  _IO('7', 0)
+
+#endif
-- 
1.7.9.5

