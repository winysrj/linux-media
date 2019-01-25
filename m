Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFC6C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 795F6218E2
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfAYPjU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 10:39:20 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49116 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726238AbfAYPjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 10:39:20 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id ED6F1634C7B;
        Fri, 25 Jan 2019 17:38:42 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gn3Z5-0001Uk-W7; Fri, 25 Jan 2019 17:38:44 +0200
Date:   Fri, 25 Jan 2019 17:38:43 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Shuah Khan <shuah@kernel.org>
Cc:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v10 1/4] media: Media Device Allocator API
Message-ID: <20190125153843.onbq7uiwpjp3b2y7@valkosipuli.retiisi.org.uk>
References: <cover.1548360791.git.shuah@kernel.org>
 <df3aae79629e5c0ab5a57dfaf5e2d815a134cd2d.1548360791.git.shuah@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df3aae79629e5c0ab5a57dfaf5e2d815a134cd2d.1548360791.git.shuah@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Shuah,

On Thu, Jan 24, 2019 at 01:32:38PM -0700, Shuah Khan wrote:
> Media Device Allocator API to allows multiple drivers share a media device.
> This API solves a very common use-case for media devices where one physical
> device (an USB stick) provides both audio and video. When such media device
> exposes a standard USB Audio class, a proprietary Video class, two or more
> independent drivers will share a single physical USB bridge. In such cases,
> it is necessary to coordinate access to the shared resource.
> 
> Using this API, drivers can allocate a media device with the shared struct
> device as the key. Once the media device is allocated by a driver, other
> drivers can get a reference to it. The media device is released when all
> the references are released.

Are there real, non-USB devices that could use the same API?

> 
> Signed-off-by: Shuah Khan <shuah@kernel.org>
> ---
>  Documentation/media/kapi/mc-core.rst |  41 ++++++++
>  drivers/media/Makefile               |   4 +
>  drivers/media/media-dev-allocator.c  | 144 +++++++++++++++++++++++++++
>  include/media/media-dev-allocator.h  |  53 ++++++++++
>  4 files changed, 242 insertions(+)
>  create mode 100644 drivers/media/media-dev-allocator.c
>  create mode 100644 include/media/media-dev-allocator.h
> 
> diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
> index 0bcfeadbc52d..07f2a6a90af2 100644
> --- a/Documentation/media/kapi/mc-core.rst
> +++ b/Documentation/media/kapi/mc-core.rst
> @@ -259,6 +259,45 @@ Subsystems should facilitate link validation by providing subsystem specific
>  helper functions to provide easy access for commonly needed information, and
>  in the end provide a way to use driver-specific callbacks.
>  
> +Media Controller Device Allocator API
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +When the media device belongs to more than one driver, the shared media
> +device is allocated with the shared struct device as the key for look ups.
> +
> +The shared media device should stay in registered state until the last
> +driver unregisters it. In addition, the media device should be released when
> +all the references are released. Each driver gets a reference to the media
> +device during probe, when it allocates the media device. If media device is
> +already allocated, the allocate API bumps up the refcount and returns the
> +existing media device. The driver puts the reference back in its disconnect
> +routine when it calls :c:func:`media_device_delete()`.
> +
> +The media device is unregistered and cleaned up from the kref put handler to
> +ensure that the media device stays in registered state until the last driver
> +unregisters the media device.
> +
> +**Driver Usage**
> +
> +Drivers should use the appropriate media-core routines to manage the shared
> +media device life-time handling the two states:
> +1. allocate -> register -> delete
> +2. get reference to already registered device -> delete
> +
> +call :c:func:`media_device_delete()` routine to make sure the shared media
> +device delete is handled correctly.
> +
> +**driver probe:**
> +Call :c:func:`media_device_usb_allocate()` to allocate or get a reference
> +Call :c:func:`media_device_register()`, if media devnode isn't registered
> +
> +**driver disconnect:**
> +Call :c:func:`media_device_delete()` to free the media_device. Freeing is
> +handled by the kref put handler.
> +
> +API Definitions
> +^^^^^^^^^^^^^^^
> +
>  .. kernel-doc:: include/media/media-device.h
>  
>  .. kernel-doc:: include/media/media-devnode.h
> @@ -266,3 +305,5 @@ in the end provide a way to use driver-specific callbacks.
>  .. kernel-doc:: include/media/media-entity.h
>  
>  .. kernel-doc:: include/media/media-request.h
> +
> +.. kernel-doc:: include/media/media-dev-allocator.h
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index 985d35ec6b29..1d7653318af6 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -6,6 +6,10 @@
>  media-objs	:= media-device.o media-devnode.o media-entity.o \
>  		   media-request.o
>  
> +ifeq ($(CONFIG_USB),y)
> +	media-objs += media-dev-allocator.o
> +endif
> +
>  #
>  # I2C drivers should come before other drivers, otherwise they'll fail
>  # when compiled as builtin drivers
> diff --git a/drivers/media/media-dev-allocator.c b/drivers/media/media-dev-allocator.c
> new file mode 100644
> index 000000000000..4606456c1e86
> --- /dev/null
> +++ b/drivers/media/media-dev-allocator.c
> @@ -0,0 +1,144 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later

