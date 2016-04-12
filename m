Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:47428 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbcDLBAI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 21:00:08 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH] media: remove Managed Media Interfaces
Date: Mon, 11 Apr 2016 19:00:02 -0600
Message-Id: <1460422802-10606-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove Managed Media Interfaces:
media_device_get_devres()
media_device_find_devres()

Using these interfaces leads to use-after-free race conditions on the
shared media device during media device unregister by drivers using it.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c | 26 --------------------------
 include/media/media-device.h | 32 --------------------------------
 2 files changed, 58 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6e43c95..a2861ca 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -820,32 +820,6 @@ void media_device_unregister(struct media_device *mdev)
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
 void media_device_pci_init(struct media_device *mdev,
 			   struct pci_dev *pci_dev,
 			   const char *name)
diff --git a/include/media/media-device.h b/include/media/media-device.h
index df74cfa..1642001 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -584,30 +584,6 @@ int __must_check media_device_register_entity_notify(struct media_device *mdev,
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
@@ -683,14 +659,6 @@ static inline void media_device_unregister_entity_notify(
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
2.5.0

