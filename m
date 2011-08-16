Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42826 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1HPKfc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 06:35:32 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQ000D9PO36Q900@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Aug 2011 11:35:30 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQ000EARO35OH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Aug 2011 11:35:30 +0100 (BST)
Date: Tue, 16 Aug 2011 12:34:56 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: dma-sg allocator: change scatterlist
 allocation method
In-reply-to: <201108161041.40789.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <004401cc5c00$24998ce0$6dcca6a0$%szyprowski@samsung.com>
Content-language: pl
References: <1312964617-3192-1-git-send-email-m.szyprowski@samsung.com>
 <201108122354.51720.laurent.pinchart@ideasonboard.com>
 <03bd01cc5bd6$40a86b10$c1f94130$%szyprowski@samsung.com>
 <201108161041.40789.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, August 16, 2011 10:42 AM Laurent Pinchart wrote:

> On Tuesday 16 August 2011 07:35:05 Marek Szyprowski wrote:
> > On Friday, August 12, 2011 11:55 PM Laurent Pinchart wrote:
> > > On Wednesday 10 August 2011 10:23:37 Marek Szyprowski wrote:
> > > > From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> > > >
> > > > Scatter-gather lib provides a helper functions to allocate scatter
> > > > list, so there is no need to use vmalloc for it. sg_alloc_table()
> > > > splits allocation into page size chunks and links them together into a
> > > > chain.
> > >
> > > Last time I check ARM platforms didn't support SG list chaining. Has that
> > > been fixed ?
> >
> > DMA-mapping code for ARM platform use for_each_sg() macro which has no
> > problems with chained SG lists.
> 
> for_each_sg() is fine, but sg_alloc_table() doesn't seem to be.
> __sg_alloc_table(), called from sg_alloc_table(), starts with
> 
> #ifndef ARCH_HAS_SG_CHAIN
>         BUG_ON(nents > max_ents);
> #endif
> 
> It also calls sg_chain() internally, which starts with
> 
> #ifndef ARCH_HAS_SG_CHAIN
>         BUG();
> #endif
> 
> ARCH_HAS_SG_CHAIN is defined on ARM if CONFIG_ARM_HAS_SG_CHAIN is set. That's
> a boolean Kconfig option that is currently never set.

Right, I wasn't aware of that, but it still doesn't look like an issue. The only

client of dma-sg allocator is marvell-ccic, which is used on x86 systems. If one
needs dma-sg allocator on ARM, he should follow the suggestion from the 
74facffeca3795ffb5cf8898f5859fbb822e4c5d commit message.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

