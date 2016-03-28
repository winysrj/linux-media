Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58770 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbcC1VeS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 17:34:18 -0400
Subject: Re: [RFC PATCH 1/4] media: Add Media Device Allocator API
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1458966594.git.shuahkh@osg.samsung.com>
 <41d017ef76e3206780c018399ec60b63d865f65c.1458966594.git.shuahkh@osg.samsung.com>
 <20160328152831.6f2ef88d@recife.lan>
Cc: laurent.pinchart@ideasonboard.com, perex@perex.cz, tiwai@suse.com,
	hans.verkuil@cisco.com, chehabrafael@gmail.com,
	javier@osg.samsung.com, jh1009.sung@samsung.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56F9A357.6050107@osg.samsung.com>
Date: Mon, 28 Mar 2016 15:34:15 -0600
MIME-Version: 1.0
In-Reply-To: <20160328152831.6f2ef88d@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/28/2016 12:28 PM, Mauro Carvalho Chehab wrote:
> Hi Shuah,
> 
> I reviewed the entire patch series, but I'm adding the comments only here,
> as the other patches are coherent with this one.

That is fine.

> 
> Em Fri, 25 Mar 2016 22:38:42 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Add Media Device Allocator API to manage Media Device life time problems.
>> There are known problems with media device life time management. When media
>> device is released while an media ioctl is in progress, ioctls fail with
>> use-after-free errors and kernel hangs in some cases.
>>
>> Media Allocator API provides interfaces to allocate a refcounted media
>> device from system wide global list and maintains the state until the
>> last user of the media device releases it.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/Makefile              |   3 +-
>>  drivers/media/media-dev-allocator.c | 153 ++++++++++++++++++++++++++++++++++++
>>  include/media/media-dev-allocator.h |  81 +++++++++++++++++++
>>  3 files changed, 236 insertions(+), 1 deletion(-)
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
>> index 0000000..51edc49
>> --- /dev/null
>> +++ b/drivers/media/media-dev-allocator.c
>> @@ -0,0 +1,153 @@
>> +/*
>> + * media-devkref.c - Media Controller Device Allocator API
>> + *
>> + * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
>> + * Copyright (c) 2016 Samsung Electronics Co., Ltd.
>> + *
>> + * This file is released under the GPLv2.
>> + * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> + */
>> +
>> +/*
>> + * This file adds Media Controller Device Instance with
>> + * Kref support. A system wide global media device list
>> + * is managed and each  media device is refcounted. The
>> + * last put on the media device releases the media device
>> + * instance.
>> +*/
>> +
>> +#ifdef CONFIG_MEDIA_CONTROLLER
> 
> No need for an ifdef here. This file will be compiled only
> if CONFIG_MEDIA_CONTROLLER, as you added it for media.ko
> dependencies at the Makefile.

Right. I will remove it.

