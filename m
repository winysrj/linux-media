Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39774 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752431AbbK2TWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2015 14:22:44 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v2 13/22] media: Use entity enums in graph walk
Date: Sun, 29 Nov 2015 21:20:14 +0200
Message-Id: <1448824823-10372-14-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will also mean that the necessary graph related data structures will
be allocated dynamically, removing the need for maximum ID checks.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 16 ++++++----------
 include/media/media-entity.h |  2 +-
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4161dc7..7429c03 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -366,7 +366,7 @@ static struct media_entity *stack_pop(struct media_entity_graph *graph)
 __must_check int media_entity_graph_walk_init(
 	struct media_entity_graph *graph, struct media_device *mdev)
 {
-	return 0;
+	return media_entity_enum_init(&graph->entities, mdev);
 }
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_init);
 
@@ -376,6 +376,7 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_init);
  */
 void media_entity_graph_walk_cleanup(struct media_entity_graph *graph)
 {
+	media_entity_enum_cleanup(&graph->entities);
 }
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_cleanup);
 
@@ -395,14 +396,11 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_cleanup);
 void media_entity_graph_walk_start(struct media_entity_graph *graph,
 				   struct media_entity *entity)
 {
+	media_entity_enum_zero(&graph->entities);
+	media_entity_enum_set(&graph->entities, entity);
+
 	graph->top = 0;
 	graph->stack[graph->top].entity = NULL;
-	bitmap_zero(graph->entities, MEDIA_ENTITY_ENUM_MAX_ID);
-
-	if (WARN_ON(media_entity_id(entity) >= MEDIA_ENTITY_ENUM_MAX_ID))
-		return;
-
-	__set_bit(media_entity_id(entity), graph->entities);
 	stack_push(graph, entity);
 }
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
@@ -445,11 +443,9 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 
 		/* Get the entity in the other end of the link . */
 		next = media_entity_other(entity, link);
-		if (WARN_ON(media_entity_id(next) >= MEDIA_ENTITY_ENUM_MAX_ID))
-			return NULL;
 
 		/* Has the entity already been visited? */
-		if (__test_and_set_bit(media_entity_id(next), graph->entities)) {
+		if (media_entity_enum_test_and_set(&graph->entities, next)) {
 			link_top(graph) = link_top(graph)->next;
 			continue;
 		}
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index f0652e2..8122736 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -109,8 +109,8 @@ struct media_entity_graph {
 		struct list_head *link;
 	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
 
-	DECLARE_BITMAP(entities, MEDIA_ENTITY_ENUM_MAX_ID);
 	int top;
+	struct media_entity_enum entities;
 };
 
 /*
-- 
2.1.4

