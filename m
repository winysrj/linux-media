Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39340 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab3EUHor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 03:44:47 -0400
Received: by mail-wg0-f42.google.com with SMTP id n12so1070034wgh.1
        for <linux-media@vger.kernel.org>; Tue, 21 May 2013 00:44:45 -0700 (PDT)
Date: Tue, 21 May 2013 09:44:41 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Inki Dae <inki.dae@samsung.com>
Cc: 'Daniel Vetter' <daniel@ffwll.ch>,
	'Rob Clark' <robdclark@gmail.com>,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: Introduce a new helper framework for buffer synchronization
Message-ID: <20130521074441.GZ12292@phenom.ffwll.local>
References: <CAAQKjZP=iOmHRpHZCbZD3v_RKUFSn0eM_WVZZvhe7F9g3eTmPA@mail.gmail.com>
 <CAF6AEGuDih-NR-VZCmQfqbvCOxjxreZRPGfhCyL12FQ1Qd616Q@mail.gmail.com>
 <006a01ce504e$0de3b0e0$29ab12a0$%dae@samsung.com>
 <CAF6AEGv2FiKMUpb5s4zHPdj4uVxnQWdVJWL-i1mOOZRxBvMZ4Q@mail.gmail.com>
 <00cf01ce512b$bacc5540$3064ffc0$%dae@samsung.com>
 <CAF6AEGuBexKUpTwm9cjGjkxCTKgEaDhAakeP0RN=rtLS6Qy=Mg@mail.gmail.com>
 <CAAQKjZP37koEPob6yqpn-WxxTh3+O=twyvRzDiEhVJTD8BxQzw@mail.gmail.com>
 <20130520211304.GV12292@phenom.ffwll.local>
 <20130520213033.GW12292@phenom.ffwll.local>
 <032701ce55f1$3e9ba4b0$bbd2ee10$%dae@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <032701ce55f1$3e9ba4b0$bbd2ee10$%dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 21, 2013 at 04:03:06PM +0900, Inki Dae wrote:
> > - Integration of fence syncing into dma_buf. Imo we should have a
> >   per-attachment mode which decides whether map/unmap (and the new sync)
> >   should wait for fences or whether the driver takes care of syncing
> >   through the new fence framework itself (for direct hw sync).
> 
> I think it's a good idea to have per-attachment mode for buffer sync. But
> I'd like to say we make sure what is the purpose of map
> (dma_buf_map_attachment)first. This interface is used to get a sgt;
> containing pages to physical memory region, and map that region with
> device's iommu table. The important thing is that this interface is called
> just one time when user wants to share an allocated buffer with dma. But cpu
> will try to access the buffer every time as long as it wants. Therefore, we
> need cache control every time cpu and dma access the shared buffer: cache
> clean when cpu goes to dma and cache invalidate when dma goes to cpu. That
> is why I added new interfaces, DMA_BUF_GET_FENCE and DMA_BUF_PUT_FENCE, to
> dma buf framework. Of course, Those are ugly so we need a better way: I just
> wanted to show you that in such way, we can synchronize the shared buffer
> between cpu and dma. By any chance, is there any way that kernel can be
> aware of when cpu accesses the shared buffer or is there any point I didn't
> catch up?

Well dma_buf_map/unmap_attachment should also flush/invalidate any caches,
and with the current dma_buf spec those two functions are the _only_ means
you have to do so. Which strictly means that if you interleave device dma
and cpu acccess you need to unmap/map every time.

Which is obviously horribly inefficient, but a known gap in the dma_buf
interface. Hence why I proposed to add dma_buf_sync_attachment similar to
dma_sync_single_for_device:

/**
 * dma_buf_sync_sg_attachment - sync caches for dma access
 * @attach: dma-buf attachment to sync
 * @sgt: the sg table to sync (returned by dma_buf_map_attachement)
 * @direction: dma direction to sync for
 *
 * This function synchronizes caches for device dma through the given
 * dma-buf attachment when interleaving dma from different devices and the
 * cpu. Other device dma needs to be synced also by calls to this
 * function (or a pair of dma_buf_map/unmap_attachment calls), cpu access
 * needs to be synced with dma_buf_begin/end_cpu_access.
 */
void dma_buf_sync_sg_attachment(struct dma_buf_attachment *attach,
				struct sg_table *sgt,
				enum dma_data_direction direction)

Note that "sync" here only means to synchronize caches, not wait for any
outstanding fences. This is simply to be consistent with the established
lingo of the dma api. How the dma-buf fences fit into this is imo a
different topic, but my idea is that all the cache coherency barriers
(i.e. dma_buf_map/unmap_attachment, dma_buf_sync_sg_attachment and
dma_buf_begin/end_cpu_access) would automatically block for any attached
fences (i.e. block for write fences when doing read-only access, block for
all fences otherwise).

Then we could do a new dma_buf_attach_flags interface for special cases
(might also be useful for other things, similar to the recently added
flags in the dma api for wc/no-kernel-mapping/...). A new flag like
DMA_BUF_ATTACH_NO_AUTOFENCE would then mean that the driver takes care of all
fencing for this attachment and the dma-buf functions should not do the
automagic fence blocking.

> In Linux kernel, especially embedded system, we had tried to implement
> generic interfaces for buffer management; how to allocate a buffer and how
> to share a buffer. As a result, now we have CMA (Contiguous Memory
> Allocator) for buffer allocation, and we have DMA-BUF for buffer sharing
> between cpu and dma. And then how to synchronize a buffer between cpu and
> dma? I think now it's best time to discuss buffer synchronization mechanism,
> and that is very natural.

I think it's important to differentiate between the two meanings of sync:
- synchronize caches (i.e. cpu cache flushing in most cases)
- and synchronize in-flight dma with fences.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