GPL-2.0+

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
> +
> +	media_device_unregister(&mdi->mdev);
> +	media_device_cleanup(&mdi->mdev);

This is a problem, albeit not really more of a problem than it is in a
driver. The refcounting changes can be made here instead. I'll take this
into account in the media device refcounting series I'm planning to start
working on again; would you be perhaps able to help testing with this
device once I have patches in that shape? I have no access to the hardware.

> +
> +	list_del(&mdi->list);
> +	mutex_unlock(&media_device_lock);
> +
> +	kfree(mdi);
> +}
> +
> +/* Callers should hold media_device_lock when calling this function */
> +static struct media_device *__media_device_get(struct device *dev,
> +						const char *module_name,
> +						struct module *modp)
> +{
> +	struct media_device_instance *mdi;
> +
> +	list_for_each_entry(mdi, &media_device_list, list) {
> +
> +		if (mdi->mdev.dev != dev)
> +			continue;
> +
> +		kref_get(&mdi->refcount);
> +
> +		/* get module reference for the media_device owner */
> +		if (modp != mdi->owner && !try_module_get(mdi->owner))
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
> +	mdi->owner = modp;
> +	kref_init(&mdi->refcount);
> +	list_add_tail(&mdi->list, &media_device_list);
> +
> +	dev_dbg(dev, "%s: alloc mdev=%p module_name %s\n", __func__,
> +		&mdi->mdev, module_name);
> +	return &mdi->mdev;
> +}
> +
> +#if IS_ENABLED(CONFIG_USB)

You already compile the file only if CONFIG_USB is enabled. I think you
could remove this.

> +struct media_device *media_device_usb_allocate(struct usb_device *udev,
> +					       const char *module_name)

I'd like to suggest working based on usb_interface instead of usb_device
here: that object already exists and you can find out the device based on
it. It seems all callers of this function already have the usb_interface
around.

> +{
> +	struct media_device *mdev;
> +	struct module *modptr;
> +
> +	mutex_lock(&module_mutex);
> +	modptr = find_module(module_name);
> +	mutex_unlock(&module_mutex);
> +
> +	mutex_lock(&media_device_lock);
> +	mdev = __media_device_get(&udev->dev, module_name, modptr);
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
> +void media_device_delete(struct media_device *mdev, const char *module_name)

Same here. The use of the module name seems a bit hackish to me, albeit I
suppose it'd work, too.

> +{
> +	struct media_device_instance *mdi = to_media_device_instance(mdev);
> +	struct module *modptr;
> +
> +	dev_dbg(mdi->mdev.dev, "%s: mdev=%p module_name %s\n",
> +		__func__, &mdi->mdev, module_name);
> +
> +	mutex_lock(&module_mutex);
> +	modptr = find_module(module_name);
> +	mutex_unlock(&module_mutex);
> +
> +	mutex_lock(&media_device_lock);
> +	/* put module reference if media_device owner is not THIS_MODULE */
> +	if (mdi->owner != modptr) {
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
> index 000000000000..9164795e911c
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
> +#if defined(CONFIG_MEDIA_CONTROLLER) && defined(CONFIG_USB)
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

-- 
Regards,

Sakari Ailus
