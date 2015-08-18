Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbbHRUE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 16:04:28 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v5 4/8] [media] media: use media_gobj inside pads
Date: Tue, 18 Aug 2015 17:04:17 -0300
Message-Id: <f443416df795b9316c49218c34230df7566b4b26.1439927113.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439927113.git.mchehab@osg.samsung.com>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439927113.git.mchehab@osg.samsung.com>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PADs also need unique object IDs that won't conflict with
the entity object IDs.

The pad objects are currently created via media_entity_init()
and, once created, never change.

While this will likely change in the future in order to
support dynamic changes, for now we'll keep PADs as arrays
and initialize the media_gobj embedded structs when
registering the entity.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e6caec8f62b7..24551d4ddfb8 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -425,6 +425,8 @@ EXPORT_SYMBOL_GPL(media_device_unregister);
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity)
 {
+	int i;
+
 	/* Warn if we apparently re-register an entity */
 	WARN_ON(entity->parent != NULL);
 	entity->parent = mdev;
@@ -433,6 +435,12 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	/* Initialize media_gobj embedded at the entity */
 	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
 	list_add_tail(&entity->list, &mdev->entities);
+
+	/* Initialize objects at the pads */
+	for (i = 0; i < entity->num_pads; i++)
+		media_gobj_init(mdev, MEDIA_GRAPH_PAD,
+			       &entity->pads[i].graph_obj);
+
 	spin_unlock(&mdev->lock);
 
 	return 0;
@@ -448,12 +456,15 @@ EXPORT_SYMBOL_GPL(media_device_register_entity);
  */
 void media_device_unregister_entity(struct media_entity *entity)
 {
+	int i;
 	struct media_device *mdev = entity->parent;
 
 	if (mdev == NULL)
 		return;
 
 	spin_lock(&mdev->lock);
+	for (i = 0; i < entity->num_pads; i++)
+		media_gobj_remove(&entity->pads[i].graph_obj);
 	media_gobj_remove(&entity->graph_obj);
 	list_del(&entity->list);
 	spin_unlock(&mdev->lock);
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 888cb88e19bf..377c6655c5d0 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -48,6 +48,9 @@ void media_gobj_init(struct media_device *mdev,
 	case MEDIA_GRAPH_ENTITY:
 		gobj->id = media_gobj_gen_id(type, ++mdev->entity_id);
 		break;
+	case MEDIA_GRAPH_PAD:
+		gobj->id = media_gobj_gen_id(type, ++mdev->pad_id);
+		break;
 	}
 }
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 3b9a31c8eba9..4b5d1ee2b67e 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -42,6 +42,7 @@ struct device;
  * @hw_revision: Hardware device revision
  * @driver_version: Device driver version
  * @entity_id:	Unique ID used on the last entity registered
+ * @pad_id:	Unique ID used on the last pad registered
  * @entities:	List of registered entities
  * @lock:	Entities list lock
  * @graph_mutex: Entities graph operation lock
@@ -69,6 +70,7 @@ struct media_device {
 	u32 driver_version;
 
 	u32 entity_id;
+	u32 pad_id;
 
 	struct list_head entities;
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 18d74a44091c..01ae1e320e36 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -34,9 +34,11 @@
  * enum media_gobj_type - type of a graph element
  *
  * @MEDIA_GRAPH_ENTITY:		Identify a media entity
+ * @MEDIA_GRAPH_PAD:		Identify a media pad
  */
 enum media_gobj_type {
 	MEDIA_GRAPH_ENTITY,
+	MEDIA_GRAPH_PAD,
 };
 
 #define BITS_PER_TYPE		8
@@ -70,6 +72,7 @@ struct media_link {
 };
 
 struct media_pad {
+	struct media_gobj graph_obj;
 	struct media_entity *entity;	/* Entity this pad belongs to */
 	u16 index;			/* Pad index in the entity pads array */
 	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
-- 
2.4.3

