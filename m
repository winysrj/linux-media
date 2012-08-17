Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46743 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab2HQAti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 20:49:38 -0400
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
Subject: [RFC 5/5] video: panel: Add R61517 panel support
Date: Fri, 17 Aug 2012 02:49:43 +0200
Message-Id: <1345164583-18924-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The R61517 is a MIPI DBI panel controller from Renesas.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/panel/Kconfig        |    9 +
 drivers/video/panel/Makefile       |    1 +
 drivers/video/panel/panel-r61517.c |  408 ++++++++++++++++++++++++++++++++++++
 include/video/panel-r61517.h       |   28 +++
 4 files changed, 446 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/panel/panel-r61517.c
 create mode 100644 include/video/panel-r61517.h

diff --git a/drivers/video/panel/Kconfig b/drivers/video/panel/Kconfig
index 12d7712..bd643be 100644
--- a/drivers/video/panel/Kconfig
+++ b/drivers/video/panel/Kconfig
@@ -25,4 +25,13 @@ config DISPLAY_PANEL_R61505
 
 	  If you are in doubt, say N.
 
+config DISPLAY_PANEL_R61517
+	tristate "Renesas R61517-based Display Panel"
+	select DISPLAY_PANEL_DBI
+	---help---
+	  Support panels based on the Renesas R61517 panel controller.
+	  Those panels are controlled through a MIPI DBI interface.
+
+	  If you are in doubt, say N.
+
 endif # DISPLAY_PANEL
diff --git a/drivers/video/panel/Makefile b/drivers/video/panel/Makefile
index e4fb9fe..3c11d26 100644
--- a/drivers/video/panel/Makefile
+++ b/drivers/video/panel/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_DISPLAY_PANEL) += panel.o
 obj-$(CONFIG_DISPLAY_PANEL_DUMMY) += panel-dummy.o
 obj-$(CONFIG_DISPLAY_PANEL_DBI) += panel-dbi.o
 obj-$(CONFIG_DISPLAY_PANEL_R61505) += panel-r61505.o
