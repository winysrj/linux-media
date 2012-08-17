Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46753 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab2HQAtf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 20:49:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org
Cc: linux-media@vger.kernel.org, Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [RFC 3/5] video: panel: Add MIPI DBI bus support
Date: Fri, 17 Aug 2012 02:49:41 +0200
Message-Id: <1345164583-18924-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/panel/Kconfig     |    4 +
 drivers/video/panel/Makefile    |    1 +
 drivers/video/panel/panel-dbi.c |  217 +++++++++++++++++++++++++++++++++++++++
 include/video/panel-dbi.h       |   92 +++++++++++++++++
 4 files changed, 314 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/panel/panel-dbi.c
 create mode 100644 include/video/panel-dbi.h

diff --git a/drivers/video/panel/Kconfig b/drivers/video/panel/Kconfig
index 36fb9ca..fd0b3cf 100644
--- a/drivers/video/panel/Kconfig
+++ b/drivers/video/panel/Kconfig
@@ -12,4 +12,8 @@ config DISPLAY_PANEL_DUMMY
 
 	  If you are in doubt, say N.
 
+config DISPLAY_PANEL_DBI
+	tristate
+	default n
+
 endif # DISPLAY_PANEL
diff --git a/drivers/video/panel/Makefile b/drivers/video/panel/Makefile
index 9fc05c2..2ab0520 100644
--- a/drivers/video/panel/Makefile
+++ b/drivers/video/panel/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_DISPLAY_PANEL) += panel.o
 obj-$(CONFIG_DISPLAY_PANEL_DUMMY) += panel-dummy.o
