Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15153 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbbIKKL3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 06:11:29 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [RFC 1/9] media: Rename MEDIA_ENTITY_ENUM_MAX_ID as MEDIA_ENTITY_MAX_LOW_ID
Date: Fri, 11 Sep 2015 13:09:04 +0300
Message-Id: <1441966152-28444-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the macro as it no longer is a maximum ID that an entity can have,
but a low ID which is used for internal purposes of enumeration. This is
the maximum number of concurrent entities that may exist in a media
device.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 6 +++---
 include/media/media-entity.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 2c984fb..5526e8c 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -332,9 +332,9 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 {
 	graph->top = 0;
 	graph->stack[graph->top].entity = NULL;
-	bitmap_zero(graph->entities, MEDIA_ENTITY_ENUM_MAX_ID);
+	bitmap_zero(graph->entities, MEDIA_ENTITY_MAX_LOW_ID);
 
-	if (WARN_ON(media_entity_id(entity) >= MEDIA_ENTITY_ENUM_MAX_ID))
+	if (WARN_ON(media_entity_id(entity) >= MEDIA_ENTITY_MAX_LOW_ID))
 		return;
 
 	__set_bit(media_entity_id(entity), graph->entities);
@@ -381,7 +381,7 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 
 		/* Get the entity in the other end of the link . */
 		next = media_entity_other(entity, link);
-		if (WARN_ON(media_entity_id(next) >= MEDIA_ENTITY_ENUM_MAX_ID))
+		if (WARN_ON(media_entity_id(next) >= MEDIA_ENTITY_MAX_LOW_ID))
 			return NULL;
 
 		/* Has the entity already been visited? */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 44ab153..bb6383b 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -304,7 +304,7 @@ static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
 }
 
 #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
-#define MEDIA_ENTITY_ENUM_MAX_ID	64
+#define MEDIA_ENTITY_MAX_LOW_ID	64
 
 struct media_entity_graph {
 	struct {
@@ -312,7 +312,7 @@ struct media_entity_graph {
 		struct list_head *link;
 	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
 
-	DECLARE_BITMAP(entities, MEDIA_ENTITY_ENUM_MAX_ID);
+	DECLARE_BITMAP(entities, MEDIA_ENTITY_MAX_LOW_ID);
 	int top;
 };
 
-- 
2.1.0.231.g7484e3b

