Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44992 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751741AbbJZXDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 19:03:49 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 04/19] media: Move struct media_entity_graph definition up
Date: Tue, 27 Oct 2015 01:01:35 +0200
Message-Id: <1445900510-1398-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It will be needed in struct media_pipeline shortly.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-entity.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index fc54192..dde9a5f 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -87,6 +87,16 @@ struct media_entity_enum {
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
 
@@ -429,16 +439,6 @@ static inline bool media_entity_enum_intersects(struct media_entity_enum *e,
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

