Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52677 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1HQNGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 09:06:46 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Wed, 17 Aug 2011 15:06:08 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 7/9] ARM: DMA: steal memory for DMA coherent mappings
In-reply-to: <201108171428.44555.arnd@arndb.de>
To: 'Arnd Bergmann' <arnd@arndb.de>
Cc: 'Russell King - ARM Linux' <linux@arm.linux.org.uk>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	'Michal Nazarewicz' <mina86@mina86.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Andrew Morton' <akpm@linux-foundation.org>,
	'KAMEZAWA Hiroyuki' <kamezawa.hiroyu@jp.fujitsu.com>,
	'Ankita Garg' <ankita@in.ibm.com>,
	'Daniel Walker' <dwalker@codeaurora.org>,
	'Mel Gorman' <mel@csn.ul.ie>,
	'Jesse Barker' <jesse.barker@linaro.org>,
	'Jonathan Corbet' <corbet@lwn.net>,
	'Shariq Hasnain' <shariq.hasnain@linaro.org>,
	'Chunsang Jeong' <chunsang.jeong@linaro.org>
Message-id: <009101cc5cde$6dfaa660$49eff320$%szyprowski@samsung.com>
Content-language: pl
References: <1313146711-1767-1-git-send-email-m.szyprowski@samsung.com>
 <201108161626.26130.arnd@arndb.de>
 <006b01cc5cb3$dac09fa0$9041dee0$%szyprowski@samsung.com>
 <201108171428.44555.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, August 17, 2011 2:29 PM Arnd Bergmann wrote:

> On Wednesday 17 August 2011, Marek Szyprowski wrote:
> > Do we really need the dynamic pool for the first version? I would like to
> > know how much memory can be allocated in GFP_ATOMIC context. What are the
> > typical sizes of such allocations?
> 
> I think this highly depends on the board and on the use case. We know
> that 2 MB is usually enough, because that is the current CONSISTENT_DMA_SIZE
> on most platforms. Most likely something a lot smaller will be ok
> in practice. CONSISTENT_DMA_SIZE is currently used for both atomic
> and non-atomic allocations.

Ok. The platforms that increased CONSISTENT_DMA_SIZE usually did that to enable
support for framebuffer or other multimedia devices, which won't be allocated 
in ATOMIC context anyway.

> > Maybe for the first version a static pool with reasonably small size
> > (like 128KiB) will be more than enough? This size can be even board
> > depended or changed with kernel command line for systems that really
> > needs more memory.
> 
> For a first version that sounds good enough. Maybe we could use a fraction
> of the CONSISTENT_DMA_SIZE as an estimate?

Ok, good. For the initial values I will probably use 1/8 of 
CONSISTENT_DMA_SIZE for coherent allocations. Writecombine atomic allocations
are extremely rare and rather ARM specific. 1/32 of CONSISTENT_DMA_SIZE should
be more than enough for them.

> For the long-term solution, I see two options:
> 
> 1. make the preallocated pool rather small so we normally don't need it.
> 2. make it large enough so we can also fulfill most nonatomic allocations
>    from that pool to avoid the TLB flushes and going through the CMA
>    code. Only use the real CMA region when the pool allocation fails.
> 
> In either case, there should be some method for balancing the pool
> size.

Right. The most obvious method is to use additional kernel thread which will
periodically call the balance function. In the implementation both usage 
scenarios are very similar, so this can even be a kernel parameter or Kconfig
option, but lets leave this for the future vesions.
 
> > I noticed one more problem. The size of the CMA managed area must be
> > the multiple of 16MiBs (MAX_ORDER+1). This means that the smallest CMA area
> > is 16MiB. These values comes from the internals of the kernel memory
> > management design and page blocks are the only entities that can be managed
> > with page migration code.
> >
> > I'm not sure if all ARMv6+ boards have at least 32MiB of memory be able to
> > create a CMA area.
> 
> My guess is that you can assume to have 64 MB or more on ARMv6 running Linux,
> but other people may have more accurate data.
> 
> Also, there is the option of setting a lower value for FORCE_MAX_ZONEORDER
> for some platforms if it becomes a problem.

Ok. I figured out an error in the above calculation, so 8MiB is the smallest
CMA area size. Assuming that there are at least 32MiB of memory available this
is not an issue anymore.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

