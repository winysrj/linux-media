Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52618 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752997AbcBURk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 12:40:29 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 2/4] v4l: Add generic pipeline power management code
Date: Sun, 21 Feb 2016 18:25:09 +0200
Message-Id: <1456071911-3284-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456071911-3284-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456071911-3284-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

When the Media controller framework was merged, it was decided not to add
pipeline power management code for it was not seen generic. As a result, a
number of drivers have copied the same piece of code, with same bugfixes
done to them at different points of time (or not at all).

Add these functions to V4L2. Their use is optional for drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-mc.c | 179 +++++++++++++++++++++++++++++++++++++-
 include/media/v4l2-mc.h           |  42 +++++++++
 2 files changed, 220 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index a7f41b3..1a6fda8 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -2,6 +2,8 @@
  * Media Controller ancillary functions
  *
  * (c) 2016 Mauro Carvalho Chehab <mchehab@osg.samsung.com>
+ * Copyright (C) 2006--2010 Nokia Corporation
+ * Copyright (c) 2016 Intel Corporation.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -17,9 +19,10 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/usb.h>
+#include <media/media-device.h>
 #include <media/media-entity.h>
 #include <media/v4l2-mc.h>
-
+#include <media/v4l2-subdev.h>
 
 struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
 						   const char *name)
@@ -256,3 +259,177 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_mc_create_media_graph);
+
+/* -----------------------------------------------------------------------------
+ * Pipeline power management
+ *
+ * Entities must be powered up when part of a pipeline that contains at least
+ * one open video device node.
+ *
+ * To achieve this use the entity use_count field to track the number of users.
+ * For entities corresponding to video device nodes the use_count field stores
+ * the users count of the node. For entities corresponding to subdevs the
+ * use_count field stores the total number of users of all video device nodes
+ * in the pipeline.
+ *
+ * The v4l2_pipeline_pm_use() function must be called in the open() and
+ * close() handlers of video device nodes. It increments or decrements the use
+ * count of all subdev entities in the pipeline.
+ *
+ * To react to link management on powered pipelines, the link setup notification
+ * callback updates the use count of all entities in the source and sink sides
+ * of the link.
+ */
+
+/*
+ * pipeline_pm_use_count - Count the number of users of a pipeline
+ * @entity: The entity
+ *
+ * Return the total number of users of all video device nodes in the pipeline.
+ */
+static int pipeline_pm_use_count(struct media_entity *entity,
+	struct media_entity_graph *graph)
+{
+	int use = 0;
+
+	media_entity_graph_walk_start(graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(graph))) {
+		if (is_media_entity_v4l2_io(entity))
+			use += entity->use_count;
+	}
+
+	return use;
+}
+
+/*
+ * pipeline_pm_power_one - Apply power change to an entity
+ * @entity: The entity
+ * @change: Use count change
+ *
+ * Change the entity use count by @change. If the entity is a subdev update its
+ * power state by calling the core::s_power operation when the use count goes
+ * from 0 to != 0 or from != 0 to 0.
+ *
+ * Return 0 on success or a negative error code on failure.
+ */
+static int pipeline_pm_power_one(struct media_entity *entity, int change)
+{
+	struct v4l2_subdev *subdev;
+	int ret;
+
+	subdev = is_media_entity_v4l2_subdev(entity)
+	       ? media_entity_to_v4l2_subdev(entity) : NULL;
+
+	if (entity->use_count == 0 && change > 0 && subdev != NULL) {
+		ret = v4l2_subdev_call(subdev, core, s_power, 1);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+	}
+
+	entity->use_count += change;
+	WARN_ON(entity->use_count < 0);
+
+	if (entity->use_count == 0 && change < 0 && subdev != NULL)
+		v4l2_subdev_call(subdev, core, s_power, 0);
+
+	return 0;
+}
+
+/*
+ * pipeline_pm_power - Apply power change to all entities in a pipeline
+ * @entity: The entity
+ * @change: Use count change
+ *
+ * Walk the pipeline to update the use count and the power state of all non-node
+ * entities.
+ *
+ * Return 0 on success or a negative error code on failure.
+ */
+static int pipeline_pm_power(struct media_entity *entity, int change,
+	struct media_entity_graph *graph)
+{
+	struct media_entity *first = entity;
+	int ret = 0;
+
+	if (!change)
+		return 0;
+
+	media_entity_graph_walk_start(graph, entity);
+
+	while (!ret && (entity = media_entity_graph_walk_next(graph)))
+		if (is_media_entity_v4l2_subdev(entity))
+			ret = pipeline_pm_power_one(entity, change);
+
+	if (!ret)
+		return ret;
+
+	media_entity_graph_walk_start(graph, first);
+
+	while ((first = media_entity_graph_walk_next(graph))
+	       && first != entity)
+		if (is_media_entity_v4l2_subdev(first))
+			pipeline_pm_power_one(first, -change);
+
+	return ret;
+}
+
+int v4l2_pipeline_pm_use(struct media_entity *entity, int use)
+{
+	struct media_device *mdev = entity->graph_obj.mdev;
+	int change = use ? 1 : -1;
+	int ret;
+
+	mutex_lock(&mdev->graph_mutex);
+
+	/* Apply use count to node. */
+	entity->use_count += change;
+	WARN_ON(entity->use_count < 0);
+
+	/* Apply power change to connected non-nodes. */
+	ret = pipeline_pm_power(entity, change, &mdev->pm_count_walk);
+	if (ret < 0)
+		entity->use_count -= change;
+
+	mutex_unlock(&mdev->graph_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_pipeline_pm_use);
+
+int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
+			      unsigned int notification)
+{
+	struct media_entity_graph *graph = &link->graph_obj.mdev->pm_count_walk;
+	struct media_entity *source = link->source->entity;
+	struct media_entity *sink = link->sink->entity;
+	int source_use;
+	int sink_use;
+	int ret = 0;
+
+	source_use = pipeline_pm_use_count(source, graph);
+	sink_use = pipeline_pm_use_count(sink, graph);
+
+	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
+	    !(flags & MEDIA_LNK_FL_ENABLED)) {
+		/* Powering off entities is assumed to never fail. */
+		pipeline_pm_power(source, -sink_use, graph);
+		pipeline_pm_power(sink, -source_use, graph);
+		return 0;
+	}
+
+	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
+		(flags & MEDIA_LNK_FL_ENABLED)) {
+
+		ret = pipeline_pm_power(source, sink_use, graph);
+		if (ret < 0)
+			return ret;
+
+		ret = pipeline_pm_power(sink, source_use, graph);
+		if (ret < 0)
+			pipeline_pm_power(source, -sink_use, graph);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_pipeline_link_notify);
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 79d84bb..3f71b8d 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -2,6 +2,8 @@
  * v4l2-mc.h - Media Controller V4L2 types and prototypes
  *
  * Copyright (C) 2016 Mauro Carvalho Chehab <mchehab@osg.samsung.com>
