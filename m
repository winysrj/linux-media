Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43131 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3FQQCf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 12:02:35 -0400
Date: Mon, 17 Jun 2013 17:01:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Inki Dae <daeinki@gmail.com>
Cc: linux-fbdev <linux-fbdev@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Rob Clark <robdclark@gmail.com>,
	"myungjoo.ham" <myungjoo.ham@samsung.com>,
	YoungJun Cho <yj44.cho@samsung.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
	framework
Message-ID: <20130617160148.GL2718@n2100.arm.linux.org.uk>
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com> <1371467722-665-1-git-send-email-inki.dae@samsung.com> <51BEF458.4090606@canonical.com> <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com> <20130617133109.GG2718@n2100.arm.linux.org.uk> <CAAQKjZO_t_kZkU46bUPTpoJs_oE1KkEqS2OTrTYjjJYZzBf+XA@mail.gmail.com> <20130617154237.GJ2718@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617154237.GJ2718@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 17, 2013 at 04:42:37PM +0100, Russell King - ARM Linux wrote:
> On Tue, Jun 18, 2013 at 12:03:31AM +0900, Inki Dae wrote:
> > 2013/6/17 Russell King - ARM Linux <linux@arm.linux.org.uk>
> > Exactly right. But that is not definitely my point. Could you please see
> > the below simple example?:
> > (Presume that CPU and DMA share a buffer and the buffer is mapped with user
> > space as cachable)
> > 
> >         handle1 = drm_gem_fd_to_handle(a dmabuf fd);  ----> 1
> >                  ...
> >         va1 = drm_gem_mmap(handle1);
> >         va2 = drm_gem_mmap(handle2);
> >         va3 = malloc(size);
> >                  ...
> > 
> >         while (conditions) {
> >                  memcpy(va1, some data, size);
> 
> Nooooooooooooooooooooooooooooooooooooooooooooo!
> 
> Well, the first thing to say here is that under the requirements of the
> DMA API, the above is immediately invalid, because you're writing to a
> buffer which under the terms of the DMA API is currently owned by the
> DMA agent, *not* by the CPU.  You're supposed to call dma_sync_sg_for_cpu()
> before you do that - but how is userspace supposed to know that requirement?
> Why should userspace even _have_ to know these requirements of the DMA
> API?
> 
> It's also entirely possible that drm_gem_fd_to_handle() (which indirectly
> causes dma_map_sg() on the buffers scatterlist) followed by mmap'ing it
> into userspace is a bug too, as it has the potential to touch caches or
> stuff in ways that maybe the DMA or IOMMU may not expect - but I'm not
> going to make too big a deal about that, because I don't think we have
> anything that picky.
> 
> However, the first point above is the most important one, and exposing
> the quirks of the DMA API to userland is certainly not a nice thing to be
> doing.  This needs to be fixed - we can't go and enforce an API which is
> deeply embedded within the kernel all the way out to userland.
> 
> What we need is something along the lines of:
> (a) dma_buf_map_attachment() _not_ to map the scatterlist for DMA.
> or
> (b) drm_gem_prime_import() not to call dma_buf_map_attachment() at all.
> 
> and for the scatterlist to be mapped for DMA at the point where the DMA
> operation is initiated, and unmapped at the point where the DMA operation
> is complete.
> 
> So no, the problem is not that we need more APIs and code - we need the
> existing kernel API fixed so that we don't go exposing userspace to the
> requirements of the DMA API.  Unless we do that, we're going to end
> up with a huge world of pain, where kernel architecture people need to
> audit every damned DRM userspace implementation that happens to be run
> on their platform, and that's not something arch people really can
> afford to do.
> 
> Basically, I think the dma_buf stuff needs to be rewritten with the
> requirements of the DMA API in the forefront of whosever mind is doing
> the rewriting.
> 
> Note: the existing stuff does have the nice side effect of being able
> to pass buffers which do not have a struct page * associated with them
> through the dma_buf API - I think we can still preserve that by having
> dma_buf provide a couple of new APIs to do the SG list map/sync/unmap,
> but in any case we need to fix the existing API so that:
> 
> 	dma_buf_map_attachment() becomes dma_buf_get_sg()
> 	dma_buf_unmap_attachment() becomes dma_buf_put_sg()
> 
> both getting rid of the DMA direction argument, and then we have four
> new dma_buf calls:
> 
> 	dma_buf_map_sg()
> 	dma_buf_unmap_sg()
> 	dma_buf_sync_sg_for_cpu()
> 	dma_buf_sync_sg_for_device()
> 
> which do the actual sg map/unmap via the DMA API *at the appropriate
> time for DMA*.
> 
> So, the summary of this is - at the moment, I regard DRM Prime and dmabuf
> to be utterly broken in design for architectures such as ARM where the
> requirements of the DMA API have to be followed if you're going to have
> a happy life.

An addendum to the above:

I'll also point out that the whole thing of having random buffers mapped
into userspace, and doing DMA on them is _highly_ architecture specific.
I'm told that PARISC is one architecture where this does not work (because
DMA needs to have some kind of congruence factor programmed into it which
can be different between kernel and userspace mappings of the same
physical mappings.

I ran into this when trying to come up with a cross-arch DMA-API mmap API,
and PARISC ended up killing the idea off (the remains of that attempt is
the dma_mmap_* stuff in ARM's asm/dma-mapping.h.)  However, this was for
the DMA coherent stuff, not the streaming API, which is what _this_
DMA prime/dma_buf stuff is about.

What I'm saying is think _very_ _carefully_ about userspace having
interleaved access to random DMA buffers.  Arguably, DRM should _not_
allow this.
