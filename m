Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031464Ab3HIXC3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:29 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 11/19] video: panel: Add R61517 panel support
Date: Sat, 10 Aug 2013 01:03:10 +0200
Message-Id: <1376089398-13322-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The R61517 is a MIPI DBI panel controller from Renesas.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/display/Kconfig        |  10 +
 drivers/video/display/Makefile       |   1 +
 drivers/video/display/panel-r61517.c | 460 +++++++++++++++++++++++++++++++++++
 include/video/panel-r61517.h         |  28 +++
 4 files changed, 499 insertions(+)
 create mode 100644 drivers/video/display/panel-r61517.c
 create mode 100644 include/video/panel-r61517.h

diff --git a/drivers/video/display/Kconfig b/drivers/video/display/Kconfig
index 76729ef..9b44b5f 100644
--- a/drivers/video/display/Kconfig
+++ b/drivers/video/display/Kconfig
@@ -29,4 +29,14 @@ config DISPLAY_PANEL_R61505
 	  If you are in doubt, say N. To compile this driver as a module, choose
 	  M here; the module will be called panel-r61505.
 
+config DISPLAY_PANEL_R61517
+	tristate "Renesas R61517-based Display Panel"
+	select DISPLAY_MIPI_DBI
+	---help---
+	  Support panels based on the Renesas R61517 panel controller.
+	  Those panels are controlled through a MIPI DBI interface.
+
+	  If you are in doubt, say N. To compile this driver as a module, choose
+	  M here; the module will be called panel-r61517.
+
 endif # DISPLAY_CORE
diff --git a/drivers/video/display/Makefile b/drivers/video/display/Makefile
index db8a4c3..1cdc8d4 100644
--- a/drivers/video/display/Makefile
+++ b/drivers/video/display/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_DISPLAY_CORE)			+= display.o
 obj-$(CONFIG_DISPLAY_MIPI_DBI)			+= mipi-dbi-bus.o
 obj-$(CONFIG_DISPLAY_PANEL_DPI)			+= panel-dpi.o
 obj-$(CONFIG_DISPLAY_PANEL_R61505)		+= panel-r61505.o
