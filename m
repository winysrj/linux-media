Return-path: <mchehab@localhost>
Received: from perceval.irobotique.be ([92.243.18.41]:56138 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab0HaVT0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Aug 2010 17:19:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC] V4L2: add a generic function to find the nearest discrete format
Date: Tue, 31 Aug 2010 23:19:24 +0200
Cc: lawrence rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1008051959330.26127@axis700.grange> <201008071655.13146.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1008272110000.28043@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1008272110000.28043@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008312319.25169.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi Guennadi,

On Friday 27 August 2010 21:16:26 Guennadi Liakhovetski wrote:
> On Sat, 7 Aug 2010, Laurent Pinchart wrote:
> > On Saturday 07 August 2010 15:20:58 Guennadi Liakhovetski wrote:
> > > On Sat, 7 Aug 2010, lawrence rust wrote:
> > [snip]
> > 
> > > > A mean squared error metric such as hypot() could be better but
> > > > requires FP.  An integer only version wouldn't be too difficult.
> > > 
> > > No FP in the kernel. And I don't think this simple task justifies any
> > > numerical acrobatic. But we can just compare x^2 + y^2 - without an
> > > sqrt. Is it worth it?
> > 
> > What about comparing areas ? The uvcvideo driver does (rw and rh are the
> > request width and request height, format is a structure containing an
> > array of supported sizes)
> > 
> >         /* Find the closest image size. The distance between image sizes
> >         is
> >         
> >          * the size in pixels of the non-overlapping regions between the
> >          * requested size and the frame-specified size.
> >          */
> 
> Well, nice, but, tbh, I have no idea what's better. With your metric
> 640x489 is further from 640x480 than 650x480, with my it's the other way
> round. Which one is better?

Mine of course ;-) It's a good question... Your method minimizes the 
width/height cumulative difference while mine minimizes the area difference. 
What's better ? Or maybe the right question is does it matter ?

> What we can do, if this really is important, we could make a callback for
> user-provided metric function... Shall we?

That sounds too complex for such a simple problem.

-- 
Regards,

Laurent Pinchart
