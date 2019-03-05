Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC97C4360F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B988208E4
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfCESwD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:52:03 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:40611 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbfCESwB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:52:01 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 76847200010;
        Tue,  5 Mar 2019 18:51:58 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 22/31] v4l: mc: Add an S_ROUTING helper function for power state changes
Date:   Tue,  5 Mar 2019 19:51:41 +0100
Message-Id: <20190305185150.20776-23-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

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
index 558dec225838..7a2536d3c75e 100644
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
index bf5043c1ab6b..730922636579 100644
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
2.20.1

