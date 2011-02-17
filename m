Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46606 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1BQXJ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 18:09:56 -0500
Received: by bwz15 with SMTP id 15so201609bwz.19
        for <linux-media@vger.kernel.org>; Thu, 17 Feb 2011 15:09:54 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
References: <4D5D9B57.3090809@gmail.com>
Date: Fri, 18 Feb 2011 00:09:51 +0100
Cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Hans Verkuil" <hansverk@cisco.com>, "Qing Xu" <qingx@marvell.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Neil Johnson" <realdealneil@gmail.com>,
	"Robert Jarzmik" <robert.jarzmik@free.fr>,
	"Uwe Taeubert" <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Eino-Ville Talvala" <talvala@stanford.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vq2lapd13l0zgt@mnazarewicz-glaptop>
In-Reply-To: <4D5D9B57.3090809@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>>> On Thu, 17 Feb 2011, Mauro Carvalho Chehab wrote:
>>>> There's an additional problem with that: assume that streaming is  
>>>> happening, and a S_FMT changing the resolution was sent. There's
>>>> no way to warrant that the very next frame will have the new
>>>> resolution. So, a meta-data with the frame resolution (and format)
>>>> would be needed.

>> Em 17-02-2011 17:26, Guennadi Liakhovetski escreveu:
>>> Sorry, we are not going to allow format changes during a running  
>>> capture. You have to stop streaming, set new formats (possibly
>>> switch to another queue) and restart streaming.
>>>
>>> What am I missing?

> On Thu, 17 Feb 2011, Mauro Carvalho Chehab wrote:
>> If you're stopping the stream, the current API will work as-is.
>>
>> If all of your concerns is about reserving a bigger buffer queue, I  
>> think that one of the reasons for the CMA allocator it for such usage.

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Not just bigger, say, with our preview / still-shot example, we would  
> have one queue with a larger number of small buffers for drop-free
> preview, and a small number of larger buffers for still images.

Ie. waste memory? As in you have both those queues allocated but only
one is used at given time?

> Currently you would have to allocate a large number of large buffers,
> which would waste memory. Or you would have to reallocate the queue,
> losing time.

> AFAICS, CMA doesn't manage our memory for us. It only provides an API
> to reserve memory for various uses with various restrictions (alignment,
> etc.) and use different allocators to obtain that memory.

I'm not sure if I understand you here.  CMA has some API for reserving
memory at boot time but it sure does manage this reserved memory, ie.
when system is running you can allocate chunks of memory from this
reserved block.

Also note, that latest CMA uses only one allocator.

> So, are you suggesting, that with that in place, we would
> first allocate the preview queue from this memory, then free it, when
> switching to snapshooting, allocate our large-buffer queue from the
> _same_ memory, capture images, free and allocate preview queue again?
> Would that be fast enough?

If CMA is considered, the most important thing to note is that CMA may
share memory with page allocator (so that other parts of the system can
use it if CMA-compatible devices are not using it).  When CMA allocates
memory chunk it may potentially need to migrate memory pages which may
take so time (there is room for improvement, but still).

Sharing can be disabled in which case allocation should be quite fast
(the last CMA patchset uses a first-fit bitmap-based gen_allocator API
but O(log n) best-fit algorithm can easily used instead).

To sum things up, if sharing is disabled, CMA should be able to fulfil
your requirements, however it may be undesirable as it wastes space.
If sharing is enabled, on the other hand, the delay may potentially be
noticeable.

> In fact, it would be kind of smart to reuse the same memory for both
> queues, but if we could do it without re-allocations?...

What I would do is allocate a few big buffers and when needed divide them
into smaller chunks (or even allocate one big block and later divide it in
whatever way needed).  I'm not sure if such usage would map well to V4L2
API.

This usage is, as a matter of fact, supported by CMA.  You can allocate
a big block and then run cma_create() on it to create a new CMA context.
Using this context you can allocate a lot of small blocks, then free them
all, to finally allocate few big blocks.

Again, I'm not sure how it maps to V4L2 API.  If you can change formats  
while
retaining V4L device instance's state, this should be doable.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
