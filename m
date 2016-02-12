Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52570 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbcBLCAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 21:00:35 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH/RFC 3/9] v4l: Add Renesas R-Car FCP driver
Date: Fri, 12 Feb 2016 04:00:44 +0200
Message-Id: <1455242450-24493-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FCP is a companion module of video processing modules in the
Renesas R-Car Gen3 SoCs. It provides data compression and decompression,
data caching, and converting of AXI transaction in order to reduce the
memory bandwidth.

The driver is not meant to be used standalone but provides an API to the
video processing modules to control the FCP.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../devicetree/bindings/media/renesas,fcp.txt      |  24 +++
 MAINTAINERS                                        |  10 ++
 drivers/media/platform/Kconfig                     |  13 ++
 drivers/media/platform/Makefile                    |   1 +
 drivers/media/platform/rcar-fcp.c                  | 176 +++++++++++++++++++++
 include/media/rcar-fcp.h                           |  34 ++++
 6 files changed, 258 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,fcp.txt
 create mode 100644 drivers/media/platform/rcar-fcp.c
 create mode 100644 include/media/rcar-fcp.h

diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt b/Documentation/devicetree/bindings/media/renesas,fcp.txt
new file mode 100644
index 000000000000..b454a3caf3c9
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
@@ -0,0 +1,24 @@
+Renesas R-Car Frame Compression Processor (FCP)
+-----------------------------------------------
+
+The FCP is a companion module of video processing modules in the Renesas R-Car
+Gen3 SoCs. It provides data compression and decompression, data caching, and
+converting of AXI transaction in order to reduce the memory bandwidth.
+
+There are three types of FCP whose configuration and behaviour highly depend
+on the module they are paired with.
+
+ - compatible: Must be one of the following
+   - "renesas,fcpv" for the 'FCP for VSP' device
+ - reg: the register base and size for the device registers
+ - clocks: Reference to the functional clock
+
+
+Device node example
+-------------------
+
+	fcpvd1: fcp@fea2f000 {
+		compatible = "renesas,fcpv";
+		reg = <0 0xfea2f000 0 0x200>;
+		clocks = <&cpg CPG_MOD 602>;
+	};
diff --git a/MAINTAINERS b/MAINTAINERS
index f07592658119..706f56e52888 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6933,6 +6933,16 @@ L:	linux-iio@vger.kernel.org
 S:	Maintained
 F:	drivers/iio/potentiometer/mcp4531.c
 
+MEDIA DRIVERS FOR RENESAS - FCP
+M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+L:	linux-media@vger.kernel.org
+L:	linux-renesas-soc@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Supported
+F:	Documentation/devicetree/bindings/media/renesas,fcp.txt
+F:	drivers/media/platform/rcar-fcp.c
+F:	include/media/rcar-fcp.h
+
 MEDIA DRIVERS FOR RENESAS - VSP1
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index fd4fcd5a7184..cbb4e5735bf8 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -255,6 +255,19 @@ config VIDEO_RENESAS_JPU
 	  To compile this driver as a module, choose M here: the module
 	  will be called rcar_jpu.
 
+config VIDEO_RENESAS_FCP
+	tristate "Renesas Frame Compression Processor"
+	depends on ARCH_SHMOBILE || COMPILE_TEST
+	depends on OF
+	---help---
+	  This is a driver for the Renesas Frame Compression Processor (FCP).
+	  The FCP is a companion module of video processing modules in the
+	  Renesas R-Car Gen3 SoCs. It handles memory access for the codec,
+	  VSP and FDP modules.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called rcar-fcp.
+
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 028a7233096b..b25735a24306 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
 obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
 
+obj-$(CONFIG_VIDEO_RENESAS_FCP) 	+= rcar-fcp.o
 obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
 
diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
new file mode 100644
index 000000000000..cf8cb629ae4f
--- /dev/null
+++ b/drivers/media/platform/rcar-fcp.c
@@ -0,0 +1,176 @@
+/*
+ * rcar-fcp.c  --  R-Car Frame Compression Processor Driver
+ *
+ * Copyright (C) 2016 Renesas Electronics Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+
+#include <media/rcar-fcp.h>
+
+struct rcar_fcp_device {
+	struct list_head list;
+	struct device *dev;
+};
+
+static LIST_HEAD(fcp_devices);
+static DEFINE_MUTEX(fcp_lock);
+
+/* -----------------------------------------------------------------------------
+ * Public API
+ */
+
+/**
+ * rcar_fcp_get - Find and acquire a reference to an FCP instance
+ * @np: Device node of the FCP instance
+ *
+ * Search the list of registered FCP instances for the instance corresponding to
+ * the given device node.
+ *
+ * Return a pointer to the FCP instance, or an ERR_PTR if the instance can't be
+ * found.
+ */
+struct rcar_fcp_device *rcar_fcp_get(const struct device_node *np)
+{
+	struct rcar_fcp_device *fcp;
+
+	mutex_lock(&fcp_lock);
+
+	list_for_each_entry(fcp, &fcp_devices, list) {
+		if (fcp->dev->of_node != np)
+			continue;
+
+		/*
+		 * Make sure the module won't be unloaded behind our back. This
+		 * is a poor's man safety net, the module should really not be
+		 * unloaded while FCP users can be active.
+		 */
+		if (!try_module_get(fcp->dev->driver->owner))
+			fcp = NULL;
+
+		goto done;
+	}
+
+	fcp = ERR_PTR(-EPROBE_DEFER);
+
+done:
+	mutex_unlock(&fcp_lock);
+	return fcp;
+}
+EXPORT_SYMBOL_GPL(rcar_fcp_get);
+
+/**
+ * rcar_fcp_put - Release a reference to an FCP instance
+ * @fcp: The FCP instance
+ *
+ * Release the FCP instance acquired by a call to rcar_fcp_get().
+ */
+void rcar_fcp_put(struct rcar_fcp_device *fcp)
+{
+	if (fcp)
+		module_put(fcp->dev->driver->owner);
+}
+EXPORT_SYMBOL_GPL(rcar_fcp_put);
+
+/**
+ * rcar_fcp_enable - Enable an FCP
+ * @fcp: The FCP instance
+ *
+ * Before any memory access through an FCP is performed by a module, the FCP
+ * must be enabled by a call to this function. The enable calls are reference
+ * counted, each of them must be followed by one rcar_fcp_disable() call when
+ * no more memory transfer can occur through the FCP.
+ */
+void rcar_fcp_enable(struct rcar_fcp_device *fcp)
+{
+	if (fcp)
+		pm_runtime_get_sync(fcp->dev);
+}
+EXPORT_SYMBOL_GPL(rcar_fcp_enable);
+
+/**
+ * rcar_fcp_disable - Disable an FCP
+ * @fcp: The FCP instance
+ *
+ * This function is the counterpart of rcar_fcp_enable(). As enable calls are
+ * reference counted a disable call may not disable the FCP synchronously.
+ */
+void rcar_fcp_disable(struct rcar_fcp_device *fcp)
+{
+	if (fcp)
+		pm_runtime_put(fcp->dev);
+}
+EXPORT_SYMBOL_GPL(rcar_fcp_disable);
+
+/* -----------------------------------------------------------------------------
+ * Platform Driver
+ */
+
+static int rcar_fcp_probe(struct platform_device *pdev)
+{
+	struct rcar_fcp_device *fcp;
+
+	fcp = devm_kzalloc(&pdev->dev, sizeof(*fcp), GFP_KERNEL);
+	if (fcp == NULL)
+		return -ENOMEM;
+
+	fcp->dev = &pdev->dev;
+
+	pm_runtime_enable(&pdev->dev);
+
+	mutex_lock(&fcp_lock);
+	list_add_tail(&fcp->list, &fcp_devices);
+	mutex_unlock(&fcp_lock);
+
+	platform_set_drvdata(pdev, fcp);
+
+	return 0;
+}
+
+static int rcar_fcp_remove(struct platform_device *pdev)
+{
+	struct rcar_fcp_device *fcp = platform_get_drvdata(pdev);
+
+	mutex_lock(&fcp_lock);
+	list_del(&fcp->list);
+	mutex_unlock(&fcp_lock);
+
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
+static const struct of_device_id rcar_fcp_of_match[] = {
+	{ .compatible = "renesas,fcpv" },
+	{ },
+};
+
+static struct platform_driver rcar_fcp_platform_driver = {
+	.probe		= rcar_fcp_probe,
+	.remove		= rcar_fcp_remove,
+	.driver		= {
+		.name	= "rcar-fcp",
+		.of_match_table = rcar_fcp_of_match,
+		.suppress_bind_attrs = true,
+	},
+};
+
+module_platform_driver(rcar_fcp_platform_driver);
+
+MODULE_ALIAS("rcar-fcp");
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("Renesas FCP Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/media/rcar-fcp.h b/include/media/rcar-fcp.h
new file mode 100644
index 000000000000..4260cf48d3b1
--- /dev/null
+++ b/include/media/rcar-fcp.h
@@ -0,0 +1,34 @@
+/*
+ * rcar-fcp.h  --  R-Car Frame Compression Processor Driver
+ *
+ * Copyright (C) 2016 Renesas Electronics Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __MEDIA_RCAR_FCP_H__
+#define __MEDIA_RCAR_FCP_H__
+
+struct device_node;
+struct rcar_fcp_device;
+
+#if IS_ENABLED(CONFIG_VIDEO_RENESAS_FCP)
+struct rcar_fcp_device *rcar_fcp_get(const struct device_node *np);
+void rcar_fcp_put(struct rcar_fcp_device *fcp);
+void rcar_fcp_enable(struct rcar_fcp_device *fcp);
+void rcar_fcp_disable(struct rcar_fcp_device *fcp);
+#else
+static inline struct rcar_fcp_device *rcar_fcp_get(const struct device_node *np)
+{
+	return ERR_PTR(-ENOENT);
+}
+static inline void rcar_fcp_put(struct rcar_fcp_device *fcp) { }
+static inline void rcar_fcp_enable(struct rcar_fcp_device *fcp) { }
+static inline void rcar_fcp_disable(struct rcar_fcp_device *fcp) { }
+#endif
+
+#endif /* __MEDIA_RCAR_FCP_H__ */
-- 
2.4.10

