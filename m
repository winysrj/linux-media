Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16753C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 14:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE2DF2082F
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 14:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553696329;
	bh=7iZnKFusbW8ayPVEGKNsgEY4AFCLKhbVfjNmWEFbOAI=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=y0pn1HW5Anl5aEQlmCOoEg2xS9mHsvrY3vZTaGljyrBujLaHK4TZN888umYCdCLyZ
	 /WR7TB66JrYz/cy0TgDznloYsrvQrG583fd1v5kMqeu1nZqEobd7ykJ4V6fBZzPKqS
	 UnSxdF0+NvRXytGWjNhzTKgt0V0p1mLz+ClmUalc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfC0OSo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbfC0OSn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 10:18:43 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB2BA2075E;
        Wed, 27 Mar 2019 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553696322;
        bh=7iZnKFusbW8ayPVEGKNsgEY4AFCLKhbVfjNmWEFbOAI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=2uOgHbuJsTF0+bW4rJQxfmWlt1Wvwj1BVtMJo7HUQwM231l03Q3Nl7mCDcOdqGaWP
         MnVaCwjB3FUQpcpDR2B/UO79ikoF91dyeavX9yJ2hHkgh6BHuDyeCRvcECMCUJyDSK
         O5zNRntKbf28NDCzBus9Gc2lsDC1/jmyjZ4pLWfY=
Subject: Re: [PATCH v12 1/5] media: Media Device Allocator API
To:     Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        perex@perex.cz, tiwai@suse.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, shuah <shuah@kernel.org>
References: <cover.1553634246.git.shuah@kernel.org>
 <1e22c34b011c3c1fd793a623fb59c82081d46038.1553634246.git.shuah@kernel.org>
 <f2b75327-5e79-d316-9599-6420b99aa140@xs4all.nl>
 <c80f31fd-4308-29ea-9c12-9ae4caacb087@kernel.org>
 <84367fd2-9ff9-bdef-adaf-16a2fc96c11b@xs4all.nl>
