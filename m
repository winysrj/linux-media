Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbcCWT1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 15:27:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/4] [media] media-devnode: fix namespace mess
Date: Wed, 23 Mar 2016 16:27:44 -0300
Message-Id: <6762d811bcc02bf1490ef286f20499979a5f91b2.1458760750.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1458760750.git.mchehab@osg.samsung.com>
References: <cover.1458760750.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1458760750.git.mchehab@osg.samsung.com>
References: <cover.1458760750.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Along all media controller code, "mdev" is used to represent
a pointer to struct media_device, and "devnode" for a pointer
to struct media_devnode.

However, inside media-devnode.[ch], "mdev" is used to represent
a pointer to struct media_devnode.

This is very confusing and may lead to development errors.

So, let's change all occurrences at media-devnode.[ch] to
also use "devnode" for such pointers.

This patch doesn't make any functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-devnode.c | 110 +++++++++++++++++++++---------------------
 include/media/media-devnode.h |  16 +++---
 2 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 64a4b1ef3dcd..ae2bc0b7a368 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -59,21 +59,21 @@ static DECLARE_BITMAP(media_devnode_nums, MEDIA_NUM_DEVICES);
 /* Called when the last user of the media device exits. */
 static void media_devnode_release(struct device *cd)
 {
-	struct media_devnode *mdev = to_media_devnode(cd);
+	struct media_devnode *devnode = to_media_devnode(cd);
 
 	mutex_lock(&media_devnode_lock);
 
 	/* Delete the cdev on this minor as well */
-	cdev_del(&mdev->cdev);
+	cdev_del(&devnode->cdev);
 
 	/* Mark device node number as free */
-	clear_bit(mdev->minor, media_devnode_nums);
+	clear_bit(devnode->minor, media_devnode_nums);
 
 	mutex_unlock(&media_devnode_lock);
 
 	/* Release media_devnode and perform other cleanups as needed. */
-	if (mdev->release)
-		mdev->release(mdev);
+	if (devnode->release)
+		devnode->release(devnode);
 }
 
 static struct bus_type media_bus_type = {
@@ -83,37 +83,37 @@ static struct bus_type media_bus_type = {
 static ssize_t media_read(struct file *filp, char __user *buf,
 		size_t sz, loff_t *off)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	if (!mdev->fops->read)
+	if (!devnode->fops->read)
 		return -EINVAL;
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return -EIO;
-	return mdev->fops->read(filp, buf, sz, off);
+	return devnode->fops->read(filp, buf, sz, off);
 }
 
 static ssize_t media_write(struct file *filp, const char __user *buf,
 		size_t sz, loff_t *off)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	if (!mdev->fops->write)
+	if (!devnode->fops->write)
 		return -EINVAL;
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return -EIO;
-	return mdev->fops->write(filp, buf, sz, off);
+	return devnode->fops->write(filp, buf, sz, off);
 }
 
 static unsigned int media_poll(struct file *filp,
 			       struct poll_table_struct *poll)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return POLLERR | POLLHUP;
-	if (!mdev->fops->poll)
+	if (!devnode->fops->poll)
 		return DEFAULT_POLLMASK;
-	return mdev->fops->poll(filp, poll);
+	return devnode->fops->poll(filp, poll);
 }
 
 static long
@@ -121,12 +121,12 @@ __media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg,
 	      long (*ioctl_func)(struct file *filp, unsigned int cmd,
 				 unsigned long arg))
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
 	if (!ioctl_func)
 		return -ENOTTY;
 
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return -EIO;
 
 	return ioctl_func(filp, cmd, arg);
@@ -134,9 +134,9 @@ __media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg,
 
 static long media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	return __media_ioctl(filp, cmd, arg, mdev->fops->ioctl);
+	return __media_ioctl(filp, cmd, arg, devnode->fops->ioctl);
 }
 
 #ifdef CONFIG_COMPAT
