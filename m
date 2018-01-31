Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:41255 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751001AbeAaHuf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 02:50:35 -0500
Subject: Re: [RFC PATCH 0/8] [media] Request API, take three
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20180126060216.147918-1-acourbot@chromium.org>
 <ced425a2-8b66-05c6-367d-46a0a40b1873@xs4all.nl>
 <CAPBb6MU5Ph=_rH_TOQi5mstujAPMTWqC_1d-8_TcuGx25sOJvg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <307f58dd-ce7e-b6f5-092a-f8679349be73@xs4all.nl>
Date: Wed, 31 Jan 2018 08:50:29 +0100
MIME-Version: 1.0
In-Reply-To: <CAPBb6MU5Ph=_rH_TOQi5mstujAPMTWqC_1d-8_TcuGx25sOJvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/30/2018 07:31 AM, Alexandre Courbot wrote:
> Hi Hans,
> 
> On Mon, Jan 29, 2018 at 8:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 01/26/2018 07:02 AM, Alexandre Courbot wrote:
>>> Howdy. Here is your bi-weekly request API redesign! ;)
>>>
>>> Again, this is a simple version that only implements the flow of requests,
>>> without applying controls. The intent is to get an agreement on a base to work
>>> on, since the previous versions went straight back to the redesign board.
>>>
>>> Highlights of this version:
>>>
>>> * As requested by Hans, request-bound buffers are now passed earlier to drivers,
>>> as early as the request itself is submitted. Doing it earlier is not be useful
>>> since the driver would not know the state of the request, and thus cannot do
>>> anything with the buffer. Drivers are now responsible for applying request
>>> parameters themselves.
>>>
>>> * As a consequence, there is no such thing as a "request queue" anymore. The
>>> flow of buffers decides the order in which requests are processed. Individual
>>> devices of the same pipeline can implement synchronization if needed, but this
>>> is beyond this first version.
>>>
>>> * VB2 code is still a bit shady. Some of it will interfere with the fences
>>> series, so I am waiting for the latter to land to do it properly.
>>>
>>> * Requests that are not yet submitted effectively act as fences on the buffers
>>> they own, resulting in the buffer queue being blocked until the request is
>>> submitted. An alternate design would be to only block the
>>> not-submitted-request's buffer and let further buffers pass before it, but since
>>> buffer order is becoming increasingly important I have decided to just block the
>>> queue. This is open to discussion though.
>>
>> I don't think we should mess with the order.
> 
> Agreed, let's keep it that way then.
> 
>>
>>>
>>> * Documentation! Also described usecases for codec and simple (i.e. not part of
>>> a complex pipeline) capture device.
>>
>> I'll concentrate on reviewing that.
>>
>>>
>>> Still remaining to do:
>>>
>>> * As pointed out by Hans on the previous revision, do not assume that drivers
>>> using v4l2_fh have a per-handle state. I have not yet found a good way to
>>> differenciate both usages.
>>
>> I suspect we need to add a flag or something for this.
> 
> I hope we don't need to, let's see if I can find a pattern...
> 
>>
>>> * Integrate Hans' patchset for control handling: as said above, this is futile
>>> unless we can agree on the basic design, which I hope we can do this time.
>>> Chrome OS needs this really badly now and will have to move forward no matter
>>> what, so I hope this will be considered good enough for a common base of work.
>>
>> I am not sure there is any reason to not move forward with the control handling.
>> You need this anyway IMHO, regardless of any public API considerations.
> 
> Only reasons are my lazyness and because I wanted to focus on the
> request flow first. But you're right. I have a version with your
> control framework changes integrated (they worked on the first attempt
> btw! :)), let me create a clean patchset from this and send another
> RFC.

Scary that it worked on the first attempt :-)

