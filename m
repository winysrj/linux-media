Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:39959 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab0KQAbR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 19:31:17 -0500
Date: Tue, 16 Nov 2010 17:31:15 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v5 01/12] media: Media device node support
Message-ID: <20101116173115.0723af74@bike.lwn.net>
In-Reply-To: <1285241696-16826-2-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285241696-16826-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1285241696-16826-2-git-send-email-laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Here's the first of my more specific comments - probably the only file
I'll get to today...

> The media_devnode structure provides support for registering and
> unregistering character devices using a dynamic major number. Reference
> counting is handled internally, making device drivers easier to write
> without having to solve the open/disconnect race condition issue over
> and over again.

My first impression is that you're creating a simplified wrapper around
chardevs - essentially a reimplementation of the miscdevice subsystem.  If
we really need this, it seems like it should be made something more
generic.

I wonder, though, why this functionality isn't just folded into struct
media_device?  Do you plan to use it elsewhere as well?


[...]

> +static unsigned int media_poll(struct file *filp,
> +			       struct poll_table_struct *poll)
> +{
> +	struct media_devnode *mdev = media_devnode_data(filp);
> +
> +	if (!mdev->fops->poll || !media_devnode_is_registered(mdev))
> +		return DEFAULT_POLLMASK;
> +	return mdev->fops->poll(filp, poll);
> +}

If it's not registered, I would expect poll() to return an error.

[...]

> +/**
> + * media_devnode_register - register a media device node
> + * @mdev: media device node structure we want to register
> + *
> + * The registration code assigns minor numbers and registers the new device node
> + * with the kernel. An error is returned if no free minor number can be found,
> + * or if the registration of the device node fails.
> + *
> + * Zero is returned on success.
> + *
> + * Note that if the media_devnode_register call fails, the release() callback of
> + * the media_devnode structure is *not* called, so the caller is responsible for
> + * freeing any data.
> + */
> +int __must_check media_devnode_register(struct media_devnode *mdev)
> +{
> +	int minor;
> +	int ret;
> +
> +	/* Part 1: Find a free minor number */
> +	mutex_lock(&media_devnode_lock);
> +	minor = find_next_zero_bit(media_devnode_nums, 0, MEDIA_NUM_DEVICES);
> +	if (minor == MEDIA_NUM_DEVICES) {
> +		mutex_unlock(&media_devnode_lock);
> +		printk(KERN_ERR "could not get a free minor\n");
> +		return -ENFILE;
> +	}
> +
> +	set_bit(mdev->minor, media_devnode_nums);
> +	mutex_unlock(&media_devnode_lock);
> +
> +	mdev->minor = minor;
> +
> +	/* Part 2: Initialize and register the character device */
> +	cdev_init(&mdev->cdev, &media_devnode_fops);
> +	mdev->cdev.owner = mdev->fops->owner;
> +
> +	ret = cdev_add(&mdev->cdev, MKDEV(MAJOR(media_dev_t), mdev->minor), 1);
> +	if (ret < 0) {
> +		printk(KERN_ERR "%s: cdev_add failed\n", __func__);
> +		goto error;
> +	}
> +
> +	/* Part 3: Register the media device */
> +	mdev->dev.class = &media_class;

There is a real push to get rid of classes.  Is there a need for this class
here?  It doesn't look like you attach any attributes to it.

> +	mdev->dev.devt = MKDEV(MAJOR(media_dev_t), mdev->minor);
> +	mdev->dev.release = media_devnode_release;
> +	if (mdev->parent)
> +		mdev->dev.parent = mdev->parent;
> +	dev_set_name(&mdev->dev, "media%d", mdev->minor);
> +	ret = device_register(&mdev->dev);
> +	if (ret < 0) {
> +		printk(KERN_ERR "%s: device_register failed\n", __func__);
> +		goto error;
> +	}
> +
> +	/* Part 4: Activate this minor. The char device can now be used. */
> +	set_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
> +
> +	return 0;
> +
> +error:
> +	cdev_del(&mdev->cdev);
> +	mutex_lock(&media_devnode_lock);
> +	clear_bit(mdev->minor, media_devnode_nums);

Bitops are atomic, even, it seems, for large bitmaps.

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

This lock shouldn't be needed either.

> +	mutex_unlock(&media_devnode_lock);
> +	device_unregister(&mdev->dev);
> +}
> +

[...]

> +struct media_file_operations {
> +	struct module *owner;
> +	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
> +	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
> +	unsigned int (*poll) (struct file *, struct poll_table_struct *);
> +	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
> +	int (*open) (struct file *);
> +	int (*release) (struct file *);
> +};

I'd be awfully tempted to just call it ioctl(); I suspect that
unlocked_ioctl() in struct file_operations will be renamed before too
long.

> +
> +/**
> + * struct media_devnode - Media device node
> + * @parent:	parent device
> + * @minor:	device node minor number
> + * @flags:	flags, combination of the MEDIA_FLAG_* constants
> + *
> + * This structure represents a media-related device node.
> + *
> + * The @parent is a physical device. It must be set by core or device drivers
> + * before registering the node.
> + */
> +struct media_devnode {
> +	/* device ops */
> +	const struct media_file_operations *fops;
> +
> +	/* sysfs */
> +	struct device dev;		/* media device */
> +	struct cdev cdev;		/* character device */

I'm an easily confused sort of guy, so it's not surprising, I guess, that I
don't understand this.  Why do you need both dev and cdev?  You register
both with the same device number...  dev seems to be there just to hang the
class from?  What am I missing here?

> +	struct device *parent;		/* device parent */
> +
> +	/* device info */
> +	int minor;
> +	unsigned long flags;		/* Use bitops to access flags */
> +
> +	/* callbacks */
> +	void (*release)(struct media_devnode *mdev);
> +};

Thanks,

jon
