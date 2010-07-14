Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51139 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab0GNN3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 09:29:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH 04/10] media: Entity graph traversal
Date: Wed, 14 Jul 2010 15:30:13 +0200
Message-Id: <1279114219-27389-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Add media entity graph traversal. The traversal follows active links by
depth first. Traversing graph backwards is prevented by comparing the next
possible entity in the graph with the previous one. Multiply connected
graphs are thus not supported.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@nokia.com>
---
 Documentation/media-framework.txt |   40 +++++++++++++
 drivers/media/media-entity.c      |  116 +++++++++++++++++++++++++++++++++++++
 include/media/media-entity.h      |   15 +++++
 3 files changed, 171 insertions(+), 0 deletions(-)

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index 4a8f379..5448b34 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -191,3 +191,43 @@ Links have flags that describe the link capabilities and state.
 	MEDIA_LINK_FLAG_IMMUTABLE indicates that the link active state can't
 	be modified at runtime. An immutable link is always active.
 
+
+Graph traversal
+---------------
+
+The media framework provides APIs to iterate over entities in a graph.
+
+To iterate over all entities belonging to a media device, drivers can use the
+media_device_for_each_entity macro, defined in include/media/media-device.h.
+
+	struct media_entity *entity;
+
+	media_device_for_each_entity(entity, mdev) {
+		/* entity will point to each entity in turn */
+		...
+	}
+
+Drivers might also need to iterate over all entities in a graph that can be
+reached only through active links starting at a given entity. The media
+framework provides a depth-first graph traversal API for that purpose.
+
+Note that graphs with cycles (whether directed or undirected) are *NOT*
+supported by the graph traversal API.
+
+Drivers initiate a graph traversal by calling
+
+	media_entity_graph_walk_start(struct media_entity_graph *graph,
+				      struct media_entity *entity);
+
+The graph structure, provided by the caller, is initialized to start graph
+traversal at the given entity.
+
+Drivers can then retrieve the next entity by calling
+
+	media_entity_graph_walk_next(struct media_entity_graph *graph);
+
+When the graph traversal is complete the function will return NULL.
+
+Graph traversal can be interrupted at any moment. No cleanup function call is
+required and the graph structure can be freed normally.
+
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index d5a4b4c..3d5b80f 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -81,6 +81,122 @@ media_entity_cleanup(struct media_entity *entity)
 }
 EXPORT_SYMBOL(media_entity_cleanup);
 
+/* -----------------------------------------------------------------------------
+ * Graph traversal
+ */
+
+static struct media_entity *media_entity_other(struct media_entity *entity,
+					       struct media_entity_link *link)
+{
+	if (link->source->entity == entity)
+		return link->sink->entity;
+	else
+		return link->source->entity;
+}
+
+/* push an entity to traversal stack */
+static void stack_push(struct media_entity_graph *graph,
+		       struct media_entity *entity)
+{
+	if (graph->top == MEDIA_ENTITY_ENUM_MAX_DEPTH - 1) {
+		WARN_ON(1);
+		return;
+	}
+	graph->top++;
+	graph->stack[graph->top].link = 0;
+	graph->stack[graph->top].entity = entity;
+}
+
+static struct media_entity *stack_pop(struct media_entity_graph *graph)
+{
+	struct media_entity *entity;
+
+	entity = graph->stack[graph->top].entity;
+	graph->top--;
+
+	return entity;
+}
+
+#define stack_peek(en)	((en)->stack[(en)->top - 1].entity)
+#define link_top(en)	((en)->stack[(en)->top].link)
+#define stack_top(en)	((en)->stack[(en)->top].entity)
+
+/**
+ * media_entity_graph_walk_start - Start walking the media graph at a given entity
+ * @graph: Media graph structure that will be used to walk the graph
+ * @entity: Starting entity
+ *
+ * This function initializes the graph traversal structure to walk the entities
+ * graph starting at the given entity. The traversal structure must not be
+ * modified by the caller during graph traversal. When done the structure can
+ * safely be freed.
+ */
+void media_entity_graph_walk_start(struct media_entity_graph *graph,
+				   struct media_entity *entity)
+{
+	graph->top = 0;
+	graph->stack[graph->top].entity = NULL;
+	stack_push(graph, entity);
+}
+EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
+
+/**
+ * media_entity_graph_walk_next - Get the next entity in the graph
+ * @graph: Media graph structure
+ *
+ * Perform a depth-first traversal of the given media entities graph.
+ *
+ * The graph structure must have been previously initialized with a call to
+ * media_entity_graph_walk_start().
+ *
+ * Return the next entity in the graph or NULL if the whole graph have been
+ * traversed.
+ */
+struct media_entity *
+media_entity_graph_walk_next(struct media_entity_graph *graph)
+{
+	if (stack_top(graph) == NULL)
+		return NULL;
+
+	/*
+	 * Depth first search. Push entity to stack and continue from
+	 * top of the stack until no more entities on the level can be
+	 * found.
+	 */
+	while (link_top(graph) < stack_top(graph)->num_links) {
+		struct media_entity *entity = stack_top(graph);
+		struct media_entity_link *link =
+			&entity->links[link_top(graph)];
+		struct media_entity *next;
+
+		/* The link is not active so we do not follow. */
+		if (!(link->flags & MEDIA_LINK_FLAG_ACTIVE)) {
+			link_top(graph)++;
+			continue;
+		}
+
+		/* Get the entity in the other end of the link . */
+		next = media_entity_other(entity, link);
+
+		/* Was it the entity we came here from? */
+		if (next == stack_peek(graph)) {
+			link_top(graph)++;
+			continue;
+		}
+
+		/* Push the new entity to stack and start over. */
+		link_top(graph)++;
+		stack_push(graph, next);
+	}
+
+	return stack_pop(graph);
+}
+EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
+
+/* -----------------------------------------------------------------------------
+ * Links management
+ */
+
 static struct
 media_entity_link *media_entity_add_link(struct media_entity *entity)
 {
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0929a90..8f5164f 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -70,10 +70,25 @@ struct media_entity {
 	};
 };
 
+#define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
+
+struct media_entity_graph {
+	struct {
+		struct media_entity *entity;
+		int link;
+	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
+	int top;
+};
+
 int media_entity_init(struct media_entity *entity, u8 num_pads,
 		struct media_entity_pad *pads, u8 extra_links);
 void media_entity_cleanup(struct media_entity *entity);
 int media_entity_create_link(struct media_entity *source, u8 source_pad,
 		struct media_entity *sink, u8 sink_pad, u32 flags);
 
+void media_entity_graph_walk_start(struct media_entity_graph *graph,
+		struct media_entity *entity);
+struct media_entity *
+media_entity_graph_walk_next(struct media_entity_graph *graph);
+
 #endif
-- 
1.7.1

