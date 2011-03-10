Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:48161 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1CJOO2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 09:14:28 -0500
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHU00MW0I81OID0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 23:14:25 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHU00FB2I7OUD@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 23:14:25 +0900 (KST)
Date: Thu, 10 Mar 2011 15:14:11 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Yet another memory provider: can linaro organize a meeting?
In-reply-to: <201103080913.59231.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linaro-dev@lists.linaro.org
Cc: linux-media@vger.kernel.org,
	'Jonghun Han' <jonghun.han@samsung.com>,
	'Russell King - ARM Linux' <linux@arm.linux.org.uk>,
	kyungmin.park@samsung.com
Message-id: <000001cbdf2d$7070bcb0$51523610$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <201103080913.59231.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Tuesday, March 08, 2011 9:14 AM Hans Verkuil wrote:

> We had a discussion yesterday regarding ways in which linaro can assist
> V4L2 development. One topic was that of sorting out memory providers like
> GEM and HWMEM.
> 
> Today I learned of yet another one: UMP from ARM.
> 
> http://blogs.arm.com/multimedia/249-making-the-mali-gpu-device-driver-open-
> source/page__cid__133__show__newcomment/

I really wonder what's the opinion of ARM Linux maintainer on this memory
allocator. Russell - could you comment on it? Is this a preferred memory
provider/allocator on ARM Linux platform? What's about still to-be-resolved
issues with mapping memory regions for DMA transfers and different cache
settings for each mapping?

> This is getting out of hand. I think that organizing a meeting to solve this
> mess should be on the top of the list. Companies keep on solving the same
> problem time and again and since none of it enters the mainline kernel any
> driver using it is also impossible to upstream.
> 
> All these memory-related modules have the same purpose: make it possible to
> allocate/reserve large amounts of memory and share it between different
> subsystems (primarily framebuffer, GPU and V4L).
> 
> It really shouldn't be that hard to get everyone involved together and settle
> on a single solution (either based on an existing proposal or create a 'the
> best of' vendor-neutral solution).
> 
> I am currently aware of the following solutions floating around the net
> that all solve different parts of the problem:
> 
> In the kernel: GEM and TTM.
> Out-of-tree: HWMEM, UMP, CMA, VCM, CMEM, PMEM.
> 
> I'm sure that last list is incomplete.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



