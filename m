Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27266 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab1HPLsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 07:48:39 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQ000LW7RH1B7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Aug 2011 12:48:37 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQ00075RRH04A@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Aug 2011 12:48:36 +0100 (BST)
Date: Tue, 16 Aug 2011 13:48:03 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: dma-sg allocator: change scatterlist
 allocation method
In-reply-to: <201108161301.50224.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <004801cc5c0a$5b61b4a0$12251de0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1312964617-3192-1-git-send-email-m.szyprowski@samsung.com>
 <201108161041.40789.laurent.pinchart@ideasonboard.com>
 <004401cc5c00$24998ce0$6dcca6a0$%szyprowski@samsung.com>
 <201108161301.50224.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, August 16, 2011 1:02 PM Laurent Pinchart wrote:

> On Tuesday 16 August 2011 12:34:56 Marek Szyprowski wrote:
> > On Tuesday, August 16, 2011 10:42 AM Laurent Pinchart wrote:
> > > On Tuesday 16 August 2011 07:35:05 Marek Szyprowski wrote:
> > > > On Friday, August 12, 2011 11:55 PM Laurent Pinchart wrote:
> > > > > On Wednesday 10 August 2011 10:23:37 Marek Szyprowski wrote:
> > > > > > From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> > > > > >
> > > > > > Scatter-gather lib provides a helper functions to allocate scatter
> > > > > > list, so there is no need to use vmalloc for it. sg_alloc_table()
> > > > > > splits allocation into page size chunks and links them together
> > > > > > into a chain.
> > > > >
> > > > > Last time I check ARM platforms didn't support SG list chaining. Has
> > > > > that been fixed ?
> > > >
> > > > DMA-mapping code for ARM platform use for_each_sg() macro which has no
> > > > problems with chained SG lists.
> > >
> > > for_each_sg() is fine, but sg_alloc_table() doesn't seem to be.
> > > __sg_alloc_table(), called from sg_alloc_table(), starts with
> > >
> > > #ifndef ARCH_HAS_SG_CHAIN
> > >
> > >         BUG_ON(nents > max_ents);
> > >
> > > #endif
> > >
> > > It also calls sg_chain() internally, which starts with
> > >
> > > #ifndef ARCH_HAS_SG_CHAIN
> > >
> > >         BUG();
> > >
> > > #endif
> > >
> > > ARCH_HAS_SG_CHAIN is defined on ARM if CONFIG_ARM_HAS_SG_CHAIN is set.
> > > That's a boolean Kconfig option that is currently never set.
> >
> > Right, I wasn't aware of that, but it still doesn't look like an issue. The
> > only client of dma-sg allocator is marvell-ccic, which is used on x86
> > systems. If one needs dma-sg allocator on ARM, he should follow the
> > suggestion from the 74facffeca3795ffb5cf8898f5859fbb822e4c5d commit message.
> 
> Won't the dma-sg allocator be the right one for systems with an IOMMU ? If so
> we'll soon run into this issue. I'd like to port the OMAP3 ISP driver to
> videobuf2.

Nope. The correct place for IOMMU is dma-contig allocator. In theory DMA-mapping
functions SHOULD hide the presence of the IOMMU from the driver. The driver
would
only need to get the 'dma_address' of the buffer and write it to the respective
multimedia device register.

The proof-of-concept of such solution for kernel allocated buffer has been 
presented in my first ARM dma-mapping patches: 
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/dma-
mapping 

User pointer buffers will need a bit more work to get them working correctly for
both iommu and non-iommu cases. For IOMMU dma_map_sg() will just fill the
scatter
list with just one dma_addr entry and it will contain the address of the buffer
in driver's io address space. Non-IOMMU needs some more tweaking (also in the
DMA-mapping)

IMHO the best way to porting OMAP3 ISP to videobuf2 is to first create a custom
memory allocator that working with OMAP3 IOMMU directly and then
adapt/merge/port
it to DMA-mapping based approach.

You can also refer to our first approaches with videobuf2-dma-iommu allocator:
http://lwn.net/Articles/439175/ 
Especially the discussion in that thread is really important for understanding
how the IOMMU should be integrated in the Linux kernel.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

