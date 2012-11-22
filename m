Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38058 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab2KVVon (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 16:44:43 -0500
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
Subject: [RFC v2 1/5] video: Add generic display entity core
Date: Thu, 22 Nov 2012 22:45:32 +0100
Message-Id: <1353620736-6517-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/Kconfig                |    1 +
 drivers/video/Makefile               |    1 +
 drivers/video/display/Kconfig        |    4 +
 drivers/video/display/Makefile       |    1 +
 drivers/video/display/display-core.c |  362 ++++++++++++++++++++++++++++++++++
 include/video/display.h              |  150 ++++++++++++++
 6 files changed, 519 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/display/Kconfig
 create mode 100644 drivers/video/display/Makefile
 create mode 100644 drivers/video/display/display-core.c
 create mode 100644 include/video/display.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index c5b7bcf..e91f03e 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2442,6 +2442,7 @@ source "drivers/video/omap/Kconfig"
 source "drivers/video/omap2/Kconfig"
 source "drivers/video/exynos/Kconfig"
 source "drivers/video/backlight/Kconfig"
+source "drivers/video/display/Kconfig"
 
 if VT
 	source "drivers/video/console/Kconfig"
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index b936b00..0a4cfea 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -14,6 +14,7 @@ fb-objs                           := $(fb-y)
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
index 0000000..bd93496
--- /dev/null
+++ b/drivers/video/display/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DISPLAY_CORE) += display-core.o
diff --git a/drivers/video/display/display-core.c b/drivers/video/display/display-core.c
new file mode 100644
index 0000000..358c089
--- /dev/null
+++ b/drivers/video/display/display-core.c
@@ -0,0 +1,362 @@
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
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/videomode.h>
+
+#include <video/display.h>
+
+static LIST_HEAD(display_entity_list);
+static LIST_HEAD(display_entity_notifiers);
+static DEFINE_MUTEX(display_entity_mutex);
+
+/* -----------------------------------------------------------------------------
+ * Control operations
+ */
+
+/**
+ * display_entity_set_state - Set the display entity operation state
+ * @entity: The display entity
+ * @state: Display entity operation state
+ *
+ * See &enum display_entity_state for information regarding the entity states.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_set_state(struct display_entity *entity,
+			     enum display_entity_state state)
+{
+	int ret;
+
+	if (entity->state == state)
+		return 0;
+
+	if (!entity->ops.ctrl || !entity->ops.ctrl->set_state)
+		return 0;
+
+	ret = entity->ops.ctrl->set_state(entity, state);
+	if (ret < 0)
+		return ret;
+
+	entity->state = state;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(display_entity_set_state);
+
+/**
+ * display_entity_update - Update the display
+ * @entity: The display entity
+ *
+ * Make the display entity ready to receive pixel data and start frame transfer.
+ * This operation can only be called if the display entity is in STANDBY or ON
+ * state.
+ *
+ * The display entity will call the upstream entity in the video chain to start
+ * the video stream.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_update(struct display_entity *entity)
+{
+	if (!entity->ops.ctrl || !entity->ops.ctrl->update)
+		return 0;
+
+	return entity->ops.ctrl->update(entity);
+}
+EXPORT_SYMBOL_GPL(display_entity_update);
+
+/**
+ * display_entity_get_modes - Get video modes supported by the display entity
+ * @entity The display entity
+ * @modes: Pointer to an array of modes
+ *
+ * Fill the modes argument with a pointer to an array of video modes. The array
+ * is owned by the display entity.
+ *
+ * Return the number of supported modes on success (including 0 if no mode is
+ * supported) or a negative error code otherwise.
+ */
+int display_entity_get_modes(struct display_entity *entity,
+			     const struct videomode **modes)
+{
+	if (!entity->ops.ctrl || !entity->ops.ctrl->get_modes)
+		return 0;
+
+	return entity->ops.ctrl->get_modes(entity, modes);
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
+	if (!entity->ops.ctrl || !entity->ops.ctrl->get_size)
+		return -EOPNOTSUPP;
+
+	return entity->ops.ctrl->get_size(entity, width, height);
+}
+EXPORT_SYMBOL_GPL(display_entity_get_size);
+
+/**
+ * display_entity_get_params - Get display entity interface parameters
+ * @entity: The display entity
+ * @params: Pointer to interface parameters
+ *
+ * Fill the parameters structure pointed to by the params argument with display
+ * entity interface parameters.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_get_params(struct display_entity *entity,
+			      struct display_entity_interface_params *params)
+{
+	if (!entity->ops.ctrl || !entity->ops.ctrl->get_modes)
+		return -EOPNOTSUPP;
+
+	return entity->ops.ctrl->get_params(entity, params);
+}
+EXPORT_SYMBOL_GPL(display_entity_get_params);
+
+/* -----------------------------------------------------------------------------
+ * Video operations
+ */
+
+/**
+ * display_entity_set_stream - Control the video stream state
+ * @entity: The display entity
+ * @state: Display video stream state
+ *
+ * Control the video stream state at the entity video output.
+ *
+ * See &enum display_entity_stream_state for information regarding the stream
+ * states.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_set_stream(struct display_entity *entity,
+			      enum display_entity_stream_state state)
+{
+	if (!entity->ops.video || !entity->ops.video->set_stream)
+		return 0;
+
+	return entity->ops.video->set_stream(entity, state);
+}
+EXPORT_SYMBOL_GPL(display_entity_set_stream);
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
+ * Registration and notification
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
+ * @display_entity: the display entity
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
+static int display_entity_notifier_match(struct display_entity *entity,
+				struct display_entity_notifier *notifier)
+{
+	return notifier->dev == NULL || notifier->dev == entity->dev;
+}
+
+/**
+ * display_entity_register_notifier - register a display entity notifier
+ * @notifier: display entity notifier structure we want to register
+ *
+ * Display entity notifiers are called to notify drivers of display
+ * entity-related events for matching display_entitys.
+ *
+ * Notifiers and display_entitys are matched through the device they correspond
+ * to. If the notifier dev field is equal to the display entity dev field the
+ * notifier will be called when an event is reported. Notifiers with a NULL dev
+ * field act as catch-all and will be called for all display_entitys.
+ *
+ * Supported events are
+ *
+ * - DISPLAY_ENTITY_NOTIFIER_CONNECT reports display entity connection and is
+ *   sent at display entity or notifier registration time
+ * - DISPLAY_ENTITY_NOTIFIER_DISCONNECT reports display entity disconnection and
+ *   is sent at display entity unregistration time
+ *
+ * Registering a notifier sends DISPLAY_ENTITY_NOTIFIER_CONNECT events for all
+ * previously registered display_entitys that match the notifiers.
+ *
+ * Return 0 on success.
+ */
+int display_entity_register_notifier(struct display_entity_notifier *notifier)
+{
+	struct display_entity *entity;
+
+	mutex_lock(&display_entity_mutex);
+	list_add_tail(&notifier->list, &display_entity_notifiers);
+
+	list_for_each_entry(entity, &display_entity_list, list) {
+		if (!display_entity_notifier_match(entity, notifier))
+			continue;
+
+		if (notifier->notify(notifier, entity,
+				     DISPLAY_ENTITY_NOTIFIER_CONNECT))
+			break;
+	}
+	mutex_unlock(&display_entity_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(display_entity_register_notifier);
+
+/**
+ * display_entity_unregister_notifier - unregister a display entity notifier
+ * @notifier: display entity notifier to be unregistered
+ *
+ * Unregistration guarantees that the notifier will never be called upon return
+ * of this function.
+ */
+void display_entity_unregister_notifier(struct display_entity_notifier *notifier)
+{
+	mutex_lock(&display_entity_mutex);
+	list_del(&notifier->list);
+	mutex_unlock(&display_entity_mutex);
+}
+EXPORT_SYMBOL_GPL(display_entity_unregister_notifier);
+
+/**
+ * display_entity_register - register a display entity
+ * @display_entity: display entity to be registered
+ *
+ * Register the display entity and send the DISPLAY_ENTITY_NOTIFIER_CONNECT
+ * event to all matching registered notifiers.
+ *
+ * Return 0 on success.
+ */
+int __must_check __display_entity_register(struct display_entity *entity,
+					   struct module *owner)
+{
+	struct display_entity_notifier *notifier;
+
+	kref_init(&entity->ref);
+	entity->owner = owner;
+	entity->state = DISPLAY_ENTITY_STATE_OFF;
+
+	mutex_lock(&display_entity_mutex);
+	list_add(&entity->list, &display_entity_list);
+
+	list_for_each_entry(notifier, &display_entity_notifiers, list) {
+		if (!display_entity_notifier_match(entity, notifier))
+			continue;
+
+		if (notifier->notify(notifier, entity,
+				     DISPLAY_ENTITY_NOTIFIER_CONNECT))
+			break;
+	}
+	mutex_unlock(&display_entity_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__display_entity_register);
+
+/**
+ * display_entity_unregister - unregister a display entity
+ * @display_entity: display entity to be unregistered
+ *
+ * Unregister the display entity and send the DISPLAY_ENTITY_NOTIFIER_DISCONNECT
+ * event to all matching registered notifiers.
+ */
+void display_entity_unregister(struct display_entity *entity)
+{
+	struct display_entity_notifier *notifier;
+
+	mutex_lock(&display_entity_mutex);
+	list_for_each_entry(notifier, &display_entity_notifiers, list) {
+		if (!display_entity_notifier_match(entity, notifier))
+			continue;
+
+		notifier->notify(notifier, entity,
+				 DISPLAY_ENTITY_NOTIFIER_DISCONNECT);
+	}
+
+	list_del(&entity->list);
+	mutex_unlock(&display_entity_mutex);
+
+	display_entity_put(entity);
+}
+EXPORT_SYMBOL_GPL(display_entity_unregister);
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("Display Core");
+MODULE_LICENSE("GPL");
diff --git a/include/video/display.h b/include/video/display.h
new file mode 100644
index 0000000..90d18ca
--- /dev/null
+++ b/include/video/display.h
@@ -0,0 +1,150 @@
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
+
+/* -----------------------------------------------------------------------------
+ * Display Entity
+ */
+
+struct display_entity;
+struct videomode;
+
+#define DISPLAY_ENTITY_NOTIFIER_CONNECT		1
+#define DISPLAY_ENTITY_NOTIFIER_DISCONNECT	2
+
+struct display_entity_notifier {
+	int (*notify)(struct display_entity_notifier *, struct display_entity *,
+		      int);
+	struct device *dev;
+	struct list_head list;
+};
+
+/**
+ * enum display_entity_state - State of a display entity
+ * @DISPLAY_ENTITY_STATE_OFF: The entity is turned off completely, possibly
+ *	including its power supplies. Communication with a display entity in
+ *	that state is not possible.
+ * @DISPLAY_ENTITY_STATE_STANDBY: The entity is in a low-power state. Full
+ *	communication with the display entity is supported, including pixel data
+ *	transfer, but the output is kept blanked.
+ * @DISPLAY_ENTITY_STATE_ON: The entity is fully operational.
+ */
+enum display_entity_state {
+	DISPLAY_ENTITY_STATE_OFF,
+	DISPLAY_ENTITY_STATE_STANDBY,
+	DISPLAY_ENTITY_STATE_ON,
+};
+
+/**
+ * enum display_entity_stream_state - State of a video stream
+ * @DISPLAY_ENTITY_STREAM_STOPPED: The video stream is stopped, no frames are
+ *	transferred.
+ * @DISPLAY_ENTITY_STREAM_SINGLE_SHOT: The video stream has been started for
+ *      single shot operation. The source entity will transfer a single frame
+ *      and then stop.
+ * @DISPLAY_ENTITY_STREAM_CONTINUOUS: The video stream is running, frames are
+ *	transferred continuously by the source entity.
+ */
+enum display_entity_stream_state {
+	DISPLAY_ENTITY_STREAM_STOPPED,
+	DISPLAY_ENTITY_STREAM_SINGLE_SHOT,
+	DISPLAY_ENTITY_STREAM_CONTINUOUS,
+};
+
+enum display_entity_interface_type {
+	DISPLAY_ENTITY_INTERFACE_DPI,
+};
+
+struct display_entity_interface_params {
+	enum display_entity_interface_type type;
+};
+
+struct display_entity_control_ops {
+	int (*set_state)(struct display_entity *ent,
+			 enum display_entity_state state);
+	int (*update)(struct display_entity *ent);
+	int (*get_modes)(struct display_entity *ent,
+			 const struct videomode **modes);
+	int (*get_params)(struct display_entity *ent,
+			  struct display_entity_interface_params *params);
+	int (*get_size)(struct display_entity *ent,
+			unsigned int *width, unsigned int *height);
+};
+
+struct display_entity_video_ops {
+	int (*set_stream)(struct display_entity *ent,
+			  enum display_entity_stream_state state);
+};
+
+struct display_entity {
+	struct list_head list;
+	struct device *dev;
+	struct module *owner;
+	struct kref ref;
+
+	struct display_entity *source;
+
+	struct {
+		const struct display_entity_control_ops *ctrl;
+		const struct display_entity_video_ops *video;
+	} ops;
+
+	void(*release)(struct display_entity *ent);
+
+	enum display_entity_state state;
+};
+
+int display_entity_set_state(struct display_entity *entity,
+			     enum display_entity_state state);
+int display_entity_update(struct display_entity *entity);
+int display_entity_get_modes(struct display_entity *entity,
+			     const struct videomode **modes);
+int display_entity_get_params(struct display_entity *entity,
+			      struct display_entity_interface_params *params);
+int display_entity_get_size(struct display_entity *entity,
+			    unsigned int *width, unsigned int *height);
+
+int display_entity_set_stream(struct display_entity *entity,
+			      enum display_entity_stream_state state);
+
+static inline void display_entity_connect(struct display_entity *source,
+					  struct display_entity *sink)
+{
+	sink->source = source;
+}
+
+static inline void display_entity_disconnect(struct display_entity *source,
+					     struct display_entity *sink)
+{
+	sink->source = NULL;
+}
+
+struct display_entity *display_entity_get(struct display_entity *entity);
+void display_entity_put(struct display_entity *entity);
+
+int __must_check __display_entity_register(struct display_entity *entity,
+					   struct module *owner);
+void display_entity_unregister(struct display_entity *entity);
+
+int display_entity_register_notifier(struct display_entity_notifier *notifier);
+void display_entity_unregister_notifier(struct display_entity_notifier *notifier);
+
+#define display_entity_register(display_entity) \
+	__display_entity_register(display_entity, THIS_MODULE)
+
+#endif /* __DISPLAY_H__ */
-- 
1.7.8.6

