Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58873 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbbHWUSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:08 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v7 05/44] [media] media: use media_gobj inside entities
Date: Sun, 23 Aug 2015 17:17:22 -0300
Message-Id: <428d72ba195018f3371adbd3a56f474aad6659b7.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As entities are graph objects, let's embed media_gobj
on it. That ensures an unique ID for entities that can be
global along the entire media controller.

For now, we'll keep the already existing entity ID. Such
field need to be dropped at some point, but for now, let's
not do this, to avoid needing to review all drivers and
the userspace apps.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e429605ca2c3..81d6a130efef 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -379,7 +379,6 @@ int __must_check __media_device_register(struct media_device *mdev,
 	if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
 		return -EINVAL;
 
-	mdev->entity_id = 1;
 	INIT_LIST_HEAD(&mdev->entities);
 	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
@@ -433,10 +432,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	entity->parent = mdev;
 
 	spin_lock(&mdev->lock);
-	if (entity->id == 0)
-		entity->id = mdev->entity_id++;
-	else
-		mdev->entity_id = max(entity->id + 1, mdev->entity_id);
+	/* Initialize media_gobj embedded at the entity */
+	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
 	list_add_tail(&entity->list, &mdev->entities);
 	spin_unlock(&mdev->lock);
 
@@ -459,6 +456,7 @@ void media_device_unregister_entity(struct media_entity *entity)
 		return;
 
 	spin_lock(&mdev->lock);
+	media_gobj_remove(&entity->graph_obj);
 	list_del(&entity->list);
 	spin_unlock(&mdev->lock);
 	entity->parent = NULL;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4834172bf6f8..888cb88e19bf 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -43,7 +43,12 @@ void media_gobj_init(struct media_device *mdev,
 			   enum media_gobj_type type,
 			   struct media_gobj *gobj)
 {
-	/* For now, nothing to do */
+	/* Create a per-type unique object ID */
+	switch (type) {
+	case MEDIA_GRAPH_ENTITY:
+		gobj->id = media_gobj_gen_id(type, ++mdev->entity_id);
+		break;
+	}
 }
 
 /**
diff --git a/include/media/media-device.h b/include/media/media-device.h
index a44f18fdf321..f6deef6e5820 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -41,7 +41,7 @@ struct device;
  * @bus_info:	Unique and stable device location identifier
  * @hw_revision: Hardware device revision
  * @driver_version: Device driver version
- * @entity_id:	ID of the next entity to be registered
+ * @entity_id:	Unique ID used on the last entity registered
  * @entities:	List of registered entities
  * @lock:	Entities list lock
  * @graph_mutex: Entities graph operation lock
@@ -69,6 +69,7 @@ struct media_device {
 	u32 driver_version;
 
 	u32 entity_id;
+
 	struct list_head entities;
 
 	/* Protects the entities list */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index b1854239a476..bb74b5883cbb 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -33,10 +33,10 @@
 /**
  * enum media_gobj_type - type of a graph object
  *
+ * @MEDIA_GRAPH_ENTITY:		Identify a media entity
  */
 enum media_gobj_type {
-	 /* FIXME: add the types here, as we embed media_gobj */
-	MEDIA_GRAPH_NONE
+	MEDIA_GRAPH_ENTITY,
 };
 
 #define MEDIA_BITS_PER_TYPE		8
@@ -94,10 +94,9 @@ struct media_entity_operations {
 };
 
 struct media_entity {
+	struct media_gobj graph_obj;
 	struct list_head list;
 	struct media_device *parent;	/* Media device this entity belongs to*/
-	u32 id;				/* Entity ID, unique in the parent media
-					 * device context */
 	const char *name;		/* Entity name */
 	u32 type;			/* Entity type (MEDIA_ENT_T_*) */
 	u32 revision;			/* Entity revision, driver specific */
@@ -148,7 +147,7 @@ static inline u32 media_entity_subtype(struct media_entity *entity)
 
 static inline u32 media_entity_id(struct media_entity *entity)
 {
-	return entity->id;
+	return entity->graph_obj.id;
 }
 
 static inline enum media_gobj_type media_type(struct media_gobj *gobj)
-- 
2.4.3

