Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39966 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3GJKTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 06:19:12 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 1/5] media: Fix circular graph traversal
Date: Wed, 10 Jul 2013 12:19:28 +0200
Message-Id: <1373451572-3892-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1373451572-3892-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1373451572-3892-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The graph traversal API (media_entity_graph_walk_*) will fail to
correctly walk the graph when circular links exist. Fix it by checking
whether an entity is already present in the stack before pushing it.

Cc: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/media-entity.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e1cd132..9084205 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -121,9 +121,9 @@ static struct media_entity *stack_pop(struct media_entity_graph *graph)
 	return entity;
 }
 
-#define stack_peek(en)	((en)->stack[(en)->top - 1].entity)
-#define link_top(en)	((en)->stack[(en)->top].link)
-#define stack_top(en)	((en)->stack[(en)->top].entity)
+#define stack_peek(en, i)	((en)->stack[i].entity)
+#define link_top(en)		((en)->stack[(en)->top].link)
+#define stack_top(en)		((en)->stack[(en)->top].entity)
 
 /**
  * media_entity_graph_walk_start - Start walking the media graph at a given entity
@@ -159,6 +159,8 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
 struct media_entity *
 media_entity_graph_walk_next(struct media_entity_graph *graph)
 {
+	unsigned int i;
+
 	if (stack_top(graph) == NULL)
 		return NULL;
 
@@ -181,8 +183,13 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 		/* Get the entity in the other end of the link . */
 		next = media_entity_other(entity, link);
 
-		/* Was it the entity we came here from? */
-		if (next == stack_peek(graph)) {
+		/* Is the entity already in the path? */
+		for (i = 1; i < graph->top; ++i) {
+			if (next == stack_peek(graph, i))
+				break;
+		}
+
+		if (i < graph->top) {
 			link_top(graph)++;
 			continue;
 		}
-- 
1.8.1.5

