Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57430 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932944AbcA0OsO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 09:48:14 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 41441600B2
	for <linux-media@vger.kernel.org>; Wed, 27 Jan 2016 16:48:12 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 3/5] v4l: Add generic pipeline power management code
Date: Wed, 27 Jan 2016 16:47:56 +0200
Message-Id: <1453906078-29087-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1453906078-29087-1-git-send-email-sakari.ailus@iki.fi>
References: <1453906078-29087-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the Media controller framework was merged, it was decided not to add
pipeline power management code for it was not seen generic. As a result, a
number of drivers have copied the same piece of code, with same bugfixes
done to them at different points of time (or not at all).

Add these functions to V4L2. Their use is optional for drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/Makefile  |   3 +
 drivers/media/v4l2-core/v4l2-mc.c | 201 ++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-mc.h           |  66 +++++++++++++
 3 files changed, 270 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-mc.c
 create mode 100644 include/media/v4l2-mc.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 1dc8bba..f7d31745 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -20,6 +20,9 @@ endif
 obj-$(CONFIG_VIDEO_V4L2) += videodev.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-dv-timings.o
+ifneq ($(CONFIG_MEDIA_CONTROLLER),)
+  obj-$(CONFIG_VIDEO_V4L2) += v4l2-mc.o
+endif
 
 obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
new file mode 100644
index 0000000..4c70cb4
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -0,0 +1,201 @@
+/*
+ * V4L2 Media controller support
+ *
+ * Copyright (C) 2006--2010 Nokia Corporation
+ * Copyright (c) 2016 Intel Corporation.
+ *
+ * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <media/media-device.h>
+#include <media/media-entity.h>
+#include <media/v4l2-subdev.h>
+#include <linux/module.h>
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
+
+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("V4L2 Media controller support");
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
new file mode 100644
index 0000000..9e353e2
--- /dev/null
+++ b/include/media/v4l2-mc.h
@@ -0,0 +1,66 @@
+/*
+ * V4L2 Media controller support
+ *
+ * Copyright (C) 2006--2010 Nokia Corporation
+ * Copyright (c) 2016 Intel Corporation.
+ *
+ * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __V4L2_MC_H__
+#define __V4L2_MC_H__
+
+#include <linux/types.h>
+
+struct media_entity;
+
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
+#endif /* __V4L2_MC_H__ */
-- 
2.1.4

