Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:43376 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751778AbeAaIK1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 03:10:27 -0500
Received: by mail-ua0-f178.google.com with SMTP id i5so8845003uai.10
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 00:10:27 -0800 (PST)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com. [209.85.213.41])
        by smtp.gmail.com with ESMTPSA id s15sm5291016vkf.10.2018.01.31.00.10.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2018 00:10:25 -0800 (PST)
Received: by mail-vk0-f41.google.com with SMTP id h69so8490347vke.7
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 00:10:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <307f58dd-ce7e-b6f5-092a-f8679349be73@xs4all.nl>
References: <20180126060216.147918-1-acourbot@chromium.org>
 <ced425a2-8b66-05c6-367d-46a0a40b1873@xs4all.nl> <CAPBb6MU5Ph=_rH_TOQi5mstujAPMTWqC_1d-8_TcuGx25sOJvg@mail.gmail.com>
 <307f58dd-ce7e-b6f5-092a-f8679349be73@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 31 Jan 2018 17:10:04 +0900
Message-ID: <CAAFQd5AbdAGteHOfKH4EoHUNSmsfCYtExVX9TSK8aWsQZ4HVJg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] [media] Request API, take three
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Sorry for joining the party late.

On Wed, Jan 31, 2018 at 4:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 01/30/2018 07:31 AM, Alexandre Courbot wrote:
>> Hi Hans,
>>
>> On Mon, Jan 29, 2018 at 8:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 01/26/2018 07:02 AM, Alexandre Courbot wrote:
>>>> Howdy. Here is your bi-weekly request API redesign! ;)
>>>>
>>>> Again, this is a simple version that only implements the flow of requests,
>>>> without applying controls. The intent is to get an agreement on a base to work
>>>> on, since the previous versions went straight back to the redesign board.
>>>>
>>>> Highlights of this version:
>>>>
>>>> * As requested by Hans, request-bound buffers are now passed earlier to drivers,
>>>> as early as the request itself is submitted. Doing it earlier is not be useful
>>>> since the driver would not know the state of the request, and thus cannot do
>>>> anything with the buffer. Drivers are now responsible for applying request
>>>> parameters themselves.
>>>>
>>>> * As a consequence, there is no such thing as a "request queue" anymore. The
>>>> flow of buffers decides the order in which requests are processed. Individual
>>>> devices of the same pipeline can implement synchronization if needed, but this
>>>> is beyond this first version.
>>>>
>>>> * VB2 code is still a bit shady. Some of it will interfere with the fences
>>>> series, so I am waiting for the latter to land to do it properly.
>>>>
>>>> * Requests that are not yet submitted effectively act as fences on the buffers
>>>> they own, resulting in the buffer queue being blocked until the request is
>>>> submitted. An alternate design would be to only block the
>>>> not-submitted-request's buffer and let further buffers pass before it, but since
>>>> buffer order is becoming increasingly important I have decided to just block the
>>>> queue. This is open to discussion though.
>>>
>>> I don't think we should mess with the order.
>>
>> Agreed, let's keep it that way then.
>>

I'm not sure I'm following here. Does it mean (quoting Alex):

a) "Requests that are not yet submitted effectively act as fences on the buffers
    they own, resulting in the buffer queue being blocked until the request is
    submitted."

b) "block the not-submitted-request's buffer and let further buffers
pass before it"

or neither?

Hans, could you clarify what you think is the right behavior here?

>>>> * For the codec usecase, I have experimented a bit marking CAPTURE buffers with
>>>> the request FD that produced them (vim2m acts that way). This seems to work
>>>> well, however FDs are process-local and could be closed before the CAPTURE
>>>> buffer is dequeued, rendering that information less meaningful, if not
>>>> dangerous.
>>>
>>> I don't follow this. Once the fd is passed to the kernel its refcount should be
>>> increased so the data it represents won't be released if userspace closes the fd.
>>
>> The refcount of the request is increased. The refcount of the FD is
>> not, since it is only a userspace reference to the request.
>
> I don't think that's right. Looking at how dma-buf does this (dma_buf_get in
> dma-buf.c) it calls fget(fd) which increases the fd refcount. In fact, as far as
> I can see the struct dma_buf doesn't have a refcount, it is solely refcounted
> through the fd. That's probably the model you want to follow.

As far as I can see from the code, fget() on an fd increases a
reference count on the struct file backing the fd. I don't think there
is another level of reference counting of fds themselves - that's why
dup(fd) gives you another fd and you can't call close(fd) on the same
fd two times.

>
>>
>>>
>>> Obviously if userspace closes the fd it cannot do anything with it anymore, but
>>> it shouldn't be 'dangerous' AFAICT.
>>
>> It userspace later gets that closed FD back from a DQBUF call, and
>> decides to use it again, then we would have a problem. I agree that it
>> is userspace responsibility to be careful here, but making things
>> foolproof never hurts.
>
> I think all the issues will go away if you refcount the fd instead of the
> request. It worked well for dma-buf for years.

I'm confused here. The kernel never returns the same FD for the same
DMA-buf twice. Every time an ioctl is called, which returns a DMA-buf
FD, it creates a new FD.

Best regards,
Tomasz
