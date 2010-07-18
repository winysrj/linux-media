Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1451 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab0GRKzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jul 2010 06:55:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH 01/10] media: Media device node support
Date: Sun, 18 Jul 2010 12:58:16 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279114219-27389-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279114219-27389-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007181258.16303.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 14 July 2010 15:30:10 Laurent Pinchart wrote:
> The media_devnode structure provides support for registering and
> unregistering character devices using a dynamic major number. Reference
> counting is handled internally, making device drivers easier to write
> without having to solve the open/disconnect race condition issue over
> and over again.
> 
> The code is copied mostly verbatim from video/v4l2-dev.c.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/Makefile        |    8 +-
>  drivers/media/media-devnode.c |  479 +++++++++++++++++++++++++++++++++++++++++
>  include/media/media-devnode.h |   97 +++++++++
>  3 files changed, 582 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/media/media-devnode.c
>  create mode 100644 include/media/media-devnode.h
> 
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index 499b081..c1b5938 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -2,7 +2,11 @@
>  # Makefile for the kernel multimedia device drivers.
>  #
>  
> +media-objs	:= media-devnode.o
> +
> +obj-$(CONFIG_MEDIA_SUPPORT)	+= media.o
> +
>  obj-y += common/ IR/ video/
>  
> -obj-$(CONFIG_VIDEO_DEV) += radio/
> -obj-$(CONFIG_DVB_CORE)  += dvb/
> +obj-$(CONFIG_VIDEO_DEV)		+= radio/
> +obj-$(CONFIG_DVB_CORE)		+= dvb/
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> new file mode 100644
> index 0000000..53f618b
> --- /dev/null
> +++ b/drivers/media/media-devnode.c
> @@ -0,0 +1,479 @@
> +/*
> + * Media device node
> + *
> + * Generic media device node infrastructure to register and unregister
> + * character devices using a dynamic major number and proper reference
> + * counting.
> + *
> + * Copyright 2010 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * Based on drivers/media/video/v4l2_dev.c code authored by
> + *
> + *	Mauro Carvalho Chehab <mchehab@infradead.org> (version 2)
> + *	Alan Cox, <alan@lxorguk.ukuu.org.uk> (version 1)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + *
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/kmod.h>
> +#include <linux/slab.h>
> +#include <linux/mm.h>
> +#include <linux/smp_lock.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <asm/system.h>
> +
> +#include <media/media-devnode.h>
> +
> +#define MEDIA_NUM_DEVICES	256
> +#define MEDIA_NAME		"media"
> +
> +static dev_t media_dev_t;
> +
> +/*
> + *	sysfs stuff
> + */
> +
> +static ssize_t show_name(struct device *cd,
> +			 struct device_attribute *attr, char *buf)
> +{
> +	struct media_devnode *mdev = to_media_devnode(cd);
> +
> +	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->name), mdev->name);
> +}
> +
> +static struct device_attribute media_devnode_attrs[] = {
> +	__ATTR(name, S_IRUGO, show_name, NULL),
> +	__ATTR_NULL
> +};
> +
> +/*
> + *	Active devices
> + */
> +static struct media_devnode *media_devnodes[MEDIA_NUM_DEVICES];
> +static DEFINE_MUTEX(media_devnode_lock);
> +static DECLARE_BITMAP(devnode_nums[MEDIA_TYPE_MAX], MEDIA_NUM_DEVICES);
> +
> +/* Device node utility functions */
> +
> +/* Note: these utility functions all assume that type is in the range
> +   [0, MEDIA_TYPE_MAX-1]. */
> +
> +/* Return the bitmap corresponding to type. */
> +static inline unsigned long *devnode_bits(int type)
> +{
> +	return devnode_nums[type];
> +}
> +
> +/* Mark device node number mdev->num as used */
> +static inline void devnode_set(struct media_devnode *mdev)
> +{
> +	set_bit(mdev->num, devnode_bits(mdev->type));
> +}
> +
> +/* Mark device node number mdev->num as unused */
> +static inline void devnode_clear(struct media_devnode *mdev)
> +{
> +	clear_bit(mdev->num, devnode_bits(mdev->type));
> +}
> +
> +/* Try to find a free device node number in the range [from, to> */
> +static inline int devnode_find(struct media_devnode *mdev, int from, int to)
> +{
> +	return find_next_zero_bit(devnode_bits(mdev->type), to, from);
> +}

