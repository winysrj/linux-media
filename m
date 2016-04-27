Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:36596 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbcD0DIg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2016 23:08:36 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, chehabrafael@gmail.com, sakari.ailus@iki.fi
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix media_ioctl use-after-free when driver unbinds
Date: Tue, 26 Apr 2016 21:08:32 -0600
Message-Id: <1461726512-9828-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When driver unbind is run while media_ioctl is in progress, media_ioctl()
fails with use-after-free. This first use-after-free is followed by more
user-after-free errors in media_release(), kobject_put(), and cdev_put()
as driver unbind continues. This problem is found on uvcvideo, em28xx, and
au0828 drivers and fix has been tested on all three.

This fix allocates media devnode and manages its lifetime separate from the
struct media_device. Adds kobject to the media_devnode structure and this
kobject is set as the cdev parent kobject. This allows cdev_add() to hold
a reference to it and release the reference in cdev_del() ensuring that the
media_devnode is not deallocated as long as the application has the cdev
open.

The first error is below:

[  472.424302] ==================================================================
[  472.424333] BUG: KASAN: use-after-free in media_ioctl+0xf0/0x130 [media] at addr ffff880027b72330
[  472.424341] Read of size 8 by task media_device_te/1794
[  472.424348] =============================================================================
[  472.424356] BUG kmalloc-4096 (Not tainted): kasan: bad access detected
[  472.424361] -----------------------------------------------------------------------------
[  472.431973] CPU: 1 PID: 1794 Comm: media_device_te Tainted: G    B           4.6.0-rc5 #2
[  472.431988] Hardware name: Hewlett-Packard HP ProBook 6475b/180F, BIOS 68TTU Ver. F.04 08/03/2012
[  472.431996]  ffffea00009edc00 ffff88009ddffc78 ffffffff81aecac3 ffff8801fa403200
[  472.432016]  ffff880027b72260 ffff88009ddffca8 ffffffff815359b2 ffff8801fa403200
[  472.432040]  ffffea00009edc00 ffff880027b72260 ffffffffa0c9cc60 ffff88009ddffcd0
[  472.432059] Call Trace:
[  472.432079]  [<ffffffff81aecac3>] dump_stack+0x67/0x94
[  472.432092]  [<ffffffff815359b2>] print_trailer+0x112/0x1a0
[  472.432108]  [<ffffffff8153b5e4>] object_err+0x34/0x40
[  472.432125]  [<ffffffff8153d9d4>] kasan_report_error+0x224/0x530
[  472.432148]  [<ffffffffa0c934c0>] ? __media_device_get_topology+0x1850/0x1850 [media]
[  472.432167]  [<ffffffff8153de13>] __asan_report_load8_noabort+0x43/0x50
[  472.432190]  [<ffffffffa0c94f60>] ? media_ioctl+0x120/0x130 [media]
[  472.432209]  [<ffffffffa0c94f60>] media_ioctl+0x120/0x130 [media]
[  472.432229]  [<ffffffff815a9e44>] do_vfs_ioctl+0x184/0xe80
[  472.432243]  [<ffffffff815a9cc0>] ? ioctl_preallocate+0x1a0/0x1a0
[  472.432256]  [<ffffffff8127b1f0>] ? __hrtimer_init+0x170/0x170
[  472.432272]  [<ffffffff82846b01>] ? do_nanosleep+0x161/0x480
[  472.432298]  [<ffffffff811451d0>] ? sigprocmask+0x290/0x290
[  472.432323]  [<ffffffff815c7209>] ? __fget_light+0x139/0x200
[  472.432358]  [<ffffffff815aabb9>] SyS_ioctl+0x79/0x90
[  472.432381]  [<ffffffff82848aa5>] entry_SYSCALL_64_fastpath+0x18/0xa8

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c           | 32 ++++++++++++++++++++------------
 drivers/media/media-devnode.c          | 23 +++++++++++++++++++++++
 drivers/media/usb/au0828/au0828-core.c |  4 ++--
 drivers/media/usb/uvc/uvc_driver.c     |  2 +-
 include/media/media-device.h           |  7 ++-----
 include/media/media-devnode.h          |  8 +++++++-
 6 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6e43c95..78b0350 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -428,7 +428,7 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
-	struct media_device *dev = to_media_device(devnode);
+	struct media_device *dev = devnode->media_dev;
 	long ret;
 
 	switch (cmd) {
@@ -504,7 +504,7 @@ static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
 				      unsigned long arg)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
