Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58640 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1948754AbcBSOHC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 09:07:02 -0500
Date: Fri, 19 Feb 2016 12:06:58 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/5] v4l: Add generic pipeline power management code
Message-ID: <20160219120658.7dc08e55@recife.lan>
In-Reply-To: <1453906078-29087-4-git-send-email-sakari.ailus@iki.fi>
References: <1453906078-29087-1-git-send-email-sakari.ailus@iki.fi>
	<1453906078-29087-4-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Jan 2016 16:47:56 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> When the Media controller framework was merged, it was decided not to add
> pipeline power management code for it was not seen generic. As a result, a
> number of drivers have copied the same piece of code, with same bugfixes
> done to them at different points of time (or not at all).
> 
> Add these functions to V4L2. Their use is optional for drivers.
> 

This patch has a trivial conflict with another patch, already merged, that
created this. So, I had to rebase, as follows...
yet, there are some issues that I'll point on a separate e-mail.


From: Sakari Ailus <sakari.ailus@iki.fi>
Date:   Wed Jan 27 12:47:56 2016 -0200

[media] v4l: Add generic pipeline power management code
    
When the Media controller framework was merged, it was decided not to add
pipeline power management code for it was not seen generic. As a result, a
number of drivers have copied the same piece of code, with same bugfixes
done to them at different points of time (or not at all).
    
Add these functions to V4L2. Their use is optional for drivers.
    
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index a7f41b323522..f6d3463cd14c 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -256,3 +256,177 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
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
index 79d84bb3573c..13252f8cd1aa 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -18,6 +18,12 @@
 #define _V4L2_MC_H
 
 #include <media/media-device.h>
+#include <linux/types.h>
+
+/* We don't need to include the headers for those */
+struct pci_dev;
+struct usb_device;
+struct media_entity;
 
 /**
  * enum tuner_pad_index - tuner pad index for MEDIA_ENT_F_TUNER
@@ -95,9 +101,6 @@ enum demod_pad_index {
 	DEMOD_NUM_PADS
 };
 
-/* We don't need to include pci.h or usb.h here */
-struct pci_dev;
-struct usb_device;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 /**
@@ -144,6 +147,44 @@ struct media_device *__v4l2_mc_usb_media_device_init(struct usb_device *udev,
 						     const char *board_name,
 						     const char *driver_name);
 
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
 #else
 static inline int v4l2_mc_create_media_graph(struct media_device *mdev)
 {
@@ -164,7 +205,8 @@ struct media_device *__v4l2_mc_usb_media_device_init(struct usb_device *udev,
 {
 	return NULL;
 }
-#endif
+
+#endif /* _V4L2_MC_H */
 
 #define v4l2_mc_usb_media_device_init(udev, name) \
 	__v4l2_mc_usb_media_device_init(udev, name, KBUILD_MODNAME)




-- 
Thanks,
Mauro
