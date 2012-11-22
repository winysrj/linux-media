Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38073 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2KVVop (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 16:44:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Inki Dae <inki.dae@samsung.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Tom Gall <tom.gall@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>
Subject: [RFC v2 3/5] video: display: Add MIPI DBI bus support
Date: Thu, 22 Nov 2012 22:45:34 +0100
Message-Id: <1353620736-6517-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/display/Kconfig        |    4 +
 drivers/video/display/Makefile       |    1 +
 drivers/video/display/mipi-dbi-bus.c |  228 ++++++++++++++++++++++++++++++++++
 include/video/display.h              |    5 +
 include/video/mipi-dbi-bus.h         |  125 +++++++++++++++++++
 5 files changed, 363 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/display/mipi-dbi-bus.c
 create mode 100644 include/video/mipi-dbi-bus.h

diff --git a/drivers/video/display/Kconfig b/drivers/video/display/Kconfig
index 0f9b990..b04c8be 100644
--- a/drivers/video/display/Kconfig
+++ b/drivers/video/display/Kconfig
@@ -5,6 +5,10 @@ menuconfig DISPLAY_CORE
 
 if DISPLAY_CORE
 
+config DISPLAY_MIPI_DBI
+	tristate
+	default n
+
 config DISPLAY_PANEL_DPI
 	tristate "DPI (Parallel) Display Panels"
 	---help---
diff --git a/drivers/video/display/Makefile b/drivers/video/display/Makefile
index 47978d4..00ef1c2 100644
--- a/drivers/video/display/Makefile
+++ b/drivers/video/display/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_DISPLAY_CORE) += display-core.o
+obj-$(CONFIG_DISPLAY_MIPI_DBI) += mipi-dbi-bus.o
 obj-$(CONFIG_DISPLAY_PANEL_DPI) += panel-dpi.o
