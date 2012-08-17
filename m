Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46730 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab2HQAtb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 20:49:31 -0400
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
Subject: [RFC 1/5] video: Add generic display panel core
Date: Fri, 17 Aug 2012 02:49:39 +0200
Message-Id: <1345164583-18924-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/Kconfig        |    1 +
 drivers/video/Makefile       |    1 +
 drivers/video/panel/Kconfig  |    4 +
 drivers/video/panel/Makefile |    1 +
 drivers/video/panel/panel.c  |  269 ++++++++++++++++++++++++++++++++++++++++++
 include/video/panel.h        |  111 +++++++++++++++++
 6 files changed, 387 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/panel/Kconfig
 create mode 100644 drivers/video/panel/Makefile
 create mode 100644 drivers/video/panel/panel.c
 create mode 100644 include/video/panel.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 0217f74..2cc394e 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2448,6 +2448,7 @@ source "drivers/video/omap/Kconfig"
 source "drivers/video/omap2/Kconfig"
 source "drivers/video/exynos/Kconfig"
 source "drivers/video/backlight/Kconfig"
+source "drivers/video/panel/Kconfig"
 
 if VT
 	source "drivers/video/console/Kconfig"
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index ee8dafb..577240c 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -14,6 +14,7 @@ fb-objs                           := $(fb-y)
 obj-$(CONFIG_VT)		  += console/
 obj-$(CONFIG_LOGO)		  += logo/
 obj-y				  += backlight/
+obj-y				  += panel/
 
 obj-$(CONFIG_EXYNOS_VIDEO)     += exynos/
 
