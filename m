Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51104 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754359AbZCKMWP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 08:22:15 -0400
Date: Wed, 11 Mar 2009 13:22:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: ospite@studenti.unina.it, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: Redesign DMA handling
In-Reply-To: <87bpsh2m5v.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0903111318510.4818@axis700.grange>
References: <1236021422-8074-1-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0903030929160.5059@axis700.grange> <87bpsh2m5v.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Wed, 4 Mar 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > (moved to the new v4l list)
> >
> >> The DMA transfers in pxa_camera showed some weaknesses in
> >> multiple queued buffers context :
> >>  - poll/select problem
> >>    The order between list pcdev->capture and DMA chain was
> >>    not the same. This creates a discrepancy between video
> >>    buffers marked as "done" by the IRQ handler, and the
> >>    really finished video buffer.
> >
> > Could you please describe where and how the order could get wrong?

Now after I've explained to you how the present DMA-chaining works, do you 
still think the order can be swapped? If so, I need a new explanation:-)

> Sorry, I missed that point in the previous reply.
> 
> It's still the same bit of code :
> -                       } else {
> -                               buf_dma->sg_cpu[nents].ddadr =
> -                                       DDADR(pcdev->dma_chans[i]);
> 
> That chains the end of the queued buffer to the active buffer

because, as we now know, this doesn't hold - we just use one (last) dummy 
descriptor from the new buffer to append it to the current sg_tail, which 
seems correct to me.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
