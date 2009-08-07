Return-path: <linux-media-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2305 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZHGW0F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Aug 2009 18:26:05 -0400
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was
 "Is get_user_pages() enough to prevent pages from being swapped out ?")
From: "David Xiao" <dxiao@broadcom.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Robin Holt" <holt@sgi.com>,
	"Laurent Desnogues" <laurent.desnogues@gmail.com>,
	"Jamie Lokier" <jamie@shareable.org>,
	"Ben Dooks" <ben-linux@fluff.org>,
	"Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <20090807202829.GF31543@n2100.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
 <20090807131501.GD2763@sgi.com>
 <20090807190145.GA31543@n2100.arm.linux.org.uk>
 <200908072211.45283.laurent.pinchart@ideasonboard.com>
 <20090807202829.GF31543@n2100.arm.linux.org.uk>
Date: Fri, 7 Aug 2009 15:25:52 -0700
Message-ID: <1249683952.4671.41.camel@david-laptop>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-08-07 at 13:28 -0700, Russell King - ARM Linux wrote:

> The kernel direct mapping maps all system (low) memory with normal
> memory cacheable attributes.
> 
> So using vmalloc, dma_alloc_coherent, using pages in userspace all
> create duplicate mappings of pages.
> 

If we do want to remove all these duplicate mappings, as part of
solution to deal with the speculative prefetching, probably one way is
to not map all the RAM into the direct-mapped space at paging_init()
time, and instead map them on-demand by different upper layer allocation
functions, such as vmalloc/dma_alloc_coherent/do_brk/kmalloc/
get_free_pages/etc. But then the distinction between upper layer
allocation functions and non-upper layer ones must be made clear though.

I know that mapping the RAM at paging_init() time can take advantage of
1M section mapping most of the time, and thus save many 1KB L2 page
tables. But a lot of memory still ends up being remapped with L2 page
tables later on, and meanwhile 1KB might not be as "precious" as it used
to be as well-:)

David    



