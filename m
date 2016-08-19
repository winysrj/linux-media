Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46730 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752779AbcHSKYD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 06:24:03 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v2 02/17] Revert "[media] media: fix use-after-free in cdev_put() when app exits after driver unbind"
Date: Fri, 19 Aug 2016 13:23:33 +0300
Message-Id: <1471602228-30722-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 5b28dde51d0c ("[media] media: fix use-after-free in
cdev_put() when app exits after driver unbind"). The commit was part of an
original patchset to avoid crashes when an unregistering device is in use.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c  |  6 ++----
 drivers/media/media-devnode.c | 48 +++++++++++++++++--------------------------
 2 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 33a9952..e61fa66 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -723,16 +723,16 @@ int __must_check __media_device_register(struct media_device *mdev,
 
 	ret = media_devnode_register(mdev, devnode, owner);
 	if (ret < 0) {
-		/* devnode free is handled in media_devnode_*() */
 		mdev->devnode = NULL;
+		kfree(devnode);
 		return ret;
 	}
 
 	ret = device_create_file(&devnode->dev, &dev_attr_model);
 	if (ret < 0) {
-		/* devnode free is handled in media_devnode_*() */
 		mdev->devnode = NULL;
 		media_devnode_unregister(devnode);
+		kfree(devnode);
 		return ret;
 	}
 
@@ -812,8 +812,6 @@ void media_device_unregister(struct media_device *mdev)
 	if (media_devnode_is_registered(mdev->devnode)) {
 		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
 		media_devnode_unregister(mdev->devnode);
-		/* devnode free is handled in media_devnode_*() */
-		mdev->devnode = NULL;
 	}
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 5b605ff..ecdc02d 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -63,8 +63,13 @@ static void media_devnode_release(struct device *cd)
 	struct media_devnode *devnode = to_media_devnode(cd);
 
 	mutex_lock(&media_devnode_lock);
+
+	/* Delete the cdev on this minor as well */
+	cdev_del(&devnode->cdev);
+
 	/* Mark device node number as free */
 	clear_bit(devnode->minor, media_devnode_nums);
+
 	mutex_unlock(&media_devnode_lock);
 
 	/* Release media_devnode and perform other cleanups as needed. */
@@ -72,7 +77,6 @@ static void media_devnode_release(struct device *cd)
 		devnode->release(devnode);
 
 	kfree(devnode);
-	pr_debug("%s: Media Devnode Deallocated\n", __func__);
 }
 
 static struct bus_type media_bus_type = {
@@ -201,8 +205,6 @@ static int media_release(struct inode *inode, struct file *filp)
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	put_device(&devnode->dev);
-
-	pr_debug("%s: Media Release\n", __func__);
 	return 0;
 }
 
@@ -233,7 +235,6 @@ int __must_check media_devnode_register(struct media_device *mdev,
 	if (minor == MEDIA_NUM_DEVICES) {
 		mutex_unlock(&media_devnode_lock);
 		pr_err("could not get a free minor\n");
-		kfree(devnode);
 		return -ENFILE;
 	}
 
@@ -243,31 +244,27 @@ int __must_check media_devnode_register(struct media_device *mdev,
 	devnode->minor = minor;
 	devnode->media_dev = mdev;
 
-	/* Part 1: Initialize dev now to use dev.kobj for cdev.kobj.parent */
-	devnode->dev.bus = &media_bus_type;
-	devnode->dev.devt = MKDEV(MAJOR(media_dev_t), devnode->minor);
-	devnode->dev.release = media_devnode_release;
-	if (devnode->parent)
-		devnode->dev.parent = devnode->parent;
-	dev_set_name(&devnode->dev, "media%d", devnode->minor);
-	device_initialize(&devnode->dev);
-
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &media_devnode_fops);
 	devnode->cdev.owner = owner;
-	devnode->cdev.kobj.parent = &devnode->dev.kobj;
 
 	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
 	if (ret < 0) {
 		pr_err("%s: cdev_add failed\n", __func__);
-		goto cdev_add_error;
+		goto error;
 	}
 
-	/* Part 3: Add the media device */
-	ret = device_add(&devnode->dev);
+	/* Part 3: Register the media device */
+	devnode->dev.bus = &media_bus_type;
+	devnode->dev.devt = MKDEV(MAJOR(media_dev_t), devnode->minor);
+	devnode->dev.release = media_devnode_release;
+	if (devnode->parent)
+		devnode->dev.parent = devnode->parent;
+	dev_set_name(&devnode->dev, "media%d", devnode->minor);
+	ret = device_register(&devnode->dev);
 	if (ret < 0) {
-		pr_err("%s: device_add failed\n", __func__);
-		goto device_add_error;
+		pr_err("%s: device_register failed\n", __func__);
+		goto error;
 	}
 
 	/* Part 4: Activate this minor. The char device can now be used. */
@@ -275,15 +272,12 @@ int __must_check media_devnode_register(struct media_device *mdev,
 
 	return 0;
 
-device_add_error:
-	cdev_del(&devnode->cdev);
-cdev_add_error:
+error:
 	mutex_lock(&media_devnode_lock);
+	cdev_del(&devnode->cdev);
 	clear_bit(devnode->minor, media_devnode_nums);
-	devnode->media_dev = NULL;
 	mutex_unlock(&media_devnode_lock);
 
-	put_device(&devnode->dev);
 	return ret;
 }
 
@@ -295,12 +289,8 @@ void media_devnode_unregister(struct media_devnode *devnode)
 
 	mutex_lock(&media_devnode_lock);
 	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
-	/* Delete the cdev on this minor as well */
-	cdev_del(&devnode->cdev);
 	mutex_unlock(&media_devnode_lock);
-	device_del(&devnode->dev);
-	devnode->media_dev = NULL;
-	put_device(&devnode->dev);
+	device_unregister(&devnode->dev);
 }
 
 /*
-- 
2.1.4

