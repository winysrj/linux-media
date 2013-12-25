Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34677 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3LYXXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Dec 2013 18:23:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC 1/2] media: Use a better owner for the media device
Date: Thu, 26 Dec 2013 00:23:41 +0100
Message-ID: <7531072.aOyNN2I7IG@avalon>
In-Reply-To: <1386936216-32296-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1386936216-32296-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 13 December 2013 14:03:35 Sakari Ailus wrote:
> mdev->fops->owner is actually the owner of the very same module which
> implements media_device_register(), so it can't be unloaded anyway. Instead,
> use THIS_MODULE through a macro as does video_register_device().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

This looks good to me.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-device.c  | 7 ++++---
>  drivers/media/media-devnode.c | 5 +++--
>  include/media/media-device.h  | 4 +++-
>  include/media/media-devnode.h | 3 ++-
>  4 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index d5a7a13..51217f0 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -372,7 +372,8 @@ static void media_device_release(struct media_devnode
> *mdev) * - dev must point to the parent device
>   * - model must be filled with the device model name
>   */
> -int __must_check media_device_register(struct media_device *mdev)
> +int __must_check __media_device_register(struct media_device *mdev,
> +					 struct module *owner)
>  {
>  	int ret;
> 
> @@ -388,7 +389,7 @@ int __must_check media_device_register(struct
> media_device *mdev) mdev->devnode.fops = &media_device_fops;
>  	mdev->devnode.parent = mdev->dev;
>  	mdev->devnode.release = media_device_release;
> -	ret = media_devnode_register(&mdev->devnode);
> +	ret = media_devnode_register(&mdev->devnode, owner);
>  	if (ret < 0)
>  		return ret;
> 
> @@ -400,7 +401,7 @@ int __must_check media_device_register(struct
> media_device *mdev)
> 
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(media_device_register);
> +EXPORT_SYMBOL_GPL(__media_device_register);
> 
>  /**
>   * media_device_unregister - unregister a media device
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> index fb0f046..7acd19c 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -232,7 +232,8 @@ static const struct file_operations media_devnode_fops =
> { * the media_devnode structure is *not* called, so the caller is
> responsible for * freeing any data.
>   */
> -int __must_check media_devnode_register(struct media_devnode *mdev)
> +int __must_check media_devnode_register(struct media_devnode *mdev,
> +					struct module *owner)
>  {
>  	int minor;
>  	int ret;
> @@ -253,7 +254,7 @@ int __must_check media_devnode_register(struct
> media_devnode *mdev)
> 
>  	/* Part 2: Initialize and register the character device */
>  	cdev_init(&mdev->cdev, &media_devnode_fops);
> -	mdev->cdev.owner = mdev->fops->owner;
> +	mdev->cdev.owner = owner;
> 
>  	ret = cdev_add(&mdev->cdev, MKDEV(MAJOR(media_dev_t), mdev->minor), 1);
>  	if (ret < 0) {
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 12155a9..6e6db78 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -87,7 +87,9 @@ struct media_device {
>  /* media_devnode to media_device */
>  #define to_media_device(node) container_of(node, struct media_device,
> devnode)
> 
> -int __must_check media_device_register(struct media_device *mdev);
> +int __must_check __media_device_register(struct media_device *mdev,
> +					 struct module *owner);
> +#define media_device_register(mdev) __media_device_register(mdev,
> THIS_MODULE) void media_device_unregister(struct media_device *mdev);
> 
>  int __must_check media_device_register_entity(struct media_device *mdev,
> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> index 3446af2..0dc7060 100644
> --- a/include/media/media-devnode.h
> +++ b/include/media/media-devnode.h
> @@ -82,7 +82,8 @@ struct media_devnode {
>  /* dev to media_devnode */
>  #define to_media_devnode(cd) container_of(cd, struct media_devnode, dev)
> 
> -int __must_check media_devnode_register(struct media_devnode *mdev);
> +int __must_check media_devnode_register(struct media_devnode *mdev,
> +					struct module *owner);
>  void media_devnode_unregister(struct media_devnode *mdev);
> 
>  static inline struct media_devnode *media_devnode_data(struct file *filp)
-- 
Regards,

Laurent Pinchart

