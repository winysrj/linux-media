Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:17530 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbZIAQyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2009 12:54:24 -0400
Date: Tue, 1 Sep 2009 17:53:48 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steven Walter <stevenrwalter@gmail.com>,
	David Xiao <dxiao@broadcom.com>,
	Ben Dooks <ben-linux@fluff.org>, Robin Holt <holt@sgi.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
 get_user_pages() enough to prevent pages from being swapped out ?")
In-Reply-To: <20090901141812.GT19719@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0909011747080.5078@sister.anvils>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
 <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com>
 <20090901132824.GN19719@n2100.arm.linux.org.uk>
 <200909011543.48439.laurent.pinchart@ideasonboard.com>
 <20090901141812.GT19719@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 1 Sep 2009, Russell King - ARM Linux wrote:
> On Tue, Sep 01, 2009 at 03:43:48PM +0200, Laurent Pinchart wrote:
> > I might be missing something obvious, but I fail to see how VIVT caches
> > could work at all with multiple mappings. If a kernel-allocated buffer
> > is DMA'ed to, we certainly want to invalidate all cache lines that store
> > buffer data. As the cache doesn't care about physical addresses we thus
> > need to invalidate all virtual mappings for the buffer. If the buffer is
> > mmap'ed in userspace I don't see how that would be done.
> 
> You need to ask MM gurus about that.  I don't touch the Linux MM very
> often so tend to keep forgetting how it works.  However, it does work
> for shared mappings of files on CPUs with VIVT caches.

I believe arch/arm/mm/flush.c __flush_dcache_aliases() is what does it.

Hugh
