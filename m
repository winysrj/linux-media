Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60755 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab1FVOWz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 10:22:55 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LN700B9W3Y5IO00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 15:22:53 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LN7008WN3Y4Z1@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 15:22:53 +0100 (BST)
Date: Wed, 22 Jun 2011 16:22:48 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 5/5] marvell-cam: implement contiguous DMA operation
In-reply-to: <4E00FE70.4000401@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Jonathan Corbet' <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	'Kassey Lee' <ygli@marvell.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <003f01cc30e7$dd2b41c0$9781c540$%szyprowski@samsung.com>
Content-language: pl
References: <1308597280-138673-1-git-send-email-corbet@lwn.net>
 <1308597280-138673-6-git-send-email-corbet@lwn.net>
 <4E00FE70.4000401@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Tuesday, June 21, 2011 10:26 PM Mauro Carvalho Chehab wrote:

> Em 20-06-2011 16:14, Jonathan Corbet escreveu:
> > The core driver can now operate in either vmalloc or dma-contig modes;
> > obviously the latter is preferable when it is supported.  Default is
> > currently vmalloc on all platforms; load the module with buffer_mode=1
> for contiguous DMA mode.
> 
> Patch looks correct.
> 
> A side note for vb2 maintainers:
> 
> IMO, vb2 core should take the responsibility to allow to switch between DMA
> scatter/gather and continuous (and, eventually, vmalloc), where the bridge
> driver support more than one option.

> Otherwise, we'll end by having codes similar to that on all drivers that
> can be used on different architectures.

Could you elaborate a bit more on this issue? Depending on driver needs, on
just sets queue->mem_ops to vb2_vmalloc_memops, vb2_dma-contig_memops or 
vb2_dma-sg_memops. There is no dependencies between the core and memory
allocators/handlers.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