> 
>>
>>> A few thoughts/questions that emerged when writing this patchset:
>>>
>>> * Since requests are exposed as file descriptors, we could easily move the
>>> MEDIA_REQ_CMD_SUBMIT and MEDIA_REQ_CMD_REININT commands as ioctls on the
>>> requests themselves, instead of having to perform them on the media device that
>>> provided the request in the first place. That would add a bit more flexibility
>>> if/when passing requests around and means the media device only needs to handle
>>> MEDIA_REQ_CMD_ALLOC. Conceptually speaking, this seems to make sense to me.
>>> Any comment for/against that?
>>
>> Makes sense IMHO.
> 
> Glad to hear it, that was my preferred design. :)
> 
>>
>>> * For the codec usecase, I have experimented a bit marking CAPTURE buffers with
>>> the request FD that produced them (vim2m acts that way). This seems to work
>>> well, however FDs are process-local and could be closed before the CAPTURE
>>> buffer is dequeued, rendering that information less meaningful, if not
>>> dangerous.
>>
>> I don't follow this. Once the fd is passed to the kernel its refcount should be
>> increased so the data it represents won't be released if userspace closes the fd.
> 
> The refcount of the request is increased. The refcount of the FD is
> not, since it is only a userspace reference to the request.

I don't think that's right. Looking at how dma-buf does this (dma_buf_get in
dma-buf.c) it calls fget(fd) which increases the fd refcount. In fact, as far as
I can see the struct dma_buf doesn't have a refcount, it is solely refcounted
through the fd. That's probably the model you want to follow.

> 
>>
>> Obviously if userspace closes the fd it cannot do anything with it anymore, but
>> it shouldn't be 'dangerous' AFAICT.
> 
> It userspace later gets that closed FD back from a DQBUF call, and
> decides to use it again, then we would have a problem. I agree that it
> is userspace responsibility to be careful here, but making things
> foolproof never hurts.

I think all the issues will go away if you refcount the fd instead of the
request. It worked well for dma-buf for years.

> 
>>
>>> Wouldn't it be better/safer to use a global request ID for
>>> such information instead? That ID would be returned upon MEDIA_REQ_CMD_ALLOC so
>>> user-space knows which request ID a FD refers to.
>>
>> I think it is not a good idea to have both an fd and an ID to refer to the
>> same object. That's going to be very confusing I think.
> 
> IDs would not refer to the object, they would just be a way to
> identify it. FDs would be the actual reference.
> 
> If we drop the idea of returning request FDs to userspace after the
> initial allocation (which is the only time we can be sure that a
> returned FD is valid), then this is not a problem anymore, but I think
> it may be useful to mark CAPTURE buffers with the request that
> generated them.
> 
>>
>>> * Using the media node to provide requests makes absolute sense for complex
>>> camera devices, but is tedious for codec devices which work on one node and
>>> require to protect request/media related code with #ifdef
>>> CONFIG_MEDIA_CONTROLLER.
>>
>> Why? They would now depend on MEDIA_CONTROLLER (i.e. they won't appear in the
>> menuconfig unless MEDIA_CONTROLLER is set). No need for an #ifdef.
> 
> Ah, if we make them depend on MEDIA_CONTROLLER, then indeed. But do we
> want to do this for e.g. vim2m and vivid?

If they support requests, then yes.

> 
>>
>>  For these devices, the sole role of the media node is
>>> to produce the request, and that's it (since request submission could be moved
>>> to the request FD as explained above). That's a modest use that hardly justifies
>>> bringing in the whole media framework IMHO. With a bit of extra abstraction, it
>>> should be possible to decouple the base requests from the media controller
>>> altogether, and propose two kinds of requests implementations: one simpler
>>> implementation that works directly with a single V4L2 node (useful for codecs),
>>> and another one that works on a media node and can control all its entities
>>> (good for camera). This would allow codecs to use the request API without
>>> forcing the media controller, and would considerably simplify the use-case. Any
>>> objection to that? IIRC the earlier design documents mentioned this possibility.
>>
>> I think this is an interesting idea, but I would postpone making a decision on
>> this until later. We need this MC support regardless, so let's start off with that.
>>
>> Once that's working we can discuss if we should or should not create a shortcut
>> for codecs. Trying to decide this now would only confuse the process.
> 
> Sounds good, as long as we make a decision before merging.

Of course.

Regards,

	Hans
