Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:46423 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754935AbeDWLtQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 07:49:16 -0400
Subject: Re: [RFCv11 PATCH 03/29] media-request: allocate media requests
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-4-hverkuil@xs4all.nl>
 <20180410065239.7e1036d0@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a09590ff-3e44-7f20-9a3a-45fa5e99dcc6@xs4all.nl>
Date: Mon, 23 Apr 2018 13:49:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180410065239.7e1036d0@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/2018 11:52 AM, Mauro Carvalho Chehab wrote:
> Em Mon,  9 Apr 2018 16:20:00 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add support for allocating a new request. This is only supported
>> if mdev->ops->req_queue is set, i.e. the driver indicates that it
>> supports queueing requests.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/Makefile        |  3 ++-
>>  drivers/media/media-device.c  | 14 ++++++++++++++
>>  drivers/media/media-request.c | 23 +++++++++++++++++++++++
>>  include/media/media-device.h  | 13 +++++++++++++
>>  include/media/media-request.h | 22 ++++++++++++++++++++++
>>  5 files changed, 74 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/media/media-request.c
>>  create mode 100644 include/media/media-request.h
>>
>> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
>> index 594b462ddf0e..985d35ec6b29 100644
>> --- a/drivers/media/Makefile
>> +++ b/drivers/media/Makefile
>> @@ -3,7 +3,8 @@
>>  # Makefile for the kernel multimedia device drivers.
>>  #
>>  
>> -media-objs	:= media-device.o media-devnode.o media-entity.o
>> +media-objs	:= media-device.o media-devnode.o media-entity.o \
>> +		   media-request.o
>>  
>>  #
>>  # I2C drivers should come before other drivers, otherwise they'll fail
>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>> index 35e81f7c0d2f..acb583c0eacd 100644
>> --- a/drivers/media/media-device.c
>> +++ b/drivers/media/media-device.c
>> @@ -32,6 +32,7 @@
>>  #include <media/media-device.h>
>>  #include <media/media-devnode.h>
>>  #include <media/media-entity.h>
>> +#include <media/media-request.h>
>>  
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>>  
>> @@ -366,6 +367,15 @@ static long media_device_get_topology(struct media_device *mdev,
>>  	return ret;
>>  }
>>  
>> +static long media_device_request_alloc(struct media_device *mdev,
>> +				       struct media_request_alloc *alloc)
>> +{
>> +	if (!mdev->ops || !mdev->ops->req_queue)
>> +		return -ENOTTY;
>> +
>> +	return media_request_alloc(mdev, alloc);
>> +}
>> +
>>  static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
>>  {
>>  	/* All media IOCTLs are _IOWR() */
>> @@ -414,6 +424,7 @@ static const struct media_ioctl_info ioctl_info[] = {
>>  	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
>>  	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
>>  	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
>> +	MEDIA_IOC(REQUEST_ALLOC, media_device_request_alloc, 0),
>>  };
>>  
>>  static long media_device_ioctl(struct file *filp, unsigned int cmd,
>> @@ -686,6 +697,9 @@ void media_device_init(struct media_device *mdev)
>>  	INIT_LIST_HEAD(&mdev->pads);
>>  	INIT_LIST_HEAD(&mdev->links);
>>  	INIT_LIST_HEAD(&mdev->entity_notify);
>> +
>> +	spin_lock_init(&mdev->req_lock);
>> +	mutex_init(&mdev->req_queue_mutex);
>>  	mutex_init(&mdev->graph_mutex);
>>  	ida_init(&mdev->entity_internal_idx);
>>  
>> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
>> new file mode 100644
>> index 000000000000..ead78613fdbe
>> --- /dev/null
>> +++ b/drivers/media/media-request.c
>> @@ -0,0 +1,23 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Media device request objects
>> + *
>> + * Copyright (C) 2018 Intel Corporation
>> + * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
>> + *
>> + * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
>> + */
>> +
>> +#include <linux/anon_inodes.h>
> 
> Not needed. You already included it at media_device.h.

Actually, it is needed here, but not in media_device.h

> 
>> +#include <linux/file.h>
>> +#include <linux/mm.h>
>> +#include <linux/string.h>
> 
> Why do you need so many includes for a stub function?

I'm going to merge patch 3 and 4. Splitting it up it too confusing for
reviewers, I've noticed. These headers are needed for patch 4.

As mentioned in an earlier reply: the req_lock spinlock is unused and is
now deleted. It was a left-over from older versions and that's what caused
the locking confusion.

Regards,

	Hans


> 
>> +
>> +#include <media/media-device.h>
>> +#include <media/media-request.h>
>> +
>> +int media_request_alloc(struct media_device *mdev,
>> +			struct media_request_alloc *alloc)
>> +{
>> +	return -ENOMEM;
>> +}
>> diff --git a/include/media/media-device.h b/include/media/media-device.h
>> index bcc6ec434f1f..07e323c57202 100644
>> --- a/include/media/media-device.h
>> +++ b/include/media/media-device.h
>> @@ -19,6 +19,7 @@
>>  #ifndef _MEDIA_DEVICE_H
>>  #define _MEDIA_DEVICE_H
>>  
>> +#include <linux/anon_inodes.h>
> 
> Why do you need it? I don't see anything below needing it.
> 
>>  #include <linux/list.h>
>>  #include <linux/mutex.h>
>>  
>> @@ -27,6 +28,7 @@
>>  
>>  struct ida;
>>  struct device;
>> +struct media_device;
>>  
>>  /**
>>   * struct media_entity_notify - Media Entity Notify
>> @@ -50,10 +52,16 @@ struct media_entity_notify {
>>   * struct media_device_ops - Media device operations
>>   * @link_notify: Link state change notification callback. This callback is
>>   *		 called with the graph_mutex held.
>> + * @req_alloc: Allocate a request
>> + * @req_free: Free a request
>> + * @req_queue: Queue a request
>>   */
>>  struct media_device_ops {
>>  	int (*link_notify)(struct media_link *link, u32 flags,
>>  			   unsigned int notification);
>> +	struct media_request *(*req_alloc)(struct media_device *mdev);
>> +	void (*req_free)(struct media_request *req);
>> +	int (*req_queue)(struct media_request *req);
>>  };
>>  
>>  /**
>> @@ -88,6 +96,8 @@ struct media_device_ops {
>>   * @disable_source: Disable Source Handler function pointer
>>   *
>>   * @ops:	Operation handler callbacks
>> + * @req_lock:	Serialise access to requests
>> + * @req_queue_mutex: Serialise validating and queueing requests
> 
> IMHO, this would better describe it:
> 	Serialise validate and queue requests
> 
> Yet, IMO, it doesn't let it clear when the spin lock should be
> used and when the mutex should be used.
> 
> I mean, what of them protect what variable?
> 
>>   *
>>   * This structure represents an abstract high-level media device. It allows easy
>>   * access to entities and provides basic media device-level support. The
>> @@ -158,6 +168,9 @@ struct media_device {
>>  	void (*disable_source)(struct media_entity *entity);
>>  
>>  	const struct media_device_ops *ops;
>> +
>> +	spinlock_t req_lock;
>> +	struct mutex req_queue_mutex;
>>  };
>>  
>>  /* We don't need to include pci.h or usb.h here */
>> diff --git a/include/media/media-request.h b/include/media/media-request.h
>> new file mode 100644
>> index 000000000000..dae3eccd9aa7
>> --- /dev/null
>> +++ b/include/media/media-request.h
>> @@ -0,0 +1,22 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Media device request objects
>> + *
>> + * Copyright (C) 2018 Intel Corporation
>> + *
>> + * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
>> + */
>> +
>> +#ifndef MEDIA_REQUEST_H
>> +#define MEDIA_REQUEST_H
>> +
>> +#include <linux/list.h>
>> +#include <linux/slab.h>
>> +#include <linux/spinlock.h>
> 
> Why those includes are needed?
> 
>> +
>> +#include <media/media-device.h>
>> +
>> +int media_request_alloc(struct media_device *mdev,
>> +			struct media_request_alloc *alloc);
>> +
>> +#endif
> 
> 
> 
> Thanks,
> Mauro
> 
