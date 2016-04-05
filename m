Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33685 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbcDEQX4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2016 12:23:56 -0400
Date: Tue, 5 Apr 2016 09:23:52 -0700
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: laurent.pinchart@ideasonboard.com, perex@perex.cz, tiwai@suse.com,
	hans.verkuil@cisco.com, chehabrafael@gmail.com,
	javier@osg.samsung.com, jh1009.sung@samsung.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [RFC PATCH 3/4] media: Add refcount to keep track of media
 device registrations
Message-ID: <20160405092352.2a3c4509@vela.lan>
In-Reply-To: <56F9A427.9060400@osg.samsung.com>
References: <cover.1458966594.git.shuahkh@osg.samsung.com>
	<dd4a411224763aa8a8e83ba43e2fbf668c2ba15f.1458966594.git.shuahkh@osg.samsung.com>
	<20160328152841.64b99e42@recife.lan>
	<56F9A427.9060400@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Mar 2016 15:37:43 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 03/28/2016 12:28 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 25 Mar 2016 22:38:44 -0600
> > Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> >   
> >> Add refcount to keep track of media device registrations to avoid release
> >> of media device when one of the drivers does unregister when media device
> >> belongs to more than one driver. Also add a new interfaces to unregister
> >> a media device allocated using Media Device Allocator and a hold register
> >> refcount. Change media_open() to get media device reference and put the
> >> reference in media_release().
> >>
> >> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> >> ---
> >>  drivers/media/media-device.c  | 53 +++++++++++++++++++++++++++++++++++++++++++
> >>  drivers/media/media-devnode.c |  3 +++
> >>  include/media/media-device.h  | 32 ++++++++++++++++++++++++++
> >>  3 files changed, 88 insertions(+)
> >>
> >> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> >> index 93aff4e..3359235 100644
> >> --- a/drivers/media/media-device.c
> >> +++ b/drivers/media/media-device.c
> >> @@ -36,6 +36,7 @@
> >>  #include <media/media-device.h>
> >>  #include <media/media-devnode.h>
> >>  #include <media/media-entity.h>
> >> +#include <media/media-dev-allocator.h>
> >>  
> >>  #ifdef CONFIG_MEDIA_CONTROLLER
> >>  
> >> @@ -702,6 +703,7 @@ void media_device_init(struct media_device *mdev)
> >>  	INIT_LIST_HEAD(&mdev->entity_notify);
> >>  	mutex_init(&mdev->graph_mutex);
> >>  	ida_init(&mdev->entity_internal_idx);
> >> +	kref_init(&mdev->refcount);
> >>  
> >>  	dev_dbg(mdev->dev, "Media device initialized\n");
> >>  }
> >> @@ -730,6 +732,13 @@ printk("%s: mdev %p\n", __func__, mdev);
> >>  	/* Check if mdev was ever registered at all */
> >>  	mutex_lock(&mdev->graph_mutex);
> >>  
> >> +	/* if media device is already registered, bump the register refcount */
> >> +	if (media_devnode_is_registered(&mdev->devnode)) {
> >> +		kref_get(&mdev->refcount);
> >> +		mutex_unlock(&mdev->graph_mutex);
> >> +		return 0;
> >> +	}
> >> +
> >>  	/* Register the device node. */
> >>  	mdev->devnode.fops = &media_device_fops;
> >>  	mdev->devnode.parent = mdev->dev;
> >> @@ -756,6 +765,22 @@ err:
> >>  }
> >>  EXPORT_SYMBOL_GPL(__media_device_register);
> >>  
> >> +void media_device_register_ref(struct media_device *mdev)
> >> +{
> >> +	if (!mdev)
> >> +		return;
> >> +
> >> +	pr_info("%s: mdev %p\n", __func__, mdev);
> >> +	mutex_lock(&mdev->graph_mutex);
> >> +
> >> +	/* Check if mdev is registered - bump registered refcount */
> >> +	if (media_devnode_is_registered(&mdev->devnode))
> >> +		kref_get(&mdev->refcount);
> >> +
> >> +	mutex_unlock(&mdev->graph_mutex);
> >> +}
> >> +EXPORT_SYMBOL_GPL(media_device_register_ref);
> >> +
> >>  int __must_check media_device_register_entity_notify(struct media_device *mdev,
> >>  					struct media_entity_notify *nptr)
> >>  {
> >> @@ -829,6 +854,34 @@ printk("%s: mdev=%p\n", __func__, mdev);
> >>  }
> >>  EXPORT_SYMBOL_GPL(media_device_unregister);
> >>  
> >> +static void __media_device_unregister_kref(struct kref *kref)
> >> +{
> >> +	struct media_device *mdev;
> >> +
> >> +	mdev = container_of(kref, struct media_device, refcount);
> >> +	__media_device_unregister(mdev);
> >> +}
> >> +
> >> +void media_device_unregister_put(struct media_device *mdev)
> >> +{
> >> +	int ret;
> >> +
> >> +	if (mdev == NULL)
> >> +		return;
> >> +
> >> +	pr_info("%s: mdev=%p\n", __func__, mdev);
> >> +	ret = kref_put_mutex(&mdev->refcount, __media_device_unregister_kref,
> >> +			     &mdev->graph_mutex);
> >> +	if (ret) {
> >> +		/* __media_device_unregister() ran */
> >> +		__media_device_cleanup(mdev);
> >> +		mutex_unlock(&mdev->graph_mutex);
> >> +		mutex_destroy(&mdev->graph_mutex);
> >> +		media_device_set_to_delete_state(mdev->dev);  
> > 
> > Where you're freeing the media_dev (or its container struct)?
> > 
> > You need to be sure that it will be freed only here.  
> 
> This step doesn't free the media device. It simply move it from
> the main media device instance list to the to be deleted list.
> 
> This is necessary to handle race condition between ioctls and media
> device unregister. Consider the case where the driver does unregister
> while application has the device open and ioctl is in progress.

This can never happen, provided that the data is properly locked.

And if it is not locked, there will be other race issues.

> In this
> case, media device should not be released until the application exits
> with an error detecting media device has been unregistered. All ioctls
> check for this condition.
> 
> A second issue is if the media device isn't free'd, a subsequent driver
> bind finds the media device that is still in the list. So this flag is
> used to move the media device instance to a second to be deleted list.
> We do have to make sure the media device gets deleted from this to be
> deleted list in the cases when the applications dies without releasing
> the reference to the media device which triggers the put.

See my previous e-mail.

> 
> >   
> >> +	}
> >> +}
> >> +EXPORT_SYMBOL_GPL(media_device_unregister_put);
> >> +
> >>  static void media_device_release_devres(struct device *dev, void *res)
> >>  {
> >>  }
> >> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> >> index 29409f4..d1d1263 100644
> >> --- a/drivers/media/media-devnode.c
> >> +++ b/drivers/media/media-devnode.c
> >> @@ -44,6 +44,7 @@
> >>  #include <linux/uaccess.h>
> >>  
> >>  #include <media/media-devnode.h>
> >> +#include <media/media-dev-allocator.h>
> >>  
> >>  #define MEDIA_NUM_DEVICES	256
> >>  #define MEDIA_NAME		"media"
> >> @@ -186,6 +187,7 @@ static int media_open(struct inode *inode, struct file *filp)
> >>  		}
> >>  	}
> >>  
> >> +	media_device_get_ref(mdev->parent);
> >>  	return 0;
> >>  }
> >>  
> >> @@ -201,6 +203,7 @@ static int media_release(struct inode *inode, struct file *filp)
> >>  	   return value is ignored. */
> >>  	put_device(&mdev->dev);
> >>  	filp->private_data = NULL;
> >> +	media_device_put(mdev->parent);
> >>  	return 0;
> >>  }
> >>  
> >> diff --git a/include/media/media-device.h b/include/media/media-device.h
> >> index e59772e..64114ae 100644
> >> --- a/include/media/media-device.h
> >> +++ b/include/media/media-device.h
> >> @@ -284,6 +284,8 @@ struct media_entity_notify {
> >>   * struct media_device - Media device
> >>   * @dev:	Parent device
> >>   * @devnode:	Media device node
> >> + * @refcount:	Media device register reference count. Used when more
> >> + *		than one driver owns the device.
> >>   * @driver_name: Optional device driver name. If not set, calls to
> >>   *		%MEDIA_IOC_DEVICE_INFO will return dev->driver->name.
> >>   *		This is needed for USB drivers for example, as otherwise
> >> @@ -348,6 +350,7 @@ struct media_device {
> >>  	/* dev->driver_data points to this struct. */
> >>  	struct device *dev;
> >>  	struct media_devnode devnode;
> >> +	struct kref refcount;  
> > 
> > You can't simply embed a kref at media_device. The problem is that
> > several conditions should be met for this approach to work:
> > 
> > 1) The structs that have struct media_device should not have a kref
> > their own (I guess that's the current case, but it should be documented
> > somewhere);
> > 
> > 2) the struct that embeds it can only be destroyed when kref refcount
> > reaches zero. That actually means that the core should either allocate
> > the struct itself or that a release callback for those structs should
> > do the kfree(). It means that all drivers should be changed for it to
> > happen.
> > 
> > Also, if you're adding a kref here, you likely should not have a kref
> > at struct media_device_instance(), as there's no need for two kref
> > destroy logic.  
> 
> When more than one driver is in play (e.g: au0828 and snd_usb_audio),
> it is necessary to keep track of how many drivers are associated with
> the media device. So we need a second kref in to do that.

