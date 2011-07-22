Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:36844 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab1GVTzt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 15:55:49 -0400
Date: Fri, 22 Jul 2011 13:55:47 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Pawel Osciak' <pawel@osciak.com>
Subject: Re: [PATCH 1/2] videobuf2: Add a non-coherent contiguous DMA mode
Message-ID: <20110722135547.5a0b38db@bike.lwn.net>
In-Reply-To: <00cb01cc4518$55c0c490$01424db0$%szyprowski@samsung.com>
References: <1310675711-39744-1-git-send-email-corbet@lwn.net>
	<1310675711-39744-2-git-send-email-corbet@lwn.net>
	<000001cc42b5$40c025f0$c24071d0$%szyprowski@samsung.com>
	<20110715083003.79802a49@bike.lwn.net>
	<00cb01cc4518$55c0c490$01424db0$%szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > The problem is that there's no convenient callback into the allocators
> > where the mapping and unmapping can be done now.  So I'd have had to add a
> > couple of memops to do that.
> 
> I think that some additional callbacks for allocators for synchronization
> buffer state will be required sooner or later anyway, so imho it is better
> to add them now to avoid massive fixing the drivers in the future.

OK, I can certainly do a version of the patch along those lines.  I'd
envision some sort of give_buffer_to_device() and give_buffer_to_cpu()
calls (with better names).  It'll take me a little while to get it done,
though - travel and such are upon me.

> >  You *can't* do the mapping at allocation time...
> 
> Could you elaborate why you can't create the mapping at allocation time? 
> DMA-mapping api requires the following call sequence:
> dma_map_single()
> ...
> dma_sync_single_for_cpu()
> dma_sync_single_for_device()
> ...
> dma_unmap_single()
> 
> I see no problem to call dma_map_single() on buffer creation and 
> dma_unmap_single() on release. dma_sync_single_for_{device,cpu} can
> be used on buffer_{prepare,finish}.

Yes, it could be done that way.  I guess I've always, rightly or wrongly,
seen streaming mappings as transient things that aren't meant to be kept
around for long periods of time.  Especially if they might, somehow, be
taking up limited resources like IOMMU slots.  But I honestly have no idea
whether it's better to keep a set of mappings around and use the sync
functions, or whether it's better to remake them each time.

> The only problem is the name of the allocator. We probably shouldn't
> reuse names that have different meaning in other related
> frameworks. non-coherent memory in dma-mapping api is reserved for some
> special type of memory which has single synchronization call, so the
> "non-coherent" might be confusing.

I'm certainly not tied to the name - got a better idea?  The module uses
streaming mappings, but, somehow, reusing "streaming" in this context
doesn't seem likely to make things clearer...:)

Thanks,

jon
