Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11080 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2ABKuR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 05:50:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LX600L3B3FRBQ50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Jan 2012 10:50:15 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LX60059P3FQQG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Jan 2012 10:50:15 +0000 (GMT)
Date: Mon, 02 Jan 2012 11:50:09 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
In-reply-to: <CACKLOr1noPCG4yW4drZ6Y=tmkqrzaBOF8k_7QJfFwDqV370RaA@mail.gmail.com>
To: 'javier Martin' <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <008e01ccc93c$4c398300$e4ac8900$%szyprowski@samsung.com>
Content-language: pl
References: <201112120024.04418.laurent.pinchart@ideasonboard.com>
 <1323962729-5689-1-git-send-email-m.szyprowski@samsung.com>
 <CACKLOr1noPCG4yW4drZ6Y=tmkqrzaBOF8k_7QJfFwDqV370RaA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Javier,

On Monday, January 02, 2012 11:45 AM You wrote:

> what is the status of this patch? Did you finally merge it in any tree?
> 
> I am willing to extend it so that it can support pfn mappings as soon
> as it's ready.

This patch has been merged to media-next kernel branch. You can download it
here:
http://git.linuxtv.org/media_tree.git/shortlog/refs/heads/staging/for_v3.3

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



