Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41389 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753474AbcKYQCX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 11:02:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: wharms@bfs.de
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Sakari Alius <sakari.ailus@iki.fi>
Subject: Re: [patch] [media] uvcvideo: freeing an error pointer
Date: Fri, 25 Nov 2016 18:02:45 +0200
Message-ID: <11316049.HORSOXRmDr@avalon>
In-Reply-To: <58384F15.4040207@bfs.de>
References: <20161125102835.GA5856@mwanda> <2064794.XNX8XhaLMu@avalon> <58384F15.4040207@bfs.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Walter,

On Friday 25 Nov 2016 15:47:49 walter harms wrote:
> Am 25.11.2016 14:57, schrieb Laurent Pinchart:
> > On Friday 25 Nov 2016 13:28:35 Dan Carpenter wrote:
> >> A recent cleanup introduced a potential dereference of -EFAULT when we
> >> call kfree(map->menu_info).
> > 
> > I should have caught that, my apologies :-(
> > 
> > Thinking a bit more about this class of problems, would the following
> > patch make sense ?
> > 
> > commit 034b71306510643f9f059249a0c14418099eb436
> > Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Date:   Fri Nov 25 15:54:22 2016 +0200
> > 
> >     mm/slab: WARN_ON error pointers passed to kfree()
> >     
> >     Passing an error pointer to kfree() is invalid and can lead to crashes
> >     or memory corruption. Reject those pointers and WARN in order to catch
> >     the problems and fix them in the callers.
> >     
> >     Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > diff --git a/mm/slab.c b/mm/slab.c
> > index 0b0550ca85b4..a7eb830c6684 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -3819,6 +3819,8 @@ void kfree(const void *objp)
> >  	if (unlikely(ZERO_OR_NULL_PTR(objp)))
> >  		return;
> > 
> > +	if (WARN_ON(IS_ERR(objp)))
> > +		return;
> >  	local_irq_save(flags);
> >  	kfree_debugcheck(objp);
> >  	c = virt_to_cache(objp);
> 
> I this is better in kfree_debugcheck().
> 1. it has the right name
> 2. is contains already a check

Sakari Ailus (CC'ed) has expressed the opinion that we might want to go one 
step further and treat error pointers the same way we treat NULL or ZERO 
pointers today, by just returning without logging anything. The reasoning is 
that accepting a NULL pointer in kfree() was decided before we made extensive 
use of allocation APIs returning error pointers, so it could be time to update 
kfree() based on the current allocation usage patterns.

> static void kfree_debugcheck(const void *objp)
>  {
>          if (!virt_addr_valid(objp)) {
>                  pr_err("kfree_debugcheck: out of range ptr %lxh\n",
>                         (unsigned long)objp);
>                  BUG();
>          }
>   }
> 
> btw: should this read %p ?

-- 
Regards,

Laurent Pinchart

