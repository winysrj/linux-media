Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:40908 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbZG2QH3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 12:07:29 -0400
Date: Wed, 29 Jul 2009 17:07:24 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
cc: linux-kernel@vger.kernel.org,
	v4l2_linux <linux-media@vger.kernel.org>
Subject: Re: Is get_user_pages() enough to prevent pages from being swapped
 out ?
In-Reply-To: <200907291741.52783.laurent.pinchart@skynet.be>
Message-ID: <Pine.LNX.4.64.0907291653510.20238@sister.anvils>
References: <200907291123.12811.laurent.pinchart@skynet.be>
 <Pine.LNX.4.64.0907291551050.16769@sister.anvils> <200907291741.52783.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 29 Jul 2009, Laurent Pinchart wrote:
> On Wednesday 29 July 2009 17:26:11 Hugh Dickins wrote:
> > On Wed, 29 Jul 2009, Laurent Pinchart wrote:
> > > what's the proper way to make sure the pages won't disappear during DMA ?
> >
> > You're right that get_user_pages() (called with a pagelist as you're
> > using) increments the page reference count.
> >
> > And that is enough to pin the page in memory, in a sense that suits
> > the use of DMA.
> >
> > I'm expressing it in that peculiar way, because:- On the one hand,
> > the page can only disappear from memory by memory hotremove, but
> > what you'll be worrying about is the page getting freed and reused
> > for another purpose while DMA is acting upon it - but raising the
> > reference count prevents that (and will prevent hotremove succeeding).
> 
> Sorry about that confusion. I'm not too familiar with memory management so I 
> mixed the proper terms.

Nothing to apologize for!  You expressed yourself in a vivid and
natural way, then I gave you a pedantic response.  It's right to be
pedantic here, to distinguish these cases, but you were not wrong.

> 
> > On the other hand, despite the raised reference count, under memory
> > pressure that page might get unmapped from the user pagetable, and
> > might even be written out to swap in its half-dirty state (though
> > is_page_cache_freeable() tries to avoid that); but it won't get
> > freed, and DMA will be to the physical address of the page (somebody
> > will correct me that it's actually the bus address or something else),
> > not to the userspace virtual address.  So it's irrelevant if that
> > vanishes for a while - when userspace accesses it again, the same
> > page (the one DMA occurs to) will be faulted back in there.
> 
> Just to make sure I understand things properly, the copy of the page written 
> to swap will not be read back when the page is faulted back in by the kernel 
> as a result of the userspace process accessing it, right ?

Absolutely right.  It's a waste of time and diskspace if we write
it at all, but to avoid the possibility of such writes completely
would involve a locking overhead we're better off without.

> 
> Why would the page be written out to swap if it's not going to be
> freed anyway ?

is_page_cache_freeable() tries to avoid such a write, by checking
that the reference count is what we'd expect it to be if nobody else
is interested in the page - at that instant.  But an instant later,
anything might take a new reference to the page: pageout() has the
page lock, but we really don't want to demand that everybody else
has to acquire the page lock just to increment page count.

We could scatter further is_page_cache_freeable() checks around;
but how ever many we added, it could always go up just after the
last check.

Hugh