+obj-$(CONFIG_DISPLAY_PANEL_R61517) += panel-r61517.o
diff --git a/drivers/video/panel/panel-r61517.c b/drivers/video/panel/panel-r61517.c
new file mode 100644
index 0000000..6e8d933
--- /dev/null
+++ b/drivers/video/panel/panel-r61517.c
@@ -0,0 +1,408 @@
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
+#include <video/panel-dbi.h>
+#include <video/panel-r61517.h>
+
+struct r61517 {
+	struct panel panel;
+	struct panel_dbi_device *dbi;
+	const struct panel_r61517_platform_data *pdata;
+};
+
+#define to_panel(p)	container_of(p, struct r61517, panel)
+
+/* -----------------------------------------------------------------------------
+ * Read, write and reset
+ */
+
+static void r61517_write_command(struct r61517 *panel, u16 reg)
+{
+	panel_dbi_write_command(panel->dbi, reg);
+}
+
+static void r61517_write_data(struct r61517 *panel, u16 data)
+{
+	panel_dbi_write_data(panel->dbi, data);
+}
+
+static void r61517_write(struct r61517 *panel, u16 reg, u16 data)
+{
+	panel_dbi_write_command(panel->dbi, reg);
+	panel_dbi_write_data(panel->dbi, data);
+}
+
+static u16 r61517_read_data(struct r61517 *panel)
+{
+	return panel_dbi_read_data(panel->dbi);
+}
+
+static void __r61517_write_array(struct r61517 *panel, const u8 *data,
+				 unsigned int len)
+{
+	unsigned int i;
+
+	for (i = 0; i < len; ++i)
+		r61517_write_data(panel, data[i]);
+}
+
+#define r61517_write_array(p, a) \
+	__r61517_write_array(p, a, ARRAY_SIZE(a))
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
+static unsigned long r61517_read_device_code(struct r61517 *panel)
+{
+	/* access protect OFF */
+	r61517_write(panel, 0xb0, 0x00);
+
+	/* deep standby OFF */
+	r61517_write(panel, 0xb1, 0x00);
+
+	/* device code command */
+	r61517_write_command(panel, 0xbf);
+	mdelay(50);
+
+	/* dummy read */
+	r61517_read_data(panel);
+
+	/* read device code */
+	return ((r61517_read_data(panel) & 0xff) << 24) |
+	       ((r61517_read_data(panel) & 0xff) << 16) |
+	       ((r61517_read_data(panel) & 0xff) << 8) |
+	       ((r61517_read_data(panel) & 0xff) << 0);
+}
+
+static void r61517_write_memory_start(struct r61517 *panel)
+{
+	r61517_write_command(panel, 0x2c);
+}
+
+static void r61517_clear_memory(struct r61517 *panel)
+{
+	unsigned int i;
+
+	r61517_write_memory_start(panel);
+
+	for (i = 0; i < (240 * 400); i++)
+		r61517_write_data(panel, 0);
+}
+
+static void r61517_enable_panel(struct r61517 *panel)
+{
+	/* access protect off */
+	r61517_write(panel, 0xb0, 0x00);
+
+	/* exit deep standby mode */
+	r61517_write(panel, 0xb1, 0x00);
+
+	/* frame memory I/F */
+	r61517_write_command(panel, 0xb3);
+	r61517_write_array(panel, data_frame_if);
+
+	/* display mode and frame memory write mode */
+	r61517_write(panel, 0xb4, 0x00); /* DBI, internal clock */
+
+	/* panel */
+	r61517_write_command(panel, 0xc0);
+	r61517_write_array(panel, data_panel);
+
+	/* timing (normal) */
+	r61517_write_command(panel, 0xc1);
+	r61517_write_array(panel, data_timing);
+
+	/* timing (partial) */
+	r61517_write_command(panel, 0xc2);
+	r61517_write_array(panel, data_timing);
+
+	/* timing (idle) */
+	r61517_write_command(panel, 0xc3);
+	r61517_write_array(panel, data_timing);
+
+	/* timing (source/VCOM/gate driving) */
+	r61517_write_command(panel, 0xc4);
+	r61517_write_array(panel, data_timing_src);
+
+	/* gamma (red) */
+	r61517_write_command(panel, 0xc8);
+	r61517_write_array(panel, data_gamma);
+
+	/* gamma (green) */
+	r61517_write_command(panel, 0xc9);
+	r61517_write_array(panel, data_gamma);
+
+	/* gamma (blue) */
+	r61517_write_command(panel, 0xca);
+	r61517_write_array(panel, data_gamma);
+
+	/* power (common) */
+	r61517_write_command(panel, 0xd0);
+	r61517_write_array(panel, data_power);
+
+	/* VCOM */
+	r61517_write_command(panel, 0xd1);
+	r61517_write_data(panel, 0x00);
+	r61517_write_data(panel, 0x0f);
+	r61517_write_data(panel, 0x02);
+
+	/* power (normal) */
+	r61517_write_command(panel, 0xd2);
+	r61517_write_data(panel, 0x63);
+	r61517_write_data(panel, 0x24);
+
+	/* power (partial) */
+	r61517_write_command(panel, 0xd3);
+	r61517_write_data(panel, 0x63);
+	r61517_write_data(panel, 0x24);
+
+	/* power (idle) */
+	r61517_write_command(panel, 0xd4);
+	r61517_write_data(panel, 0x63);
+	r61517_write_data(panel, 0x24);
+
+	r61517_write_command(panel, 0xd8);
+	r61517_write_data(panel, 0x77);
+	r61517_write_data(panel, 0x77);
+
+	/* TE signal */
+	r61517_write(panel, 0x35, 0x00);
+
+	/* TE signal line */
+	r61517_write_command(panel, 0x44);
+	r61517_write_data(panel, 0x00);
+	r61517_write_data(panel, 0x00);
+
+	/* column address */
+	r61517_write_command(panel, 0x2a);
+	r61517_write_data(panel, 0x00);
+	r61517_write_data(panel, 0x00);
+	r61517_write_data(panel, 0x00);
+	r61517_write_data(panel, 0xef);
+
+	/* page address */
+	r61517_write_command(panel, 0x2b);
+	r61517_write_data(panel, 0x00);
+	r61517_write_data(panel, 0x00);
+	r61517_write_data(panel, 0x01);
+	r61517_write_data(panel, 0x8f);
+
+	/* exit sleep mode */
+	r61517_write_command(panel, 0x11);
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
+	r61517_write_command(panel, 0x29);
+	mdelay(1);
+}
+
+static void r61517_display_off(struct r61517 *panel)
+{
+	r61517_write_command(panel, 0x28);
+}
+
+/* -----------------------------------------------------------------------------
+ * Panel operations
+ */
+
+static int r61517_enable(struct panel *p, enum panel_enable_mode enable)
+{
+	struct r61517 *panel = to_panel(p);
+
+	switch (enable) {
+	case PANEL_ENABLE_OFF:
+		r61517_disable_panel(panel);
+		break;
+
+	case PANEL_ENABLE_BLANK:
+		if (p->enable == PANEL_ENABLE_OFF)
+			r61517_enable_panel(panel);
+		else
+			r61517_display_off(panel);
+		break;
+
+	case PANEL_ENABLE_ON:
+		if (p->enable == PANEL_ENABLE_OFF)
+			r61517_enable_panel(panel);
+
+		r61517_display_on(panel);
+		break;
+	}
+
+	return 0;
+}
+
+static int r61517_start_transfer(struct panel *p)
+{
+	struct r61517 *panel = to_panel(p);
+
+	r61517_write_memory_start(panel);
+	return 0;
+}
+
+static int r61517_get_modes(struct panel *p, const struct fb_videomode **modes)
+{
+	struct r61517 *panel = to_panel(p);
+
+	*modes = panel->pdata->mode;
+	return 1;
+}
+
+static const struct panel_ops r61517_ops = {
+	.enable = r61517_enable,
+	.start_transfer = r61517_start_transfer,
+	.get_modes = r61517_get_modes,
+};
+
+static void r61517_release(struct panel *p)
+{
+	struct r61517 *panel = to_panel(p);
+
+	kfree(panel);
+}
+
+static int r61517_remove(struct panel_dbi_device *dev)
+{
+	struct r61517 *panel = panel_dbi_get_drvdata(dev);
+
+	panel_dbi_set_drvdata(dev, NULL);
+	panel_unregister(&panel->panel);
+
+	return 0;
+}
+
+static int __devinit r61517_probe(struct panel_dbi_device *dev)
+{
+	const struct panel_r61517_platform_data *pdata = dev->dev.platform_data;
+	struct r61517 *panel;
+	int ret;
+
+	if (pdata == NULL)
+		return -ENODEV;
+
+	panel = kzalloc(sizeof(*panel), GFP_KERNEL);
+	if (panel == NULL)
+		return -ENOMEM;
+
+	panel->pdata = pdata;
+	panel->dbi = dev;
+
+	r61517_reset(panel);
+
+	if (r61517_read_device_code(panel) != 0x01221517) {
+		kfree(panel);
+		return -ENODEV;
+	}
+
+	pr_info("R61517 panel controller detected.\n");
+
+	panel->panel.dev = &dev->dev;
+	panel->panel.release = r61517_release;
+	panel->panel.ops = &r61517_ops;
+	panel->panel.width = pdata->width;
+	panel->panel.height = pdata->height;
+
+	ret = panel_register(&panel->panel);
+	if (ret < 0) {
+		kfree(panel);
+		return ret;
+	}
+
+	panel_dbi_set_drvdata(dev, panel);
+
+	return 0;
+}
+
+static const struct dev_pm_ops r61517_dev_pm_ops = {
+};
+
+static struct panel_dbi_driver r61517_driver = {
+	.probe = r61517_probe,
+	.remove = r61517_remove,
+	.driver = {
+		.name = "panel_r61517",
+		.owner = THIS_MODULE,
+		.pm = &r61517_dev_pm_ops,
+	},
+};
+
+module_panel_dbi_driver(r61517_driver);
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("Renesas R61517-based Display Panel");
+MODULE_LICENSE("GPL");
diff --git a/include/video/panel-r61517.h b/include/video/panel-r61517.h
new file mode 100644
index 0000000..c9e6ddf
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
+#include <linux/fb.h>
+#include <video/panel.h>
+
+struct panel_r61517_platform_data {
+	unsigned long width;		/* Panel width in mm */
+	unsigned long height;		/* Panel height in mm */
+	const struct fb_videomode *mode;
+
+	int protect;			/* Protect GPIO */
+	int reset;			/* Reset GPIO */
+};
+
+#endif /* __PANEL_R61517_H__ */
-- 
1.7.8.6

