Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:34469 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750893Ab1DUJrt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 05:47:49 -0400
Date: Thu, 21 Apr 2011 11:47:43 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-media@vger.kernel.org, dhowells@redhat.com,
	linux-uvc-devel@lists.berlios.de, mchehab@redhat.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, martin_rubli@logitech.com,
	jarod@redhat.com, tj@kernel.org, arnd@arndb.de, fweisbec@gmail.com,
	agust@denx.de, gregkh@suse.de, vapier@gentoo.org
Subject: Re: [PATCH v3] media:uvc_driver: add uvc support on no-mmu arch
Message-ID: <20110421094743.GA8503@minime.bse>
References: <1303355862-17507-1-git-send-email-lliubbo@gmail.com>
 <20110421075947.GA8178@minime.bse>
 <BANLkTimHX8aYoeSU1ES0Tw0Swaz9xYLt=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimHX8aYoeSU1ES0Tw0Swaz9xYLt=Q@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Apr 21, 2011 at 04:20:36PM +0800, Bob Liu wrote:
> > on mmu systems do_mmap_pgoff contains a len = PAGE_ALIGN(len); line.
> > If we depend on this behavior, why not do it here as well and get rid
> > of the #ifdef?
> >
> 
> If do it in do_mmap_pgoff() the whole system will be effected, I am
> not sure whether
> it's correct and needed for other subsystem.

With "here" I was referring to uvc_queue_mmap.

> >> +     addr = (unsigned long)queue->mem + buffer->buf.m.offset;
> >> +     ret = addr;
> >
> > Why the intermediate step using addr?
> >
> 
> If don't return addr, do_mmap_pgoff() will return failure and we can't
> setup vma correctly.
> See mm/nommu.c line 1386(add = file->f_op->get_unmmapped_area() ).

I know, but why not do
	ret = (unsigned long)queue->mem + buffer->buf.m.offset;
instead?

  Daniel
