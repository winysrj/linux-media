Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54600 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbeKTVtQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 16:49:16 -0500
Subject: Re: [RFC PATCH v8 1/4] media: Media Device Allocator API
To: shuah@kernel.org, mchehab@kernel.org, perex@perex.cz,
        tiwai@suse.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <cover.1541118238.git.shuah@kernel.org>
 <e474dd16f1d6443c12b1361376193c9d0efcced6.1541109584.git.shuah@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0412cf12-8f2f-4a63-74da-6f92dd503c4b@xs4all.nl>
Date: Tue, 20 Nov 2018 12:20:32 +0100
MIME-Version: 1.0
In-Reply-To: <e474dd16f1d6443c12b1361376193c9d0efcced6.1541109584.git.shuah@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/02/2018 01:31 AM, shuah@kernel.org wrote:
> From: Shuah Khan <shuah@kernel.org>
> 
> Media Device Allocator API to allows multiple drivers share a media device.
> Using this API, drivers can allocate a media device with the shared struct
> device as the key. Once the media device is allocated by a driver, other
> drivers can get a reference to it. The media device is released when all
> the references are released.
> 
> Signed-off-by: Shuah Khan <shuah@kernel.org>
> ---
>  Documentation/media/kapi/mc-core.rst |  37 ++++++++
>  drivers/media/Makefile               |   3 +-
>  drivers/media/media-dev-allocator.c  | 132 +++++++++++++++++++++++++++
>  include/media/media-dev-allocator.h  |  53 +++++++++++
>  4 files changed, 224 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/media-dev-allocator.c
>  create mode 100644 include/media/media-dev-allocator.h
> 
> diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
> index 0c05503eaf1f..d6f409598065 100644
> --- a/Documentation/media/kapi/mc-core.rst
> +++ b/Documentation/media/kapi/mc-core.rst
> @@ -257,8 +257,45 @@ Subsystems should facilitate link validation by providing subsystem specific
>  helper functions to provide easy access for commonly needed information, and
>  in the end provide a way to use driver-specific callbacks.
>  
> +Media Controller Device Allocator API
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +When media device belongs to more than one driver, the shared media device

When -> When the

> +is allocated with the shared struct device as the key for look ups.
> +
> +Shared media device should stay in registered state until the last driver

Shared -> The shared

> +unregisters it. In addition, media device should be released when all the

media -> the media

> +references are released. Each driver gets a reference to the media device
> +during probe, when it allocates the media device. If media device is already
> +allocated, allocate API bumps up the refcount and return the existing media

allocate -> the allocate
return -> returns

> +device. Driver puts the reference back from its disconnect routine when it

Driver -> The driver
from -> in

> +calls :c:func:`media_device_delete()`.
> +
> +Media device is unregistered and cleaned up from the kref put handler to

Media -> The media
from -> in

> +ensure that the media device stays in registered state until the last driver
> +unregisters the media device.

What happens if an application still has the media device open and you forcibly
remove the last driver? I think it should be OK since the media_devnode struct
isn't freed until the last open filehandle closes. But it is good to test this.

> +
> +**Driver Usage**
> +
> +Drivers should use the media-core routines to get register reference and

'get register reference'? Not sure what you meant to say.

> +call :c:func:`media_device_delete()` routine to make sure the shared media
> +device delete is handled correctly.
> +
> +**driver probe:**
> +Call :c:func:`media_device_usb_allocate()` to allocate or get a reference
> +Call :c:func:`media_device_register()`, if media devnode isn't registered
> +
> +**driver disconnect:**
> +Call :c:func:`media_device_delete()` to free the media_device. Free'ing is

Free'ing -> Freeing

