Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40244 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbcCXWWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 18:22:46 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 1/2] Revert "[media] media-device: use kref for media_device instance"
Date: Fri, 25 Mar 2016 00:22:43 +0200
Message-Id: <1458858164-1066-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458858164-1066-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458858164-1066-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 44ff16d0b7ccb4c872de7a53196b2d3f83089607.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/media-device.c           | 117 ++++++++-------------------------
 drivers/media/usb/au0828/au0828-core.c |   3 +-
 include/media/media-device.h           |  28 --------
 sound/usb/media.c                      |   3 +-
 4 files changed, 33 insertions(+), 118 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 4a97d92a7e7d..c32fa15cc76e 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -707,16 +707,11 @@ void media_device_init(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_init);
 
-static void __media_device_cleanup(struct media_device *mdev)
+void media_device_cleanup(struct media_device *mdev)
 {
 	ida_destroy(&mdev->entity_internal_idx);
 	mdev->entity_internal_idx_max = 0;
 	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
-}
-
-void media_device_cleanup(struct media_device *mdev)
-{
-	__media_device_cleanup(mdev);
 	mutex_destroy(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_device_cleanup);
@@ -726,9 +721,6 @@ int __must_check __media_device_register(struct media_device *mdev,
 {
 	int ret;
 
-	/* Check if mdev was ever registered at all */
-	mutex_lock(&mdev->graph_mutex);
-
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
 	mdev->devnode.parent = mdev->dev;
@@ -739,19 +731,17 @@ int __must_check __media_device_register(struct media_device *mdev,
 
 	ret = media_devnode_register(&mdev->devnode, owner);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
 	if (ret < 0) {
 		media_devnode_unregister(&mdev->devnode);
-		goto err;
+		return ret;
 	}
 
 	dev_dbg(mdev->dev, "Media device registered\n");
 
-err:
-	mutex_unlock(&mdev->graph_mutex);
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
 
@@ -783,13 +773,24 @@ void media_device_unregister_entity_notify(struct media_device *mdev,
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
 
-static void __media_device_unregister(struct media_device *mdev)
+void media_device_unregister(struct media_device *mdev)
 {
 	struct media_entity *entity;
 	struct media_entity *next;
 	struct media_interface *intf, *tmp_intf;
 	struct media_entity_notify *notify, *nextp;
 
+	if (mdev == NULL)
+		return;
+
+	mutex_lock(&mdev->graph_mutex);
+
+	/* Check if mdev was ever registered at all */
+	if (!media_devnode_is_registered(&mdev->devnode)) {
+		mutex_unlock(&mdev->graph_mutex);
+		return;
+	}
+
 	/* Remove all entities from the media device */
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
 		__media_device_unregister_entity(entity);
@@ -806,23 +807,12 @@ static void __media_device_unregister(struct media_device *mdev)
 		kfree(intf);
 	}
 
-	/* Check if mdev devnode was registered */
-	if (media_devnode_is_registered(&mdev->devnode)) {
-		device_remove_file(&mdev->devnode.dev, &dev_attr_model);
-		media_devnode_unregister(&mdev->devnode);
-	}
+	mutex_unlock(&mdev->graph_mutex);
 
-	dev_dbg(mdev->dev, "Media device unregistered\n");
-}
+	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
+	media_devnode_unregister(&mdev->devnode);
 
-void media_device_unregister(struct media_device *mdev)
-{
-	if (mdev == NULL)
-		return;
-
-	mutex_lock(&mdev->graph_mutex);
-	__media_device_unregister(mdev);
-	mutex_unlock(&mdev->graph_mutex);
+	dev_dbg(mdev->dev, "Media device unregistered\n");
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
@@ -830,74 +820,25 @@ static void media_device_release_devres(struct device *dev, void *res)
 {
 }
 
-static void do_media_device_unregister_devres(struct kref *kref)
-{
-	struct media_device_devres *mdev_devres;
-	struct media_device *mdev;
-	int ret;
-
-	mdev_devres = container_of(kref, struct media_device_devres, kref);
-
-	if (!mdev_devres)
-		return;
-
-	mdev = &mdev_devres->mdev;
-
-	mutex_lock(&mdev->graph_mutex);
-	__media_device_unregister(mdev);
-	__media_device_cleanup(mdev);
-	mutex_unlock(&mdev->graph_mutex);
-	mutex_destroy(&mdev->graph_mutex);
-
-	ret = devres_destroy(mdev->dev, media_device_release_devres,
-			     NULL, NULL);
-	pr_debug("%s: devres_destroy() returned %d\n", __func__, ret);
-}
-
-void media_device_unregister_devres(struct media_device *mdev)
-{
-	struct media_device_devres *mdev_devres;
-
-	mdev_devres = container_of(mdev, struct media_device_devres, mdev);
-	kref_put(&mdev_devres->kref, do_media_device_unregister_devres);
-}
-EXPORT_SYMBOL_GPL(media_device_unregister_devres);
-
 struct media_device *media_device_get_devres(struct device *dev)
 {
-	struct media_device_devres *mdev_devres, *ptr;
+	struct media_device *mdev;
 
-	mdev_devres = devres_find(dev, media_device_release_devres, NULL, NULL);
-	if (mdev_devres) {
-		kref_get(&mdev_devres->kref);
-		return &mdev_devres->mdev;
-	}
+	mdev = devres_find(dev, media_device_release_devres, NULL, NULL);
+	if (mdev)
+		return mdev;
 
-	mdev_devres = devres_alloc(media_device_release_devres,
-				   sizeof(struct media_device_devres),
-				   GFP_KERNEL);
-	if (!mdev_devres)
+	mdev = devres_alloc(media_device_release_devres,
+				sizeof(struct media_device), GFP_KERNEL);
+	if (!mdev)
 		return NULL;
-
-	ptr = devres_get(dev, mdev_devres, NULL, NULL);
-	if (ptr)
-		kref_init(&ptr->kref);
-	else
-		devres_free(mdev_devres);
-
-	return &ptr->mdev;
+	return devres_get(dev, mdev, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(media_device_get_devres);
 
 struct media_device *media_device_find_devres(struct device *dev)
 {
-	struct media_device_devres *mdev_devres;
-
-	mdev_devres = devres_find(dev, media_device_release_devres, NULL, NULL);
-	if (!mdev_devres)
-		return NULL;
-
-	return &mdev_devres->mdev;
+	return devres_find(dev, media_device_release_devres, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(media_device_find_devres);
 
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 85c13ca5178f..e2fb3c836b88 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -157,7 +157,8 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 	dev->media_dev->enable_source = NULL;
 	dev->media_dev->disable_source = NULL;
 
-	media_device_unregister_devres(dev->media_dev);
+	media_device_unregister(dev->media_dev);
+	media_device_cleanup(dev->media_dev);
 	dev->media_dev = NULL;
 #endif
 }
diff --git a/include/media/media-device.h b/include/media/media-device.h
index e59772ed8494..b21ef244ad3e 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -23,7 +23,6 @@
 #ifndef _MEDIA_DEVICE_H
 #define _MEDIA_DEVICE_H
 
-#include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 
@@ -383,16 +382,6 @@ struct media_device {
 			   unsigned int notification);
 };
 
-/**
- * struct media_device_devres - Media device device resource
- * @mdev:	pointer to struct media_device
- * @kref:	Object refcount
- */
-struct media_device_devres {
-	struct media_device mdev;
-	struct kref kref;
-};
-
 /* We don't need to include pci.h or usb.h here */
 struct pci_dev;
 struct usb_device;
@@ -615,19 +604,6 @@ struct media_device *media_device_get_devres(struct device *dev);
  */
 struct media_device *media_device_find_devres(struct device *dev);
 
-/**
- * media_device_unregister_devres) - Unregister media device allocated as
- *				     as device resource
- *
- * @dev: pointer to struct &device.
- *
- * Devices allocated via media_device_get_devres should be de-alocalted
- * and freed via this function. Callers should not call
- * media_device_unregister() nor media_device_cleanup() on devices
- * allocated via media_device_get_devres().
- */
-void media_device_unregister_devres(struct media_device *mdev);
-
 /* Iterate over all entities. */
 #define media_device_for_each_entity(entity, mdev)			\
 	list_for_each_entry(entity, &(mdev)->entities, graph_obj.list)
@@ -712,10 +688,6 @@ static inline struct media_device *media_device_find_devres(struct device *dev)
 	return NULL;
 }
 
-static inline void media_device_unregister_devres(struct media_device *mdev)
-{
-}
-
 static inline void media_device_pci_init(struct media_device *mdev,
 					 struct pci_dev *pci_dev,
 					 char *name)
diff --git a/sound/usb/media.c b/sound/usb/media.c
index d5584e907a86..0d03773b4c67 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -303,7 +303,8 @@ void media_snd_device_delete(struct snd_usb_audio *chip)
 	media_snd_mixer_delete(chip);
 
 	if (mdev) {
-		media_device_unregister_devres(mdev);
+		if (media_devnode_is_registered(&mdev->devnode))
+			media_device_unregister(mdev);
 		chip->media_dev = NULL;
 	}
 }
-- 
2.7.3

