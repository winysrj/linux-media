Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51666 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbZHGH4X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 03:56:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "David Xiao" <dxiao@broadcom.com>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is get_user_pages() enough to prevent pages from being swapped out ?")
Date: Fri, 7 Aug 2009 09:58:30 +0200
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
	"Ben Dooks" <ben-linux@fluff.org>,
	"Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
	"Robin Holt" <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <20090806222543.GG31579@n2100.arm.linux.org.uk> <1249624766.32621.61.camel@david-laptop>
In-Reply-To: <1249624766.32621.61.camel@david-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908070958.31322.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 07 August 2009 07:59:26 David Xiao wrote:
> On Thu, 2009-08-06 at 15:25 -0700, Russell King - ARM Linux wrote:
> > As far as userspace DMA coherency, the only way you could do it with
> > current kernel APIs is by using get_user_pages(), creating a scatterlist
> > from those, and then passing it to dma_map_sg().  While the device has
> > ownership of the SG, userspace must _not_ touch the buffer until after
> > DMA has completed.
> >
> > However, that won't work with ARMv7's speculative prefetching.  I'm
> > afraid with such things, DMA direct into userspace mappings becomes a
> > _lot_ harder, and lets face it, lots of Linux drivers just aren't going
> > to bother supporting this - we can't currently get agreement to have an
> > API to map DMA coherent pages into userspace!
>
> The V7 speculative prefetching will then probably apply to DMA coherency
> issue in general, both kernel and user space DMAs. Could this be
> addressed by inside the dma_unmap_sg/single() calling dma_cache_maint()
> when the direction is DMA_FROM_DEVICE/DMA_BIDIRECTIONAL, to basically
> invalidate the related cache lines in case any filled by prefetching?
> Assuming dma_unmap_sg/single() is called after each DMA operation is
> completed.

Sorry about this, but I'm not sure to understand the speculative prefetching 
cache issue completely.

My understanding is that, even if userspace doesn't touch the DMA buffer while 
DMA is in progress, it could still read from locations close to the buffer, 
resulting in a speculative prefetch of data in the buffer. Those data would 
then end up in the D-cache, and would not be coherent with what the device 
transfers.

If that's correct, how do we avoid the problem in the general case of DMA to 
kernel-allocated buffers ?

Regards,

Laurent Pinchart

