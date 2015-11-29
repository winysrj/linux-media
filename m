Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39725 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752346AbbK2TWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2015 14:22:42 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v2 04/22] media: Move struct media_entity_graph definition up
Date: Sun, 29 Nov 2015 21:20:05 +0200
Message-Id: <1448824823-10372-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It will be needed in struct media_pipeline shortly.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-entity.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 5a0339a..2601bb0 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -95,6 +95,16 @@ struct media_entity_enum {
 	int idx_max;
 };
 
+struct media_entity_graph {
+	struct {
+		struct media_entity *entity;
+		struct list_head *link;
+	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
+
+	DECLARE_BITMAP(entities, MEDIA_ENTITY_ENUM_MAX_ID);
+	int top;
+};
+
 struct media_pipeline {
 };
 
@@ -437,16 +447,6 @@ static inline bool media_entity_enum_intersects(struct media_entity_enum *e,
 	return bitmap_intersects(e->e, f->e, min(e->idx_max, f->idx_max));
 }
 
-struct media_entity_graph {
-	struct {
-		struct media_entity *entity;
-		struct list_head *link;
-	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
-
-	DECLARE_BITMAP(entities, MEDIA_ENTITY_ENUM_MAX_ID);
-	int top;
-};
-
 #define gobj_to_entity(gobj) \
 		container_of(gobj, struct media_entity, graph_obj)
 
-- 
2.1.4

