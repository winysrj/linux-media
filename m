Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964803AbbLOKnc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 05:43:32 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 2/2] [media] media-device: better lock media_device_unregister()
Date: Tue, 15 Dec 2015 08:43:12 -0200
Message-Id: <cda0486f763fc1c2f5267c3a0806cf297317301b.1450176187.git.mchehab@osg.samsung.com>
In-Reply-To: <2875b74a677adc2cd9fc11ba054654caf01e4a18.1450176187.git.mchehab@osg.samsung.com>
References: <2875b74a677adc2cd9fc11ba054654caf01e4a18.1450176187.git.mchehab@osg.samsung.com>
In-Reply-To: <2875b74a677adc2cd9fc11ba054654caf01e4a18.1450176187.git.mchehab@osg.samsung.com>
References: <2875b74a677adc2cd9fc11ba054654caf01e4a18.1450176187.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If media_device_unregister() is called by two different
drivers, a race condition may happen, as the check if the
device is not registered is not protected.

Move the spin_lock() to happen earlier in the function, in order
to prevent such race condition.

Reported-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1222fa642ad8..189c2ba8c3d3 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -573,18 +573,13 @@ EXPORT_SYMBOL_GPL(media_device_register_entity);
  * If the entity has never been registered this function will return
  * immediately.
  */
-void media_device_unregister_entity(struct media_entity *entity)
+static void __media_device_unregister_entity(struct media_entity *entity)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_link *link, *tmp;
 	struct media_interface *intf;
 	unsigned int i;
 
-	if (mdev == NULL)
-		return;
-
-	spin_lock(&mdev->lock);
-
 	/* Remove all interface links pointing to this entity */
 	list_for_each_entry(intf, &mdev->interfaces, graph_obj.list) {
 		list_for_each_entry_safe(link, tmp, &intf->links, list) {
@@ -603,11 +598,23 @@ void media_device_unregister_entity(struct media_entity *entity)
 	/* Remove the entity */
 	media_gobj_destroy(&entity->graph_obj);
 
-	spin_unlock(&mdev->lock);
 	entity->graph_obj.mdev = NULL;
 }
+
+void media_device_unregister_entity(struct media_entity *entity)
+{
+	struct media_device *mdev = entity->graph_obj.mdev;
+
+	if (mdev == NULL)
+		return;
+
+	spin_lock(&mdev->lock);
+	__media_device_unregister_entity(entity);
+	spin_unlock(&mdev->lock);
+}
 EXPORT_SYMBOL_GPL(media_device_unregister_entity);
 
+
 /**
  * media_device_register - register a media device
  * @mdev:	The media device
@@ -666,22 +673,29 @@ void media_device_unregister(struct media_device *mdev)
 	struct media_entity *next;
 	struct media_interface *intf, *tmp_intf;
 
+	if (mdev == NULL)
+		return;
+
+	spin_lock(&mdev->lock);
+
 	/* Check if mdev was ever registered at all */
-	if (!media_devnode_is_registered(&mdev->devnode))
+	if (!media_devnode_is_registered(&mdev->devnode)) {
+		spin_unlock(&mdev->lock);
 		return;
+	}
 
 	/* Remove all entities from the media device */
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
-		media_device_unregister_entity(entity);
+		__media_device_unregister_entity(entity);
 
 	/* Remove all interfaces from the media device */
-	spin_lock(&mdev->lock);
 	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
 				 graph_obj.list) {
 		__media_remove_intf_links(intf);
 		media_gobj_destroy(&intf->graph_obj);
 		kfree(intf);
 	}
+
 	spin_unlock(&mdev->lock);
 
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
-- 
2.5.0