From:   shuah <shuah@kernel.org>
Message-ID: <2fa1d7fb-75c4-88ea-f803-25a5800b6482@kernel.org>
Date:   Wed, 27 Mar 2019 08:18:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <84367fd2-9ff9-bdef-adaf-16a2fc96c11b@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/27/19 7:55 AM, Hans Verkuil wrote:
> On 3/27/19 2:45 PM, shuah wrote:
>> Hi Hans,
>>
>> On 3/27/19 4:37 AM, Hans Verkuil wrote:
>>> Hi Shuah,
>>>
>>> Some comments at the end. I suspect you still have to do more work :-(
>>
>> I am okay with doing more work. I am expecting it since, I am not happy
>> with the config options that are in play. More on this below.
>>
>>>
>>> On 3/27/19 3:24 AM, Shuah Khan wrote:
>>>> Media Device Allocator API to allows multiple drivers share a media device.
>>>> This API solves a very common use-case for media devices where one physical
>>>> device (an USB stick) provides both audio and video. When such media device
>>>> exposes a standard USB Audio class, a proprietary Video class, two or more
>>>> independent drivers will share a single physical USB bridge. In such cases,
>>>> it is necessary to coordinate access to the shared resource.
>>>>
>>>> Using this API, drivers can allocate a media device with the shared struct
>>>> device as the key. Once the media device is allocated by a driver, other
>>>> drivers can get a reference to it. The media device is released when all
>>>> the references are released.
>>>>
>>>> Signed-off-by: Shuah Khan <shuah@kernel.org>
>>>> ---
>>>>    Documentation/media/kapi/mc-core.rst |  41 ++++++++
>>>>    drivers/media/Makefile               |   6 ++
>>>>    drivers/media/media-dev-allocator.c  | 142 +++++++++++++++++++++++++++
>>>>    include/media/media-dev-allocator.h  |  54 ++++++++++
>>>>    4 files changed, 243 insertions(+)
>>>>    create mode 100644 drivers/media/media-dev-allocator.c
>>>>    create mode 100644 include/media/media-dev-allocator.h
>>>>
>>>> diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
>>>> index f930725e0d6b..05bba0b61748 100644
>>>> --- a/Documentation/media/kapi/mc-core.rst
>>>> +++ b/Documentation/media/kapi/mc-core.rst
>>>> @@ -259,6 +259,45 @@ Subsystems should facilitate link validation by providing subsystem specific
>>>>    helper functions to provide easy access for commonly needed information, and
>>>>    in the end provide a way to use driver-specific callbacks.
>>>>    
>>>> +Media Controller Device Allocator API
>>>> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>> +
>>>> +When the media device belongs to more than one driver, the shared media
>>>> +device is allocated with the shared struct device as the key for look ups.
>>>> +
>>>> +The shared media device should stay in registered state until the last
>>>> +driver unregisters it. In addition, the media device should be released when
>>>> +all the references are released. Each driver gets a reference to the media
>>>> +device during probe, when it allocates the media device. If media device is
>>>> +already allocated, the allocate API bumps up the refcount and returns the
>>>> +existing media device. The driver puts the reference back in its disconnect
>>>> +routine when it calls :c:func:`media_device_delete()`.
>>>> +
>>>> +The media device is unregistered and cleaned up from the kref put handler to
>>>> +ensure that the media device stays in registered state until the last driver
>>>> +unregisters the media device.
>>>> +
>>>> +**Driver Usage**
>>>> +
>>>> +Drivers should use the appropriate media-core routines to manage the shared
>>>> +media device life-time handling the two states:
>>>> +1. allocate -> register -> delete
>>>> +2. get reference to already registered device -> delete
>>>> +
>>>> +call :c:func:`media_device_delete()` routine to make sure the shared media
>>>> +device delete is handled correctly.
>>>> +
>>>> +**driver probe:**
>>>> +Call :c:func:`media_device_usb_allocate()` to allocate or get a reference
>>>> +Call :c:func:`media_device_register()`, if media devnode isn't registered
>>>> +
>>>> +**driver disconnect:**
>>>> +Call :c:func:`media_device_delete()` to free the media_device. Freeing is
>>>> +handled by the kref put handler.
>>>> +
>>>> +API Definitions
>>>> +^^^^^^^^^^^^^^^
>>>> +
>>>>    .. kernel-doc:: include/media/media-device.h
>>>>    
>>>>    .. kernel-doc:: include/media/media-devnode.h
>>>> @@ -266,3 +305,5 @@ in the end provide a way to use driver-specific callbacks.
>>>>    .. kernel-doc:: include/media/media-entity.h
>>>>    
>>>>    .. kernel-doc:: include/media/media-request.h
>>>> +
>>>> +.. kernel-doc:: include/media/media-dev-allocator.h
>>>> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
>>>> index 985d35ec6b29..20b488067ec2 100644
>>>> --- a/drivers/media/Makefile
>>>> +++ b/drivers/media/Makefile
>>>> @@ -6,6 +6,12 @@
>>>>    media-objs	:= media-device.o media-devnode.o media-entity.o \
>>>>    		   media-request.o
>>>>    
>>>> +ifeq ($(CONFIG_USB),y)
>>>> +	ifeq ($(CONFIG_MODULES),y)
>>>> +		media-objs += media-dev-allocator.o
>>>> +	endif
>>>> +endif
>>>> +
>>>>    #
>>>>    # I2C drivers should come before other drivers, otherwise they'll fail
>>>>    # when compiled as builtin drivers
>>>> diff --git a/drivers/media/media-dev-allocator.c b/drivers/media/media-dev-allocator.c
>>>> new file mode 100644
>>>> index 000000000000..a37515254009
>>>> --- /dev/null
>>>> +++ b/drivers/media/media-dev-allocator.c
>>>> @@ -0,0 +1,142 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/*
>>>> + * media-dev-allocator.c - Media Controller Device Allocator API
>>>> + *
>>>> + * Copyright (c) 2018 Shuah Khan <shuah@kernel.org>
>>>> + *
>>>> + * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>> + */
>>>> +
>>>> +/*
>>>> + * This file adds a global refcounted Media Controller Device Instance API.
>>>> + * A system wide global media device list is managed and each media device
>>>> + * includes a kref count. The last put on the media device releases the media
>>>> + * device instance.
>>>> + *
>>>> + */
>>>> +
>>>> +#include <linux/kref.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/slab.h>
>>>> +#include <linux/usb.h>
>>>> +
>>>> +#include <media/media-device.h>
>>>> +
>>>> +static LIST_HEAD(media_device_list);
>>>> +static DEFINE_MUTEX(media_device_lock);
>>>> +
>>>> +struct media_device_instance {
>>>> +	struct media_device mdev;
>>>> +	struct module *owner;
>>>> +	struct list_head list;
>>>> +	struct kref refcount;
>>>> +};
>>>> +
>>>> +static inline struct media_device_instance *
>>>> +to_media_device_instance(struct media_device *mdev)
>>>> +{
>>>> +	return container_of(mdev, struct media_device_instance, mdev);
>>>> +}
>>>> +
>>>> +static void media_device_instance_release(struct kref *kref)
>>>> +{
>>>> +	struct media_device_instance *mdi =
>>>> +		container_of(kref, struct media_device_instance, refcount);
>>>> +
>>>> +	dev_dbg(mdi->mdev.dev, "%s: mdev=%p\n", __func__, &mdi->mdev);
>>>> +
>>>> +	mutex_lock(&media_device_lock);
>>>> +
>>>> +	media_device_unregister(&mdi->mdev);
>>>> +	media_device_cleanup(&mdi->mdev);
>>>> +
>>>> +	list_del(&mdi->list);
>>>> +	mutex_unlock(&media_device_lock);
>>>> +
>>>> +	kfree(mdi);
>>>> +}
>>>> +
>>>> +/* Callers should hold media_device_lock when calling this function */
>>>> +static struct media_device *__media_device_get(struct device *dev,
>>>> +						const char *module_name,
>>>> +						struct module *modp)
>>>> +{
>>>> +	struct media_device_instance *mdi;
>>>> +
>>>> +	list_for_each_entry(mdi, &media_device_list, list) {
>>>> +
>>>> +		if (mdi->mdev.dev != dev)
>>>> +			continue;
>>>> +
>>>> +		kref_get(&mdi->refcount);
>>>> +
>>>> +		/* get module reference for the media_device owner */
>>>> +		if (modp != mdi->owner && !try_module_get(mdi->owner))
>>>> +			dev_err(dev, "%s: try_module_get() error\n", __func__);
>>>> +		dev_dbg(dev, "%s: get mdev=%p module_name %s\n",
>>>> +			__func__, &mdi->mdev, module_name);
>>>> +		return &mdi->mdev;
>>>> +	}
>>>> +
>>>> +	mdi = kzalloc(sizeof(*mdi), GFP_KERNEL);
>>>> +	if (!mdi)
>>>> +		return NULL;
>>>> +
>>>> +	mdi->owner = modp;
>>>> +	kref_init(&mdi->refcount);
>>>> +	list_add_tail(&mdi->list, &media_device_list);
>>>> +
>>>> +	dev_dbg(dev, "%s: alloc mdev=%p module_name %s\n", __func__,
>>>> +		&mdi->mdev, module_name);
>>>> +	return &mdi->mdev;
>>>> +}
>>>> +
>>>> +struct media_device *media_device_usb_allocate(struct usb_device *udev,
>>>> +					       const char *module_name)
>>>> +{
>>>> +	struct media_device *mdev;
>>>> +	struct module *modptr;
>>>> +
>>>> +	mutex_lock(&module_mutex);
>>>> +	modptr = find_module(module_name);
>>>> +	mutex_unlock(&module_mutex);
>>>> +
>>>> +	mutex_lock(&media_device_lock);
>>>> +	mdev = __media_device_get(&udev->dev, module_name, modptr);
>>>> +	if (!mdev) {
>>>> +		mutex_unlock(&media_device_lock);
>>>> +		return ERR_PTR(-ENOMEM);
>>>> +	}
>>>> +
>>>> +	/* check if media device is already initialized */
>>>> +	if (!mdev->dev)
>>>> +		__media_device_usb_init(mdev, udev, udev->product,
>>>> +					module_name);
>>>> +	mutex_unlock(&media_device_lock);
>>>> +	return mdev;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(media_device_usb_allocate);
>>>> +
>>>> +void media_device_delete(struct media_device *mdev, const char *module_name)
>>>> +{
>>>> +	struct media_device_instance *mdi = to_media_device_instance(mdev);
>>>> +	struct module *modptr;
>>>> +
>>>> +	dev_dbg(mdi->mdev.dev, "%s: mdev=%p module_name %s\n",
>>>> +		__func__, &mdi->mdev, module_name);
>>>> +
>>>> +	mutex_lock(&module_mutex);
>>>> +	modptr = find_module(module_name);
>>>> +	mutex_unlock(&module_mutex);
>>>> +
>>>> +	mutex_lock(&media_device_lock);
>>>> +	/* put module reference if media_device owner is not THIS_MODULE */
>>>> +	if (mdi->owner != modptr) {
>>>> +		module_put(mdi->owner);
>>>> +		dev_dbg(mdi->mdev.dev,
>>>> +			"%s decremented owner module reference\n", __func__);
>>>> +	}
>>>> +	mutex_unlock(&media_device_lock);
>>>> +	kref_put(&mdi->refcount, media_device_instance_release);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(media_device_delete);
>>>> diff --git a/include/media/media-dev-allocator.h b/include/media/media-dev-allocator.h
>>>> new file mode 100644
>>>> index 000000000000..69aee9a4b4c1
>>>> --- /dev/null
>>>> +++ b/include/media/media-dev-allocator.h
>>>> @@ -0,0 +1,54 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0+ */
>>>> +/*
>>>> + * media-dev-allocator.h - Media Controller Device Allocator API
>>>> + *
>>>> + * Copyright (c) 2018 Shuah Khan <shuah@kernel.org>
>>>> + *
>>>> + * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>> + */
>>>> +
>>>> +/*
>>>> + * This file adds a global ref-counted Media Controller Device Instance API.
>>>> + * A system wide global media device list is managed and each media device
>>>> + * includes a kref count. The last put on the media device releases the media
>>>> + * device instance.
>>>> + */
>>>> +
>>>> +#ifndef _MEDIA_DEV_ALLOCTOR_H
>>>> +#define _MEDIA_DEV_ALLOCTOR_H
>>>> +
>>>> +struct usb_device;
>>>> +
>>>> +#if defined(CONFIG_MEDIA_CONTROLLER) && defined(CONFIG_USB) && \
>>>> +	defined(CONFIG_MODULES)
>>>> +/**
>>>> + * media_device_usb_allocate() - Allocate and return struct &media device
>>>> + *
>>>> + * @udev:		struct &usb_device pointer
>>>> + * @module_name:	should be filled with %KBUILD_MODNAME
>>>> + *
>>>> + * This interface should be called to allocate a Media Device when multiple
>>>> + * drivers share usb_device and the media device. This interface allocates
>>>> + * &media_device structure and calls media_device_usb_init() to initialize
>>>> + * it.
>>>> + *
>>>> + */
>>>> +struct media_device *media_device_usb_allocate(struct usb_device *udev,
>>>> +					       char *module_name);
>>>> +/**
>>>> + * media_device_delete() - Release media device. Calls kref_put().
>>>> + *
>>>> + * @mdev:		struct &media_device pointer
>>>> + * @module_name:	should be filled with %KBUILD_MODNAME
>>>> + *
>>>> + * This interface should be called to put Media Device Instance kref.
>>>> + */
>>>> +void media_device_delete(struct media_device *mdev, char *module_name);
>>>> +#else
>>>> +static inline struct media_device *media_device_usb_allocate(
>>>> +			struct usb_device *udev, char *module_name)
>>>> +			{ return NULL; }
>>>> +static inline void media_device_delete(
>>>> +			struct media_device *mdev, char *module_name) { }
>>>> +#endif /* CONFIG_MEDIA_CONTROLLER && CONFIG_USB && CONFIG_MODULES */
>>>
>>> I am still getting sparse warnings:
>>>
>>> drivers/media/media-dev-allocator.c /home/hans/work/build/media-git/drivers/media/media-dev-allocator.c:94:21:  warning: symbol 'media_device_usb_allocate' was not declared. Should it be static?
>>> drivers/media/media-dev-allocator.c /home/hans/work/build/media-git/drivers/media/media-dev-allocator.c:120:6:  warning: symbol 'media_device_delete' was not declared. Should it be static?
>>> drivers/media/media-dev-allocator.c:94:22: warning: no previous prototype for 'media_device_usb_allocate' [-Wmissing-prototypes]
>>> drivers/media/media-dev-allocator.c:120:6: warning: no previous prototype for 'media_device_delete' [-Wmissing-prototypes]
>>
>> I didn't see the warns - maybe I have to upgrade to the latest gcc.
> 
> Ah, media-dev-allocator.c doesn't include media-dev-allocator.h.
> 
> I suspect that that's the reason for the sparse warning.
> 
>>
>>>
>>> This makes sense since if the #if above evaluates to 0, then the
>>> static inlines are used. But in media-dev-allocator.c these functions
>>> are still present without a corresponding prototype.
>>>
>>> You likely need a similar #if in media-dev-allocator.c.
>>>
>>> Have you tested this if CONFIG_MODULES is not set? Does au0828 still work
>>> w.r.t. sharing the shared resource? Has the driver been tested when MEDIA_CONTROLLER
>>> is not set? Should au0828 select MEDIA_CONTROLLER explicitly perhaps?
>>
>> Unfortunately without MEDIA_CONTROLLER and CONFIG_MODULES, no sharing
>> happening. The only way to ensure sharing in all cases, is selecting
>> MEDIA_CONTROLLER and MODULES in au0828 and that will make sure
>> snd-usb-audio enables SND_USB_AUDIO_USE_MEDIA_CONTROLLER and all of
>> the sharing logic works.
> 
> You can select MEDIA_CONTROLLER for au0828, but never MODULES. Selecting
> MEDIA_CONTROLLER makes sense, I have no objection to that.
> 
> What do you mean with 'no sharing happening'? You have to deal with
> modules to make sure they are not unloaded, but other than that this
> feature shouldn't depend on MODULES. Or am I missing something?
> 
>>

You are right. It shouldn't depend on MODULES. The code that deals with
modules so they don't get unloaded has dependency on MODULES, not all
of it. I see the problem now.

I will update au0828 to select MEDIA_CONTROLLER and update the module
logic and send v13. Maybe that is the lucky version :)

thanks,
-- Shuah

