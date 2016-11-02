Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49437 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752795AbcKBN3g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 09:29:36 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 02/32] media: entity: Add media_entity_has_route() function
Date: Wed,  2 Nov 2016 14:22:59 +0100
Message-Id: <20161102132329.436-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This is a wrapper around the media entity has_route operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/media-entity.c | 29 +++++++++++++++++++++++++++++
 include/media/media-entity.h |  3 +++
 2 files changed, 32 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c68239e..4d03ea7 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -242,6 +242,35 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
  * Graph traversal
  */
 
+/**
+ * media_entity_has_route - Check if two entity pads are connected internally
+ * @entity: The entity
+ * @pad0: The first pad index
+ * @pad1: The second pad index
+ *
+ * This function can be used to check whether two pads of an entity are
+ * connected internally in the entity.
+ *
+ * The caller must hold entity->source->parent->mutex.
+ *
+ * Return: true if the pads are connected internally and false otherwise.
+ */
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
index 8f9fc85..5fb3f06 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -851,6 +851,9 @@ void media_entity_graph_walk_cleanup(struct media_entity_graph *graph);
  */
 void media_entity_put(struct media_entity *entity);
 
+bool media_entity_has_route(struct media_entity *entity, unsigned int sink,
+			    unsigned int source);
+
 /**
  * media_entity_graph_walk_start - Start walking the media graph at a
  *	given entity
-- 
2.10.2

