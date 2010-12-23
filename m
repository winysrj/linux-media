Return-path: <mchehab@gaivota>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60809 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab0LWMVA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 07:21:00 -0500
Date: Thu, 23 Dec 2010 12:19:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: 'Kyungmin Park' <kmpark@infradead.org>,
	'Michal Nazarewicz' <m.nazarewicz@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	'Daniel Walker' <dwalker@codeaurora.org>,
	'Johan MOSSBERG' <johan.xx.mossberg@stericsson.com>,
	'Mel Gorman' <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
	'Michal Nazarewicz' <mina86@mina86.com>, linux-mm@kvack.org,
	'Ankita Garg' <ankita@in.ibm.com>,
	'Andrew Morton' <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org,
	'KAMEZAWA Hiroyuki' <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCHv8 00/12] Contiguous Memory Allocator
Message-ID: <20101223121917.GG3636@n2100.arm.linux.org.uk>
References: <cover.1292443200.git.m.nazarewicz@samsung.com> <AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com> <20101223100642.GD3636@n2100.arm.linux.org.uk> <00ea01cba290$4d67f500$e837df00$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00ea01cba290$4d67f500$e837df00$%szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, Dec 23, 2010 at 11:58:08AM +0100, Marek Szyprowski wrote:
> Actually this contiguous memory allocator is a better replacement for
> alloc_pages() which is used by dma_alloc_coherent(). It is a generic
> framework that is not tied only to ARM architecture.

... which is open to abuse.  What I'm trying to find out is - if it
can't be used for DMA, what is it to be used for?

Or are we inventing an everything-but-ARM framework?

> > In other words, do we _actually_ have a use for this which doesn't
> > involve doing something like allocating 32MB of memory from it,
> > remapping it so that it's DMA coherent, and then performing DMA
> > on the resulting buffer?
> 
> This is an arm specific problem, also related to dma_alloc_coherent()
> allocator. To be 100% conformant with ARM specification we would
> probably need to unmap all pages used by the dma_coherent allocator
> from the LOW MEM area. This is doable, but completely not related
> to the CMA and this patch series.

You've already been told why we can't unmap pages from the kernel
direct mapping.

Okay, so I'm just going to assume that CMA has _no_ _business_ being
used on ARM, and is not something that should interest anyone in the
ARM community.
