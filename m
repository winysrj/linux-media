Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:38111 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755306Ab0H0TQH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 15:16:07 -0400
Date: Fri, 27 Aug 2010 21:16:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: lawrence rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH/RFC] V4L2: add a generic function to find the nearest
 discrete format
In-Reply-To: <201008071655.13146.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1008272110000.28043@axis700.grange>
References: <Pine.LNX.4.64.1008051959330.26127@axis700.grange>
 <1281174446.1363.104.camel@gagarin> <Pine.LNX.4.64.1008071512470.3798@axis700.grange>
 <201008071655.13146.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Sat, 7 Aug 2010, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Saturday 07 August 2010 15:20:58 Guennadi Liakhovetski wrote:
> > On Sat, 7 Aug 2010, lawrence rust wrote:
> 
> [snip]
> 
> > > A mean squared error metric such as hypot() could be better but requires
> > > FP.  An integer only version wouldn't be too difficult.
> > 
> > No FP in the kernel. And I don't think this simple task justifies any
> > numerical acrobatic. But we can just compare x^2 + y^2 - without an sqrt.
> > Is it worth it?
> 
> What about comparing areas ? The uvcvideo driver does (rw and rh are the 
> request width and request height, format is a structure containing an array of 
> supported sizes)
> 
>         /* Find the closest image size. The distance between image sizes is
>          * the size in pixels of the non-overlapping regions between the
>          * requested size and the frame-specified size.
>          */

Well, nice, but, tbh, I have no idea what's better. With your metric 
640x489 is further from 640x480 than 650x480, with my it's the other way 
round. Which one is better? What we can do, if this really is important, 
we could make a callback for user-provided metric function... Shall we?

Thanks
Guennadi

>         rw = fmt->fmt.pix.width;
>         rh = fmt->fmt.pix.height;
>         maxd = (unsigned int)-1;
> 
>         for (i = 0; i < format->nframes; ++i) {
>                 __u16 w = format->frame[i].wWidth;
>                 __u16 h = format->frame[i].wHeight;
> 
>                 d = min(w, rw) * min(h, rh);
>                 d = w*h + rw*rh - 2*d;
>                 if (d < maxd) {
>                         maxd = d;
>                         frame = &format->frame[i];
>                 }
> 
>                 if (maxd == 0)
>                         break;
>         }
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
