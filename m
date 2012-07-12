Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4596 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab2GLTDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 15:03:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [Ksummit-2012-discuss] Media system Summit
Date: Thu, 12 Jul 2012 21:03:01 +0200
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	KS2012 <ksummit-2012-discuss@lists.linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1341994155.3522.16.camel@dabdike.int.hansenpartnership.com> <20120712161820.GA4488@sirena.org.uk> <CAOesGMgg6CoxY-RHGnXfpG8y3sqnn-Q=3xY0X=mov41wme7w8Q@mail.gmail.com>
In-Reply-To: <CAOesGMgg6CoxY-RHGnXfpG8y3sqnn-Q=3xY0X=mov41wme7w8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207122103.01910.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu July 12 2012 18:48:23 Olof Johansson wrote:
> On Thu, Jul 12, 2012 at 9:18 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Thu, Jul 12, 2012 at 10:08:04AM +0200, Sylwester Nawrocki wrote:
> >
> >> I'd like to add a "Common device tree bindings for media devices" topic to
> >> the agenda for consideration.
> >
> > It'd be nice to get this to join up with ASoC...
> 
> 
> There's a handful of various subsystems that have similar topics,
> maybe slice it the other way and do a device-tree/ACPI breakout that
> cuts across the various areas instead?
> 
> Communication really needs to be two-way: Crafting good bindings for a
> complex piece of hardware isn't trivial and having someone know both
> the subsystem and device tree principles is rare. At least getting all
> those people into the same room would be good.

I'm not so sure: I think that most decisions that need to be made are
quite subsystem specific. Trying to figure out how to implement DT for
multiple subsystems in one workshop seems unlikely to succeed, simply
because of lack of time. I also don't think there is much overlap between
subsystems in this respect, so while the DT implementation for one subsystem
is discussed, the representatives of other subsystems are twiddling their
thumbs.

It might be more productive to have one or two DT experts around who
rotate over the various workshops that have to deal with the DT and can
offer advice.

Regards,

	Hans

> 
> There's obvious overlap with ARM here as well, since it's one of the
> current big pushers of DT use, but I think it would be better to hold
> this as a separate breakout from that.
> 
> 
> -Olof
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