-	struct media_device *dev = to_media_device(devnode);
+	struct media_device *dev = devnode->media_dev;
 	long ret;
 
 	switch (cmd) {
@@ -546,7 +546,8 @@ static const struct media_file_operations media_device_fops = {
 static ssize_t show_model(struct device *cd,
 			  struct device_attribute *attr, char *buf)
 {
-	struct media_device *mdev = to_media_device(to_media_devnode(cd));
+	struct media_devnode *devnode = to_media_devnode(cd);
+	struct media_device *mdev = devnode->media_dev;
 
 	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->model), mdev->model);
 }
@@ -725,21 +726,26 @@ int __must_check __media_device_register(struct media_device *mdev,
 {
 	int ret;
 
+	mdev->devnode = kzalloc(sizeof(struct media_devnode), GFP_KERNEL);
+	if (!mdev->devnode)
+		return -ENOMEM;
+
 	/* Register the device node. */
-	mdev->devnode.fops = &media_device_fops;
-	mdev->devnode.parent = mdev->dev;
-	mdev->devnode.release = media_device_release;
+	mdev->devnode->fops = &media_device_fops;
+	mdev->devnode->parent = mdev->dev;
+	mdev->devnode->media_dev = mdev;
+	mdev->devnode->release = media_device_release;
 
 	/* Set version 0 to indicate user-space that the graph is static */
 	mdev->topology_version = 0;
 
-	ret = media_devnode_register(&mdev->devnode, owner);
+	ret = media_devnode_register(mdev->devnode, owner);
 	if (ret < 0)
 		return ret;
 
-	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
+	ret = device_create_file(&mdev->devnode->dev, &dev_attr_model);
 	if (ret < 0) {
-		media_devnode_unregister(&mdev->devnode);
+		media_devnode_unregister(mdev->devnode);
 		return ret;
 	}
 
@@ -790,7 +796,7 @@ void media_device_unregister(struct media_device *mdev)
 	spin_lock(&mdev->lock);
 
 	/* Check if mdev was ever registered at all */
-	if (!media_devnode_is_registered(&mdev->devnode)) {
+	if (!media_devnode_is_registered(mdev->devnode)) {
 		spin_unlock(&mdev->lock);
 		return;
 	}
@@ -813,8 +819,10 @@ void media_device_unregister(struct media_device *mdev)
 
 	spin_unlock(&mdev->lock);
 
-	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
-	media_devnode_unregister(&mdev->devnode);
+	device_remove_file(&mdev->devnode->dev, &dev_attr_model);
+	media_devnode_unregister(mdev->devnode);
+	/* kfree devnode is done via kobject_put() handler */
+	mdev->devnode = NULL;
 
 	dev_dbg(mdev->dev, "Media device unregistered\n");
 }
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 29409f4..9af9ba1 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -171,6 +171,9 @@ static int media_open(struct inode *inode, struct file *filp)
 		mutex_unlock(&media_devnode_lock);
 		return -ENXIO;
 	}
+
+	kobject_get(&mdev->kobj);
+
 	/* and increase the device refcount */
 	get_device(&mdev->dev);
 	mutex_unlock(&media_devnode_lock);
@@ -181,6 +184,7 @@ static int media_open(struct inode *inode, struct file *filp)
 		ret = mdev->fops->open(filp);
 		if (ret) {
 			put_device(&mdev->dev);
+			kobject_put(&mdev->kobj);
 			filp->private_data = NULL;
 			return ret;
 		}
@@ -200,6 +204,7 @@ static int media_release(struct inode *inode, struct file *filp)
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	put_device(&mdev->dev);
+	kobject_put(&mdev->kobj);
 	filp->private_data = NULL;
 	return 0;
 }
@@ -218,6 +223,19 @@ static const struct file_operations media_devnode_fops = {
 	.llseek = no_llseek,
 };
 
