Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:51227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1DSMAg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 08:00:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 4/7] v4l: videobuf2: add IOMMU based DMA memory allocator
Date: Tue, 19 Apr 2011 14:00:29 +0200
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Kukjin Kim'" <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com> <00ea01cbfe70$860ca900$9225fb00$%szyprowski@samsung.com> <20110419092135.GD22799@n2100.arm.linux.org.uk>
In-Reply-To: <20110419092135.GD22799@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191400.30167.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 19 April 2011, Russell King - ARM Linux wrote:
> On Tue, Apr 19, 2011 at 11:02:34AM +0200, Marek Szyprowski wrote:
> > On Monday, April 18, 2011 4:16 PM Arnd Bergmann wrote:
> > > My feeling is that this is not the right abstraction. Why can't you
> > > just implement the regular dma-mapping.h interfaces for your IOMMU
> > > so that the videobuf code can use the existing allocators?
> > 
> > I'm not really sure which existing videobuf2 allocators might transparently
> > support IOMMU interface yet
> > 
> > Do you think that all iommu operations can be hidden behind dma_map_single 
> > and dma_unmap_single?
> 
> That is one of the intentions of the DMA API.

Exactly.

All architectures that support IOMMUs today do that, see:

arch/alpha/kernel/pci_iommu.c
arch/ia64/hp/common/sba_iommu.c
arch/powerpc/kernel/dma-iommu.c
arch/sparc/kernel/iommu.c
arch/x86/kernel/amd_iommu.c

ARM would be the first one to combine an IOMMU with potentially
noncoherent DMA, but there is no fundamental reason why we shouldn't
be able to transparently support an IOMMU.

Ideally, I think we should first find an architecture-independent
way to define an IOMMU in one place instead of having to do both
the iommu.h and dma-mapping.h interfaces, but I wouldn't require
Samsung to do that in order to support their IOMMU. Doing support for
the dma-mapping.h interface should be sufficient there.

	Arnd
