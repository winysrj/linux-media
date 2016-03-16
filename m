Return-path: <linux-media-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:39058 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965207AbcCPMFB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 08:05:01 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 4/5] [media] media-device: use kref for media_device instance
Date: Wed, 16 Mar 2016 09:04:05 -0300
Message-Id: <82ef082c4de7c0a1c546da1d9e462bc86ab423bf.1458129823.git.mchehab@osg.samsung.com>
In-Reply-To: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
In-Reply-To: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the media_device can be used by multiple drivers,
via devres, we need to be sure that it will be dropped only
when all drivers stop using it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 48 +++++++++++++++++++++++++++++++-------------
 include/media/media-device.h |  3 +++
 2 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c32fa15cc76e..38e6c319fe6e 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -721,6 +721,15 @@ int __must_check __media_device_register(struct media_device *mdev,
 {
 	int ret;
 
+	/* Check if mdev was ever registered at all */
+	mutex_lock(&mdev->graph_mutex);
+	if (media_devnode_is_registered(&mdev->devnode)) {
+		kref_get(&mdev->kref);
+		mutex_unlock(&mdev->graph_mutex);
+		return 0;
+	}
+	kref_init(&mdev->kref);
+
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
 	mdev->devnode.parent = mdev->dev;
@@ -730,8 +739,10 @@ int __must_check __media_device_register(struct media_device *mdev,
 	mdev->topology_version = 0;
 
 	ret = media_devnode_register(&mdev->devnode, owner);
-	if (ret < 0)
+	if (ret < 0) {
+		media_devnode_unregister(&mdev->devnode);
 		return ret;
+	}
 
 	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
 	if (ret < 0) {
@@ -739,6 +750,7 @@ int __must_check __media_device_register(struct media_device *mdev,
 		return ret;
 	}
 
+	mutex_unlock(&mdev->graph_mutex);
 	dev_dbg(mdev->dev, "Media device registered\n");
 
 	return 0;
@@ -773,23 +785,15 @@ void media_device_unregister_entity_notify(struct media_device *mdev,
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
 
-void media_device_unregister(struct media_device *mdev)
+static void do_media_device_unregister(struct kref *kref)
 {
+	struct media_device *mdev;
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
+	mdev = container_of(kref, struct media_device, kref);
 
 	/* Remove all entities from the media device */
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
@@ -807,13 +811,26 @@ void media_device_unregister(struct media_device *mdev)
 		kfree(intf);
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
+	/* Check if mdev devnode was registered */
+	if (!media_devnode_is_registered(&mdev->devnode))
+		return;
 
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	media_devnode_unregister(&mdev->devnode);
 
 	dev_dbg(mdev->dev, "Media device unregistered\n");
 }
+
+void media_device_unregister(struct media_device *mdev)
+{
+	if (mdev == NULL)
+		return;
+
+	mutex_lock(&mdev->graph_mutex);
+	kref_put(&mdev->kref, do_media_device_unregister);
+	mutex_unlock(&mdev->graph_mutex);
+
+}
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
 static void media_device_release_devres(struct device *dev, void *res)
@@ -825,13 +842,16 @@ struct media_device *media_device_get_devres(struct device *dev)
 	struct media_device *mdev;
 
 	mdev = devres_find(dev, media_device_release_devres, NULL, NULL);
-	if (mdev)
+	if (mdev) {
+		kref_get(&mdev->kref);
 		return mdev;
+	}
 
 	mdev = devres_alloc(media_device_release_devres,
 				sizeof(struct media_device), GFP_KERNEL);
 	if (!mdev)
 		return NULL;
+
 	return devres_get(dev, mdev, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(media_device_get_devres);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index ca3871b853ba..73c16e6e6b6b 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -23,6 +23,7 @@
 #ifndef _MEDIA_DEVICE_H
 #define _MEDIA_DEVICE_H
 
+#include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 
@@ -283,6 +284,7 @@ struct media_entity_notify {
  * struct media_device - Media device
  * @dev:	Parent device
  * @devnode:	Media device node
+ * @kref:	Object refcount
  * @driver_name: Optional device driver name. If not set, calls to
  *		%MEDIA_IOC_DEVICE_INFO will return dev->driver->name.
  *		This is needed for USB drivers for example, as otherwise
@@ -347,6 +349,7 @@ struct media_device {
 	/* dev->driver_data points to this struct. */
 	struct device *dev;
 	struct media_devnode devnode;
+	struct kref kref;
 
 	char model[32];
 	char driver_name[32];
-- 
2.5.0

