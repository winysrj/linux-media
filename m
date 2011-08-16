Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59438 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab1HPLBj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 07:01:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] media: vb2: dma-sg allocator: change scatterlist allocation method
Date: Tue, 16 Aug 2011 13:01:49 +0200
Cc: linux-media@vger.kernel.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Pawel Osciak'" <pawel@osciak.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
References: <1312964617-3192-1-git-send-email-m.szyprowski@samsung.com> <201108161041.40789.laurent.pinchart@ideasonboard.com> <004401cc5c00$24998ce0$6dcca6a0$%szyprowski@samsung.com>
In-Reply-To: <004401cc5c00$24998ce0$6dcca6a0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161301.50224.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

On Tuesday 16 August 2011 12:34:56 Marek Szyprowski wrote:
> On Tuesday, August 16, 2011 10:42 AM Laurent Pinchart wrote:
> > On Tuesday 16 August 2011 07:35:05 Marek Szyprowski wrote:
> > > On Friday, August 12, 2011 11:55 PM Laurent Pinchart wrote:
> > > > On Wednesday 10 August 2011 10:23:37 Marek Szyprowski wrote:
> > > > > From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> > > > > 
> > > > > Scatter-gather lib provides a helper functions to allocate scatter
> > > > > list, so there is no need to use vmalloc for it. sg_alloc_table()
> > > > > splits allocation into page size chunks and links them together
> > > > > into a chain.
> > > > 
> > > > Last time I check ARM platforms didn't support SG list chaining. Has
> > > > that been fixed ?
> > > 
> > > DMA-mapping code for ARM platform use for_each_sg() macro which has no
> > > problems with chained SG lists.
> > 
> > for_each_sg() is fine, but sg_alloc_table() doesn't seem to be.
> > __sg_alloc_table(), called from sg_alloc_table(), starts with
> > 
> > #ifndef ARCH_HAS_SG_CHAIN
> > 
> >         BUG_ON(nents > max_ents);
> > 
> > #endif
> > 
> > It also calls sg_chain() internally, which starts with
> > 
> > #ifndef ARCH_HAS_SG_CHAIN
> > 
> >         BUG();
> > 
> > #endif
> > 
> > ARCH_HAS_SG_CHAIN is defined on ARM if CONFIG_ARM_HAS_SG_CHAIN is set.
> > That's a boolean Kconfig option that is currently never set.
> 
> Right, I wasn't aware of that, but it still doesn't look like an issue. The
> only client of dma-sg allocator is marvell-ccic, which is used on x86
> systems. If one needs dma-sg allocator on ARM, he should follow the
> suggestion from the 74facffeca3795ffb5cf8898f5859fbb822e4c5d commit message.

Won't the dma-sg allocator be the right one for systems with an IOMMU ? If so 
we'll soon run into this issue. I'd like to port the OMAP3 ISP driver to 
videobuf2.

-- 
Regards,

Laurent Pinchart
