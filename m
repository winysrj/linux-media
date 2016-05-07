Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbcEGPO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 May 2016 11:14:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 2/2] [media] media-device: dynamically allocate struct media_devnode
Date: Sat,  7 May 2016 12:12:09 -0300
Message-Id: <83247b8a21c292a08949b3fe619cc56dc4709896.1462633500.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1462633500.git.mchehab@osg.samsung.com>
References: <cover.1462633500.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1462633500.git.mchehab@osg.samsung.com>
References: <cover.1462633500.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct media_devnode is currently embedded at struct media_device.

While this works fine during normal usage, it leads to a race
condition during devnode unregister. the problem is that drivers
assume that, after calling media_device_unregister(), the struct
that contains media_device can be freed. This is not true, as it
can't be freed until userspace closes all opened /dev/media devnodes.

In other words, if the media devnode is still open, and media_device
gets freed, any call to an ioctl will make the core to try to access
struct media_device, with will cause an use-after-free and even GPF.

Fix this by dynamically allocating the struct media_devnode and only
freeing it when it is safe.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c           | 44 +++++++++++++++++++++++-----------
 drivers/media/media-devnode.c          |  7 +++++-
 drivers/media/usb/au0828/au0828-core.c |  4 ++--
 drivers/media/usb/uvc/uvc_driver.c     |  2 +-
 include/media/media-device.h           |  5 +---
 include/media/media-devnode.h          | 13 +++++++++-
 6 files changed, 52 insertions(+), 23 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 47a99af5525e..8c520e064c34 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -423,7 +423,7 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
-	struct media_device *dev = to_media_device(devnode);
+	struct media_device *dev = devnode->media_dev;
 	long ret;
 
 	mutex_lock(&dev->graph_mutex);
@@ -495,7 +495,7 @@ static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
 				      unsigned long arg)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
-	struct media_device *dev = to_media_device(devnode);
+	struct media_device *dev = devnode->media_dev;
 	long ret;
 
 	switch (cmd) {
@@ -531,7 +531,8 @@ static const struct media_file_operations media_device_fops = {
 static ssize_t show_model(struct device *cd,
 			  struct device_attribute *attr, char *buf)
 {
-	struct media_device *mdev = to_media_device(to_media_devnode(cd));
+	struct media_devnode *devnode = to_media_devnode(cd);
+	struct media_device *mdev = devnode->media_dev;
 
 	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->model), mdev->model);
 }
