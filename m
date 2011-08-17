Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52432 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1HQIwe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 04:52:34 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQ200228DZK3L@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Aug 2011 09:52:32 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQ200LY3DZI0A@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Aug 2011 09:52:31 +0100 (BST)
Date: Wed, 17 Aug 2011 10:51:56 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: dma-sg allocator: change scatterlist
 allocation method
In-reply-to: <20110816180315.4be6ac9b@tpl.lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>
Cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <007a01cc5cba$eb512d60$c1f38820$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1312964617-3192-1-git-send-email-m.szyprowski@samsung.com>
 <201108122354.51720.laurent.pinchart@ideasonboard.com>
 <03bd01cc5bd6$40a86b10$c1f94130$%szyprowski@samsung.com>
 <201108161041.40789.laurent.pinchart@ideasonboard.com>
 <004401cc5c00$24998ce0$6dcca6a0$%szyprowski@samsung.com>
 <20110816180315.4be6ac9b@tpl.lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, August 17, 2011 2:03 AM Jonathan Corbet wrote:

> On Tue, 16 Aug 2011 12:34:56 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > Right, I wasn't aware of that, but it still doesn't look like an issue. The
only
> >
> > client of dma-sg allocator is marvell-ccic, which is used on x86 systems. If
one
> > needs dma-sg allocator on ARM, he should follow the suggestion from the
> > 74facffeca3795ffb5cf8898f5859fbb822e4c5d commit message.
> 
> Um...that driver runs on ARM, actually - the controller is part of the
> ARMADA 610 SoC...

Ups, I'm really sorry, it looks that I mixed something. I thought that OLPCs are

only x86 based.

> For the OLPC 1.75 there will never be a scatterlist longer than one
> page, I don't think.  That controller can do HD, though, so longer
> lists are possible in the future.

Ok, I see. Do you think it would be possible to ask PXA/MMP platform developers
to 
review all the drivers that can be used on that platform and enable scatter-list

chaining for this arm sub-arch? If this is a problem then we will have to delay
this
sg chaining patch.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

