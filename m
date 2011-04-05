Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:21028 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1DEHYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:24:47 -0400
Date: Tue, 05 Apr 2011 09:23:53 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 04/12] mm: alloc_contig_freed_pages() added
In-reply-to: <op.vte0fgez3l0zgt@mnazarewicz-glaptop>
To: 'Michal Nazarewicz' <mina86@mina86.com>,
	'Dave Hansen' <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, 'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Andrew Morton' <akpm@linux-foundation.org>,
	'KAMEZAWA Hiroyuki' <kamezawa.hiroyu@jp.fujitsu.com>,
	'Ankita Garg' <ankita@in.ibm.com>,
	'Daniel Walker' <dwalker@codeaurora.org>,
	'Johan MOSSBERG' <johan.xx.mossberg@stericsson.com>,
	'Mel Gorman' <mel@csn.ul.ie>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Message-id: <008b01cbf362$6fb52c40$4f1f84c0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: pl
Content-transfer-encoding: 8BIT
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
 <1301577368-16095-5-git-send-email-m.szyprowski@samsung.com>
 <1301587083.31087.1032.camel@nimitz> <op.vs77qfx03l0zgt@mnazarewicz-glaptop>
 <1301606078.31087.1275.camel@nimitz> <op.vs8awkrx3l0zgt@mnazarewicz-glaptop>
 <1301610411.30870.29.camel@nimitz> <op.vs8cf5xd3l0zgt@mnazarewicz-glaptop>
 <1301666596.30870.176.camel@nimitz> <op.vte0fgez3l0zgt@mnazarewicz-glaptop>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Monday, April 04, 2011 3:15 PM Michał Nazarewicz wrote:

> > What kind of success have you had running this in practice?  I'd be
> > worried that some silly task or a sticky dentry would end up in the
> > range that you want to allocate in.
> 
> I'm not sure what you are asking.
> 
> The function requires the range to be marked as MIGRATE_ISOLATE and all
> pages being free, so nothing can be allocated there while the function
> is running.
> 
> If you are asking about CMA in general, the range that CMA uses is marked
> as MIGRATE_CMA (a new migrate type) which means that only MIGRATE_MOVABLE
> pages can be allocated there.  This means, that in theory, if there is
> enough memory the pages can always be moved out of the region.  At leasts
> that's my understanding of the type.  If this is correct, the allocation
> should always succeed provided enough memory for the pages within the
> region to be moved to is available.
> 
> As of practice, I have run some simple test to see if the code works and
> they succeeded.  Also, Marek has run some test with actual hardware and
> those worked well as well (but I'll let Marek talk about any details).

We did the tests with real multimedia drivers - video codec and video
converter (s5p-mfc and s5p-fimc). These drivers allocate large contiguous 
buffers for video data. The allocation is performed when driver is opened
by user space application. 

First we consumed system memory by running a set of simple applications
that just did some malloc() and filled memory with random pattern to consume
free pages. Then some of that memory has been freed and we ran the video
decoding application. Multimedia drivers successfully managed to allocate
required contiguous buffers from MIGRATE_CMA ranges.

The tests have been performed with different system usage patterns (malloc(),
heavy filesystem load, anonymous memory mapping). In all these cases CMA
worked surprisingly good allowing the drivers to allocate the required 
contiguous buffers.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


