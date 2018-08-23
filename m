Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:12410 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730783AbeHWQ57 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 12:57:59 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 20/30] v4l: mc: Add an S_ROUTING helper function for power state changes
Date: Thu, 23 Aug 2018 15:25:34 +0200
Message-Id: <20180823132544.521-21-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

With the addition of the has_route() media entity operation, all pads of an
entity are no longer interconnected. The S_ROUTING IOCTL for sub-devices can
be used to enable and disable routes for an entity. The consequence is that
the routing information has to be taken into account in use count
calculation: disabling a route has a very similar effect on use counts as
has disabling a link.

Add a helper function for drivers implementing VIDIOC_SUBDEV_S_ROUTING
IOCTL to take the change into account.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-mc.c | 34 +++++++++++++++++++++++++++++++
 include/media/v4l2-mc.h           | 22 ++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index f702cac5205b3447..2ca4b0d62dd943ff 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -401,3 +401,37 @@ int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_pipeline_link_notify);
+
+int v4l2_subdev_routing_pm_use(struct media_entity *entity,
+			       struct v4l2_subdev_route *route)
+{
+	struct media_graph *graph =
+		&entity->graph_obj.mdev->pm_count_walk;
+	struct media_pad *source = &entity->pads[route->source_pad];
+	struct media_pad *sink = &entity->pads[route->sink_pad];
+	int source_use;
+	int sink_use;
+	int ret;
+
+	source_use = pipeline_pm_use_count(source, graph);
+	sink_use = pipeline_pm_use_count(sink, graph);
+
+	if (!(route->flags & V4L2_SUBDEV_ROUTE_FL_ACTIVE)) {
+		/* Route disabled. */
+		pipeline_pm_power(source, -sink_use, graph);
+		pipeline_pm_power(sink, -source_use, graph);
+		return 0;
+	}
+
+	/* Route enabled. */
+	ret = pipeline_pm_power(source, sink_use, graph);
+	if (ret < 0)
+		return ret;
+
+	ret = pipeline_pm_power(sink, source_use, graph);
+	if (ret < 0)
+		pipeline_pm_power(source, -sink_use, graph);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_routing_pm_use);
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 2634d9dc9916e3c4..ea0a54bd951f5330 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -104,6 +104,7 @@ enum demod_pad_index {
 /* We don't need to include pci.h or usb.h here */
 struct pci_dev;
 struct usb_device;
+struct v4l2_subdev_route;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 /**
@@ -210,6 +211,22 @@ int v4l2_pipeline_pm_use(struct media_entity *entity, int use);
 int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
 			      unsigned int notification);
 
+/**
+ * v4l2_subdev_routing_pm_use - Handle power state changes due to S_ROUTING
+ * @entity: The entity
+ * @route: The new state of the route
+ *
+ * Propagate the use count across a route in a pipeline whenever the
+ * route is enabled or disabled. The function is called before
+ * changing the route state when enabling a route, and after changing
+ * the route state when disabling a route.
+ *
+ * Return 0 on success or a negative error code on failure. Powering entities
+ * off is assumed to never fail. This function will not fail for disconnection
+ * events.
+ */
+int v4l2_subdev_routing_pm_use(struct media_entity *entity,
+			       struct v4l2_subdev_route *route);
 #else /* CONFIG_MEDIA_CONTROLLER */
 
 static inline int v4l2_mc_create_media_graph(struct media_device *mdev)
@@ -242,5 +259,10 @@ static inline int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
 	return 0;
 }
 
+static inline int v4l2_subdev_routing_pm_use(struct media_entity *entity,
+					     struct v4l2_subdev_route *route)
+{
+	return 0;
+}
 #endif /* CONFIG_MEDIA_CONTROLLER */
 #endif /* _V4L2_MC_H */
-- 
2.18.0
