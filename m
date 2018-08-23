Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:12261 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730734AbeHWQ5x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 12:57:53 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 12/30] media: entity: Add an iterator helper for connected pads
Date: Thu, 23 Aug 2018 15:25:26 +0200
Message-Id: <20180823132544.521-13-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Add a helper macro for iterating over pads that are connected through
enabled routes. This can be used to find all the connected pads within an
entity, for instance starting from the pad which has been obtained during
the graph walk.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-entity.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 53f293415fc39ab1..169cf47982a0b1fa 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -888,6 +888,33 @@ __must_check int media_graph_walk_init(
 bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
 			    unsigned int pad1);
 
+static inline struct media_pad *__media_entity_for_routed_pads_next(
+	struct media_pad *start, struct media_pad *iter)
+{
+	struct media_entity *entity = start->entity;
+
+	while (iter < &entity->pads[entity->num_pads] &&
+	       !media_entity_has_route(entity, start->index, iter->index))
+		iter++;
+
+	return iter;
+}
+
+/**
+ * media_entity_for_routed_pads - Iterate over entity pads connected by routes
+ *
+ * @start: The stating pad
+ * @iter: The iterator pad
+ *
+ * Iterate over all pads connected through routes from a given pad
+ * within an entity. The iteration will include the starting pad itself.
+ */
+#define media_entity_for_routed_pads(start, iter)			\
+	for (iter = __media_entity_for_routed_pads_next(		\
+		     start, (start)->entity->pads);			\
+	     iter < &(start)->entity->pads[(start)->entity->num_pads];	\
+	     iter = __media_entity_for_routed_pads_next(start, iter + 1))
+
 /**
  * media_graph_walk_cleanup - Release resources used by graph walk.
  *
-- 
2.18.0
