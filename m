Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40442 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751459AbcGNWfX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 18:35:23 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [RFC 01/16] Revert "[media] media: fix media devnode ioctl/syscall and unregister race"
Date: Fri, 15 Jul 2016 01:34:56 +0300
Message-Id: <1468535711-13836-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 6f0dd24a084a ("[media] media: fix media devnode
ioctl/syscall and unregister race"). The commit was part of an original
patchset to avoid crashes when an unregistering device is in use.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c  | 15 +++++++--------
 drivers/media/media-devnode.c |  8 +-------
 include/media/media-devnode.h | 16 ++--------------
 3 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1795abe..33a9952 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -732,7 +732,6 @@ int __must_check __media_device_register(struct media_device *mdev,
 	if (ret < 0) {
 		/* devnode free is handled in media_devnode_*() */
 		mdev->devnode = NULL;
-		media_devnode_unregister_prepare(devnode);
 		media_devnode_unregister(devnode);
 		return ret;
 	}
@@ -789,9 +788,6 @@ void media_device_unregister(struct media_device *mdev)
 		return;
 	}
 
-	/* Clear the devnode register bit to avoid races with media dev open */
-	media_devnode_unregister_prepare(mdev->devnode);
-
 	/* Remove all entities from the media device */
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
 		__media_device_unregister_entity(entity);
@@ -812,10 +808,13 @@ void media_device_unregister(struct media_device *mdev)
 
 	dev_dbg(mdev->dev, "Media device unregistered\n");
 
-	device_remove_file(&mdev->devnode->dev, &dev_attr_model);
-	media_devnode_unregister(mdev->devnode);
-	/* devnode free is handled in media_devnode_*() */
-	mdev->devnode = NULL;
+	/* Check if mdev devnode was registered */
+	if (media_devnode_is_registered(mdev->devnode)) {
+		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
+		media_devnode_unregister(mdev->devnode);
+		/* devnode free is handled in media_devnode_*() */
+		mdev->devnode = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index f2772ba..5b605ff 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -287,7 +287,7 @@ cdev_add_error:
 	return ret;
 }
 
-void media_devnode_unregister_prepare(struct media_devnode *devnode)
+void media_devnode_unregister(struct media_devnode *devnode)
 {
 	/* Check if devnode was ever registered at all */
 	if (!media_devnode_is_registered(devnode))
@@ -295,12 +295,6 @@ void media_devnode_unregister_prepare(struct media_devnode *devnode)
 
 	mutex_lock(&media_devnode_lock);
 	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
-	mutex_unlock(&media_devnode_lock);
-}
-
-void media_devnode_unregister(struct media_devnode *devnode)
-{
-	mutex_lock(&media_devnode_lock);
 	/* Delete the cdev on this minor as well */
 	cdev_del(&devnode->cdev);
 	mutex_unlock(&media_devnode_lock);
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 37d4948..d5037a9 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -127,26 +127,14 @@ int __must_check media_devnode_register(struct media_device *mdev,
 					struct module *owner);
 
 /**
- * media_devnode_unregister_prepare - clear the media device node register bit
- * @devnode: the device node to prepare for unregister
- *
- * This clears the passed device register bit. Future open calls will be met
- * with errors. Should be called before media_devnode_unregister() to avoid
- * races with unregister and device file open calls.
- *
- * This function can safely be called if the device node has never been
- * registered or has already been unregistered.
- */
-void media_devnode_unregister_prepare(struct media_devnode *devnode);
-
-/**
  * media_devnode_unregister - unregister a media device node
  * @devnode: the device node to unregister
  *
  * This unregisters the passed device. Future open calls will be met with
  * errors.
  *
- * Should be called after media_devnode_unregister_prepare()
+ * This function can safely be called if the device node has never been
+ * registered or has already been unregistered.
  */
 void media_devnode_unregister(struct media_devnode *devnode);
 
-- 
2.1.4