@@ -144,9 +144,9 @@ static long media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 static long media_compat_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	return __media_ioctl(filp, cmd, arg, mdev->fops->compat_ioctl);
+	return __media_ioctl(filp, cmd, arg, devnode->fops->compat_ioctl);
 }
 
 #endif /* CONFIG_COMPAT */
@@ -154,7 +154,7 @@ static long media_compat_ioctl(struct file *filp, unsigned int cmd,
 /* Override for the open function */
 static int media_open(struct inode *inode, struct file *filp)
 {
-	struct media_devnode *mdev;
+	struct media_devnode *devnode;
 	int ret;
 
 	/* Check if the media device is available. This needs to be done with
@@ -164,23 +164,23 @@ static int media_open(struct inode *inode, struct file *filp)
 	 * a crash.
 	 */
 	mutex_lock(&media_devnode_lock);
-	mdev = container_of(inode->i_cdev, struct media_devnode, cdev);
+	devnode = container_of(inode->i_cdev, struct media_devnode, cdev);
 	/* return ENXIO if the media device has been removed
 	   already or if it is not registered anymore. */
-	if (!media_devnode_is_registered(mdev)) {
+	if (!media_devnode_is_registered(devnode)) {
 		mutex_unlock(&media_devnode_lock);
 		return -ENXIO;
 	}
 	/* and increase the device refcount */
-	get_device(&mdev->dev);
+	get_device(&devnode->dev);
 	mutex_unlock(&media_devnode_lock);
 
-	filp->private_data = mdev;
+	filp->private_data = devnode;
 
-	if (mdev->fops->open) {
-		ret = mdev->fops->open(filp);
+	if (devnode->fops->open) {
+		ret = devnode->fops->open(filp);
 		if (ret) {
-			put_device(&mdev->dev);
+			put_device(&devnode->dev);
 			filp->private_data = NULL;
 			return ret;
 		}
@@ -192,14 +192,14 @@ static int media_open(struct inode *inode, struct file *filp)
 /* Override for the release function */
 static int media_release(struct inode *inode, struct file *filp)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	if (mdev->fops->release)
-		mdev->fops->release(filp);
+	if (devnode->fops->release)
+		devnode->fops->release(filp);
 
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
-	put_device(&mdev->dev);
+	put_device(&devnode->dev);
 	filp->private_data = NULL;
 	return 0;
 }
@@ -218,7 +218,7 @@ static const struct file_operations media_devnode_fops = {
 	.llseek = no_llseek,
 };
 
-int __must_check media_devnode_register(struct media_devnode *mdev,
+int __must_check media_devnode_register(struct media_devnode *devnode,
 					struct module *owner)
 {
 	int minor;
@@ -236,55 +236,55 @@ int __must_check media_devnode_register(struct media_devnode *mdev,
 	set_bit(minor, media_devnode_nums);
 	mutex_unlock(&media_devnode_lock);
 
-	mdev->minor = minor;
+	devnode->minor = minor;
 
 	/* Part 2: Initialize and register the character device */
-	cdev_init(&mdev->cdev, &media_devnode_fops);
-	mdev->cdev.owner = owner;
+	cdev_init(&devnode->cdev, &media_devnode_fops);
+	devnode->cdev.owner = owner;
 
-	ret = cdev_add(&mdev->cdev, MKDEV(MAJOR(media_dev_t), mdev->minor), 1);
+	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
 	if (ret < 0) {
 		pr_err("%s: cdev_add failed\n", __func__);
 		goto error;
 	}
 
 	/* Part 3: Register the media device */
-	mdev->dev.bus = &media_bus_type;
-	mdev->dev.devt = MKDEV(MAJOR(media_dev_t), mdev->minor);
-	mdev->dev.release = media_devnode_release;
-	if (mdev->parent)
-		mdev->dev.parent = mdev->parent;
-	dev_set_name(&mdev->dev, "media%d", mdev->minor);
-	ret = device_register(&mdev->dev);
+	devnode->dev.bus = &media_bus_type;
+	devnode->dev.devt = MKDEV(MAJOR(media_dev_t), devnode->minor);
+	devnode->dev.release = media_devnode_release;
+	if (devnode->parent)
+		devnode->dev.parent = devnode->parent;
+	dev_set_name(&devnode->dev, "media%d", devnode->minor);
+	ret = device_register(&devnode->dev);
 	if (ret < 0) {
 		pr_err("%s: device_register failed\n", __func__);
 		goto error;
 	}
 
 	/* Part 4: Activate this minor. The char device can now be used. */
-	set_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	set_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 
 	return 0;
 
 error:
 	mutex_lock(&media_devnode_lock);
-	cdev_del(&mdev->cdev);
-	clear_bit(mdev->minor, media_devnode_nums);
+	cdev_del(&devnode->cdev);
+	clear_bit(devnode->minor, media_devnode_nums);
 	mutex_unlock(&media_devnode_lock);
 
 	return ret;
 }
 
-void media_devnode_unregister(struct media_devnode *mdev)
+void media_devnode_unregister(struct media_devnode *devnode)
 {
-	/* Check if mdev was ever registered at all */
-	if (!media_devnode_is_registered(mdev))
+	/* Check if devnode was ever registered at all */
+	if (!media_devnode_is_registered(devnode))
 		return;
 
 	mutex_lock(&media_devnode_lock);
-	clear_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 	mutex_unlock(&media_devnode_lock);
-	device_unregister(&mdev->dev);
+	device_unregister(&devnode->dev);
 }
 
 /*
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index fe42f08e72bd..e1d5af077adb 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -94,7 +94,7 @@ struct media_devnode {
 	unsigned long flags;		/* Use bitops to access flags */
 
 	/* callbacks */
-	void (*release)(struct media_devnode *mdev);
+	void (*release)(struct media_devnode *devnode);
 };
 
 /* dev to media_devnode */
@@ -103,7 +103,7 @@ struct media_devnode {
 /**
  * media_devnode_register - register a media device node
  *
- * @mdev: media device node structure we want to register
+ * @devnode: media device node structure we want to register
  * @owner: should be filled with %THIS_MODULE
  *
  * The registration code assigns minor numbers and registers the new device node
@@ -116,12 +116,12 @@ struct media_devnode {
  * the media_devnode structure is *not* called, so the caller is responsible for
  * freeing any data.
  */
-int __must_check media_devnode_register(struct media_devnode *mdev,
+int __must_check media_devnode_register(struct media_devnode *devnode,
 					struct module *owner);
 
 /**
  * media_devnode_unregister - unregister a media device node
- * @mdev: the device node to unregister
+ * @devnode: the device node to unregister
  *
  * This unregisters the passed device. Future open calls will be met with
  * errors.
@@ -129,7 +129,7 @@ int __must_check media_devnode_register(struct media_devnode *mdev,
  * This function can safely be called if the device node has never been
  * registered or has already been unregistered.
  */
-void media_devnode_unregister(struct media_devnode *mdev);
+void media_devnode_unregister(struct media_devnode *devnode);
 
 /**
  * media_devnode_data - returns a pointer to the &media_devnode
@@ -145,11 +145,11 @@ static inline struct media_devnode *media_devnode_data(struct file *filp)
  * media_devnode_is_registered - returns true if &media_devnode is registered;
  *	false otherwise.
  *
- * @mdev: pointer to struct &media_devnode.
+ * @devnode: pointer to struct &media_devnode.
  */
-static inline int media_devnode_is_registered(struct media_devnode *mdev)
+static inline int media_devnode_is_registered(struct media_devnode *devnode)
 {
-	return test_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	return test_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 }
 
 #endif /* _MEDIA_DEVNODE_H */
-- 
2.5.5


