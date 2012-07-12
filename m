Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39400 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab2GLQsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 12:48:23 -0400
Received: by obbuo13 with SMTP id uo13so3516464obb.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 09:48:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120712161820.GA4488@sirena.org.uk>
References: <1341994155.3522.16.camel@dabdike.int.hansenpartnership.com>
	<4FFE41F0.4010602@redhat.com>
	<4FFE85E4.7030609@gmail.com>
	<20120712161820.GA4488@sirena.org.uk>
Date: Thu, 12 Jul 2012 09:48:23 -0700
Message-ID: <CAOesGMgg6CoxY-RHGnXfpG8y3sqnn-Q=3xY0X=mov41wme7w8Q@mail.gmail.com>
Subject: Re: [Ksummit-2012-discuss] Media system Summit
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	KS2012 <ksummit-2012-discuss@lists.linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 12, 2012 at 9:18 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jul 12, 2012 at 10:08:04AM +0200, Sylwester Nawrocki wrote:
>
>> I'd like to add a "Common device tree bindings for media devices" topic to
>> the agenda for consideration.
>
> It'd be nice to get this to join up with ASoC...


There's a handful of various subsystems that have similar topics,
maybe slice it the other way and do a device-tree/ACPI breakout that
cuts across the various areas instead?

Communication really needs to be two-way: Crafting good bindings for a
complex piece of hardware isn't trivial and having someone know both
the subsystem and device tree principles is rare. At least getting all
those people into the same room would be good.

There's obvious overlap with ARM here as well, since it's one of the
current big pushers of DT use, but I think it would be better to hold
this as a separate breakout from that.


-Olof
