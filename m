Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60614 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933006AbbLPNew (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 08:34:52 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v3 21/23] media: Remove pre-allocated entity enumeration bitmap
Date: Wed, 16 Dec 2015 15:32:36 +0200
Message-Id: <1450272758-29446-22-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bitmaps for entity enumerations used to be statically allocated. Now
that the drivers have been converted to use the new interface which
explicitly initialises the enum objects, drop the pre-allocated bitmaps.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 16 +++++-----------
 include/media/media-entity.h |  9 ++-------
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index ddf3c23..c799a4e 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -222,14 +222,10 @@ void media_gobj_remove(struct media_gobj *gobj)
  */
 int __media_entity_enum_init(struct media_entity_enum *ent_enum, int idx_max)
 {
-	if (idx_max > MEDIA_ENTITY_ENUM_MAX_ID) {
-		ent_enum->bmap = kcalloc(DIV_ROUND_UP(idx_max, BITS_PER_LONG),
-					 sizeof(long), GFP_KERNEL);
-		if (!ent_enum->bmap)
-			return -ENOMEM;
-	} else {
-		ent_enum->bmap = ent_enum->prealloc_bmap;
-	}
+	ent_enum->bmap = kcalloc(DIV_ROUND_UP(idx_max, BITS_PER_LONG),
+				 sizeof(long), GFP_KERNEL);
+	if (!ent_enum->bmap)
+		return -ENOMEM;
 
 	bitmap_zero(ent_enum->bmap, idx_max);
 	ent_enum->idx_max = idx_max;
@@ -245,9 +241,7 @@ EXPORT_SYMBOL_GPL(__media_entity_enum_init);
  */
 void media_entity_enum_cleanup(struct media_entity_enum *ent_enum)
 {
-	if (ent_enum->bmap != ent_enum->prealloc_bmap)
-		kfree(ent_enum->bmap);
-	ent_enum->bmap = NULL;
+	kfree(ent_enum->bmap);
 }
 EXPORT_SYMBOL_GPL(media_entity_enum_cleanup);
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 251eddf..034b9d7 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -72,27 +72,22 @@ struct media_gobj {
 };
 
 #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
-#define MEDIA_ENTITY_ENUM_MAX_ID	64
 
 /*
  * The number of pads can't be bigger than the number of entities,
  * as the worse-case scenario is to have one entity linked up to
- * MEDIA_ENTITY_ENUM_MAX_ID - 1 entities.
+ * 63 entities.
  */
-#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_MAX_ID - 1)
+#define MEDIA_ENTITY_MAX_PADS		63
 
 /**
  * struct media_entity_enum - An enumeration of media entities.
  *
- * @prealloc_bmap: Pre-allocated space reserved for media entities if the
- *		total number of entities does not exceed
- *		MEDIA_ENTITY_ENUM_MAX_ID.
  * @bmap:	Bit map in which each bit represents one entity at struct
  *		media_entity->internal_idx.
  * @idx_max:	Number of bits in bmap
  */
 struct media_entity_enum {
-	DECLARE_BITMAP(prealloc_bmap, MEDIA_ENTITY_ENUM_MAX_ID);
 	unsigned long *bmap;
 	int idx_max;
 };
-- 
2.1.4

