Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38251 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497AbcEXRFm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 13:05:42 -0400
Subject: Re: [PATCH 1/3] media: Media Device Allocator API
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	hans.verkuil@cisco.com, chehabrafael@gmail.com,
	javier@osg.samsung.com, inki.dae@samsung.com,
	g.liakhovetski@gmx.de, jh1009.sung@samsung.com
References: <cover.1463158822.git.shuahkh@osg.samsung.com>
 <efdba25cd9ad3b5fa025ed91613921641058a727.1463158822.git.shuahkh@osg.samsung.com>
 <5742E8CC.2060806@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <574489E3.40506@osg.samsung.com>
Date: Tue, 24 May 2016 11:05:39 -0600
MIME-Version: 1.0
In-Reply-To: <5742E8CC.2060806@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/23/2016 05:26 AM, Hans Verkuil wrote:
> Hi Shuah,
> 
> Some comments below:

Thanks for the review.

> 
> On 05/13/2016 07:09 PM, Shuah Khan wrote:
>> Media Device Allocator API to allows multiple drivers share a media device.
>> Using this API, drivers can allocate a media device with the shared struct
>> device as the key. Once the media device is allocated by a driver, other
>> drivers can get a reference to it. The media device is released when all
>> the references are released.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/Makefile              |   3 +-
>>  drivers/media/media-dev-allocator.c | 139 ++++++++++++++++++++++++++++++++++++
>>  include/media/media-dev-allocator.h | 118 ++++++++++++++++++++++++++++++
>>  3 files changed, 259 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/media/media-dev-allocator.c
>>  create mode 100644 include/media/media-dev-allocator.h
>>
>> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
>> index e608bbc..b08f091 100644
>> --- a/drivers/media/Makefile
>> +++ b/drivers/media/Makefile
>> @@ -2,7 +2,8 @@
>>  # Makefile for the kernel multimedia device drivers.
>>  #
>>  
>> -media-objs	:= media-device.o media-devnode.o media-entity.o
>> +media-objs	:= media-device.o media-devnode.o media-entity.o \
>> +		   media-dev-allocator.o
>>  
>>  #
>>  # I2C drivers should come before other drivers, otherwise they'll fail
>> diff --git a/drivers/media/media-dev-allocator.c b/drivers/media/media-dev-allocator.c
>> new file mode 100644
>> index 0000000..b49ab55
>> --- /dev/null
>> +++ b/drivers/media/media-dev-allocator.c
>> @@ -0,0 +1,139 @@
>> +/*
>> + * media-dev-allocator.c - Media Controller Device Allocator API
>> + *
>> + * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
>> + * Copyright (c) 2016 Samsung Electronics Co., Ltd.
>> + *
>> + * This file is released under the GPLv2.
>> + * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> + */
>> +
>> +/*
>> + * This file adds a global refcounted Media Controller Device Instance API.
>> + * A system wide global media device list is managed and each media device
>> + * includes a kref count. The last put on the media device releases the media
>> + * device instance.
>> + *
>> +*/
>> +
>> +#include <linux/slab.h>
>> +#include <linux/kref.h>
>> +#include <linux/usb.h>
>> +#include <media/media-device.h>
>> +
>> +static LIST_HEAD(media_device_list);
>> +static DEFINE_MUTEX(media_device_lock);
>> +
>> +struct media_device_instance {
>> +	struct media_device mdev;
>> +	struct list_head list;
>> +	struct device *dev;
>> +	struct kref refcount;
>> +};
>> +
>> +static inline struct media_device_instance *
>> +to_media_device_instance(struct media_device *mdev)
>> +{
>> +	return container_of(mdev, struct media_device_instance, mdev);
>> +}
>> +
>> +static void media_device_instance_release(struct kref *kref)
>> +{
>> +	struct media_device_instance *mdi =
>> +		container_of(kref, struct media_device_instance, refcount);
>> +
>> +	dev_dbg(mdi->mdev.dev, "%s: mdev=%p\n", __func__, &mdi->mdev);
>> +
>> +	mutex_lock(&media_device_lock);
>> +
>> +	media_device_unregister(&mdi->mdev);
>> +	media_device_cleanup(&mdi->mdev);
>> +
>> +	list_del(&mdi->list);
>> +	mutex_unlock(&media_device_lock);
>> +
>> +	kfree(mdi);
>> +}
>> +
>> +static struct media_device *__media_device_get(struct device *dev,
>> +					       bool allocate)
>> +{
>> +	struct media_device_instance *mdi;
>> +
>> +	mutex_lock(&media_device_lock);
>> +
>> +	list_for_each_entry(mdi, &media_device_list, list) {
>> +		if (mdi->dev == dev) {
>> +			kref_get(&mdi->refcount);
>> +			dev_dbg(dev, "%s: get mdev=%p\n",
>> +				 __func__, &mdi->mdev);
>> +			goto done;
>> +		}
>> +	}
>> +
>> +	if (!allocate) {
>> +		mdi = NULL;
>> +		goto done;
>> +	}
>> +
>> +	mdi = kzalloc(sizeof(*mdi), GFP_KERNEL);
>> +	if (!mdi)
>> +		goto done;
>> +
>> +	mdi->dev = dev;
>> +	kref_init(&mdi->refcount);
>> +	list_add_tail(&mdi->list, &media_device_list);
>> +
>> +	dev_dbg(dev, "%s: alloc mdev=%p\n", __func__, &mdi->mdev);
>> +
>> +done:
>> +	mutex_unlock(&media_device_lock);
>> +
>> +	return mdi ? &mdi->mdev : NULL;
>> +}
>> +
>> +struct media_device *media_device_allocate(struct device *dev)
>> +{
>> +	dev_dbg(dev, "%s\n", __func__);
>> +	return __media_device_get(dev, true);
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_allocate);
> 
> Do we need this function? Whenever a media device is allocated, you also need
> to initialize the media device with the media_device_lock held (as happens
> below in media_device_usb_allocate). You can't really use this function
> standalone as far as I can see.
> 
> An alternative might be to pass a callback function with media_device_allocate
> that initialized the media device. That would ensure that there are no race
> conditions since media_device_allocate can lock media_device_lock before
> calling the callback.

