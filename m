Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4049C4360F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9040421019
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfCESvf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:51:35 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:53029 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbfCESve (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:51:34 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 55ED720000E;
        Tue,  5 Mar 2019 18:51:31 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 02/31] media: entity: Use pads instead of entities in the media graph walk stack
Date:   Tue,  5 Mar 2019 19:51:21 +0100
Message-Id: <20190305185150.20776-3-jacopo+renesas@jmondi.org>
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

Change the media graph walk stack structure to use media pads instead of
using media entities. In addition to the entity, the pad contains the
information which pad in the entity are being dealt with.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/media-entity.c | 53 ++++++++++++++++++------------------
 include/media/media-entity.h |  8 +++---
 2 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 2bbc07de71aa..bddfcd3b2dd9 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -237,40 +237,39 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
  * Graph traversal
  */
 
-static struct media_entity *
-media_entity_other(struct media_entity *entity, struct media_link *link)
+static struct media_pad *
+media_pad_other(struct media_pad *pad, struct media_link *link)
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
+	next = media_pad_other(pad, link);
 
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
index 07ab141e739e..e50972d44fb5 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -86,16 +86,16 @@ struct media_entity_enum {
  * struct media_graph - Media graph traversal state
  *
  * @stack:		Graph traversal stack; the stack contains information
- *			on the path the media entities to be walked and the
- *			links through which they were reached.
- * @stack.entity:	pointer to &struct media_entity at the graph.
+ *			on the media pads to be walked and the links through
+ *			which they were reached.
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
2.20.1

