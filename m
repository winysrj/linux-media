Return-path: <linux-media-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4745 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZHYWC6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 18:02:58 -0400
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was
 "Is get_user_pages() enough to prevent pages from being swapped out ?")
From: "David Xiao" <dxiao@broadcom.com>
To: "Steven Walter" <stevenrwalter@gmail.com>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Ben Dooks" <ben-linux@fluff.org>,
	"Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
	"Robin Holt" <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
 <20090806114619.GW2080@trinity.fluff.org>
 <200908061506.23874.laurent.pinchart@ideasonboard.com>
 <1249584374.29182.20.camel@david-laptop>
 <20090806222543.GG31579@n2100.arm.linux.org.uk>
 <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com>
Date: Tue, 25 Aug 2009 15:02:48 -0700
Message-ID: <1251237768.8877.26.camel@david-laptop>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-08-25 at 05:53 -0700, Steven Walter wrote:
> On Thu, Aug 6, 2009 at 6:25 PM, Russell King - ARM
> Linux<linux@arm.linux.org.uk> wrote:
> [...]
> > As far as userspace DMA coherency, the only way you could do it with
> > current kernel APIs is by using get_user_pages(), creating a scatterlist
> > from those, and then passing it to dma_map_sg().  While the device has
> > ownership of the SG, userspace must _not_ touch the buffer until after
> > DMA has completed.
> [...]
> 
> Would that work on a processor with VIVT caches?  It seems not.  In
> particular, dma_map_page uses page_address to get a virtual address to
> pass to map_single().  map_single() in turn uses this address to
> perform cache maintenance.  Since page_address() returns the kernel
> virtual address, I don't see how any cache-lines for the userspace
> virtual address would get invalidated (for the DMA_FROM_DEVICE case).
> 
> If that's true, then what is the correct way to allow DMA to/from a
> userspace buffer with a VIVT cache?  If not true, what am I missing?

page_address() is basically returning page->virtual, which records the
virtual/physical mapping for both user/kernel space; and what only
matters there is highmem or not.

David 


