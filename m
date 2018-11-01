Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:18095 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbeKBIiE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 04:38:04 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH v2 08/30] media: entity: Add media_has_route() function
Date: Fri,  2 Nov 2018 00:31:22 +0100
Message-Id: <20181101233144.31507-9-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This is a wrapper around the media entity has_route operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/media-entity.c | 16 ++++++++++++++++
 include/media/media-entity.h | 17 +++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index f2fa0b7826dbc2f3..3c0e7425c8983b45 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -237,6 +237,22 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
  * Graph traversal
  */
 
+bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
+			    unsigned int pad1)
+{
+	if (pad0 >= entity->num_pads || pad1 >= entity->num_pads)
+		return false;
+
+	if (pad0 == pad1)
+		return true;
+
+	if (!entity->ops || !entity->ops->has_route)
+		return true;
+
+	return entity->ops->has_route(entity, pad0, pad1);
+}
+EXPORT_SYMBOL_GPL(media_entity_has_route);
+
 static struct media_pad *
 media_entity_other(struct media_pad *pad, struct media_link *link)
 {
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index cd482814654616b5..9540d2af80f19805 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -919,6 +919,23 @@ int media_entity_get_fwnode_pad(struct media_entity *entity,
 __must_check int media_graph_walk_init(
 	struct media_graph *graph, struct media_device *mdev);
 
+/**
+ * media_entity_has_route - Check if two entity pads are connected internally
+ *
+ * @entity: The entity
+ * @pad0: The first pad index
+ * @pad1: The second pad index
+ *
+ * This function can be used to check whether two pads of an entity are
+ * connected internally in the entity.
+ *
+ * The caller must hold entity->graph_obj.mdev->mutex.
+ *
+ * Return: true if the pads are connected internally and false otherwise.
+ */
+bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
+			    unsigned int pad1);
+
 /**
  * media_graph_walk_cleanup - Release resources used by graph walk.
  *
-- 
2.19.1
