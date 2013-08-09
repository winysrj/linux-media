Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031434Ab3HIXCZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:25 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 04/19] video: display: Add display entity notifier
Date: Sat, 10 Aug 2013 01:03:03 +0200
Message-Id: <1376089398-13322-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Display entities are initialized by they respective drivers
asynchronously with the master display driver. The notifier
infrastructure allows display drivers to create a list of entities they
need (based on platform data) and be notified when those entities are
added to or removed from the system.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/video/display/Makefile           |   3 +-
 drivers/video/display/display-notifier.c | 304 +++++++++++++++++++++++++++++++
 include/video/display.h                  |  66 +++++++
 3 files changed, 372 insertions(+), 1 deletion(-)
 create mode 100644 drivers/video/display/display-notifier.c

diff --git a/drivers/video/display/Makefile b/drivers/video/display/Makefile
index 3054adc..b907aad 100644
--- a/drivers/video/display/Makefile
+++ b/drivers/video/display/Makefile
@@ -1,2 +1,3 @@
-display-y					:= display-core.o
+display-y					:= display-core.o \
+						   display-notifier.o
 obj-$(CONFIG_DISPLAY_CORE)			+= display.o
diff --git a/drivers/video/display/display-notifier.c b/drivers/video/display/display-notifier.c
new file mode 100644
index 0000000..c9210ec
--- /dev/null
+++ b/drivers/video/display/display-notifier.c
@@ -0,0 +1,304 @@
+/*
+ * Display Notifier
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
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+
+#include <video/display.h>
+
+static LIST_HEAD(display_entity_list);
+static LIST_HEAD(display_entity_notifiers);
+static DEFINE_MUTEX(display_entity_mutex);
+
+/* -----------------------------------------------------------------------------
+ * Notifiers
+ */
+
+static bool match_platform(struct device *dev,
+			   struct display_entity_match *match)
+{
+	pr_debug("%s: matching device '%s' with name '%s'\n", __func__,
+		 dev_name(dev), match->match.platform.name);
+
+	return !strcmp(match->match.platform.name, dev_name(dev));
+}
+
+static struct display_entity_match *
+display_entity_notifier_match(struct display_entity_notifier *notifier,
+			      struct display_entity *entity)
+{
+	bool (*match_func)(struct device *, struct display_entity_match *);
+	struct display_entity_match *match;
+
+	pr_debug("%s: matching entity '%s' (ptr 0x%p dev '%s')\n", __func__,
+		 entity->name, entity, dev_name(entity->dev));
+
+	list_for_each_entry(match, &notifier->waiting, list) {
+		switch (match->type) {
+		default:
+		case DISPLAY_ENTITY_BUS_PLATFORM:
+			match_func = match_platform;
+			break;
+		}
+
+		if (match_func(entity->dev, match))
+			return match;
+	}
+
+	return NULL;
+}
+
+static void display_entity_notifier_cleanup(struct display_entity *entity)
+{
+	entity->match = NULL;
+	entity->notifier = NULL;
+}
+
+static int
+display_entity_notifier_notify(struct display_entity_notifier *notifier,
+			       struct display_entity *entity,
+			       struct display_entity_match *match)
+{
+	int ret;
+
+	pr_debug("%s: notifying device '%s' for entity '%s' (ptr 0x%p dev '%s')\n",
+		 __func__, dev_name(notifier->dev), entity->name, entity,
+		 dev_name(entity->dev));
+
+	/* Remove the match from waiting list. */
+	list_del(&match->list);
+	entity->match = match;
+	entity->notifier = notifier;
+
+	if (notifier->bound) {
+		ret = notifier->bound(notifier, entity, match);
+		if (ret < 0)
+			goto error_bound;
+	}
+
+	/* Move the entity from the global list to the notifier's done list. */
+	list_move(&entity->list, &notifier->done);
+
+	if (list_empty(&notifier->waiting) && notifier->complete) {
+		pr_debug("%s: notifying device '%s' of completion\n", __func__,
+			 dev_name(notifier->dev));
+		ret = notifier->complete(notifier);
+		if (ret < 0)
+			goto error_complete;
+	}
+
+	return 0;
+
+error_complete:
+	/* Move the entity back to the global list. */
+	list_move(&entity->list, &display_entity_list);
+	if (notifier->unbind)
+		notifier->unbind(notifier, entity, match);
+error_bound:
+	/* Put the match back to the waiting list. */
+	list_add_tail(&match->list, &notifier->waiting);
+	display_entity_notifier_cleanup(entity);
+
+	return ret;
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
+	struct display_entity_match *match;
+	struct display_entity *entity;
+	struct display_entity *next;
+	unsigned int i;
+	int ret = 0;
+
+	if (notifier->num_entities == 0)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&notifier->waiting);
+	INIT_LIST_HEAD(&notifier->done);
+
+	for (i = 0; i < notifier->num_entities; i++) {
+		match = &notifier->entities[i];
+
+		switch (match->type) {
+		case DISPLAY_ENTITY_BUS_PLATFORM:
+			break;
+		default:
+			dev_err(notifier->dev,
+				"%s: Invalid bus type %u on %p\n", __func__,
+				match->type, match);
+			return -EINVAL;
+		}
+
+		list_add_tail(&match->list, &notifier->waiting);
+	}
+
+	mutex_lock(&display_entity_mutex);
+
+	list_add_tail(&notifier->list, &display_entity_notifiers);
+
+	list_for_each_entry_safe(entity, next, &display_entity_list, list) {
+		match = display_entity_notifier_match(notifier, entity);
+		if (!match)
+			continue;
+
+		ret = display_entity_notifier_notify(notifier, entity, match);
+		if (ret)
+			break;
+	}
+
+	mutex_unlock(&display_entity_mutex);
+
+	return ret;
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
+	struct display_entity *entity;
+	struct display_entity *next;
+
+	if (notifier->num_entities == 0)
+		return;
+
+	mutex_lock(&display_entity_mutex);
+
+	list_del(&notifier->list);
+
+	list_for_each_entry_safe(entity, next, &notifier->done, list) {
+		if (notifier->unbind)
+			notifier->unbind(notifier, entity, entity->match);
+
+		/* Move the entity back to the global list. */
+		display_entity_notifier_cleanup(entity);
+		list_move(&entity->list, &display_entity_list);
+	}
+	mutex_unlock(&display_entity_mutex);
+}
+EXPORT_SYMBOL_GPL(display_entity_unregister_notifier);
+
+/* -----------------------------------------------------------------------------
+ * Entity Registration
+ */
+
+/**
+ * display_entity_add - add a display entity to the list of available entities
+ * @entity: display entity to be added
+ *
+ * Add the display entity to the list of available entities and send the
+ * DISPLAY_ENTITY_NOTIFIER_CONNECT event to all matching registered notifiers.
+ *
+ * Return 0 on success.
+ */
+int display_entity_add(struct display_entity *entity)
+{
+	struct display_entity_notifier *notifier;
+	struct display_entity_match *match = NULL;
+
+	pr_debug("%s: adding entity '%s' (ptr 0x%p dev '%s')\n", __func__,
+		 entity->name, entity, dev_name(entity->dev));
+
+	mutex_lock(&display_entity_mutex);
+
+	/* Add the entity to the global unbound entities list. It will later be
+	 * moved to the notifier done list by display_entity_notifier_notify().
+	 */
+	list_add_tail(&entity->list, &display_entity_list);
+
+	list_for_each_entry(notifier, &display_entity_notifiers, list) {
+		match = display_entity_notifier_match(notifier, entity);
+		if (match)
+			break;
+	}
+
+	if (match) {
+		/* A match has been found, notify the notifier. */
+		display_entity_notifier_notify(notifier, entity, match);
+	}
+
+	mutex_unlock(&display_entity_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(display_entity_add);
+
+/**
+ * display_entity_remove - removea display entity
+ * @entity: display entity to be removed
+ *
+ * Remove the display entity from the list of available entities and send the
+ * DISPLAY_ENTITY_NOTIFIER_DISCONNECT event to all matching registered
+ * notifiers.
+ */
+void display_entity_remove(struct display_entity *entity)
+{
+	struct display_entity_notifier *notifier = entity->notifier;
+	struct display_entity_match *match = entity->match;
+
+	pr_debug("%s: removing entity '%s' (ptr 0x%p dev '%s')\n", __func__,
+		 entity->name, entity, dev_name(entity->dev));
+
+	if (!notifier) {
+		/* Remove the entity from the global list. */
+		list_del(&entity->list);
+		return;
+	}
+
+	mutex_lock(&display_entity_mutex);
+
+	if (notifier->unbind)
+		notifier->unbind(notifier, entity, match);
+
+	/* Remove the entity from the notifier's done list. */
+	display_entity_notifier_cleanup(entity);
+	list_del(&entity->list);
+
+	/* Move the match back to the waiting list. */
+	list_add_tail(&match->list, &notifier->waiting);
+
+	mutex_unlock(&display_entity_mutex);
+}
+EXPORT_SYMBOL_GPL(display_entity_remove);
diff --git a/include/video/display.h b/include/video/display.h
index fef05a68..2063694 100644
--- a/include/video/display.h
+++ b/include/video/display.h
@@ -23,6 +23,8 @@
  */
 
 struct display_entity;
+struct display_entity_match;
+struct display_entity_notify;
 struct videomode;
 
 /**
@@ -101,6 +103,9 @@ struct display_entity {
 	char name[32];
 	struct media_entity entity;
 
+	struct display_entity_match *match;
+	struct display_entity_notifier *notifier;
+
 	const struct display_entity_ops *ops;
 
 	void(*release)(struct display_entity *ent);
@@ -140,4 +145,65 @@ int display_entity_get_params(struct display_entity *entity, unsigned int port,
 int display_entity_set_stream(struct display_entity *entity, unsigned int port,
 			      enum display_entity_stream_state state);
 
+/* -----------------------------------------------------------------------------
+ * Notifier
+ */
+
+enum display_entity_bus_type {
+	DISPLAY_ENTITY_BUS_PLATFORM,
+};
+
+/**
+ * struct display_entity_match - Display entity description
+ * @type: display entity bus type
+ * @match.platform.name: platform device name
+ * @match.dt.node: DT node
+ * @list: link match objects waiting to be matched
+ */
+struct display_entity_match {
+	enum display_entity_bus_type type;
+	union {
+		struct {
+			const char *name;
+		} platform;
+	} match;
+
+	struct list_head list;
+};
+
+/**
+ * display_entity_notifier - display entity notifier
+ * @num_entities: number of display entities
+ * @entities: array of pointers to subdevice descriptors
+ * @waiting: list of struct v4l2_async_subdev, waiting for their drivers
+ * @done: list of struct v4l2_async_subdev_list, already probed
+ * @list: member in a global list of notifiers
+ * @bound: a display entity has been registered
+ * @complete: all display entities have been registered
+ * @unbind: a display entity is being unregistered
+ */
+struct display_entity_notifier {
+	struct device *dev;
+
+	unsigned int num_entities;
+	struct display_entity_match *entities;
+	struct list_head waiting;
+	struct list_head done;
+	struct list_head list;
+
+	int (*bound)(struct display_entity_notifier *notifier,
+		     struct display_entity *entity,
+		     struct display_entity_match *match);
+	int (*complete)(struct display_entity_notifier *notifier);
+	void (*unbind)(struct display_entity_notifier *notifier,
+		       struct display_entity *entity,
+		       struct display_entity_match *match);
+};
+
+int display_entity_register_notifier(struct display_entity_notifier *notifier);
+void display_entity_unregister_notifier(struct display_entity_notifier *notifier);
+
+int display_entity_add(struct display_entity *entity);
+void display_entity_remove(struct display_entity *entity);
+
 #endif /* __DISPLAY_H__ */
-- 
1.8.1.5

