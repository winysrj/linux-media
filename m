Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60580 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754462AbbLPNes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 08:34:48 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v3 04/23] media: Move struct media_entity_graph definition up
Date: Wed, 16 Dec 2015 15:32:19 +0200
Message-Id: <1450272758-29446-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It will be needed in struct media_pipeline shortly.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-entity.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 70803f7..4f789a4 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -97,6 +97,16 @@ struct media_entity_enum {
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
 
@@ -441,16 +451,6 @@ static inline bool media_entity_enum_intersects(
 				 min(ent_enum1->idx_max, ent_enum2->idx_max));
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

