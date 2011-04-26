Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:52026 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab1DZOKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 10:10:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
Date: Tue, 26 Apr 2011 16:10:15 +0200
Cc: "'Joerg Roedel'" <joerg.roedel@amd.com>,
	linux-samsung-soc@vger.kernel.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Kukjin Kim'" <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com> <201104211618.31418.arnd@arndb.de> <000001cc00bf$a3afc220$eb0f4660$%szyprowski@samsung.com>
In-Reply-To: <000001cc00bf$a3afc220$eb0f4660$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104261610.15481.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 22 April 2011, Marek Szyprowski wrote:
> > * Create two codec devices in parallel and bind to both with your
> >   driver, ideally splitting up the resources between the two
> >   devices in a meaningful way.
> 
> Video codec has only standard 2 resources - ioregs and irq, so there
> is not much left for such splitting.

Ok, I see.

> > None of them are extremely nice, but it's not that hard either.
> > You should probably prototype a few of these approaches to see
> > which one is the least ugly one.
> 
> Ok. Today while iterating over the hardware requirements I noticed
> one more thing. Our codec hardware has one more, odd requirement for
> video buffers. The DMA addresses need to be aligned to 8KiB or 16KiB
> (depending on buffer type). Do you have any idea how this can be
> handled in a generic way?

I don't think you can force the mappings to be aligned to that size
in the streaming mapping, but you should be able to just align inside
of dma_map_single etc and map a larger region.

For the allocation functions (dma_alloc_coherent, dma_alloc_noncoherent),
using alloc_pages to allocate multiples of the size you need should
always give you aligned buffers because of the way that the underlying
buddy allocator works.

	Arnd