+obj-$(CONFIG_DISPLAY_PANEL_DBI) += panel-dbi.o
diff --git a/drivers/video/panel/panel-dbi.c b/drivers/video/panel/panel-dbi.c
new file mode 100644
index 0000000..0511997
--- /dev/null
+++ b/drivers/video/panel/panel-dbi.c
@@ -0,0 +1,217 @@
+/*
+ * MIPI DBI Bus
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
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
+
+#include <video/panel-dbi.h>
+
+/* -----------------------------------------------------------------------------
+ * Bus operations
+ */
+
+void panel_dbi_write_command(struct panel_dbi_device *dev, unsigned long cmd)
+{
+	dev->bus->ops->write_command(dev->bus, cmd);
+}
+EXPORT_SYMBOL_GPL(panel_dbi_write_command);
+
+void panel_dbi_write_data(struct panel_dbi_device *dev, unsigned long data)
+{
+	dev->bus->ops->write_data(dev->bus, data);
+}
+EXPORT_SYMBOL_GPL(panel_dbi_write_data);
+
+unsigned long panel_dbi_read_data(struct panel_dbi_device *dev)
+{
+	return dev->bus->ops->read_data(dev->bus);
+}
+EXPORT_SYMBOL_GPL(panel_dbi_read_data);
+
+/* -----------------------------------------------------------------------------
+ * Bus type
+ */
+
+static const struct panel_dbi_device_id *
+panel_dbi_match_id(const struct panel_dbi_device_id *id,
+		   struct panel_dbi_device *dev)
+{
+	while (id->name[0]) {
+		if (strcmp(dev->name, id->name) == 0) {
+			dev->id_entry = id;
+			return id;
+		}
+		id++;
+	}
+	return NULL;
+}
+
+static int panel_dbi_match(struct device *_dev, struct device_driver *_drv)
+{
+	struct panel_dbi_device *dev = to_panel_dbi_device(_dev);
+	struct panel_dbi_driver *drv = to_panel_dbi_driver(_drv);
+
+	if (drv->id_table)
+		return panel_dbi_match_id(drv->id_table, dev) != NULL;
+
+	return (strcmp(dev->name, _drv->name) == 0);
+}
+
+static ssize_t modalias_show(struct device *_dev, struct device_attribute *a,
+			     char *buf)
+{
+	struct panel_dbi_device *dev = to_panel_dbi_device(_dev);
+	int len = snprintf(buf, PAGE_SIZE, PANEL_DBI_MODULE_PREFIX "%s\n",
+			   dev->name);
+
+	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
+}
+
+static struct device_attribute panel_dbi_dev_attrs[] = {
+	__ATTR_RO(modalias),
+	__ATTR_NULL,
+};
+
+static int panel_dbi_uevent(struct device *_dev, struct kobj_uevent_env *env)
+{
+	struct panel_dbi_device *dev = to_panel_dbi_device(_dev);
+
+	add_uevent_var(env, "MODALIAS=%s%s", PANEL_DBI_MODULE_PREFIX,
+		       dev->name);
+	return 0;
+}
+
+static const struct dev_pm_ops panel_dbi_dev_pm_ops = {
+	.runtime_suspend = pm_generic_runtime_suspend,
+	.runtime_resume = pm_generic_runtime_resume,
+	.runtime_idle = pm_generic_runtime_idle,
+	.suspend = pm_generic_suspend,
+	.resume = pm_generic_resume,
+	.freeze = pm_generic_freeze,
+	.thaw = pm_generic_thaw,
+	.poweroff = pm_generic_poweroff,
+	.restore = pm_generic_restore,
+};
+
+static struct bus_type panel_dbi_bus_type = {
+	.name		= "mipi-dbi",
+	.dev_attrs	= panel_dbi_dev_attrs,
+	.match		= panel_dbi_match,
+	.uevent		= panel_dbi_uevent,
+	.pm		= &panel_dbi_dev_pm_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Device and driver (un)registration
+ */
+
+/**
+ * panel_dbi_device_register - register a DBI device
+ * @dev: DBI device we're registering
+ */
+int panel_dbi_device_register(struct panel_dbi_device *dev,
+			      struct panel_dbi_bus *bus)
+{
+	device_initialize(&dev->dev);
+
+	dev->bus = bus;
+	dev->dev.bus = &panel_dbi_bus_type;
+	dev->dev.parent = bus->dev;
+
+	if (dev->id != -1)
+		dev_set_name(&dev->dev, "%s.%d", dev->name,  dev->id);
+	else
+		dev_set_name(&dev->dev, "%s", dev->name);
+
+	return device_add(&dev->dev);
+}
+EXPORT_SYMBOL_GPL(panel_dbi_device_register);
+
+/**
+ * panel_dbi_device_unregister - unregister a DBI device
+ * @dev: DBI device we're unregistering
+ */
+void panel_dbi_device_unregister(struct panel_dbi_device *dev)
+{
+	device_del(&dev->dev);
+	put_device(&dev->dev);
+}
+EXPORT_SYMBOL_GPL(panel_dbi_device_unregister);
+
+static int panel_dbi_drv_probe(struct device *_dev)
+{
+	struct panel_dbi_driver *drv = to_panel_dbi_driver(_dev->driver);
+	struct panel_dbi_device *dev = to_panel_dbi_device(_dev);
+
+	return drv->probe(dev);
+}
+
+static int panel_dbi_drv_remove(struct device *_dev)
+{
+	struct panel_dbi_driver *drv = to_panel_dbi_driver(_dev->driver);
+	struct panel_dbi_device *dev = to_panel_dbi_device(_dev);
+
+	return drv->remove(dev);
+}
+
+/**
+ * panel_dbi_driver_register - register a driver for DBI devices
+ * @drv: DBI driver structure
+ */
+int panel_dbi_driver_register(struct panel_dbi_driver *drv)
+{
+	drv->driver.bus = &panel_dbi_bus_type;
+	if (drv->probe)
+		drv->driver.probe = panel_dbi_drv_probe;
+	if (drv->remove)
+		drv->driver.remove = panel_dbi_drv_remove;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(panel_dbi_driver_register);
+
+/**
+ * panel_dbi_driver_unregister - unregister a driver for DBI devices
+ * @drv: DBI driver structure
+ */
+void panel_dbi_driver_unregister(struct panel_dbi_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(panel_dbi_driver_unregister);
+
+/* -----------------------------------------------------------------------------
+ * Init/exit
+ */
+
+static int __init panel_dbi_init(void)
+{
+	return bus_register(&panel_dbi_bus_type);
+}
+
+static void __exit panel_dbi_exit(void)
+{
+	bus_unregister(&panel_dbi_bus_type);
+}
+
+module_init(panel_dbi_init);
+module_exit(panel_dbi_exit)
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("MIPI DBI Bus");
+MODULE_LICENSE("GPL");
diff --git a/include/video/panel-dbi.h b/include/video/panel-dbi.h
new file mode 100644
index 0000000..799ac41
--- /dev/null
+++ b/include/video/panel-dbi.h
@@ -0,0 +1,92 @@
+/*
+ * MIPI DBI Bus
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
+#ifndef __PANEL_DBI_H__
+#define __PANEL_DBI_H__
+
+#include <linux/device.h>
+#include <video/panel.h>
+
+struct panel_dbi_bus;
+
+struct panel_dbi_bus_ops {
+	void (*write_command)(struct panel_dbi_bus *bus, unsigned long cmd);
+	void (*write_data)(struct panel_dbi_bus *bus, unsigned long data);
+	unsigned long (*read_data)(struct panel_dbi_bus *bus);
+};
+
+struct panel_dbi_bus {
+	struct device *dev;
+	const struct panel_dbi_bus_ops *ops;
+};
+
+#define PANEL_DBI_MODULE_PREFIX		"mipi-dbi:"
+#define PANEL_DBI_NAME_SIZE		32
+
+struct panel_dbi_device_id {
+	char name[PANEL_DBI_NAME_SIZE];
+	kernel_ulong_t driver_data	/* Data private to the driver */
+			__aligned(sizeof(kernel_ulong_t));
+};
+
+struct panel_dbi_device {
+	const char *name;
+	int id;
+	struct device dev;
+
+	const struct panel_dbi_device_id *id_entry;
+	struct panel_dbi_bus *bus;
+};
+
+#define to_panel_dbi_device(d)	container_of(d, struct panel_dbi_device, dev)
+
+int panel_dbi_device_register(struct panel_dbi_device *dev,
+			      struct panel_dbi_bus *bus);
+void panel_dbi_device_unregister(struct panel_dbi_device *dev);
+
+struct panel_dbi_driver {
+	int(*probe)(struct panel_dbi_device *);
+	int(*remove)(struct panel_dbi_device *);
+	struct device_driver driver;
+	const struct panel_dbi_device_id *id_table;
+};
+
+#define to_panel_dbi_driver(d)	container_of(d, struct panel_dbi_driver, driver)
+
+int panel_dbi_driver_register(struct panel_dbi_driver *drv);
+void panel_dbi_driver_unregister(struct panel_dbi_driver *drv);
+
+static inline void *panel_dbi_get_drvdata(const struct panel_dbi_device *dev)
+{
+	return dev_get_drvdata(&dev->dev);
+}
+
+static inline void panel_dbi_set_drvdata(struct panel_dbi_device *dev,
+					 void *data)
+{
+	dev_set_drvdata(&dev->dev, data);
+}
+
+/* module_panel_dbi_driver() - Helper macro for drivers that don't do
+ * anything special in module init/exit.  This eliminates a lot of
+ * boilerplate.  Each module may only use this macro once, and
+ * calling it replaces module_init() and module_exit()
+ */
+#define module_panel_dbi_driver(__panel_dbi_driver) \
+	module_driver(__panel_dbi_driver, panel_dbi_driver_register, \
+			panel_dbi_driver_unregister)
+
+void panel_dbi_write_command(struct panel_dbi_device *dev, unsigned long cmd);
+void panel_dbi_write_data(struct panel_dbi_device *dev, unsigned long data);
+unsigned long panel_dbi_read_data(struct panel_dbi_device *dev);
+
+#endif /* __PANEL_DBI__ */
-- 
1.7.8.6

