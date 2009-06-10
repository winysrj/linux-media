Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48875 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751331AbZFJQC3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 12:02:29 -0400
Date: Wed, 10 Jun 2009 18:02:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: S_FMT vs. S_CROP
In-Reply-To: <49D46D2E.5090702@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0906101738140.4817@axis700.grange>
References: <49CBB13F.7090609@hni.uni-paderborn.de>
 <Pine.LNX.4.64.0903261831430.5438@axis700.grange> <49D32B16.2070101@hni.uni-paderborn.de>
 <Pine.LNX.4.64.0904011831340.5389@axis700.grange> <49D46D2E.5090702@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This question - how S_FMT and S_CROP affest image geometry - has been 
discussed at least twice before - that's only with my participation, don't 
know if and how often it has come up before. But the fact, that in two 
discussions we came up with different results seems to suggest, that this 
is not something trivially known by all except me.

First time I asked this question in this thread

http://www.mail-archive.com/linux-media@vger.kernel.org/msg00052.html

and Mauro replied (see above thread for a complete reply):

On Thu, 8 Jan 2009, Mauro Carvalho Chehab wrote:

> On Wed, 7 Jan 2009 10:14:31 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

[snip]

> > For example on mt9t031 
> > binning and skipping are used for that. Whereas CROP uses the current 
> > scaling configuration and selects a sub-window, so, once you've done S_FMT 
> > to 320x240, a crop request for 640x480 might well fail.
> 
> I also understand this way. You cannot crop with a resolution bigger than what
> you've selected.

(Let's call this statement M1:-))

> > For this you have 
> > to issue a S_FMT, i.e., change scaling. Or would one have to re-scale 
> > transparently?
> > 
> > Is this interpretation correct? It seems to reflect the API as documented 
> > on http://v4l2spec.bytesex.org/spec/book1.htm correctly.
> > 
> > If it is correct, then what should CROP_CAP return as maximum supported 
> > window sizes? Should it return them according to the current scaling or 
> > according to scale 1?
> 
> I understand that it should return against the current scaling.

(and this one M2, whereas I understand it as "current scaling" means 
"current scaling coefficient", not "current scaled output windof")

Then in another thread

http://www.mail-archive.com/linux-media@vger.kernel.org/msg03512.html

Stefan motivated for an incomatibly different interpretation of the 
standard:

On Thu, 2 Apr 2009, Stefan Herbrechtsmeier wrote:

[snip]

> The user doesn't have to remember the scale anyway. Only the ways a different.
> You interpret S_CROP
> as something like a cutting of the S_FMT window. I interpret S_FMT as a output
> format selection
> and S_CROP as a sensor window selection.

which I now interpret as

S_FMT(640x480) means "scale whatever rectangle has been selected on the 
sensor to produce an output window of 640x480" and S_CROP(2048x1536) means 
"take a window of 2048x1536 sensor pixels from the sensor and scale it to 
whatever output window has been or will be selected by S_FMT." This 
contradicts M1, because you certainly can crop a larger (sensor) window. 
Also, I now believe, that [GS]_CROP and, logically, CROPCAP operate in 
sensor pixels and shall not depend on any scales, which contradicts (my 
understanding of) M2.

It now seems to be quite simple to me:

{G,S,TRY}_FMT configure output geometry in user pixels
[GS]_CROP, CROPCAP configure input window in sensor pixels

The thus configured input window should be mapped (scaled) into the output 
window.

Now, which one is correct?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
