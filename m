Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57738 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753951AbcLIOxy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 09:53:54 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Subject: [PATCH v2 4/9] media: entity: Split graph walk iteration into two functions
Date: Fri,  9 Dec 2016 16:53:37 +0200
Message-Id: <1481295222-14743-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With media_entity_graph_walk_next() getting more and more complicated (and
especially so with has_routing() support added), split the function into
two.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-entity.c | 56 ++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 26cea7d..1de28ce 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -328,6 +328,34 @@ void media_graph_walk_start(struct media_graph *graph,
 }
 EXPORT_SYMBOL_GPL(media_graph_walk_start);
 
+static void media_graph_walk_iter(struct media_graph *graph)
+{
+	struct media_entity *entity = stack_top(graph);
+	struct media_link *link;
+	struct media_entity *next;
+
+	link = list_entry(link_top(graph), typeof(*link), list);
+
+	/* The link is not enabled so we do not follow. */
+	if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
+		link_top(graph) = link_top(graph)->next;
+		return;
+	}
+
+	/* Get the entity in the other end of the link . */
+	next = media_entity_other(entity, link);
+
+	/* Has the entity already been visited? */
+	if (media_entity_enum_test_and_set(&graph->ent_enum, next)) {
+		link_top(graph) = link_top(graph)->next;
+		return;
+	}
+
+	/* Push the new entity to stack and start over. */
+	link_top(graph) = link_top(graph)->next;
+	stack_push(graph, next);
+}
+
 struct media_entity *media_graph_walk_next(struct media_graph *graph)
 {
 	if (stack_top(graph) == NULL)
@@ -338,32 +366,8 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
 	 * top of the stack until no more entities on the level can be
 	 * found.
 	 */
-	while (link_top(graph) != &stack_top(graph)->links) {
-		struct media_entity *entity = stack_top(graph);
-		struct media_link *link;
-		struct media_entity *next;
-
-		link = list_entry(link_top(graph), typeof(*link), list);
-
-		/* The link is not enabled so we do not follow. */
-		if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
-			link_top(graph) = link_top(graph)->next;
-			continue;
-		}
-
-		/* Get the entity in the other end of the link . */
-		next = media_entity_other(entity, link);
-
-		/* Has the entity already been visited? */
-		if (media_entity_enum_test_and_set(&graph->ent_enum, next)) {
-			link_top(graph) = link_top(graph)->next;
-			continue;
-		}
-
-		/* Push the new entity to stack and start over. */
-		link_top(graph) = link_top(graph)->next;
-		stack_push(graph, next);
-	}
+	while (link_top(graph) != &stack_top(graph)->links)
+		media_graph_walk_iter(graph);
 
 	return stack_pop(graph);
 }
-- 
2.1.4

