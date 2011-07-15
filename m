Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:38527 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab1GOOaF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 10:30:05 -0400
Date: Fri, 15 Jul 2011 08:30:03 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] videobuf2: Add a non-coherent contiguous DMA mode
Message-ID: <20110715083003.79802a49@bike.lwn.net>
In-Reply-To: <000001cc42b5$40c025f0$c24071d0$%szyprowski@samsung.com>
References: <1310675711-39744-1-git-send-email-corbet@lwn.net>
	<1310675711-39744-2-git-send-email-corbet@lwn.net>
	<000001cc42b5$40c025f0$c24071d0$%szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Marek,

Thanks for having a look.

> > +static unsigned int vb2_dma_nc_num_users(void *vbuf)
> > +{
> > +	struct vb2_nc_buf *buf = vbuf;
> > +
> > +	return atomic_read(&buf->refcount);
> > +	/* Let's hope they don't fork() about now... */
> 
> This comment is really not needed here. vm_handler takes care of correct
> reference
> counting of the buffer when vma is duplicated (in case of operations like fork).

I'm just a little worried about race conditions with this refcounting; what
keeps the count from changing between when you check it (for a value of
one, not zero) and when you act on it?  I mentioned fork() because it won't
care about any local locks.  But...if the count is <=1, that means, I
guess, that nobody has the buffer mapped, so fork() is not going to take
things.  So it's probably safe; I'll take the comment out.

> I would add a pointer to driver's struct device as an argument for this memory
> allocator context (like it is done for dma_contig/coherent) and move
> dma_map_single()
> and dma_unmap_single() calls directly into the allocator. The driver needs only
> to
> call dma_sync_single_for_{cpu,device} in buf_prepare and buf_finish
> respectively.

I had thought about doing that, but decided to mirror the scatter/gather
version, which pushes the mapping into the drivers.  I do think consistency
makes some sense; if the mapping is to be done in the memops code, dma-sg
should change.

The problem is that there's no convenient callback into the allocators
where the mapping and unmapping can be done now.  So I'd have had to add a
couple of memops to do that.  You *can't* do the mapping at allocation
time...  Rather than add more memops, I decided to do it in the driver,
where some there are callbacks that happen at the right times.

Would you rather I added the memops and did things that way?

> The allocator does it's job right, but I still have some concerns.
> alloc_pages_exact()
> are really not so reliable if system is running for a longer time and memory
> gets
> fragmented. 

Trust me, I'm well aware of that - though compaction and THP have made that
a whole lot better than it was.  The real point, though, is this:
alloc_pages_exact() is *way* more reliable than dma_alloc_coherent() on
some systems.

> This allocator also will not get any advantage of the IOMMU module
> if such
> is available (the allocator will still use one big chunk of physically
> contiguous
> memory block instead of allocating smaller chunks and mapping them contiguously
> into
> device io address space).

True, but the system I'm working on doesn't have a nice IOMMU like that.
Extending the allocator for such support doesn't seem like that hard a
thing to do, but I don't have the hardware to do it with.

> I plan to focus on these issues once I finish working on dma-mapping extensions.
> My
> idea is to introduce dma_alloc_attrs() function which will unify
> dma_alloc_coherent,
> dma_alloc_writecombine, dma_alloc_non-coherent and provide some additional 
> functionality. This way the driver will be able to provide some attributes to 
> control the properties of the memory. By default a standard COHERENT
> (=non-cached)
> memory will be provided, but we can have attributes for WRITECOMBINE memory and
> NON-COHERENT (afair specific to some pci busses) and real CACHED memory (which
> requires manual synchronization).
> 
> Having a common way of allocating a dma buffer enables us to use vb2-dma-contig 
> allocator for all sub-types of the memory.

I had thought about just extending dma-contig to support both modes, but I
didn't find enough common code there to make it worthwhile.  I'm not sure
how much value there is in mashing it all into one box; the drivers have to
be aware of the differences in each case.

Improving the DMA API makes sense - it's been fairly static for a long
time.  I also wouldn't expect any such changes to be merged anytime real
soon - you're playing in a lot of sensitive arch and mm playgrounds (I
suspect you've noticed that :).  

In the mean time I have an allocator which increases frame rates by a
factor of three on my hardware, one which could easily be ready for 3.2 (no
point in trying to rush it for 3.1, certainly).  Do I understand you to say
that you'd rather not see it go in?  My preference would be to merge it; we
can always make a switch if and when something better shows up elsewhere.
I doubt it will have accumulated a huge number of users.  What say you?

Thanks,

jon
