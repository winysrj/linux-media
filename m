Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9266 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1GRHBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 03:01:00 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LOI00MM3OTNKP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jul 2011 08:00:59 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LOI000QWOTLVL@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jul 2011 08:00:58 +0100 (BST)
Date: Mon, 18 Jul 2011 09:00:10 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/2] videobuf2: Add a non-coherent contiguous DMA mode
In-reply-to: <20110715083003.79802a49@bike.lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>
Cc: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <00cb01cc4518$55c0c490$01424db0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1310675711-39744-1-git-send-email-corbet@lwn.net>
 <1310675711-39744-2-git-send-email-corbet@lwn.net>
 <000001cc42b5$40c025f0$c24071d0$%szyprowski@samsung.com>
 <20110715083003.79802a49@bike.lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, July 15, 2011 4:30 PM Jonathan Corbet wrote:

> Hi, Marek,
> 
> Thanks for having a look.
> 
> > > +static unsigned int vb2_dma_nc_num_users(void *vbuf)
> > > +{
> > > +	struct vb2_nc_buf *buf = vbuf;
> > > +
> > > +	return atomic_read(&buf->refcount);
> > > +	/* Let's hope they don't fork() about now... */
> >
> > This comment is really not needed here. vm_handler takes care of correct
> > reference
> > counting of the buffer when vma is duplicated (in case of operations like
> fork).
> 
> I'm just a little worried about race conditions with this refcounting; what
> keeps the count from changing between when you check it (for a value of
> one, not zero) and when you act on it?  I mentioned fork() because it won't
> care about any local locks.  But...if the count is <=1, that means, I
> guess, that nobody has the buffer mapped, so fork() is not going to take
> things.  So it's probably safe; I'll take the comment out.
> 
> > I would add a pointer to driver's struct device as an argument for this
> memory
> > allocator context (like it is done for dma_contig/coherent) and move
> > dma_map_single()
> > and dma_unmap_single() calls directly into the allocator. The driver
> needs only
> > to
> > call dma_sync_single_for_{cpu,device} in buf_prepare and buf_finish
> > respectively.
> 
> I had thought about doing that, but decided to mirror the scatter/gather
> version, which pushes the mapping into the drivers.  I do think consistency
> makes some sense; if the mapping is to be done in the memops code, dma-sg
> should change.
> 
> The problem is that there's no convenient callback into the allocators
> where the mapping and unmapping can be done now.  So I'd have had to add a
> couple of memops to do that.

I think that some additional callbacks for allocators for synchronization
buffer state will be required sooner or later anyway, so imho it is better
to add them now to avoid massive fixing the drivers in the future.

>  You *can't* do the mapping at allocation time...

Could you elaborate why you can't create the mapping at allocation time? 
DMA-mapping api requires the following call sequence:
dma_map_single()
...
dma_sync_single_for_cpu()
dma_sync_single_for_device()
...
dma_unmap_single()

I see no problem to call dma_map_single() on buffer creation and 
dma_unmap_single() on release. dma_sync_single_for_{device,cpu} can
be used on buffer_{prepare,finish}.

>  Rather than add more memops, I decided to do it in the driver,
> where some there are callbacks that happen at the right times.
> 
> Would you rather I added the memops and did things that way?

Scatter-gather allocator was our first meeting with dma-mapping api, now I
noticed we will need to cleanup it a bit.

> > The allocator does it's job right, but I still have some concerns.
> > alloc_pages_exact()
> > are really not so reliable if system is running for a longer time and
> memory
> > gets
> > fragmented.
> 
> Trust me, I'm well aware of that - though compaction and THP have made that
> a whole lot better than it was.  The real point, though, is this:
> alloc_pages_exact() is *way* more reliable than dma_alloc_coherent() on
> some systems.

OK.

> > This allocator also will not get any advantage of the IOMMU module
> > if such
> > is available (the allocator will still use one big chunk of physically
> > contiguous
> > memory block instead of allocating smaller chunks and mapping them
> contiguously
> > into
> > device io address space).
> 
> True, but the system I'm working on doesn't have a nice IOMMU like that.
> Extending the allocator for such support doesn't seem like that hard a
> thing to do, but I don't have the hardware to do it with.
> 
> > I plan to focus on these issues once I finish working on dma-mapping
> extensions.
> > My
> > idea is to introduce dma_alloc_attrs() function which will unify
> > dma_alloc_coherent,
> > dma_alloc_writecombine, dma_alloc_non-coherent and provide some
> additional
> > functionality. This way the driver will be able to provide some
> attributes to
> > control the properties of the memory. By default a standard COHERENT
> > (=non-cached)
> > memory will be provided, but we can have attributes for WRITECOMBINE
> memory and
> > NON-COHERENT (afair specific to some pci busses) and real CACHED memory
> (which
> > requires manual synchronization).
> >
> > Having a common way of allocating a dma buffer enables us to use vb2-dma-
> contig
> > allocator for all sub-types of the memory.
> 
> I had thought about just extending dma-contig to support both modes, but I
> didn't find enough common code there to make it worthwhile.  I'm not sure
> how much value there is in mashing it all into one box; the drivers have to
> be aware of the differences in each case.
> 
> Improving the DMA API makes sense - it's been fairly static for a long
> time.  I also wouldn't expect any such changes to be merged anytime real
> soon - you're playing in a lot of sensitive arch and mm playgrounds (I
> suspect you've noticed that :).

Yes, I'm aware of that.

> In the mean time I have an allocator which increases frame rates by a
> factor of three on my hardware, one which could easily be ready for 3.2 (no
> point in trying to rush it for 3.1, certainly).  Do I understand you to say
> that you'd rather not see it go in?  My preference would be to merge it; we
> can always make a switch if and when something better shows up elsewhere.
> I doubt it will have accumulated a huge number of users.  What say you?

I just wanted to point out that it will be a temporary solution until
dma-mapping
and vb2-dma-contig allocator are extended with new features, but I see no
problems
to merge it now. It gives significant performance gain that definitely is worth
it.
The only problem is the name of the allocator. We probably shouldn't reuse names
that have different meaning in other related frameworks. non-coherent memory in
dma-mapping api is reserved for some special type of memory which has single
synchronization call, so the "non-coherent" might be confusing.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



