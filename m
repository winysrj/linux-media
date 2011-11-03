Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63586 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1KCKlG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 06:41:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LU2008SAZ0FR140@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 10:41:03 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU20093SZ0ESK@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 10:41:03 +0000 (GMT)
Date: Thu, 03 Nov 2011 11:40:59 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: RE: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
In-reply-to: <201111021453.46902.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <002301cc9a15$13580cb0$3a082610$%p@samsung.com>
Content-language: pl
References: <1320231122-22518-1-git-send-email-andrzej.p@samsung.com>
 <201111021453.46902.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

Thank you for quickly responding with a review. As for coding style
remarks I generally agree. However, Guennadi seems to have a different
opinion on one of them.

On Wednesday, November 02, 2011 2:54 PM Laurent Pinchart wrote:

> 
> This can cause an AB-BA deadlock, and will be reported by deadlock
> detection
> if enabled.
> 
Marek has already wrote about this. The same problem relates to other
allocators, AFAIK. He proposed a solution.

Regards,

Andrzej



