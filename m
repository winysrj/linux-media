Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41863 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175AbZHGII2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 04:08:28 -0400
Date: Fri, 7 Aug 2009 09:08:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Xiao <dxiao@broadcom.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
	get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090807080811.GA18343@n2100.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <20090806114619.GW2080@trinity.fluff.org> <200908061506.23874.laurent.pinchart@ideasonboard.com> <1249584374.29182.20.camel@david-laptop> <20090806222543.GG31579@n2100.arm.linux.org.uk> <1249624766.32621.61.camel@david-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249624766.32621.61.camel@david-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 06, 2009 at 10:59:26PM -0700, David Xiao wrote:
> The V7 speculative prefetching will then probably apply to DMA coherency
> issue in general, both kernel and user space DMAs. Could this be
> addressed by inside the dma_unmap_sg/single() calling dma_cache_maint()
> when the direction is DMA_FROM_DEVICE/DMA_BIDIRECTIONAL, to basically
> invalidate the related cache lines in case any filled by prefetching?
> Assuming dma_unmap_sg/single() is called after each DMA operation is
> completed. 

It's something that I was going to look at, and it's probably going to
have to be something I do blind - I currently have no MPCore platform,
and even if my Realview EB worked, it doesn't use DMA at all.

However, it's not trivial - the unmap functions don't have all the
necessary information.  dma_unmap_single() has the DMA address, which
we can convert to the original virtual address via dma_to_virt().
However, dma_unmap_page() can't translate back to a virtual page
since we're missing some information there.

It bugs me that the DMA API is restrictive in the information which
architectures can retain across a mapping which makes this non-trivial.
Had I known of these issues when the DMA API was originally being
discussed, I'd have suggested that we have an arch-specific dma_map
struct which could contain whatever information was required, rather
than requiring the driver to maintain the handle/size/direction/etc
between each of the calls.  That would mean we could retain the virtual
address/struct page rather than having to work it back in some way.
