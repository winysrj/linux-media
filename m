Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21008 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1DRNYf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 09:24:35 -0400
Date: Mon, 18 Apr 2011 15:24:29 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFC/PATCH v3 0/7] Samsung IOMMU videobuf2 allocator and s5p-fimc
	update
In-reply-to: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: 'Kyungmin Park' <kyungmin.park@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Arnd Bergmann' <arnd@arndb.de>,
	'Kukjin Kim' <kgene.kim@samsung.com>
Message-id: <003701cbfdcb$f254c020$d6fe4060$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Monday, April 18, 2011 11:27 AM Marek Szyprowski wrote:

> This is a third version of the Samsung IOMMU driver (see patch #2) and
> videobuf2 allocator for IOMMU mapped memory (see patch #4) as well as
> FIMC driver update. This update brings some minor bugfixes to Samsung
> IOMMU (SYSMMU) driver and support for pages larger than 4KiB in
> videobuf2-dma-iommu allocator.

snip

> This patch series contains a collection of patches for various platform
> subsystems. Here is a detailed list:
> 
> [PATCH 1/7] ARM: EXYNOS4: power domains: fixes and code cleanup
> - adds support for block gating in Samsung power domain driver and
>   performs some cleanup
> 
> [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
> - a complete rewrite of sysmmu driver for Samsung platform, now uses
>   linux/include/iommu.h api (key patch in this series)
> 
> [PATCH 3/7] v4l: videobuf2: dma-sg: move some generic functions to memops
> - a little cleanup and preparations for the dma-iommu allocator
> 
> [PATCH 4/7] v4l: videobuf2: add IOMMU based DMA memory allocator
> - introduces new memory allocator for videobuf2 for drivers that support
>   iommu dma memory mappings (key patch in this series)

I was in a bit hurry and I forgot to mention that the above patch relies
on some improvements to gen_alloc framework. The required 2 patches can be
found in the following patch series:
https://lkml.org/lkml/2011/3/31/213

"[PATCH 01/12] lib: bitmap: Added alignment offset for
bitmap_find_next_zero_area()"
https://lkml.org/lkml/2011/3/31/211

"[PATCH 02/12] lib: genalloc: Generic allocator improvements"
https://lkml.org/lkml/2011/3/31/207

For easier testing I've uploaded the whole IOMMU patch series and
prerequisites to public GIT repository to vb2-iommu branch (will be
available in a about 2 hours):

http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2-
iommu

git://git.infradead.org/users/kmpark/linux-2.6-samsung vb2-iommu

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

