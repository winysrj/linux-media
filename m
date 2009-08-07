Return-path: <linux-media-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1723 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZHGF7q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Aug 2009 01:59:46 -0400
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was
 "Is get_user_pages() enough to prevent pages from being swapped out ?")
From: "David Xiao" <dxiao@broadcom.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Ben Dooks" <ben-linux@fluff.org>,
	"Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
	"Robin Holt" <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <20090806222543.GG31579@n2100.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
 <20090806114619.GW2080@trinity.fluff.org>
 <200908061506.23874.laurent.pinchart@ideasonboard.com>
 <1249584374.29182.20.camel@david-laptop>
 <20090806222543.GG31579@n2100.arm.linux.org.uk>
Date: Thu, 6 Aug 2009 22:59:26 -0700
Message-ID: <1249624766.32621.61.camel@david-laptop>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-08-06 at 15:25 -0700, Russell King - ARM Linux wrote: 
> On Thu, Aug 06, 2009 at 11:46:14AM -0700, David Xiao wrote:
> > On Thu, 2009-08-06 at 06:06 -0700, Laurent Pinchart wrote:
> > > Hi Ben,
> > > 
> > > On Thursday 06 August 2009 13:46:19 Ben Dooks wrote:
> > > > On Thu, Aug 06, 2009 at 12:08:21PM +0200, Laurent Pinchart wrote:
> > > [snip]
> > > > >
> > > > > The second problem is to ensure cache coherency. As the userspace
> > > > > application will read data from the video buffers, those buffers will end
> > > > > up being cached in the processor's data cache. The driver does need to
> > > > > invalidate the cache before starting the DMA operation (userspace could
> > > > > in theory write to the buffers, but the data will be overwritten by DMA
> > > > > anyway, so there's no need to clean the cache).
> > > >
> > > > You'll need to clean the write buffers, otherwise the CPU may have data
> > > > queued that it has yet to write back to memory.
> > > 
> > > Good points, thanks.
> > 
> >    I thought this should have been taken care of by the CPU specific
> > dma_inv_range routine. However, In arch/arm/mm/cache-v7.c,
> > v7_dma_inv_range does not drain the write buffer; and the
> > v6_dma_inv_range does that in the end of all the cache maintenance
> > operaitons.
> 
> There's no such thing as "drain write buffer" in ARMv7.  There are
> barriers instead, in particular dsb, which replaces the original
> "drain write buffer" instruction.
> 
Sorry, I overlooked the "DSB" inst in the end; yes, it looks like the
CP15 related "drain write buffer" inst is deprecated in V7. 
> As far as userspace DMA coherency, the only way you could do it with
> current kernel APIs is by using get_user_pages(), creating a scatterlist
> from those, and then passing it to dma_map_sg().  While the device has
> ownership of the SG, userspace must _not_ touch the buffer until after
> DMA has completed.
> 
> However, that won't work with ARMv7's speculative prefetching.  I'm
> afraid with such things, DMA direct into userspace mappings becomes a
> _lot_ harder, and lets face it, lots of Linux drivers just aren't going
> to bother supporting this - we can't currently get agreement to have an
> API to map DMA coherent pages into userspace!

The V7 speculative prefetching will then probably apply to DMA coherency
issue in general, both kernel and user space DMAs. Could this be
addressed by inside the dma_unmap_sg/single() calling dma_cache_maint()
when the direction is DMA_FROM_DEVICE/DMA_BIDIRECTIONAL, to basically
invalidate the related cache lines in case any filled by prefetching?
Assuming dma_unmap_sg/single() is called after each DMA operation is
completed. 

David  



