Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49565 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab2GLVGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 17:06:03 -0400
Date: Thu, 12 Jul 2012 23:05:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Olof Johansson <olof@lixom.net>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	KS2012 <ksummit-2012-discuss@lists.linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [Ksummit-2012-discuss] Media system Summit
In-Reply-To: <201207122103.01910.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1207122256290.19866@axis700.grange>
References: <1341994155.3522.16.camel@dabdike.int.hansenpartnership.com>
 <20120712161820.GA4488@sirena.org.uk> <CAOesGMgg6CoxY-RHGnXfpG8y3sqnn-Q=3xY0X=mov41wme7w8Q@mail.gmail.com>
 <201207122103.01910.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Jul 2012, Hans Verkuil wrote:

> On Thu July 12 2012 18:48:23 Olof Johansson wrote:
> > On Thu, Jul 12, 2012 at 9:18 AM, Mark Brown
> > <broonie@opensource.wolfsonmicro.com> wrote:
> > > On Thu, Jul 12, 2012 at 10:08:04AM +0200, Sylwester Nawrocki wrote:
> > >
> > >> I'd like to add a "Common device tree bindings for media devices" topic to
> > >> the agenda for consideration.
> > >
> > > It'd be nice to get this to join up with ASoC...
> > 
> > 
> > There's a handful of various subsystems that have similar topics,
> > maybe slice it the other way and do a device-tree/ACPI breakout that
> > cuts across the various areas instead?
> > 
> > Communication really needs to be two-way: Crafting good bindings for a
> > complex piece of hardware isn't trivial and having someone know both
> > the subsystem and device tree principles is rare. At least getting all
> > those people into the same room would be good.
> 
> I'm not so sure: I think that most decisions that need to be made are
> quite subsystem specific. Trying to figure out how to implement DT for
> multiple subsystems in one workshop seems unlikely to succeed, simply
> because of lack of time. I also don't think there is much overlap between
> subsystems in this respect, so while the DT implementation for one subsystem
> is discussed, the representatives of other subsystems are twiddling their
> thumbs.
> 
> It might be more productive to have one or two DT experts around who
> rotate over the various workshops that have to deal with the DT and can
> offer advice.

I'm sure everyone has seen this, but just to have it mentioned here:

<a 
href="http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/50755">
shameless self-advertisement</a>

I'm not sure whether the overlap with other subsystems is large or not, 
but there definitely is some, also with video (fbdev / drm), e.g., 
http://thread.gmane.org/gmane.linux.drivers.devicetree/17495

As for whether or not discuss DT for various subsystems together - why not 
do both? First short sessions in each subsystems, of course, this would 
only work if proposals have been prepared beforehand and at least 
preliminary discussions on the MLs have taken place, and then another 
(also short) combined session? Of course, it also depends on how much time 
we can and want to dedicate to this.

Thanks
Guennadi

> Regards,
> 
> 	Hans
> 
> > 
> > There's obvious overlap with ARM here as well, since it's one of the
> > current big pushers of DT use, but I think it would be better to hold
> > this as a separate breakout from that.
> > 
> > 
> > -Olof
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
