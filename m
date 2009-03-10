Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33563 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753413AbZCJJf1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 05:35:27 -0400
Date: Tue, 10 Mar 2009 10:35:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: robert.jarzmik@free.fr
cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] pxa_camera: Redesign DMA handling
In-Reply-To: <1871633271.2933441236676310985.JavaMail.root@zimbra20-e3.priv.proxad.net>
Message-ID: <Pine.LNX.4.64.0903101019020.4733@axis700.grange>
References: <1871633271.2933441236676310985.JavaMail.root@zimbra20-e3.priv.proxad.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Mar 2009, robert.jarzmik@free.fr wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> >Now, this is the trick: we use a dummy descriptor (actually, the one from 
> >the new video buffer, but it doesn't matter) to set up a descriptor to 
>                                         \
>                                          -> that doesn't seem right to me
> 
> Have a look at the schema I drew. The DMA restarts at the dummy descriptor,
> which finishes the "partial" page transfer interrupted, and resumes at 
> "first vb". OK, let's assume this works perfectly. Then the buffer 
> "first vb", "second vb", "third vb" are processed. But the DMA chain doesn't
>  stop, it continues to the "dummy" descritor, then jumps back in the middle
> of "first vb", and corrupts it, doesn't it ?
> 
> Now consider the "first vb" was unqueued _and_ requeued in the meantime, while
> the "new buffer" was under DMA active filling.
> Won't we finish with something like :
> 
> +-----------------------+  +------------------+
> | Former New vb | dummy |  | First vb | dummy |
> +-------^-----------|---+  +----^-----+---|---+
>         |           |           |         |
>         |           +-----------+         |
>         |            former link          |
>         |                                 |
>         |                                 |
>         +---------------------------------+
>                   new restarter link

No. remember, the last _valid_ descriptor contains the DDADR_STOP as the 
next descriptor address, so, it'll stop there.

> > Now we restart DMA at our "dummy" descriptor. Actually, it is not dummy 
> > any more, it is "linking," "partial," or whatever you call it.
> OK. That's good, now I understand it. I will try to reproduce your DMA link
> architecture, because as it is, I don't yet understand why capture_example
> fails ...
> 
> Would you mind if I changed the pxa descriptors chain for _one_ video buffer into :
>  +-----------+------------+------------+-----+---------------+-----------------+
>  | restarter | desc-sg[0] | desc-sg[1] | ... | desc-sg[last] | finisher/linker |
>  +-----------+------------+------------+-----+---------------+-----------------+
> where :
>  - desc-sg[n] are descriptors to fill in the image
>  - finisher/linker is either the DMA STOP, or just a 0 bytes transfer with next 
>    descriptor set up to the desc-sg[0] of the next captured frame
>  - restarter is never used (ie. DMA chains start always at desc-sg[0]), excepting
>    when restarting a running chain
> 
> I know I ask for 1 additionnal descriptor, but I find that easier to maintain.
> Would you agree for such a change ?

1 Additional descriptor is not a big problem per se, they are only a few 
bytes big, the question is only if this really improves anything. I have 
taken over the current solution as the "only working" from original 
sources, probably, going back to Intel. As you understand, this is quite 
critical code, and we shouldn't break it. So, unless there are real good 
reasons to change it, I would try to leave it as is. If we found a way to 
improve the procedure, e.g., to avoid having to stop DMA when queuing a 
new buffer, that would be great! But so far I do not see a way to do this 
in a race-free way. Maybe we could do something like

1. prepare the new descriptor-chain.
2. with one instruction append it to the current tail by just rewriting 
   the tail's next descriptor pointer, which was equal to DDADR_STOP
3. verify if it worked, i.e., if DMA is still before the merge-point or 
   already after it.
4. fast path - in most cases we would succeed, so, we are done, just 
   update all our software states. If we failed, and DMA stopped before we 
   have overwritten the pointer, re-start DMA from the beginning of our 
   new buffer, which should be fast and race-free.

I think, actually, this might work. We only have to think carefully about 
3 - how do we reliably verify the DMA status?

What do you think?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