+obj-$(CONFIG_DISPLAY_PANEL_R61517)		+= panel-r61517.o
diff --git a/drivers/video/display/panel-r61517.c b/drivers/video/display/panel-r61517.c
new file mode 100644
index 0000000..ccfec33
--- /dev/null
+++ b/drivers/video/display/panel-r61517.c
@@ -0,0 +1,460 @@
+/*
+ * Renesas R61517-based Display Panels
+ *
+ * Copyright (C) 2012 Renesas Solutions Corp.
+ * Based on KFR2R09 LCD panel support
+ * Copyright (C) 2009 Magnus Damm
+ * Register settings based on the out-of-tree t33fb.c driver
+ * Copyright (C) 2008 Lineo Solutions, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+
+#include <video/display.h>
+#include <video/mipi-dbi-bus.h>
+#include <video/mipi_display.h>
+#include <video/panel-r61517.h>
+#include <video/videomode.h>
+
+struct r61517 {
+	struct display_entity entity;
+	struct mipi_dbi_device *dbi;
+	const struct panel_r61517_platform_data *pdata;
+};
+
+static inline struct r61517 *to_panel(struct display_entity *e)
+{
+	return container_of(e, struct r61517, entity);
+}
+
+/* -----------------------------------------------------------------------------
+ * Read, write and reset
+ */
+
+static void r61517_write_command(struct r61517 *panel, u16 cmd)
+{
+	mipi_dbi_write_command(panel->dbi, cmd);
+}
+
+static void r61517_write_data(struct r61517 *panel, u8 data)
+{
+	mipi_dbi_write_data(panel->dbi, &data, 1);
+}
+
+static int r61517_read_data(struct r61517 *panel)
+{
+	u8 data;
+	int ret;
+
+	ret = mipi_dbi_read_data(panel->dbi, &data, 1);
+	if (ret < 0)
+		return ret;
+
+	return data;
+}
+
+static void r61517_write(struct r61517 *panel, u8 reg, const u8 *data,
+			 size_t len)
+{
+	mipi_dbi_write_command(panel->dbi, reg);
+	mipi_dbi_write_data(panel->dbi, data, len);
+}
+
+static void r61517_write8(struct r61517 *panel, u8 reg, u8 data)
+{
+	r61517_write(panel, reg, &data, 1);
+}
+
+static void r61517_write16(struct r61517 *panel, u8 reg, u16 data)
+{
+	u8 buffer[2] = { (data >> 8) & 0xff, (data >> 0) & 0xff };
+
+	r61517_write(panel, reg, buffer, 2);
+}
+
+static void r61517_write32(struct r61517 *panel, u8 reg, u32 data)
+{
+	u8 buffer[4] = { (data >> 24) & 0xff, (data >> 16) & 0xff,
+			 (data >>  8) & 0xff, (data >>  0) & 0xff };
+
+	r61517_write(panel, reg, buffer, 4);
+}
+
+#define r61517_write_array(p, c, a) \
+	r61517_write((p), (c), (a), ARRAY_SIZE(a))
+
+static void r61517_reset(struct r61517 *panel)
+{
+	gpio_set_value(panel->pdata->protect, 0);	/* PROTECT/ -> L */
+	gpio_set_value(panel->pdata->reset, 0);		/* LCD_RST/ -> L */
+	gpio_set_value(panel->pdata->protect, 1);	/* PROTECT/ -> H */
+	usleep_range(1100, 1200);
+	gpio_set_value(panel->pdata->reset, 1);		/* LCD_RST/ -> H */
+	usleep_range(10, 100);
+	gpio_set_value(panel->pdata->protect, 0);	/* PROTECT/ -> L */
+	msleep(20);
+}
+
+/* -----------------------------------------------------------------------------
+ * Configuration
+ */
+
+static const u8 data_frame_if[] = {
+	0x02, /* WEMODE: 1=cont, 0=one-shot */
+	0x00, 0x00,
+	0x00, /* EPF, DFM */
+	0x02, /* RIM[1] : 1 (18bpp) */
+};
+
+static const u8 data_panel[] = {
+	0x0b,
+	0x63, /* 400 lines */
+	0x04, 0x00, 0x00, 0x04, 0x11, 0x00, 0x00,
+};
+
+static const u8 data_timing[] = {
+	0x00, 0x00, 0x13, 0x08, 0x08,
+};
+
+static const u8 data_timing_src[] = {
+	0x11, 0x01, 0x00, 0x01,
+};
+
+static const u8 data_gamma[] = {
+	0x01, 0x02, 0x08, 0x23,	0x03, 0x0c, 0x00, 0x06,	0x00, 0x00,
+	0x01, 0x00, 0x0c, 0x23, 0x03, 0x08, 0x02, 0x06, 0x00, 0x00,
+};
+
+static const u8 data_power[] = {
+	0x07, 0xc5, 0xdc, 0x02,	0x33, 0x0a,
+};
+
+static const u8 data_vcom[] = {
+	0x00, 0x0f, 0x02,
+};
+
+static unsigned long r61517_read_device_code(struct r61517 *panel)
+{
+	/* access protect OFF */
+	r61517_write8(panel, 0xb0, 0);
+
+	/* deep standby OFF */
+	r61517_write8(panel, 0xb1, 0);
+
+	/* device code command */
+	r61517_write_command(panel, 0xbf);
+	mdelay(50);
+
+	/* dummy read */
+	r61517_read_data(panel);
+
+	/* read device code */
+	return (r61517_read_data(panel) << 24) |
+	       (r61517_read_data(panel) << 16) |
+	       (r61517_read_data(panel) << 8) |
+	       (r61517_read_data(panel) << 0);
+}
+
+static void r61517_write_memory_start(struct r61517 *panel)
+{
+	r61517_write_command(panel, MIPI_DCS_WRITE_MEMORY_START);
+}
+
+static void r61517_clear_memory(struct r61517 *panel)
+{
+	unsigned int size = panel->pdata->mode->hactive
+			  * panel->pdata->mode->vactive;
+	unsigned int i;
+
+	r61517_write_memory_start(panel);
+
+	for (i = 0; i < size; i++)
+		r61517_write_data(panel, 0);
+}
+
+static void r61517_enable_panel(struct r61517 *panel)
+{
+	/* access protect off */
+	r61517_write8(panel, 0xb0, 0);
+
+	/* exit deep standby mode */
+	r61517_write8(panel, 0xb1, 0);
+
+	/* frame memory I/F */
+	r61517_write_array(panel, 0xb3, data_frame_if);
+
+	/* display mode and frame memory write mode */
+	r61517_write8(panel, 0xb4, 0); /* DBI, internal clock */
+
+	/* panel */
+	r61517_write_array(panel, 0xc0, data_panel);
+
+	/* timing (normal) */
+	r61517_write_array(panel, 0xc1, data_timing);
+
+	/* timing (partial) */
+	r61517_write_array(panel, 0xc2, data_timing);
+
+	/* timing (idle) */
+	r61517_write_array(panel, 0xc3, data_timing);
+
+	/* timing (source/VCOM/gate driving) */
+	r61517_write_array(panel, 0xc4, data_timing_src);
+
+	/* gamma (red) */
+	r61517_write_array(panel, 0xc8, data_gamma);
+
+	/* gamma (green) */
+	r61517_write_array(panel, 0xc9, data_gamma);
+
+	/* gamma (blue) */
+	r61517_write_array(panel, 0xca, data_gamma);
+
+	/* power (common) */
+	r61517_write_array(panel, 0xd0, data_power);
+
+	/* VCOM */
+	r61517_write_array(panel, 0xd1, data_vcom);
+
+	/* power (normal) */
+	r61517_write16(panel, 0xd2, 0x6324);
+
+	/* power (partial) */
+	r61517_write16(panel, 0xd3, 0x6324);
+
+	/* power (idle) */
+	r61517_write16(panel, 0xd4, 0x6324);
+
+	r61517_write16(panel, 0xd8, 0x7777);
+
+	/* TE signal */
+	r61517_write8(panel, MIPI_DCS_SET_TEAR_ON, 0);
+
+	/* TE signal line */
+	r61517_write16(panel, MIPI_DCS_SET_TEAR_SCANLINE, 0);
+
+	/* column address */
+	r61517_write32(panel, MIPI_DCS_SET_COLUMN_ADDRESS,
+		       panel->pdata->mode->hactive - 1);
+
+	/* page address */
+	r61517_write32(panel, MIPI_DCS_SET_PAGE_ADDRESS,
+		       panel->pdata->mode->vactive - 1);
+
+	/* exit sleep mode */
+	r61517_write_command(panel, MIPI_DCS_EXIT_SLEEP_MODE);
+
+	mdelay(120);
+
+	/* clear vram */
+	r61517_clear_memory(panel);
+}
+
+static void r61517_disable_panel(struct r61517 *panel)
+{
+	r61517_reset(panel);
+}
+
+static void r61517_display_on(struct r61517 *panel)
+{
+	r61517_write_command(panel, MIPI_DCS_SET_DISPLAY_ON);
+	mdelay(1);
+}
+
+static void r61517_display_off(struct r61517 *panel)
+{
+	r61517_write_command(panel, MIPI_DCS_SET_DISPLAY_OFF);
+}
+
+/* -----------------------------------------------------------------------------
+ * Panel operations
+ */
+
+static const struct display_entity_interface_params r61517_dbi_params = {
+	.type = DISPLAY_ENTITY_INTERFACE_DBI,
+	.p.dbi = {
+		.type = MIPI_DBI_INTERFACE_TYPE_B,
+		.flags = MIPI_DBI_INTERFACE_TE,
+		.cs_setup = 1,
+		.wr_setup = 1,
+		.wr_cycle = 9,
+		.wr_hold = 4,
+		.rd_setup = 1,
+		.rd_latch = 20,
+		.rd_cycle = 41,
+		.rd_hold = 20,
+	},
+};
+
+static int r61517_set_state(struct display_entity *entity,
+			    enum display_entity_state state)
+{
+	struct r61517 *panel = to_panel(entity);
+
+	switch (state) {
+	case DISPLAY_ENTITY_STATE_OFF:
+		r61517_disable_panel(panel);
+		break;
+
+	case DISPLAY_ENTITY_STATE_STANDBY:
+		if (entity->state == DISPLAY_ENTITY_STATE_OFF)
+			r61517_enable_panel(panel);
+		else
+			r61517_display_off(panel);
+		break;
+
+	case DISPLAY_ENTITY_STATE_ON:
+		if (entity->state == DISPLAY_ENTITY_STATE_OFF)
+			r61517_enable_panel(panel);
+
+		r61517_display_on(panel);
+		break;
+	}
+
+	return 0;
+}
+
+static int r61517_update(struct display_entity *entity)
+{
+	struct r61517 *panel = to_panel(entity);
+	struct media_pad *source;
+
+	r61517_write_memory_start(panel);
+
+	source = media_entity_remote_pad(&entity->entity.pads[0]);
+	if (source == NULL)
+		return -EPIPE;
+
+	display_entity_set_stream(to_display_entity(source->entity),
+				  source->index,
+				  DISPLAY_ENTITY_STREAM_SINGLE_SHOT);
+	return 0;
+}
+
+static int r61517_get_modes(struct display_entity *entity, unsigned int port,
+			    const struct videomode **modes)
+{
+	struct r61517 *panel = to_panel(entity);
+
+	*modes = panel->pdata->mode;
+	return 1;
+}
+
+static int r61517_get_size(struct display_entity *entity,
+			   unsigned int *width, unsigned int *height)
+{
+	struct r61517 *panel = to_panel(entity);
+
+	*width = panel->pdata->width;
+	*height = panel->pdata->height;
+	return 0;
+}
+
+static int r61517_get_params(struct display_entity *entity, unsigned int port,
+			     struct display_entity_interface_params *params)
+{
+	*params = r61517_dbi_params;
+	return 0;
+}
+
+static const struct display_entity_control_ops r61517_control_ops = {
+	.set_state = r61517_set_state,
+	.update = r61517_update,
+	.get_modes = r61517_get_modes,
+	.get_size = r61517_get_size,
+	.get_params = r61517_get_params,
+};
+
+static const struct display_entity_ops r61517_ops = {
+	.ctrl = &r61517_control_ops,
+};
+
+static int r61517_remove(struct mipi_dbi_device *dev)
+{
+	struct r61517 *panel = mipi_dbi_get_drvdata(dev);
+
+	display_entity_remove(&panel->entity);
+	display_entity_cleanup(&panel->entity);
+
+	return 0;
+}
+
+static int r61517_probe(struct mipi_dbi_device *dev)
+{
+	const struct panel_r61517_platform_data *pdata = dev->dev.platform_data;
+	struct r61517 *panel;
+	int ret;
+
+	if (pdata == NULL)
+		return -ENODEV;
+
+	panel = devm_kzalloc(&dev->dev, sizeof(*panel), GFP_KERNEL);
+	if (panel == NULL)
+		return -ENOMEM;
+
+	panel->pdata = pdata;
+	panel->dbi = dev;
+
+	dev->bus_width = pdata->bus_width;
+	mipi_dbi_set_data_width(dev, 8);
+
+	r61517_reset(panel);
+
+	if (r61517_read_device_code(panel) != 0x01221517)
+		return -ENODEV;
+
+	pr_info("R61517 panel controller detected.\n");
+
+	panel->entity.dev = &dev->dev;
+	panel->entity.ops = &r61517_ops;
+
+	ret = display_entity_init(&panel->entity, 1, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = display_entity_add(&panel->entity);
+	if (ret < 0)
+		return ret;
+
+	mipi_dbi_set_drvdata(dev, panel);
+
+	return 0;
+}
+
+static const struct dev_pm_ops r61517_dev_pm_ops = {
+};
+
+static struct mipi_dbi_device_id r61517_id_table[] = {
+	{ "panel-r61517", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(mipi_dbi, r61517_id_table);
+
+static struct mipi_dbi_driver r61517_driver = {
+	.probe = r61517_probe,
+	.remove = r61517_remove,
+	.id_table = r61517_id_table,
+	.driver = {
+		.name = "panel-r61517",
+		.owner = THIS_MODULE,
+		.pm = &r61517_dev_pm_ops,
+	},
+};
+
+module_mipi_dbi_driver(r61517_driver);
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("Renesas R61517-based Display Panel");
+MODULE_LICENSE("GPL");
diff --git a/include/video/panel-r61517.h b/include/video/panel-r61517.h
new file mode 100644
index 0000000..33f16af
--- /dev/null
+++ b/include/video/panel-r61517.h
@@ -0,0 +1,28 @@
+/*
+ * Renesas R61517-based Display Panels
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
+#ifndef __PANEL_R61517_H__
+#define __PANEL_R61517_H__
+
+struct videomode;
+
+struct panel_r61517_platform_data {
+	unsigned long width;		/* Panel width in mm */
+	unsigned long height;		/* Panel height in mm */
+	const struct videomode *mode;
+
+	unsigned int bus_width;
+	int protect;			/* Protect GPIO */
+	int reset;			/* Reset GPIO */
+};
+
+#endif /* __PANEL_R61517_H__ */
-- 
1.8.1.5

