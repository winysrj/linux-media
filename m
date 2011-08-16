Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35533 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1HPFfN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 01:35:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQ0004VHA6LE250@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Aug 2011 06:35:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQ000DDPA6K41@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Aug 2011 06:35:08 +0100 (BST)
Date: Tue, 16 Aug 2011 07:35:05 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: dma-sg allocator: change scatterlist
 allocation method
In-reply-to: <201108122354.51720.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <03bd01cc5bd6$40a86b10$c1f94130$%szyprowski@samsung.com>
Content-language: pl
References: <1312964617-3192-1-git-send-email-m.szyprowski@samsung.com>
 <201108122354.51720.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, August 12, 2011 11:55 PM Laurent Pinchart wrote:

> On Wednesday 10 August 2011 10:23:37 Marek Szyprowski wrote:
> > From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> >
> > Scatter-gather lib provides a helper functions to allocate scatter list,
> > so there is no need to use vmalloc for it. sg_alloc_table() splits
> > allocation into page size chunks and links them together into a chain.
> 
> Last time I check ARM platforms didn't support SG list chaining. Has that been
> fixed ?

DMA-mapping code for ARM platform use for_each_sg() macro which has no problems
with chained SG lists.

(snipped)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