You are right, it is not used and all the usb drivers will use the
media_device_usb_allocate() and for pci drivers that have the need
to share the media device, we could add media_device_pci_allocate().
I think deleting this and collapsing the logic media_device_usb_allocate()
will help with the locking as well. I will fix this. I can delete this
routine all together and make some changes to __media_device_get() to
expect to be called media_device_lock held. That should work well.

> 
>> +
>> +struct media_device *media_device_usb_allocate(struct usb_device *udev,
>> +					       char *driver_name)
>> +{
>> +	struct media_device *mdev;
>> +
>> +	mdev = media_device_allocate(&udev->dev);
>> +	if (!mdev)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	/* check if media device is already initialized */
>> +	mutex_lock(&media_device_lock);
>> +	if (!mdev->dev)
>> +		__media_device_usb_init(mdev, udev, udev->product,
>> +					driver_name);
>> +	mutex_unlock(&media_device_lock);
>> +
>> +	return mdev;
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_usb_allocate);
>> +
>> +/* don't allocate - get reference if one is found */
>> +struct media_device *media_device_get(struct media_device *mdev)
>> +{
>> +	struct media_device_instance *mdi = to_media_device_instance(mdev);
>> +
>> +	dev_dbg(mdi->mdev.dev, "%s: mdev=%p\n", __func__, &mdi->mdev);
>> +	return __media_device_get(mdi->dev, false);
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_get);
> 
> Do we need this anywhere? It makes no sense to call this standalone, at least, not
> that I can see. You just have different drivers that all call media_device_usb_allocate,
> and they also call media_device_put when they are done with it. See also my comments
> for the next patch.

You are right. It was needed when I originally did this patch series
and used this to fix the lifetime issue. media_device_get() used to
get called from media_device_open() and media_device_put() from
media_device_close(). I left it in there just in case, there is a
need to get a reference, but I think it can be added later when the
need arises. I will delete this.

