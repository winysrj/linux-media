Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:42925 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752961AbeBVJi0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 04:38:26 -0500
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
 <c016f8f1-06f3-cc3b-03d1-7a17c39dbec0@xs4all.nl>
 <CAPBb6MXmALFZp+EB8BjKnYO7FYV3eU9LisJwR4Qp265GRhA3eg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <591e7b83-9322-bf73-c762-6709c811d9de@xs4all.nl>
Date: Thu, 22 Feb 2018 10:38:17 +0100
MIME-Version: 1.0
In-Reply-To: <CAPBb6MXmALFZp+EB8BjKnYO7FYV3eU9LisJwR4Qp265GRhA3eg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/22/18 10:30, Alexandre Courbot wrote:
> On Wed, Feb 21, 2018 at 4:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 02/21/2018 07:01 AM, Alexandre Courbot wrote:
>>> Hi Hans,
>>>
>>> On Tue, Feb 20, 2018 at 7:36 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On 02/20/18 05:44, Alexandre Courbot wrote:
>>
>> <snip>
>>
>>>>> +#define MEDIA_REQUEST_IOC(__cmd, func)                                       \
>>>>> +     [_IOC_NR(MEDIA_REQUEST_IOC_##__cmd) - 0x80] = {                 \
>>>>> +             .cmd = MEDIA_REQUEST_IOC_##__cmd,                       \
>>>>> +             .fn = func,                                             \
>>>>> +     }
>>>>> +
>>>>> +struct media_request_ioctl_info {
>>>>> +     unsigned int cmd;
>>>>> +     long (*fn)(struct media_request *req);
>>>>> +};
>>>>> +
>>>>> +static const struct media_request_ioctl_info ioctl_info[] = {
>>>>> +     MEDIA_REQUEST_IOC(SUBMIT, media_request_ioctl_submit),
>>>>> +     MEDIA_REQUEST_IOC(REINIT, media_request_ioctl_reinit),
>>>>
>>>> There are only two ioctls, so there is really no need for the
>>>> MEDIA_REQUEST_IOC define. Just keep it simple.
>>>
>>> The number of times it is used doesn't change the fact that it helps
>>> with readability IMHO.
>>
>> But this macro just boils down to:
>>
>> static const struct media_request_ioctl_info ioctl_info[] = {
>>         { MEDIA_REQUEST_IOC_SUBMIT, media_request_ioctl_submit },
>>         { MEDIA_REQUEST_IOC_REINIT, media_request_ioctl_reinit },
>> };
>>
>> It's absolutely identical! So it seems senseless to me.
> 
> This expands to more than that - the index needs to be offset by 0x80,
> something we probably don't want to repeat every line.
> 
>>
>>>
>>>>
>>>>> +};
>>>>> +
>>>>> +static long media_request_ioctl(struct file *filp, unsigned int cmd,
>>>>> +                             unsigned long __arg)
>>>>> +{
>>>>> +     struct media_request *req = filp->private_data;
>>>>> +     const struct media_request_ioctl_info *info;
>>>>> +
>>>>> +     if ((_IOC_NR(cmd) < 0x80) ||
>>>>
>>>> Why start the ioctl number at 0x80? Why not just 0?
>>>> It avoids all this hassle with the 0x80 offset.
>>
>> There is no clash with the MC ioctls, so I really don't believe the 0x80
>> offset is needed.
> 
> I suppose your comment in patch 16 supersedes this one. :)

Yes, it does. I realized later why this was done like this.

That said, I don't like the magic value. Something like this might be
cleaner:

	const unsigned int first_ioc_nr = _IOC_NR(MEDIA_REQUEST_IOC_SUBMIT);

Then use first_ioc_nr (or nr_offset or whatever) instead of 0x80.

Regards,

	Hans
