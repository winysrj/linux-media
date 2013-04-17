Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:33885 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966490Ab3DQPRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 11:17:39 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC 01/10] video: Add generic display entity core
Date: Wed, 17 Apr 2013 16:17:13 +0100
Message-Id: <1366211842-21497-2-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
References: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/Kconfig                |    1 +
 drivers/video/Makefile               |    1 +
 drivers/video/display/Kconfig        |    4 +
 drivers/video/display/Makefile       |    1 +
 drivers/video/display/display-core.c |  362 ++++++++++++++++++++++++++++++=
++++
 include/video/display.h              |  150 ++++++++++++++
 6 files changed, 519 insertions(+)
 create mode 100644 drivers/video/display/Kconfig
 create mode 100644 drivers/video/display/Makefile
 create mode 100644 drivers/video/display/display-core.c
 create mode 100644 include/video/display.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4c1546f..281e548 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2456,6 +2456,7 @@ source "drivers/video/omap2/Kconfig"
 source "drivers/video/exynos/Kconfig"
 source "drivers/video/mmp/Kconfig"
 source "drivers/video/backlight/Kconfig"
+source "drivers/video/display/Kconfig"
=20
 if VT
 =09source "drivers/video/console/Kconfig"
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 9df3873..b989e8e 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -15,6 +15,7 @@ fb-objs                           :=3D $(fb-y)
 obj-$(CONFIG_VT)=09=09  +=3D console/
 obj-$(CONFIG_LOGO)=09=09  +=3D logo/
 obj-y=09=09=09=09  +=3D backlight/
+obj-y=09=09=09=09  +=3D display/
=20
 obj-$(CONFIG_EXYNOS_VIDEO)     +=3D exynos/
