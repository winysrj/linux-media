Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:38281 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933619AbZHGUJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 16:09:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is get_user_pages() enough to prevent pages from being swapped out ?")
Date: Fri, 7 Aug 2009 22:11:40 +0200
Cc: Robin Holt <holt@sgi.com>,
	Laurent Desnogues <laurent.desnogues@gmail.com>,
	Jamie Lokier <jamie@shareable.org>,
	David Xiao <dxiao@broadcom.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <20090807131501.GD2763@sgi.com> <20090807190145.GA31543@n2100.arm.linux.org.uk>
In-Reply-To: <20090807190145.GA31543@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908072211.45283.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 07 August 2009 21:01:45 Russell King - ARM Linux wrote:
> On Fri, Aug 07, 2009 at 08:15:01AM -0500, Robin Holt wrote:
> > On Fri, Aug 07, 2009 at 02:07:43PM +0200, Laurent Desnogues wrote:
> > > On Fri, Aug 7, 2009 at 11:54 AM, Jamie Lokier<jamie@shareable.org> 
wrote:
> > > > 1. Does the architecture not prevent speculative instruction
> > > > prefetches from crossing a page boundary?  It would be handy under
> > > > the circumstances.
> > >
> > > There's no such restriction in ARMv7 architecture.
> >
> > Doesn't it prevent them for uncached areas?
>
> "Uncached areas" is very very fuzzy.  Are you talking about a non-cachable
> memory mapping, or a strongly ordered mapping.
>
> I'm afraid that we're going to have to require more precise use of language
> to describe these things - wolley statements like "uncached areas" are now
> just too ambiguous.

Ok. Maybe the kernel mapping from L_PTE_MT_UNCACHED to strongly ordered for 
ARMv6 and up (not sure about how it worked for previous versions) brought some 
confusion. I'll try to be more precise now.

> > I _THOUGHT_ there was an alloc_consistent (or something like that) call on
> > ARM which gave you an uncached mapping where you could do DMA.
>
> The dma_alloc_coherent() does _remap_ memory into a strongly ordered
> mapping.  However, the fully cached mapping remains, which means that
> the CPU can still speculatively prefetch from that memory.

Does that mean that, in theory, all DMA transfers in the DMA_FROM_DEVICE 
direction are currently broken on ARMv7 ?

The ARM Architecture Reference Manual (ARM DDI 0100I) states that

"• If the same memory locations are marked as having different memory types 
(Normal, Device, or Strongly Ordered), for example by the use of synonyms in a 
virtual to physical address mapping, UNPREDICTABLE behavior results.

• If the same memory locations are marked as having different cacheable 
attributes, for example by the use of synonyms in a virtual to physical 
address mapping, UNPREDICTABLE behavior results."

dma_alloc_coherent() ends up calling __dma_alloc(), which allocates pages 
using alloc_pages(), flushes the data cache for the allocated virtual range 
and then simply remaps the pages using PTEs previously allocated from the 
kernel MM.

This would be broken if a fully cached Normal mapping already existed for 
those physical pages. You seem to imply that's the case, but I'm not sure to 
understand why.

> Since we map the fully cached mapping using section (or even supersection)
> mappings for TLB efficiency, we can't change the memory type on a
> per-page basis.
>
> > I also thought there was a dma_* set of functions which remapped as
> > uncached before DMA begins and remapped as normal after DMA has been
> > completed.
>
> You're talking about the deprecated DMA bounce code there.  It's
> basically the same problem since it uses the dma_alloc_coherent()
> interface to gain a source of DMA-able memory.

Regards,

Laurent Pinchart

