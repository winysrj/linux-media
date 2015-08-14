Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46930 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbbHNO6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 10:58:31 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 5/6] media: use media_graph_obj inside pads
Date: Fri, 14 Aug 2015 11:56:42 -0300
Message-Id: <3c1310f15c5ca9ca7446f8e3d8c835b3d796f607.1439563682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439563682.git.mchehab@osg.samsung.com>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439563682.git.mchehab@osg.samsung.com>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PADs also need unique object IDs that won't conflict with
the entity object IDs.

The pad objects are currently created via media_entity_init()
and, once created, never change.

While this will likely change in the future in order to
suppory dynamic changes, for now we'll keep PADs as arrays
and initialize the media_graph_obj embeeded structs when
registering the entity.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index f06b08392007..3ac5803b327e 100644
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
 	/* Initialize media_graph_obj embedded at the entity */
 	graph_obj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
 
+	/* Initialize objects at the pads */
+	for (i = 0; i < entity->num_pads; i++)
+		graph_obj_init(mdev, MEDIA_GRAPH_PAD,
+			       &entity->pads[i].graph_obj);
+
+	list_add_tail(&entity->list, &mdev->entities);
 	spin_unlock(&mdev->lock);
 
 	return 0;
@@ -448,6 +456,7 @@ EXPORT_SYMBOL_GPL(media_device_register_entity);
  */
 void media_device_unregister_entity(struct media_entity *entity)
 {
+	int i;
 	struct media_device *mdev = entity->parent;
 
 	if (mdev == NULL)
@@ -455,6 +464,8 @@ void media_device_unregister_entity(struct media_entity *entity)
 
 	spin_lock(&mdev->lock);
 	graph_obj_remove(&entity->graph_obj);
+	for (i = 0; i < entity->num_pads; i++)
+		graph_obj_remove(&entity->pads[i].graph_obj);
 	list_del(&entity->list);
 	spin_unlock(&mdev->lock);
 	entity->parent = NULL;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c06546509a89..d3dee6fc79d7 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -48,6 +48,8 @@ void graph_obj_init(struct media_device *mdev,
 	switch (type) {
 	case MEDIA_GRAPH_ENTITY:
 		gobj->id |= ++mdev->entity_id;
+	case MEDIA_GRAPH_PAD:
+		gobj->id |= ++mdev->pad_id;
 	}
 }
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 35634c0da362..2a9d9260cccc 100644
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
@@ -70,6 +71,7 @@ struct media_device {
 
 	/* Unique object ID counter */
 	u32 entity_id;
+	u32 pad_id;
 
 	struct list_head entities;
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 2c775f3ef24f..936f68f27bba 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -34,9 +34,11 @@
  * enum media_graph_type - type of a graph element
  *
  * @MEDIA_GRAPH_ENTITY:		Identify a media entity
+ * @MEDIA_GRAPH_PAD:		Identify a media pad
  */
 enum media_graph_type {
 	MEDIA_GRAPH_ENTITY,
+	MEDIA_GRAPH_PAD,
 };
 
 
@@ -66,6 +68,7 @@ struct media_link {
 };
 
 struct media_pad {
+	struct media_graph_obj graph_obj;
 	struct media_entity *entity;	/* Entity this pad belongs to */
 	u16 index;			/* Pad index in the entity pads array */
 	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
-- 
2.4.3