diff --git a/drivers/video/display/mipi-dbi-bus.c b/drivers/video/display/mipi-dbi-bus.c
new file mode 100644
index 0000000..bd39a97
--- /dev/null
+++ b/drivers/video/display/mipi-dbi-bus.c
@@ -0,0 +1,228 @@
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
+#include <video/mipi-dbi-bus.h>
+
+/* -----------------------------------------------------------------------------
+ * Bus operations
+ */
+
+int mipi_dbi_set_data_width(struct mipi_dbi_device *dev, unsigned int width)
+{
+	if (width != 8 && width != 16)
+		return -EINVAL;
+
+	dev->data_width = width;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mipi_dbi_set_data_width);
+
+int mipi_dbi_write_command(struct mipi_dbi_device *dev, u16 cmd)
+{
+	return dev->bus->ops->write_command(dev->bus, dev, cmd);
+}
+EXPORT_SYMBOL_GPL(mipi_dbi_write_command);
+
+int mipi_dbi_write_data(struct mipi_dbi_device *dev, const u8 *data,
+			size_t len)
+{
+	return dev->bus->ops->write_data(dev->bus, dev, data, len);
+}
+EXPORT_SYMBOL_GPL(mipi_dbi_write_data);
+
+int mipi_dbi_read_data(struct mipi_dbi_device *dev, u8 *data, size_t len)
+{
+	return dev->bus->ops->read_data(dev->bus, dev, data, len);
+}
+EXPORT_SYMBOL_GPL(mipi_dbi_read_data);
+
+/* -----------------------------------------------------------------------------
+ * Bus type
+ */
+
+static const struct mipi_dbi_device_id *
+mipi_dbi_match_id(const struct mipi_dbi_device_id *id,
+		  struct mipi_dbi_device *dev)
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
+static int mipi_dbi_match(struct device *_dev, struct device_driver *_drv)
+{
+	struct mipi_dbi_device *dev = to_mipi_dbi_device(_dev);
+	struct mipi_dbi_driver *drv = to_mipi_dbi_driver(_drv);
+
+	if (drv->id_table)
+		return mipi_dbi_match_id(drv->id_table, dev) != NULL;
+
+	return (strcmp(dev->name, _drv->name) == 0);
+}
+
+static ssize_t modalias_show(struct device *_dev, struct device_attribute *a,
+			     char *buf)
+{
+	struct mipi_dbi_device *dev = to_mipi_dbi_device(_dev);
+	int len = snprintf(buf, PAGE_SIZE, MIPI_DBI_MODULE_PREFIX "%s\n",
+			   dev->name);
+
+	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
+}
+
+static struct device_attribute mipi_dbi_dev_attrs[] = {
+	__ATTR_RO(modalias),
+	__ATTR_NULL,
+};
+
+static int mipi_dbi_uevent(struct device *_dev, struct kobj_uevent_env *env)
+{
+	struct mipi_dbi_device *dev = to_mipi_dbi_device(_dev);
+
+	add_uevent_var(env, "MODALIAS=%s%s", MIPI_DBI_MODULE_PREFIX,
+		       dev->name);
+	return 0;
+}
+
+static const struct dev_pm_ops mipi_dbi_dev_pm_ops = {
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
+static struct bus_type mipi_dbi_bus_type = {
+	.name		= "mipi-dbi",
+	.dev_attrs	= mipi_dbi_dev_attrs,
+	.match		= mipi_dbi_match,
+	.uevent		= mipi_dbi_uevent,
+	.pm		= &mipi_dbi_dev_pm_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Device and driver (un)registration
+ */
+
+/**
+ * mipi_dbi_device_register - register a DBI device
+ * @dev: DBI device we're registering
+ */
+int mipi_dbi_device_register(struct mipi_dbi_device *dev,
+			      struct mipi_dbi_bus *bus)
+{
+	device_initialize(&dev->dev);
+
+	dev->bus = bus;
+	dev->dev.bus = &mipi_dbi_bus_type;
+	dev->dev.parent = bus->dev;
+
+	if (dev->id != -1)
+		dev_set_name(&dev->dev, "%s.%d", dev->name,  dev->id);
+	else
+		dev_set_name(&dev->dev, "%s", dev->name);
+
+	return device_add(&dev->dev);
+}
+EXPORT_SYMBOL_GPL(mipi_dbi_device_register);
+
+/**
+ * mipi_dbi_device_unregister - unregister a DBI device
+ * @dev: DBI device we're unregistering
+ */
+void mipi_dbi_device_unregister(struct mipi_dbi_device *dev)
+{
+	device_del(&dev->dev);
+	put_device(&dev->dev);
+}
+EXPORT_SYMBOL_GPL(mipi_dbi_device_unregister);
+
+static int mipi_dbi_drv_probe(struct device *_dev)
+{
+	struct mipi_dbi_driver *drv = to_mipi_dbi_driver(_dev->driver);
+	struct mipi_dbi_device *dev = to_mipi_dbi_device(_dev);
+
+	return drv->probe(dev);
+}
+
+static int mipi_dbi_drv_remove(struct device *_dev)
+{
+	struct mipi_dbi_driver *drv = to_mipi_dbi_driver(_dev->driver);
+	struct mipi_dbi_device *dev = to_mipi_dbi_device(_dev);
+
+	return drv->remove(dev);
+}
+
+/**
+ * mipi_dbi_driver_register - register a driver for DBI devices
+ * @drv: DBI driver structure
+ */
+int mipi_dbi_driver_register(struct mipi_dbi_driver *drv)
+{
+	drv->driver.bus = &mipi_dbi_bus_type;
+	if (drv->probe)
+		drv->driver.probe = mipi_dbi_drv_probe;
+	if (drv->remove)
+		drv->driver.remove = mipi_dbi_drv_remove;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(mipi_dbi_driver_register);
+
+/**
+ * mipi_dbi_driver_unregister - unregister a driver for DBI devices
+ * @drv: DBI driver structure
+ */
+void mipi_dbi_driver_unregister(struct mipi_dbi_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(mipi_dbi_driver_unregister);
+
+/* -----------------------------------------------------------------------------
+ * Init/exit
+ */
+
+static int __init mipi_dbi_init(void)
+{
+	return bus_register(&mipi_dbi_bus_type);
+}
+
+static void __exit mipi_dbi_exit(void)
+{
+	bus_unregister(&mipi_dbi_bus_type);
+}
+
+module_init(mipi_dbi_init);
+module_exit(mipi_dbi_exit)
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("MIPI DBI Bus");
+MODULE_LICENSE("GPL");
diff --git a/include/video/display.h b/include/video/display.h
index 90d18ca..75ba270 100644
--- a/include/video/display.h
+++ b/include/video/display.h
@@ -16,6 +16,7 @@
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <video/mipi-dbi-bus.h>
 
 /* -----------------------------------------------------------------------------
  * Display Entity
@@ -68,10 +69,14 @@ enum display_entity_stream_state {
 
 enum display_entity_interface_type {
 	DISPLAY_ENTITY_INTERFACE_DPI,
+	DISPLAY_ENTITY_INTERFACE_DBI,
 };
 
 struct display_entity_interface_params {
 	enum display_entity_interface_type type;
+	union {
+		struct mipi_dbi_interface_params dbi;
+	} p;
 };
 
 struct display_entity_control_ops {
diff --git a/include/video/mipi-dbi-bus.h b/include/video/mipi-dbi-bus.h
new file mode 100644
index 0000000..876b69d
--- /dev/null
+++ b/include/video/mipi-dbi-bus.h
@@ -0,0 +1,125 @@
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
+#ifndef __MIPI_DBI_BUS_H__
+#define __MIPI_DBI_BUS_H__
+
+#include <linux/device.h>
+
+struct mipi_dbi_bus;
+struct mipi_dbi_device;
+
+struct mipi_dbi_bus_ops {
+	int (*write_command)(struct mipi_dbi_bus *bus,
+			     struct mipi_dbi_device *dev, u16 cmd);
+	int (*write_data)(struct mipi_dbi_bus *bus, struct mipi_dbi_device *dev,
+			  const u8 *data, size_t len);
+	int (*read_data)(struct mipi_dbi_bus *bus, struct mipi_dbi_device *dev,
+			 u8 *data, size_t len);
+};
+
+struct mipi_dbi_bus {
+	struct device *dev;
+	const struct mipi_dbi_bus_ops *ops;
+};
+
+#define MIPI_DBI_MODULE_PREFIX		"mipi-dbi:"
+#define MIPI_DBI_NAME_SIZE		32
+
+struct mipi_dbi_device_id {
+	char name[MIPI_DBI_NAME_SIZE];
+	__kernel_ulong_t driver_data	/* Data private to the driver */
+			__aligned(sizeof(__kernel_ulong_t));
+};
+
+enum mipi_dbi_interface_type {
+	MIPI_DBI_INTERFACE_TYPE_A,
+	MIPI_DBI_INTERFACE_TYPE_B,
+};
+
+#define MIPI_DBI_INTERFACE_TE		(1 << 0)
+
+struct mipi_dbi_interface_params {
+	enum mipi_dbi_interface_type type;
+	unsigned int flags;
+
+	unsigned int cs_setup;
+	unsigned int rd_setup;
+	unsigned int rd_latch;
+	unsigned int rd_cycle;
+	unsigned int rd_hold;
+	unsigned int wr_setup;
+	unsigned int wr_cycle;
+	unsigned int wr_hold;
+};
+
+#define MIPI_DBI_FLAG_ALIGN_LEFT	(1 << 0)
+
+struct mipi_dbi_device {
+	const char *name;
+	int id;
+	struct device dev;
+
+	const struct mipi_dbi_device_id *id_entry;
+	struct mipi_dbi_bus *bus;
+
+	unsigned int flags;
+	unsigned int bus_width;
+	unsigned int data_width;
+};
+
+#define to_mipi_dbi_device(d)	container_of(d, struct mipi_dbi_device, dev)
+
+int mipi_dbi_device_register(struct mipi_dbi_device *dev,
+			     struct mipi_dbi_bus *bus);
+void mipi_dbi_device_unregister(struct mipi_dbi_device *dev);
+
+struct mipi_dbi_driver {
+	int(*probe)(struct mipi_dbi_device *);
+	int(*remove)(struct mipi_dbi_device *);
+	struct device_driver driver;
+	const struct mipi_dbi_device_id *id_table;
+};
+
+#define to_mipi_dbi_driver(d)	container_of(d, struct mipi_dbi_driver, driver)
+
+int mipi_dbi_driver_register(struct mipi_dbi_driver *drv);
+void mipi_dbi_driver_unregister(struct mipi_dbi_driver *drv);
+
+static inline void *mipi_dbi_get_drvdata(const struct mipi_dbi_device *dev)
+{
+	return dev_get_drvdata(&dev->dev);
+}
+
+static inline void mipi_dbi_set_drvdata(struct mipi_dbi_device *dev,
+					void *data)
+{
+	dev_set_drvdata(&dev->dev, data);
+}
+
+/* module_mipi_dbi_driver() - Helper macro for drivers that don't do
+ * anything special in module init/exit.  This eliminates a lot of
+ * boilerplate.  Each module may only use this macro once, and
+ * calling it replaces module_init() and module_exit()
+ */
+#define module_mipi_dbi_driver(__mipi_dbi_driver) \
+	module_driver(__mipi_dbi_driver, mipi_dbi_driver_register, \
+			mipi_dbi_driver_unregister)
+
+int mipi_dbi_set_data_width(struct mipi_dbi_device *dev, unsigned int width);
+
+int mipi_dbi_write_command(struct mipi_dbi_device *dev, u16 cmd);
+int mipi_dbi_read_data(struct mipi_dbi_device *dev, u8 *data, size_t len);
+int mipi_dbi_write_data(struct mipi_dbi_device *dev, const u8 *data,
+			size_t len);
+
+#endif /* __MIPI_DBI_BUS__ */
-- 
1.7.8.6

