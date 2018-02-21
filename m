Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47789 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751295AbeBUH3Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 02:29:25 -0500
Subject: Re: [RFCv4 01/21] media: add request API core and UAPI
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20180220044425.169493-1-acourbot@chromium.org>
 <20180220044425.169493-2-acourbot@chromium.org>
 <5fd863ad-a0fe-88d7-05bd-90c2b4096145@xs4all.nl>
 <CAPBb6MUUuo+50zfs-XaRcVD6sV3uaownVeFKgX=A6NkTO1he1w@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c016f8f1-06f3-cc3b-03d1-7a17c39dbec0@xs4all.nl>
Date: Wed, 21 Feb 2018 08:29:20 +0100
MIME-Version: 1.0
In-Reply-To: <CAPBb6MUUuo+50zfs-XaRcVD6sV3uaownVeFKgX=A6NkTO1he1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/2018 07:01 AM, Alexandre Courbot wrote:
> Hi Hans,
> 
> On Tue, Feb 20, 2018 at 7:36 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 02/20/18 05:44, Alexandre Courbot wrote:

<snip>

>>> +#define MEDIA_REQUEST_IOC(__cmd, func)                                       \
>>> +     [_IOC_NR(MEDIA_REQUEST_IOC_##__cmd) - 0x80] = {                 \
>>> +             .cmd = MEDIA_REQUEST_IOC_##__cmd,                       \
>>> +             .fn = func,                                             \
>>> +     }
>>> +
>>> +struct media_request_ioctl_info {
>>> +     unsigned int cmd;
>>> +     long (*fn)(struct media_request *req);
>>> +};
>>> +
>>> +static const struct media_request_ioctl_info ioctl_info[] = {
>>> +     MEDIA_REQUEST_IOC(SUBMIT, media_request_ioctl_submit),
>>> +     MEDIA_REQUEST_IOC(REINIT, media_request_ioctl_reinit),
>>
>> There are only two ioctls, so there is really no need for the
>> MEDIA_REQUEST_IOC define. Just keep it simple.
> 
> The number of times it is used doesn't change the fact that it helps
> with readability IMHO.

But this macro just boils down to:

static const struct media_request_ioctl_info ioctl_info[] = {
	{ MEDIA_REQUEST_IOC_SUBMIT, media_request_ioctl_submit },
	{ MEDIA_REQUEST_IOC_REINIT, media_request_ioctl_reinit },
};

It's absolutely identical! So it seems senseless to me.

> 
>>
>>> +};
>>> +
>>> +static long media_request_ioctl(struct file *filp, unsigned int cmd,
>>> +                             unsigned long __arg)
>>> +{
>>> +     struct media_request *req = filp->private_data;
>>> +     const struct media_request_ioctl_info *info;
>>> +
>>> +     if ((_IOC_NR(cmd) < 0x80) ||
>>
>> Why start the ioctl number at 0x80? Why not just 0?
>> It avoids all this hassle with the 0x80 offset.

There is no clash with the MC ioctls, so I really don't believe the 0x80
offset is needed.

>>
>>> +          _IOC_NR(cmd) >= 0x80 + ARRAY_SIZE(ioctl_info) ||
>>> +          ioctl_info[_IOC_NR(cmd) - 0x80].cmd != cmd)
>>> +             return -ENOIOCTLCMD;
>>> +
>>> +     info = &ioctl_info[_IOC_NR(cmd) - 0x80];
>>> +
>>> +     return info->fn(req);
>>> +}

<snip>

>>> diff --git a/include/uapi/linux/media-request.h b/include/uapi/linux/media-request.h
>>> new file mode 100644
>>> index 000000000000..5d30f731a442
>>> --- /dev/null
>>> +++ b/include/uapi/linux/media-request.h
>>> @@ -0,0 +1,37 @@
>>> +/*
>>> + * Media requests UAPI
>>> + *
>>> + * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +
>>> +#ifndef __LINUX_MEDIA_REQUEST_H
>>> +#define __LINUX_MEDIA_REQUEST_H
>>> +
>>> +#ifndef __KERNEL__
>>> +#include <stdint.h>
>>> +#endif
>>> +#include <linux/ioctl.h>
>>> +#include <linux/types.h>
>>> +#include <linux/version.h>
>>> +
>>> +/* Only check that requests can be used, do not allocate */
>>> +#define MEDIA_REQUEST_FLAG_TEST                      0x00000001
>>> +
>>> +struct media_request_new {
>>> +     __u32 flags;
>>> +     __s32 fd;
>>> +} __attribute__ ((packed));
>>> +
>>> +#define MEDIA_REQUEST_IOC_SUBMIT       _IO('|',  128)
>>> +#define MEDIA_REQUEST_IOC_REINIT       _IO('|',  129)
>>> +
>>> +#endif
>>>
>>
>> I need to think a bit more on this internal API, so I might come back
>> to this patch for more comments.
> 
> I think I should probably elaborate on why I think it is advantageous
> to have these ioctls handled here.

Sorry for the confusion, I was not actually referring to these ioctls.
In fact, I really like them. It was more a general comment about the
request API core.

I should have been more clear.

Regards,

	Hans

> 
> One of the reasons if that it does not force user-space to keep track
> of who issued the request to operate on it. Semantically, the only
> device a request could be submitted to is the device that produced it
> anyway, so since that argument is constant we may as well get rid of
> it (and we also don't need to pass the request FD as argument
> anymore).
> 
> It also gives us more freedom when designing new request-related
> ioctls: before, all request-related operations were multiplexed under
> a single MEDIA_IOC_REQUEST_CMD ioctl, which cmd field indicated the
> actual operation to perform. With this design, all the arguments must
> fit within the media_request_cmd structure, which may cause confusion
> as it will have to be variable-sized. I am thinking in particular
> about a future atomic-like API to set topology, controls and buffers
> related to a request all at the same time. Having it as a request
> ioctl seems perfectly fitting to me.
> 
