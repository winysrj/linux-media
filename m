Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:28552 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZICHhO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2009 03:37:14 -0400
Date: Thu, 3 Sep 2009 10:31:51 +0300
From: Imre Deak <imre.deak@nokia.com>
To: ext Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Steven Walter <stevenrwalter@gmail.com>,
	David Xiao <dxiao@broadcom.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
	get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090903073151.GA25928@localhost>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com> <20090901132824.GN19719@n2100.arm.linux.org.uk> <200909011543.48439.laurent.pinchart@ideasonboard.com> <20090902151044.GG30183@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902151044.GG30183@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 02, 2009 at 05:10:44PM +0200, Deak Imre (Nokia-D/Helsinki) wrote:
> On Tue, Sep 01, 2009 at 03:43:48PM +0200, ext Laurent Pinchart wrote:
> > [...]
> > I might be missing something obvious, but I fail to see how VIVT caches could 
> > work at all with multiple mappings. If a kernel-allocated buffer is DMA'ed to, 
> > we certainly want to invalidate all cache lines that store buffer data. As the 
> > cache doesn't care about physical addresses we thus need to invalidate all 
> > virtual mappings for the buffer. If the buffer is mmap'ed in userspace I don't 
> > see how that would be done.
> 
> To my understanding buffers returned by dma_alloc_*, kmalloc, vmalloc
> are ok:
> 
> The cache lines for direct mapping are flushed in dma_alloc_* and
> vmalloc. After this you are not supposed to access the buffers
> through the direct mapping until you're done with the DMA.
> 
> For kmalloc you use the direct mapping in the first place, so the
> flush in dma_map_* will be enough.
> 
> For user mappings I think you'd have to do an additional flush for
> the direct mapping, while the user mapping is flushed in dma_map_*.

Based on the the discussion so far this is my understanding on how
zero-copy DMA is possible on ARM. Could you please confirm / correct
these? :

- user space passes an arbitrary buffer:
  - get_user_pages(user address range)
  - DMA(user address range)
  - user space reads from the buffer

  Problems:
  - not supported according to Russell
  - unhandled faults for cache ops on not-present PTEs, but patch
    from Laurent fixes this

- mmap a kernel buffer to user space with cacheable mapping:
  - user space writes to the buffer
  - flush cache(user address range)
  - DMA(kernel buffer)
  - user space reads from the buffer

  The additional flush cache is needed for VIVT/aliasing VIPT.
  Instead of the flush cache:
  - the mapping can be done with writethrough, non-writeallocate or
    non-cacheable mapping, or
  - for aliasing VIPT a non-aliasing user address is picked

DMA(address range) is:
  - dma_map_*(address range)
  - perform DMA to/from address range
  - dma_unmap_*(address range)

Thanks,
Imre

