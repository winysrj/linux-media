Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40020 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755596AbcKVKBW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 05:01:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, shuahkh@osg.samsung.com
Subject: Re: [RFC v4 01/21] Revert "[media] media: fix media devnode ioctl/syscall and unregister race"
Date: Tue, 22 Nov 2016 12:01:39 +0200
Message-ID: <5398240.2zSPZQBYuK@avalon>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk> <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 08 Nov 2016 15:55:10 Sakari Ailus wrote:
> This reverts commit 6f0dd24a084a ("[media] media: fix media devnode
> ioctl/syscall and unregister race"). The commit was part of an original
> patchset to avoid crashes when an unregistering device is in use.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

For 01/21 to 03/21,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-device.c  | 15 +++++++--------
>  drivers/media/media-devnode.c |  8 +-------
>  include/media/media-devnode.h | 16 ++--------------
>  3 files changed, 10 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 2783531..f2525eb 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -730,7 +730,6 @@ int __must_check __media_device_register(struct
> media_device *mdev, if (ret < 0) {
>  		/* devnode free is handled in media_devnode_*() */
>  		mdev->devnode = NULL;
> -		media_devnode_unregister_prepare(devnode);
>  		media_devnode_unregister(devnode);
>  		return ret;
>  	}
> @@ -787,9 +786,6 @@ void media_device_unregister(struct media_device *mdev)
>  		return;
>  	}
> 
> -	/* Clear the devnode register bit to avoid races with media dev open 
*/
> -	media_devnode_unregister_prepare(mdev->devnode);
> -
>  	/* Remove all entities from the media device */
>  	list_for_each_entry_safe(entity, next, &mdev->entities, 
graph_obj.list)
>  		__media_device_unregister_entity(entity);
> @@ -810,10 +806,13 @@ void media_device_unregister(struct media_device
> *mdev)
> 
>  	dev_dbg(mdev->dev, "Media device unregistered\n");
> 
> -	device_remove_file(&mdev->devnode->dev, &dev_attr_model);
> -	media_devnode_unregister(mdev->devnode);
> -	/* devnode free is handled in media_devnode_*() */
> -	mdev->devnode = NULL;
> +	/* Check if mdev devnode was registered */
> +	if (media_devnode_is_registered(mdev->devnode)) {
> +		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
> +		media_devnode_unregister(mdev->devnode);
> +		/* devnode free is handled in media_devnode_*() */
> +		mdev->devnode = NULL;
> +	}
>  }
>  EXPORT_SYMBOL_GPL(media_device_unregister);
> 
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> index f2772ba..5b605ff 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -287,7 +287,7 @@ int __must_check media_devnode_register(struct
> media_device *mdev, return ret;
>  }
> 
> -void media_devnode_unregister_prepare(struct media_devnode *devnode)
> +void media_devnode_unregister(struct media_devnode *devnode)
>  {
>  	/* Check if devnode was ever registered at all */
>  	if (!media_devnode_is_registered(devnode))
> @@ -295,12 +295,6 @@ void media_devnode_unregister_prepare(struct
> media_devnode *devnode)
> 
>  	mutex_lock(&media_devnode_lock);
>  	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
> -	mutex_unlock(&media_devnode_lock);
> -}
> -
> -void media_devnode_unregister(struct media_devnode *devnode)
> -{
> -	mutex_lock(&media_devnode_lock);
>  	/* Delete the cdev on this minor as well */
>  	cdev_del(&devnode->cdev);
>  	mutex_unlock(&media_devnode_lock);
> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> index cd23e91..d55ec2b 100644
> --- a/include/media/media-devnode.h
> +++ b/include/media/media-devnode.h
> @@ -128,26 +128,14 @@ int __must_check media_devnode_register(struct
> media_device *mdev, struct module *owner);
> 
>  /**
> - * media_devnode_unregister_prepare - clear the media device node register
> bit - * @devnode: the device node to prepare for unregister
> - *
> - * This clears the passed device register bit. Future open calls will be
> met - * with errors. Should be called before media_devnode_unregister() to
> avoid - * races with unregister and device file open calls.
> - *
> - * This function can safely be called if the device node has never been
> - * registered or has already been unregistered.
> - */
> -void media_devnode_unregister_prepare(struct media_devnode *devnode);
> -
> -/**
>   * media_devnode_unregister - unregister a media device node
>   * @devnode: the device node to unregister
>   *
>   * This unregisters the passed device. Future open calls will be met with
>   * errors.
>   *
> - * Should be called after media_devnode_unregister_prepare()
> + * This function can safely be called if the device node has never been
> + * registered or has already been unregistered.
>   */
>  void media_devnode_unregister(struct media_devnode *devnode);

-- 
Regards,

Laurent Pinchart

