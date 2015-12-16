Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41335 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934237AbbLPRLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 12:11:37 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/5] [media] media-device.h: use just one u64 counter for object ID
Date: Wed, 16 Dec 2015 15:11:15 -0200
Message-Id: <9c04bcb45824fd8e5231f6f26269b57830c1f34d.1450285867.git.mchehab@osg.samsung.com>
In-Reply-To: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
References: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
In-Reply-To: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
References: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using one u32 counter per type for object IDs, use
just one counter, and move it to u64, in order to match the
changes at the userspace API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 35 +++++++++++++++--------------------
 include/media/media-device.h | 10 ++--------
 include/media/media-entity.h | 27 +++++++++++++--------------
 3 files changed, 30 insertions(+), 42 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index a2d28162213e..d3160224db33 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -106,8 +106,8 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 	switch (media_type(gobj)) {
 	case MEDIA_GRAPH_ENTITY:
 		dev_dbg(gobj->mdev->dev,
-			"%s: id 0x%08x entity#%d: '%s'\n",
-			event_name, gobj->id, media_localid(gobj),
+			"%s id %llu: entity '%s'\n",
+			event_name, media_id(gobj),
 			gobj_to_entity(gobj)->name);
 		break;
 	case MEDIA_GRAPH_LINK:
@@ -115,14 +115,12 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 		struct media_link *link = gobj_to_link(gobj);
 
 		dev_dbg(gobj->mdev->dev,
-			"%s: id 0x%08x link#%d: %s#%d ==> %s#%d\n",
-			event_name, gobj->id, media_localid(gobj),
-
-			gobj_type(media_type(link->gobj0)),
-			media_localid(link->gobj0),
-
-			gobj_type(media_type(link->gobj1)),
-			media_localid(link->gobj1));
+			"%s id %llu: %s link id %llu ==> id %llu\n",
+			event_name, media_id(gobj),
+			media_type(link->gobj0) == MEDIA_GRAPH_PAD ?
+				"data" : "interface",
+			media_id(link->gobj0),
+			media_id(link->gobj1));
 		break;
 	}
 	case MEDIA_GRAPH_PAD:
@@ -130,11 +128,10 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 		struct media_pad *pad = gobj_to_pad(gobj);
 
 		dev_dbg(gobj->mdev->dev,
-			"%s: id 0x%08x %s%spad#%d: '%s':%d\n",
-			event_name, gobj->id,
-			pad->flags & MEDIA_PAD_FL_SINK   ? "  sink " : "",
+			"%s id %llu: %s%spad '%s':%d\n",
+			event_name, media_id(gobj),
+			pad->flags & MEDIA_PAD_FL_SINK   ? "sink " : "",
 			pad->flags & MEDIA_PAD_FL_SOURCE ? "source " : "",
-			media_localid(gobj),
 			pad->entity->name, pad->index);
 		break;
 	}
@@ -144,8 +141,8 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 		struct media_intf_devnode *devnode = intf_to_devnode(intf);
 
 		dev_dbg(gobj->mdev->dev,
-			"%s: id 0x%08x intf_devnode#%d: %s - major: %d, minor: %d\n",
-			event_name, gobj->id, media_localid(gobj),
+			"%s id %llu: intf_devnode %s - major: %d, minor: %d\n",
+			event_name, media_id(gobj),
 			intf_type(intf),
 			devnode->major, devnode->minor);
 		break;
