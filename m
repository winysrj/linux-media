Return-Path: <SRS0=XDLN=QC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D156FC282C0
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 00:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D85621902
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 00:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548462453;
	bh=8LXYoJtRhagIsq2Y7nU+K6k++/CRn2zRN4+Hk0OINJ4=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=ANKi//QEC8ztIdUrhAzayysUdRzUH0eQX8ryqFeuGGE6TUYNWLvcSsUEY9AQexzy6
	 hbVUBhp33DWAqt0UnZUi9JkocWKqe2zAzihPglLytB5dAL/ljehL1h0VOVtT1fO8YU
	 5ehuVhJmK/o2lfqR6G2ACBQ7GquwAlY6/UYTlOOg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfAZA11 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 19:27:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbfAZA11 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 19:27:27 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A5BE218CD;
        Sat, 26 Jan 2019 00:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548462446;
        bh=8LXYoJtRhagIsq2Y7nU+K6k++/CRn2zRN4+Hk0OINJ4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fmzJ1g2SDFKTifZMHVtJCff17FxVSr7mrwIdrroulUb9awDM2YW0AuufSXYUtMqDd
         77So73FmYhxDzku6OFaunZVHAuU2goXf3NpV7bFaC1U5Ej7px524QXvUZ2okfKR5dc
         WW76y1PM9lRjr7USeIVvmTVbCEn08BZJTHcUZKcE=
Subject: Re: [PATCH v10 1/4] media: Media Device Allocator API
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        shuah <shuah@kernel.org>
References: <cover.1548360791.git.shuah@kernel.org>
 <df3aae79629e5c0ab5a57dfaf5e2d815a134cd2d.1548360791.git.shuah@kernel.org>
 <20190125153843.onbq7uiwpjp3b2y7@valkosipuli.retiisi.org.uk>
From:   shuah <shuah@kernel.org>
Message-ID: <fa3a4d98-d4a3-47ac-0fdc-4f3e0c7c630d@kernel.org>
Date:   Fri, 25 Jan 2019 17:27:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190125153843.onbq7uiwpjp3b2y7@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On 1/25/19 8:38 AM, Sakari Ailus wrote:
> Hi Shuah,
> 
> On Thu, Jan 24, 2019 at 01:32:38PM -0700, Shuah Khan wrote:
>> Media Device Allocator API to allows multiple drivers share a media device.
>> This API solves a very common use-case for media devices where one physical
>> device (an USB stick) provides both audio and video. When such media device
>> exposes a standard USB Audio class, a proprietary Video class, two or more
>> independent drivers will share a single physical USB bridge. In such cases,
>> it is necessary to coordinate access to the shared resource.
>>
>> Using this API, drivers can allocate a media device with the shared struct
>> device as the key. Once the media device is allocated by a driver, other
>> drivers can get a reference to it. The media device is released when all
>> the references are released.
> 
> Are there real, non-USB devices that could use the same API?
> 

There might be. I don't have any to test. This patch is restricted
to USB at the moment.

>>
>> Signed-off-by: Shuah Khan <shuah@kernel.org>
>> ---
>>   Documentation/media/kapi/mc-core.rst |  41 ++++++++
>>   drivers/media/Makefile               |   4 +
>>   drivers/media/media-dev-allocator.c  | 144 +++++++++++++++++++++++++++
>>   include/media/media-dev-allocator.h  |  53 ++++++++++
>>   4 files changed, 242 insertions(+)
>>   create mode 100644 drivers/media/media-dev-allocator.c
>>   create mode 100644 include/media/media-dev-allocator.h
>>
>> diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
>> index 0bcfeadbc52d..07f2a6a90af2 100644
>> --- a/Documentation/media/kapi/mc-core.rst
>> +++ b/Documentation/media/kapi/mc-core.rst
>> @@ -259,6 +259,45 @@ Subsystems should facilitate link validation by providing subsystem specific
>>   helper functions to provide easy access for commonly needed information, and
>>   in the end provide a way to use driver-specific callbacks.
>>   
>> +Media Controller Device Allocator API
>> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> +
>> +When the media device belongs to more than one driver, the shared media
>> +device is allocated with the shared struct device as the key for look ups.
>> +
>> +The shared media device should stay in registered state until the last
>> +driver unregisters it. In addition, the media device should be released when
>> +all the references are released. Each driver gets a reference to the media
>> +device during probe, when it allocates the media device. If media device is
>> +already allocated, the allocate API bumps up the refcount and returns the
>> +existing media device. The driver puts the reference back in its disconnect
>> +routine when it calls :c:func:`media_device_delete()`.
>> +
>> +The media device is unregistered and cleaned up from the kref put handler to
>> +ensure that the media device stays in registered state until the last driver
>> +unregisters the media device.
>> +
>> +**Driver Usage**
>> +
>> +Drivers should use the appropriate media-core routines to manage the shared
>> +media device life-time handling the two states:
>> +1. allocate -> register -> delete
>> +2. get reference to already registered device -> delete
>> +
>> +call :c:func:`media_device_delete()` routine to make sure the shared media
>> +device delete is handled correctly.
>> +
>> +**driver probe:**
>> +Call :c:func:`media_device_usb_allocate()` to allocate or get a reference
>> +Call :c:func:`media_device_register()`, if media devnode isn't registered
>> +
>> +**driver disconnect:**
>> +Call :c:func:`media_device_delete()` to free the media_device. Freeing is
>> +handled by the kref put handler.
>> +
>> +API Definitions
>> +^^^^^^^^^^^^^^^
>> +
>>   .. kernel-doc:: include/media/media-device.h
>>   
>>   .. kernel-doc:: include/media/media-devnode.h
>> @@ -266,3 +305,5 @@ in the end provide a way to use driver-specific callbacks.
>>   .. kernel-doc:: include/media/media-entity.h
>>   
>>   .. kernel-doc:: include/media/media-request.h
>> +
>> +.. kernel-doc:: include/media/media-dev-allocator.h
>> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
>> index 985d35ec6b29..1d7653318af6 100644
>> --- a/drivers/media/Makefile
>> +++ b/drivers/media/Makefile
>> @@ -6,6 +6,10 @@
>>   media-objs	:= media-device.o media-devnode.o media-entity.o \
>>   		   media-request.o
>>   
>> +ifeq ($(CONFIG_USB),y)
>> +	media-objs += media-dev-allocator.o
>> +endif
>> +
>>   #
>>   # I2C drivers should come before other drivers, otherwise they'll fail
>>   # when compiled as builtin drivers
>> diff --git a/drivers/media/media-dev-allocator.c b/drivers/media/media-dev-allocator.c
>> new file mode 100644
>> index 000000000000..4606456c1e86
>> --- /dev/null
>> +++ b/drivers/media/media-dev-allocator.c
>> @@ -0,0 +1,144 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
> 
> GPL-2.0+
> 

