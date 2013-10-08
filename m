Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([78.24.191.182]:59483 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab3JHMHd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Oct 2013 08:07:33 -0400
Received: from localhost.localdomain ([127.0.0.1]:39055 "EHLO linux-mips.org"
        rhost-flags-OK-OK-OK-FAIL) by eddie.linux-mips.org with ESMTP
        id S6868557Ab3JHMHcDQcLA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Oct 2013 14:07:32 +0200
Date: Tue, 8 Oct 2013 14:07:27 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-mips@linux-mips.org, linux-media@vger.kernel.org
Subject: Re: Suspected cache coherency problem on V4L2 and AR7100 CPU
Message-ID: <20131008120727.GH1615@linux-mips.org>
References: <m3eh82a1yo.fsf@t19.piap.pl>
 <m361t9a31i.fsf@t19.piap.pl>
 <20131007142429.GG3098@linux-mips.org>
 <m3li24891u.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3li24891u.fsf@t19.piap.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 08, 2013 at 10:24:13AM +0200, Krzysztof Hałasa wrote:

> > That's fine.  You just need to ensure that there are no virtual
> > aliases.
> 
> Does this include virtual aliasing between a 4 KB TLB-mapped page and
> a kseg0 address? I don't really have two TLBs pointing to the same page.

Yes.

Note that the terminology used in the manuals may be confusing here.
They call KSEG0/1 and - on 64 bit - XKPHYS "unmapped spaces".  But
obviously there is a mapping from virtual to physical addresses.  It's
just that there is no TLB entry being used for these mappings.

It's easier to understand if you see that all memory accesses are going
through the cache, TLB mapped or not.

> > One way to do so is to increase the page size to 16kB.
> 
> Right, this way we will have a unique mapping from the virtual address
> to the data cache, as the cache size (per way) is 8 KB here. Is it the
> correct fix in this situation?

16K is a silver bullet solution to all cache aliasing problems.  So if
your issue persists with 16K page size, it's not a cache aliasing issue.
Aside there are generally performance gains from the bigger page size.

> > Note that there is a variant of the 24K which has a VIPT cache but uses
> > hardware to resolve cache aliases.  That is, from a kernel cache management
> > perspective it behaves like a PIPT cache.
> 
> It seems it's not the case here. What I have here is:
> CPU revision is: 00019374 (MIPS 24Kc)
> SoC: Atheros AR7161 rev 2
> Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
> Primary data cache 32kB, 4-way, VIPT, cache aliases, linesize 32 bytes

Yes; it would print "PIPT" if the cache was aliasing-free.

> > However as I understand what you're mapping to userspace is actually
> > device memory, right?
> 
> Not exactly - I'm using PCI DMA to userspace SG buffers in RAM.
> 
> The userspace first allocates the buffers in normal RAM (with vmalloc()
> or something, there is an mmap ioctl() for this), the address returned
> is 0x7xxxxxxx. Then the buffers (which consist of several pages each)
> are presented to the hw driver which obtains separate (kernel) mapping
> for each page (kseg0) and does dma_map_sg() and so on. The driver also
> simply writes to the buffers. This isn't a problem, though - only the
> incoherence between TLB and kseg0 is.

Now that very much sounds like an aliasing issue!

> The problem is the userspace doesn't see the kernel writes - The
> 0x7xxxxxxx TLB-mapped pages are read-cached and not invalidated while
> the kernel writes to the same pages using kseg0 addresses.
> 
> Thanks for looking at this.

You're welcome.

I'm just wondering the underlying issue might be a generic problem.

  Ralf