@@ -163,21 +160,19 @@ void media_gobj_create(struct media_device *mdev,
 	gobj->mdev = mdev;
 
 	/* Create a per-type unique object ID */
+	gobj->id = media_gobj_gen_id(type, ++mdev->id);
+
 	switch (type) {
 	case MEDIA_GRAPH_ENTITY:
-		gobj->id = media_gobj_gen_id(type, ++mdev->entity_id);
 		list_add_tail(&gobj->list, &mdev->entities);
 		break;
 	case MEDIA_GRAPH_PAD:
-		gobj->id = media_gobj_gen_id(type, ++mdev->pad_id);
 		list_add_tail(&gobj->list, &mdev->pads);
 		break;
 	case MEDIA_GRAPH_LINK:
-		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
 		list_add_tail(&gobj->list, &mdev->links);
 		break;
 	case MEDIA_GRAPH_INTF_DEVNODE:
-		gobj->id = media_gobj_gen_id(type, ++mdev->intf_devnode_id);
 		list_add_tail(&gobj->list, &mdev->interfaces);
 		break;
 	}
diff --git a/include/media/media-device.h b/include/media/media-device.h
index aa8ec40c3a0e..b516c7b06e02 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -275,10 +275,7 @@ struct device;
  * @driver_version: Device driver version
  * @topology_version: Monotonic counter for storing the version of the graph
  *		topology. Should be incremented each time the topology changes.
- * @entity_id:	Unique ID used on the last entity registered
- * @pad_id:	Unique ID used on the last pad registered
- * @link_id:	Unique ID used on the last link registered
- * @intf_devnode_id: Unique ID used on the last interface devnode registered
+ * @id:		Unique ID used on the last registered graph object
  * @entity_internal_idx: Unique internal entity ID used by the graph traversal
  *		algorithms
  * @entity_internal_idx_max: Allocated internal entity indices
@@ -313,10 +310,7 @@ struct media_device {
 
 	u32 topology_version;
 
-	u32 entity_id;
-	u32 pad_id;
-	u32 link_id;
-	u32 intf_devnode_id;
+	u64 id;
 	struct ida entity_internal_idx;
 	int entity_internal_idx_max;
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 855b47df6ed5..73ab2bc6a1c9 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -46,9 +46,9 @@ enum media_gobj_type {
 	MEDIA_GRAPH_INTF_DEVNODE,
 };
 
-#define MEDIA_BITS_PER_TYPE		8
-#define MEDIA_BITS_PER_LOCAL_ID		(32 - MEDIA_BITS_PER_TYPE)
-#define MEDIA_LOCAL_ID_MASK		 GENMASK(MEDIA_BITS_PER_LOCAL_ID - 1, 0)
+#define MEDIA_BITS_PER_TYPE		8ULL
+#define MEDIA_BITS_PER_ID		(64ULL - MEDIA_BITS_PER_TYPE)
+#define MEDIA_ID_MASK			 GENMASK_ULL(MEDIA_BITS_PER_ID - 1, 0)
 
 /* Structs to represent the objects that belong to a media graph */
 
@@ -58,16 +58,15 @@ enum media_gobj_type {
  * @mdev:	Pointer to the struct media_device that owns the object
  * @id:		Non-zero object ID identifier. The ID should be unique
  *		inside a media_device, as it is composed by
- *		MEDIA_BITS_PER_TYPE to store the type plus
- *		MEDIA_BITS_PER_LOCAL_ID	to store a per-type ID
- *		(called as "local ID").
+ *		%MEDIA_BITS_PER_TYPE to store the type plus
+ *		%MEDIA_BITS_PER_ID to store the ID
  * @list:	List entry stored in one of the per-type mdev object lists
  *
  * All objects on the media graph should have this struct embedded
  */
 struct media_gobj {
 	struct media_device	*mdev;
-	u32			id;
+	u64			id;
 	struct list_head	list;
 };
 
@@ -299,20 +298,20 @@ static inline u32 media_entity_id(struct media_entity *entity)
  */
 static inline enum media_gobj_type media_type(struct media_gobj *gobj)
 {
-	return gobj->id >> MEDIA_BITS_PER_LOCAL_ID;
+	return gobj->id >> MEDIA_BITS_PER_ID;
 }
 
-static inline u32 media_localid(struct media_gobj *gobj)
+static inline u64 media_id(struct media_gobj *gobj)
 {
-	return gobj->id & MEDIA_LOCAL_ID_MASK;
+	return gobj->id & MEDIA_ID_MASK;
 }
 
-static inline u32 media_gobj_gen_id(enum media_gobj_type type, u32 local_id)
+static inline u64 media_gobj_gen_id(enum media_gobj_type type, u64 local_id)
 {
-	u32 id;
+	u64 id;
 
-	id = type << MEDIA_BITS_PER_LOCAL_ID;
-	id |= local_id & MEDIA_LOCAL_ID_MASK;
+	id = (u64)type << MEDIA_BITS_PER_ID;
+	id |= local_id & MEDIA_ID_MASK;
 
 	return id;
 }
-- 
2.5.0