We really don't need media_devnodes and devnode_nums. Or allow for other
media types for that matter. That's all legacy stuff from v4l2 that can
just be nuked for this new character driver.

> +
> +static inline void media_get(struct media_devnode *mdev)
> +{
> +	get_device(&mdev->dev);
> +}
> +
> +static inline void media_put(struct media_devnode *mdev)
> +{
> +	put_device(&mdev->dev);
> +}
> +
> +/* Called when the last user of the media device exits. */
> +static void media_devnode_release(struct device *cd)
> +{
> +	struct media_devnode *mdev = to_media_devnode(cd);
> +
> +	mutex_lock(&media_devnode_lock);
> +	if (media_devnodes[mdev->minor] != mdev) {
> +		mutex_unlock(&media_devnode_lock);
> +		/* should not happen */
> +		WARN_ON(1);
> +		return;
> +	}
> +
> +	/* Free up this device for reuse */
> +	media_devnodes[mdev->minor] = NULL;
> +
> +	/* Delete the cdev on this minor as well */
> +	cdev_del(mdev->cdev);
> +	/* Just in case some driver tries to access this from the release()
> +	 * callback.
> +	 */
> +	mdev->cdev = NULL;
> +
> +	/* Mark device node number as free */
> +	devnode_clear(mdev);
> +
> +	mutex_unlock(&media_devnode_lock);
> +
> +	/* Release media_devnode and perform other cleanups as needed. */
> +	if (mdev->release)
> +		mdev->release(mdev);
> +}
> +
> +static struct class media_class = {
> +	.name = MEDIA_NAME,
> +	.dev_attrs = media_devnode_attrs,
> +};
> +
> +struct media_devnode *media_devnode_data(struct file *file)
> +{
> +	return media_devnodes[iminor(file->f_path.dentry->d_inode)];

This can become:

struct media_devnode *media_devnode_data(struct inode *inode)
{
	return container_of(inode->i_cdev, struct media_devnode, cdev);
}

where struct cdev is embedded in struct media_devnode. See also the
'Linux Device Drivers' book.

It's probably better if the media_open function does this operation and sets
filp->private_data to media_devnode. Then we can just use:

struct media_devnode *media_devnode_data(struct file *filep)
{
	return filp->private_data;
}


> +}
> +EXPORT_SYMBOL(media_devnode_data);
> +
> +static ssize_t media_read(struct file *filp, char __user *buf,
> +		size_t sz, loff_t *off)
> +{
> +	struct media_devnode *mdev = media_devnode_data(filp);
> +
> +	if (!mdev->fops->read)
> +		return -EINVAL;
> +	if (!media_devnode_is_registered(mdev))
> +		return -EIO;
> +	return mdev->fops->read(filp, buf, sz, off);
> +}
> +
> +static ssize_t media_write(struct file *filp, const char __user *buf,
> +		size_t sz, loff_t *off)
> +{
> +	struct media_devnode *mdev = media_devnode_data(filp);
> +
> +	if (!mdev->fops->write)
> +		return -EINVAL;
> +	if (!media_devnode_is_registered(mdev))
> +		return -EIO;
> +	return mdev->fops->write(filp, buf, sz, off);
> +}
> +
> +static unsigned int media_poll(struct file *filp,
> +			       struct poll_table_struct *poll)
> +{
> +	struct media_devnode *mdev = media_devnode_data(filp);
> +
> +	if (!mdev->fops->poll || !media_devnode_is_registered(mdev))
> +		return DEFAULT_POLLMASK;
> +	return mdev->fops->poll(filp, poll);
> +}
> +
> +static long media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{
> +	struct media_devnode *mdev = media_devnode_data(filp);
> +	int ret = -ENOTTY;
> +
> +	/* Allow ioctl to continue even if the device was unregistered.
> +	   Things like dequeueing buffers might still be useful. */

Definitely out of date comment.

I would bail out if the device was unregistered. Unless there is a good
solid use case for this.

> +	if (mdev->fops->unlocked_ioctl)
> +		ret = mdev->fops->unlocked_ioctl(filp, cmd, arg);

I would only support unlocked_ioctl. Let's not introduce a BKL in this new
char device.

> +	else if (mdev->fops->ioctl) {
> +		lock_kernel();
> +		ret = mdev->fops->ioctl(filp, cmd, arg);
> +		unlock_kernel();
> +	}
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_MMU
> +#define media_get_unmapped_area NULL
> +#else
> +static unsigned long media_get_unmapped_area(struct file *filp,
> +		unsigned long addr, unsigned long len, unsigned long pgoff,
> +		unsigned long flags)
> +{
> +	struct media_devnode *mdev = media_devnode_data(filp);
> +
> +	if (!mdev->fops->get_unmapped_area)
> +		return -ENOSYS;
> +	if (!media_devnode_is_registered(mdev))
> +		return -ENODEV;
> +	return mdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
> +}
> +#endif

Do we really need this? I know it is in v4l2-dev.c, but AFAIK there isn't a
single driver that implements get_unmapped_area. I never understood why it is
in v4l2-dev.c for that matter.

> +
> +static int media_mmap(struct file *filp, struct vm_area_struct *vm)
> +{
> +	struct media_devnode *mdev = media_devnode_data(filp);
> +
> +	if (!mdev->fops->mmap || !media_devnode_is_registered(mdev))
> +		return -ENODEV;
> +	return mdev->fops->mmap(filp, vm);
> +}

Hmm. Do we want mmap support? I wouldn't add this unless there is a driver
that actually needs this.

> +
> +/* Override for the open function */
> +static int media_open(struct inode *inode, struct file *filp)
> +{
> +	struct media_devnode *mdev;
> +	int ret = 0;
> +
> +	/* Check if the media device is available */
> +	mutex_lock(&media_devnode_lock);
> +	mdev = media_devnode_data(filp);
> +	/* return ENODEV if the media device has been removed
> +	   already or if it is not registered anymore. */
> +	if (mdev == NULL || !media_devnode_is_registered(mdev)) {
> +		mutex_unlock(&media_devnode_lock);
> +		return -ENODEV;
> +	}
> +	/* and increase the device refcount */
> +	media_get(mdev);
> +	mutex_unlock(&media_devnode_lock);
> +	if (mdev->fops->open)
> +		ret = mdev->fops->open(filp);
> +
> +	/* decrease the refcount in case of an error */
> +	if (ret)
> +		media_put(mdev);
> +	return ret;
> +}
> +
> +/* Override for the release function */
> +static int media_release(struct inode *inode, struct file *filp)
> +{
> +	struct media_devnode *mdev = media_devnode_data(filp);
> +	int ret = 0;
> +
> +	if (mdev->fops->release)
> +		mdev->fops->release(filp);
> +
> +	/* decrease the refcount unconditionally since the release()
> +	   return value is ignored. */
> +	media_put(mdev);
> +	return ret;
> +}
> +
> +static const struct file_operations media_devnode_fops = {
> +	.owner = THIS_MODULE,
> +	.read = media_read,
> +	.write = media_write,
> +	.open = media_open,
> +	.get_unmapped_area = media_get_unmapped_area,
> +	.mmap = media_mmap,
> +	.unlocked_ioctl = media_ioctl,
> +#ifdef CONFIG_COMPAT
> +/*	.compat_ioctl = media_compat_ioctl32, */
> +#endif

Just remove this.

> +	.release = media_release,
> +	.poll = media_poll,
> +	.llseek = no_llseek,
> +};
> +
> +/**
> + * media_devnode_register - register a media device node
> + * @mdev: media device node structure we want to register
> + * @type: type of device node to register
> + *
> + * The registration code assigns minor numbers and device node numbers based
> + * on the requested type and registers the new device node with the kernel. An
> + * error is returned if no free minor or device node number could be found, or
> + * if the registration of the device node failed.
> + *
> + * Zero is returned on success.
> + *
> + * Note that if the media_devnode_register call fails, the release() callback of
> + * the media_devnode structure is *not* called, so the caller is responsible for
> + * freeing any data.
> + *
> + * Valid types are
> + *
> + * %MEDIA_TYPE_DEVICE - A media device
> + */
> +int __must_check media_devnode_register(struct media_devnode *mdev, int type)

Don't do types. I see no need for that.

> +{
> +	const char *name_base;
> +	int minor_offset = 0;
> +	int minor_cnt = MEDIA_NUM_DEVICES;
> +	void *priv;
> +	int ret;
> +	int nr;
> +	int i;
> +
> +	/* Part 1: check device type. */
> +	name_base = media_devnode_type_name(type);
> +	if (name_base == NULL) {
> +		printk(KERN_ERR "%s called with unknown type: %d\n",
> +		       __func__, type);
> +		return -EINVAL;
> +	}
> +
> +	mdev->type = type;
> +	mdev->cdev = NULL;
> +
> +	/* Part 2: find a free minor and device node number. */
> +
> +	/* Pick a device node number */
> +	mutex_lock(&media_devnode_lock);
> +	nr = devnode_find(mdev, 0, minor_cnt);
> +	if (nr == minor_cnt) {
> +		printk(KERN_ERR "could not get a free device node number\n");
> +		mutex_unlock(&media_devnode_lock);
> +		return -ENFILE;
> +	}
> +
> +	/* The device node number and minor numbers are independent, so we just
> +	 * find the first free minor number.
> +	 */
> +	for (i = 0; i < MEDIA_NUM_DEVICES; i++)
> +		if (media_devnodes[i] == NULL)
> +			break;
> +	if (i == MEDIA_NUM_DEVICES) {
> +		mutex_unlock(&media_devnode_lock);
> +		printk(KERN_ERR "could not get a free minor\n");
> +		return -ENFILE;
> +	}
> +
> +	mdev->minor = i + minor_offset;
> +	mdev->num = nr;
> +	devnode_set(mdev);
> +
> +	/* Should not happen since we thought this minor was free */
> +	WARN_ON(media_devnodes[mdev->minor] != NULL);
> +	mutex_unlock(&media_devnode_lock);
> +
> +	/* Part 3: Initialize the character device */
> +	mdev->cdev = cdev_alloc();
> +	if (mdev->cdev == NULL) {
> +		ret = -ENOMEM;
> +		goto cleanup;
> +	}
> +	mdev->cdev->ops = &media_devnode_fops;
> +	mdev->cdev->owner = mdev->fops->owner;
> +	ret = cdev_add(mdev->cdev, MKDEV(MAJOR(media_dev_t), mdev->minor), 1);
> +	if (ret < 0) {
> +		printk(KERN_ERR "%s: cdev_add failed\n", __func__);
> +		kfree(mdev->cdev);
> +		mdev->cdev = NULL;
> +		goto cleanup;
> +	}
> +
> +	/* Part 4: register the device with sysfs
> +	 *
> +	 * Zeroing struct device will clear the device's drvdata, so make a
> +	 * copy and put it back.
> +	 * */
> +	priv = dev_get_drvdata(&mdev->dev);
> +	memset(&mdev->dev, 0, sizeof(mdev->dev));
> +	dev_set_drvdata(&mdev->dev, priv);
> +	mdev->dev.class = &media_class;
> +	mdev->dev.devt = MKDEV(MAJOR(media_dev_t), mdev->minor);
> +	if (mdev->parent)
> +		mdev->dev.parent = mdev->parent;
> +	dev_set_name(&mdev->dev, "%s%d", name_base, mdev->num);
> +	ret = device_register(&mdev->dev);
> +	if (ret < 0) {
> +		printk(KERN_ERR "%s: device_register failed\n", __func__);
> +		goto cleanup;
> +	}
> +	/* Register the release callback that will be called when the last
> +	   reference to the device goes away. */
> +	mdev->dev.release = media_devnode_release;
> +
> +	/* Part 5: Activate this minor. The char device can now be used. */
> +	set_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
> +	mutex_lock(&media_devnode_lock);
> +	media_devnodes[mdev->minor] = mdev;
> +	mutex_unlock(&media_devnode_lock);
> +	return 0;
> +
> +cleanup:
> +	mutex_lock(&media_devnode_lock);
> +	if (mdev->cdev)
> +		cdev_del(mdev->cdev);
> +	devnode_clear(mdev);
> +	mutex_unlock(&media_devnode_lock);
> +	return ret;
> +}
> +
> +/**
> + * media_devnode_unregister - unregister a media device node
> + * @mdev: the device node to unregister
> + *
> + * This unregisters the passed device. Future open calls will be met with
> + * errors.
> + *
> + * This function can safely be called if the device node has never been
> + * registered or has already been unregistered.
> + */
> +void media_devnode_unregister(struct media_devnode *mdev)
> +{
> +	/* Check if mdev was ever registered at all */
> +	if (!media_devnode_is_registered(mdev))
> +		return;
> +
> +	mutex_lock(&media_devnode_lock);
> +	clear_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
> +	mutex_unlock(&media_devnode_lock);
> +	device_unregister(&mdev->dev);
> +}
> +
> +const char *media_devnode_type_name(int type)
> +{
> +	switch (type) {
> +	case MEDIA_TYPE_DEVICE:
> +		return "media";
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +/*
> + *	Initialise media for linux
> + */
> +static int __init media_devnode_init(void)
> +{
> +	int ret;
> +
> +	printk(KERN_INFO "Linux media interface: v0.10\n");
> +	ret = alloc_chrdev_region(&media_dev_t, 0, MEDIA_NUM_DEVICES,
> +				  MEDIA_NAME);
> +	if (ret < 0) {
> +		printk(KERN_WARNING "media: unable to allcoate major\n");
> +		return ret;
> +	}
> +
> +	ret = class_register(&media_class);
> +	if (ret < 0) {
> +		unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
> +		printk(KERN_WARNING "media: class_register failed\n");
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit media_devnode_exit(void)
> +{
> +	class_unregister(&media_class);
> +	unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
> +}
> +
> +module_init(media_devnode_init)
> +module_exit(media_devnode_exit)
> +
> +MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
> +MODULE_DESCRIPTION("Device node registration for media drivers");
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> new file mode 100644
> index 0000000..85c890f
> --- /dev/null
> +++ b/include/media/media-devnode.h
> @@ -0,0 +1,97 @@
> +/*
> + * Media device node handling
> + *
> + * Copyright (C) 2010  Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * Common functions for media-related drivers to register and unregister media
> + * device nodes.
> + */
> +#ifndef _MEDIA_DEVNODE_H
> +#define _MEDIA_DEVNODE_H
> +
> +#include <linux/poll.h>
> +#include <linux/fs.h>
> +#include <linux/device.h>
> +#include <linux/cdev.h>
> +
> +/* Media device node type. */
> +#define MEDIA_TYPE_DEVICE	0
> +#define MEDIA_TYPE_MAX		1
> +
> +/*
> + * Flag to mark the media_devnode struct as registered. Drivers must not touch
> + * this flag directly, it will be set and cleared by media_devnode_register and
> + * media_devnode_unregister.
> + */
> +#define MEDIA_FLAG_REGISTERED	0
> +
> +struct media_file_operations {
> +	struct module *owner;
> +	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
> +	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
> +	unsigned int (*poll) (struct file *, struct poll_table_struct *);
> +	long (*ioctl) (struct file *, unsigned int, unsigned long);
> +	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
> +	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
> +				unsigned long, unsigned long, unsigned long);
> +	int (*mmap) (struct file *, struct vm_area_struct *);
> +	int (*open) (struct file *);
> +	int (*release) (struct file *);
> +};
> +
> +/**
> + * struct media_devnode - Media device node
> + * @parent:	parent device
> + * @name:	media device node name
> + * @type:	node type, one of the MEDIA_TYPE_* constants
> + * @minor:	device node minor number
> + * @num:	device node number
> + * @flags:	flags, combination of the MEDIA_FLAG_* constants
> + *
> + * This structure represents a media-related device node.
> + *
> + * The @parent is a physical device. It must be set by core or device drivers
> + * before registering the node.
> + *
> + * @name is a descriptive name exported through sysfs. It doesn't have to be
> + * unique.
> + *
> + * The device node number @num is used to create the kobject name and thus
> + * serves as a hint to udev when creating the device node.
> + */
> +struct media_devnode {
> +	/* device ops */
> +	const struct media_file_operations *fops;
> +
> +	/* sysfs */
> +	struct device dev;		/* v4l device */
> +	struct cdev *cdev;		/* character device */
> +	struct device *parent;		/* device parent */
> +
> +	/* device info */
> +	char name[32];
> +	int type;
> +
> +	int minor;
> +	u16 num;
> +	unsigned long flags;		/* Use bitops to access flags */
> +
> +	/* callbacks */
> +	void (*release)(struct media_devnode *mdev);
> +};
> +
> +/* dev to media_devnode */
> +#define to_media_devnode(cd) container_of(cd, struct media_devnode, dev)
> +
> +int __must_check media_devnode_register(struct media_devnode *mdev, int type);
> +void media_devnode_unregister(struct media_devnode *mdev);
> +
> +const char *media_devnode_type_name(int type);
> +struct media_devnode *media_devnode_data(struct file *file);
> +
> +static inline int media_devnode_is_registered(struct media_devnode *mdev)
> +{
> +	return test_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
> +}
> +
> +#endif /* _MEDIA_DEVNODE_H */
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