Why two krefs? It is one struct that needs to be tracked, so just one
kref should be enough. 

> 
> I could add another kref to the media device instance to keep track
> of registrations to trigger unregister.

No! don't add lots of kref. Just one is enough. Complex solutions won't make
it any better.

> >   
> >>  
> >>  	char model[32];
> >>  	char driver_name[32];
> >> @@ -501,6 +504,17 @@ int __must_check __media_device_register(struct media_device *mdev,
> >>  #define media_device_register(mdev) __media_device_register(mdev, THIS_MODULE)
> >>  
> >>  /**
> >> + * media_device_register_ref() - Increments media device register refcount
> >> + *
> >> + * @mdev:	pointer to struct &media_device
> >> + *
> >> + * When more than one driver is associated with the media device, it is
> >> + * necessary to refcount the number of registrations to avoid unregister
> >> + * when it is still in use.
> >> + */
> >> +void media_device_register_ref(struct media_device *mdev);
> >> +
> >> +/**
> >>   * media_device_unregister() - Unregisters a media device element
> >>   *
> >>   * @mdev:	pointer to struct &media_device
> >> @@ -512,6 +526,18 @@ int __must_check __media_device_register(struct media_device *mdev,
> >>  void media_device_unregister(struct media_device *mdev);
> >>  
> >>  /**
> >> + * media_device_unregister_put() - Unregisters a media device element
> >> + *
> >> + * @mdev:	pointer to struct &media_device
> >> + *
> >> + * Should be called to unregister media device allocated with Media Device
> >> + * Allocator API media_device_get() interface.
> >> + * It is safe to call this function on an unregistered (but initialised)
> >> + * media device.
> >> + */
> >> +void media_device_unregister_put(struct media_device *mdev);
> >> +
> >> +/**
> >>   * media_device_register_entity() - registers a media entity inside a
> >>   *	previously registered media device.
> >>   *
> >> @@ -681,9 +707,15 @@ static inline int media_device_register(struct media_device *mdev)
> >>  {
> >>  	return 0;
> >>  }
> >> +static inline void media_device_register_ref(struct media_device *mdev)
> >> +{
> >> +}
> >>  static inline void media_device_unregister(struct media_device *mdev)
> >>  {
> >>  }
> >> +static inline void media_device_unregister_put(struct media_device *mdev)
> >> +{
> >> +}
> >>  static inline int media_device_register_entity(struct media_device *mdev,
> >>  						struct media_entity *entity)
> >>  {  
> > 
> >   
> 
> thanks,
> -- Shuah
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
