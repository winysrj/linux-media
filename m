Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40431 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841AbbLOKnd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 05:43:33 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 1/2] [media] media-device: move media entity register/unregister functions
Date: Tue, 15 Dec 2015 08:43:11 -0200
Message-Id: <2875b74a677adc2cd9fc11ba054654caf01e4a18.1450176187.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media entity register and unregister functions are called by media
device register/unregister. Move them to occur earlier, as we'll need
an unlocked version of media_device_entity_unregister() and we don't
want to add a function prototype without needing it.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 160 +++++++++++++++++++++----------------------
 1 file changed, 80 insertions(+), 80 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index da4126863ecc..1222fa642ad8 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -529,6 +529,86 @@ static void media_device_release(struct media_devnode *mdev)
 }
 
 /**
+ * media_device_register_entity - Register an entity with a media device
+ * @mdev:	The media device
+ * @entity:	The entity
+ */
+int __must_check media_device_register_entity(struct media_device *mdev,
+					      struct media_entity *entity)
+{
+	unsigned int i;
+
+	if (entity->function == MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN ||
+	    entity->function == MEDIA_ENT_F_UNKNOWN)
+		dev_warn(mdev->dev,
+			 "Entity type for entity %s was not initialized!\n",
+			 entity->name);
+
+	/* Warn if we apparently re-register an entity */
+	WARN_ON(entity->graph_obj.mdev != NULL);
+	entity->graph_obj.mdev = mdev;
+	INIT_LIST_HEAD(&entity->links);
+	entity->num_links = 0;
+	entity->num_backlinks = 0;
+
+	spin_lock(&mdev->lock);
+	/* Initialize media_gobj embedded at the entity */
+	media_gobj_create(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
+
+	/* Initialize objects at the pads */
+	for (i = 0; i < entity->num_pads; i++)
+		media_gobj_create(mdev, MEDIA_GRAPH_PAD,
+			       &entity->pads[i].graph_obj);
+
+	spin_unlock(&mdev->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(media_device_register_entity);
+
+/**
+ * media_device_unregister_entity - Unregister an entity
+ * @entity:	The entity
+ *
+ * If the entity has never been registered this function will return
+ * immediately.
+ */
+void media_device_unregister_entity(struct media_entity *entity)
+{
+	struct media_device *mdev = entity->graph_obj.mdev;
+	struct media_link *link, *tmp;
+	struct media_interface *intf;
+	unsigned int i;
+
+	if (mdev == NULL)
+		return;
+
+	spin_lock(&mdev->lock);
+
+	/* Remove all interface links pointing to this entity */
+	list_for_each_entry(intf, &mdev->interfaces, graph_obj.list) {
+		list_for_each_entry_safe(link, tmp, &intf->links, list) {
+			if (link->entity == entity)
+				__media_remove_intf_link(link);
+		}
+	}
+
+	/* Remove all data links that belong to this entity */
+	__media_entity_remove_links(entity);
+
+	/* Remove all pads that belong to this entity */
+	for (i = 0; i < entity->num_pads; i++)
+		media_gobj_destroy(&entity->pads[i].graph_obj);
+
+	/* Remove the entity */
+	media_gobj_destroy(&entity->graph_obj);
+
+	spin_unlock(&mdev->lock);
+	entity->graph_obj.mdev = NULL;
+}
+EXPORT_SYMBOL_GPL(media_device_unregister_entity);
+
+/**
  * media_device_register - register a media device
  * @mdev:	The media device
  *
@@ -611,86 +691,6 @@ void media_device_unregister(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
-/**
- * media_device_register_entity - Register an entity with a media device
- * @mdev:	The media device
- * @entity:	The entity
- */
-int __must_check media_device_register_entity(struct media_device *mdev,
-					      struct media_entity *entity)
-{
-	unsigned int i;
-
-	if (entity->function == MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN ||
-	    entity->function == MEDIA_ENT_F_UNKNOWN)
-		dev_warn(mdev->dev,
-			 "Entity type for entity %s was not initialized!\n",
-			 entity->name);
-
-	/* Warn if we apparently re-register an entity */
-	WARN_ON(entity->graph_obj.mdev != NULL);
-	entity->graph_obj.mdev = mdev;
-	INIT_LIST_HEAD(&entity->links);
-	entity->num_links = 0;
-	entity->num_backlinks = 0;
-
-	spin_lock(&mdev->lock);
-	/* Initialize media_gobj embedded at the entity */
-	media_gobj_create(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
-
-	/* Initialize objects at the pads */
-	for (i = 0; i < entity->num_pads; i++)
-		media_gobj_create(mdev, MEDIA_GRAPH_PAD,
-			       &entity->pads[i].graph_obj);
-
-	spin_unlock(&mdev->lock);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(media_device_register_entity);
-
-/**
- * media_device_unregister_entity - Unregister an entity
- * @entity:	The entity
- *
- * If the entity has never been registered this function will return
- * immediately.
- */
-void media_device_unregister_entity(struct media_entity *entity)
-{
-	struct media_device *mdev = entity->graph_obj.mdev;
-	struct media_link *link, *tmp;
-	struct media_interface *intf;
-	unsigned int i;
-
-	if (mdev == NULL)
-		return;
-
-	spin_lock(&mdev->lock);
-
-	/* Remove all interface links pointing to this entity */
-	list_for_each_entry(intf, &mdev->interfaces, graph_obj.list) {
-		list_for_each_entry_safe(link, tmp, &intf->links, list) {
-			if (link->entity == entity)
-				__media_remove_intf_link(link);
-		}
-	}
-
-	/* Remove all data links that belong to this entity */
-	__media_entity_remove_links(entity);
-
-	/* Remove all pads that belong to this entity */
-	for (i = 0; i < entity->num_pads; i++)
-		media_gobj_destroy(&entity->pads[i].graph_obj);
-
-	/* Remove the entity */
-	media_gobj_destroy(&entity->graph_obj);
-
-	spin_unlock(&mdev->lock);
-	entity->graph_obj.mdev = NULL;
-}
-EXPORT_SYMBOL_GPL(media_device_unregister_entity);
-
 static void media_device_release_devres(struct device *dev, void *res)
 {
 }
-- 
2.5.0

