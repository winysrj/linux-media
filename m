Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39773 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752483AbbK2TWr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2015 14:22:47 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v2 21/22] media: Rename MEDIA_ENTITY_ENUM_MAX_ID as MEDIA_ENTITY_ENUM_STACK_ALLOC
Date: Sun, 29 Nov 2015 21:20:22 +0200
Message-Id: <1448824823-10372-22-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The purpose of the macro has changed, rename it accordingly. It is not and
should no longer be used in drivers directly, but only for the purpose for
defining how many bits can be allocated from the stack for entity
enumerations.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 2 +-
 include/media/media-entity.h | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 137aa09d..feca976 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -222,7 +222,7 @@ void media_gobj_remove(struct media_gobj *gobj)
  */
 int __media_entity_enum_init(struct media_entity_enum *e, int idx_max)
 {
-	if (idx_max > MEDIA_ENTITY_ENUM_MAX_ID) {
+	if (idx_max > MEDIA_ENTITY_ENUM_STACK_ALLOC) {
 		e->e = kcalloc(DIV_ROUND_UP(idx_max, BITS_PER_LONG),
 			       sizeof(long), GFP_KERNEL);
 		if (!e->e)
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 85c2656..145d339 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -72,14 +72,14 @@ struct media_gobj {
 };
 
 #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
-#define MEDIA_ENTITY_ENUM_MAX_ID	64
+#define MEDIA_ENTITY_ENUM_STACK_ALLOC	64
 
 /*
  * The number of pads can't be bigger than the number of entities,
  * as the worse-case scenario is to have one entity linked up to
- * MEDIA_ENTITY_ENUM_MAX_ID - 1 entities.
+ * MEDIA_ENTITY_ENUM_STACK_ALLOC - 1 entities.
  */
-#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_MAX_ID - 1)
+#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_STACK_ALLOC - 1)
 
 /* struct media_entity_enum - An enumeration of media entities.
  *
@@ -90,7 +90,7 @@ struct media_gobj {
  * @idx_max:	Number of bits in the enum.
  */
 struct media_entity_enum {
-	DECLARE_BITMAP(__e, MEDIA_ENTITY_ENUM_MAX_ID);
+	DECLARE_BITMAP(__e, MEDIA_ENTITY_ENUM_STACK_ALLOC);
 	unsigned long *e;
 	int idx_max;
 };
-- 
2.1.4

