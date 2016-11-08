Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48878 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751516AbcKHNze (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:34 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 03/21] Revert "[media] media-device: dynamically allocate struct media_devnode"
Date: Tue,  8 Nov 2016 15:55:12 +0200
Message-Id: <1478613330-24691-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit a087ce704b80 ("[media] media-device: dynamically
allocate struct media_devnode"). The commit was part of an original
patchset to avoid crashes when an unregistering device is in use.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c           | 44 +++++++++++-----------------------
 drivers/media/media-devnode.c          |  7 +-----
 drivers/media/usb/au0828/au0828-core.c |  4 ++--
 drivers/media/usb/uvc/uvc_driver.c     |  2 +-
 include/media/media-device.h           |  5 +++-
 include/media/media-devnode.h          | 15 ++----------
 6 files changed, 24 insertions(+), 53 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6f5ed09..0e07300 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -417,7 +417,7 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long __arg)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
-	struct media_device *dev = devnode->media_dev;
+	struct media_device *dev = to_media_device(devnode);
 	const struct media_ioctl_info *info;
 	void __user *arg = (void __user *)__arg;
 	char __karg[256], *karg = __karg;
@@ -493,7 +493,7 @@ static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
 				      unsigned long arg)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
-	struct media_device *dev = devnode->media_dev;
+	struct media_device *dev = to_media_device(devnode);
 	long ret;
 
 	switch (cmd) {
@@ -529,8 +529,7 @@ static const struct media_file_operations media_device_fops = {
 static ssize_t show_model(struct device *cd,
 			  struct device_attribute *attr, char *buf)
 {
-	struct media_devnode *devnode = to_media_devnode(cd);
-	struct media_device *mdev = devnode->media_dev;
+	struct media_device *mdev = to_media_device(to_media_devnode(cd));
 
 	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->model), mdev->model);
 }
