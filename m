Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46867 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZG2PkR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 11:40:17 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Is get_user_pages() enough to prevent pages from being swapped out ?
Date: Wed, 29 Jul 2009 17:41:52 +0200
Cc: linux-kernel@vger.kernel.org,
	"v4l2_linux" <linux-media@vger.kernel.org>
References: <200907291123.12811.laurent.pinchart@skynet.be> <Pine.LNX.4.64.0907291551050.16769@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0907291551050.16769@sister.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907291741.52783.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugh,

first of all, thanks for your answer.

On Wednesday 29 July 2009 17:26:11 Hugh Dickins wrote:
> On Wed, 29 Jul 2009, Laurent Pinchart wrote:
> > I'm trying to debug a video acquisition device driver and found myself
> > having to dive deep into the memory management subsystem.
> >
> > The driver uses videobuf-dma-sg to manage video buffers. videobuf-dma-sg
> > gets pointers to buffers from userspace and calls get_user_pages() to
> > retrieve the list of pages underlying those buffers. The page list is
> > used to build a scatter-gather list that is given to the hardware. The
> > device then performs DMA directly to the memory.
> >
> > Pages underlying the buffers must obviously not be swapped out during
> > DMA. The get_user_pages() (mm/memory.c) documentation seems to imply that
> > returned pages are pinned to memory (my understanding of "pinned" is that
> > they will not be swapped out):
>
> ...
>
> > However, all is seems to do for that purpose is incrementing the page
> > reference count using get_page().
> >
> > I had a look through the memory management subsystem code and it seems to
> > me that incrementing the reference count is not sufficient to make sure
> > the page won't be swapped out. To ensure that, it should instead be
> > marked as unevictable, either directly or by marking an associated VMA as
> > VM_LOCKED. This is what the mlock() syscall does, in addition to calling
> > get_user_pages().
> >
> > The MM subsystem is quite complex and my understanding might not be
> > correct, so I'd appreciate if someone could shed light on the issue. Does
> > get_user_pages() really pin pages to memory and prevent them from being
> > swapped out in all circumstances ? If so, how does it do so ? If not,
> > what's the proper way to make sure the pages won't disappear during DMA ?
>
> You're right that get_user_pages() (called with a pagelist as you're
> using) increments the page reference count.
>
> And that is enough to pin the page in memory, in a sense that suits
> the use of DMA.
>
> I'm expressing it in that peculiar way, because:- On the one hand,
> the page can only disappear from memory by memory hotremove, but
> what you'll be worrying about is the page getting freed and reused
> for another purpose while DMA is acting upon it - but raising the
> reference count prevents that (and will prevent hotremove succeeding).

Sorry about that confusion. I'm not too familiar with memory management so I 
mixed the proper terms.

> On the other hand, despite the raised reference count, under memory
> pressure that page might get unmapped from the user pagetable, and
> might even be written out to swap in its half-dirty state (though
> is_page_cache_freeable() tries to avoid that); but it won't get
> freed, and DMA will be to the physical address of the page (somebody
> will correct me that it's actually the bus address or something else),
> not to the userspace virtual address.  So it's irrelevant if that
> vanishes for a while - when userspace accesses it again, the same
> page (the one DMA occurs to) will be faulted back in there.

Just to make sure I understand things properly, the copy of the page written 
to swap will not be read back when the page is faulted back in by the kernel 
as a result of the userspace process accessing it, right ?

Why would the page be written out to swap if it's not going to be freed anyway 
?

> In contrast, mlock() is not enough to pin a page in memory in this
> sense: from a userspace point of view, an mlock()ed page indeed is
> locked into memory, but page migration (for NUMA balancing or for
> memory hotremove) is still free to substitute an alternative page
> there.  get_user_pages()'s raised reference count prevents that,
> but mlock() does not.

Thanks for pointing that "detail" out.

> There is one little problem with the get_user_pages() pinning,
> hopefully one that can never affect you at all.  If the task that
> did the get_user_pages() forks, and parent or child userspace tries
> to write to one of the pages in question while it's pinned (and it's
> an anonymous page, not a pagecache page shared with underlying file),
> then the first to touch it will get a copy of the original DMA page
> at that instant, thereafter losing contact with the original DMA page.
>
> One answer to that is to madvise such an area with MADV_DONTFORK,
> then fork won't duplicate that area, so no Copy-on-Write issues
> will arise.  That satisfies many of us, but others look for a
> way to eliminate this issue completely.

I don't think the userspace processes we use here to access the video buffers 
fork, but I'll double check that and use madvise in that case.

Thank you very much for your help.

Best regards,

Laurent Pinchart