>> +
>> +void media_device_put(struct media_device *mdev)
>> +{
>> +	struct media_device_instance *mdi = to_media_device_instance(mdev);
>> +
>> +	dev_dbg(mdi->mdev.dev, "%s: mdev=%p\n", __func__, &mdi->mdev);
>> +	kref_put(&mdi->refcount, media_device_instance_release);
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_put);
>> diff --git a/include/media/media-dev-allocator.h b/include/media/media-dev-allocator.h
>> new file mode 100644
>> index 0000000..a63dfc6
>> --- /dev/null
>> +++ b/include/media/media-dev-allocator.h
>> @@ -0,0 +1,118 @@
>> +/*
>> + * media-dev-allocator.h - Media Controller Device Allocator API
>> + *
>> + * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
>> + * Copyright (c) 2016 Samsung Electronics Co., Ltd.
>> + *
>> + * This file is released under the GPLv2.
>> + * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> + */
>> +
>> +/*
>> + * This file adds a global ref-counted Media Controller Device Instance API.
>> + * A system wide global media device list is managed and each media device
>> + * includes a kref count. The last put on the media device releases the media
>> + * device instance.
>> +*/
>> +
>> +#ifndef _MEDIA_DEV_ALLOCTOR_H
>> +#define _MEDIA_DEV_ALLOCTOR_H
>> +
>> +struct usb_device;
>> +
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +/**
>> + * DOC: Media Controller Device Allocator API
>> + *
>> + * When media device belongs to more than one driver, the shared media device
>> + * is allocated with the shared struct device as the key for look ups.
>> + *
>> + * Shared media device should stay in registered state until the last driver
>> + * unregisters it. In addition, media device should be released when all the
>> + * references are released. Each driver gets a reference to the media device
>> + * during probe, when it allocates the media device. If media device is already
>> + * allocated, allocate API bumps up the refcount and return the existing media
>> + * device. Driver puts the reference back from its disconnect routine when it
>> + * calls media_device_unregister_put().
>> + *
>> + * Media device is unregistered and cleaned up from the kref put handler to
>> + * ensure that the media device stays in registered state until the last driver
>> + * unregisters the media device.
>> + *
>> + * Media Device can be in any the following states:
>> + *
>> + * - Allocated
> 
> I don't think this is a real state. It's either unregistered or allocated and
> registered. Just 'allocated' doesn't really make sense. This ties in to my
> comment about media_device_allocate().
> 
>> + * - Registered (could be tied to more than one driver)
>> + * - Unregistered and released in the kref put handler.
> 
> I would probably drop these 5 lines altogether.
> 
>> + *
>> + * Driver Usage:
>> + *
>> + * Drivers should use the media-core routines to get register reference and
>> + * use the media_device_unregister_put() routine to make sure the shared
>> + * media device delete is handled correctly.
>> + *
>> + * driver probe:
>> + *	Call media_device_usb_allocate() to allocate or get a reference
>> + *	Call media_device_register(), if media devnode isn't registered
>> + *
>> + * driver disconnect:
>> + *	Call media_device_unregister_put() to put the reference.
> 
> There is no media_device_unregister_put() (yet). That should be in the
> next patch.
> 
>> + *
>> + */
>> +
>> +/**
>> + * media_device_usb_allocate() - Allocate and return media device
>> + *
>> + * @udev - struct usb_device pointer
>> + * @driver_name
>> + *
>> + * This interface should be called to allocate a media device when multiple
>> + * drivers share usb_device and the media device. This interface allocates
>> + * media device and calls media_device_usb_init() to initialize it.
>> + *
>> + */
>> +struct media_device *media_device_usb_allocate(struct usb_device *udev,
>> +					       char *driver_name);
>> +/**
>> + * media_device_allocate() - Allocate and return global media device
>> + *
>> + * @dev - struct device pointer
>> + *
>> + * This interface should be called to allocate media device. A new media
>> + * device instance is created and added to the system wide media device
>> + * instance list. If media device instance exists, media_device_allocate()
>> + * increments the reference count and returns the media device. When more
>> + * than one driver control the media device, the first driver to probe will
>> + * allocate and the second driver when it calls  media_device_allocate(),
>> + * it will get a reference.
>> + *
>> + */
>> +struct media_device *media_device_allocate(struct device *dev);
>> +/**
>> + * media_device_get() -	Get reference to a registered media device.
>> + *
>> + * @mdev - struct media_device pointer
>> + *
>> + * This interface should be called to get a reference to an allocated media
>> + * device.
>> + */
>> +struct media_device *media_device_get(struct media_device *mdev);
>> +/**
>> + * media_device_put() - Release media device. Calls kref_put().
>> + *
>> + * @mdev - struct media_device pointer
>> + *
>> + * This interface should be called to put Media Device Instance kref.
>> + */
>> +void media_device_put(struct media_device *mdev);
>> +#else
>> +static inline struct media_device *media_device_usb_allocate(
>> +			struct usb_device *udev, char *driver_name)
>> +			{ return NULL; }
>> +static inline struct media_device *media_device_allocate(struct device *dev)
>> +			{ return NULL; }
>> +static inline struct media_device *media_device_get(struct media_device *mdev)
>> +			{ return NULL; }
>> +static inline void media_device_put(struct media_device *mdev) { }
>> +#endif /* CONFIG_MEDIA_CONTROLLER */
>> +#endif
>>
> 
> Regards,
> 
> 	Hans
> 

