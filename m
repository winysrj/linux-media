Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031416Ab3HIXCY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:24 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 02/19] video: Add Common Display Framework core
Date: Sat, 10 Aug 2013 01:03:01 +0200
Message-Id: <1376089398-13322-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Common Display Framework (CDF) splits display devices in entities
that interact through an abstract API. Each entity is managed by its own
driver independently of the other entities, with the framework
orchestrating interactions.

This commit introduces the CDF core with entity (un)registration and
core control operations support.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/Kconfig                |   1 +
 drivers/video/Makefile               |   1 +
 drivers/video/display/Kconfig        |   4 +
 drivers/video/display/Makefile       |   2 +
 drivers/video/display/display-core.c | 236 +++++++++++++++++++++++++++++++++++
 include/video/display.h              |  94 ++++++++++++++
 6 files changed, 338 insertions(+)
 create mode 100644 drivers/video/display/Kconfig
 create mode 100644 drivers/video/display/Makefile
 create mode 100644 drivers/video/display/display-core.c
 create mode 100644 include/video/display.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4cf1e1d..c9ca1d5 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2477,6 +2477,7 @@ source "drivers/video/omap2/Kconfig"
 source "drivers/video/exynos/Kconfig"
 source "drivers/video/mmp/Kconfig"
 source "drivers/video/backlight/Kconfig"
+source "drivers/video/display/Kconfig"
 
 if VT
 	source "drivers/video/console/Kconfig"
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index e8bae8d..d7fd4a2 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -15,6 +15,7 @@ fb-objs                           := $(fb-y)
 obj-$(CONFIG_VT)		  += console/
 obj-$(CONFIG_LOGO)		  += logo/
 obj-y				  += backlight/
+obj-y				  += display/
 
 obj-$(CONFIG_EXYNOS_VIDEO)     += exynos/
 
