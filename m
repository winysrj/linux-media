Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934294AbbLPRLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 12:11:37 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/5] [media] move documentation to the header files
Date: Wed, 16 Dec 2015 15:11:11 -0200
Message-Id: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some exported functions were still documented at the .c file,
instead of documenting at the .h one.

Move the documentation to the right place, as we only use headers
at media device-drivers.xml DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 37 -------------------------------------
 drivers/media/media-entity.c | 13 -------------
 include/media/media-device.h |  6 ++++++
 include/media/media-entity.h | 18 ++++++++++++++++--
 4 files changed, 22 insertions(+), 52 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 49dd41cd047f..3e0227555196 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -577,13 +577,6 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 }
 EXPORT_SYMBOL_GPL(media_device_register_entity);
 
-/**
- * media_device_unregister_entity - Unregister an entity
- * @entity:	The entity
- *
- * If the entity has never been registered this function will return
- * immediately.
- */
 static void __media_device_unregister_entity(struct media_entity *entity)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
@@ -627,17 +620,6 @@ void media_device_unregister_entity(struct media_entity *entity)
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity);
 
-
-/**
- * media_device_init() - initialize a media device
- * @mdev:	The media device
- *
- * The caller is responsible for initializing the media device before
- * registration. The following fields must be set:
- *
- * - dev must point to the parent device
- * - model must be filled with the device model name
- */
 int __must_check media_device_init(struct media_device *mdev)
 {
 	if (WARN_ON(mdev->dev == NULL))
@@ -657,11 +639,6 @@ int __must_check media_device_init(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_init);
 
-/**
- * media_device_cleanup() - Cleanup a media device
- * @mdev:	The media device
- *
- */
 void media_device_cleanup(struct media_device *mdev)
 {
 	ida_destroy(&mdev->entity_internal_idx);
@@ -670,13 +647,6 @@ void media_device_cleanup(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_cleanup);
 
-/**
- * __media_device_register() - register a media device
- * @mdev:	The media device
- * @owner:	The module owner
- *
- * returns zero on success or a negative error code.
- */
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner)
 {
@@ -706,13 +676,6 @@ int __must_check __media_device_register(struct media_device *mdev,
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
 
-/**
- * media_device_unregister - unregister a media device
- * @mdev:	The media device
- *
- * It is safe to call this function on an unregistered
- * (but initialised) media device.
- */
 void media_device_unregister(struct media_device *mdev)
 {
 	struct media_entity *entity;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 32a5f8cae72d..a2d28162213e 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -70,14 +70,6 @@ static inline const char *intf_type(struct media_interface *intf)
 	}
 };
 
-/**
- * __media_entity_enum_init - Initialise an entity enumeration
- *
- * @ent_enum: Entity enumeration to be initialised
- * @idx_max: Maximum number of entities in the enumeration
- *
- * Returns zero on success or a negative error code.
- */
 __must_check int __media_entity_enum_init(struct media_entity_enum *ent_enum,
 					  int idx_max)
 {
@@ -93,11 +85,6 @@ __must_check int __media_entity_enum_init(struct media_entity_enum *ent_enum,
 }
 EXPORT_SYMBOL_GPL(__media_entity_enum_init);
 
-/**
- * media_entity_enum_cleanup - Release resources of an entity enumeration
- *
- * @e: Entity enumeration to be released
- */
 void media_entity_enum_cleanup(struct media_entity_enum *ent_enum)
 {
 	kfree(ent_enum->bmap);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index ded71f60d193..4b900c9c5cdd 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -428,6 +428,8 @@ void media_device_cleanup(struct media_device *mdev);
  * a sysfs attribute.
  *
  * Unregistering a media device that hasn't been registered is *NOT* safe.
+ *
+ * Return: returns zero on success or a negative error code.
  */
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner);
@@ -437,6 +439,10 @@ int __must_check __media_device_register(struct media_device *mdev,
  * __media_device_unregister() - Unegisters a media device element
  *
  * @mdev:	pointer to struct &media_device
+ *
+ *
+ * It is safe to call this function on an unregistered (but initialised)
+ * media device.
  */
 void media_device_unregister(struct media_device *mdev);
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index f915ed62ac81..c4aaeb85229c 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -370,9 +370,23 @@ static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
 	}
 }
 
+/**
+ * __media_entity_enum_init - Initialise an entity enumeration
+ *
+ * @ent_enum: Entity enumeration to be initialised
+ * @idx_max: Maximum number of entities in the enumeration
+ *
+ * Return: Returns zero on success or a negative error code.
+ */
 __must_check int __media_entity_enum_init(struct media_entity_enum *ent_enum,
 					  int idx_max);
-void media_entity_enum_cleanup(struct media_entity_enum *e);
+
+/**
+ * media_entity_enum_cleanup - Release resources of an entity enumeration
+ *
+ * @ent_enum: Entity enumeration to be released
+ */
+void media_entity_enum_cleanup(struct media_entity_enum *ent_enum);
 
 /**
  * media_entity_enum_zero - Clear the entire enum
@@ -847,6 +861,7 @@ void media_remove_intf_link(struct media_link *link);
  * Note: this is an unlocked version of media_remove_intf_links().
  */
 void __media_remove_intf_links(struct media_interface *intf);
+
 /**
  * media_remove_intf_links() - remove all links associated with an interface
  *
@@ -861,7 +876,6 @@ void __media_remove_intf_links(struct media_interface *intf);
  */
 void media_remove_intf_links(struct media_interface *intf);
 
-
 #define media_entity_call(entity, operation, args...)			\
 	(((entity)->ops && (entity)->ops->operation) ?			\
 	 (entity)->ops->operation((entity) , ##args) : -ENOIOCTLCMD)
-- 
2.5.0