diff --git a/drivers/video/panel/Kconfig b/drivers/video/panel/Kconfig
new file mode 100644
index 0000000..26b1787
--- /dev/null
+++ b/drivers/video/panel/Kconfig
@@ -0,0 +1,4 @@
+menuconfig DISPLAY_PANEL
+	tristate "Display Panel"
+	---help---
+	  Support for display panels for graphics devices.
diff --git a/drivers/video/panel/Makefile b/drivers/video/panel/Makefile
new file mode 100644
index 0000000..cf5c5e2
--- /dev/null
+++ b/drivers/video/panel/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DISPLAY_PANEL) += panel.o
diff --git a/drivers/video/panel/panel.c b/drivers/video/panel/panel.c
new file mode 100644
index 0000000..cfca804
--- /dev/null
+++ b/drivers/video/panel/panel.c
@@ -0,0 +1,269 @@
+/*
+ * Display Panel
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
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+
+#include <video/panel.h>
+
+static LIST_HEAD(panel_list);
+static LIST_HEAD(panel_notifiers);
+static DEFINE_MUTEX(panel_mutex);
+
+/**
+ * panel_enable - Set the panel operation mode
+ * @panel: The panel
+ * @enable: Panel operation mode
+ *
+ * - PANEL_ENABLE_OFF turns the panel off completely, possibly including its
+ *   power supplies. Communication with a panel in that mode is not possible.
+ * - PANEL_ENABLE_BLANK turns the panel on but keep the output blanked. Full
+ *   communication with the panel is supported, including pixel data transfer.
+ * - PANEL_ENABLE_ON turns the whole panel on, including the output.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int panel_enable(struct panel *panel, enum panel_enable_mode enable)
+{
+	int ret;
+
+	if (panel->enable == enable)
+		return 0;
+
+	if (!panel->ops || !panel->ops->enable)
+		return 0;
+
+	ret = panel->ops->enable(panel, enable);
+	if (ret < 0)
+		return ret;
+
+	panel->enable = enable;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(panel_enable);
+
+/**
+ * panel_start_transfer - Start frame transfer
+ * @panel: The panel
+ *
+ * Make the panel ready to receive pixel data and start frame transfer. This
+ * operation can only be called if the panel is in BLANK or ON mode.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int panel_start_transfer(struct panel *panel)
+{
+	if (!panel->ops || !panel->ops->start_transfer)
+		return 0;
+
+	return panel->ops->start_transfer(panel);
+}
+
+/**
+ * panel_get_modes - Get video modes supported by the panel
+ * @panel: The panel
+ * @modes: Pointer to an array of modes
+ *
+ * Fill the modes argument with a pointer to an array of video modes. The array
+ * is owned by the panel.
+ *
+ * Return the number of supported modes on success (including 0 if no mode is
+ * supported) or a negative error code otherwise.
+ */
+int panel_get_modes(struct panel *panel, const struct fb_videomode **modes)
+{
+	if (!panel->ops || !panel->ops->get_modes)
+		return 0;
+
+	return panel->ops->get_modes(panel, modes);
+}
+EXPORT_SYMBOL_GPL(panel_get_modes);
+
+static void panel_release(struct kref *ref)
+{
+	struct panel *panel = container_of(ref, struct panel, ref);
+
+	if (panel->release)
+		panel->release(panel);
+}
+
+/**
+ * panel_get - get a reference to a panel
+ * @panel: the panel
+ *
+ * Return the panel pointer.
+ */
+struct panel *panel_get(struct panel *panel)
+{
+	if (panel == NULL)
+		return NULL;
+
+	kref_get(&panel->ref);
+	return panel;
+}
+EXPORT_SYMBOL_GPL(panel_get);
+
+/**
+ * panel_put - release a reference to a panel
+ * @panel: the panel
+ *
+ * Releasing the last reference to a panel releases the panel itself.
+ */
+void panel_put(struct panel *panel)
+{
+	kref_put(&panel->ref, panel_release);
+}
+EXPORT_SYMBOL_GPL(panel_put);
+
+static int panel_notifier_match(struct panel *panel,
+				struct panel_notifier *notifier)
+{
+	return notifier->dev == NULL ||
+	       notifier->dev == panel->dev;
+}
+
+/**
+ * panel_register_notifier - register a display panel notifier
+ * @notifier: panel notifier structure we want to register
+ *
+ * Panel notifiers are called to notify drivers of panel-related events for
+ * matching panels.
+ *
+ * Notifiers and panels are matched through the device they correspond to. If
+ * the notifier dev field is equal to the panel dev field the notifier will be
+ * called when an event is reported. Notifiers with a NULL dev field act as
+ * catch-all and will be called for all panels.
+ *
+ * Supported events are
+ *
+ * - PANEL_NOTIFIER_CONNECT reports panel connection and is sent at panel or
+ *   notifier registration time
+ * - PANEL_NOTIFIER_DISCONNECT reports panel disconnection and is sent at panel
+ *   unregistration time
+ *
+ * Registering a notifier sends PANEL_NOTIFIER_CONNECT events for all previously
+ * registered panels that match the notifiers.
+ *
+ * Return 0 on success.
+ */
+int panel_register_notifier(struct panel_notifier *notifier)
+{
+	struct panel *panel;
+
+	mutex_lock(&panel_mutex);
+	list_add_tail(&notifier->list, &panel_notifiers);
+
+	list_for_each_entry(panel, &panel_list, list) {
+		if (!panel_notifier_match(panel, notifier))
+			continue;
+
+		if (notifier->notify(notifier, panel, PANEL_NOTIFIER_CONNECT))
+			break;
+	}
+	mutex_unlock(&panel_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(panel_register_notifier);
+
+/**
+ * panel_unregister_notifier - unregister a display panel notifier
+ * @notifier: panel notifier to be unregistered
+ *
+ * Unregistration guarantees that the notifier will never be called upon return
+ * of this function.
+ */
+void panel_unregister_notifier(struct panel_notifier *notifier)
+{
+	mutex_lock(&panel_mutex);
+	list_del(&notifier->list);
+	mutex_unlock(&panel_mutex);
+}
+EXPORT_SYMBOL_GPL(panel_unregister_notifier);
+
+/**
+ * panel_register - register a display panel
+ * @panel: panel to be registered
+ *
+ * Register the panel and send the PANEL_NOTIFIER_CONNECT event to all
+ * matching registered notifiers.
+ *
+ * Return 0 on success.
+ */
+int __must_check __panel_register(struct panel *panel, struct module *owner)
+{
+	struct panel_notifier *notifier;
+
+	kref_init(&panel->ref);
+	panel->owner = owner;
+	panel->enable = PANEL_ENABLE_OFF;
+
+	mutex_lock(&panel_mutex);
+	list_add(&panel->list, &panel_list);
+
+	list_for_each_entry(notifier, &panel_notifiers, list) {
+		if (!panel_notifier_match(panel, notifier))
+			continue;
+
+		if (notifier->notify(notifier, panel, PANEL_NOTIFIER_CONNECT))
+			break;
+	}
+	mutex_unlock(&panel_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__panel_register);
+
+/**
+ * panel_unregister - unregister a display panel
+ * @panel: panel to be unregistered
+ *
+ * Unregister the panel and send the PANEL_NOTIFIER_DISCONNECT event to all
+ * matching registered notifiers.
+ */
+void panel_unregister(struct panel *panel)
+{
+	struct panel_notifier *notifier;
+
+	mutex_lock(&panel_mutex);
+	list_for_each_entry(notifier, &panel_notifiers, list) {
+		if (!panel_notifier_match(panel, notifier))
+			continue;
+
+		notifier->notify(notifier, panel, PANEL_NOTIFIER_DISCONNECT);
+	}
+
+	list_del(&panel->list);
+	mutex_unlock(&panel_mutex);
+
+	panel_put(panel);
+}
+EXPORT_SYMBOL_GPL(panel_unregister);
+
+static int __init panel_init(void)
+{
+	return 0;
+}
+
+static void __exit panel_exit(void)
+{
+}
+
+module_init(panel_init);
+module_exit(panel_exit)
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("Display Panel Core");
+MODULE_LICENSE("GPL");
diff --git a/include/video/panel.h b/include/video/panel.h
new file mode 100644
index 0000000..bb11141
--- /dev/null
+++ b/include/video/panel.h
@@ -0,0 +1,111 @@
+/*
+ * Display Panel
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
+#ifndef __PANEL_H__
+#define __PANEL_H__
+
+#include <linux/fb.h>
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/module.h>
+
+struct panel;
+
+#define PANEL_NOTIFIER_CONNECT		1
+#define PANEL_NOTIFIER_DISCONNECT	2
+
+struct panel_notifier {
+	int (*notify)(struct panel_notifier *, struct panel *, int);
+	struct device *dev;
+	struct list_head list;
+};
+
+enum panel_enable_mode {
+	PANEL_ENABLE_OFF,
+	PANEL_ENABLE_BLANK,
+	PANEL_ENABLE_ON,
+};
+
+struct panel_ops {
+	int (*enable)(struct panel *panel, enum panel_enable_mode enable);
+	int (*start_transfer)(struct panel *panel);
+	int (*get_modes)(struct panel *panel,
+			 const struct fb_videomode **modes);
+};
+
+struct panel {
+	struct list_head list;
+	struct device *dev;
+	struct module *owner;
+	struct kref ref;
+
+	const struct panel_ops *ops;
+	void(*release)(struct panel *panel);
+
+	unsigned int width;
+	unsigned int height;
+
+	enum panel_enable_mode enable;
+};
+
+/**
+ * panel_enable - Set the panel operation mode
+ * @panel: The panel
+ * @enable: Panel operation mode
+ *
+ * - PANEL_ENABLE_OFF turns the panel off completely, possibly including its
+ *   power supplies. Communication with a panel in that mode is not possible.
+ * - PANEL_ENABLE_BLANK turns the panel on but keep the output blanked. Full
+ *   communication with the panel is supported, including pixel data transfer.
+ * - PANEL_ENABLE_ON turns the whole panel on, including the output.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int panel_enable(struct panel *panel, enum panel_enable_mode enable);
+
+/**
+ * panel_start_transfer - Start frame transfer
+ * @panel: The panel
+ *
+ * Make the panel ready to receive pixel data and start frame transfer. This
+ * operation can only be called if the panel is in BLANK or ON mode.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int panel_start_transfer(struct panel *panel);
+
+/**
+ * panel_get_modes - Get video modes supported by the panel
+ * @panel: The panel
+ * @modes: Pointer to an array of modes
+ *
+ * Fill the modes argument with a pointer to an array of video modes. The array
+ * is owned by the panel.
+ *
+ * Return the number of supported modes on success (including 0 if no mode is
+ * supported) or a negative error code otherwise.
+ */
+int panel_get_modes(struct panel *panel, const struct fb_videomode **modes);
+
+struct panel *panel_get(struct panel *panel);
+void panel_put(struct panel *panel);
+
+int __must_check __panel_register(struct panel *panel, struct module *owner);
+void panel_unregister(struct panel *panel);
+
+int panel_register_notifier(struct panel_notifier *notifier);
+void panel_unregister_notifier(struct panel_notifier *notifier);
+
+#define panel_register(panel) \
+	__panel_register(panel, THIS_MODULE)
+
+#endif /* __PANEL_H__ */
-- 
1.7.8.6

