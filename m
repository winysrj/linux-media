Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57776 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753952AbcLIOx4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 09:53:56 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Subject: [PATCH v2 6/9] media: entity: Add debug information to graph walk
Date: Fri,  9 Dec 2016 16:53:39 +0200
Message-Id: <1481295222-14743-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use dev_dbg() to tell about the progress of the graph traversal algorithm.
This is intended to make debugging of the algorithm easier.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-entity.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 5064ba0..caa13e6 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -325,6 +325,8 @@ void media_graph_walk_start(struct media_graph *graph,
 	graph->top = 0;
 	graph->stack[graph->top].entity = NULL;
 	stack_push(graph, entity);
+	dev_dbg(entity->graph_obj.mdev->dev,
+		"begin graph walk at '%s'\n", entity->name);
 }
 EXPORT_SYMBOL_GPL(media_graph_walk_start);
 
@@ -339,6 +341,10 @@ static void media_graph_walk_iter(struct media_graph *graph)
 	/* The link is not enabled so we do not follow. */
 	if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
 		link_top(graph) = link_top(graph)->next;
+		dev_dbg(entity->graph_obj.mdev->dev,
+			"walk: skipping disabled link '%s':%u -> '%s':%u\n",
+			link->source->entity->name, link->source->index,
+			link->sink->entity->name, link->sink->index);
 		return;
 	}
 
@@ -348,16 +354,23 @@ static void media_graph_walk_iter(struct media_graph *graph)
 	/* Has the entity already been visited? */
 	if (media_entity_enum_test_and_set(&graph->ent_enum, next)) {
 		link_top(graph) = link_top(graph)->next;
+		dev_dbg(entity->graph_obj.mdev->dev,
+			"walk: skipping entity '%s' (already seen)\n",
+			next->name);
 		return;
 	}
 
 	/* Push the new entity to stack and start over. */
 	link_top(graph) = link_top(graph)->next;
 	stack_push(graph, next);
+	dev_dbg(entity->graph_obj.mdev->dev, "walk: pushing '%s' on stack\n",
+		next->name);
 }
 
 struct media_entity *media_graph_walk_next(struct media_graph *graph)
 {
+	struct media_entity *entity;
+
 	if (stack_top(graph) == NULL)
 		return NULL;
 
@@ -369,7 +382,11 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
 	while (link_top(graph) != &stack_top(graph)->links)
 		media_graph_walk_iter(graph);
 
-	return stack_pop(graph);
+	entity = stack_pop(graph);
+	dev_dbg(entity->graph_obj.mdev->dev,
+		"walk: returning entity '%s'\n", entity->name);
+
+	return entity;
 }
 EXPORT_SYMBOL_GPL(media_graph_walk_next);
 
-- 
2.1.4

