Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46752 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3BLXdZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 18:33:25 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so318223eei.3
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2013 15:33:23 -0800 (PST)
Message-ID: <511AD140.60905@gmail.com>
Date: Wed, 13 Feb 2013 00:33:20 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: LMML <linux-media@vger.kernel.org>, ming.lei@canonical.com,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC] V4L2 events with extensible payload
References: <51197181.6020000@gmail.com> <201302120859.34174.hverkuil@xs4all.nl>
In-Reply-To: <201302120859.34174.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2013 08:59 AM, Hans Verkuil wrote:
> On Mon February 11 2013 23:32:33 Sylwester Nawrocki wrote:
...
>> 1. Is the event payload supposed to be relatively small and the interface
>> is deliberately defined to disallow passing anything with the payload
>> greater than 64 B ? In order to keep it a rather lightweight interface
>> and anything that needs more data should use other/new ioctls ?
>
> Yes, that was the original design philisophy. In particular because events
> can be generated from interrupt context and you cannot allocate memory in
> interrupt context. Note that the original design had one event queue for
> each filehandle containing all types of events. That made it basically
> impossible to have variable sized payloads without having to allocate
> memory for each payload.

I see, but I think Linux allows allocating memory in atomic contexts and
one example of it is [1] (function read_faces()). I'm not saying it is best
possible approach but with GFP_ATOMIC flag it is possible to use kmalloc
in interrupt handlers.

$ git grep -1 GFP_ATOMIC include/linux/slab.h
include/linux/slab.h- *
include/linux/slab.h: * %GFP_ATOMIC - Allocation will not sleep.  May 
use emergency pools.
include/linux/slab.h- *   For example, use this inside interrupt handlers.

[1] http://patchwork.linuxtv.org/patch/8703

> The idea that I had in mind was that if you need larger payloads then
> the event should provide a cookie of some sort that you can use with another
> ioctl to get hold of the full payload.

I was also considering something similar, but not with a generic ioctl to
dequeue payload of an event.

> The later redesign (one queue per filehandle per event type) would have
> made that much easier since you could allocate the needed payload data
> when the event is subscribed, but by then the ioctl was already defined as
> IOR.
>
>> 2. If answer to 1. is 'no', then what would be a best way to proceed to
>> make the event's payload more flexible ? Would creating a new ioctl to
>> dequeue events be way to go ?
>>
>> I am asking mostly in context of the face detection feature in the
>> Exynos4x12 SoC camera ISP. Similarly, the v4l2 event payload size was a
>> limitation during development of a driver for the face detection IP block
>> available in OMAP4 SoCs by Ming Lei [2]:
>>
>> "From the start, I hope that the event interface can be used to retrieve
>>    object detection result.
>>
>> When I found it is difficult to fit 'struct v4l2_od_object' into 64 bytes,
>> I decide to introduce two IOCTLs for the purpose."
>>
>> I thought it would have been better to make the event interface more
>> flexible and reuse the existing infrastructure, rather than inventing new
>> ioctls for the purpose and reimplementing similar set of features.
>>
>>
>> Any suggestions, thoughts are warm welcome.
>
> I don't think changing DQEVENT is the right approach. While possible, it
> would create more confusion than it solves IMHO. What might be better (just
> brainstorming here) is to add a DQEVENT_PAYLOAD ioctl. The DQEVENT will give
> you the required size of the payload and the sequence number can be used as
> the cookie. Only the payload of the last dequeued event can be retrieved
> that way, which shouldn't be an issue as far as I can tell.

It would be nice to be able to dequeue multiple event payloads in one go,
I guess if there are multiple events of same type it could be possible to
allow user space to dequeue further payloads. This would be useful in case
there are multiple objects detected and only one interrupt is raised.

This would save some syscalls, however I'm not sure yet if it is worth the
complication of the interface.

> Hmm, strictly speaking you do not need the sequence number if you just return
> the payload of the last event, but it's probably a good sanity check.
>
> Internally this can be implemented by allocating the payload memory when the
> event is subscribed or when the event is generated. The first method is best
> if events need to be generated during interrupt context, the second method
> is best if the payload can be large and differs in size for each event. Of
> course, in that case the event can never be generated from interrupt context.
>
> You probably want to have the choice which method to use.

Agreed, such an option sounds like something good to have.

I will likely give this idea a try at the beginning of next month.
Thank you for the pointers.

--

Regards,
Sylwester
