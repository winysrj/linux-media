Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:47352 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab0GZJG5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 05:06:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v2 01/10] media: Media device node support
Date: Mon, 26 Jul 2010 11:07:14 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-2-git-send-email-laurent.pinchart@ideasonboard.com> <201007241359.11584.hverkuil@xs4all.nl>
In-Reply-To: <201007241359.11584.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007261107.16043.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On Saturday 24 July 2010 13:59:11 Hans Verkuil wrote:
> On Wednesday 21 July 2010 16:35:26 Laurent Pinchart wrote:
> > The media_devnode structure provides support for registering and
> > unregistering character devices using a dynamic major number. Reference
> > counting is handled internally, making device drivers easier to write
> > without having to solve the open/disconnect race condition issue over
> > and over again.
> > 
> > The code is based on video/v4l2-dev.c.

[snip]

> > diff --git a/drivers/media/media-devnode.c
> > b/drivers/media/media-devnode.c new file mode 100644
> > index 0000000..fa300f8
> > --- /dev/null
> > +++ b/drivers/media/media-devnode.c
> > @@ -0,0 +1,339 @@

[snip]

> > +/*
> > + *	Active devices
> > + */
> > +static DEFINE_MUTEX(media_devnode_lock);
> 
> I don't think this lock is actually needed. The bit operations are already
> atomic, so we can do without this lock.

The mutex is needed to avoid an open/unregister race. Without it the device 
could be unregistered during media_open, after the media_devnode_is_registered 
check but before the call to get_device.

> > +static DECLARE_BITMAP(media_devnode_nums, MEDIA_NUM_DEVICES);
> > +
> > +static inline void media_get(struct media_devnode *mdev)
> > +{
> > +	get_device(&mdev->dev);
> > +}
> > +
> > +static inline void media_put(struct media_devnode *mdev)
> > +{
> > +	put_device(&mdev->dev);
> > +}
> 
> These functions are used quite rarely. I'd remove these inlines and just
> call get/put_device directly.

Agreed. I was thinking of removing them and thought you would like it better 
if I kept them :-)

[snip]

