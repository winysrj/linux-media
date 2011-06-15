Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64101 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1FOIP1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 04:15:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Wed, 15 Jun 2011 10:14:53 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
In-reply-to: <201106150937.18524.arnd@arndb.de>
To: 'Arnd Bergmann' <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org
Cc: 'Michal Nazarewicz' <mina86@mina86.com>,
	'Ankita Garg' <ankita@in.ibm.com>,
	'Daniel Walker' <dwalker@codeaurora.org>,
	'Jesse Barker' <jesse.barker@linaro.org>,
	'Mel Gorman' <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'KAMEZAWA Hiroyuki' <kamezawa.hiroyu@jp.fujitsu.com>,
	'Andrew Morton' <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <000701cc2b34$4e090710$ea1b1530$%szyprowski@samsung.com>
Content-language: pl
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <201106142030.07549.arnd@arndb.de>
 <000501cc2b2b$789a54b0$69cefe10$%szyprowski@samsung.com>
 <201106150937.18524.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, June 15, 2011 9:37 AM Arnd Bergmann wrote:

> On Wednesday 15 June 2011 09:11:39 Marek Szyprowski wrote:
> > I see your concerns, but I really wonder how to determine the properties
> > of the global/default cma pool. You definitely don't want to give all
> > available memory o CMA, because it will have negative impact on kernel
> > operation (kernel really needs to allocate unmovable pages from time to
> > time).
> 
> Exactly. This is a hard problem, so I would prefer to see a solution for
> coming up with reasonable defaults.

The problem is to define these reasonable defaults, because they also depend
on the target usage pattern for the board. If one doesn't plan to use video
codec at all, then the value calculated for full HD movie decoding are 
definitely too high.

> > The only solution I see now is to provide Kconfig entry to determine
> > the size of the global CMA pool, but this still have some issues,
> > especially for multi-board kernels (each board probably will have
> > different amount of RAM and different memory-consuming devices
> > available). It looks that each board startup code still might need to
> > tweak the size of CMA pool. I can add a kernel command line option for
> > it, but such solution also will not solve all the cases (afair there
> > was a discussion about kernel command line parameters for memory
> > configuration and the conclusion was that it should be avoided).
> 
> The command line option can be a last resort if the heuristics fail,
> but it's not much better than a fixed Kconfig setting.
> 
> How about a Kconfig option that defines the percentage of memory
> to set aside for contiguous allocations?

There can be probably both types of Kconfig entries: for absolute value
and the percentage of the total memory, but still, creating a 
fully-functional multi-board kernel will be really hard.

However there is one more issue here. It is quite common that embedded
systems have memory that is not really contiguous in address space
(there are some holes that splits it into 'banks' or regions). So we
might have a system with 256MiB of memory split into 2 memory banks.
In this case the CMA pool can use only one of them (the pool must be
contiguous internally). I'm not sure if such systems might require more
memory for contiguous buffers.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