> +handled by the kref put handler.
> +
> +API Definitions
> +^^^^^^^^^^^^^^^
> +
>  .. kernel-doc:: include/media/media-device.h
>  
>  .. kernel-doc:: include/media/media-devnode.h
>  
>  .. kernel-doc:: include/media/media-entity.h
> +
> +.. kernel-doc:: include/media/media-dev-allocator.h
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index 594b462ddf0e..8608f0a41dca 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -3,7 +3,8 @@
>  # Makefile for the kernel multimedia device drivers.
>  #
>  
> -media-objs	:= media-device.o media-devnode.o media-entity.o
> +media-objs	:= media-device.o media-devnode.o media-entity.o \
> +		   media-dev-allocator.o

Perhaps only add media-dev-allocator if CONFIG_USB is enabled?

>  
>  #
>  # I2C drivers should come before other drivers, otherwise they'll fail
> diff --git a/drivers/media/media-dev-allocator.c b/drivers/media/media-dev-allocator.c
> new file mode 100644
> index 000000000000..262d1293dc13
> --- /dev/null
> +++ b/drivers/media/media-dev-allocator.c
> @@ -0,0 +1,132 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * media-dev-allocator.c - Media Controller Device Allocator API
> + *
> + * Copyright (c) 2018 Shuah Khan <shuah@kernel.org>
> + *
> + * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + */
> +
> +/*
> + * This file adds a global refcounted Media Controller Device Instance API.
> + * A system wide global media device list is managed and each media device
> + * includes a kref count. The last put on the media device releases the media
> + * device instance.
> + *
> + */
> +
> +#include <linux/kref.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/usb.h>
> +
> +#include <media/media-device.h>
> +
> +static LIST_HEAD(media_device_list);
> +static DEFINE_MUTEX(media_device_lock);
> +
> +struct media_device_instance {
> +	struct media_device mdev;
> +	struct module *owner;
> +	struct list_head list;
> +	struct kref refcount;
> +};
> +
> +static inline struct media_device_instance *
> +to_media_device_instance(struct media_device *mdev)
> +{
> +	return container_of(mdev, struct media_device_instance, mdev);
> +}
> +
> +static void media_device_instance_release(struct kref *kref)
> +{
> +	struct media_device_instance *mdi =
> +		container_of(kref, struct media_device_instance, refcount);
> +
> +	dev_dbg(mdi->mdev.dev, "%s: mdev=%p\n", __func__, &mdi->mdev);
> +
> +	mutex_lock(&media_device_lock);

Can't the lock be moved down to just before list_del? Or am I missing something?

> +
> +	media_device_unregister(&mdi->mdev);
> +	media_device_cleanup(&mdi->mdev);
> +
> +	list_del(&mdi->list);
> +	mutex_unlock(&media_device_lock);
> +
> +	kfree(mdi);
> +}
> +
> +/* Callers should hold media_device_lock when calling this function */
> +static struct media_device *__media_device_get(struct device *dev,
> +					       char *module_name)

const char *

> +{
> +	struct media_device_instance *mdi;
> +
> +	list_for_each_entry(mdi, &media_device_list, list) {
> +		if (mdi->mdev.dev != dev)
> +			continue;
> +
> +		kref_get(&mdi->refcount);
> +		/* get module reference for the media_device owner */
> +		if (find_module(module_name) != mdi->owner &&
> +		    !try_module_get(mdi->owner))
> +			dev_err(dev, "%s: try_module_get() error\n", __func__);
> +		dev_dbg(dev, "%s: get mdev=%p module_name %s\n",
> +			__func__, &mdi->mdev, module_name);
> +		return &mdi->mdev;
> +	}
> +
> +	mdi = kzalloc(sizeof(*mdi), GFP_KERNEL);
> +	if (!mdi)
> +		return NULL;
> +
> +	mdi->owner = find_module(module_name);
> +	kref_init(&mdi->refcount);
> +	list_add_tail(&mdi->list, &media_device_list);
> +
> +	dev_dbg(dev, "%s: alloc mdev=%p module_name %s\n", __func__,
> +		&mdi->mdev, module_name);
> +	return &mdi->mdev;
> +}
> +
> +#if IS_ENABLED(CONFIG_USB)
> +struct media_device *media_device_usb_allocate(struct usb_device *udev,
> +					       char *module_name)

