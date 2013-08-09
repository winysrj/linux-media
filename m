Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031460Ab3HIXC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:28 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 09/19] video: panel: Add DPI panel support
Date: Sat, 10 Aug 2013 01:03:08 +0200
Message-Id: <1376089398-13322-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Display Pixel Interface is a configurable-width video-only
unidirectional parallel bus standard that defines video formats and
signaling for panel devices.

This driver implements support for simple DPI panels with no runtime
configuration capabilities (GPIOs- and/or regulators-based control can
be implemented later when needed) and exposes it as a display entity.
The panel native video mode is passed to the driver through platform
data or device tree properties.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/display/Kconfig     |  10 ++
 drivers/video/display/Makefile    |   1 +
 drivers/video/display/panel-dpi.c | 207 ++++++++++++++++++++++++++++++++++++++
 include/video/panel-dpi.h         |  24 +++++
 4 files changed, 242 insertions(+)
 create mode 100644 drivers/video/display/panel-dpi.c
 create mode 100644 include/video/panel-dpi.h

diff --git a/drivers/video/display/Kconfig b/drivers/video/display/Kconfig
index f7532c1..bce09d6 100644
--- a/drivers/video/display/Kconfig
+++ b/drivers/video/display/Kconfig
@@ -9,4 +9,14 @@ config DISPLAY_MIPI_DBI
 	tristate
 	default n
 
+config DISPLAY_PANEL_DPI
+	tristate "DPI (Parallel) Display Panels"
+	---help---
+	  Support for simple digital (parallel) pixel interface panels. Those
+	  panels receive pixel data through a parallel bus and have no control
+	  bus.
+
+	  If you are in doubt, say N. To compile this driver as a module, choose
+	  M here; the module will be called panel-dpi.
+
 endif # DISPLAY_CORE
diff --git a/drivers/video/display/Makefile b/drivers/video/display/Makefile
index 59022d2..31c017b 100644
--- a/drivers/video/display/Makefile
+++ b/drivers/video/display/Makefile
@@ -2,3 +2,4 @@ display-y					:= display-core.o \
 						   display-notifier.o
 obj-$(CONFIG_DISPLAY_CORE)			+= display.o
 obj-$(CONFIG_DISPLAY_MIPI_DBI)			+= mipi-dbi-bus.o
