Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53908 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754167AbcKYN4W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 08:56:22 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 5/5] media: entity: Add debug information to graph walk
Date: Fri, 25 Nov 2016 15:55:46 +0200
Message-Id: <1480082146-25991-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1480082146-25991-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1480082146-25991-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use dev_dbg() to tell about the progress of the graph traversal algorithm.
This is intended to make debugging of the algorithm easier.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e242ead..186906b 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -335,6 +335,8 @@ void media_graph_walk_start(struct media_graph *graph,
 	graph->top = 0;
 	graph->stack[graph->top].entity = NULL;
 	stack_push(graph, entity);
+	dev_dbg(entity->graph_obj.mdev->dev,
+		"begin graph walk at \"%s\"\n", entity->name);
 }
 EXPORT_SYMBOL_GPL(media_graph_walk_start);
 
@@ -349,6 +351,10 @@ static void graph_walk_iter(struct media_graph *graph)
 	/* The link is not enabled so we do not follow. */
 	if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
 		link_top(graph) = link_top(graph)->next;
+		dev_dbg(entity->graph_obj.mdev->dev,
+			"walk: skipping disabled link \"%s\":%u -> \"%s\":%u\n",
+			link->source->entity->name, link->source->index,
+			link->sink->entity->name, link->sink->index);
 		return;
 	}
 
@@ -358,16 +364,23 @@ static void graph_walk_iter(struct media_graph *graph)
 	/* Has the entity already been visited? */
 	if (media_entity_enum_test_and_set(&graph->ent_enum, next)) {
 		link_top(graph) = link_top(graph)->next;
+		dev_dbg(entity->graph_obj.mdev->dev,
+			"walk: skipping entity \"%s\" (already seen)\n",
+			next->name);
 		return;
 	}
 
 	/* Push the new entity to stack and start over. */
 	link_top(graph) = link_top(graph)->next;
 	stack_push(graph, next);
+	dev_dbg(entity->graph_obj.mdev->dev, "walk: pushing \"%s\" on stack\n",
+		next->name);
 }
 
 struct media_entity *media_graph_walk_next(struct media_graph *graph)
 {
+	struct media_entity *entity;
+
 	if (stack_top(graph) == NULL)
 		return NULL;
 
@@ -379,7 +392,11 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
 	while (link_top(graph) != &stack_top(graph)->links)
 		graph_walk_iter(graph);
 
-	return stack_pop(graph);
+	entity = stack_pop(graph);
+	dev_dbg(entity->graph_obj.mdev->dev,
+		"walk: returning entity \"%s\"\n", entity->name);
+
+	return entity;
 }
 EXPORT_SYMBOL_GPL(media_graph_walk_next);
 
-- 
2.1.4