const char *

> +{
> +	struct media_device *mdev;
> +
> +	mutex_lock(&media_device_lock);
> +	mdev = __media_device_get(&udev->dev, module_name);
> +	if (!mdev) {
> +		mutex_unlock(&media_device_lock);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	/* check if media device is already initialized */
> +	if (!mdev->dev)
> +		__media_device_usb_init(mdev, udev, udev->product,
> +					module_name);
> +	mutex_unlock(&media_device_lock);
> +	return mdev;
> +}
> +EXPORT_SYMBOL_GPL(media_device_usb_allocate);
> +#endif
> +
> +void media_device_delete(struct media_device *mdev, char *module_name)
> +{
> +	struct media_device_instance *mdi = to_media_device_instance(mdev);
> +
> +	dev_dbg(mdi->mdev.dev, "%s: mdev=%p module_name %s\n",
> +		__func__, &mdi->mdev, module_name);
> +
> +	mutex_lock(&media_device_lock);
> +	/* put module reference if media_device owner is not THIS_MODULE */
> +	if (mdi->owner != find_module(module_name)) {
> +		module_put(mdi->owner);
> +		dev_dbg(mdi->mdev.dev,
> +			"%s decremented owner module reference\n", __func__);
> +	}
> +	mutex_unlock(&media_device_lock);
> +	kref_put(&mdi->refcount, media_device_instance_release);
> +}
> +EXPORT_SYMBOL_GPL(media_device_delete);
> diff --git a/include/media/media-dev-allocator.h b/include/media/media-dev-allocator.h
> new file mode 100644
> index 000000000000..8fbadff2cef8
> --- /dev/null
> +++ b/include/media/media-dev-allocator.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * media-dev-allocator.h - Media Controller Device Allocator API
> + *
> + * Copyright (c) 2018 Shuah Khan <shuah@kernel.org>
> + *
> + * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + */
> +
> +/*
> + * This file adds a global ref-counted Media Controller Device Instance API.
> + * A system wide global media device list is managed and each media device
> + * includes a kref count. The last put on the media device releases the media
> + * device instance.
> + */
> +
> +#ifndef _MEDIA_DEV_ALLOCTOR_H
> +#define _MEDIA_DEV_ALLOCTOR_H
> +
> +struct usb_device;
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER

Perhaps change this to:

#if defined(CONFIG_MEDIA_CONTROLLER) && defined(CONFIG_USB)

Since for now this only makes sense for USB devices.

> +/**
> + * media_device_usb_allocate() - Allocate and return struct &media device
> + *
> + * @udev:		struct &usb_device pointer
> + * @module_name:	should be filled with %KBUILD_MODNAME
> + *
> + * This interface should be called to allocate a Media Device when multiple
> + * drivers share usb_device and the media device. This interface allocates
> + * &media_device structure and calls media_device_usb_init() to initialize
> + * it.
> + *
> + */
> +struct media_device *media_device_usb_allocate(struct usb_device *udev,
> +					       char *module_name);
> +/**
> + * media_device_delete() - Release media device. Calls kref_put().
> + *
> + * @mdev:		struct &media_device pointer
> + * @module_name:	should be filled with %KBUILD_MODNAME
> + *
> + * This interface should be called to put Media Device Instance kref.
> + */
> +void media_device_delete(struct media_device *mdev, char *module_name);
> +#else
> +static inline struct media_device *media_device_usb_allocate(
> +			struct usb_device *udev, char *module_name)
> +			{ return NULL; }
> +static inline void media_device_delete(
> +			struct media_device *mdev, char *module_name) { }
> +#endif /* CONFIG_MEDIA_CONTROLLER */
> +#endif
> 

Regards,

	Hans
