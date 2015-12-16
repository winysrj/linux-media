Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60577 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752151AbbLPNes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 08:34:48 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v3 03/23] media: Add an API to manage entity enumerations
Date: Wed, 16 Dec 2015 15:32:18 +0200
Message-Id: <1450272758-29446-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

This is useful in e.g. knowing whether certain operations have already
been performed for an entity. The users include the framework itself (for
graph walking) and a number of drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c |  39 ++++++++++++
 include/media/media-device.h |  15 +++++
 include/media/media-entity.h | 140 ++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 186 insertions(+), 8 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index d11f440..67eebcb 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -213,6 +213,45 @@ void media_gobj_remove(struct media_gobj *gobj)
 }
 
 /**
+ * __media_entity_enum_init - Initialise an entity enumeration
+ *
+ * @ent_enum: Entity enumeration to be initialised
+ * @idx_max: Maximum number of entities in the enumeration
+ *
+ * Returns zero on success or a negative error code.
+ */
+int __media_entity_enum_init(struct media_entity_enum *ent_enum, int idx_max)
+{
+	if (idx_max > MEDIA_ENTITY_ENUM_MAX_ID) {
+		ent_enum->bmap = kcalloc(DIV_ROUND_UP(idx_max, BITS_PER_LONG),
+					 sizeof(long), GFP_KERNEL);
+		if (!ent_enum->bmap)
+			return -ENOMEM;
+	} else {
+		ent_enum->bmap = ent_enum->prealloc_bmap;
+	}
+
+	bitmap_zero(ent_enum->bmap, idx_max);
+	ent_enum->idx_max = idx_max;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__media_entity_enum_init);
+
+/**
+ * media_entity_enum_cleanup - Release resources of an entity enumeration
+ *
+ * @e: Entity enumeration to be released
+ */
+void media_entity_enum_cleanup(struct media_entity_enum *ent_enum)
+{
+	if (ent_enum->bmap != ent_enum->prealloc_bmap)
+		kfree(ent_enum->bmap);
+	ent_enum->bmap = NULL;
+}
+EXPORT_SYMBOL_GPL(media_entity_enum_cleanup);
+
+/**
  * media_entity_init - Initialize a media entity
  *
  * @num_pads: Total number of sink and source pads.
diff --git a/include/media/media-device.h b/include/media/media-device.h
index c0e1764..abf94b4 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -110,6 +110,21 @@ struct media_device {
 /* media_devnode to media_device */
 #define to_media_device(node) container_of(node, struct media_device, devnode)
 
+/**
+ * media_entity_enum_init - Initialise an entity enumeration
+ *
+ * @e: Entity enumeration to be initialised
+ * @mdev: The related media device
+ *
+ * Returns zero on success or a negative error code.
+ */
+static inline __must_check int media_entity_enum_init(
+	struct media_entity_enum *ent_enum, struct media_device *mdev)
+{
+	return __media_entity_enum_init(ent_enum,
+					mdev->entity_internal_idx_max + 1);
+}
+
 void media_device_init(struct media_device *mdev);
 void media_device_cleanup(struct media_device *mdev);
 int __must_check __media_device_register(struct media_device *mdev,
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index d3d3a39..70803f7 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -23,7 +23,7 @@
 #ifndef _MEDIA_ENTITY_H
 #define _MEDIA_ENTITY_H
 
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/media.h>
@@ -71,6 +71,32 @@ struct media_gobj {
 	struct list_head	list;
 };
 
+#define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
+#define MEDIA_ENTITY_ENUM_MAX_ID	64
+
+/*
+ * The number of pads can't be bigger than the number of entities,
+ * as the worse-case scenario is to have one entity linked up to
+ * MEDIA_ENTITY_ENUM_MAX_ID - 1 entities.
+ */
+#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_MAX_ID - 1)
+
+/**
+ * struct media_entity_enum - An enumeration of media entities.
+ *
+ * @prealloc_bmap: Pre-allocated space reserved for media entities if the
+ *		total number of entities does not exceed
+ *		MEDIA_ENTITY_ENUM_MAX_ID.
+ * @bmap:	Bit map in which each bit represents one entity at struct
+ *		media_entity->internal_idx.
+ * @idx_max:	Number of bits in bmap
+ */
+struct media_entity_enum {
+	DECLARE_BITMAP(prealloc_bmap, MEDIA_ENTITY_ENUM_MAX_ID);
+	unsigned long *bmap;
+	int idx_max;
+};
+
 struct media_pipeline {
 };
 
@@ -307,15 +333,113 @@ static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
 	}
 }
 
