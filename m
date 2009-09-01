Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48819 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZIANoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 09:44:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is get_user_pages() enough to prevent pages from being swapped out ?")
Date: Tue, 1 Sep 2009 15:43:48 +0200
Cc: Steven Walter <stevenrwalter@gmail.com>,
	David Xiao <dxiao@broadcom.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com> <20090901132824.GN19719@n2100.arm.linux.org.uk>
In-Reply-To: <20090901132824.GN19719@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909011543.48439.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 01 September 2009 15:28:24 Russell King - ARM Linux wrote:
> On Tue, Aug 25, 2009 at 08:53:29AM -0400, Steven Walter wrote:
> > On Thu, Aug 6, 2009 at 6:25 PM, Russell King - ARM
> > Linux<linux@arm.linux.org.uk> wrote:
> > [...]
> >
> > > As far as userspace DMA coherency, the only way you could do it with
> > > current kernel APIs is by using get_user_pages(), creating a
> > > scatterlist from those, and then passing it to dma_map_sg().  While the
> > > device has ownership of the SG, userspace must _not_ touch the buffer
> > > until after DMA has completed.
> >
> > [...]
> >
> > Would that work on a processor with VIVT caches?  It seems not.  In
> > particular, dma_map_page uses page_address to get a virtual address to
> > pass to map_single().  map_single() in turn uses this address to
> > perform cache maintenance.  Since page_address() returns the kernel
> > virtual address, I don't see how any cache-lines for the userspace
> > virtual address would get invalidated (for the DMA_FROM_DEVICE case).
>
> You are correct.
>
> > If that's true, then what is the correct way to allow DMA to/from a
> > userspace buffer with a VIVT cache?  If not true, what am I missing?
>
> I don't think you read what I said (but I've also forgotten what I did
> say).
>
> To put it simply, the kernel does not support DMA direct from userspace
> pages.  Solutions which have been proposed in the past only work with a
> sub-set of conditions (such as the one above only works with VIPT
> caches.)

I might be missing something obvious, but I fail to see how VIVT caches could 
work at all with multiple mappings. If a kernel-allocated buffer is DMA'ed to, 
we certainly want to invalidate all cache lines that store buffer data. As the 
cache doesn't care about physical addresses we thus need to invalidate all 
virtual mappings for the buffer. If the buffer is mmap'ed in userspace I don't 
see how that would be done.

-- 
Laurent Pinchart
