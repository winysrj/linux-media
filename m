Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58097 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754417AbcJNRe4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:34:56 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 03/21] [media] v4l: of: add v4l2_of_subdev_registered
Date: Fri, 14 Oct 2016 19:34:23 +0200
Message-Id: <1476466481-24030-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide a default registered callback for device tree probed subdevices
that use OF graph bindings to add still missing source subdevices to
the async notifier waiting list.
This is only necessary for subdevices that have input ports to which
other subdevices are connected that are not initially known to the
master/bridge device when it sets up the notifier.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Alphabetical #include order
 - Compile v4l2_of_subdev_registered only if CONFIG_MEDIA_CONTROLLER is set.
---
 drivers/media/v4l2-core/v4l2-of.c | 69 +++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-of.h           | 15 +++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 93b3368..73c5643 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+#include <media/v4l2-device.h>
 #include <media/v4l2-of.h>
 
 static int v4l2_of_parse_csi_bus(const struct device_node *node,
@@ -314,3 +315,71 @@ void v4l2_of_put_link(struct v4l2_of_link *link)
 	of_node_put(link->remote_node);
 }
 EXPORT_SYMBOL(v4l2_of_put_link);
+
+struct v4l2_subdev *v4l2_find_subdev_by_node(struct v4l2_device *v4l2_dev,
+					     struct device_node *node)
+{
+	struct v4l2_subdev *sd;
+
+	list_for_each_entry(sd, &v4l2_dev->subdevs, list)
+		if (sd->of_node == node)
+			return sd;
+
+	return NULL;
+}
+EXPORT_SYMBOL(v4l2_find_subdev_by_node);
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+/**
+ * v4l2_of_subdev_registered() - default OF probed subdev registered callback
+ * @subdev: subdevice with initialized entities
+ *
+ * Parse all OF graph endpoints corrensponding to the subdev's entity input pads
+ * and add the remote subdevs to the async subdev notifier.
+ */
+int v4l2_of_subdev_registered(struct v4l2_subdev *sd)
+{
+	struct device_node *ep;
+
+	for_each_endpoint_of_node(sd->of_node, ep) {
+		struct v4l2_of_link link;
+		struct media_entity *entity;
+		unsigned int pad;
+		int ret;
+
+		ret = v4l2_of_parse_link(ep, &link);
+		if (ret)
+			continue;
+
+		/*
+		 * Assume 1:1 correspondence between OF node and entity,
+		 * and between OF port numbers and pad indices.
+		 */
+		entity = &sd->entity;
+		pad = link.local_port;
+
+		if (pad >= entity->num_pads)
+			return -EINVAL;
+
+		/* Add source subdevs to async notifier */
+		if (entity->pads[pad].flags & MEDIA_PAD_FL_SINK) {
+			struct v4l2_async_subdev *asd;
+
+			asd = devm_kzalloc(sd->dev, sizeof(*asd), GFP_KERNEL);
+			if (!asd) {
+				v4l2_of_put_link(&link);
+				return -ENOMEM;
+			}
+
+			asd->match_type = V4L2_ASYNC_MATCH_OF;
+			asd->match.of.node = link.remote_node;
+
+			__v4l2_async_notifier_add_subdev(sd->notifier, asd);
+		}
+
+		v4l2_of_put_link(&link);
+	}
+
+	return 0;
+}
+#endif /* CONFIG_MEDIA_CONTROLLER */
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 4dc34b2..f99a04b 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -22,6 +22,8 @@
 #include <media/v4l2-mediabus.h>
 
 struct device_node;
+struct v4l2_device;
+struct v4l2_subdev;
 
 /**
  * struct v4l2_of_bus_mipi_csi2 - MIPI CSI-2 bus data structure
@@ -95,6 +97,8 @@ void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint);
 int v4l2_of_parse_link(const struct device_node *node,
 		       struct v4l2_of_link *link);
 void v4l2_of_put_link(struct v4l2_of_link *link);
+struct v4l2_subdev *v4l2_find_subdev_by_node(struct v4l2_device *v4l2_dev,
+					     struct device_node *node);
 #else /* CONFIG_OF */
 
 static inline int v4l2_of_parse_endpoint(const struct device_node *node,
@@ -123,6 +127,17 @@ static inline void v4l2_of_put_link(struct v4l2_of_link *link)
 {
 }
 
+struct v4l2_subdev *v4l2_find_subdev_by_node(struct v4l2_device *v4l2_dev,
+					     struct device_node *node)
+{
+	return NULL;
+}
 #endif /* CONFIG_OF */
 
+#if defined(CONFIG_OF) && defined(CONFIG_MEDIA_CONTROLLER)
+int v4l2_of_subdev_registered(struct v4l2_subdev *sd);
+#else
+#define v4l2_of_subdev_registered NULL
+#endif /* CONFIG_OF && CONFIG_MEDIA_CONTROLLER */
+
 #endif /* _V4L2_OF_H */
-- 
2.9.3

