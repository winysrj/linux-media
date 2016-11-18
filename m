Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53425
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751020AbcKRBum (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 20:50:42 -0500
Subject: Re: [PATCH v4 1/3] media: Media Device Allocator API
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <cover.1479271294.git.shuahkh@osg.samsung.com>
 <448169cd2db0ba7c8a455bd672e6709e6bada2aa.1479271294.git.shuahkh@osg.samsung.com>
 <20161117231206.GC13965@valkosipuli.retiisi.org.uk>
Cc: mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, g.liakhovetski@gmx.de, ONeukum@suse.com,
        k@oikw.org, daniel@zonque.org, mahasler@gmail.com,
        clemens@ladisch.de, geliangtang@163.com, vdronov@redhat.com,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <3f631791-917e-55ec-0476-35ee34955f6f@osg.samsung.com>
Date: Thu, 17 Nov 2016 18:50:37 -0700
MIME-Version: 1.0
In-Reply-To: <20161117231206.GC13965@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for a quick review.

On 11/17/2016 04:12 PM, Sakari Ailus wrote:
> Hi Shuah,
> 
> On Wed, Nov 16, 2016 at 07:29:09AM -0700, Shuah Khan wrote:
>> Media Device Allocator API to allows multiple drivers share a media device.
>> Using this API, drivers can allocate a media device with the shared struct
>> device as the key. Once the media device is allocated by a driver, other
>> drivers can get a reference to it. The media device is released when all
>> the references are released.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>> Changes since v3:
>> - Fixed undefined reference to `__media_device_usb_init compile error when
>>   CONFIG_USB is disabled.
>> - Fixed kernel paging error when accessing /dev/mediaX after rmmod of the
>>   module that owns the media_device. The fix bumps the reference count for
>>   the owner when second driver comes along to share the media_device. If
>>   au0828 owns the media_device, then snd_usb_audio will bump the refcount
>>   for au0828, so it won't get deleted and vice versa.
>>
>>  drivers/media/Makefile              |   3 +-
>>  drivers/media/media-dev-allocator.c | 146 ++++++++++++++++++++++++++++++++++++
>>  include/media/media-dev-allocator.h |  87 +++++++++++++++++++++
>>  3 files changed, 235 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/media/media-dev-allocator.c
>>  create mode 100644 include/media/media-dev-allocator.h
>>
>> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
>> index 0deaa93..7c0701d 100644
>> --- a/drivers/media/Makefile
>> +++ b/drivers/media/Makefile
>> @@ -6,7 +6,8 @@ ifeq ($(CONFIG_MEDIA_CEC_EDID),y)
>>    obj-$(CONFIG_MEDIA_SUPPORT) += cec-edid.o
>>  endif
>>  
>> -media-objs	:= media-device.o media-devnode.o media-entity.o
>> +media-objs	:= media-device.o media-devnode.o media-entity.o \
>> +		   media-dev-allocator.o
>>  
>>  #
>>  # I2C drivers should come before other drivers, otherwise they'll fail
>> diff --git a/drivers/media/media-dev-allocator.c b/drivers/media/media-dev-allocator.c
>> new file mode 100644
>> index 0000000..014a317
>> --- /dev/null
>> +++ b/drivers/media/media-dev-allocator.c
>> @@ -0,0 +1,146 @@
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
>> + */
>> +
>> +#include <linux/slab.h>
>> +#include <linux/kref.h>
>> +#include <linux/usb.h>
>> +#include <linux/module.h>
>> +#include <media/media-device.h>
> 
> Alphabetical order, please.
> 

Will do. It gets out of hand as I keep adding headers :)

>> +
>> +static LIST_HEAD(media_device_list);
>> +static DEFINE_MUTEX(media_device_lock);
>> +
>> +struct media_device_instance {
>> +	struct media_device mdev;
>> +	struct module *owner;
>> +	struct list_head list;
>> +	struct device *dev;
> 
> We've got a struct device pointer in struct media_device. Should we have the
> same here, or use the value in struct media_device?

I think it is good to have it independent of media_device.

> 
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
> 
> Do you need the lock during unregister / cleanup? Isn't it just to serialise
> the access to the linked list?

It is for serializing the list. Think of a case where two drivers are running
through their release sequence and call media_device_delete(). We want only one
of them to do unregister.

> 
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
>> +/* Callers should hold media_device_lock when calling this function */
>> +static struct media_device *__media_device_get(struct device *dev,
>> +					       char *module_name)
>> +{
>> +	struct media_device_instance *mdi;
>> +
>> +	list_for_each_entry(mdi, &media_device_list, list) {
>> +		if (mdi->dev == dev) {
> 
> You could make this look nicer if you continue here if mdi->dev != dev.

I can do that.

> 
>> +			kref_get(&mdi->refcount);
>> +			/* get module reference for the media_device owner */
>> +			if (find_module(module_name) != mdi->owner &&
>> +			    !try_module_get(mdi->owner))
>> +				dev_err(dev, "%s: try_module_get() error\n",
>> +					__func__);
>> +			dev_dbg(dev, "%s: get mdev=%p module_name %s\n",
>> +				__func__, &mdi->mdev, module_name);
>> +			return &mdi->mdev;
>> +		}
>> +	}
>> +
>> +	mdi = kzalloc(sizeof(*mdi), GFP_KERNEL);
>> +	if (!mdi)
>> +		return NULL;
>> +
>> +	mdi->dev = dev;
>> +	mdi->owner = find_module(module_name);
>> +	kref_init(&mdi->refcount);
>> +	list_add_tail(&mdi->list, &media_device_list);
>> +
>> +	dev_dbg(dev, "%s: alloc mdev=%p module_name %s\n", __func__,
> 
> Does the pointer value provide useful information here? The media device is
> specific to a device and there's just one per device. The device name is
> already printed anyway.

It is very useful in making sure there is no leak. That is when second
driver calls media_device_usb_allocate(), we want to see that the same
pointer is handed out. It came in handy for me during testing.

> 
>> +		&mdi->mdev, module_name);
>> +	return &mdi->mdev;
>> +}
>> +
>> +#if IS_ENABLED(CONFIG_USB)
>> +struct media_device *media_device_usb_allocate(struct usb_device *udev,
>> +					       char *module_name)
> 
> How about adding a macro bearing this name, and using KBUILD_MODNAME there?
> It'd look cleaner in drivers. That's what e.g. media_device_register() does,
> for instance.
> 

Yes. I can do it the way media_device_register() does.

>> +{
>> +	struct media_device *mdev;
>> +
>> +	if (!module_name) {
>> +		dev_err(&udev->dev, "%s Module Name is null\n", __func__);
> 
> You use colon (":") elsewhere after the function name, how about here as
> well? "Name" could begin with lowercase letter, too.

Yeah. I added this later, that explains the inconsistency. Will fix it.

> 
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +
>> +	mutex_lock(&media_device_lock);
>> +	mdev = __media_device_get(&udev->dev, module_name);
>> +	if (!mdev) {
>> +		mutex_unlock(&media_device_lock);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	/* check if media device is already initialized */
>> +	if (!mdev->dev)
> 
> I think I would look up a device explicitly, and allocate one if needed.
> This would mean splitting __media_device_get(), you could return the device
> early if found, and then initialise without a need to check anything.

Yeah that could work. I didn't want to add yet another interface and wanted
to _get to do both. I will play with it and see how it comes together. There
is a reason why I kept them the same - but can't recall why.

> 
>> +		__media_device_usb_init(mdev, udev, udev->product,
>> +					module_name);
> 
> When is the media device registered and by which party?

Media device init and register steps are now separate. Drivers first call
media_device_init() and then at a later time call media_device_register().
This split happened during media controller v2 work. This split helps bail
out early if media_device init fails. Here is the sequence:

media_device_init() or media_device_usb_allocate() if using shared media-device
v4l2 and dvb register
media_device_register()

> 
> I guess you can register entities once the media device is registered.
> Nothing I can think of should prevent that, but I don't think it's been done
> before. There could be bugs.
> 
>> +	mutex_unlock(&media_device_lock);
>> +
>> +	dev_dbg(&udev->dev, "%s\n", __func__);
> 
> This was probably nice to have during development time but should be removed
> now.

Yeah this can go.

> 
>> +	return mdev;
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_usb_allocate);
>> +#endif
>> +
>> +void media_device_delete(struct media_device *mdev, char *module_name)
>> +{
>> +	struct media_device_instance *mdi = to_media_device_instance(mdev);
>> +
>> +	if (!module_name) {
>> +		dev_err(mdi->mdev.dev, "%s Module Name is null\n", __func__);
> 
> Can this happen? If so, why? What if the driver is linked to the kernel
> instead?

I don't believe this should happen. I can remove it.

> 
>> +		return;
>> +	}
>> +
>> +	dev_dbg(mdi->mdev.dev, "%s: mdev=%p module_name %s\n",
>> +		__func__, &mdi->mdev, module_name);
>> +
>> +	mutex_lock(&media_device_lock);
>> +	/* put module reference if media_device owner is not THIS_MODULE */
>> +	if (mdi->owner != find_module(module_name)) {
>> +		module_put(mdi->owner);
>> +		dev_dbg(mdi->mdev.dev,
>> +			"%s decremented owner module reference\n", __func__);
>> +	}
>> +	mutex_unlock(&media_device_lock);
>> +	kref_put(&mdi->refcount, media_device_instance_release);
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_delete);
>> diff --git a/include/media/media-dev-allocator.h b/include/media/media-dev-allocator.h
>> new file mode 100644
>> index 0000000..45c437d
>> --- /dev/null
>> +++ b/include/media/media-dev-allocator.h
>> @@ -0,0 +1,87 @@
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
>> + */
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
> 
> The last or the first?
> 
> Presumably any driver that acquires the media device this way can create
> entities, and these entities would be removed when that driver releases the
> media device. We don't refcount graph objects at the moment, so if these
> objects are referred to elsewhere in the kernel while that driver goes away,
> bad things will follow.

Two scenarios:

Say if one of the drivers is unbound. The second driver still has its graph
that can be accessed. When the first driver comes back with a subsequent bind,
then it can add its graph nodes. This works very well at the moment. I ran
au0828 unbind/bind loops while running media-ctl and media_device_tests
accessing the graph.

I do think last is necessary and makes things simpler. Otherwise, we will
have to address cases when a driver goes away taking media_device with it,
the other driver might still have references to it. We have to do some kind
of handshake or callbacks to make sure the other driver knows about its
counterpart disappearing. They do have kind of split brain now with their
own devices i.e video, dvb, audio devices.

The second scenario is when the driver that owns the media_device (module
ownership) get removed via rmmod, then without the second driver holding
the reference to the first module, bad things happen. This is why I added
the logic to keep track of the module ownership and have the second driver
get module reference for the owning module.

The implication of holding module reference is:

rmmmod on the owner module will fail with "module in use error". This isn't
unusual anyway, when the device or module is in use, we do this now.
e.g: if au08282 is the owner the, it can't be removed until
snd_usb_audio is removed and vice versa.

thanks,
-- Shuah

> 
> It's not the only place this kind of problems exist at the moment though, so
> the solution could perhaps be left for later as well. The patchset I've been
> pushing solves, as far as I understand, the ones that pre-exist w/o this
> patchset. The solutions need some reworking if this set is applied, as
> there's no longer a single driver responsible for a media device.
> 
>> + * references are released. Each driver gets a reference to the media device
>> + * during probe, when it allocates the media device. If media device is already
>> + * allocated, allocate API bumps up the refcount and return the existing media
>> + * device. Driver puts the reference back from its disconnect routine when it
>> + * calls media_device_delete().
>> + *
>> + * Media device is unregistered and cleaned up from the kref put handler to
>> + * ensure that the media device stays in registered state until the last driver
>> + * unregisters the media device.
>> + *
>> + * Driver Usage:
>> + *
>> + * Drivers should use the media-core routines to get register reference and
>> + * call media_device_delete() routine to make sure the shared media device
>> + * delete is handled correctly.
>> + *
>> + * driver probe:
>> + *	Call media_device_usb_allocate() to allocate or get a reference
>> + *	Call media_device_register(), if media devnode isn't registered
>> + *
>> + * driver disconnect:
>> + *	Call media_device_delete() to free the media_device. Free'ing is
>> + *	handled by the put handler.
>> + *
>> + */
>> +
>> +/**
>> + * media_device_usb_allocate() - Allocate and return media device
>> + *
>> + * @udev - struct usb_device pointer
>> + * @module_name
>> + *
>> + * This interface should be called to allocate a media device when multiple
>> + * drivers share usb_device and the media device. This interface allocates
>> + * media device and calls media_device_usb_init() to initialize it.
>> + *
>> + */
>> +struct media_device *media_device_usb_allocate(struct usb_device *udev,
>> +					       char *module_name);
>> +/**
>> + * media_device_delete() - Release media device. Calls kref_put().
>> + *
>> + * @mdev - struct media_device pointer
>> + * @module_name
>> + *
>> + * This interface should be called to put Media Device Instance kref.
>> + */
>> +void media_device_delete(struct media_device *mdev, char *driver_name);
>> +#else
>> +static inline struct media_device *media_device_usb_allocate(
>> +			struct usb_device *udev, char *driver_name)
>> +			{ return NULL; }
>> +static inline void media_device_delete(
>> +			struct media_device *mdev, char *module_name) { }
>> +#endif /* CONFIG_MEDIA_CONTROLLER */
>> +#endif
> 

