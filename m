Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56916 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbcE0Uo5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 16:44:57 -0400
Subject: Re: [PATCH v2 1/2] media: Media Device Allocator API
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	hans.verkuil@cisco.com, chehabrafael@gmail.com,
	javier@osg.samsung.com, inki.dae@samsung.com,
	g.liakhovetski@gmx.de, jh1009.sung@samsung.com
References: <cover.1464132578.git.shuahkh@osg.samsung.com>
 <90f39ad8de612214e52d7be35be3077b7510786a.1464132578.git.shuahkh@osg.samsung.com>
 <57484B11.2060400@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5748B1BF.8050400@osg.samsung.com>
Date: Fri, 27 May 2016 14:44:47 -0600
MIME-Version: 1.0
In-Reply-To: <57484B11.2060400@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/2016 07:26 AM, Hans Verkuil wrote:
> On 05/25/2016 01:39 AM, Shuah Khan wrote:
>> Media Device Allocator API to allows multiple drivers share a media device.
>> Using this API, drivers can allocate a media device with the shared struct
>> device as the key. Once the media device is allocated by a driver, other
>> drivers can get a reference to it. The media device is released when all
>> the references are released.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/Makefile              |   3 +-
>>  drivers/media/media-dev-allocator.c | 120 ++++++++++++++++++++++++++++++++++++
>>  include/media/media-dev-allocator.h |  85 +++++++++++++++++++++++++
>>  3 files changed, 207 insertions(+), 1 deletion(-)
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
>> index 0000000..b8c9811
>> --- /dev/null
>> +++ b/drivers/media/media-dev-allocator.c
>> @@ -0,0 +1,120 @@
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
> 
> Add a comment here saying that media_device_lock has to be locked when
> calling this get function.
> 

Fixed all the comments and sent patch v3. Thanks again for the review.

-- Shuah

