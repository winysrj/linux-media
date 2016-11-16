Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:42715 "EHLO
        resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936101AbcKPUuI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 15:50:08 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: remove obsolete Media Device Managed resource interfaces
Date: Wed, 16 Nov 2016 13:49:50 -0700
Message-Id: <20161116204950.29400-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove obsolete media_device_get_devres(), media_device_find_devres(),
and media_device_release_devres() interfaces. These interfaces are now
obsolete.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c | 26 --------------------------
 include/media/media-device.h | 32 --------------------------------
 2 files changed, 58 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 2783531..5b67267 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -817,32 +817,6 @@ void media_device_unregister(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
-static void media_device_release_devres(struct device *dev, void *res)
-{
-}
-
-struct media_device *media_device_get_devres(struct device *dev)
-{
-	struct media_device *mdev;
-
-	mdev = devres_find(dev, media_device_release_devres, NULL, NULL);
-	if (mdev)
-		return mdev;
-
-	mdev = devres_alloc(media_device_release_devres,
-				sizeof(struct media_device), GFP_KERNEL);
-	if (!mdev)
-		return NULL;
-	return devres_get(dev, mdev, NULL, NULL);
-}
-EXPORT_SYMBOL_GPL(media_device_get_devres);
-
-struct media_device *media_device_find_devres(struct device *dev)
-{
-	return devres_find(dev, media_device_release_devres, NULL, NULL);
-}
-EXPORT_SYMBOL_GPL(media_device_find_devres);
-
 #if IS_ENABLED(CONFIG_PCI)
 void media_device_pci_init(struct media_device *mdev,
 			   struct pci_dev *pci_dev,
diff --git a/include/media/media-device.h b/include/media/media-device.h
index ef93e21..633f2e3 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -373,30 +373,6 @@ int __must_check media_device_register_entity_notify(struct media_device *mdev,
 void media_device_unregister_entity_notify(struct media_device *mdev,
 					struct media_entity_notify *nptr);
 
-/**
- * media_device_get_devres() -	get media device as device resource
- *				creates if one doesn't exist
- *
- * @dev: pointer to struct &device.
- *
- * Sometimes, the media controller &media_device needs to be shared by more
- * than one driver. This function adds support for that, by dynamically
- * allocating the &media_device and allowing it to be obtained from the
- * struct &device associated with the common device where all sub-device
- * components belong. So, for example, on an USB device with multiple
- * interfaces, each interface may be handled by a separate per-interface
- * drivers. While each interface have its own &device, they all share a
- * common &device associated with the hole USB device.
- */
-struct media_device *media_device_get_devres(struct device *dev);
-
-/**
- * media_device_find_devres() - find media device as device resource
- *
- * @dev: pointer to struct &device.
- */
-struct media_device *media_device_find_devres(struct device *dev);
-
 /* Iterate over all entities. */
 #define media_device_for_each_entity(entity, mdev)			\
 	list_for_each_entry(entity, &(mdev)->entities, graph_obj.list)
@@ -474,14 +450,6 @@ static inline void media_device_unregister_entity_notify(
 					struct media_entity_notify *nptr)
 {
 }
-static inline struct media_device *media_device_get_devres(struct device *dev)
-{
-	return NULL;
-}
-static inline struct media_device *media_device_find_devres(struct device *dev)
-{
-	return NULL;
-}
 
 static inline void media_device_pci_init(struct media_device *mdev,
 					 struct pci_dev *pci_dev,
-- 
2.7.4

