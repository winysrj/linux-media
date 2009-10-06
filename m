Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56052 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733AbZJFPR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2009 11:17:27 -0400
From: "David F. Carlson" <dave@chronolytics.com>
Message-Id: <200910061519.n96FJR3p024739@chronolytics.com>
Subject: Re: Global Video Buffers Pool - PMM and UPBuffer reference drivers
To: m.szyprowski@samsung.com (Marek Szyprowski)
Date: Tue, 6 Oct 2009 11:19:27 -0400 (EDT)
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	p.osciak@samsung.com (Pawel Osciak), kyungmin.park@samsung.com,
	m.szyprowski@samsung.com (Marek Szyprowski),
	t.fujak@samsung.com (Tomasz Fujak)
In-Reply-To: <002301ca465c$841cdca0$8c5695e0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to Marek Szyprowski:
> 
> struct pmm_mem_info info = {
> 	.magic = PMM_MAGIC,
> 	.size = BUFFER_SIZE,
> 	.type = PMM_MEM_GENERAL,
> 	.flags = PMM_NO_CACHE,
> 	.alignment = 0x1000,
> };
> 
> fd = open(/dev/pmm);
> ioctl(fd, IOCTL_PMM_ALLOC, &info);
> mmap(0, BUFFER_SIZE, 0777, MAP_SHARED, fd, 0);
> close(fd);

Thanks for the clarification.

> 
> > 2. Since these buffers will be dma sources/targets, cache will be off (no?)
> 
> You can control weather to use cache or not on the buffer region with special
> flags provided to alloc ioctl. In case o cacheable mapping, the upbuffer
> translation layer would do proper cache synchronization (flush/clean/invalidate)
> basing on the type of operation that the driver wants to perform (please refer
> to include/linux/s3c/upbuffer.h)

How does user-space "know" that a buffer will be the target of DMA?  How will
"flushing" working on implied-dma devices (such as the FB 60Hz dma)?  

Will the FB take any user or driver allocated PMM and "fix it" to be 
non-cached so that implicit DMA makes sense?  Or does the user have to "know" 
that a buffer may be the target of dma sometime later because the driver
it passed the PMM to may subsequently pass it to another driver?  

You have added lots of capability but have provided no user-space guidance.

> 
> Exactly this is addressed by the UPBuffer translation layer. If application
> unmaps the buffer from its address space the region is not freed unless the
> multimedia driver explicitly unlocks it after the transaction. That is that
> I called the buffer locking. Multimedia driver must lock the buffer before
> performing any DMA transactions on it.
>  
> 
> > You have presented a very flexible, general purpose bootmem allocator/mapper.
> > (cache/uncached, bounce/pmm, etc.)
> > 
> > The problem you were trying to solve is a means to generalize multiple
> > compile-time fixed bootmem allocations at runtime.
> > 
> > Perhaps this could be simplified to fix that problem by assuming that
> > all users (including the s3c-fb driver) would use a simple non-cached
> > pmm allocator so that all allocations would be pooled.
> 
> I don't get this, could you elaborate?

You have lot of provisions for "bounce" copies etc. that imply that s3c-mm
drivers will accept non-PMM buffers for I/O.  This creates more problems than
it solves.  Fix the fixed allocation problem, then solve world hunger.

> 
> > I would advocate "hiding" pmm allocations within the s3c-mm drivers.
> > Each driver could test user buffers for "isPMM()" trivially since the
> > bootmem is physically contig.
> > 
> > What is the advantage in exporting the pmm API to user-space?
> 
> Only user applications know what buffers will be required for the
> processing they are performing and which of them they want to reuse
> with other drivers. We decided to remove all buffers from the drivers
> and allocate them separately in user space. This way no memory is wasted
> to fixed buffers. Please note that the ability of SHARING the same buffer
> between different devices is the key feature of this solution.

I have no problem with buffer sharing and runtime pools.  Motherhood and 
apple pie.

I think what is missing are the use-cases for *each s3c-mm device*:

1.  Device DMA model (cached/non-cached  no-dma / explicit dma / implicit dma)
2.  Device buffer model: min size, max size, alignment, scatter/gather) 
3.  Device shared PMM use-case (post->fb and what else?)
4.  Device lifecycle of pmm buffers (define "transaction")
5.  Device non-PMM use-case (when would using non-PMM make sense)

You obviously had these use-cases in mind when you designed the PMM.

It would help to understand this design if you could elaborate on you model
for how these devices would be used.  (And how the user will "know" how
to satisfy each device wrt (1), (2), (3))  

The reality is that user-space doesn't/can't/shouldn't know intimate details 
of driver internals like required alignment, etc.  

My suggestion (from the previous email that PMM is a driver issue):
The user should direct each driver to allocate its buffer(s) providing a 
size and a "SHARED|PRIVATE" flag depending on when the buffer could ever 
be passed to another driver.  

struct user_pmm {
   size_t    size;      /* desired size of the allocation */
   uint32_t  flags;     /* SHARED or PRIVATE to this driver */
};

*Each driver* has the IOCTL_PMM_ALLOC so that it can "know" its requirements.
And there is no /dev/pmm.

Cheers,

David F. Carlson    Chronolytics, Inc.  Rochester, NY
mailto:dave@chronolytics.com            http://www.chronolytics.com

"The faster I go, the behinder I get." --Lewis Carroll
