Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:58997 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbcD0QnT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 12:43:19 -0400
Subject: Re: [PATCH] media: fix media_ioctl use-after-free when driver unbinds
To: Shuah Khan <shuahkh@osg.samsung.com>, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, sakari.ailus@iki.fi
References: <1461726512-9828-1-git-send-email-shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <5720EC1A.8060101@metafoo.de>
Date: Wed, 27 Apr 2016 18:43:06 +0200
MIME-Version: 1.0
In-Reply-To: <1461726512-9828-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks mostly good, a few comments.

On 04/27/2016 05:08 AM, Shuah Khan wrote:
[...]
> @@ -428,7 +428,7 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
>  			       unsigned long arg)
>  {
>  	struct media_devnode *devnode = media_devnode_data(filp);
> -	struct media_device *dev = to_media_device(devnode);

Can we keep the helper macro, means we don't need to touch this code.

> +	struct media_device *dev = devnode->media_dev;

You need a lock to protect this from running concurrently with
media_device_unregister() otherwise the struct might be freed while still in
use.

>  	long ret;
>  
>  	switch (cmd) {
[...]
> @@ -725,21 +726,26 @@ int __must_check __media_device_register(struct media_device *mdev,
>  {
>  	int ret;
>  
> +	mdev->devnode = kzalloc(sizeof(struct media_devnode), GFP_KERNEL);

sizeof(*mdev->devnode) is preferred kernel style,

> +	if (!mdev->devnode)
> +		return -ENOMEM;
> +
>  	/* Register the device node. */
> -	mdev->devnode.fops = &media_device_fops;
> -	mdev->devnode.parent = mdev->dev;
> -	mdev->devnode.release = media_device_release;
> +	mdev->devnode->fops = &media_device_fops;
> +	mdev->devnode->parent = mdev->dev;
> +	mdev->devnode->media_dev = mdev;
> +	mdev->devnode->release = media_device_release;

This should no longer be necessary. Just drop the release callback altogether.

>  
>  	/* Set version 0 to indicate user-space that the graph is static */
>  	mdev->topology_version = 0;
>  
[...]
> @@ -813,8 +819,10 @@ void media_device_unregister(struct media_device *mdev)
>  
>  	spin_unlock(&mdev->lock);
>  
> -	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> -	media_devnode_unregister(&mdev->devnode);
> +	device_remove_file(&mdev->devnode->dev, &dev_attr_model);
> +	media_devnode_unregister(mdev->devnode);
> +	/* kfree devnode is done via kobject_put() handler */
> +	mdev->devnode = NULL;

mdev->devnode->media_dev needs to be set to NULL.

>  
>  	dev_dbg(mdev->dev, "Media device unregistered\n");
>  }
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> index 29409f4..9af9ba1 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -171,6 +171,9 @@ static int media_open(struct inode *inode, struct file *filp)
>  		mutex_unlock(&media_devnode_lock);
>  		return -ENXIO;
>  	}
> +
> +	kobject_get(&mdev->kobj);

This is not necessary, and if it was it would be prone to race condition as
the last reference could be dropped before this line. But assigning the cdev
parent makes sure that we always have a reference to the object while the
open() callback is running.

> +
>  	/* and increase the device refcount */
>  	get_device(&mdev->dev);
>  	mutex_unlock(&media_devnode_lock);
>  /*
[...]
> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> index fe42f08..ba4bdaa 100644
> --- a/include/media/media-devnode.h
> +++ b/include/media/media-devnode.h
> @@ -70,7 +70,9 @@ struct media_file_operations {
>   * @fops:	pointer to struct &media_file_operations with media device ops
>   * @dev:	struct device pointer for the media controller device
>   * @cdev:	struct cdev pointer character device
> + * @kobj:	struct kobject
>   * @parent:	parent device
> + * @media_dev:	media device
>   * @minor:	device node minor number
>   * @flags:	flags, combination of the MEDIA_FLAG_* constants
>   * @release:	release callback called at the end of media_devnode_release()
> @@ -87,7 +89,9 @@ struct media_devnode {
>  	/* sysfs */
>  	struct device dev;		/* media device */
>  	struct cdev cdev;		/* character device */
> +	struct kobject kobj;		/* set as cdev parent kobj */

You don't need a extra kobj. Just use the struct dev kobj.

>  	struct device *parent;		/* device parent */
> +	struct media_device *media_dev; /* media device for the devnode */
>  
>  	/* device info */
>  	int minor;

