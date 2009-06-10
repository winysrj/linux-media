Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4660 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760430AbZFJVX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 17:23:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: S_FMT vs. S_CROP
Date: Wed, 10 Jun 2009 23:23:43 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <49CBB13F.7090609@hni.uni-paderborn.de> <49D46D2E.5090702@hni.uni-paderborn.de> <Pine.LNX.4.64.0906101738140.4817@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906101738140.4817@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906102323.43677.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 10 June 2009 18:02:39 Guennadi Liakhovetski wrote:
> This question - how S_FMT and S_CROP affest image geometry - has been
> discussed at least twice before - that's only with my participation,
> don't know if and how often it has come up before. But the fact, that in
> two discussions we came up with different results seems to suggest, that
> this is not something trivially known by all except me.
>
> First time I asked this question in this thread
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg00052.html
>
> and Mauro replied (see above thread for a complete reply):
>
> On Thu, 8 Jan 2009, Mauro Carvalho Chehab wrote:
> > On Wed, 7 Jan 2009 10:14:31 +0100 (CET)
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>
> [snip]
>
> > > For example on mt9t031
> > > binning and skipping are used for that. Whereas CROP uses the current
> > > scaling configuration and selects a sub-window, so, once you've done
> > > S_FMT to 320x240, a crop request for 640x480 might well fail.
> >
> > I also understand this way. You cannot crop with a resolution bigger
> > than what you've selected.
>
> (Let's call this statement M1:-))

If I read the spec correctly, in particular section 1.11.1, then cropping 
comes before scaling, so you can crop to 640x480 (S_CROP) and scale that to 
320x240 (S_FMT). S_FMT scales the cropped rectangle.

>
> > > For this you have
> > > to issue a S_FMT, i.e., change scaling. Or would one have to re-scale
> > > transparently?
> > >
> > > Is this interpretation correct? It seems to reflect the API as
> > > documented on http://v4l2spec.bytesex.org/spec/book1.htm correctly.
> > >
> > > If it is correct, then what should CROP_CAP return as maximum
> > > supported window sizes? Should it return them according to the
> > > current scaling or according to scale 1?
> >
> > I understand that it should return against the current scaling.
>
> (and this one M2, whereas I understand it as "current scaling" means
> "current scaling coefficient", not "current scaled output windof")
>
> Then in another thread
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg03512.html
>
> Stefan motivated for an incomatibly different interpretation of the
> standard:
>
> On Thu, 2 Apr 2009, Stefan Herbrechtsmeier wrote:
>
> [snip]
>
> > The user doesn't have to remember the scale anyway. Only the ways a
> > different. You interpret S_CROP
> > as something like a cutting of the S_FMT window. I interpret S_FMT as a
> > output format selection
> > and S_CROP as a sensor window selection.
>
> which I now interpret as
>
> S_FMT(640x480) means "scale whatever rectangle has been selected on the
> sensor to produce an output window of 640x480" and S_CROP(2048x1536)
> means "take a window of 2048x1536 sensor pixels from the sensor and scale
> it to whatever output window has been or will be selected by S_FMT." This
> contradicts M1, because you certainly can crop a larger (sensor) window.
> Also, I now believe, that [GS]_CROP and, logically, CROPCAP operate in
> sensor pixels and shall not depend on any scales, which contradicts (my
> understanding of) M2.
>
> It now seems to be quite simple to me:
>
> {G,S,TRY}_FMT configure output geometry in user pixels
> [GS]_CROP, CROPCAP configure input window in sensor pixels

Agreed.

> The thus configured input window should be mapped (scaled) into the
> output window.
>
> Now, which one is correct?

Your interpretation is correct to the best of my knowledge. I think the 
cropping API remains one of the worst explained ioctls in the spec. There 
are some weird things you can get into when dealing with S-Video (PAL/NTSC) 
like signals, but for sensors like this it is as you described.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
