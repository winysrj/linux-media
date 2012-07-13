Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45241 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273Ab2GMBU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 21:20:28 -0400
Received: by pbbrp8 with SMTP id rp8so4601152pbb.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 18:20:27 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 Jul 2012 18:20:27 -0700
Message-ID: <CAOesGMgs7sBn=Tfk6YP7BE=O0s8qQrz17n-GfEi_Vr2HDy6xZA@mail.gmail.com>
Subject: Device-tree cross-subsystem binding workshop [was Media system Summit]
From: Olof Johansson <olof@lixom.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	KS2012 <ksummit-2012-discuss@lists.linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 12, 2012 at 12:03 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thu July 12 2012 18:48:23 Olof Johansson wrote:
>> On Thu, Jul 12, 2012 at 9:18 AM, Mark Brown
>> <broonie@opensource.wolfsonmicro.com> wrote:
>> > On Thu, Jul 12, 2012 at 10:08:04AM +0200, Sylwester Nawrocki wrote:
>> >
>> >> I'd like to add a "Common device tree bindings for media devices" topic to
>> >> the agenda for consideration.
>> >
>> > It'd be nice to get this to join up with ASoC...
>>
>>
>> There's a handful of various subsystems that have similar topics,
>> maybe slice it the other way and do a device-tree/ACPI breakout that
>> cuts across the various areas instead?
>>
>> Communication really needs to be two-way: Crafting good bindings for a
>> complex piece of hardware isn't trivial and having someone know both
>> the subsystem and device tree principles is rare. At least getting all
>> those people into the same room would be good.
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

One of the real problems right now is the lack of DT reviewers and
general reviewer fatigue. In particular, many of the proposed bindings
tend to have the same issues (focusing too much on how the
platform_data is structured today and not on what the hardware
actually is), and a few other similar things.

Based on that I don't think it's a better solution to have the same
few people walk from room to room to cover the same thing multiple
times. No one has to sit there the whole day and listen on it all, but
for those who are genuinely interested in how other subsystems will
handle these bindings, I think it would be very useful to learn from
how they made their decisions. Don't work in a vacuum, etc.

So, I'd like to formally propose this as a mini-summit or workshop or
whatever you might want to call it. I can help organize it together
with Rob and Grant if needed (especially since Grant has a lot of
other things going on at the moment).

If there's insufficent interest to do this as a separate event we can
try to accomodate for it as part of the ARM mini-summit, but squeezing
all of that in with the rest of the ARM activities in one day will be
hard.


-Olof
