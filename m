Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:47784 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZFJVjT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 17:39:19 -0400
Date: Wed, 10 Jun 2009 14:39:21 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: S_FMT vs. S_CROP
In-Reply-To: <200906102323.43677.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0906101438550.32713@shell2.speakeasy.net>
References: <49CBB13F.7090609@hni.uni-paderborn.de> <49D46D2E.5090702@hni.uni-paderborn.de>
 <Pine.LNX.4.64.0906101738140.4817@axis700.grange> <200906102323.43677.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Jun 2009, Hans Verkuil wrote:
> On Wednesday 10 June 2009 18:02:39 Guennadi Liakhovetski wrote:
> > This question - how S_FMT and S_CROP affest image geometry - has been
> > discussed at least twice before - that's only with my participation,
> > don't know if and how often it has come up before. But the fact, that in
> > two discussions we came up with different results seems to suggest, that
> > this is not something trivially known by all except me.
> >
> > First time I asked this question in this thread
> >
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg00052.html
> >
> > and Mauro replied (see above thread for a complete reply):
> >
> > On Thu, 8 Jan 2009, Mauro Carvalho Chehab wrote:
> > > On Wed, 7 Jan 2009 10:14:31 +0100 (CET)
> > > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> >
> > [snip]
> >
> > > > For example on mt9t031
> > > > binning and skipping are used for that. Whereas CROP uses the current
> > > > scaling configuration and selects a sub-window, so, once you've done
> > > > S_FMT to 320x240, a crop request for 640x480 might well fail.
> > >
> > > I also understand this way. You cannot crop with a resolution bigger
> > > than what you've selected.
> >
> > (Let's call this statement M1:-))
>
> If I read the spec correctly, in particular section 1.11.1, then cropping
> comes before scaling, so you can crop to 640x480 (S_CROP) and scale that to
> 320x240 (S_FMT). S_FMT scales the cropped rectangle.

This is my understanding of how it's supposed to work as well.