+ * Copyright (C) 2006--2010 Nokia Corporation
+ * Copyright (c) 2016 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -18,6 +20,7 @@
 #define _V4L2_MC_H
 
 #include <media/media-device.h>
+#include <linux/types.h>
 
 /**
  * enum tuner_pad_index - tuner pad index for MEDIA_ENT_F_TUNER
@@ -169,4 +172,43 @@ struct media_device *__v4l2_mc_usb_media_device_init(struct usb_device *udev,
 #define v4l2_mc_usb_media_device_init(udev, name) \
 	__v4l2_mc_usb_media_device_init(udev, name, KBUILD_MODNAME)
 
+/**
+ * v4l2_pipeline_pm_use - Update the use count of an entity
+ * @entity: The entity
+ * @use: Use (1) or stop using (0) the entity
+ *
+ * Update the use count of all entities in the pipeline and power entities on or
+ * off accordingly.
+ *
+ * This function is intended to be called in video node open (use ==
+ * 1) and release (use == 0). It uses struct media_entity.use_count to
+ * track the power status. The use of this function should be paired
+ * with v4l2_pipeline_link_notify().
+ *
+ * Return 0 on success or a negative error code on failure. Powering entities
+ * off is assumed to never fail. No failure can occur when the use parameter is
+ * set to 0.
+ */
+int v4l2_pipeline_pm_use(struct media_entity *entity, int use);
+
+
+/**
+ * v4l2_pipeline_link_notify - Link management notification callback
+ * @link: The link
+ * @flags: New link flags that will be applied
+ * @notification: The link's state change notification type (MEDIA_DEV_NOTIFY_*)
+ *
+ * React to link management on powered pipelines by updating the use count of
+ * all entities in the source and sink sides of the link. Entities are powered
+ * on or off accordingly. The use of this function should be paired
+ * with v4l2_pipeline_pm_use().
+ *
+ * Return 0 on success or a negative error code on failure. Powering entities
+ * off is assumed to never fail. This function will not fail for disconnection
+ * events.
+ */
+int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
+			      unsigned int notification);
+
+
 #endif
-- 
2.1.4