@@ -704,23 +705,34 @@ EXPORT_SYMBOL_GPL(media_device_cleanup);
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner)
 {
+	struct media_devnode *devnode;
 	int ret;
 
+	devnode = kzalloc(sizeof(*devnode), GFP_KERNEL);
+	if (!devnode)
+		return -ENOMEM;
+
 	/* Register the device node. */
-	mdev->devnode.fops = &media_device_fops;
-	mdev->devnode.parent = mdev->dev;
-	mdev->devnode.release = media_device_release;
+	mdev->devnode = devnode;
+	devnode->fops = &media_device_fops;
+	devnode->parent = mdev->dev;
+	devnode->release = media_device_release;
 
 	/* Set version 0 to indicate user-space that the graph is static */
 	mdev->topology_version = 0;
 
-	ret = media_devnode_register(&mdev->devnode, owner);
-	if (ret < 0)
+	ret = media_devnode_register(mdev, devnode, owner);
+	if (ret < 0) {
+		mdev->devnode = NULL;
+		kfree(devnode);
 		return ret;
+	}
 
-	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
+	ret = device_create_file(&devnode->dev, &dev_attr_model);
 	if (ret < 0) {
-		media_devnode_unregister(&mdev->devnode);
+		mdev->devnode = NULL;
+		media_devnode_unregister(devnode);
+		kfree(devnode);
 		return ret;
 	}
 
@@ -771,7 +783,7 @@ void media_device_unregister(struct media_device *mdev)
 	mutex_lock(&mdev->graph_mutex);
 
 	/* Check if mdev was ever registered at all */
-	if (!media_devnode_is_registered(&mdev->devnode)) {
+	if (!media_devnode_is_registered(mdev->devnode)) {
 		mutex_unlock(&mdev->graph_mutex);
 		return;
 	}
@@ -794,9 +806,13 @@ void media_device_unregister(struct media_device *mdev)
 
 	mutex_unlock(&mdev->graph_mutex);
 
-	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
-	dev_dbg(mdev->dev, "Media device unregistering\n");
-	media_devnode_unregister(&mdev->devnode);
+	dev_dbg(mdev->dev, "Media device unregistered\n");
+
+	/* Check if mdev devnode was registered */
+	if (media_devnode_is_registered(mdev->devnode)) {
+		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
+		media_devnode_unregister(mdev->devnode);
+	}
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 7481c9610945..ecdc02d6ed83 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -44,6 +44,7 @@
 #include <linux/uaccess.h>
 
 #include <media/media-devnode.h>
+#include <media/media-device.h>
 
 #define MEDIA_NUM_DEVICES	256
 #define MEDIA_NAME		"media"
@@ -74,6 +75,8 @@ static void media_devnode_release(struct device *cd)
 	/* Release media_devnode and perform other cleanups as needed. */
 	if (devnode->release)
 		devnode->release(devnode);
+
+	kfree(devnode);
 }
 
 static struct bus_type media_bus_type = {
@@ -219,7 +222,8 @@ static const struct file_operations media_devnode_fops = {
 	.llseek = no_llseek,
 };
 
-int __must_check media_devnode_register(struct media_devnode *devnode,
+int __must_check media_devnode_register(struct media_device *mdev,
+					struct media_devnode *devnode,
 					struct module *owner)
 {
 	int minor;
@@ -238,6 +242,7 @@ int __must_check media_devnode_register(struct media_devnode *devnode,
 	mutex_unlock(&media_devnode_lock);
 
 	devnode->minor = minor;
+	devnode->media_dev = mdev;
 
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &media_devnode_fops);
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 321ea5cf1329..bf53553d2624 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -142,7 +142,7 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity_notify *notify, *nextp;
 
-	if (!mdev || !media_devnode_is_registered(&mdev->devnode))
+	if (!mdev || !media_devnode_is_registered(mdev->devnode))
 		return;
 
 	/* Remove au0828 entity_notify callbacks */
@@ -482,7 +482,7 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 	if (!dev->media_dev)
 		return 0;
 
-	if (!media_devnode_is_registered(&dev->media_dev->devnode)) {
+	if (!media_devnode_is_registered(dev->media_dev->devnode)) {
 
 		/* register media device */
 		ret = media_device_register(dev->media_dev);
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 451e84e962e2..302e284a95eb 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1674,7 +1674,7 @@ static void uvc_delete(struct uvc_device *dev)
 	if (dev->vdev.dev)
 		v4l2_device_unregister(&dev->vdev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (media_devnode_is_registered(&dev->mdev.devnode))
+	if (media_devnode_is_registered(dev->mdev.devnode))
 		media_device_unregister(&dev->mdev);
 	media_device_cleanup(&dev->mdev);
 #endif
diff --git a/include/media/media-device.h b/include/media/media-device.h
index a9b33c47310d..f743ae2210ee 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -347,7 +347,7 @@ struct media_entity_notify {
 struct media_device {
 	/* dev->driver_data points to this struct. */
 	struct device *dev;
-	struct media_devnode devnode;
+	struct media_devnode *devnode;
 
 	char model[32];
 	char driver_name[32];
@@ -393,9 +393,6 @@ struct usb_device;
 #define MEDIA_DEV_NOTIFY_PRE_LINK_CH	0
 #define MEDIA_DEV_NOTIFY_POST_LINK_CH	1
 
-/* media_devnode to media_device */
-#define to_media_device(node) container_of(node, struct media_device, devnode)
-
 /**
  * media_entity_enum_init - Initialise an entity enumeration
  *
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index e1d5af077adb..5bb3b0e86d73 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -33,6 +33,8 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 
+struct media_device;
+
 /*
  * Flag to mark the media_devnode struct as registered. Drivers must not touch
  * this flag directly, it will be set and cleared by media_devnode_register and
@@ -81,6 +83,8 @@ struct media_file_operations {
  * before registering the node.
  */
 struct media_devnode {
+	struct media_device *media_dev;
+
 	/* device ops */
 	const struct media_file_operations *fops;
 
@@ -103,6 +107,7 @@ struct media_devnode {
 /**
  * media_devnode_register - register a media device node
  *
+ * @media_dev: struct media_device we want to register a device node
  * @devnode: media device node structure we want to register
  * @owner: should be filled with %THIS_MODULE
  *
@@ -116,7 +121,8 @@ struct media_devnode {
  * the media_devnode structure is *not* called, so the caller is responsible for
  * freeing any data.
  */
-int __must_check media_devnode_register(struct media_devnode *devnode,
+int __must_check media_devnode_register(struct media_device *mdev,
+					struct media_devnode *devnode,
 					struct module *owner);
 
 /**
@@ -146,9 +152,14 @@ static inline struct media_devnode *media_devnode_data(struct file *filp)
  *	false otherwise.
  *
  * @devnode: pointer to struct &media_devnode.
+ *
+ * Note: If mdev is NULL, it also returns false.
  */
 static inline int media_devnode_is_registered(struct media_devnode *devnode)
 {
+	if (!devnode)
+		return false;
+
 	return test_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 }
 
-- 
2.5.5


