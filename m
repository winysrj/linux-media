Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276AbbLPRLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 12:11:37 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/5] [media] media-entity.h fix documentation for several parameters
Date: Wed, 16 Dec 2015 15:11:13 -0200
Message-Id: <f1c2fa8c4bb2bea33fe26c80eabe8041f842ecf1.1450285867.git.mchehab@osg.samsung.com>
In-Reply-To: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
References: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
In-Reply-To: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
References: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several parameters added by the media_ent_enum patches
were declared with wrong argument names:
	include/media/media-device.h:333: warning: No description found for parameter 'entity_internal_idx_max'
	include/media/media-device.h:354: warning: No description found for parameter 'ent_enum'
	include/media/media-device.h:354: warning: Excess function parameter 'e' description in 'media_entity_enum_init'
	include/media/media-device.h:333: warning: No description found for parameter 'entity_internal_idx_max'
	include/media/media-device.h:354: warning: No description found for parameter 'ent_enum'
	include/media/media-device.h:354: warning: Excess function parameter 'e' description in 'media_entity_enum_init'
	include/media/media-entity.h:397: warning: No description found for parameter 'ent_enum'
	include/media/media-entity.h:397: warning: Excess function parameter 'e' description in 'media_entity_enum_zero'
	include/media/media-entity.h:409: warning: No description found for parameter 'ent_enum'
	include/media/media-entity.h:409: warning: Excess function parameter 'e' description in 'media_entity_enum_set'
	include/media/media-entity.h:424: warning: No description found for parameter 'ent_enum'
	include/media/media-entity.h:424: warning: Excess function parameter 'e' description in 'media_entity_enum_clear'
	include/media/media-entity.h:441: warning: No description found for parameter 'ent_enum'
	include/media/media-entity.h:441: warning: Excess function parameter 'e' description in 'media_entity_enum_test'
	include/media/media-entity.h:458: warning: No description found for parameter 'ent_enum'
	include/media/media-entity.h:458: warning: Excess function parameter 'e' description in 'media_entity_enum_test_and_set'
	include/media/media-entity.h:474: warning: No description found for parameter 'ent_enum'
	include/media/media-entity.h:474: warning: Excess function parameter 'e' description in 'media_entity_enum_empty'
	include/media/media-entity.h:474: warning: Excess function parameter 'entity' description in 'media_entity_enum_empty'
	include/media/media-entity.h:489: warning: No description found for parameter 'ent_enum1'
	include/media/media-entity.h:489: warning: No description found for parameter 'ent_enum2'
	include/media/media-entity.h:489: warning: Excess function parameter 'e' description in 'media_entity_enum_intersects'
	include/media/media-entity.h:489: warning: Excess function parameter 'f' description in 'media_entity_enum_intersects'

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/media/media-device.h |  6 ++++--
 include/media/media-entity.h | 24 ++++++++++++------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index 4b900c9c5cdd..aa8ec40c3a0e 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -279,7 +279,9 @@ struct device;
  * @pad_id:	Unique ID used on the last pad registered
  * @link_id:	Unique ID used on the last link registered
  * @intf_devnode_id: Unique ID used on the last interface devnode registered
- * @entity_internal_idx: Allocated internal entity indices
+ * @entity_internal_idx: Unique internal entity ID used by the graph traversal
+ *		algorithms
+ * @entity_internal_idx_max: Allocated internal entity indices
  * @entities:	List of registered entities
  * @interfaces:	List of registered interfaces
  * @pads:	List of registered pads
@@ -344,7 +346,7 @@ struct media_device {
 /**
  * media_entity_enum_init - Initialise an entity enumeration
  *
- * @e: Entity enumeration to be initialised
+ * @ent_enum: Entity enumeration to be initialised
  * @mdev: The related media device
  *
  * Returns zero on success or a negative error code.
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index f90ff56888d4..855b47df6ed5 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -391,7 +391,7 @@ void media_entity_enum_cleanup(struct media_entity_enum *ent_enum);
 /**
  * media_entity_enum_zero - Clear the entire enum
  *
- * @e: Entity enumeration to be cleared
+ * @ent_enum: Entity enumeration to be cleared
  */
 static inline void media_entity_enum_zero(struct media_entity_enum *ent_enum)
 {
@@ -401,7 +401,7 @@ static inline void media_entity_enum_zero(struct media_entity_enum *ent_enum)
 /**
  * media_entity_enum_set - Mark a single entity in the enum
  *
- * @e: Entity enumeration
+ * @ent_enum: Entity enumeration
  * @entity: Entity to be marked
  */
 static inline void media_entity_enum_set(struct media_entity_enum *ent_enum,
@@ -416,7 +416,7 @@ static inline void media_entity_enum_set(struct media_entity_enum *ent_enum,
 /**
  * media_entity_enum_clear - Unmark a single entity in the enum
  *
- * @e: Entity enumeration
+ * @ent_enum: Entity enumeration
  * @entity: Entity to be unmarked
  */
 static inline void media_entity_enum_clear(struct media_entity_enum *ent_enum,
@@ -431,7 +431,7 @@ static inline void media_entity_enum_clear(struct media_entity_enum *ent_enum,
 /**
  * media_entity_enum_test - Test whether the entity is marked
  *
- * @e: Entity enumeration
+ * @ent_enum: Entity enumeration
  * @entity: Entity to be tested
  *
  * Returns true if the entity was marked.
@@ -448,13 +448,14 @@ static inline bool media_entity_enum_test(struct media_entity_enum *ent_enum,
 /**
  * media_entity_enum_test - Test whether the entity is marked, and mark it
  *
- * @e: Entity enumeration
+ * @ent_enum: Entity enumeration
  * @entity: Entity to be tested
  *
  * Returns true if the entity was marked, and mark it before doing so.
  */
-static inline bool media_entity_enum_test_and_set(
-	struct media_entity_enum *ent_enum, struct media_entity *entity)
+static inline bool
+media_entity_enum_test_and_set(struct media_entity_enum *ent_enum,
+			       struct media_entity *entity)
 {
 	if (WARN_ON(entity->internal_idx >= ent_enum->idx_max))
 		return true;
@@ -463,10 +464,9 @@ static inline bool media_entity_enum_test_and_set(
 }
 
 /**
- * media_entity_enum_test - Test whether the entire enum is empty
+ * media_entity_enum_empty - Test whether the entire enum is empty
  *
- * @e: Entity enumeration
- * @entity: Entity to be tested
+ * @ent_enum: Entity enumeration
  *
  * Returns true if the entity was marked.
  */
@@ -478,8 +478,8 @@ static inline bool media_entity_enum_empty(struct media_entity_enum *ent_enum)
 /**
  * media_entity_enum_intersects - Test whether two enums intersect
  *
- * @e: First entity enumeration
- * @f: Second entity enumeration
+ * @ent_enum1: First entity enumeration
+ * @ent_enum2: Second entity enumeration
  *
  * Returns true if entity enumerations e and f intersect, otherwise false.
  */
-- 
2.5.0

