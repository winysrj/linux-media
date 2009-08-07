Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54184 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792AbZHGU2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 16:28:41 -0400
Date: Fri, 7 Aug 2009 21:28:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Robin Holt <holt@sgi.com>,
	Laurent Desnogues <laurent.desnogues@gmail.com>,
	Jamie Lokier <jamie@shareable.org>,
	David Xiao <dxiao@broadcom.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
	get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090807202829.GF31543@n2100.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <20090807131501.GD2763@sgi.com> <20090807190145.GA31543@n2100.arm.linux.org.uk> <200908072211.45283.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200908072211.45283.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 07, 2009 at 10:11:40PM +0200, Laurent Pinchart wrote:
> Ok. Maybe the kernel mapping from L_PTE_MT_UNCACHED to strongly ordered for 
> ARMv6 and up (not sure about how it worked for previous versions) brought some 
> confusion. I'll try to be more precise now.

It's something we should correct.

> Does that mean that, in theory, all DMA transfers in the DMA_FROM_DEVICE 
> direction are currently broken on ARMv7 ?

Technically, yes.  I haven't had a stream of bug reports which tends
to suggest that either the speculation isn't that aggressive in current
silicon, or we're just lucky so far.

> The ARM Architecture Reference Manual (ARM DDI 0100I) states that

Bear in mind that DDI0100 is out of date now.  There's a different
document number for it (I forget what it is.)

> "• If the same memory locations are marked as having different memory types 
> (Normal, Device, or Strongly Ordered), for example by the use of synonyms in a 
> virtual to physical address mapping, UNPREDICTABLE behavior results.
> 
> • If the same memory locations are marked as having different cacheable 
> attributes, for example by the use of synonyms in a virtual to physical 
> address mapping, UNPREDICTABLE behavior results."

Both of these we end up doing.  The current position is "yes, umm, we're
not sure what we can do about that"... which also happens to be mine as
well.  Currently, my best solution is to go for minimal lowmem and
maximal highmem - so _everything_ gets mapped in on an as required
basis.

> This would be broken if a fully cached Normal mapping already existed for 
> those physical pages. You seem to imply that's the case, but I'm not sure to 
> understand why.

The kernel direct mapping maps all system (low) memory with normal
memory cacheable attributes.

So using vmalloc, dma_alloc_coherent, using pages in userspace all
create duplicate mappings of pages.
