Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44466 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751841AbZCEWPE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 17:15:04 -0500
Date: Thu, 5 Mar 2009 23:15:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
In-Reply-To: <Pine.LNX.4.58.0903051317010.24268@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.64.0903052312310.4980@axis700.grange>
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0903052119590.4980@axis700.grange> <873adrekwj.fsf@free.fr>
 <Pine.LNX.4.58.0903051317010.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Trent Piepho wrote:

> On Thu, 5 Mar 2009, Robert Jarzmik wrote:
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> >
> > > This is not a review yet - just an explanation why I was suggesting to
> > > adjust height and width - you say yourself, that YUV422P (I think, this is
> > > wat you meant, not just YUV422) requires planes to immediately follow one
> > > another. But you have to align them on 8 byte boundary for DMA, so, you
> > > violate the standard, right? If so, I would rather suggest to adjust width
> > > and height for planar formats to comply to the standard. Or have I
> > > misunderstood you?
> > No, you understand perfectly.
> >
> > And now, what do we do :
> >  - adjust height ?
> >  - adjust height ?
> >  - adjust both ?
> >
> > I couldn't decide which one, any hint ?
> 
> Shame the planes have to be contiguous.  Software like ffmpeg doesn't
> require this and could handle planes with gaps between them without
> trouble.  Plans aligned on 8 bytes boundaries would probably be faster in
> fact.  Be better if v4l2_buffer gave us offsets for each plane.
> 
> If you must adjust, probably better to adjust both.

Yes, adjusting both is also what I was suggesting in my original review. 
How about aligning the bigger of the two to 4 bytes and the smaller to 2? 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
