Return-path: <mchehab@pedra>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45924 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759220Ab1CaT0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 15:26:53 -0400
Date: Thu, 31 Mar 2011 15:26:50 -0400
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
Subject: Re: [PATCH 05/12] mm: alloc_contig_range() added
Message-ID: <20110331192650.GE14441@home.goodmis.org>
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
 <1301577368-16095-6-git-send-email-m.szyprowski@samsung.com>
 <1301587361.31087.1040.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301587361.31087.1040.camel@nimitz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 31, 2011 at 09:02:41AM -0700, Dave Hansen wrote:
> On Thu, 2011-03-31 at 15:16 +0200, Marek Szyprowski wrote:
> > +       ret = 0;
> > +       while (!PageBuddy(pfn_to_page(start & (~0UL << ret))))
> > +               if (WARN_ON(++ret >= MAX_ORDER))
> > +                       return -EINVAL; 
> 
> Holy cow, that's dense.  Is there really no more straightforward way to
> do that?
> 
> In any case, please pull the ++ret bit out of the WARN_ON().  Some
> people like to do:
> 
> #define WARN_ON(...) do{}while(0)
> 
> to save space on some systems.  

That should be fixed, as the if (WARN_ON()) has become a standard in
most of the kernel. Removing WARN_ON() should be:

#define WARN_ON(x) ({0;})

But I agree, that there should be no "side effects" inside a WARN_ON(),
which that "++ret" is definitely one.

-- Steve

