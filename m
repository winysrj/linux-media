Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:28841 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbeKBIiO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 04:38:14 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 20/30] v4l: mc: Add an S_ROUTING helper function for power state changes
Date: Fri,  2 Nov 2018 00:31:34 +0100
Message-Id: <20181101233144.31507-21-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-mc.c | 34 +++++++++++++++++++++++++++++++
 include/media/v4l2-mc.h           | 22 ++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 208cd91ce57ff211..534c5ea4fab42244 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -482,3 +482,37 @@ int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
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
index bf5043c1ab6b3a32..730922636579a5fe 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -26,6 +26,7 @@
 /* We don't need to include pci.h or usb.h here */
 struct pci_dev;
 struct usb_device;
+struct v4l2_subdev_route;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 /**
@@ -132,6 +133,22 @@ int v4l2_pipeline_pm_use(struct media_entity *entity, int use);
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
@@ -164,5 +181,10 @@ static inline int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
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
2.19.1
