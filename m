Return-path: <linux-media-owner@vger.kernel.org>
Received: from trinity.fluff.org ([89.16.178.74]:60496 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbZHFLqk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2009 07:46:40 -0400
Date: Thu, 6 Aug 2009 12:46:19 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
	v4l2_linux <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090806114619.GW2080@trinity.fluff.org>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908061208.22131.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 06, 2009 at 12:08:21PM +0200, Laurent Pinchart wrote:
> [Resent with an updated subject, this time CC'ing linux-arm-kernel]
> 
> I've spent the last few days "playing" with get_user_pages() and mlock() and 
> got some interesting results. It turned out that cache coherency comes into 
> play at some point, making the overall problem more complex.
> 
> Here's my current setup:
> 
> - OMAP processor, based on an ARMv7 core
> - MMU and IOMMU
> - VIPT non-aliasing data cache
> - video capture driver that transfers data to memory using DMA
> - video capture application that pass userspace pointers to video buffers to 
> the driver
> 
> My goal is to make sure that, upon DMA completion, the correct data will be 
> available to the userspace application.
> 
> The first problem was to pin pages to memory, to make sure they will not be 
> freed when the DMA is in progress. videobug-dma-sg uses get_user_pages() for 
> that, and Hugh Dickins nicely explained to me why this is enough.
> 
> The second problem is to ensure cache coherency. As the userspace application 
> will read data from the video buffers, those buffers will end up being cached 
> in the processor's data cache. The driver does need to invalidate the cache 
> before starting the DMA operation (userspace could in theory write to the 
> buffers, but the data will be overwritten by DMA anyway, so there's no need to 
> clean the cache).

You'll need to clean the write buffers, otherwise the CPU may have data
queued that it has yet to write back to memory.

> As the cache is of the VIPT (Virtual Index Physical Tag) type, cache 
> invalidation can either be done globally (in which case the cache is flushed 
> instead of being invalidated) or based on virtual addresses. In the last case 
> the processor will need to look physical addresses up, either in the TLB or 
> through hardware table walk.
> 
> I can see three solutions to the DMA/cache problem.
> 
> 1. Flushing the whole data cache right before starting the DMA transfer. 
> There's no API for that in the ARM architecture, so a whole I+D cache is 
> required. This is quite costly, we're talking about around 30 flushes per 
> second, but it doesn't involve the MMU. That's the solution that I currently 
> use.
> 
> 2. Invalidating only the cache lines that store video buffer data. This 
> requires a TLB lookup or a hardware table walk, so the userspace application 
> MM context needs to be available (no problem there as where's flushing in 
> userspace context) and all pages need to be mapped properly. This can be a 
> problem as, as Hugh pointed out, pages can still be unmapped from the 
> userspace context after get_user_pages() returns. I have experienced one oops 
> due to a kernel paging request failure:

If you already know the virtual addresses of the buffers, why do you need
a TLB lookup (or am I being dense here?)

>         Unable to handle kernel paging request at virtual address 44e12000
>         pgd = c8698000
>         [44e12000] *pgd=8a4fd031, *pte=8cfda1cd, *ppte=00000000
>         Internal error: Oops: 817 [#1] PREEMPT
>         PC is at v7_dma_inv_range+0x2c/0x44
> 
> Fixing this requires more investigation, and I'm not sure how to proceed to 
> find out if the page fault is really caused by pages being unmapped from the 
> userspace context. Help would be appreciated.
> 
> 3. Mark the pages as non-cacheable. Depending on how the buffers are then used 
> by userspace, the additional cache misses might destroy any benefit I would 
> get from not flushing the cache before DMA. I'm not sure how to mark a bunch 
> of pages as non-cacheable though. What usually happens is that video drivers 
> allocate DMA-coherent memory themselves, but in this case I need to deal with 
> an arbitrary buffer allocated by userspace. If someone has any experience with 
> this, it would be appreciated.
> 
> Regards,
> 
> Laurent Pinchart
> 
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

