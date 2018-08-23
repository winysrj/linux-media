Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:12056 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730572AbeHWQ5o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 12:57:44 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 02/30] media: entity: Use pads instead of entities in the media graph walk stack
Date: Thu, 23 Aug 2018 15:25:16 +0200
Message-Id: <20180823132544.521-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Change the media graph walk stack structure to use media pads instead of
using media entities. In addition to the entity, the pad contains the
information which pad in the entity are being dealt with.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 53 ++++++++++++++++++------------------
 include/media/media-entity.h |  6 ++--
 2 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 70679d186944a117..c5dcae6d0caf92ec 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -237,40 +237,39 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
  * Graph traversal
  */
 
-static struct media_entity *
-media_entity_other(struct media_entity *entity, struct media_link *link)
+static struct media_pad *
+media_entity_other(struct media_pad *pad, struct media_link *link)
 {
-	if (link->source->entity == entity)
-		return link->sink->entity;
+	if (link->source == pad)
+		return link->sink;
 	else
-		return link->source->entity;
+		return link->source;
 }
 
 /* push an entity to traversal stack */
-static void stack_push(struct media_graph *graph,
-		       struct media_entity *entity)
+static void stack_push(struct media_graph *graph, struct media_pad *pad)
 {
 	if (graph->top == MEDIA_ENTITY_ENUM_MAX_DEPTH - 1) {
 		WARN_ON(1);
 		return;
 	}
 	graph->top++;
-	graph->stack[graph->top].link = entity->links.next;
-	graph->stack[graph->top].entity = entity;
+	graph->stack[graph->top].link = pad->entity->links.next;
+	graph->stack[graph->top].pad = pad;
 }
 
-static struct media_entity *stack_pop(struct media_graph *graph)
+static struct media_pad *stack_pop(struct media_graph *graph)
 {
-	struct media_entity *entity;
+	struct media_pad *pad;
 
-	entity = graph->stack[graph->top].entity;
+	pad = graph->stack[graph->top].pad;
 	graph->top--;
 
-	return entity;
+	return pad;
 }
 
 #define link_top(en)	((en)->stack[(en)->top].link)
-#define stack_top(en)	((en)->stack[(en)->top].entity)
+#define stack_top(en)	((en)->stack[(en)->top].pad)
 
 /**
  * media_graph_walk_init - Allocate resources for graph walk
@@ -306,8 +305,8 @@ void media_graph_walk_start(struct media_graph *graph, struct media_pad *pad)
 	media_entity_enum_set(&graph->ent_enum, pad->entity);
 
 	graph->top = 0;
-	graph->stack[graph->top].entity = NULL;
-	stack_push(graph, pad->entity);
+	graph->stack[graph->top].pad = NULL;
+	stack_push(graph, pad);
 	dev_dbg(pad->graph_obj.mdev->dev,
 		"begin graph walk at '%s':%u\n", pad->entity->name, pad->index);
 }
@@ -315,16 +314,16 @@ EXPORT_SYMBOL_GPL(media_graph_walk_start);
 
 static void media_graph_walk_iter(struct media_graph *graph)
 {
-	struct media_entity *entity = stack_top(graph);
+	struct media_pad *pad = stack_top(graph);
 	struct media_link *link;
-	struct media_entity *next;
+	struct media_pad *next;
 
 	link = list_entry(link_top(graph), typeof(*link), list);
 
 	/* The link is not enabled so we do not follow. */
 	if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
 		link_top(graph) = link_top(graph)->next;
-		dev_dbg(entity->graph_obj.mdev->dev,
+		dev_dbg(pad->graph_obj.mdev->dev,
 			"walk: skipping disabled link '%s':%u -> '%s':%u\n",
 			link->source->entity->name, link->source->index,
 			link->sink->entity->name, link->sink->index);
@@ -332,22 +331,22 @@ static void media_graph_walk_iter(struct media_graph *graph)
 	}
 
 	/* Get the entity in the other end of the link . */
-	next = media_entity_other(entity, link);
+	next = media_entity_other(pad, link);
 
 	/* Has the entity already been visited? */
-	if (media_entity_enum_test_and_set(&graph->ent_enum, next)) {
+	if (media_entity_enum_test_and_set(&graph->ent_enum, next->entity)) {
 		link_top(graph) = link_top(graph)->next;
-		dev_dbg(entity->graph_obj.mdev->dev,
+		dev_dbg(pad->graph_obj.mdev->dev,
 			"walk: skipping entity '%s' (already seen)\n",
-			next->name);
+			next->entity->name);
 		return;
 	}
 
 	/* Push the new entity to stack and start over. */
 	link_top(graph) = link_top(graph)->next;
 	stack_push(graph, next);
-	dev_dbg(entity->graph_obj.mdev->dev, "walk: pushing '%s' on stack\n",
-		next->name);
+	dev_dbg(next->graph_obj.mdev->dev, "walk: pushing '%s':%u on stack\n",
+		next->entity->name, next->index);
 }
 
 struct media_entity *media_graph_walk_next(struct media_graph *graph)
@@ -362,10 +361,10 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
 	 * top of the stack until no more entities on the level can be
 	 * found.
 	 */
-	while (link_top(graph) != &stack_top(graph)->links)
+	while (link_top(graph) != &stack_top(graph)->entity->links)
 		media_graph_walk_iter(graph);
 
-	entity = stack_pop(graph);
+	entity = stack_pop(graph)->entity;
 	dev_dbg(entity->graph_obj.mdev->dev,
 		"walk: returning entity '%s'\n", entity->name);
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 20ff038c8aeff4b8..c844a677a1cfbb0d 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -86,16 +86,16 @@ struct media_entity_enum {
  * struct media_graph - Media graph traversal state
  *
  * @stack:		Graph traversal stack; the stack contains information
- *			on the path the media entities to be walked and the
+ *			on the path the media pads to be walked and the
  *			links through which they were reached.
- * @stack.entity:	pointer to &struct media_entity at the graph.
+ * @stack.pad:		pointer to &struct media_pad at the graph.
  * @stack.link:		pointer to &struct list_head.
  * @ent_enum:		Visited entities
  * @top:		The top of the stack
  */
 struct media_graph {
 	struct {
-		struct media_entity *entity;
+		struct media_pad *pad;
 		struct list_head *link;
 	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
 
-- 
2.18.0
