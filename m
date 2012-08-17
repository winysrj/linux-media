Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46743 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab2HQAtd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 20:49:33 -0400
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
Subject: [RFC 2/5] video: panel: Add dummy panel support
Date: Fri, 17 Aug 2012 02:49:40 +0200
Message-Id: <1345164583-18924-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/panel/Kconfig       |   11 ++++
 drivers/video/panel/Makefile      |    1 +
 drivers/video/panel/panel-dummy.c |  103 +++++++++++++++++++++++++++++++++++++
 include/video/panel-dummy.h       |   25 +++++++++
 4 files changed, 140 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/panel/panel-dummy.c
 create mode 100644 include/video/panel-dummy.h

diff --git a/drivers/video/panel/Kconfig b/drivers/video/panel/Kconfig
index 26b1787..36fb9ca 100644
--- a/drivers/video/panel/Kconfig
+++ b/drivers/video/panel/Kconfig
@@ -2,3 +2,14 @@ menuconfig DISPLAY_PANEL
 	tristate "Display Panel"
 	---help---
 	  Support for display panels for graphics devices.
+
+if DISPLAY_PANEL
+
+config DISPLAY_PANEL_DUMMY
+	tristate "Dummy Display Panel"
+	---help---
+	  Support dummy panels with no control bus.
+
+	  If you are in doubt, say N.
+
+endif # DISPLAY_PANEL
diff --git a/drivers/video/panel/Makefile b/drivers/video/panel/Makefile
index cf5c5e2..9fc05c2 100644
--- a/drivers/video/panel/Makefile
+++ b/drivers/video/panel/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_DISPLAY_PANEL) += panel.o
+obj-$(CONFIG_DISPLAY_PANEL_DUMMY) += panel-dummy.o
diff --git a/drivers/video/panel/panel-dummy.c b/drivers/video/panel/panel-dummy.c
new file mode 100644
index 0000000..9ba1447
--- /dev/null
+++ b/drivers/video/panel/panel-dummy.c
@@ -0,0 +1,103 @@
+/*
+ * Dummy Display Panel
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
+
+#include <video/panel-dummy.h>
+
+struct panel_dummy {
+	struct panel panel;
+	const struct panel_dummy_platform_data *pdata;
+};
+
+#define to_panel_dummy(p)	container_of(p, struct panel_dummy, panel)
+
+static int panel_dummy_get_modes(struct panel *p,
+				 const struct fb_videomode **modes)
+{
+	struct panel_dummy *panel = to_panel_dummy(p);
+
+	*modes = panel->pdata->mode;
+	return 1;
+}
+
+static const struct panel_ops panel_dummy_ops = {
+	.get_modes = panel_dummy_get_modes,
+};
+
+static void panel_dummy_release(struct panel *p)
+{
+	struct panel_dummy *panel = to_panel_dummy(p);
+
+	kfree(panel);
+}
+
+static int panel_dummy_remove(struct platform_device *pdev)
+{
+	struct panel_dummy *panel = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	panel_unregister(&panel->panel);
+
+	return 0;
+}
+
+static int __devinit panel_dummy_probe(struct platform_device *pdev)
+{
+	const struct panel_dummy_platform_data *pdata = pdev->dev.platform_data;
+	struct panel_dummy *panel;
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
+	panel->panel.dev = &pdev->dev;
+	panel->panel.release = panel_dummy_release;
+	panel->panel.ops = &panel_dummy_ops;
+	panel->panel.width = pdata->width;
+	panel->panel.height = pdata->height;
+
+	ret = panel_register(&panel->panel);
+	if (ret < 0) {
+		kfree(panel);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, panel);
+
+	return 0;
+}
+
+static const struct dev_pm_ops panel_dummy_dev_pm_ops = {
+};
+
+static struct platform_driver panel_dummy_driver = {
+	.probe = panel_dummy_probe,
+	.remove = panel_dummy_remove,
+	.driver = {
+		.name = "panel_dummy",
+		.owner = THIS_MODULE,
+		.pm = &panel_dummy_dev_pm_ops,
+	},
+};
+
+module_platform_driver(panel_dummy_driver);
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("Dummy Display Panel");
+MODULE_LICENSE("GPL");
diff --git a/include/video/panel-dummy.h b/include/video/panel-dummy.h
new file mode 100644
index 0000000..558a297
--- /dev/null
+++ b/include/video/panel-dummy.h
@@ -0,0 +1,25 @@
+/*
+ * Dummy Display Panel
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
+#ifndef __PANEL_DUMMY_H__
+#define __PANEL_DUMMY_H__
+
+#include <linux/fb.h>
+#include <video/panel.h>
+
+struct panel_dummy_platform_data {
+	unsigned long width;		/* Panel width in mm */
+	unsigned long height;		/* Panel height in mm */
+	const struct fb_videomode *mode;
+};
+
+#endif /* __PANEL_DUMMY_H__ */
-- 
1.7.8.6