> 
>> +
>> +#include <linux/slab.h>
>> +#include <linux/kref.h>
>> +#include <media/media-device.h>
>> +
>> +static LIST_HEAD(media_device_list);
>> +static LIST_HEAD(media_device_to_delete_list);
>> +static DEFINE_MUTEX(media_device_lock);
>> +
>> +struct media_device_instance {
>> +	struct media_device mdev;
>> +	struct list_head list;
>> +	struct list_head to_delete_list;
>> +	struct device *dev;
>> +	struct kref refcount;
> 
>> +	bool to_delete; /* should be set when devnode is deleted */
> 
> I don't think this is needed.

This is necessary to handle race condition between ioctls and media
device unregister. Consider the case where the driver does unregister
while application has the device open and ioctl is in progress. In this
case, media device should not be released until the application exits
with an error detecting media device has been unregistered. All ioctls
check for this condition.

A second issue is if the media device isn't free'd, a subsequent driver
bind finds the media device that is still in the list. So this flag is
used to move the media device instance to a second to be deleted list.
We do have to make sure the media device gets deleted from this to be
deleted list in the cases when the applications dies without releasing
the reference to the media device which triggers the put.

When more than one driver is in play (e.g: au0828 and snd_usb_audio),
it is necessary to keep track of how many drivers are associated with
the media device. So we need a second kref in to do that. I saw your
comment on RFC PATCH 3/4 about embedding kref in struct media_device.
I could add another kref to the media device instance to keep track
of registrations to trigger unregister.

> 
>> +};
>> +
>> +static struct media_device *__media_device_get(struct device *dev,
>> +					       bool alloc, bool kref)
>> +{
> 
> Please don't use "kref" for a boolean here. Makes it confusing, as reviewers
> would expect "kref" to be of "struct kref" type.
> 
> Also, alloc seems to be a bad name for the other bool.
> 
> Maybe you could call them as "do_alloc" and "create_kref".

Yes. Agreed. I changed the names.

> 
>> +	struct media_device_instance *mdi;
>> +
>> +	mutex_lock(&media_device_lock);
>> +
>> +	list_for_each_entry(mdi, &media_device_list, list) {
>> +		if (mdi->dev == dev) {
>> +			if (kref) {
>> +				kref_get(&mdi->refcount);
>> +				pr_info("%s: mdev=%p\n", __func__, &mdi->mdev);
>> +			}
>> +			goto done;
>> +		}
>> +	}
>> +
>> +	if (!alloc) {
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
>> +	pr_info("%s: mdev=%p\n", __func__, &mdi->mdev);
>> +
>> +done:
>> +	mutex_unlock(&media_device_lock);
>> +
>> +	return mdi ? &mdi->mdev : NULL;
>> +}
>> +
>> +struct media_device *media_device_get(struct device *dev)
>> +{
>> +	pr_info("%s\n", __func__);
>> +	return __media_device_get(dev, true, true);
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_get);
>> +
>> +/* Don't increment kref - this is a search and find */
>> +struct media_device *media_device_find(struct device *dev)
>> +{
>> +	pr_info("%s\n", __func__);
>> +	return __media_device_get(dev, false, false);
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_find);
>> +
>> +/* don't allocate - increment kref if one is found */
>> +struct media_device *media_device_get_ref(struct device *dev)
>> +{
>> +	pr_info("%s\n", __func__);
>> +	return __media_device_get(dev, false, true);
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_get_ref);
>> +
>> +static void media_device_instance_release(struct kref *kref)
>> +{
>> +	struct media_device_instance *mdi =
>> +		container_of(kref, struct media_device_instance, refcount);
>> +
>> +	pr_info("%s: mdev=%p\n", __func__, &mdi->mdev);
>> +
>> +	list_del(&mdi->list);
>> +	kfree(mdi);
>> +}
>> +
>> +void media_device_put(struct device *dev)
>> +{
>> +	struct media_device_instance *mdi;
>> +
>> +	mutex_lock(&media_device_lock);
>> +	/* search first in the media_device_list */
>> +	list_for_each_entry(mdi, &media_device_list, list) {
>> +		if (mdi->dev == dev) {
>> +			pr_info("%s: mdev=%p\n", __func__, &mdi->mdev);
>> +			kref_put(&mdi->refcount, media_device_instance_release);
>> +			goto done;
>> +		}
>> +	}
>> +	/* search in the media_device_to_delete_list */
>> +	list_for_each_entry(mdi, &media_device_to_delete_list, to_delete_list) {
>> +		if (mdi->dev == dev) {
>> +			pr_info("%s: mdev=%p\n", __func__, &mdi->mdev);
>> +			kref_put(&mdi->refcount, media_device_instance_release);
>> +			goto done;
>> +		}
>> +	}
>> +done:
>> +	mutex_unlock(&media_device_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_put);
> 
> You also need something to initialize the kref for places where
> the struct media_device is embedded, or to convert all of them to use
> dynamically-allocated media_device structs.

Yes. I think we need to convert all drivers to use the media device
allocator. That is the only way to solve the ioctl problems.

> 
>> +
>> +void media_device_set_to_delete_state(struct device *dev)
>> +{
>> +	struct media_device_instance *mdi;
>> +
>> +	mutex_lock(&media_device_lock);
>> +	list_for_each_entry(mdi, &media_device_list, list) {
>> +		if (mdi->dev == dev) {
>> +			pr_info("%s: mdev=%p\n", __func__, &mdi->mdev);
>> +			mdi->to_delete = true;
>> +			list_move(&mdi->list, &media_device_to_delete_list);
>> +			goto done;
>> +		}
>> +	}
>> +done:
>> +	mutex_unlock(&media_device_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_set_to_delete_state);
>> +
>> +#endif /* CONFIG_MEDIA_CONTROLLER */
>> diff --git a/include/media/media-dev-allocator.h b/include/media/media-dev-allocator.h
>> new file mode 100644
>> index 0000000..2932c90
>> --- /dev/null
>> +++ b/include/media/media-dev-allocator.h
>> @@ -0,0 +1,81 @@
>> +/*
>> + * media-devkref.c - Media Controller Device Allocator API
>> + *
>> + * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
>> + * Copyright (c) 2016 Samsung Electronics Co., Ltd.
>> + *
>> + * This file is released under the GPLv2.
>> + * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> + */
>> +
>> +/*
>> + * This file adds Media Controller Device Instance with Kref support.
>> + * A system wide global media device list is managed and each media
>> + * device is refcounted. The last put on the media device releases
>> + * the media device instance.
>> +*/
>> +
>> +#ifndef _MEDIA_DEV_ALLOCTOR_H
>> +#define _MEDIA_DEV_ALLOCTOR_H
>> +
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +/**
>> + * media_device_get() - Allocate and return global media device
>> + *
>> + * @mdev
>> + *
>> + * This interface should be called to allocate media device. A new media
>> + * device instance is created and added to the system wide media device
>> + * instance list. If media device instance exists, media_device_get()
>> + * increments the reference count and returns the media device. When
>> + * more than one driver control the media device, the first driver to
>> + * probe will allocate and the second driver when it calls media_device_get()
>> + * it will get a reference.
>> + *
>> + */
>> +struct media_device *media_device_get(struct device *dev);
>> +/**
>> + * media_device_get_ref() - Get reference to an allocated and registered
>> + *			    media device.
>> + *
>> + * @mdev
>> + *
>> + * This interface should be called to get a reference to an allocated media
>> + * device. media_open() ioctl should call this to hold a reference to ensure
>> + * the media device will not be released until the media_release() does a put
>> + * on it.
>> + */
>> +struct media_device *media_device_get_ref(struct device *dev);
>> +/**
>> + * media_device_find() - Find an allocated and registered media device.
>> + *
>> + * @mdev
>> + *
>> + * This interface should be called to find a media device. This will not
>> + * incremnet the reference count.
>> + */
>> +struct media_device *media_device_find(struct device *dev);
>> +/**
>> + * media_device_put() - Release refcounted media device. Calls kref_put()
>> + *
>> + * @mdev
>> + *
>> + * This interface should be called to decrement refcount.
>> + */
>> +void media_device_put(struct device *dev);
>> +/**
>> + * media_device_set_to_delete_state() - Set the state to be deleted.
>> + *
>> + * @mdev
>> + *
>> + * This interface is used to not release the media device under from
>> + * an active ioctl if unregister happens.
>> + */
>> +void media_device_set_to_delete_state(struct device *dev);
>> +#else
>> +struct media_device *media_device_get(struct device *dev) { return NULL; }
>> +struct media_device *media_device_find(struct device *dev) { return NULL; }
>> +void media_device_put(struct media_device *mdev) { }
>> +void media_device_set_to_delete_state(struct device *dev) { }
>> +#endif /* CONFIG_MEDIA_CONTROLLER */
>> +#endif
> 
> 

thanks,
-- Shuah

