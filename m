Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46294 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932879AbcCQLu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 07:50:57 -0400
Date: Thu, 17 Mar 2016 13:50:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>, javier@osg.samsung.com
Subject: Re: [PATCH 4/5] [media] media-device: use kref for media_device
 instance
Message-ID: <20160317115053.GB11084@valkosipuli.retiisi.org.uk>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
 <82ef082c4de7c0a1c546da1d9e462bc86ab423bf.1458129823.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82ef082c4de7c0a1c546da1d9e462bc86ab423bf.1458129823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Mar 16, 2016 at 09:04:05AM -0300, Mauro Carvalho Chehab wrote:
> Now that the media_device can be used by multiple drivers,
> via devres, we need to be sure that it will be dropped only
> when all drivers stop using it.

Not long ago we split media device initialisation and registration into two.
The intent with that was to prevent users from seeing the media device until
all the initialisation is finished. I suppose that with dynamic updates, or
media device being shared with two drivers, it might be difficult to achieve
that. At least the method has to be different.

media_device_init() and media_device_cleanup() were a pair where the latter
undid the first. This patchs remove the requirement of calling cleanup
explitly, breaking that model. It's perhaps not a big problem, there is
likely no single driver which would initialise the media controller device
once but would register and unregister it multiple times. I still wonder if
we really lost something important if we removed media_device_init() and
media_device_cleanup() altogether and merged the functionality in
media_device_{,un}register().

Cc Javier who wrote the patch.

commit 9832e155f1ed3030fdfaa19e72c06472dc2ecb1d
Author: Javier Martinez Canillas <javier@osg.samsung.com>
Date:   Fri Dec 11 20:57:08 2015 -0200

    [media] media-device: split media initialization and registration

For system-wide media device, I think we'd need to introduce a new concept,
graph, that would define an interconnected set of entities. This would
mainly be needed for callbacks, e.g. the power on / off sequences of the
entities could be specific to V4L as discussed earlier. With this approach
hacks wouldn't be needed to be made in the first place to support two drivers
sharing a media device.

What was the original reason you needed to share the media device btw.?

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/media-device.c | 48 +++++++++++++++++++++++++++++++-------------
>  include/media/media-device.h |  3 +++
>  2 files changed, 37 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index c32fa15cc76e..38e6c319fe6e 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -721,6 +721,15 @@ int __must_check __media_device_register(struct media_device *mdev,
>  {
>  	int ret;
>  
> +	/* Check if mdev was ever registered at all */
> +	mutex_lock(&mdev->graph_mutex);
> +	if (media_devnode_is_registered(&mdev->devnode)) {
> +		kref_get(&mdev->kref);
> +		mutex_unlock(&mdev->graph_mutex);
> +		return 0;
> +	}
> +	kref_init(&mdev->kref);
> +
>  	/* Register the device node. */
>  	mdev->devnode.fops = &media_device_fops;
>  	mdev->devnode.parent = mdev->dev;
> @@ -730,8 +739,10 @@ int __must_check __media_device_register(struct media_device *mdev,
>  	mdev->topology_version = 0;
>  
>  	ret = media_devnode_register(&mdev->devnode, owner);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		media_devnode_unregister(&mdev->devnode);
>  		return ret;
> +	}
>  
>  	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
>  	if (ret < 0) {
> @@ -739,6 +750,7 @@ int __must_check __media_device_register(struct media_device *mdev,
>  		return ret;
>  	}
>  
> +	mutex_unlock(&mdev->graph_mutex);
>  	dev_dbg(mdev->dev, "Media device registered\n");
>  
>  	return 0;
> @@ -773,23 +785,15 @@ void media_device_unregister_entity_notify(struct media_device *mdev,
>  }
>  EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
>  
> -void media_device_unregister(struct media_device *mdev)
> +static void do_media_device_unregister(struct kref *kref)
>  {
> +	struct media_device *mdev;
>  	struct media_entity *entity;
>  	struct media_entity *next;
>  	struct media_interface *intf, *tmp_intf;
>  	struct media_entity_notify *notify, *nextp;
>  
> -	if (mdev == NULL)
> -		return;
> -
> -	mutex_lock(&mdev->graph_mutex);
> -
> -	/* Check if mdev was ever registered at all */
> -	if (!media_devnode_is_registered(&mdev->devnode)) {
> -		mutex_unlock(&mdev->graph_mutex);
> -		return;
> -	}
> +	mdev = container_of(kref, struct media_device, kref);
>  
>  	/* Remove all entities from the media device */
>  	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
> @@ -807,13 +811,26 @@ void media_device_unregister(struct media_device *mdev)
>  		kfree(intf);
>  	}
>  
> -	mutex_unlock(&mdev->graph_mutex);
> +	/* Check if mdev devnode was registered */
> +	if (!media_devnode_is_registered(&mdev->devnode))
> +		return;
>  
>  	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
>  	media_devnode_unregister(&mdev->devnode);
>  
>  	dev_dbg(mdev->dev, "Media device unregistered\n");
>  }
> +
> +void media_device_unregister(struct media_device *mdev)
> +{
> +	if (mdev == NULL)
> +		return;
> +
> +	mutex_lock(&mdev->graph_mutex);
> +	kref_put(&mdev->kref, do_media_device_unregister);
> +	mutex_unlock(&mdev->graph_mutex);
> +
> +}
>  EXPORT_SYMBOL_GPL(media_device_unregister);
>  
>  static void media_device_release_devres(struct device *dev, void *res)
> @@ -825,13 +842,16 @@ struct media_device *media_device_get_devres(struct device *dev)
>  	struct media_device *mdev;
>  
>  	mdev = devres_find(dev, media_device_release_devres, NULL, NULL);
> -	if (mdev)
> +	if (mdev) {
> +		kref_get(&mdev->kref);
>  		return mdev;
> +	}
>  
>  	mdev = devres_alloc(media_device_release_devres,
>  				sizeof(struct media_device), GFP_KERNEL);
>  	if (!mdev)
>  		return NULL;
> +
>  	return devres_get(dev, mdev, NULL, NULL);
>  }
>  EXPORT_SYMBOL_GPL(media_device_get_devres);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index ca3871b853ba..73c16e6e6b6b 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -23,6 +23,7 @@
>  #ifndef _MEDIA_DEVICE_H
>  #define _MEDIA_DEVICE_H
>  
> +#include <linux/kref.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>
>  
> @@ -283,6 +284,7 @@ struct media_entity_notify {
>   * struct media_device - Media device
>   * @dev:	Parent device
>   * @devnode:	Media device node
> + * @kref:	Object refcount
>   * @driver_name: Optional device driver name. If not set, calls to
>   *		%MEDIA_IOC_DEVICE_INFO will return dev->driver->name.
>   *		This is needed for USB drivers for example, as otherwise
> @@ -347,6 +349,7 @@ struct media_device {
>  	/* dev->driver_data points to this struct. */
>  	struct device *dev;
>  	struct media_devnode devnode;
> +	struct kref kref;
>  
>  	char model[32];
>  	char driver_name[32];
> -- 
> 2.5.0
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