diff --git a/drivers/video/display/Kconfig b/drivers/video/display/Kconfig
new file mode 100644
index 0000000..1d533e7
--- /dev/null
+++ b/drivers/video/display/Kconfig
@@ -0,0 +1,4 @@
+menuconfig DISPLAY_CORE
+	tristate "Display Core"
+	---help---
+	  Support common display framework for graphics devices.
diff --git a/drivers/video/display/Makefile b/drivers/video/display/Makefile
new file mode 100644
index 0000000..3054adc
--- /dev/null
+++ b/drivers/video/display/Makefile
@@ -0,0 +1,2 @@
+display-y					:= display-core.o
+obj-$(CONFIG_DISPLAY_CORE)			+= display.o
diff --git a/drivers/video/display/display-core.c b/drivers/video/display/display-core.c
new file mode 100644
index 0000000..82fc58b
--- /dev/null
+++ b/drivers/video/display/display-core.c
@@ -0,0 +1,236 @@
+/*
+ * Display Core
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
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include <media/media-device.h>
+
+#include <video/display.h>
+#include <video/videomode.h>
+
+/* -----------------------------------------------------------------------------
+ * Control operations
+ */
+
+/**
+ * display_entity_get_modes - Get video modes supported by the display entity
+ * @entity: The display entity
+ * @port: The display entity port
+ * @modes: Pointer to an array of modes
+ *
+ * Fill the modes argument with a pointer to an array of video modes. The array
+ * is owned by the display entity.
+ *
+ * Return the number of supported modes on success (including 0 if no mode is
+ * supported) or a negative error code otherwise.
+ */
+int display_entity_get_modes(struct display_entity *entity, unsigned int port,
+			     const struct videomode **modes)
+{
+	if (port >= entity->entity.num_pads)
+		return -EINVAL;
+
+	if (!entity->ops->ctrl || !entity->ops->ctrl->get_modes)
+		return 0;
+
+	return entity->ops->ctrl->get_modes(entity, port, modes);
+}
+EXPORT_SYMBOL_GPL(display_entity_get_modes);
+
+/**
+ * display_entity_get_size - Get display entity physical size
+ * @entity: The display entity
+ * @width: Physical width in millimeters
+ * @height: Physical height in millimeters
+ *
+ * When applicable, for instance for display panels, retrieve the display
+ * physical size in millimeters.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_get_size(struct display_entity *entity,
+			    unsigned int *width, unsigned int *height)
+{
+	if (!entity->ops->ctrl || !entity->ops->ctrl->get_size)
+		return -EOPNOTSUPP;
+
+	return entity->ops->ctrl->get_size(entity, width, height);
+}
+EXPORT_SYMBOL_GPL(display_entity_get_size);
+
+/**
+ * display_entity_get_params - Get display entity interface parameters
+ * @entity: The display entity
+ * @port: The display entity port
+ * @params: Pointer to interface parameters
+ *
+ * Fill the parameters structure pointed to by the params argument with display
+ * entity interface parameters.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_get_params(struct display_entity *entity, unsigned int port,
+			      struct display_entity_interface_params *params)
+{
+	if (port >= entity->entity.num_pads)
+		return -EINVAL;
+
+	if (!entity->ops->ctrl || !entity->ops->ctrl->get_params)
+		return -EOPNOTSUPP;
+
+	return entity->ops->ctrl->get_params(entity, port, params);
+}
+EXPORT_SYMBOL_GPL(display_entity_get_params);
+
+/* -----------------------------------------------------------------------------
+ * Connections
+ */
+
+/**
+ * display_entity_connect - Connect two entities through a video stream
+ * @source: The video stream source
+ * @sink: The video stream sink
+ *
+ * Set the sink entity source field to the source entity.
+ */
+
+/**
+ * display_entity_disconnect - Disconnect two previously connected entities
+ * @source: The video stream source
+ * @sink: The video stream sink
+ *
+ * Break a connection between two previously connected entities. The source
+ * entity source field is reset to NULL.
+ */
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+static void display_entity_release(struct kref *ref)
+{
+	struct display_entity *entity =
+		container_of(ref, struct display_entity, ref);
+
+	if (entity->release)
+		entity->release(entity);
+}
+
+/**
+ * display_entity_get - get a reference to a display entity
+ * @display_entity: the display entity
+ *
+ * Return the display entity pointer.
+ */
+struct display_entity *display_entity_get(struct display_entity *entity)
+{
+	if (entity == NULL)
+		return NULL;
+
+	kref_get(&entity->ref);
+	return entity;
+}
+EXPORT_SYMBOL_GPL(display_entity_get);
+
+/**
+ * display_entity_put - release a reference to a display entity
+ * @entity: the display entity
+ *
+ * Releasing the last reference to a display entity releases the display entity
+ * itself.
+ */
+void display_entity_put(struct display_entity *entity)
+{
+	kref_put(&entity->ref, display_entity_release);
+}
+EXPORT_SYMBOL_GPL(display_entity_put);
+
+/**
+ * display_entity_init - Initialize a display entity
+ * @entity: display entity to be registered
+ * @num_sinks: number of sink ports
+ * @num_sources: number of source ports
+ *
+ * Initialize the display entity with the given number of sink and source ports.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_init(struct display_entity *entity, unsigned int num_sinks,
+			unsigned int num_sources)
+{
+	struct media_entity *ment = &entity->entity;
+	struct media_pad *pads;
+	unsigned int num_pads;
+	unsigned int i;
+	int ret;
+
+	kref_init(&entity->ref);
+
+	num_pads = num_sinks + num_sources;
+	pads = kzalloc(sizeof(*pads) * num_pads, GFP_KERNEL);
+	if (pads == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < num_sinks; ++i)
+		pads[i].flags = MEDIA_PAD_FL_SINK;
+	for (; i < num_pads; ++i)
+		pads[i].flags = MEDIA_PAD_FL_SOURCE;
+
+	ment->name = entity->name;
+
+	ret = media_entity_init(ment, num_pads, pads, 0);
+	if (ret < 0) {
+		kfree(pads);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(display_entity_init);
+
+/**
+ * display_entity_cleanup - Clean a display entity up
+ * @entity: display entity to be cleaned up
+ *
+ * Clean the entity up and free all resources allocated by by
+ * display_entity_init().
+ */
+void display_entity_cleanup(struct display_entity *entity)
+{
+	struct media_entity *ment = &entity->entity;
+
+	kfree(ment->pads);
+	media_entity_cleanup(ment);
+
+	display_entity_put(entity);
+}
+EXPORT_SYMBOL_GPL(display_entity_cleanup);
+
+int display_entity_register(struct media_device *mdev,
+			    struct display_entity *entity)
+{
+	return media_device_register_entity(mdev, &entity->entity);
+}
+EXPORT_SYMBOL_GPL(display_entity_register);
+
+void display_entity_unregister(struct display_entity *entity)
+{
+	media_device_unregister_entity(&entity->entity);
+}
+EXPORT_SYMBOL_GPL(display_entity_unregister);
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("Display Core");
+MODULE_LICENSE("GPL");
diff --git a/include/video/display.h b/include/video/display.h
new file mode 100644
index 0000000..74b227d
--- /dev/null
+++ b/include/video/display.h
@@ -0,0 +1,94 @@
+/*
+ * Display Core
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
+#ifndef __DISPLAY_H__
+#define __DISPLAY_H__
+
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <media/media-entity.h>
+
+/* -----------------------------------------------------------------------------
+ * Display Entity
+ */
+
+struct display_entity;
+struct videomode;
+
+enum display_entity_interface_type {
+	DISPLAY_ENTITY_INTERFACE_DPI,
+	DISPLAY_ENTITY_INTERFACE_DBI,
+	DISPLAY_ENTITY_INTERFACE_LVDS,
+	DISPLAY_ENTITY_INTERFACE_VGA,
+};
+
+struct display_entity_interface_params {
+	enum display_entity_interface_type type;
+};
+
+struct display_entity_control_ops {
+	int (*get_size)(struct display_entity *ent,
+			unsigned int *width, unsigned int *height);
+
+	/* Port operations */
+	int (*get_modes)(struct display_entity *entity, unsigned int port,
+			 const struct videomode **modes);
+	int (*get_params)(struct display_entity *entity, unsigned int port,
+			  struct display_entity_interface_params *params);
+};
+
+struct display_entity_ops {
+	const struct display_entity_control_ops *ctrl;
+};
+
+struct display_entity {
+	struct list_head list;
+	struct device *dev;
+	struct module *owner;
+	struct kref ref;
+
+	char name[32];
+	struct media_entity entity;
+
+	const struct display_entity_ops *ops;
+
+	void(*release)(struct display_entity *ent);
+};
+
+static inline struct display_entity *
+to_display_entity(struct media_entity *entity)
+{
+	return container_of(entity, struct display_entity, entity);
+}
+
+int __must_check display_entity_init(struct display_entity *entity,
+				     unsigned int num_sinks,
+				     unsigned int num_sources);
+void display_entity_cleanup(struct display_entity *entity);
+
+int display_entity_register(struct media_device *mdev,
+			    struct display_entity *entity);
+void display_entity_unregister(struct display_entity *entity);
+
+/* Operations */
+struct display_entity *display_entity_get(struct display_entity *entity);
+void display_entity_put(struct display_entity *entity);
+
+int display_entity_get_size(struct display_entity *entity,
+			    unsigned int *width, unsigned int *height);
+int display_entity_get_modes(struct display_entity *entity, unsigned int port,
+			     const struct videomode **modes);
+int display_entity_get_params(struct display_entity *entity, unsigned int port,
+			      struct display_entity_interface_params *params);
+
+#endif /* __DISPLAY_H__ */
-- 
1.8.1.5

