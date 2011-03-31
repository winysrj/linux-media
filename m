Return-path: <mchehab@pedra>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000Ab1CaTYe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 15:24:34 -0400
Date: Thu, 31 Mar 2011 15:24:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, Michal Nazarewicz <mina86@mina86.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
	Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH 04/12] mm: alloc_contig_freed_pages() added
Message-ID: <20110331192429.GD14441@home.goodmis.org>
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
 <1301577368-16095-5-git-send-email-m.szyprowski@samsung.com>
 <1301587083.31087.1032.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301587083.31087.1032.camel@nimitz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 31, 2011 at 08:58:03AM -0700, Dave Hansen wrote:
> On Thu, 2011-03-31 at 15:16 +0200, Marek Szyprowski wrote:
> > 
> > +unsigned long alloc_contig_freed_pages(unsigned long start, unsigned long end,
> > +                                      gfp_t flag)
> > +{
> > +       unsigned long pfn = start, count;
> > +       struct page *page;
> > +       struct zone *zone;
> > +       int order;
> > +
> > +       VM_BUG_ON(!pfn_valid(start));
> 
> This seems kinda mean.  Could we return an error?  I understand that
> this is largely going to be an early-boot thing, but surely trying to
> punt on crappy input beats a full-on BUG().
> 
> 	if (!pfn_valid(start))
> 		return -1;

But still keep the warning?

	if (WARN_ON(!pfn_valid(start))
		return -1;

-- Steve