+static void media_devnode_free(struct kobject *kobj)
+{
+	struct media_devnode *devnode =
+			container_of(kobj, struct media_devnode, kobj);
+
+	kfree(devnode);
+	pr_info("%s: Media Devnode Deallocated\n", __func__);
+}
+
+static struct kobj_type media_devnode_ktype = {
+	.release = media_devnode_free,
+};
+
 int __must_check media_devnode_register(struct media_devnode *mdev,
 					struct module *owner)
 {
@@ -238,9 +256,12 @@ int __must_check media_devnode_register(struct media_devnode *mdev,
 
 	mdev->minor = minor;
 
+	kobject_init(&mdev->kobj, &media_devnode_ktype);
+
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&mdev->cdev, &media_devnode_fops);
 	mdev->cdev.owner = owner;
+	mdev->cdev.kobj.parent = &mdev->kobj;
 
 	ret = cdev_add(&mdev->cdev, MKDEV(MAJOR(media_dev_t), mdev->minor), 1);
 	if (ret < 0) {
@@ -269,6 +290,7 @@ int __must_check media_devnode_register(struct media_devnode *mdev,
 error:
 	cdev_del(&mdev->cdev);
 	clear_bit(mdev->minor, media_devnode_nums);
+	kobject_put(&mdev->kobj);
 	return ret;
 }
 
@@ -282,6 +304,7 @@ void media_devnode_unregister(struct media_devnode *mdev)
 	clear_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
 	mutex_unlock(&media_devnode_lock);
 	device_unregister(&mdev->dev);
+	kobject_put(&mdev->kobj);
 }
 
 /*
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index cc22b32..8af9344 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -136,7 +136,7 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev &&
-		media_devnode_is_registered(&dev->media_dev->devnode)) {
+		media_devnode_is_registered(dev->media_dev->devnode)) {
 		/* clear enable_source, disable_source */
 		dev->media_dev->source_priv = NULL;
 		dev->media_dev->enable_source = NULL;
@@ -468,7 +468,7 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 	if (!dev->media_dev)
 		return 0;
 
-	if (!media_devnode_is_registered(&dev->media_dev->devnode)) {
+	if (!media_devnode_is_registered(dev->media_dev->devnode)) {
 
 		/* register media device */
 		ret = media_device_register(dev->media_dev);
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 451e84e9..302e284 100644
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
index df74cfa..65394f3 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -283,7 +283,7 @@ struct media_entity_notify {
 /**
  * struct media_device - Media device
  * @dev:	Parent device
- * @devnode:	Media device node
+ * @devnode:	Media device node pointer
  * @driver_name: Optional device driver name. If not set, calls to
  *		%MEDIA_IOC_DEVICE_INFO will return dev->driver->name.
  *		This is needed for USB drivers for example, as otherwise
@@ -348,7 +348,7 @@ struct media_entity_notify {
 struct media_device {
 	/* dev->driver_data points to this struct. */
 	struct device *dev;
-	struct media_devnode devnode;
+	struct media_devnode *devnode;
 
 	char model[32];
 	char driver_name[32];
@@ -396,9 +396,6 @@ struct usb_device;
 #define MEDIA_DEV_NOTIFY_PRE_LINK_CH	0
 #define MEDIA_DEV_NOTIFY_POST_LINK_CH	1
 
-/* media_devnode to media_device */
-#define to_media_device(node) container_of(node, struct media_device, devnode)
-
 /**
  * media_entity_enum_init - Initialise an entity enumeration
  *
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index fe42f08..ba4bdaa 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -70,7 +70,9 @@ struct media_file_operations {
  * @fops:	pointer to struct &media_file_operations with media device ops
  * @dev:	struct device pointer for the media controller device
  * @cdev:	struct cdev pointer character device
+ * @kobj:	struct kobject
  * @parent:	parent device
+ * @media_dev:	media device
  * @minor:	device node minor number
  * @flags:	flags, combination of the MEDIA_FLAG_* constants
  * @release:	release callback called at the end of media_devnode_release()
@@ -87,7 +89,9 @@ struct media_devnode {
 	/* sysfs */
 	struct device dev;		/* media device */
 	struct cdev cdev;		/* character device */
+	struct kobject kobj;		/* set as cdev parent kobj */
 	struct device *parent;		/* device parent */
+	struct media_device *media_dev; /* media device for the devnode */
 
 	/* device info */
 	int minor;
@@ -149,7 +153,9 @@ static inline struct media_devnode *media_devnode_data(struct file *filp)
  */
 static inline int media_devnode_is_registered(struct media_devnode *mdev)
 {
-	return test_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	if (mdev)
+		return test_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	return false;
 }
 
 #endif /* _MEDIA_DEVNODE_H */
-- 
2.5.0

