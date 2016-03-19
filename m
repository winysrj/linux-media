Return-path: <linux-media-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:49637 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbcCSAnX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 20:43:23 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>, alsa-devel@alsa-project.org
Subject: [PATCH v2] [media] media-device: use kref for media_device instance
Date: Fri, 18 Mar 2016 21:42:16 -0300
Message-Id: <9d8830150475bc4d4dde2fa1f5163aef82a35477.1458347578.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the media_device can be used by multiple drivers,
via devres, we need to be sure that it will be dropped only
when all drivers stop using it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---

v2: The kref is now used only when media_device is allocated via 
    the media_device*_devress. This warrants that other drivers won't be
    affected, and that we can keep media_device_cleanup() balanced with
    media_device_init().

 drivers/media/media-device.c           | 117 +++++++++++++++++++++++++--------
 drivers/media/usb/au0828/au0828-core.c |   3 +-
 include/media/media-device.h           |  28 ++++++++
 sound/usb/media.c                      |   3 +-
 4 files changed, 118 insertions(+), 33 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c32fa15cc76e..4a97d92a7e7d 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -707,11 +707,16 @@ void media_device_init(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_init);
 
-void media_device_cleanup(struct media_device *mdev)
+static void __media_device_cleanup(struct media_device *mdev)
 {
 	ida_destroy(&mdev->entity_internal_idx);
 	mdev->entity_internal_idx_max = 0;
 	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
+}
+
+void media_device_cleanup(struct media_device *mdev)
+{
+	__media_device_cleanup(mdev);
 	mutex_destroy(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_device_cleanup);
@@ -721,6 +726,9 @@ int __must_check __media_device_register(struct media_device *mdev,
 {
 	int ret;
 
+	/* Check if mdev was ever registered at all */
+	mutex_lock(&mdev->graph_mutex);
+
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
 	mdev->devnode.parent = mdev->dev;
@@ -731,17 +739,19 @@ int __must_check __media_device_register(struct media_device *mdev,
 
 	ret = media_devnode_register(&mdev->devnode, owner);
 	if (ret < 0)
-		return ret;
+		goto err;
 
 	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
 	if (ret < 0) {
 		media_devnode_unregister(&mdev->devnode);
-		return ret;
+		goto err;
 	}
 
 	dev_dbg(mdev->dev, "Media device registered\n");
 
-	return 0;
+err:
+	mutex_unlock(&mdev->graph_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
 
@@ -773,24 +783,13 @@ void media_device_unregister_entity_notify(struct media_device *mdev,
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
 
-void media_device_unregister(struct media_device *mdev)
+static void __media_device_unregister(struct media_device *mdev)
 {
 	struct media_entity *entity;
 	struct media_entity *next;
 	struct media_interface *intf, *tmp_intf;
 	struct media_entity_notify *notify, *nextp;
 
-	if (mdev == NULL)
-		return;
-
-	mutex_lock(&mdev->graph_mutex);
-
-	/* Check if mdev was ever registered at all */
-	if (!media_devnode_is_registered(&mdev->devnode)) {
-		mutex_unlock(&mdev->graph_mutex);
-		return;
-	}
-
 	/* Remove all entities from the media device */
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
 		__media_device_unregister_entity(entity);
@@ -807,38 +806,98 @@ void media_device_unregister(struct media_device *mdev)
 		kfree(intf);
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
-
-	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
-	media_devnode_unregister(&mdev->devnode);
+	/* Check if mdev devnode was registered */
+	if (media_devnode_is_registered(&mdev->devnode)) {
+		device_remove_file(&mdev->devnode.dev, &dev_attr_model);
+		media_devnode_unregister(&mdev->devnode);
+	}
 
 	dev_dbg(mdev->dev, "Media device unregistered\n");
 }
+
+void media_device_unregister(struct media_device *mdev)
+{
+	if (mdev == NULL)
+		return;
+
+	mutex_lock(&mdev->graph_mutex);
+	__media_device_unregister(mdev);
+	mutex_unlock(&mdev->graph_mutex);
+}
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
 static void media_device_release_devres(struct device *dev, void *res)
 {
 }
 
-struct media_device *media_device_get_devres(struct device *dev)
+static void do_media_device_unregister_devres(struct kref *kref)
 {
+	struct media_device_devres *mdev_devres;
 	struct media_device *mdev;
+	int ret;
 
-	mdev = devres_find(dev, media_device_release_devres, NULL, NULL);
-	if (mdev)
-		return mdev;
+	mdev_devres = container_of(kref, struct media_device_devres, kref);
 
-	mdev = devres_alloc(media_device_release_devres,
-				sizeof(struct media_device), GFP_KERNEL);
-	if (!mdev)
+	if (!mdev_devres)
+		return;
+
+	mdev = &mdev_devres->mdev;
+
+	mutex_lock(&mdev->graph_mutex);
+	__media_device_unregister(mdev);
+	__media_device_cleanup(mdev);
+	mutex_unlock(&mdev->graph_mutex);
+	mutex_destroy(&mdev->graph_mutex);
+
+	ret = devres_destroy(mdev->dev, media_device_release_devres,
+			     NULL, NULL);
+	pr_debug("%s: devres_destroy() returned %d\n", __func__, ret);
+}
+
+void media_device_unregister_devres(struct media_device *mdev)
+{
+	struct media_device_devres *mdev_devres;
+
+	mdev_devres = container_of(mdev, struct media_device_devres, mdev);
+	kref_put(&mdev_devres->kref, do_media_device_unregister_devres);
+}
+EXPORT_SYMBOL_GPL(media_device_unregister_devres);
+
+struct media_device *media_device_get_devres(struct device *dev)
+{
+	struct media_device_devres *mdev_devres, *ptr;
+
+	mdev_devres = devres_find(dev, media_device_release_devres, NULL, NULL);
+	if (mdev_devres) {
+		kref_get(&mdev_devres->kref);
+		return &mdev_devres->mdev;
+	}
+
+	mdev_devres = devres_alloc(media_device_release_devres,
+				   sizeof(struct media_device_devres),
+				   GFP_KERNEL);
+	if (!mdev_devres)
 		return NULL;
-	return devres_get(dev, mdev, NULL, NULL);
+
+	ptr = devres_get(dev, mdev_devres, NULL, NULL);
+	if (ptr)
+		kref_init(&ptr->kref);
+	else
+		devres_free(mdev_devres);
+
+	return &ptr->mdev;
 }
 EXPORT_SYMBOL_GPL(media_device_get_devres);
 
 struct media_device *media_device_find_devres(struct device *dev)
 {
-	return devres_find(dev, media_device_release_devres, NULL, NULL);
+	struct media_device_devres *mdev_devres;
+
+	mdev_devres = devres_find(dev, media_device_release_devres, NULL, NULL);
+	if (!mdev_devres)
+		return NULL;
+
+	return &mdev_devres->mdev;
 }
 EXPORT_SYMBOL_GPL(media_device_find_devres);
 
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 06da73f1ff22..060904ed8f20 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -157,8 +157,7 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 	dev->media_dev->enable_source = NULL;
 	dev->media_dev->disable_source = NULL;
 
-	media_device_unregister(dev->media_dev);
-	media_device_cleanup(dev->media_dev);
+	media_device_unregister_devres(dev->media_dev);
 	dev->media_dev = NULL;
 #endif
 }
diff --git a/include/media/media-device.h b/include/media/media-device.h
index b21ef244ad3e..e59772ed8494 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -23,6 +23,7 @@
 #ifndef _MEDIA_DEVICE_H
 #define _MEDIA_DEVICE_H
 
+#include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 
@@ -382,6 +383,16 @@ struct media_device {
 			   unsigned int notification);
 };
 
+/**
+ * struct media_device_devres - Media device device resource
+ * @mdev:	pointer to struct media_device
+ * @kref:	Object refcount
+ */
+struct media_device_devres {
+	struct media_device mdev;
+	struct kref kref;
+};
+
 /* We don't need to include pci.h or usb.h here */
 struct pci_dev;
 struct usb_device;
@@ -604,6 +615,19 @@ struct media_device *media_device_get_devres(struct device *dev);
  */
 struct media_device *media_device_find_devres(struct device *dev);
 
+/**
+ * media_device_unregister_devres) - Unregister media device allocated as
+ *				     as device resource
+ *
+ * @dev: pointer to struct &device.
+ *
+ * Devices allocated via media_device_get_devres should be de-alocalted
+ * and freed via this function. Callers should not call
+ * media_device_unregister() nor media_device_cleanup() on devices
+ * allocated via media_device_get_devres().
+ */
+void media_device_unregister_devres(struct media_device *mdev);
+
 /* Iterate over all entities. */
 #define media_device_for_each_entity(entity, mdev)			\
 	list_for_each_entry(entity, &(mdev)->entities, graph_obj.list)
@@ -688,6 +712,10 @@ static inline struct media_device *media_device_find_devres(struct device *dev)
 	return NULL;
 }
 
+static inline void media_device_unregister_devres(struct media_device *mdev)
+{
+}
+
 static inline void media_device_pci_init(struct media_device *mdev,
 					 struct pci_dev *pci_dev,
 					 char *name)
diff --git a/sound/usb/media.c b/sound/usb/media.c
index 93a50d01490c..f78955fd0d6e 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -311,8 +311,7 @@ void media_snd_device_delete(struct snd_usb_audio *chip)
 	media_snd_mixer_delete(chip);
 
 	if (mdev) {
-		if (media_devnode_is_registered(&mdev->devnode))
-			media_device_unregister(mdev);
+		media_device_unregister_devres(mdev);
 		chip->media_dev = NULL;
 	}
 }
-- 
2.5.0