-#define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
-#define MEDIA_ENTITY_ENUM_MAX_ID	64
+int __media_entity_enum_init(struct media_entity_enum *e, int idx_max);
+void media_entity_enum_cleanup(struct media_entity_enum *e);
 
-/*
- * The number of pads can't be bigger than the number of entities,
- * as the worse-case scenario is to have one entity linked up to
- * MEDIA_ENTITY_ENUM_MAX_ID - 1 entities.
+/**
+ * media_entity_enum_zero - Clear the entire enum
+ *
+ * @e: Entity enumeration to be cleared
  */
-#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_MAX_ID - 1)
+static inline void media_entity_enum_zero(struct media_entity_enum *ent_enum)
+{
+	bitmap_zero(ent_enum->bmap, ent_enum->idx_max);
+}
+
+/**
+ * media_entity_enum_set - Mark a single entity in the enum
+ *
+ * @e: Entity enumeration
+ * @entity: Entity to be marked
+ */
+static inline void media_entity_enum_set(struct media_entity_enum *ent_enum,
+					 struct media_entity *entity)
+{
+	if (WARN_ON(entity->internal_idx >= ent_enum->idx_max))
+		return;
+
+	__set_bit(entity->internal_idx, ent_enum->bmap);
+}
+
+/**
+ * media_entity_enum_clear - Unmark a single entity in the enum
+ *
+ * @e: Entity enumeration
+ * @entity: Entity to be unmarked
+ */
+static inline void media_entity_enum_clear(struct media_entity_enum *ent_enum,
+					   struct media_entity *entity)
+{
+	if (WARN_ON(entity->internal_idx >= ent_enum->idx_max))
+		return;
+
+	__clear_bit(entity->internal_idx, ent_enum->bmap);
+}
+
+/**
+ * media_entity_enum_test - Test whether the entity is marked
+ *
+ * @e: Entity enumeration
+ * @entity: Entity to be tested
+ *
+ * Returns true if the entity was marked.
+ */
+static inline bool media_entity_enum_test(struct media_entity_enum *ent_enum,
+					  struct media_entity *entity)
+{
+	if (WARN_ON(entity->internal_idx >= ent_enum->idx_max))
+		return true;
+
+	return test_bit(entity->internal_idx, ent_enum->bmap);
+}
+
+/**
+ * media_entity_enum_test - Test whether the entity is marked, and mark it
+ *
+ * @e: Entity enumeration
+ * @entity: Entity to be tested
+ *
+ * Returns true if the entity was marked, and mark it before doing so.
+ */
+static inline bool media_entity_enum_test_and_set(
+	struct media_entity_enum *ent_enum, struct media_entity *entity)
+{
+	if (WARN_ON(entity->internal_idx >= ent_enum->idx_max))
+		return true;
+
+	return __test_and_set_bit(entity->internal_idx, ent_enum->bmap);
+}
+
+/**
+ * media_entity_enum_test - Test whether the entire enum is empty
+ *
+ * @e: Entity enumeration
+ * @entity: Entity to be tested
+ *
+ * Returns true if the entity was marked.
+ */
+static inline bool media_entity_enum_empty(struct media_entity_enum *ent_enum)
+{
+	return bitmap_empty(ent_enum->bmap, ent_enum->idx_max);
+}
+
+/**
+ * media_entity_enum_intersects - Test whether two enums intersect
+ *
+ * @e: First entity enumeration
+ * @f: Second entity enumeration
+ *
+ * Returns true if entity enumerations e and f intersect, otherwise false.
+ */
+static inline bool media_entity_enum_intersects(
+	struct media_entity_enum *ent_enum1,
+	struct media_entity_enum *ent_enum2)
+{
+	WARN_ON(ent_enum1->idx_max != ent_enum2->idx_max);
+
+	return bitmap_intersects(ent_enum1->bmap, ent_enum2->bmap,
+				 min(ent_enum1->idx_max, ent_enum2->idx_max));
+}
 
 struct media_entity_graph {
 	struct {
-- 
2.1.4

