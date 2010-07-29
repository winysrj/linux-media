Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36474 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883Ab0G2QHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 12:07:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v3 01/10] media: Media device node support
Date: Thu, 29 Jul 2010 18:06:34 +0200
Message-Id: <1280419616-7658-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media_devnode structure provides support for registering and
unregistering character devices using a dynamic major number. Reference
counting is handled internally, making device drivers easier to write
without having to solve the open/disconnect race condition issue over
and over again.

The code is based on video/v4l2-dev.c.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/Makefile        |    8 +-
 drivers/media/media-devnode.c |  326 +++++++++++++++++++++++++++++++++++++++++
 include/media/media-devnode.h |   84 +++++++++++
 3 files changed, 416 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/media-devnode.c
 create mode 100644 include/media/media-devnode.h

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 499b081..c1b5938 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -2,7 +2,11 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
+media-objs	:= media-devnode.o
+
+obj-$(CONFIG_MEDIA_SUPPORT)	+= media.o
+
 obj-y += common/ IR/ video/
 
-obj-$(CONFIG_VIDEO_DEV) += radio/
-obj-$(CONFIG_DVB_CORE)  += dvb/
+obj-$(CONFIG_VIDEO_DEV)		+= radio/
+obj-$(CONFIG_DVB_CORE)		+= dvb/
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
new file mode 100644
index 0000000..6f5558c
--- /dev/null
+++ b/drivers/media/media-devnode.c
@@ -0,0 +1,326 @@
+/*
+ * Media device node
+ *
+ * Generic media device node infrastructure to register and unregister
+ * character devices using a dynamic major number and proper reference
+ * counting.
+ *
+ * Copyright 2010 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * Based on drivers/media/video/v4l2_dev.c code authored by
+ *
+ *	Mauro Carvalho Chehab <mchehab@infradead.org> (version 2)
+ *	Alan Cox, <alan@lxorguk.ukuu.org.uk> (version 1)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kmod.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/smp_lock.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <asm/system.h>
+
+#include <media/media-devnode.h>
+
+#define MEDIA_NUM_DEVICES	256
+#define MEDIA_NAME		"media"
+
+static dev_t media_dev_t;
+
+/*
+ *	sysfs stuff
+ */
+
+static ssize_t show_name(struct device *cd,
+			 struct device_attribute *attr, char *buf)
+{
+	struct media_devnode *mdev = to_media_devnode(cd);
+
+	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->name), mdev->name);
+}
+
+static struct device_attribute media_devnode_attrs[] = {
+	__ATTR(name, S_IRUGO, show_name, NULL),
+	__ATTR_NULL
+};
+
+/*
+ *	Active devices
+ */
+static DEFINE_MUTEX(media_devnode_lock);
+static DECLARE_BITMAP(media_devnode_nums, MEDIA_NUM_DEVICES);
+
+/* Called when the last user of the media device exits. */
+static void media_devnode_release(struct device *cd)
+{
+	struct media_devnode *mdev = to_media_devnode(cd);
+
+	mutex_lock(&media_devnode_lock);
+
+	/* Delete the cdev on this minor as well */
+	cdev_del(&mdev->cdev);
+
+	/* Mark device node number as free */
+	clear_bit(mdev->minor, media_devnode_nums);
+
+	mutex_unlock(&media_devnode_lock);
+
+	/* Release media_devnode and perform other cleanups as needed. */
+	if (mdev->release)
+		mdev->release(mdev);
+}
+
+static struct class media_class = {
+	.name = MEDIA_NAME,
+	.dev_attrs = media_devnode_attrs,
+};
+
+static ssize_t media_read(struct file *filp, char __user *buf,
+		size_t sz, loff_t *off)
+{
+	struct media_devnode *mdev = media_devnode_data(filp);
+
+	if (!mdev->fops->read)
+		return -EINVAL;
+	if (!media_devnode_is_registered(mdev))
+		return -EIO;
+	return mdev->fops->read(filp, buf, sz, off);
+}
+
+static ssize_t media_write(struct file *filp, const char __user *buf,
+		size_t sz, loff_t *off)
+{
+	struct media_devnode *mdev = media_devnode_data(filp);
+
+	if (!mdev->fops->write)
+		return -EINVAL;
+	if (!media_devnode_is_registered(mdev))
+		return -EIO;
+	return mdev->fops->write(filp, buf, sz, off);
+}
+
+static unsigned int media_poll(struct file *filp,
+			       struct poll_table_struct *poll)
+{
+	struct media_devnode *mdev = media_devnode_data(filp);
+
+	if (!mdev->fops->poll || !media_devnode_is_registered(mdev))
+		return DEFAULT_POLLMASK;
+	return mdev->fops->poll(filp, poll);
+}
+
+static long media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct media_devnode *mdev = media_devnode_data(filp);
+
+	if (!mdev->fops->unlocked_ioctl)
+		return -ENOTTY;
+
+	if (!media_devnode_is_registered(mdev))
+		return -EIO;
+
+	return mdev->fops->unlocked_ioctl(filp, cmd, arg);
+}
+
+/* Override for the open function */
+static int media_open(struct inode *inode, struct file *filp)
+{
+	struct media_devnode *mdev;
+	int ret;
+
+	/* Check if the media device is available. This needs to be done with
+	 * the media_devnode_lock held to prevent an open/unregister race:
+	 * without the lock, the device could be unregistered and freed between
+	 * the media_devnode_is_registered() and get_device() calls, leading to
+	 * a crash.
+	 */
+	mutex_lock(&media_devnode_lock);
+	mdev = container_of(inode->i_cdev, struct media_devnode, cdev);
+	/* return ENODEV if the media device has been removed
+	   already or if it is not registered anymore. */
+	if (!media_devnode_is_registered(mdev)) {
+		mutex_unlock(&media_devnode_lock);
+		return -ENODEV;
+	}
+	/* and increase the device refcount */
+	get_device(&mdev->dev);
+	mutex_unlock(&media_devnode_lock);
+	if (mdev->fops->open) {
+		ret = mdev->fops->open(filp);
+		if (ret) {
+			put_device(&mdev->dev);
+			return ret;
+		}
+	}
+
+	filp->private_data = mdev;
+	return 0;
+}
+
+/* Override for the release function */
+static int media_release(struct inode *inode, struct file *filp)
+{
+	struct media_devnode *mdev = media_devnode_data(filp);
+	int ret = 0;
+
+	if (mdev->fops->release)
+		mdev->fops->release(filp);
+
+	/* decrease the refcount unconditionally since the release()
+	   return value is ignored. */
+	put_device(&mdev->dev);
+	filp->private_data = NULL;
+	return ret;
+}
+
+static const struct file_operations media_devnode_fops = {
+	.owner = THIS_MODULE,
+	.read = media_read,
+	.write = media_write,
+	.open = media_open,
+	.unlocked_ioctl = media_ioctl,
+	.release = media_release,
+	.poll = media_poll,
+	.llseek = no_llseek,
+};
+
+/**
+ * media_devnode_register - register a media device node
+ * @mdev: media device node structure we want to register
+ *
+ * The registration code assigns minor numbers and registers the new device node
+ * with the kernel. An error is returned if no free minor number can be found,
+ * or if the registration of the device node fails.
+ *
+ * Zero is returned on success.
+ *
+ * Note that if the media_devnode_register call fails, the release() callback of
+ * the media_devnode structure is *not* called, so the caller is responsible for
+ * freeing any data.
+ */
+int __must_check media_devnode_register(struct media_devnode *mdev)
+{
+	int minor;
+	int ret;
+
+	/* Part 1: Find a free minor number */
+	mutex_lock(&media_devnode_lock);
+	minor = find_next_zero_bit(media_devnode_nums, 0, MEDIA_NUM_DEVICES);
+	if (minor == MEDIA_NUM_DEVICES) {
+		mutex_unlock(&media_devnode_lock);
+		printk(KERN_ERR "could not get a free minor\n");
+		return -ENFILE;
+	}
+
+	set_bit(mdev->minor, media_devnode_nums);
+	mutex_unlock(&media_devnode_lock);
+
+	mdev->minor = minor;
+
+	/* Part 2: Initialize and register the character device */
+	cdev_init(&mdev->cdev, &media_devnode_fops);
+	mdev->cdev.owner = mdev->fops->owner;
+
+	ret = cdev_add(&mdev->cdev, MKDEV(MAJOR(media_dev_t), mdev->minor), 1);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: cdev_add failed\n", __func__);
+		goto error;
+	}
+
+	/* Part 3: Register the media device */
+	mdev->dev.class = &media_class;
+	mdev->dev.devt = MKDEV(MAJOR(media_dev_t), mdev->minor);
+	mdev->dev.release = media_devnode_release;
+	if (mdev->parent)
+		mdev->dev.parent = mdev->parent;
+	dev_set_name(&mdev->dev, "media%d", mdev->minor);
+	ret = device_register(&mdev->dev);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: device_register failed\n", __func__);
+		goto error;
+	}
+
+	/* Part 4: Activate this minor. The char device can now be used. */
+	set_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+
+	return 0;
+
+error:
+	cdev_del(&mdev->cdev);
+	mutex_lock(&media_devnode_lock);
+	clear_bit(mdev->minor, media_devnode_nums);
+	mutex_unlock(&media_devnode_lock);
+	return ret;
+}
+
+/**
+ * media_devnode_unregister - unregister a media device node
+ * @mdev: the device node to unregister
+ *
+ * This unregisters the passed device. Future open calls will be met with
+ * errors.
+ *
+ * This function can safely be called if the device node has never been
+ * registered or has already been unregistered.
+ */
+void media_devnode_unregister(struct media_devnode *mdev)
+{
+	/* Check if mdev was ever registered at all */
+	if (!media_devnode_is_registered(mdev))
+		return;
+
+	mutex_lock(&media_devnode_lock);
+	clear_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	mutex_unlock(&media_devnode_lock);
+	device_unregister(&mdev->dev);
+}
+
+/*
+ *	Initialise media for linux
+ */
+static int __init media_devnode_init(void)
+{
+	int ret;
+
+	printk(KERN_INFO "Linux media interface: v0.10\n");
+	ret = alloc_chrdev_region(&media_dev_t, 0, MEDIA_NUM_DEVICES,
+				  MEDIA_NAME);
+	if (ret < 0) {
+		printk(KERN_WARNING "media: unable to allcoate major\n");
+		return ret;
+	}
+
+	ret = class_register(&media_class);
+	if (ret < 0) {
+		unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
+		printk(KERN_WARNING "media: class_register failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void __exit media_devnode_exit(void)
+{
+	class_unregister(&media_class);
+	unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
+}
+
+module_init(media_devnode_init)
+module_exit(media_devnode_exit)
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("Device node registration for media drivers");
+MODULE_LICENSE("GPL");
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
new file mode 100644
index 0000000..ade03b7
--- /dev/null
+++ b/include/media/media-devnode.h
@@ -0,0 +1,84 @@
+/*
+ * Media device node handling
+ *
+ * Copyright (C) 2010  Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * Common functions for media-related drivers to register and unregister media
+ * device nodes.
+ */
+#ifndef _MEDIA_DEVNODE_H
+#define _MEDIA_DEVNODE_H
+
+#include <linux/poll.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
+
+/*
+ * Flag to mark the media_devnode struct as registered. Drivers must not touch
+ * this flag directly, it will be set and cleared by media_devnode_register and
+ * media_devnode_unregister.
+ */
+#define MEDIA_FLAG_REGISTERED	0
+
+struct media_file_operations {
+	struct module *owner;
+	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
+	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
+	unsigned int (*poll) (struct file *, struct poll_table_struct *);
+	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
+	int (*open) (struct file *);
+	int (*release) (struct file *);
+};
+
+/**
+ * struct media_devnode - Media device node
+ * @parent:	parent device
+ * @name:	media device node name
+ * @minor:	device node minor number
+ * @flags:	flags, combination of the MEDIA_FLAG_* constants
+ *
+ * This structure represents a media-related device node.
+ *
+ * The @parent is a physical device. It must be set by core or device drivers
+ * before registering the node.
+ *
+ * @name is a descriptive name exported through sysfs. It doesn't have to be
+ * unique.
+ */
+struct media_devnode {
+	/* device ops */
+	const struct media_file_operations *fops;
+
+	/* sysfs */
+	struct device dev;		/* media device */
+	struct cdev cdev;		/* character device */
+	struct device *parent;		/* device parent */
+
+	/* device info */
+	char name[32];
+
+	int minor;
+	unsigned long flags;		/* Use bitops to access flags */
+
+	/* callbacks */
+	void (*release)(struct media_devnode *mdev);
+};
+
+/* dev to media_devnode */
+#define to_media_devnode(cd) container_of(cd, struct media_devnode, dev)
+
+int __must_check media_devnode_register(struct media_devnode *mdev);
+void media_devnode_unregister(struct media_devnode *mdev);
+
+static inline struct media_devnode *media_devnode_data(struct file *filp)
+{
+	return filp->private_data;
+}
+
+static inline int media_devnode_is_registered(struct media_devnode *mdev)
+{
+	return test_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+}
+
+#endif /* _MEDIA_DEVNODE_H */
-- 
1.7.1

