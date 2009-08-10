Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:32930 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbZHJNq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 09:46:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is get_user_pages() enough to prevent pages from being swapped out ?")
Date: Mon, 10 Aug 2009 15:49:10 +0200
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
	Robin Holt <holt@sgi.com>,
	Laurent Desnogues <laurent.desnogues@gmail.com>,
	Jamie Lokier <jamie@shareable.org>,
	David Xiao <dxiao@broadcom.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"v4l2_linux" <linux-media@vger.kernel.org>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <200908072211.45283.laurent.pinchart@ideasonboard.com> <20090807202829.GF31543@n2100.arm.linux.org.uk>
In-Reply-To: <20090807202829.GF31543@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908101549.10683.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 07 August 2009 22:28:29 Russell King - ARM Linux wrote:
> On Fri, Aug 07, 2009 at 10:11:40PM +0200, Laurent Pinchart wrote:
> > Ok. Maybe the kernel mapping from L_PTE_MT_UNCACHED to strongly ordered
> > for ARMv6 and up (not sure about how it worked for previous versions)
> > brought some confusion. I'll try to be more precise now.
>
> It's something we should correct.

Do you mean we should map L_PTE_MT_UNCACHED to Normal, non cacheable memory on 
ARMv6 and up ? That looks like an easy change, but I'm scared of possible side 
effects.

> > Does that mean that, in theory, all DMA transfers in the DMA_FROM_DEVICE
> > direction are currently broken on ARMv7 ?
>
> Technically, yes.  I haven't had a stream of bug reports which tends to
> suggest that either the speculation isn't that aggressive in current
> silicon, or we're just lucky so far.

Current silicons probably avoid prefetching memory at random. The most 
probable cause of problems would be a read in kernel virtual memory at a 
location just before the buffer being written by DMA. This would result in a 
few bytes being corrupted for no apparent reason. As the problem would be 
quite difficult to reproduce, I don't expect many people to perform an in-
depth investigation and fill a bug report.

> > The ARM Architecture Reference Manual (ARM DDI 0100I) states that
>
> Bear in mind that DDI0100 is out of date now.  There's a different document
> number for it (I forget what it is.)

Are you talking about the ARM Cortex A8 TRM (ARM DDI 0344D) ? I've read that 
one (and I should have done so earlier, it helped me understand that the 
kernel properly maps Linux PTE flags to ARM PTE flags where I thought there 
was a bug).

> > "• If the same memory locations are marked as having different memory
> > types (Normal, Device, or Strongly Ordered), for example by the use of
> > synonyms in a virtual to physical address mapping, UNPREDICTABLE behavior
> > results.
> >
> > • If the same memory locations are marked as having different cacheable
> > attributes, for example by the use of synonyms in a virtual to physical
> > address mapping, UNPREDICTABLE behavior results."
>
> Both of these we end up doing.  The current position is "yes, umm, we're not
> sure what we can do about that"... which also happens to be mine as well.
> Currently, my best solution is to go for minimal lowmem and maximal highmem
> - so _everything_ gets mapped in on an as required basis.

I suppose the problem will be more common in future architectures, even on 
other platforms. Do we have the proper infrastructure to do so without 
seriously damaging performances ?

> > This would be broken if a fully cached Normal mapping already existed for
> > those physical pages. You seem to imply that's the case, but I'm not sure
> > to understand why.
>
> The kernel direct mapping maps all system (low) memory with normal
> memory cacheable attributes.
>
> So using vmalloc, dma_alloc_coherent, using pages in userspace all
> create duplicate mappings of pages.

Right.

I'm experimenting with several solutions to the initial problem (handling DMA 
and cache). Of course they all theoretically break because of the aliasing 
introduced by the kernel low memory mapping combined with speculative 
prefetching, but as that problem is global it won't affect performances of one 
solution over the other.

1. Flushing the whole cache before giving ownership of the buffer to the 
device works, but is quite costly.

2. Flushing only part of the cache might work, but I'm getting unhandled 
kernel paging requests. I'm investigating that.

3. Marking the userspace mapping as non-cacheable might bring a performance 
improvement, so I'd like to try that.

I'd like some help with marking the mapping as non-cacheable. As pages can be 
unmapped from userspace virtual memory even though get_user_pages() prevent 
them from being freed, I need to either:

a. Make sure the mapping will be non-cacheable when brought back in userspace 
virtual memory after a page fault. This requires marking the whole underlying 
VMA as non-cacheable (vma->vm_page_prot), possibly making much more than the 
video buffers uncacheable.

My plan is to retrieve a pointer to the VMA underlying the buffer, then walk 
the VMA virtual addresses range to mark all associated PTEs as uncacheable. If 
a PTE is not present for some reason I won't need to care, as it will be 
faulted in correctly using the VMA vm_page_prot the next time is is accessed.

I'm not sure how to handle young PTEs though. On at least ARMv7 a non-young 
Linux PTE seems to result in an invalid ARM PTE (0x0000000). What exactly is 
that for ? How should I care ?

b. Prevent the pages from being unmapped from the userspace virtual mapping, 
in which case the whole VMA won't need to be marked as uncached (unless this 
breaks coherency somewhere else).

I've read/heard that this can be done by using mlock() from userspace, but I 
need a kernel-side solution. mlock() marks the VMA as VM_LOCKED among other 
things. Would that be enough to prevent pages from being unmapped from 
userspace virtual memory ?

Regards,

--
Laurent Pinchart
