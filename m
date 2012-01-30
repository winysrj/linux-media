Return-path: <linux-media-owner@vger.kernel.org>
Received: from gir.skynet.ie ([193.1.99.77]:36570 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab2A3LYc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 06:24:32 -0500
Date: Mon, 30 Jan 2012 11:24:28 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	Michal Nazarewicz <mina86@mina86.com>,
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
Subject: Re: [PATCH 03/15] mm: compaction: introduce
 isolate_migratepages_range().
Message-ID: <20120130112428.GF25268@csn.ul.ie>
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-4-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1327568457-27734-4-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 26, 2012 at 10:00:45AM +0100, Marek Szyprowski wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
> 
> This commit introduces isolate_migratepages_range() function which
> extracts functionality from isolate_migratepages() so that it can be
> used on arbitrary PFN ranges.
> 
> isolate_migratepages() function is implemented as a simple wrapper
> around isolate_migratepages_range().
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Super, this is much easier to read. I have just one nit below but once
that is fixed;

Acked-by: Mel Gorman <mel@csn.ul.ie>

> @@ -313,7 +316,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
>  		} else if (!locked)
>  			spin_lock_irq(&zone->lru_lock);
>  
> -		if (!pfn_valid_within(low_pfn))
> +		if (!pfn_valid(low_pfn))
>  			continue;
>  		nr_scanned++;
>  

This chunk looks unrelated to the rest of the patch.

I think what you are doing is patching around a bug that CMA exposed
which is very similar to the bug report at
http://www.spinics.net/lists/linux-mm/msg29260.html . Is this true?

If so, I posted a fix that only calls pfn_valid() when necessary. Can
you check if that works for you and if so, drop this hunk please? If
the patch does not work for you, then this hunk still needs to be
in a separate patch and handled separately as it would also be a fix
for -stable.

-- 
Mel Gorman
SUSE Labs
