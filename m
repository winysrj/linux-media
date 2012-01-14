Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:30597 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab2ANTaD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 14:30:03 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 1/1] libmediactl: Implement MEDIA_ENT_ID_FLAG_NEXT in media_get_entity_by_id()
Date: Sat, 14 Jan 2012 21:33:36 +0200
Message-Id: <1326569616-7048-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/mediactl.c |    9 +++++++--
 src/mediactl.h |    4 +++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/src/mediactl.c b/src/mediactl.c
index 5b8c587..f62fcdf 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -81,8 +81,13 @@ struct media_entity *media_get_entity_by_id(struct media_device *media,
 	for (i = 0; i < media->entities_count; ++i) {
 		struct media_entity *entity = &media->entities[i];
 
-		if (entity->info.id == id)
-			return entity;
+		if (!(id & MEDIA_ENT_ID_FLAG_NEXT)) {
+			if (entity->info.id == id)
+				return entity;
+		} else {
+			if (entity->info.id >= (id & ~MEDIA_ENT_ID_FLAG_NEXT)
+				return entity;
+		}
 	}
 
 	return NULL;
diff --git a/src/mediactl.h b/src/mediactl.h
index 1b47b7e..4d3892e 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -164,7 +164,9 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
  * @param media - media device.
  * @param id - entity ID.
  *
- * Search for an entity with an ID equal to @a id.
+ * Search for an entity with an ID equal to @a id. If id flag
+ * MEDIA_ENT_ID_FLAG_NEXT is present, an entity with ID greater or equal to
+ * @a id will be returned.
  *
  * @return A pointer to the entity if found, or NULL otherwise.
  */
-- 
1.7.2.5

