Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60145 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2GMB2R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 21:28:17 -0400
Received: by pbbrp8 with SMTP id rp8so4610787pbb.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 18:28:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1207122256290.19866@axis700.grange>
References: <1341994155.3522.16.camel@dabdike.int.hansenpartnership.com>
	<20120712161820.GA4488@sirena.org.uk>
	<CAOesGMgg6CoxY-RHGnXfpG8y3sqnn-Q=3xY0X=mov41wme7w8Q@mail.gmail.com>
	<201207122103.01910.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.1207122256290.19866@axis700.grange>
Date: Thu, 12 Jul 2012 18:28:16 -0700
Message-ID: <CAOesGMi9r_a+JqDk2_n64EDSE4dCMnJc-kXzo__xLQgD_LXMWQ@mail.gmail.com>
Subject: Re: [Ksummit-2012-discuss] Media system Summit
From: Olof Johansson <olof@lixom.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	KS2012 <ksummit-2012-discuss@lists.linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 12, 2012 at 2:05 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 12 Jul 2012, Hans Verkuil wrote:
>
>> On Thu July 12 2012 18:48:23 Olof Johansson wrote:
>> > On Thu, Jul 12, 2012 at 9:18 AM, Mark Brown
>> > <broonie@opensource.wolfsonmicro.com> wrote:
>> > > On Thu, Jul 12, 2012 at 10:08:04AM +0200, Sylwester Nawrocki wrote:
>> > >
>> > >> I'd like to add a "Common device tree bindings for media devices" topic to
>> > >> the agenda for consideration.
>> > >
>> > > It'd be nice to get this to join up with ASoC...
>> >
>> >
>> > There's a handful of various subsystems that have similar topics,
>> > maybe slice it the other way and do a device-tree/ACPI breakout that
>> > cuts across the various areas instead?
>> >
>> > Communication really needs to be two-way: Crafting good bindings for a
>> > complex piece of hardware isn't trivial and having someone know both
>> > the subsystem and device tree principles is rare. At least getting all
>> > those people into the same room would be good.
>>
>> I'm not so sure: I think that most decisions that need to be made are
>> quite subsystem specific. Trying to figure out how to implement DT for
>> multiple subsystems in one workshop seems unlikely to succeed, simply
>> because of lack of time. I also don't think there is much overlap between
>> subsystems in this respect, so while the DT implementation for one subsystem
>> is discussed, the representatives of other subsystems are twiddling their
>> thumbs.
>>
>> It might be more productive to have one or two DT experts around who
>> rotate over the various workshops that have to deal with the DT and can
>> offer advice.
>
> I'm sure everyone has seen this, but just to have it mentioned here:
>
> <a
> href="http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/50755">
> shameless self-advertisement</a>

I hadn't seen it, since you didn't cc devicetree-discuss. Well, I'm
also generally behind on list email right now since I am travelling
but I couldn't find it in any list folder I subscribe to.

> As for whether or not discuss DT for various subsystems together - why not
> do both? First short sessions in each subsystems, of course, this would
> only work if proposals have been prepared beforehand and at least
> preliminary discussions on the MLs have taken place, and then another
> (also short) combined session? Of course, it also depends on how much time
> we can and want to dedicate to this.

The agenda for such a day should probably be partially broken down per
subsystem, yes, and it would make sense for people from the various
areas to describe the kind of setup that they need to be able to
define, similar to how you did in your writeup above.

In some cases it would be a matter of in-person
review/discussion/arguments of already proposed bindings, in other
cases it would probably be a seeding discussion for upcoming bindings
instead. Having the latter piggy-back on hearing what's discussed with
the former category would likely be a good idea.


-Olof
