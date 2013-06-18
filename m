Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43343 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3FRKrA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 06:47:00 -0400
Date: Tue, 18 Jun 2013 11:46:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Inki Dae <daeinki@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Rob Clark <robdclark@gmail.com>,
	"myungjoo.ham" <myungjoo.ham@samsung.com>,
	YoungJun Cho <yj44.cho@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
	framework
Message-ID: <20130618104613.GX2718@n2100.arm.linux.org.uk>
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com> <1371467722-665-1-git-send-email-inki.dae@samsung.com> <51BEF458.4090606@canonical.com> <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com> <20130617133109.GG2718@n2100.arm.linux.org.uk> <CAAQKjZO_t_kZkU46bUPTpoJs_oE1KkEqS2OTrTYjjJYZzBf+XA@mail.gmail.com> <20130617154237.GJ2718@n2100.arm.linux.org.uk> <CAKMK7uECS=eqNB-Ud6s=NvdYMPfxgJaGPbUx9hANfP6kb02j_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uECS=eqNB-Ud6s=NvdYMPfxgJaGPbUx9hANfP6kb02j_w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 18, 2013 at 09:00:16AM +0200, Daniel Vetter wrote:
> On Mon, Jun 17, 2013 at 04:42:37PM +0100, Russell King - ARM Linux wrote:
> > What we need is something along the lines of:
> > (a) dma_buf_map_attachment() _not_ to map the scatterlist for DMA.
> > or
> > (b) drm_gem_prime_import() not to call dma_buf_map_attachment() at all.
> 
> I strongly vote for (b) (plus adding a dma_buf_map_sync interface to allow
> syncing to other devices/cpu whithout dropping the dma mappings). At least
> that's been the idea behind things, but currently all (x86-based) drm
> drivers cut corners here massively.
> 
> Aside: The entire reason behind hiding the dma map step in the dma-buf
> attachment is to allow drivers to expose crazy iommus (e.g. the tiler unit
> on omap) to other devices. So imo (a) isn't the right choice.

That's why I also talk below about adding the dma_buf_map/sync callbacks
below, so that a dma_buf implementation can do whatever is necessary with
the sg at the point of use.

However, you are correct that this should be unnecessary, as DRM should
only be calling dma_buf_map_attachment() when it needs to know about the
memory behind the object.  The problem is that people will cache that
information - it also may be expensive to setup for the dma_buf - as it
involves counting the number of pages, memory allocation, and maybe
obtaining the set of pages from shmem.

With (a) plus the callbacks below, it means that step is only performed
once, and then the DMA API part is entirely separate - we can have our
cake and eat it in that regard.

> > Note: the existing stuff does have the nice side effect of being able
> > to pass buffers which do not have a struct page * associated with them
> > through the dma_buf API - I think we can still preserve that by having
> > dma_buf provide a couple of new APIs to do the SG list map/sync/unmap,
> > but in any case we need to fix the existing API so that:
> >
> > dma_buf_map_attachment() becomes dma_buf_get_sg()
> > dma_buf_unmap_attachment() becomes dma_buf_put_sg()
> >
> > both getting rid of the DMA direction argument, and then we have four
> > new dma_buf calls:
> >
> > dma_buf_map_sg()
> > dma_buf_unmap_sg()
> > dma_buf_sync_sg_for_cpu()
> > dma_buf_sync_sg_for_device()
> >
> > which do the actual sg map/unmap via the DMA API *at the appropriate
> > time for DMA*.
> 
> Hm, my idea was to just add a dma_buf_sync_attchment for the device side
> syncing, since the cpu access stuff is already bracketed with the
> begin/end cpu access stuff. We might need a sync_for_cpu or so for mmap,
> but imo mmap support for dma_buf is a bit insane anyway, so I don't care
> too much about it.
> 
> Since such dma mappings would be really longstanding in most cases anyway
> drivers could just map with BIDIRECTIONAL and do all the real flushing
> with the new sync stuff.

Note that the DMA API debug doesn't allow you to change the direction
argument on an existing mapping (neither should it, again this is
documented in the DMA API stuff in Documentation/).  This is where you
would need the complete set of four functions I mention above which
reflect the functionality of the DMA API.

The dma_buf implementation doesn't _have_ to implement them if they
are no-ops - for example, your dma_buf sg array contains DMA pointers,
and the memory is already coherent in some way (for example, it's a
separate chunk of memory which isn't part of system RAM.)
