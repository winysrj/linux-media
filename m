Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49004 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754449AbeDWJ7i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 05:59:38 -0400
Subject: Re: [RFCv11 PATCH 03/29] media-request: allocate media requests
To: Tomasz Figa <tfiga@google.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-4-hverkuil@xs4all.nl>
 <CAAFQd5D4b2=cAM+64Oyt=8VEhxevyZ=rJjgZK7Eds_+du9uOEw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <829a1435-66a7-ceb9-8b55-6cc692df4222@xs4all.nl>
Date: Mon, 23 Apr 2018 11:59:34 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5D4b2=cAM+64Oyt=8VEhxevyZ=rJjgZK7Eds_+du9uOEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/2018 07:35 AM, Tomasz Figa wrote:
> Hi Hans,
> 
> On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> [snip]
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
> 
> I'm not sure about the origin of this line, but it's not a correct
> copyright for kernel code produced as a part of Chrome OS project. It would
> normally be something like
> 
> Copyright (C) 2018 Google, Inc.

Fixed.

> 
>> + *
>> + * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
>> + */
>> +
>> +#include <linux/anon_inodes.h>
>> +#include <linux/file.h>
>> +#include <linux/mm.h>
>> +#include <linux/string.h>
>> +
>> +#include <media/media-device.h>
>> +#include <media/media-request.h>
>> +
>> +int media_request_alloc(struct media_device *mdev,
>> +                       struct media_request_alloc *alloc)
>> +{
>> +       return -ENOMEM;
>> +}
>> diff --git a/include/media/media-device.h b/include/media/media-device.h
>> index bcc6ec434f1f..07e323c57202 100644
>> --- a/include/media/media-device.h
>> +++ b/include/media/media-device.h
>> @@ -19,6 +19,7 @@
>>   #ifndef _MEDIA_DEVICE_H
>>   #define _MEDIA_DEVICE_H
> 
>> +#include <linux/anon_inodes.h>
> 
> What is the need for anon_inodes in this header?
> 
>>   #include <linux/list.h>
>>   #include <linux/mutex.h>
> 
>> @@ -27,6 +28,7 @@
> 
>>   struct ida;
>>   struct device;
>> +struct media_device;
> 
>>   /**
>>    * struct media_entity_notify - Media Entity Notify
>> @@ -50,10 +52,16 @@ struct media_entity_notify {
>>    * struct media_device_ops - Media device operations
>>    * @link_notify: Link state change notification callback. This callback
> is
>>    *              called with the graph_mutex held.
>> + * @req_alloc: Allocate a request
>> + * @req_free: Free a request
>> + * @req_queue: Queue a request
>>    */
>>   struct media_device_ops {
>>          int (*link_notify)(struct media_link *link, u32 flags,
>>                             unsigned int notification);
>> +       struct media_request *(*req_alloc)(struct media_device *mdev);
>> +       void (*req_free)(struct media_request *req);
>> +       int (*req_queue)(struct media_request *req);
>>   };
> 
>>   /**
>> @@ -88,6 +96,8 @@ struct media_device_ops {
>>    * @disable_source: Disable Source Handler function pointer
>>    *
>>    * @ops:       Operation handler callbacks
>> + * @req_lock:  Serialise access to requests
>> + * @req_queue_mutex: Serialise validating and queueing requests
> 
> Let's bikeshed a bit! "access" sounds like a superset of "validating and
> queuing" to me. Perhaps it could make sense to be a bit more specific on
> what type of access the spinlock is used for?

req_lock is unused and is now deleted. It's a left-over from older code.

Regards,

	Hans

> 
> Best regards,
> Tomasz
> 
