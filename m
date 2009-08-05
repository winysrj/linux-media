Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50828 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934539AbZHEOgJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 10:36:09 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Is get_user_pages() enough to prevent pages from being swapped out ?
Date: Wed, 5 Aug 2009 16:37:57 +0200
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
	"v4l2_linux" <linux-media@vger.kernel.org>
References: <200907291123.12811.laurent.pinchart@skynet.be> <20090730113951.GA2763@sgi.com> <Pine.LNX.4.64.0907301248090.27155@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0907301248090.27155@sister.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908051637.58276.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugh,

I've spent the last few days "playing" with get_user_pages() and mlock() and 
got some interesting results. It turned out that cache coherency comes into 
play at some point, making the overall problem more complex.

Here's my current setup:

- OMAP processor, based on an ARMv7 core
- MMU and IOMMU
- VIPT non-aliasing data cache
- video capture driver that transfers data to memory using DMA
- video capture application that pass userspace pointers to video buffers to 
the driver

My goal is to make sure that, upon DMA completion, the correct data will be 
available to the userspace application.

The first problem was to pin pages to memory, to make sure they will not be 
freed when the DMA is in progress. videobug-dma-sg uses get_user_pages() for 
that, and you nicely explained to me why this is enough.

The second problem is to ensure cache coherency. As the userspace application 
will read data from the video buffers, those buffers will end up being cached 
in the processor's data cache. The driver does need to invalidate the cache 
before starting the DMA operation (userspace could in theory write to the 
buffers, but the data will be overwritten by DMA anyway, so there's no need to 
clean the cache).

As the cache is of the VIPT (Virtual Index Physical Tag) type, cache 
invalidation can either be done globally (in which case the cache is flushed 
instead of being invalidated) or based on virtual addresses. In the last case 
the processor will need to look physical addresses up, either in the TLB or 
through hardware table walk.

I can see three solutions to the DMA/cache problem.

1. Flushing the whole data cache right before starting the DMA transfer. 
There's no API for that in the ARM architecture, so a whole I+D cache is 
required. This is quite costly, we're talking about around 30 flushes per 
second, but it doesn't involve the MMU. That's the solution that I currently 
use.

2. Invalidating only the cache lines that store video buffer data. This 
requires a TLB lookup or a hardware table walk, so the userspace application 
MM context needs to be available (no problem there as where's flushing in 
userspace context) and all pages need to be mapped properly. This can be a 
problem as, as you pointed out, pages can still be unmapped from the userspace 
context after get_user_pages() returns. I have experienced one oops due to a 
kernel paging request failure:

	Unable to handle kernel paging request at virtual address 44e12000
	pgd = c8698000
	[44e12000] *pgd=8a4fd031, *pte=8cfda1cd, *ppte=00000000
	Internal error: Oops: 817 [#1] PREEMPT
	PC is at v7_dma_inv_range+0x2c/0x44

Fixing this requires more investigation, and I'm not sure how to proceed to 
find out if the page fault is really caused by pages being unmapped from the 
userspace context. Help would be appreciated.

3. Mark the pages as non-cacheable. Depending on how the buffers are then used 
by userspace, the additional cache misses might destroy any benefit I would 
get from not flushing the cache before DMA. I'm not sure how to mark a bunch 
of pages as non-cacheable though. What usually happens is that video drivers 
allocate DMA-coherent memory themselves, but in this case I need to deal with 
an arbitrary buffer allocated by userspace. If someone has any experience with 
this, it would be appreciated.

Regards,

Laurent Pinchart

