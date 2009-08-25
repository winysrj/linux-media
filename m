Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:47106 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbZHYXOV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 19:14:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "David Xiao" <dxiao@broadcom.com>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is get_user_pages() enough to prevent pages from being swapped out ?")
Date: Wed, 26 Aug 2009 01:17:27 +0200
Cc: "Steven Walter" <stevenrwalter@gmail.com>,
	"Russell King - ARM Linux" <linux@arm.linux.org.uk>,
	"Ben Dooks" <ben-linux@fluff.org>,
	"Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
	"Robin Holt" <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com> <1251237768.8877.26.camel@david-laptop>
In-Reply-To: <1251237768.8877.26.camel@david-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908260117.27180.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 26 August 2009 00:02:48 David Xiao wrote:
> On Tue, 2009-08-25 at 05:53 -0700, Steven Walter wrote:
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
> >
> > If that's true, then what is the correct way to allow DMA to/from a
> > userspace buffer with a VIVT cache?  If not true, what am I missing?
>
> page_address() is basically returning page->virtual, which records the
> virtual/physical mapping for both user/kernel space; and what only
> matters there is highmem or not.

I'm not sure to get it. Are you implying that a physical page will then be 
mapped to the same address in all contexts (kernelspace and userspace 
processes) ? Is that even possible ? And if not, how could page->virtual store 
both the initial kernel map and all the userspace mappings ?

-- 
Laurent Pinchart
