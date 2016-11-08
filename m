Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:47026 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932477AbcKHMyk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 07:54:40 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 1/1] media: entity: Add media_entity_has_route() function
Date: Tue,  8 Nov 2016 14:54:28 +0200
Message-Id: <1478609668-1117-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <20161108124238.GM3217@valkosipuli.retiisi.org.uk>
References: <20161108124238.GM3217@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This is a wrapper around the media entity has_route operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Niklas,

There was actually another problem with the Kerneldoc comment related to
the mutex. Fixed that one as well.

Kind regards,
Sakari

 drivers/media/media-entity.c | 16 ++++++++++++++++
 include/media/media-entity.h | 17 +++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 5734bb9..7de08e1 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -242,6 +242,22 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
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
 static struct media_entity *
 media_entity_other(struct media_entity *entity, struct media_link *link)
 {
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 2060e48..aa8d3c5 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -834,6 +834,23 @@ __must_check int media_entity_graph_walk_init(
 	struct media_entity_graph *graph, struct media_device *mdev);
 
 /**
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
+/**
  * media_entity_graph_walk_cleanup - Release resources used by graph walk.
  *
  * @graph: Media graph structure that will be used to walk the graph
-- 
2.7.4