I would like to address this in a follow-on patch instead of
re-doing the series again. Hope that is okay.

>> +/*
>> + * media-dev-allocator.c - Media Controller Device Allocator API
>> + *
>> + * Copyright (c) 2018 Shuah Khan <shuah@kernel.org>
>> + *
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
>> +#include <linux/kref.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/usb.h>
>> +
>> +#include <media/media-device.h>
>> +
>> +static LIST_HEAD(media_device_list);
>> +static DEFINE_MUTEX(media_device_lock);
>> +
>> +struct media_device_instance {
>> +	struct media_device mdev;
>> +	struct module *owner;
>> +	struct list_head list;
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
> 
> This is a problem, albeit not really more of a problem than it is in a
> driver.

Okay good to know that it can be addressed in your media device
refcounting series.

The refcounting changes can be made here instead. I'll take this
> into account in the media device refcounting series I'm planning to start
> working on again; would you be perhaps able to help testing with this
> device once I have patches in that shape? I have no access to the hardware.
> 

Absolutely. I will be happy to help you with testing on the same
hardware, I used for this series.

>> +
>> +	list_del(&mdi->list);
>> +	mutex_unlock(&media_device_lock);
>> +
>> +	kfree(mdi);
>> +}
>> +
>> +/* Callers should hold media_device_lock when calling this function */
>> +static struct media_device *__media_device_get(struct device *dev,
>> +						const char *module_name,
>> +						struct module *modp)
>> +{
>> +	struct media_device_instance *mdi;
>> +
>> +	list_for_each_entry(mdi, &media_device_list, list) {
>> +
>> +		if (mdi->mdev.dev != dev)
>> +			continue;
>> +
>> +		kref_get(&mdi->refcount);
>> +
>> +		/* get module reference for the media_device owner */
>> +		if (modp != mdi->owner && !try_module_get(mdi->owner))
>> +			dev_err(dev, "%s: try_module_get() error\n", __func__);
>> +		dev_dbg(dev, "%s: get mdev=%p module_name %s\n",
>> +			__func__, &mdi->mdev, module_name);
>> +		return &mdi->mdev;
>> +	}
>> +
>> +	mdi = kzalloc(sizeof(*mdi), GFP_KERNEL);
>> +	if (!mdi)
>> +		return NULL;
>> +
>> +	mdi->owner = modp;
>> +	kref_init(&mdi->refcount);
>> +	list_add_tail(&mdi->list, &media_device_list);
>> +
>> +	dev_dbg(dev, "%s: alloc mdev=%p module_name %s\n", __func__,
>> +		&mdi->mdev, module_name);
>> +	return &mdi->mdev;
>> +}
>> +
>> +#if IS_ENABLED(CONFIG_USB)
> 
> You already compile the file only if CONFIG_USB is enabled. I think you
> could remove this.
> 
>> +struct media_device *media_device_usb_allocate(struct usb_device *udev,
>> +					       const char *module_name)
> 
> I'd like to suggest working based on usb_interface instead of usb_device
> here: that object already exists and you can find out the device based on
> it. It seems all callers of this function already have the usb_interface
> around.
> 

Is there an advantage to using interface instead of the parent device?
Is there a problem doing it this way?


>> +{
>> +	struct media_device *mdev;
>> +	struct module *modptr;
>> +
>> +	mutex_lock(&module_mutex);
>> +	modptr = find_module(module_name);
>> +	mutex_unlock(&module_mutex);
>> +
>> +	mutex_lock(&media_device_lock);
>> +	mdev = __media_device_get(&udev->dev, module_name, modptr);
>> +	if (!mdev) {
>> +		mutex_unlock(&media_device_lock);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	/* check if media device is already initialized */
>> +	if (!mdev->dev)
>> +		__media_device_usb_init(mdev, udev, udev->product,
>> +					module_name);
>> +	mutex_unlock(&media_device_lock);
>> +	return mdev;
>> +}
>> +EXPORT_SYMBOL_GPL(media_device_usb_allocate);
>> +#endif
>> +
>> +void media_device_delete(struct media_device *mdev, const char *module_name)
> 
> Same here. The use of the module name seems a bit hackish to me, albeit I
> suppose it'd work, too.
> 

What is hackish about it? I found it very useful to use it in debug and
error messages that are user-friendly.

thanks,
-- Shuah
