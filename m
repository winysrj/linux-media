Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32049 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab1DULca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 07:32:30 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Thu, 21 Apr 2011 13:32:21 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU)
	driver
In-reply-to: <201104201807.27314.arnd@arndb.de>
To: 'Arnd Bergmann' <arnd@arndb.de>
Cc: 'Joerg Roedel' <joerg.roedel@amd.com>,
	linux-samsung-soc@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <003001cc0017$c7fb3a40$57f1aec0$%szyprowski@samsung.com>
Content-language: pl
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
 <201104191629.49676.arnd@arndb.de>
 <007301cbff6a$f17a4710$d46ed530$%szyprowski@samsung.com>
 <201104201807.27314.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, April 20, 2011 6:07 PM Arnd Bergmann wrote:

> On Wednesday 20 April 2011, Marek Szyprowski wrote:
> > On Tuesday, April 19, 2011 4:30 PM Arnd Bergmann wrote:
> 
> > > Sounds good. I think we should put it into a new drivers/iommu, along
> > > with your specific iommu implementation, and then we can convert the
> > > existing ones over to use that.
> >
> > I see, this sounds quite reasonable. I think I finally got how this
> should
> > be implemented.
> >
> > The only question is how a device can allocate a buffer that will be most
> > convenient for IOMMU mapping (i.e. will require least entries to map)?
> >
> > IOMMU can create a contiguous mapping for ANY set of pages, but it
> performs
> > much better if the pages are grouped into 64KiB or 1MiB areas.
> >
> > Can device allocate a buffer without mapping it into kernel space?
> 
> Not today as far as I know. You can register coherent memory per device
> using dma_declare_coherent_memory(), which will be used to back
> dma_alloc_coherent(), but I believe it is always mapped right now.

This is not exactly what I meant.

As we have IOMMU, the device driver can access any system memory. However
the performance will be better if the buffer is composed of larger contiguous
parts (like 64KiB or 1MiB). I would like to avoid putting logic that manages
buffer allocation into the device drivers. It would be best if such buffers
could be allocated by a single call to dma-mapping API.

Right now there is dma_alloc_coherent() function, which is used by the
drivers to allocate a contiguous block of memory and map it to DMA addresses.
With IOMMU implementation it is quite easy to provide a replacement for it
that will allocate some set of pages and map into device virtual address
space as a contiguous buffer. 

This will have the advantage that the same multimedia device driver
will work on both systems - Samsung S5PC110 (without IOMMU) and Exynos4
(with IOMMU).

However dma_alloc_coherent() besides allocating memory also implies some
particular type of memory mapping for it. IMHO it might be a good idea to
separate these 2 things (allocation and mapping) somewhere in the future.

On systems with IOMMU the dma_map_sg() can be also used to create a mapping
in device virtual address space, but the driver will still need to allocate
the memory by itself.

(snipped)

> > > > Getting back to our video codec - it has 2 IOMMU controllers. The
> codec
> > > > hardware is able to address only 256MiB of space. Do you have an idea
> how
> > > > this can be handled with dma-mapping API? The only idea that comes to
> my
> > > > mind is to provide a second, fake 'struct device' and use it for
> > > allocations
> > > > for the second IOMMU controller.
> > >
> > > Good question.
> > >
> > > How do you even decide which controller to use from the driver?
> > > I would need to understand better what you are trying to do to
> > > give a good recommendation.
> >
> > Both controllers are used by the hardware depending on the buffer type.
> > For example, buffers with chroma video data are accessed by first (called
> > 'left') memory channel, the others (with luma video data) - by the second
> > channel (called 'right'). Each memory channel is limited to 256MiB
> address
> > space and best performance is achieved when buffers are allocated in
> > separate physical memory banks (the boards usually have 2 or more memory
> banks,
> > memory is not interleaved).
> 
> Ok, I see. Having one device per channel as you suggested could probably
> work around this, and it's at least consistent with how you'd represent
> IOMMUs in the device tree. It is not ideal because it makes the video
> driver more complex when it now has to deal with multiple struct device
> that it binds to, but I can't think of any nicer way either.

Well, this will definitely complicate the codec driver. I wonder if allowing
the driver to kmalloc(sizeof(struct device))) and copy the relevant data
from the 'proper' struct device will be better idea. It is still hack but 
definitely less intrusive for the driver.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

