Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41418 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751184AbZFRRbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 13:31:34 -0400
Date: Thu, 18 Jun 2009 19:31:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: S_FMT vs. S_CROP
In-Reply-To: <200906102323.43677.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0906181920380.7460@axis700.grange>
References: <49CBB13F.7090609@hni.uni-paderborn.de> <49D46D2E.5090702@hni.uni-paderborn.de>
 <Pine.LNX.4.64.0906101738140.4817@axis700.grange> <200906102323.43677.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, a couple of things have become clearer to me, some others managed to 
confuse me again:

On Wed, 10 Jun 2009, Hans Verkuil wrote:

> On Wednesday 10 June 2009 18:02:39 Guennadi Liakhovetski wrote:

[snip]

> > which I now interpret as
> >
> > S_FMT(640x480) means "scale whatever rectangle has been selected on the
> > sensor to produce an output window of 640x480" and S_CROP(2048x1536)
> > means "take a window of 2048x1536 sensor pixels from the sensor and scale
> > it to whatever output window has been or will be selected by S_FMT." This
> > contradicts M1, because you certainly can crop a larger (sensor) window.
> > Also, I now believe, that [GS]_CROP and, logically, CROPCAP operate in
> > sensor pixels and shall not depend on any scales, which contradicts (my
> > understanding of) M2.
> >
> > It now seems to be quite simple to me:
> >
> > {G,S,TRY}_FMT configure output geometry in user pixels
> > [GS]_CROP, CROPCAP configure input window in sensor pixels
> 
> Agreed.
> 
> > The thus configured input window should be mapped (scaled) into the
> > output window.
> >
> > Now, which one is correct?
> 
> Your interpretation is correct to the best of my knowledge. I think the 
> cropping API remains one of the worst explained ioctls in the spec. There 
> are some weird things you can get into when dealing with S-Video (PAL/NTSC) 
> like signals, but for sensors like this it is as you described.

It seems, my above interpretation contradicts with the following statement 
from the description of S_CROP in the spec:

<quote>
Second the driver adjusts the image size (the opposite rectangle of the 
scaling process, source or target depending on the data direction) to the 
closest size possible while maintaining the current horizontal and 
vertical scaling factor.
</quote>

I read this as "you crop according to the user request and yor new scaled 
image is a result of your new crop area and _old_ scaling factors."

Now, if you set up the crop, and preserve the scaling factors, what the 
heck does "adjusts the image size ... to the closest size possible"... 
What else adjustment freedom does one have here? Shall I be bending the 
sensor in the third dimension or what?...

And btw, the calculations and reasoning in the example in 1.11.2 I cannot 
follow at all. For example this "The present scaling factors limit 
cropping to 640 × 384" I cannot derive however hard I try. And this "the 
driver returns the cropping size 608 × 384 and adjusts the image size to 
closest possible 304 × 192" means the scaling factors are now both 2:1 as 
a result of S_CROP, and before S_CROP the horisontal scale used to be 1:1, 
so, it changed, which again contradicts (IMHO) S_CROP definition above.

HEEEEELP!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