> > +static long media_ioctl(struct file *filp, unsigned int cmd, unsigned
> > long arg) +{
> > +	struct media_devnode *mdev = media_devnode_data(filp);
> > +
> > +	if (!media_devnode_is_registered(mdev))
> > +		return -EIO;
> > +
> > +	if (!mdev->fops->unlocked_ioctl)
> > +		return -ENOTTY;
> 
> These two if's should be swapper (just like in media_read and write).

I'm not sure why, but OK.

> > +
> > +	return mdev->fops->unlocked_ioctl(filp, cmd, arg);
> > +}
> > +
> > +/* Override for the open function */
> > +static int media_open(struct inode *inode, struct file *filp)
> > +{
> > +	struct media_devnode *mdev;
> > +	int ret;
> > +
> > +	/* Check if the media device is available */
> > +	mutex_lock(&media_devnode_lock);
> > +	mdev = container_of(inode->i_cdev, struct media_devnode, cdev);
> > +	/* return ENODEV if the media device has been removed
> > +	   already or if it is not registered anymore. */
> > +	if (mdev == NULL || !media_devnode_is_registered(mdev)) {
> 
> mdev can never be NULL.

Indeed, thanks.

> > +		mutex_unlock(&media_devnode_lock);
> > +		return -ENODEV;
> > +	}
> > +	/* and increase the device refcount */
> > +	media_get(mdev);
> > +	mutex_unlock(&media_devnode_lock);
> > +	if (mdev->fops->open) {
> > +		ret = mdev->fops->open(filp);
> > +		if (ret) {
> > +			media_put(mdev);
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	filp->private_data = mdev;
> > +	return 0;
> > +}

[snip]

> > +/**
> > + * media_devnode_register - register a media device node
> > + * @mdev: media device node structure we want to register
> > + *
> > + * The registration code assigns minor numbers and registers the new 
> > device node
> > + * with the kernel. An error is returned if no free minor number can be
> > found,
> > + * or if the registration of the device node fails.
> > + *
> > + * Zero is returned on success.
> > + *
> > + * Note that if the media_devnode_register call fails, the release()
> > callback of
> > + * the media_devnode structure is *not* called, so the caller is
> > responsible for
> > + * freeing any data.
> > + */
> > +int __must_check media_devnode_register(struct media_devnode *mdev)
> > +{
> > +	void *priv;
> > +	int minor;
> > +	int ret;
> > +
> > +	/* Part 1: find a free minor number */
> > +	mutex_lock(&media_devnode_lock);
> > +	minor = find_next_zero_bit(media_devnode_nums, 0, MEDIA_NUM_DEVICES);
> 
> When media_devnode_lock is removed we can't use find_next_zero_bit anymore.
> Instead, we have to loop over all bits and call test_and_set_bit() to
> ensure atomicity.

I think the lock is still needed (see above), so find_next_zero_bit can be 
kept.

> > +	if (minor == MEDIA_NUM_DEVICES) {
> > +		printk(KERN_ERR "could not get a free minor\n");
> > +		mutex_unlock(&media_devnode_lock);
> > +		return -ENFILE;
> > +	}
> > +
> > +	set_bit(mdev->minor, media_devnode_nums);
> > +	mdev->minor = minor;
> > +
> > +	mutex_unlock(&media_devnode_lock);
> > +
> > +	/* Part 2: Initialize and register the character device */
> > +	cdev_init(&mdev->cdev, &media_devnode_fops);
> > +	mdev->cdev.owner = mdev->fops->owner;
> > +
> > +	ret = cdev_add(&mdev->cdev, MKDEV(MAJOR(media_dev_t), mdev->minor), 1);
> > +	if (ret < 0) {
> > +		printk(KERN_ERR "%s: cdev_add failed\n", __func__);
> > +		goto error;
> > +	}
> > +
> > +	/* Part 3: register the media device
> > +	 *
> > +	 * Zeroing struct device will clear the device's drvdata, so make a
> > +	 * copy and put it back.
> > +	 */
> > +	priv = dev_get_drvdata(&mdev->dev);
> > +	memset(&mdev->dev, 0, sizeof(mdev->dev));
> > +	dev_set_drvdata(&mdev->dev, priv);
> 
> Don't zero mdev->dev. We should assume that mdev has been zeroed by the
> caller. This construct is actually a bug in v4l2-dev.c. I've seen patches
> that fixed it, but I don't know the status of those patches. The problem
> is that dev_set_drvdata these days allocates memory. So if dev_set_drvdata
> was called before this function, then this construct will leak a bit of
> memory.
> 
> I would just remove this and require that mdev was initialized correctly
> when it was allocated.

OK.

> > +	mdev->dev.class = &media_class;
> > +	mdev->dev.devt = MKDEV(MAJOR(media_dev_t), mdev->minor);
> > +	mdev->dev.release = media_devnode_release;
> > +	if (mdev->parent)
> > +		mdev->dev.parent = mdev->parent;
> > +	dev_set_name(&mdev->dev, "media%d", mdev->minor);
> 
> Wouldn't mediactlX be a better name? Just plain 'media' is awfully general.

Good question.

> > +	ret = device_register(&mdev->dev);
> > +	if (ret < 0) {
> > +		printk(KERN_ERR "%s: device_register failed\n", __func__);
> > +		goto error;
> > +	}
> > +
> > +	/* Part 4: Activate this minor. The char device can now be used. */
> > +	set_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
> > +
> > +	return 0;
> > +
> > +error:
> > +	cdev_del(&mdev->cdev);
> > +	mutex_lock(&media_devnode_lock);
> > +	clear_bit(mdev->minor, media_devnode_nums);
> > +	mutex_unlock(&media_devnode_lock);
> > +	return ret;
> > +}

[snip]

> > diff --git a/include/media/media-devnode.h
> > b/include/media/media-devnode.h new file mode 100644
> > index 0000000..5c8f682
> > --- /dev/null
> > +++ b/include/media/media-devnode.h
> > @@ -0,0 +1,91 @@

[snip]

> > +struct media_file_operations {
> > +	struct module *owner;
> > +	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
> > +	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t
> > *); +	unsigned int (*poll) (struct file *, struct poll_table_struct *);
> > +	long (*ioctl) (struct file *, unsigned int, unsigned long);
> 
> I think you forgot to remove the ioctl, mmap and get_unmapped_area ops from
> this struct.

Yes, thanks.

> > +	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
> > +	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
> > +				unsigned long, unsigned long, unsigned long);
> > +	int (*mmap) (struct file *, struct vm_area_struct *);
> > +	int (*open) (struct file *);
> > +	int (*release) (struct file *);
> > +};
> > +
> > +/**
> > + * struct media_devnode - Media device node
> > + * @parent:	parent device
> > + * @name:	media device node name
> > + * @minor:	device node minor number
> > + * @flags:	flags, combination of the MEDIA_FLAG_* constants
> > + *
> > + * This structure represents a media-related device node.
> > + *
> > + * The @parent is a physical device. It must be set by core or device
> > drivers
> > + * before registering the node.
> > + *
> > + * @name is a descriptive name exported through sysfs. It doesn't have to
> > be
> > + * unique.
> > + *
> > + * The device node number @num is used to create the kobject name and
> > thus
> > + * serves as a hint to udev when creating the device node.
> 
> 'num' no longer exists.

Oops :-)

-- 
Regards,

Laurent Pinchart
