Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49334 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753425AbcFQGJS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 02:09:18 -0400
Date: Fri, 17 Jun 2016 09:08:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: fix media devnode ioctl/syscall and unregister
 race
Message-ID: <20160617060843.GE24980@valkosipuli.retiisi.org.uk>
References: <1465580243-7274-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1465580243-7274-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Fri, Jun 10, 2016 at 11:37:23AM -0600, Shuah Khan wrote:
> Media devnode open/ioctl could be in progress when media device unregister
> is initiated. System calls and ioctls check media device registered status
> at the beginning, however, there is a window where unregister could be in
> progress without changing the media devnode status to unregistered.
> 
> process 1				process 2
> fd = open(/dev/media0)
> media_devnode_is_registered()
> 	(returns true here)
> 
> 					media_device_unregister()
> 						(unregister is in progress
> 						and devnode isn't
> 						unregistered yet)
> 					...
> ioctl(fd, ...)
> __media_ioctl()
> media_devnode_is_registered()
> 	(returns true here)
> 					...
> 					media_devnode_unregister()
> 					...
> 					(driver releases the media device
> 					memory)
> 
> media_device_ioctl()
> 	(By this point
> 	devnode->media_dev does not
> 	point to allocated memory.
> 	use-after free in in mutex_lock_nested)
> 
> BUG: KASAN: use-after-free in mutex_lock_nested+0x79c/0x800 at addr
> ffff8801ebe914f0
> 
> Fix it by clearing register bit when unregister starts to avoid the race.

Does this patch solve the problem? You'd have to take the mutex for the
duration of the IOCTL which I don't see the patch doing.

Instead of serialising operations using mutexes, I believe a proper fix for
this is to take a reference to the data structures required.

> 
> process 1                               process 2
> fd = open(/dev/media0)
> media_devnode_is_registered()
>         (could return true here)
> 
>                                         media_device_unregister()
>                                                 (clear the register bit,
> 						 then start unregister.)
>                                         ...
> ioctl(fd, ...)
> __media_ioctl()
> media_devnode_is_registered()
>         (return false here, ioctl
> 	 returns I/O error, and
> 	 will not access media
> 	 device memory)
>                                         ...
>                                         media_devnode_unregister()
>                                         ...
>                                         (driver releases the media device
> 					 memory)
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reported-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
> 
> Test Procedure and Results:
> 
> https://drive.google.com/file/d/0B0NIL0BQg-AlN1VxT2oyTXBPRHc/view?usp=sharing
> 
>  drivers/media/media-device.c  | 15 ++++++++-------
>  drivers/media/media-devnode.c |  8 +++++++-
>  include/media/media-devnode.h | 16 ++++++++++++++--
>  3 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 33a9952..1795abe 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -732,6 +732,7 @@ int __must_check __media_device_register(struct media_device *mdev,
>  	if (ret < 0) {
>  		/* devnode free is handled in media_devnode_*() */
>  		mdev->devnode = NULL;
> +		media_devnode_unregister_prepare(devnode);
>  		media_devnode_unregister(devnode);
>  		return ret;
>  	}
> @@ -788,6 +789,9 @@ void media_device_unregister(struct media_device *mdev)
>  		return;
>  	}
>  
> +	/* Clear the devnode register bit to avoid races with media dev open */
> +	media_devnode_unregister_prepare(mdev->devnode);
> +
>  	/* Remove all entities from the media device */
>  	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
>  		__media_device_unregister_entity(entity);
> @@ -808,13 +812,10 @@ void media_device_unregister(struct media_device *mdev)
>  
>  	dev_dbg(mdev->dev, "Media device unregistered\n");
>  
> -	/* Check if mdev devnode was registered */
> -	if (media_devnode_is_registered(mdev->devnode)) {
> -		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
> -		media_devnode_unregister(mdev->devnode);
> -		/* devnode free is handled in media_devnode_*() */
> -		mdev->devnode = NULL;
> -	}
> +	device_remove_file(&mdev->devnode->dev, &dev_attr_model);
> +	media_devnode_unregister(mdev->devnode);
> +	/* devnode free is handled in media_devnode_*() */
> +	mdev->devnode = NULL;
>  }
>  EXPORT_SYMBOL_GPL(media_device_unregister);
>  
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> index 5b605ff..f2772ba 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -287,7 +287,7 @@ cdev_add_error:
>  	return ret;
>  }
>  
> -void media_devnode_unregister(struct media_devnode *devnode)
> +void media_devnode_unregister_prepare(struct media_devnode *devnode)
>  {
>  	/* Check if devnode was ever registered at all */
>  	if (!media_devnode_is_registered(devnode))
> @@ -295,6 +295,12 @@ void media_devnode_unregister(struct media_devnode *devnode)
>  
>  	mutex_lock(&media_devnode_lock);
>  	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
> +	mutex_unlock(&media_devnode_lock);
> +}
> +
> +void media_devnode_unregister(struct media_devnode *devnode)
> +{
> +	mutex_lock(&media_devnode_lock);
>  	/* Delete the cdev on this minor as well */
>  	cdev_del(&devnode->cdev);
>  	mutex_unlock(&media_devnode_lock);
> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> index 5bb3b0e..f0b7dd7 100644
> --- a/include/media/media-devnode.h
> +++ b/include/media/media-devnode.h
> @@ -126,14 +126,26 @@ int __must_check media_devnode_register(struct media_device *mdev,
>  					struct module *owner);
>  
>  /**
> + * media_devnode_unregister_prepare - clear the media device node register bit
> + * @devnode: the device node to prepare for unregister
> + *
> + * This clears the passed device register bit. Future open calls will be met
> + * with errors. Should be called before media_devnode_unregister() to avoid
> + * races with unregister and device file open calls.
> + *
> + * This function can safely be called if the device node has never been
> + * registered or has already been unregistered.
> + */
> +void media_devnode_unregister_prepare(struct media_devnode *devnode);
> +
> +/**
>   * media_devnode_unregister - unregister a media device node
>   * @devnode: the device node to unregister
>   *
>   * This unregisters the passed device. Future open calls will be met with
>   * errors.
>   *
> - * This function can safely be called if the device node has never been
> - * registered or has already been unregistered.
> + * Should be called after media_devnode_unregister_prepare()
>   */
>  void media_devnode_unregister(struct media_devnode *devnode);
>  

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
