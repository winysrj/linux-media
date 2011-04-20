Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54515 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab1DTOzN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2011 10:55:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Wed, 20 Apr 2011 16:55:09 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU)
	driver
In-reply-to: <201104191629.49676.arnd@arndb.de>
To: 'Arnd Bergmann' <arnd@arndb.de>
Cc: 'Joerg Roedel' <joerg.roedel@amd.com>,
	linux-samsung-soc@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <007301cbff6a$f17a4710$d46ed530$%szyprowski@samsung.com>
Content-language: pl
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
 <201104191449.50824.arnd@arndb.de>
 <000001cbfe9a$8e64cae0$ab2e60a0$%szyprowski@samsung.com>
 <201104191629.49676.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Tuesday, April 19, 2011 4:30 PM Arnd Bergmann wrote:

> > > That is a limitation of the current implementation. We might want to
> > > change that anyway, e.g. to handle the mali IOMMU along with yours.
> > > I believe the reason for allowing only one IOMMU type so far has been
> > > that nobody required more than one. As I mentioned, the IOMMU API is
> > > rather new and has not been ported to much variety of hardware, unlike
> > > the dma-mapping API, which does support multiple different IOMMUs
> > > in a single system.
> >
> > Ok. I understand. IOMMU API is quite nice abstraction of the IOMMU chip.
> > dma-mapping API is something much more complex that creates the actual
> > mapping for various sets of the devices. IMHO the right direction will
> > be to create dma-mapping implementation that will be just a client of
> > the IOMMU API. What's your opinion?
> 
> Sounds good. I think we should put it into a new drivers/iommu, along
> with your specific iommu implementation, and then we can convert the
> existing ones over to use that.

I see, this sounds quite reasonable. I think I finally got how this should
be implemented. 

The only question is how a device can allocate a buffer that will be most
convenient for IOMMU mapping (i.e. will require least entries to map)?

IOMMU can create a contiguous mapping for ANY set of pages, but it performs
much better if the pages are grouped into 64KiB or 1MiB areas.

Can device allocate a buffer without mapping it into kernel space?

The problem that still left to be resolved is the fact the
dma_coherent_alloc() should also be able to use IOMMU. This would however
trigger the problem of double mappings with different cache attributes: 
dma api might require to create coherent (==non-cached mappings), while 
all low-memory is still mapped with (super)sections as cached, what is 
against ARM CPU specification and might cause unpredicted behavior
especially on CPUs that do speculative prefetch. Right now this problem
has been ignored in dma-mappings implementation, but there have been some
patches posted to resolve this by reserving some area exclusively for dma
coherent mappings: 
http://thread.gmane.org/gmane.linux.ports.arm.kernel/100822/focus=100913

Right now I would like to postpone resolving this issue because the Samsung
iommu task already became really big.

> Note that this also requires using dma-mapping-common.h, which we currently
> don't on ARM.

Yes, I noticed this, shouldn't be much problem, imho.

> > > The domain really reflects the user, not the device here, which makes
> more
> > > sense if you think of virtual machines than of multimedia devices.
> > >
> > > I would suggest that you just use a single iommu_domain globally for
> > > all in-kernel users.
> >
> > There are cases where having a separate mapping for each device makes
> sense.
> > It definitely increases the security and helps to find some bugs in
> > the drivers.
> >
> > Getting back to our video codec - it has 2 IOMMU controllers. The codec
> > hardware is able to address only 256MiB of space. Do you have an idea how
> > this can be handled with dma-mapping API? The only idea that comes to my
> > mind is to provide a second, fake 'struct device' and use it for
> allocations
> > for the second IOMMU controller.
> 
> Good question.
> 
> How do you even decide which controller to use from the driver?
> I would need to understand better what you are trying to do to
> give a good recommendation.

Both controllers are used by the hardware depending on the buffer type.
For example, buffers with chroma video data are accessed by first (called
'left') memory channel, the others (with luma video data) - by the second
channel (called 'right'). Each memory channel is limited to 256MiB address
space and best performance is achieved when buffers are allocated in 
separate physical memory banks (the boards usually have 2 or more memory banks,
memory is not interleaved).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