@@ -703,34 +702,23 @@ EXPORT_SYMBOL_GPL(media_device_cleanup);
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner)
 {
-	struct media_devnode *devnode;
 	int ret;
 
-	devnode = kzalloc(sizeof(*devnode), GFP_KERNEL);
-	if (!devnode)
-		return -ENOMEM;
-
 	/* Register the device node. */
-	mdev->devnode = devnode;
-	devnode->fops = &media_device_fops;
-	devnode->parent = mdev->dev;
-	devnode->release = media_device_release;
+	mdev->devnode.fops = &media_device_fops;
+	mdev->devnode.parent = mdev->dev;
+	mdev->devnode.release = media_device_release;
 
 	/* Set version 0 to indicate user-space that the graph is static */
 	mdev->topology_version = 0;
 
-	ret = media_devnode_register(mdev, devnode, owner);
-	if (ret < 0) {
-		mdev->devnode = NULL;
-		kfree(devnode);
+	ret = media_devnode_register(&mdev->devnode, owner);
+	if (ret < 0)
 		return ret;
-	}
 
-	ret = device_create_file(&devnode->dev, &dev_attr_model);
+	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
 	if (ret < 0) {
-		mdev->devnode = NULL;
-		media_devnode_unregister(devnode);
-		kfree(devnode);
+		media_devnode_unregister(&mdev->devnode);
 		return ret;
 	}
 
@@ -781,7 +769,7 @@ void media_device_unregister(struct media_device *mdev)
 	mutex_lock(&mdev->graph_mutex);
 
 	/* Check if mdev was ever registered at all */
-	if (!media_devnode_is_registered(mdev->devnode)) {
+	if (!media_devnode_is_registered(&mdev->devnode)) {
 		mutex_unlock(&mdev->graph_mutex);
 		return;
 	}
@@ -804,13 +792,9 @@ void media_device_unregister(struct media_device *mdev)
 
 	mutex_unlock(&mdev->graph_mutex);
 
-	dev_dbg(mdev->dev, "Media device unregistered\n");
-
-	/* Check if mdev devnode was registered */
-	if (media_devnode_is_registered(mdev->devnode)) {
-		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
-		media_devnode_unregister(mdev->devnode);
-	}
+	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
+	dev_dbg(mdev->dev, "Media device unregistering\n");
+	media_devnode_unregister(&mdev->devnode);
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index ecdc02d..7481c96 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -44,7 +44,6 @@
 #include <linux/uaccess.h>
 
 #include <media/media-devnode.h>
-#include <media/media-device.h>
 
 #define MEDIA_NUM_DEVICES	256
 #define MEDIA_NAME		"media"
@@ -75,8 +74,6 @@ static void media_devnode_release(struct device *cd)
 	/* Release media_devnode and perform other cleanups as needed. */
 	if (devnode->release)
 		devnode->release(devnode);
-
-	kfree(devnode);
 }
 
 static struct bus_type media_bus_type = {
@@ -222,8 +219,7 @@ static const struct file_operations media_devnode_fops = {
 	.llseek = no_llseek,
 };
 
-int __must_check media_devnode_register(struct media_device *mdev,
-					struct media_devnode *devnode,
+int __must_check media_devnode_register(struct media_devnode *devnode,
 					struct module *owner)
 {
 	int minor;
@@ -242,7 +238,6 @@ int __must_check media_devnode_register(struct media_device *mdev,
 	mutex_unlock(&media_devnode_lock);
 
 	devnode->minor = minor;
-	devnode->media_dev = mdev;
 
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &media_devnode_fops);
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index bf53553..321ea5c 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -142,7 +142,7 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity_notify *notify, *nextp;
 
-	if (!mdev || !media_devnode_is_registered(mdev->devnode))
+	if (!mdev || !media_devnode_is_registered(&mdev->devnode))
 		return;
 
 	/* Remove au0828 entity_notify callbacks */
@@ -482,7 +482,7 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 	if (!dev->media_dev)
 		return 0;
 
-	if (!media_devnode_is_registered(dev->media_dev->devnode)) {
+	if (!media_devnode_is_registered(&dev->media_dev->devnode)) {
 
 		/* register media device */
 		ret = media_device_register(dev->media_dev);
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 87b2fc3b..52cdef6 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1780,7 +1780,7 @@ static void uvc_delete(struct uvc_device *dev)
 	if (dev->vdev.dev)
 		v4l2_device_unregister(&dev->vdev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (media_devnode_is_registered(dev->mdev.devnode))
+	if (media_devnode_is_registered(&dev->mdev.devnode))
 		media_device_unregister(&dev->mdev);
 	media_device_cleanup(&dev->mdev);
 #endif
diff --git a/include/media/media-device.h b/include/media/media-device.h
index ef93e21..96de915 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -127,7 +127,7 @@ struct media_device_ops {
 struct media_device {
 	/* dev->driver_data points to this struct. */
 	struct device *dev;
-	struct media_devnode *devnode;
+	struct media_devnode devnode;
 
 	char model[32];
 	char driver_name[32];
@@ -172,6 +172,9 @@ struct usb_device;
 #define MEDIA_DEV_NOTIFY_PRE_LINK_CH	0
 #define MEDIA_DEV_NOTIFY_POST_LINK_CH	1
 
+/* media_devnode to media_device */
+#define to_media_device(node) container_of(node, struct media_device, devnode)
+
 /**
  * media_entity_enum_init - Initialise an entity enumeration
  *
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index d55ec2b..a68b4b6 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -33,8 +33,6 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 
-struct media_device;
-
 /*
  * Flag to mark the media_devnode struct as registered. Drivers must not touch
  * this flag directly, it will be set and cleared by media_devnode_register and
@@ -85,8 +83,6 @@ struct media_file_operations {
  * before registering the node.
  */
 struct media_devnode {
-	struct media_device *media_dev;
-
 	/* device ops */
 	const struct media_file_operations *fops;
 
@@ -109,8 +105,7 @@ struct media_devnode {
 /**
  * media_devnode_register - register a media device node
  *
- * @mdev: struct media_device we want to register a device node
- * @devnode: media device node structure we want to register
+ * @devnode: struct media_devnode we want to register a device node
  * @owner: should be filled with %THIS_MODULE
  *
  * The registration code assigns minor numbers and registers the new device node
@@ -123,8 +118,7 @@ struct media_devnode {
  * the media_devnode structure is *not* called, so the caller is responsible for
  * freeing any data.
  */
-int __must_check media_devnode_register(struct media_device *mdev,
-					struct media_devnode *devnode,
+int __must_check media_devnode_register(struct media_devnode *devnode,
 					struct module *owner);
 
 /**
@@ -154,14 +148,9 @@ static inline struct media_devnode *media_devnode_data(struct file *filp)
  *	false otherwise.
  *
  * @devnode: pointer to struct &media_devnode.
- *
- * Note: If mdev is NULL, it also returns false.
  */
 static inline int media_devnode_is_registered(struct media_devnode *devnode)
 {
-	if (!devnode)
-		return false;
-
 	return test_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 }
 
-- 
2.1.4

