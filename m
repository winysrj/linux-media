Return-path: <linux-media-owner@vger.kernel.org>
Received: from cmpxchg.org ([85.214.51.133]:56493 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbZEEVXi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2009 17:23:38 -0400
Date: Tue, 5 May 2009 23:21:39 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: magnus.damm@gmail.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, lethal@linux-sh.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: introduce follow_pte()
Message-ID: <20090505212139.GA2559@cmpxchg.org>
References: <20090501181449.GA8912@cmpxchg.org> <1241430874-12667-1-git-send-email-hannes@cmpxchg.org> <20090505122442.6271c7da.akpm@linux-foundation.org> <20090505203807.GB2428@cmpxchg.org> <20090505140517.bef78dd3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505140517.bef78dd3.akpm@linux-foundation.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 05, 2009 at 02:05:17PM -0700, Andrew Morton wrote:
> On Tue, 5 May 2009 22:38:07 +0200
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > On Tue, May 05, 2009 at 12:24:42PM -0700, Andrew Morton wrote:
> > > On Mon,  4 May 2009 11:54:32 +0200
> > > Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > 
> > > > A generic readonly page table lookup helper to map an address space
> > > > and an address from it to a pte.
> > > 
> > > umm, OK.
> > > 
> > > Is there actually some point to these three patches?  If so, what is it?
> > 
> > Magnus needs to check for physical contiguity of a VMAs backing pages
> > to support zero-copy exportation of video data to userspace.
> > 
> > This series implements follow_pfn() so he can walk the VMA backing
> > pages and ensure their PFNs are in linear order.
> > 
> > [ This patch can be collapsed with 2/3, I just thought it would be
> >   easier to read the diffs when having them separate. ]
> > 
> > 1/3 and 2/3: factor out the page table walk from follow_phys() into
> > follow_pte().
> > 
> > 3/3: implement follow_pfn() on top of follow_pte().
> 
> So we could bundle these patches with Magnus's patchset, or we could
> consider these three patches as a cleanup or something.
>
> Given that 3/3 introduces an unused function, I'm inclined to sit tight
> and await Magnus's work.

Yeah, I didn't see the video guys responding on Magnus' patch yet, so
let's wait for them.

Magnus, the actual conversion of your code should be trivial, could
you respin it on top of these three patches using follow_pfn() then?

	Thanks, Hannes
