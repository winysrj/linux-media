Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031466Ab3HIXCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:30 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 13/19] video: display: Add VGA connector support
Date: Sat, 10 Aug 2013 01:03:12 +0200
Message-Id: <1376089398-13322-14-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver exposes VGA connectors as display entity devices. The
connectors are passive devices that pass analog VGA signals though. They
optionally cary DDC signals for bidirectional control communications
with the devices connected to the connectors.

EDID retrieval isn't supported yet.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/video/display/Kconfig   |  11 +++
 drivers/video/display/Makefile  |   1 +
 drivers/video/display/con-vga.c | 148 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 160 insertions(+)
 create mode 100644 drivers/video/display/con-vga.c

diff --git a/drivers/video/display/Kconfig b/drivers/video/display/Kconfig
index 32ce08d..9b482a8 100644
--- a/drivers/video/display/Kconfig
+++ b/drivers/video/display/Kconfig
@@ -5,6 +5,17 @@ menuconfig DISPLAY_CORE
 
 if DISPLAY_CORE
 
+
+config DISPLAY_CONNECTOR_VGA
+	tristate "VGA Connector"
+	---help---
+	  Support for simple digital (parallel) pixel interface panels. Those
+	  panels receive pixel data through a parallel bus and have no control
+	  bus.
+
+	  If you are in doubt, say N. To compile this driver as a module, choose
+	  M here; the module will be called con-vga.
+
 config DISPLAY_MIPI_DBI
 	tristate
 	default n
diff --git a/drivers/video/display/Makefile b/drivers/video/display/Makefile
index 43cd78d..d03c64a 100644
--- a/drivers/video/display/Makefile
+++ b/drivers/video/display/Makefile
@@ -1,6 +1,7 @@
 display-y					:= display-core.o \
 						   display-notifier.o
 obj-$(CONFIG_DISPLAY_CORE)			+= display.o
+obj-$(CONFIG_DISPLAY_CONNECTOR_VGA)		+= con-vga.o
 obj-$(CONFIG_DISPLAY_MIPI_DBI)			+= mipi-dbi-bus.o
 obj-$(CONFIG_DISPLAY_PANEL_DPI)			+= panel-dpi.o
 obj-$(CONFIG_DISPLAY_PANEL_R61505)		+= panel-r61505.o
diff --git a/drivers/video/display/con-vga.c b/drivers/video/display/con-vga.c
new file mode 100644
index 0000000..798ac9e
--- /dev/null
+++ b/drivers/video/display/con-vga.c
@@ -0,0 +1,148 @@
+/*
+ * VGA Connector
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
+struct con_vga {
+	struct display_entity entity;
+};
+
+static int con_vga_set_state(struct display_entity *entity,
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
+static int con_vga_get_modes(struct display_entity *entity, unsigned int port,
+			     const struct videomode **modes)
+{
+	/* TODO: Add EDID retrieval support. */
+	return 0;
+}
+
+static int con_vga_get_params(struct display_entity *entity, unsigned int port,
+			      struct display_entity_interface_params *params)
+{
+	memset(params, 0, sizeof(*params));
+
+	params->type = DISPLAY_ENTITY_INTERFACE_VGA;
+
+	return 0;
+}
+
+static const struct display_entity_control_ops con_vga_control_ops = {
+	.set_state = con_vga_set_state,
+	.get_modes = con_vga_get_modes,
+	.get_params = con_vga_get_params,
+};
+
+static const struct display_entity_ops con_vga_ops = {
+	.ctrl = &con_vga_control_ops,
+};
+
+static int con_vga_remove(struct platform_device *pdev)
+{
+	struct con_vga *con = platform_get_drvdata(pdev);
+
+	display_entity_remove(&con->entity);
+	display_entity_cleanup(&con->entity);
+
+	return 0;
+}
+
+static int con_vga_probe(struct platform_device *pdev)
+{
+	struct con_vga *con;
+	int ret;
+
+	con = devm_kzalloc(&pdev->dev, sizeof(*con), GFP_KERNEL);
+	if (con == NULL)
+		return -ENOMEM;
+
+	con->entity.dev = &pdev->dev;
+	con->entity.ops = &con_vga_ops;
+	strlcpy(con->entity.name, "vga-con", sizeof(con->entity.name));
+
+	ret = display_entity_init(&con->entity, 1, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = display_entity_add(&con->entity);
+	if (ret < 0)
+		return ret;
+
+	platform_set_drvdata(pdev, con);
+
+	return 0;
+}
+
+static const struct dev_pm_ops con_vga_dev_pm_ops = {
+};
+
+static struct platform_device_id con_vga_id_table[] = {
+	{ "con-vga", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, con_vga_id_table);
+
+#ifdef CONFIG_OF
+static struct of_device_id con_vga_of_id_table[] = {
+	{ .compatible = "con-vga", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, con_vga_of_id_table);
+#endif
+
+static struct platform_driver con_vga_driver = {
+	.probe = con_vga_probe,
+	.remove = con_vga_remove,
+	.id_table = con_vga_id_table,
+	.driver = {
+		.name = "con-vga",
+		.owner = THIS_MODULE,
+		.pm = &con_vga_dev_pm_ops,
+		.of_match_table = of_match_ptr(con_vga_of_id_table),
+	},
+};
+
+module_platform_driver(con_vga_driver);
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("VGA Connector");
+MODULE_LICENSE("GPL");
-- 
1.8.1.5

