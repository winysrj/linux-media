Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:37612 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3FRF1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 01:27:43 -0400
From: Inki Dae <inki.dae@samsung.com>
To: 'Russell King - ARM Linux' <linux@arm.linux.org.uk>
Cc: 'Maarten Lankhorst' <maarten.lankhorst@canonical.com>,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	'Rob Clark' <robdclark@gmail.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	'Daniel Vetter' <daniel@ffwll.ch>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com>
 <1371467722-665-1-git-send-email-inki.dae@samsung.com>
 <51BEF458.4090606@canonical.com>
 <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com>
 <20130617133109.GG2718@n2100.arm.linux.org.uk>
 <CAAQKjZO_t_kZkU46bUPTpoJs_oE1KkEqS2OTrTYjjJYZzBf+XA@mail.gmail.com>
 <20130617154237.GJ2718@n2100.arm.linux.org.uk>
 <CAAQKjZOokFKN85pygVnm7ShSa+O0ZzwxvQ0rFssgNLp+RO5pGg@mail.gmail.com>
 <20130617182127.GM2718@n2100.arm.linux.org.uk>
In-reply-to: <20130617182127.GM2718@n2100.arm.linux.org.uk>
Subject: RE: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
	framework
Date: Tue, 18 Jun 2013 14:27:40 +0900
Message-id: <007301ce6be4$8d5c6040$a81520c0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Tuesday, June 18, 2013 3:21 AM
> To: Inki Dae
> Cc: Maarten Lankhorst; linux-fbdev; Kyungmin Park; DRI mailing list; Rob
> Clark; myungjoo.ham; YoungJun Cho; Daniel Vetter; linux-arm-
> kernel@lists.infradead.org; linux-media@vger.kernel.org
> Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
> framework
> 
> On Tue, Jun 18, 2013 at 02:19:04AM +0900, Inki Dae wrote:
> > It seems like that all pages of the scatterlist should be mapped with
> > DMA every time DMA operation  is started (or drm_xxx_set_src_dma_buffer
> > function call), and the pages should be unmapped from DMA again every
> > time DMA operation is completed: internally, including each cache
> > operation.
> 
> Correct.
> 
> > Isn't that big overhead?
> 
> Yes, if you _have_ to do a cache operation to ensure that the DMA agent
> can see the data the CPU has written.
> 
> > And If there is no problem, we should accept such overhead?
> 
> If there is no problem then why are we discussing this and why do we need
> this API extension? :)

Ok, another issue regardless of dmabuf-sync. Reasonable to me even though
big overhead. Besides, it seems like that most DRM drivers have same issue.
Therefore, we may need to solve this issue like below:
	- do not map a dmabuf with DMA. And just create/update buffer object
of importer.
	- map the buffer with DMA every time DMA start or iommu page fault
occurs.
	- unmap the buffer from DMA every time DMA operation is completed

With the above approach, cache operation portion of my approach,
dmabuf-sync, can be removed. However, I'm not sure that we really have to
use the above approach with a big overhead. Of course, if we don't use the
above approach then user processes would need to do each cache operation
before DMA operation is started and also after DMA operation is completed in
some cases; user space mapped with physical memory as cachable, and CPU and
DMA share the same buffer.

So I'd like to ask for other DRM maintainers. How do you think about it? it
seems like that Intel DRM (maintained by Daniel), OMAP DRM (maintained by
Rob) and GEM CMA helper also have same issue Russell pointed out. I think
not only the above approach but also the performance is very important.

Thanks,
Inki Dae

> 
> > Actually, drm_gem_fd_to_handle() includes to map a
> > given dmabuf with iommu table (just logical data) of the DMA. And then,
> the
> > device address (or iova) already mapped will be set to buffer register
> of
> > the DMA with drm_xxx_set_src/dst_dma_buffer(handle1, ...) call.
> 
> Consider this with a PIPT cache:
> 
> 	dma_map_sg()	- at this point, the kernel addresses of these
> 			buffers are cleaned and invalidated for the DMA
> 
> 	userspace writes to the buffer, the data sits in the CPU cache
> 	Because the cache is PIPT, this data becomes visible to the
> 	kernel as well.
> 
> 	DMA is started, and it writes to the buffer
> 
> Now, at this point, which is the correct data?  The data physically in the
> RAM which the DMA has written, or the data in the CPU cache.  It may
> the answer is - they both are, and the loss of either can be a potential
> data corruption issue - there is no way to tell which data should be
> kept but the system is in an inconsistent state and _one_ of them will
> have to be discarded.
> 
> 	dma_unmap_sg()	- at this point, the kernel addresses of the
> 			buffers are _invalidated_ and any data in those
> 			cache lines is discarded
> 
> Which also means that the data in userspace will also be discarded with
> PIPT caches.
> 
> This is precisely why we have buffer rules associated with the DMA API,
> which are these:
> 
> 	dma_map_sg()
> 	- the buffer transfers ownership from the CPU to the DMA agent.
> 	- the CPU may not alter the buffer in any way.
> 	while (cpu_wants_access) {
> 		dma_sync_sg_for_cpu()
> 		- the buffer transfers ownership from the DMA to the CPU.
> 		- the DMA may not alter the buffer in any way.
> 		dma_sync_sg_for_device()
> 		- the buffer transfers ownership from the CPU to the DMA
> 		- the CPU may not alter the buffer in any way.
> 	}
> 	dma_unmap_sg()
> 	- the buffer transfers ownership from the DMA to the CPU.
> 	- the DMA may not alter the buffer in any way.
> 
> Any violation of that is likely to lead to data corruption.  Now, some
> may say that the DMA API is only about the kernel mapping.  Yes it is,
> because it takes no regard what so ever about what happens with the
> userspace mappings.  This is absolutely true when you have VIVT or
> aliasing VIPT caches.
> 
> Now consider that with a PIPT cache, or a non-aliasing VIPT cache (which
> is exactly the same behaviourally from this aspect) any modification of
> a userspace mapping is precisely the same as modifying the kernel space
> mapping - and what you find is that the above rules end up _inherently_
> applying to the userspace mappings as well.
> 
> In other words, userspace applications which have mapped the buffers
> must _also_ respect these rules.
> 
> And there's no way in hell that I'd ever trust userspace to get this
> anywhere near right, and I *really* do not like these kinds of internal
> kernel API rules being exposed to userspace.
> 
> And so the idea that userspace should be allowed to setup DMA transfers
> via "set source buffer", "set destination buffer" calls into an API is
> just plain rediculous.  No, userspace should be allowed to ask for
> "please copy from buffer X to buffer Y using this transform".
> 
> Also remember that drm_xxx_set_src/dst_dma_buffer() would have to
> deal with the DRM object IDs for the buffer, and not the actual buffer
> information themselves - that is kept within the kernel, so the kernel
> knows what's happening.