+obj-$(CONFIG_DISPLAY_PANEL_DPI)			+= panel-dpi.o
diff --git a/drivers/video/display/panel-dpi.c b/drivers/video/display/panel-dpi.c
new file mode 100644
index 0000000..b1ecf6d
--- /dev/null
+++ b/drivers/video/display/panel-dpi.c
@@ -0,0 +1,207 @@
+/*
+ * DPI Display Panel
+ *
+ * Copyright (C) 2012 Renesas Solutions Corp.
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
+#include <video/of_display_timing.h>
+#include <video/of_videomode.h>
+#include <video/panel-dpi.h>
+#include <video/videomode.h>
+
+struct panel_dpi {
+	struct display_entity entity;
+
+	unsigned int width;
+	unsigned int height;
+	struct videomode mode;
+};
+
+static inline struct panel_dpi *to_panel_dpi(struct display_entity *e)
+{
+	return container_of(e, struct panel_dpi, entity);
+}
+
+static const struct display_entity_interface_params panel_dpi_params = {
+	.type = DISPLAY_ENTITY_INTERFACE_DPI,
+};
+
+static int panel_dpi_set_state(struct display_entity *entity,
+			       enum display_entity_state state)
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
+static int panel_dpi_get_modes(struct display_entity *entity, unsigned int port,
+			       const struct videomode **modes)
+{
+	struct panel_dpi *panel = to_panel_dpi(entity);
+
+	*modes = &panel->mode;
+	return 1;
+}
+
+static int panel_dpi_get_size(struct display_entity *entity,
+			      unsigned int *width, unsigned int *height)
+{
+	struct panel_dpi *panel = to_panel_dpi(entity);
+
+	*width = panel->width;
+	*height = panel->height;
+	return 0;
+}
+
+static int panel_dpi_get_params(struct display_entity *entity,
+				unsigned int port,
+				struct display_entity_interface_params *params)
+{
+	*params = panel_dpi_params;
+	return 0;
+}
+
+static const struct display_entity_control_ops panel_dpi_control_ops = {
+	.set_state = panel_dpi_set_state,
+	.get_modes = panel_dpi_get_modes,
+	.get_size = panel_dpi_get_size,
+	.get_params = panel_dpi_get_params,
+};
+
+static const struct display_entity_ops panel_dpi_ops = {
+	.ctrl = &panel_dpi_control_ops,
+};
+
+static int panel_dpi_remove(struct platform_device *pdev)
+{
+	struct panel_dpi *panel = platform_get_drvdata(pdev);
+
+	display_entity_remove(&panel->entity);
+	display_entity_cleanup(&panel->entity);
+
+	return 0;
+}
+
+static int panel_dpi_parse_pdata(struct panel_dpi *panel,
+				 struct platform_device *pdev)
+{
+	const struct panel_dpi_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
+	int ret;
+
+	if (pdata) {
+		panel->width = pdata->width;
+		panel->height = pdata->height;
+		panel->mode = *pdata->mode;
+	} else if (IS_ENABLED(CONFIG_OF) && np) {
+		/* Width and height are optional. */
+		of_property_read_u32(np, "width-mm", &panel->width);
+		of_property_read_u32(np, "height-mm", &panel->height);
+
+		ret = of_get_videomode(np, &panel->mode, OF_USE_NATIVE_MODE);
+		if (ret < 0)
+			return ret;
+	} else {
+		dev_err(&pdev->dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int panel_dpi_probe(struct platform_device *pdev)
+{
+	struct panel_dpi *panel;
+	int ret;
+
+	panel = devm_kzalloc(&pdev->dev, sizeof(*panel), GFP_KERNEL);
+	if (panel == NULL)
+		return -ENOMEM;
+
+	ret = panel_dpi_parse_pdata(panel, pdev);
+	if (ret < 0)
+		return ret;
+
+	panel->entity.dev = &pdev->dev;
+	panel->entity.ops = &panel_dpi_ops;
+	strlcpy(panel->entity.name, "panel-dpi", sizeof(panel->entity.name));
+
+	ret = display_entity_init(&panel->entity, 1, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = display_entity_add(&panel->entity);
+	if (ret < 0)
+		return ret;
+
+	platform_set_drvdata(pdev, panel);
+
+	return 0;
+}
+
+static const struct dev_pm_ops panel_dpi_dev_pm_ops = {
+};
+
+static struct platform_device_id panel_dpi_id_table[] = {
+	{ "panel-dpi", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, panel_dpi_id_table);
+
+#ifdef CONFIG_OF
+static struct of_device_id panel_dpi_of_id_table[] = {
+	{ .compatible = "panel-dpi", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, panel_dpi_of_id_table);
+#endif
+
+static struct platform_driver panel_dpi_driver = {
+	.probe = panel_dpi_probe,
+	.remove = panel_dpi_remove,
+	.id_table = panel_dpi_id_table,
+	.driver = {
+		.name = "panel-dpi",
+		.owner = THIS_MODULE,
+		.pm = &panel_dpi_dev_pm_ops,
+		.of_match_table = of_match_ptr(panel_dpi_of_id_table),
+	},
+};
+
+module_platform_driver(panel_dpi_driver);
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("DPI Display Panel");
+MODULE_LICENSE("GPL");
diff --git a/include/video/panel-dpi.h b/include/video/panel-dpi.h
new file mode 100644
index 0000000..af85d5b
--- /dev/null
+++ b/include/video/panel-dpi.h
@@ -0,0 +1,24 @@
+/*
+ * DPI Display Panel
+ *
+ * Copyright (C) 2012 Renesas Solutions Corp.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __PANEL_DPI_H__
+#define __PANEL_DPI_H__
+
+struct videomode;
+
+struct panel_dpi_platform_data {
+	unsigned long width;		/* Panel width in mm */
+	unsigned long height;		/* Panel height in mm */
+	const struct videomode *mode;
+};
+
+#endif /* __PANEL_DPI_H__ */
-- 
1.8.1.5

