Return-path: <linux-media-owner@vger.kernel.org>
Received: from gir.skynet.ie ([193.1.99.77]:39058 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab2A3Owd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 09:52:33 -0500
Date: Mon, 30 Jan 2012 14:52:30 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shariq Hasnain <shariq.hasnain@linaro.org>,
	Chunsang Jeong <chunsang.jeong@linaro.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH 08/15] mm: mmzone: MIGRATE_CMA migration type added
Message-ID: <20120130145230.GQ25268@csn.ul.ie>
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-9-git-send-email-m.szyprowski@samsung.com>
 <20120130123542.GL25268@csn.ul.ie>
 <op.v8wepotk3l0zgt@mpn-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <op.v8wepotk3l0zgt@mpn-glaptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 30, 2012 at 02:06:50PM +0100, Michal Nazarewicz wrote:
> >>@@ -1017,11 +1049,14 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
> >> 			rmv_page_order(page);
> >>
> >> 			/* Take ownership for orders >= pageblock_order */
> >>-			if (current_order >= pageblock_order)
> >>+			if (current_order >= pageblock_order &&
> >>+			    !is_pageblock_cma(page))
> >> 				change_pageblock_range(page, current_order,
> >> 							start_migratetype);
> >>
> >>-			expand(zone, page, order, current_order, area, migratetype);
> >>+			expand(zone, page, order, current_order, area,
> >>+			       is_migrate_cma(start_migratetype)
> >>+			     ? start_migratetype : migratetype);
> >>
> >
> >What is this check meant to be doing?
> >
> >start_migratetype is determined by allocflags_to_migratetype() and
> >that never will be MIGRATE_CMA so is_migrate_cma(start_migratetype)
> >should always be false.
> 
> Right, thanks!  This should be the other way around, ie.:
> 
> +			expand(zone, page, order, current_order, area,
> +			       is_migrate_cma(migratetype)
> +			     ? migratetype : start_migratetype);
> 
> I'll fix this and the calls to is_pageblock_cma().
> 

That makes a lot more sense. Thanks.

I have a vague recollection that there was a problem with finding
unmovable pages in MIGRATE_CMA regions. This might have been part of
the problem.

-- 
Mel Gorman
SUSE Labs
