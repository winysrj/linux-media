Return-path: <linux-media-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3786 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZIASJB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2009 14:09:01 -0400
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was
 "Is get_user_pages() enough to prevent pages from being swapped out ?")
From: "David Xiao" <dxiao@broadcom.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Steven Walter" <stevenrwalter@gmail.com>,
	"Ben Dooks" <ben-linux@fluff.org>,
	"Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
	"Robin Holt" <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <20090901133110.GO19719@n2100.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
 <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com>
 <1251237768.8877.26.camel@david-laptop>
 <200908260117.27180.laurent.pinchart@ideasonboard.com>
 <1251307331.9535.16.camel@david-laptop>
 <20090901133110.GO19719@n2100.arm.linux.org.uk>
Date: Tue, 1 Sep 2009 11:08:51 -0700
Message-ID: <1251828531.3641.25.camel@david-laptop>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-09-01 at 06:31 -0700, Russell King - ARM Linux wrote:
> On Wed, Aug 26, 2009 at 10:22:11AM -0700, David Xiao wrote:
> > Sorry for the confusion, page_address() indeed only returns kernel
> > virtual address; and in order to support VIVT cache maintenance for the
> > user space mappings, the dma_map_sg/dma_map_page() functions or even the
> > struct scatterlist do seem to have to be modified to pass in virtual
> > address, I think.
> 
> That's the wrong answer.  When DMA happens (and therefore these functions
> are called) the userspace context could already have been switched away,
> which means that any userspace address information is useless.
> 
The dma_map_sg/page() needs to be set up before starting DMA operations.

If the context switch happens before/when DMA occurs, that is okay since
in the case of VIVT cache all the necessary cache lines will be
invalidated/flushed  anyway with every context switch. 

My understanding is that there are basically two issues associated with
VIVT cache in an OS environment:
1. address space change. When a context switch happens, if the new
address space is overlapping with the old one, as ARM linux does, all
the related cache lines have to be invalidated/flushed, unless something
like ASID used together with VIVT cache.

2. cache-line aliasing in the same address space. 
In the user space DMA case, we are assuming that these physical pages
are only mapped twice, once in user space and once in kernel
direct-mapping. 
I went through the kernel code path and think the kernel direct-mapping
was already flushed/invalidated before the pages were handed over to the
user space; therefore, the proposal is to record the user space virtual
address and do the proper cache maintenance operations.
 
> Adding support to the existing DMA API functions so they can be used for
> userspace mapped pages is simply the wrong approach - most users of those
> functions are not concerned with userspace mapped pages at all, and adding
> that burden onto all those users is clearly sub-optimal.
> 

The kernel is already addressing the mmap() file case by putting the
mapping field into the struct page and etc; and I personally do not
think it is too much of a change for the user space DMA case, if we
agree the application/request is valid of course.

David


