Return-path: <linux-media-owner@vger.kernel.org>
Received: from cmpxchg.org ([85.214.51.133]:33651 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761086AbZEASPM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2009 14:15:12 -0400
Date: Fri, 1 May 2009 20:14:49 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	linux-mm@kvack.org, lethal@linux-sh.org
Subject: Re: [PATCH] videobuf-dma-contig: zero copy USERPTR support V2
Message-ID: <20090501181449.GA8912@cmpxchg.org>
References: <20090428090129.17081.782.sendpatchset@rx1.opensource.se> <aec7e5c30904302026q42ecbd57m6e88c937bbd262bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec7e5c30904302026q42ecbd57m6e88c937bbd262bb@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 01, 2009 at 12:26:38PM +0900, Magnus Damm wrote:
> On Tue, Apr 28, 2009 at 6:01 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> > This is V2 of the V4L2 videobuf-dma-contig USERPTR zero copy patch.
> 
> I guess the V4L2 specific bits are pretty simple.
> 
> As for the minor mm modifications below,
> 
> > --- 0001/mm/memory.c
> > +++ work/mm/memory.c    2009-04-28 14:56:43.000000000 +0900
> > @@ -3009,7 +3009,6 @@ int in_gate_area_no_task(unsigned long a
> >
> >  #endif /* __HAVE_ARCH_GATE_AREA */
> >
> > -#ifdef CONFIG_HAVE_IOREMAP_PROT
> >  int follow_phys(struct vm_area_struct *vma,
> >                unsigned long address, unsigned int flags,
> >                unsigned long *prot, resource_size_t *phys)
> 
> Is it ok with the memory management guys to always build follow_phys()?

AFAICS, pte_pgprot is only defined on three architectures that have
the config symbol above set.  It shouldn't compile on the others.

I have a patch that factors out follow_pte and builds follow_pfn and
follow_phys on top of that.  I can send it monday, no access to it
from here right now.

Then we can keep follow_phys private to this configuration.

	Hannes
