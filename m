Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60369 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab1BRKb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 05:31:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Michal Nazarewicz" <mina86@mina86.com>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
Date: Fri, 18 Feb 2011 11:31:30 +0100
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Hans Verkuil" <hansverk@cisco.com>, "Qing Xu" <qingx@marvell.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Neil Johnson" <realdealneil@gmail.com>,
	"Robert Jarzmik" <robert.jarzmik@free.fr>,
	"Uwe Taeubert" <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Eino-Ville Talvala" <talvala@stanford.edu>
References: <4D5D9B57.3090809@gmail.com> <op.vq2lapd13l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.vq2lapd13l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181131.30920.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michal,

On Friday 18 February 2011 00:09:51 Michal Nazarewicz wrote:
> >>> On Thu, 17 Feb 2011, Mauro Carvalho Chehab wrote:
> >>>> There's an additional problem with that: assume that streaming is
> >>>> happening, and a S_FMT changing the resolution was sent. There's
> >>>> no way to warrant that the very next frame will have the new
> >>>> resolution. So, a meta-data with the frame resolution (and format)
> >>>> would be needed.
> >> 
> >> Em 17-02-2011 17:26, Guennadi Liakhovetski escreveu:
> >>> Sorry, we are not going to allow format changes during a running
> >>> capture. You have to stop streaming, set new formats (possibly
> >>> switch to another queue) and restart streaming.
> >>> 
> >>> What am I missing?
> > 
> > On Thu, 17 Feb 2011, Mauro Carvalho Chehab wrote:
> >> If you're stopping the stream, the current API will work as-is.
> >> 
> >> If all of your concerns is about reserving a bigger buffer queue, I
> >> think that one of the reasons for the CMA allocator it for such usage.
> 
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> > Not just bigger, say, with our preview / still-shot example, we would
> > have one queue with a larger number of small buffers for drop-free
> > preview, and a small number of larger buffers for still images.
> 
> Ie. waste memory? As in you have both those queues allocated but only
> one is used at given time?

It's a trade-off between memory and speed. Preallocating still image capture 
buffers will give you better snapshot performances, at the expense of memory.

The basic problems we have here is that taking snapshots is slow with the 
current API if we need to stop capture, free buffers, change the format, 
allocate new buffers (and perform cache management operations) and restart the 
stream. To fix this we're considering a way to preallocate still image capture 
buffers, but I'm open to proposals for other ways to solve the issue :-)

> > Currently you would have to allocate a large number of large buffers,
> > which would waste memory. Or you would have to reallocate the queue,
> > losing time.
> > 
> > AFAICS, CMA doesn't manage our memory for us. It only provides an API
> > to reserve memory for various uses with various restrictions (alignment,
> > etc.) and use different allocators to obtain that memory.
> 
> I'm not sure if I understand you here.  CMA has some API for reserving
> memory at boot time but it sure does manage this reserved memory, ie.
> when system is running you can allocate chunks of memory from this
> reserved block.
> 
> Also note, that latest CMA uses only one allocator.
> 
> > So, are you suggesting, that with that in place, we would
> > first allocate the preview queue from this memory, then free it, when
> > switching to snapshooting, allocate our large-buffer queue from the
> > _same_ memory, capture images, free and allocate preview queue again?
> > Would that be fast enough?
> 
> If CMA is considered, the most important thing to note is that CMA may
> share memory with page allocator (so that other parts of the system can
> use it if CMA-compatible devices are not using it).  When CMA allocates
> memory chunk it may potentially need to migrate memory pages which may
> take so time (there is room for improvement, but still).
> 
> Sharing can be disabled in which case allocation should be quite fast
> (the last CMA patchset uses a first-fit bitmap-based gen_allocator API
> but O(log n) best-fit algorithm can easily used instead).
> 
> To sum things up, if sharing is disabled, CMA should be able to fulfil
> your requirements, however it may be undesirable as it wastes space.
> If sharing is enabled, on the other hand, the delay may potentially be
> noticeable.
> 
> > In fact, it would be kind of smart to reuse the same memory for both
> > queues, but if we could do it without re-allocations?...
> 
> What I would do is allocate a few big buffers and when needed divide them
> into smaller chunks (or even allocate one big block and later divide it in
> whatever way needed).  I'm not sure if such usage would map well to V4L2
> API.
> 
> This usage is, as a matter of fact, supported by CMA.  You can allocate
> a big block and then run cma_create() on it to create a new CMA context.
> Using this context you can allocate a lot of small blocks, then free them
> all, to finally allocate few big blocks.
> 
> Again, I'm not sure how it maps to V4L2 API.  If you can change formats
> while retaining V4L device instance's state, this should be doable.

-- 
Regards,

Laurent Pinchart