=20
diff --git a/drivers/video/display/Kconfig b/drivers/video/display/Kconfig
new file mode 100644
index 0000000..1d533e7
--- /dev/null
+++ b/drivers/video/display/Kconfig
@@ -0,0 +1,4 @@
+menuconfig DISPLAY_CORE
+=09tristate "Display Core"
+=09---help---
+=09  Support common display framework for graphics devices.
diff --git a/drivers/video/display/Makefile b/drivers/video/display/Makefil=
e
new file mode 100644
index 0000000..bd93496
--- /dev/null
+++ b/drivers/video/display/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DISPLAY_CORE) +=3D display-core.o
diff --git a/drivers/video/display/display-core.c b/drivers/video/display/d=
isplay-core.c
new file mode 100644
index 0000000..d2daa15
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
+
+#include <video/display.h>
+#include <video/videomode.h>
+
+static LIST_HEAD(display_entity_list);
+static LIST_HEAD(display_entity_notifiers);
+static DEFINE_MUTEX(display_entity_mutex);
+
+/* -----------------------------------------------------------------------=
------
+ * Control operations
+ */
+
+/**
+ * display_entity_set_state - Set the display entity operation state
+ * @entity: The display entity
+ * @state: Display entity operation state
+ *
+ * See &enum display_entity_state for information regarding the entity sta=
tes.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_set_state(struct display_entity *entity,
+=09=09=09     enum display_entity_state state)
+{
+=09int ret;
+
+=09if (entity->state =3D=3D state)
+=09=09return 0;
+
+=09if (!entity->ops.ctrl || !entity->ops.ctrl->set_state)
+=09=09return 0;
+
+=09ret =3D entity->ops.ctrl->set_state(entity, state);
+=09if (ret < 0)
+=09=09return ret;
+
+=09entity->state =3D state;
+=09return 0;
+}
+EXPORT_SYMBOL_GPL(display_entity_set_state);
+
+/**
+ * display_entity_update - Update the display
+ * @entity: The display entity
+ *
+ * Make the display entity ready to receive pixel data and start frame tra=
nsfer.
+ * This operation can only be called if the display entity is in STANDBY o=
r ON
+ * state.
+ *
+ * The display entity will call the upstream entity in the video chain to =
start
+ * the video stream.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_update(struct display_entity *entity)
+{
+=09if (!entity->ops.ctrl || !entity->ops.ctrl->update)
+=09=09return 0;
+
+=09return entity->ops.ctrl->update(entity);
+}
+EXPORT_SYMBOL_GPL(display_entity_update);
+
+/**
+ * display_entity_get_modes - Get video modes supported by the display ent=
ity
+ * @entity The display entity
+ * @modes: Pointer to an array of modes
+ *
+ * Fill the modes argument with a pointer to an array of video modes. The =
array
+ * is owned by the display entity.
+ *
+ * Return the number of supported modes on success (including 0 if no mode=
 is
+ * supported) or a negative error code otherwise.
+ */
+int display_entity_get_modes(struct display_entity *entity,
+=09=09=09     const struct videomode **modes)
+{
+=09if (!entity->ops.ctrl || !entity->ops.ctrl->get_modes)
+=09=09return 0;
+
+=09return entity->ops.ctrl->get_modes(entity, modes);
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
+=09=09=09    unsigned int *width, unsigned int *height)
+{
+=09if (!entity->ops.ctrl || !entity->ops.ctrl->get_size)
+=09=09return -EOPNOTSUPP;
+
+=09return entity->ops.ctrl->get_size(entity, width, height);
+}
+EXPORT_SYMBOL_GPL(display_entity_get_size);
+
+/**
+ * display_entity_get_params - Get display entity interface parameters
+ * @entity: The display entity
+ * @params: Pointer to interface parameters
+ *
+ * Fill the parameters structure pointed to by the params argument with di=
splay
+ * entity interface parameters.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_get_params(struct display_entity *entity,
+=09=09=09      struct display_entity_interface_params *params)
+{
+=09if (!entity->ops.ctrl || !entity->ops.ctrl->get_modes)
+=09=09return -EOPNOTSUPP;
+
+=09return entity->ops.ctrl->get_params(entity, params);
+}
+EXPORT_SYMBOL_GPL(display_entity_get_params);
+
+/* -----------------------------------------------------------------------=
------
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
+ * See &enum display_entity_stream_state for information regarding the str=
eam
+ * states.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_set_stream(struct display_entity *entity,
+=09=09=09      enum display_entity_stream_state state)
+{
+=09if (!entity->ops.video || !entity->ops.video->set_stream)
+=09=09return 0;
+
+=09return entity->ops.video->set_stream(entity, state);
+}
+EXPORT_SYMBOL_GPL(display_entity_set_stream);
+
+/* -----------------------------------------------------------------------=
------
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
+ * display_entity_disconnect - Disconnect two previously connected entitie=
s
+ * @source: The video stream source
+ * @sink: The video stream sink
+ *
+ * Break a connection between two previously connected entities. The sourc=
e
+ * entity source field is reset to NULL.
+ */
+
+/* -----------------------------------------------------------------------=
------
+ * Registration and notification
+ */
+
+static void display_entity_release(struct kref *ref)
+{
+=09struct display_entity *entity =3D
+=09=09container_of(ref, struct display_entity, ref);
+
+=09if (entity->release)
+=09=09entity->release(entity);
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
+=09if (entity =3D=3D NULL)
+=09=09return NULL;
+
+=09kref_get(&entity->ref);
+=09return entity;
+}
+EXPORT_SYMBOL_GPL(display_entity_get);
+
+/**
+ * display_entity_put - release a reference to a display entity
+ * @display_entity: the display entity
+ *
+ * Releasing the last reference to a display entity releases the display e=
ntity
+ * itself.
+ */
+void display_entity_put(struct display_entity *entity)
+{
+=09kref_put(&entity->ref, display_entity_release);
+}
+EXPORT_SYMBOL_GPL(display_entity_put);
+
+static int display_entity_notifier_match(struct display_entity *entity,
+=09=09=09=09struct display_entity_notifier *notifier)
+{
+=09return notifier->dev =3D=3D NULL || notifier->dev =3D=3D entity->dev;
+}
+
+/**
+ * display_entity_register_notifier - register a display entity notifier
+ * @notifier: display entity notifier structure we want to register
+ *
+ * Display entity notifiers are called to notify drivers of display
+ * entity-related events for matching display_entitys.
+ *
+ * Notifiers and display_entitys are matched through the device they corre=
spond
+ * to. If the notifier dev field is equal to the display entity dev field =
the
+ * notifier will be called when an event is reported. Notifiers with a NUL=
L dev
+ * field act as catch-all and will be called for all display_entitys.
+ *
+ * Supported events are
+ *
+ * - DISPLAY_ENTITY_NOTIFIER_CONNECT reports display entity connection and=
 is
+ *   sent at display entity or notifier registration time
+ * - DISPLAY_ENTITY_NOTIFIER_DISCONNECT reports display entity disconnecti=
on and
+ *   is sent at display entity unregistration time
+ *
+ * Registering a notifier sends DISPLAY_ENTITY_NOTIFIER_CONNECT events for=
 all
+ * previously registered display_entitys that match the notifiers.
+ *
+ * Return 0 on success.
+ */
+int display_entity_register_notifier(struct display_entity_notifier *notif=
ier)
+{
+=09struct display_entity *entity;
+
+=09mutex_lock(&display_entity_mutex);
+=09list_add_tail(&notifier->list, &display_entity_notifiers);
+
+=09list_for_each_entry(entity, &display_entity_list, list) {
+=09=09if (!display_entity_notifier_match(entity, notifier))
+=09=09=09continue;
+
+=09=09if (notifier->notify(notifier, entity,
+=09=09=09=09     DISPLAY_ENTITY_NOTIFIER_CONNECT))
+=09=09=09break;
+=09}
+=09mutex_unlock(&display_entity_mutex);
+
+=09return 0;
+}
+EXPORT_SYMBOL_GPL(display_entity_register_notifier);
+
+/**
+ * display_entity_unregister_notifier - unregister a display entity notifi=
er
+ * @notifier: display entity notifier to be unregistered
+ *
+ * Unregistration guarantees that the notifier will never be called upon r=
eturn
+ * of this function.
+ */
+void display_entity_unregister_notifier(struct display_entity_notifier *no=
tifier)
+{
+=09mutex_lock(&display_entity_mutex);
+=09list_del(&notifier->list);
+=09mutex_unlock(&display_entity_mutex);
+}
+EXPORT_SYMBOL_GPL(display_entity_unregister_notifier);
+
+/**
+ * display_entity_register - register a display entity
+ * @display_entity: display entity to be registered
+ *
+ * Register the display entity and send the DISPLAY_ENTITY_NOTIFIER_CONNEC=
T
+ * event to all matching registered notifiers.
+ *
+ * Return 0 on success.
+ */
+int __must_check __display_entity_register(struct display_entity *entity,
+=09=09=09=09=09   struct module *owner)
+{
+=09struct display_entity_notifier *notifier;
+
+=09kref_init(&entity->ref);
+=09entity->owner =3D owner;
+=09entity->state =3D DISPLAY_ENTITY_STATE_OFF;
+
+=09mutex_lock(&display_entity_mutex);
+=09list_add(&entity->list, &display_entity_list);
+
+=09list_for_each_entry(notifier, &display_entity_notifiers, list) {
+=09=09if (!display_entity_notifier_match(entity, notifier))
+=09=09=09continue;
+
+=09=09if (notifier->notify(notifier, entity,
+=09=09=09=09     DISPLAY_ENTITY_NOTIFIER_CONNECT))
+=09=09=09break;
+=09}
+=09mutex_unlock(&display_entity_mutex);
+
+=09return 0;
+}
+EXPORT_SYMBOL_GPL(__display_entity_register);
+
+/**
+ * display_entity_unregister - unregister a display entity
+ * @display_entity: display entity to be unregistered
+ *
+ * Unregister the display entity and send the DISPLAY_ENTITY_NOTIFIER_DISC=
ONNECT
+ * event to all matching registered notifiers.
+ */
+void display_entity_unregister(struct display_entity *entity)
+{
+=09struct display_entity_notifier *notifier;
+
+=09mutex_lock(&display_entity_mutex);
+=09list_for_each_entry(notifier, &display_entity_notifiers, list) {
+=09=09if (!display_entity_notifier_match(entity, notifier))
+=09=09=09continue;
+
+=09=09notifier->notify(notifier, entity,
+=09=09=09=09 DISPLAY_ENTITY_NOTIFIER_DISCONNECT);
+=09}
+
+=09list_del(&entity->list);
+=09mutex_unlock(&display_entity_mutex);
+
+=09display_entity_put(entity);
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
+/* -----------------------------------------------------------------------=
------
+ * Display Entity
+ */
+
+struct display_entity;
+struct videomode;
+
+#define DISPLAY_ENTITY_NOTIFIER_CONNECT=09=091
+#define DISPLAY_ENTITY_NOTIFIER_DISCONNECT=092
+
+struct display_entity_notifier {
+=09int (*notify)(struct display_entity_notifier *, struct display_entity *=
,
+=09=09      int);
+=09struct device *dev;
+=09struct list_head list;
+};
+
+/**
+ * enum display_entity_state - State of a display entity
+ * @DISPLAY_ENTITY_STATE_OFF: The entity is turned off completely, possibl=
y
+ *=09including its power supplies. Communication with a display entity in
+ *=09that state is not possible.
+ * @DISPLAY_ENTITY_STATE_STANDBY: The entity is in a low-power state. Full
+ *=09communication with the display entity is supported, including pixel d=
ata
+ *=09transfer, but the output is kept blanked.
+ * @DISPLAY_ENTITY_STATE_ON: The entity is fully operational.
+ */
+enum display_entity_state {
+=09DISPLAY_ENTITY_STATE_OFF,
+=09DISPLAY_ENTITY_STATE_STANDBY,
+=09DISPLAY_ENTITY_STATE_ON,
+};
+
+/**
+ * enum display_entity_stream_state - State of a video stream
+ * @DISPLAY_ENTITY_STREAM_STOPPED: The video stream is stopped, no frames =
are
+ *=09transferred.
+ * @DISPLAY_ENTITY_STREAM_SINGLE_SHOT: The video stream has been started f=
or
+ *      single shot operation. The source entity will transfer a single fr=
ame
+ *      and then stop.
+ * @DISPLAY_ENTITY_STREAM_CONTINUOUS: The video stream is running, frames =
are
+ *=09transferred continuously by the source entity.
+ */
+enum display_entity_stream_state {
+=09DISPLAY_ENTITY_STREAM_STOPPED,
+=09DISPLAY_ENTITY_STREAM_SINGLE_SHOT,
+=09DISPLAY_ENTITY_STREAM_CONTINUOUS,
+};
+
+enum display_entity_interface_type {
+=09DISPLAY_ENTITY_INTERFACE_DPI,
+};
+
+struct display_entity_interface_params {
+=09enum display_entity_interface_type type;
+};
+
+struct display_entity_control_ops {
+=09int (*set_state)(struct display_entity *ent,
+=09=09=09 enum display_entity_state state);
+=09int (*update)(struct display_entity *ent);
+=09int (*get_modes)(struct display_entity *ent,
+=09=09=09 const struct videomode **modes);
+=09int (*get_params)(struct display_entity *ent,
+=09=09=09  struct display_entity_interface_params *params);
+=09int (*get_size)(struct display_entity *ent,
+=09=09=09unsigned int *width, unsigned int *height);
+};
+
+struct display_entity_video_ops {
+=09int (*set_stream)(struct display_entity *ent,
+=09=09=09  enum display_entity_stream_state state);
+};
+
+struct display_entity {
+=09struct list_head list;
+=09struct device *dev;
+=09struct module *owner;
+=09struct kref ref;
+
+=09struct display_entity *source;
+
+=09struct {
+=09=09const struct display_entity_control_ops *ctrl;
+=09=09const struct display_entity_video_ops *video;
+=09} ops;
+
+=09void(*release)(struct display_entity *ent);
+
+=09enum display_entity_state state;
+};
+
+int display_entity_set_state(struct display_entity *entity,
+=09=09=09     enum display_entity_state state);
+int display_entity_update(struct display_entity *entity);
+int display_entity_get_modes(struct display_entity *entity,
+=09=09=09     const struct videomode **modes);
+int display_entity_get_params(struct display_entity *entity,
+=09=09=09      struct display_entity_interface_params *params);
+int display_entity_get_size(struct display_entity *entity,
+=09=09=09    unsigned int *width, unsigned int *height);
+
+int display_entity_set_stream(struct display_entity *entity,
+=09=09=09      enum display_entity_stream_state state);
+
+static inline void display_entity_connect(struct display_entity *source,
+=09=09=09=09=09  struct display_entity *sink)
+{
+=09sink->source =3D source;
+}
+
+static inline void display_entity_disconnect(struct display_entity *source=
,
+=09=09=09=09=09     struct display_entity *sink)
+{
+=09sink->source =3D NULL;
+}
+
+struct display_entity *display_entity_get(struct display_entity *entity);
+void display_entity_put(struct display_entity *entity);
+
+int __must_check __display_entity_register(struct display_entity *entity,
+=09=09=09=09=09   struct module *owner);
+void display_entity_unregister(struct display_entity *entity);
+
+int display_entity_register_notifier(struct display_entity_notifier *notif=
ier);
+void display_entity_unregister_notifier(struct display_entity_notifier *no=
tifier);
+
+#define display_entity_register(display_entity) \
+=09__display_entity_register(display_entity, THIS_MODULE)
+
+#endif /* __DISPLAY_H__ */
--=20
1.7.10.4


