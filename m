Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33063 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751636AbdLDKHe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 05:07:34 -0500
Date: Mon, 4 Dec 2017 08:07:27 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jemma Denson <jdenson@gmail.com>
Cc: Soeren Moch <smoch@web.de>,
        Tycho =?UTF-8?B?TMO8cnNlbg==?= <tycholursen@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Manu Abraham <manu@linuxtv.org>,
        Andreas Regel <andreas.regel@gmx.de>,
        Oliver Endriss <o.endriss@gmx.de>
Subject: Re: [GIT PULL] SAA716x DVB driver
Message-ID: <20171204080727.2b5480ce@vento.lan>
In-Reply-To: <740078a3-ce40-c16d-79dd-5e55c5496060@gmail.com>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
        <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
        <20170827073040.6e96d79a@vento.lan>
        <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
        <20170909181123.392cfbb0@vento.lan>
        <a44b8eb0-cdd5-aa28-ad30-68db0126b6f6@web.de>
        <20170916125042.78c4abad@recife.lan>
        <fab215f8-29f3-1857-6f33-c45e78bb5e3c@web.de>
        <7c17c0a1-1c98-1272-8430-4a194b658872@gmail.com>
        <20171127092408.20de0fe0@vento.lan>
        <e2076533-5c33-f3be-b438-a1616f743a92@gmail.com>
        <20171202174922.34a6f9b9@vento.lan>
        <ce4f25e6-7d75-2391-d685-35b50a0639bb@web.de>
        <335e279e-d498-135f-8077-770c77cf353b@gmail.com>
        <3251f1f3-ce9b-529d-b155-ac433d1b0ae5@web.de>
        <740078a3-ce40-c16d-79dd-5e55c5496060@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Dec 2017 15:04:31 +0000
Jemma Denson <jdenson@gmail.com> escreveu:

> On 03/12/17 14:11, Soeren Moch wrote:
> > On 03.12.2017 11:57, Jemma Denson wrote: =20
> >> On 02/12/17 23:59, Soeren Moch wrote: =20

> > The whole purpose of driver development is bringing support for existing
> > hardware to available user applications, preferably with existing APIs.
> > And exactly that is in this pull request.
> > In the whole discussion I cannot find a single reason, how merging this
> > driver would violate the linux development principles. =20
>=20
> That's not really one for me to answer, but Mauro has raised objections
> so it can't be merged as is. I'm just trying to find a way forward that
> avoids this getting stuck for another few years.

Let me write a longer explanation about what are my concerns.

The current FF API was designed back in 1999, almost 20 years ago. It
was a pioneer design on that time, but it shows its age. I had several
discussions in the past with some chipset manufacturers and with
people interested on open sourcing their drivers for embedded devices.
The point is: the current way it is implemented doesn't fit, for
several reasons:

- The API itself is not flexible enough to support their hardware,
  with usually has a different number of frontends than the number
  of decoders and all sorts of other complexities. On modern
  chipsets, the same pipeline is used also for other things like
  hdmi input/output and even webcams/microphones. So, an API that
  integrates with such components are needed. Also, on modern=20
  hardware, the descrambler hardware can dynamically be added/removed
  from the pipeline, and they usually have a pair of scrambler/descrambler
  module (using a different crypto algorithm), used when the data is
  written on a hard disk;

- The documentation for the API is incomplete;

- The API is broken with 64 bits kernel and 32 bits userspace. Most SoCs
  nowadays use 64 bits Kernel, but lots of vendors are still using 32 bits
  userspace;

- The DVB core doesn't support the FF API. Everything should be
  written at the drivers.

Having an API for FF that doesn't fit on modern hardware has a practical
effect of preventing people to write it on a proper way, as APIs on
Linux are forever (in the sense that, while the API is still in usage
by non-OOT/staging drivers, it can't be removed).

The only driver that implements such API upstream isfor a hardware developed
in 1999, whose production ended ages ago. So, the status of this API,
from Kernel's PoV, is that it could be removed anytime if needed, by
simply removing one obsolete driver. Removing obsolete drivers that
are preventing adding new functionalities is allowed.

So, it is time to replace it for good, implementing something that works
for modern hardware, using APIs that fits on embedded systems needs
(as most FF implementation are for STB and TV sets).

In other words, I'm simply against adding a new driver that will=20
come with a bold maintenance requirement of keeping alive an obsolete
FF API that doesn't fit on modern chipset needs, and would prevent
adding a new FF API for another 20 years that would otherwise work
with modern hardware. It is time to discuss about a new FF API and
implement drivers supporting it.

In the specific case of saa716x driver, users seemed to be happy on
having it OOT, as it has been working like that for a long time without
any attempts to merge it. As new hardware using this chipset aren't
manufactured anymore (AFAIKT). So, a trivial alternative would be to
keep if OOT.

So, the only way I would agree on merging the saa716x driver upstream
(specially support for FF) is if we come up with a solution that
wouldn't force us to stick with an FF API that doesn't support modern
hardware for a long time.

As capping saa716x FF support doesn't make much sense, we should
migrate it to a new FF API, long term.

-

=46rom what I understood, Soeren's original proposal at his initial pull
request were to add it at staging, keeping it there forever. This is=20
against staging policy. Staging is not a place to keep drivers forever,=20
but a place to add drivers that require work. A driver at staging that
isn't maintained (in the sense of solving issues that will allow
it to be moved out of staging) can be removed anytime. So, this is not
an option.

As a summary from this thread's discussion, my understanding is that
there are currently two alternatives about a way to move forward:

1) add saa716x driver at staging, with developers committed to solve
   whatever issues the driver has. On other words, we should have a plan
   to migrate it to an API capable of attending current needs. Both=20
   developers and users should be aware that, if such change never happen,
   the driver may be removed anytime in the future.

2) add first the parts that won't require a new API, and having developers
   working on addressing the API issues for FF. Once this is addressed,
   merge the FF support. While this doesn't happen, the FF part of the
   driver would be maintained OOT.

That's said, I'm pretty sure that, if we merge it at staging, and it=20
ended by being removed on a couple of Kernel versions, this would be
a lot worse for users than just keep it maintained OOT. So, (2) could
work better, as, at worse case scenario where developers won't ever have=20
time to finish the FF API work, the non-FF part won't be dropped.

Regards,
Mauro
