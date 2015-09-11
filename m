Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14390 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbbIKKLq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 06:11:46 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [RFC 5/9] media: Use entity enums in graph walk
Date: Fri, 11 Sep 2015 13:09:08 +0300
Message-Id: <1441966152-28444-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 10 +++++-----
 include/media/media-entity.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 5526e8c..a4d6e1b 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -332,12 +332,12 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 {
 	graph->top = 0;
 	graph->stack[graph->top].entity = NULL;
-	bitmap_zero(graph->entities, MEDIA_ENTITY_MAX_LOW_ID);
+	media_entity_enum_init(graph->entities);
 
-	if (WARN_ON(media_entity_id(entity) >= MEDIA_ENTITY_MAX_LOW_ID))
+	if (WARN_ON(entity->low_id >= MEDIA_ENTITY_MAX_LOW_ID))
 		return;
 
-	__set_bit(media_entity_id(entity), graph->entities);
+	media_entity_enum_set(graph->entities, entity);
 	stack_push(graph, entity);
 }
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
@@ -381,11 +381,11 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 
 		/* Get the entity in the other end of the link . */
 		next = media_entity_other(entity, link);
-		if (WARN_ON(media_entity_id(next) >= MEDIA_ENTITY_MAX_LOW_ID))
+		if (WARN_ON(entity->low_id >= MEDIA_ENTITY_MAX_LOW_ID))
 			return NULL;
 
 		/* Has the entity already been visited? */
-		if (__test_and_set_bit(media_entity_id(next), graph->entities)) {
+		if (media_entity_enum_test_and_set(graph->entities, next)) {
 			link_top(graph) = link_top(graph)->next;
 			continue;
 		}
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 95b1061..849ec4a 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -370,7 +370,7 @@ struct media_entity_graph {
 		struct list_head *link;
 	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
 
-	DECLARE_BITMAP(entities, MEDIA_ENTITY_MAX_LOW_ID);
+	DECLARE_MEDIA_ENTITY_ENUM(entities);
 	int top;
 };
 
-- 
2.1.0.231.g7484e3b

