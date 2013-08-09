Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54864 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031442Ab3HIXCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:30 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 12/19] video: display: Add VGA Digital to Analog Converter support
Date: Sat, 10 Aug 2013 01:03:11 +0200
Message-Id: <1376089398-13322-13-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver implements support for VGA Digital to Analog Converters
(DACs) that receive pixel data through a DPI interface and have no
control interface (GPIOs- and/or regulators-based control can be
implemented later when needed). It exposes the devices a display
entities.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/video/display/Kconfig   |   9 +++
 drivers/video/display/Makefile  |   1 +
 drivers/video/display/vga-dac.c | 152 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 162 insertions(+)
 create mode 100644 drivers/video/display/vga-dac.c

diff --git a/drivers/video/display/Kconfig b/drivers/video/display/Kconfig
index 9b44b5f..32ce08d 100644
--- a/drivers/video/display/Kconfig
+++ b/drivers/video/display/Kconfig
@@ -39,4 +39,13 @@ config DISPLAY_PANEL_R61517
 	  If you are in doubt, say N. To compile this driver as a module, choose
 	  M here; the module will be called panel-r61517.
 
+config DISPLAY_VGA_DAC
+	tristate "VGA Digital to Analog Converters"
+	---help---
+	  Support for simple VGA digital to analog converters. Those converters
+	  receive pixel data through a parallel bus and have no control bus.
+
+	  If you are in doubt, say N. To compile this driver as a module, choose
+	  M here: the module will be called vga-dac.
+
 endif # DISPLAY_CORE
diff --git a/drivers/video/display/Makefile b/drivers/video/display/Makefile
index 1cdc8d4..43cd78d 100644
--- a/drivers/video/display/Makefile
+++ b/drivers/video/display/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_DISPLAY_MIPI_DBI)			+= mipi-dbi-bus.o
 obj-$(CONFIG_DISPLAY_PANEL_DPI)			+= panel-dpi.o
 obj-$(CONFIG_DISPLAY_PANEL_R61505)		+= panel-r61505.o
 obj-$(CONFIG_DISPLAY_PANEL_R61517)		+= panel-r61517.o
+obj-$(CONFIG_DISPLAY_VGA_DAC)			+= vga-dac.o
diff --git a/drivers/video/display/vga-dac.c b/drivers/video/display/vga-dac.c
new file mode 100644
index 0000000..d0256e6
--- /dev/null
+++ b/drivers/video/display/vga-dac.c
@@ -0,0 +1,152 @@
+/*
+ * VGA Digital to Analog Converter
+ *
+ * Copyright (C) 2013 Renesas Solutions Corp.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include <video/display.h>
+
+#define VGA_DAC_PORT_SINK		0
+#define VGA_DAC_PORT_SOURCE		1
+
+struct vga_dac {
+	struct display_entity entity;
+};
+
+static inline struct vga_dac *to_vga_dac(struct display_entity *e)
+{
+	return container_of(e, struct vga_dac, entity);
+}
+
+static int vga_dac_set_state(struct display_entity *entity,
+			     enum display_entity_state state)
+{
+	struct media_pad *source;
+
+	source = media_entity_remote_pad(&entity->entity.pads[0]);
+	if (source == NULL)
+		return -EPIPE;
+
+	switch (state) {
+	case DISPLAY_ENTITY_STATE_OFF:
+	case DISPLAY_ENTITY_STATE_STANDBY:
+		display_entity_set_stream(to_display_entity(source->entity),
+					  source->index,
+					  DISPLAY_ENTITY_STREAM_STOPPED);
+		break;
+
+	case DISPLAY_ENTITY_STATE_ON:
+		display_entity_set_stream(to_display_entity(source->entity),
+					  source->index,
+					  DISPLAY_ENTITY_STREAM_CONTINUOUS);
+		break;
+	}
+
+	return 0;
+}
+
+static int vga_dac_get_params(struct display_entity *entity, unsigned int port,
+			      struct display_entity_interface_params *params)
+{
+	memset(params, 0, sizeof(*params));
+
+	if (port == VGA_DAC_PORT_SINK)
+		params->type = DISPLAY_ENTITY_INTERFACE_DPI;
+	else
+		params->type = DISPLAY_ENTITY_INTERFACE_VGA;
+
+	return 0;
+}
+
+static const struct display_entity_control_ops vga_dac_control_ops = {
+	.set_state = vga_dac_set_state,
+	.get_params = vga_dac_get_params,
+};
+
+static const struct display_entity_ops vga_dac_ops = {
+	.ctrl = &vga_dac_control_ops,
+};
+
+static int vga_dac_remove(struct platform_device *pdev)
+{
+	struct vga_dac *dac = platform_get_drvdata(pdev);
+
+	display_entity_remove(&dac->entity);
+	display_entity_cleanup(&dac->entity);
+
+	return 0;
+}
+
+static int vga_dac_probe(struct platform_device *pdev)
+{
+	struct vga_dac *dac;
+	int ret;
+
+	dac = devm_kzalloc(&pdev->dev, sizeof(*dac), GFP_KERNEL);
+	if (dac == NULL)
+		return -ENOMEM;
+
+	dac->entity.dev = &pdev->dev;
+	dac->entity.ops = &vga_dac_ops;
+	strlcpy(dac->entity.name, dev_name(&pdev->dev),
+		sizeof(dac->entity.name));
+
+	ret = display_entity_init(&dac->entity, 1, 1);
+	if (ret < 0)
+		return ret;
+
+	ret = display_entity_add(&dac->entity);
+	if (ret < 0)
+		return ret;
+
+	platform_set_drvdata(pdev, dac);
+
+	return 0;
+}
+
+static const struct dev_pm_ops vga_dac_dev_pm_ops = {
+};
+
+static struct platform_device_id vga_dac_id_table[] = {
+	{ "adv7123", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, vga_dac_id_table);
+
+#ifdef CONFIG_OF
+static struct of_device_id vga_dac_of_id_table[] = {
+	{ .compatible = "adi,adv7123", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, vga_dac_of_id_table);
+#endif
+
+static struct platform_driver vga_dac_driver = {
+	.probe = vga_dac_probe,
+	.remove = vga_dac_remove,
+	.id_table = vga_dac_id_table,
+	.driver = {
+		.name = "vga-dac",
+		.owner = THIS_MODULE,
+		.pm = &vga_dac_dev_pm_ops,
+		.of_match_table = of_match_ptr(vga_dac_of_id_table),
+	},
+};
+
+module_platform_driver(vga_dac_driver);
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("VGA Digital-to-Analog Converter");
+MODULE_LICENSE("GPL");
-- 
1.8.1.5

