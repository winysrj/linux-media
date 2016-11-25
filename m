Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58372
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751218AbcKYJXG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 04:23:06 -0500
Date: Fri, 25 Nov 2016 07:22:52 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org
Cc: mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, g.liakhovetski@gmx.de, ONeukum@suse.com,
        k@oikw.org, daniel@zonque.org, mahasler@gmail.com,
        clemens@ladisch.de, geliangtang@163.com, vdronov@redhat.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v5 1/3] media: Media Device Allocator API
Message-ID: <20161125072252.6ba98832@vento.lan>
In-Reply-To: <075f607f991d5dc0468cec69d67c2767f3a4e1cb.1479502501.git.shuahkh@osg.samsung.com>
References: <cover.1479502501.git.shuahkh@osg.samsung.com>
        <075f607f991d5dc0468cec69d67c2767f3a4e1cb.1479502501.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Nov 2016 14:45:10 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Media Device Allocator API to allows multiple drivers share a media device.
> Using this API, drivers can allocate a media device with the shared struct
> device as the key. Once the media device is allocated by a driver, other
> drivers can get a reference to it. The media device is released when all
> the references are released.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> Changes to patch 0001 since v4:
> - Addressed Sakari's review comments with the exception of
>   opting to not introduce media_device_usb_allocate() macro,
>   and to not add a new routine to find media device instance
>   to avoid a one line check.
> 
>  Documentation/media/kapi/mc-core.rst |   2 +
>  drivers/media/Makefile               |   3 +-
>  drivers/media/media-dev-allocator.c  | 135 +++++++++++++++++++++++++++++++++++
>  include/media/media-dev-allocator.h  |  88 +++++++++++++++++++++++
>  4 files changed, 227 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/media-dev-allocator.c
>  create mode 100644 include/media/media-dev-allocator.h
> 
> diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
> index 1a738e5..0b9090d 100644
> --- a/Documentation/media/kapi/mc-core.rst
> +++ b/Documentation/media/kapi/mc-core.rst
> @@ -262,3 +262,5 @@ in the end provide a way to use driver-specific callbacks.
>  .. kernel-doc:: include/media/media-devnode.h
>  
>  .. kernel-doc:: include/media/media-entity.h
> +
> +.. kernel-doc:: include/media/media-dev-allocator.h
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index 0deaa93..7c0701d 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -6,7 +6,8 @@ ifeq ($(CONFIG_MEDIA_CEC_EDID),y)
>    obj-$(CONFIG_MEDIA_SUPPORT) += cec-edid.o
>  endif
>  
> -media-objs	:= media-device.o media-devnode.o media-entity.o
> +media-objs	:= media-device.o media-devnode.o media-entity.o \
> +		   media-dev-allocator.o
>  
>  #
>  # I2C drivers should come before other drivers, otherwise they'll fail
> diff --git a/drivers/media/media-dev-allocator.c b/drivers/media/media-dev-allocator.c
> new file mode 100644
> index 0000000..581e50e
> --- /dev/null
> +++ b/drivers/media/media-dev-allocator.c
> @@ -0,0 +1,135 @@
> +/*
> + * media-dev-allocator.c - Media Controller Device Allocator API
> + *
> + * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
> + * Copyright (c) 2016 Samsung Electronics Co., Ltd.
> + *
> + * This file is released under the GPLv2.
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
> +	struct device *dev;

I agree with Sakari here: mdev is embedded. So, it will always have
a mdev.dev inside it. So, if dev == mdev.dev for all cases, we
can just get rid of it. If you want to simplify the code, just add
a to_dev() macro like:

#define to_dev(mdi) (mdi)->mdev.dev

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
> +{
> +	struct media_device_instance *mdi;
> +
> +	list_for_each_entry(mdi, &media_device_list, list) {
> +		if (mdi->dev != dev)
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
> +	mdi->dev = dev;
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

It misses variant for PCI drivers. Ok, we could postpone it until
we have the need of using media device allocator on pci drivers.


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
> index 0000000..fad8cb9
> --- /dev/null
> +++ b/include/media/media-dev-allocator.h
> @@ -0,0 +1,88 @@
> +/*
> + * media-dev-allocator.h - Media Controller Device Allocator API
> + *
> + * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
> + * Copyright (c) 2016 Samsung Electronics Co., Ltd.
> + *
> + * This file is released under the GPLv2.
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
> +/**
> + * Media Controller Device Allocator API

Huh? kernel-doc won't work with this. Did you test this patch with the
media documentation, by calling:
	make DOCBOOKS="" SPHINXOPTS="-j9" SPHINXDIRS=media htmldocs

Also, as I said before: please move
those textual descriptions to Documentation/media/kapi/mc-core.rst, and use
ReST markup to enrich it and add cross-references to functions and data
structs mentioned below. 

> + *
> + * When media device belongs to more than one driver, the shared media device
> + * is allocated with the shared struct device as the key for look ups.
> + *
> + * Shared media device should stay in registered state until the last driver
> + * unregisters it. In addition, media device should be released when all the
> + * references are released. Each driver gets a reference to the media device
> + * during probe, when it allocates the media device. If media device is already
> + * allocated, allocate API bumps up the refcount and return the existing media
> + * device. Driver puts the reference back from its disconnect routine when it
> + * calls media_device_delete().
> + *
> + * Media device is unregistered and cleaned up from the kref put handler to
> + * ensure that the media device stays in registered state until the last driver
> + * unregisters the media device.
> + *
> + * Driver Usage:
> + *
> + * Drivers should use the media-core routines to get register reference and
> + * call media_device_delete() routine to make sure the shared media device
> + * delete is handled correctly.
> + *
> + * driver probe:
> + *	Call media_device_usb_allocate() to allocate or get a reference
> + *	Call media_device_register(), if media devnode isn't registered
> + *
> + * driver disconnect:
> + *	Call media_device_delete() to free the media_device. Free'ing is
> + *	handled by the put handler.
> + *
> + */
> +
> +/**
> + * media_device_usb_allocate() - Allocate and return media device
> + *
> + * @udev:		struct usb_device pointer
> + * @module_name:	should be filled with KBUILD_MODNAME
> + *
> + * This interface should be called to allocate a media device when multiple
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
> + * @mdev:		struct media_device pointer
> + * @module_name:	should be filled with KBUILD_MODNAME
> + *
> + * This interface should be called to put Media Device Instance kref.
> + */
> +void media_device_delete(struct media_device *mdev, char *driver_name);
> +#else
> +static inline struct media_device *media_device_usb_allocate(
> +			struct usb_device *udev, char *driver_name)
> +			{ return NULL; }
> +static inline void media_device_delete(
> +			struct media_device *mdev, char *module_name) { }
> +#endif /* CONFIG_MEDIA_CONTROLLER */
> +#endif



Thanks,
Mauro
