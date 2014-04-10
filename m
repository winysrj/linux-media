Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934795AbaDJKcY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 06:32:24 -0400
Date: Thu, 10 Apr 2014 12:32:20 +0200
From: Jan Kara <jack@suse.cz>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	linux-media@vger.kernel.org,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	'Tomasz Stanislawski' <t.stanislaws@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Helper to abstract vma handling in media layer
Message-ID: <20140410103220.GB28404@quack.suse.cz>
References: <1395085776-8626-1-git-send-email-jack@suse.cz>
 <53466C4A.2030107@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53466C4A.2030107@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hello,

On Thu 10-04-14 12:02:50, Marek Szyprowski wrote:
> On 2014-03-17 20:49, Jan Kara wrote:
> >   The following patch series is my first stab at abstracting vma handling
> >from the various media drivers. After this patch set drivers have to know
> >much less details about vmas, their types, and locking. My motivation for
> >the series is that I want to change get_user_pages() locking and I want
> >to handle subtle locking details in as few places as possible.
> >
> >The core of the series is the new helper get_vaddr_pfns() which is given a
> >virtual address and it fills in PFNs into provided array. If PFNs correspond to
> >normal pages it also grabs references to these pages. The difference from
> >get_user_pages() is that this function can also deal with pfnmap, mixed, and io
> >mappings which is what the media drivers need.
> >
> >The patches are just compile tested (since I don't have any of the hardware
> >I'm afraid I won't be able to do any more testing anyway) so please handle
> >with care. I'm grateful for any comments.
> 
> Thanks for posting this series! I will check if it works with our
> hardware soon.  This is something I wanted to introduce some time ago to
> simplify buffer handling in dma-buf, but I had no time to start working.
  Thanks for having a look in the series.

> However I would like to go even further with integration of your pfn
> vector idea.  This structure looks like a best solution for a compact
> representation of the memory buffer, which should be considered by the
> hardware as contiguous (either contiguous in physical memory or mapped
> contiguously into dma address space by the respective iommu). As you
> already noticed it is widely used by graphics and video drivers.
> 
> I would also like to add support for pfn vector directly to the
> dma-mapping subsystem. This can be done quite easily (even with a
> fallback for architectures which don't provide method for it). I will try
> to prepare rfc soon.  This will finally remove the need for hacks in
> media/v4l2-core/videobuf2-dma-contig.c
  That would be a worthwhile thing to do. When I was reading the code this
seemed like something which could be done but I delibrately avoided doing
more unification than necessary for my purposes as I don't have any
hardware to test and don't know all the subtleties in the code... BTW, is
there some way to test the drivers without the physical video HW?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
