Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38464 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdLBTta (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 14:49:30 -0500
Date: Sat, 2 Dec 2017 17:49:22 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jemma Denson <jdenson@gmail.com>
Cc: Tycho =?UTF-8?B?TMO8cnNlbg==?= <tycholursen@gmail.com>,
        Soeren Moch <smoch@web.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [GIT PULL] SAA716x DVB driver
Message-ID: <20171202174922.34a6f9b9@vento.lan>
In-Reply-To: <e2076533-5c33-f3be-b438-a1616f743a92@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 2 Dec 2017 18:51:16 +0000
Jemma Denson <jdenson@gmail.com> escreveu:

> Hi Mauro,
>=20
> On 27/11/17 11:24, Mauro Carvalho Chehab wrote:
> > Em Fri, 24 Nov 2017 17:28:37 +0100
> > Tycho L=C3=BCrsen <tycholursen@gmail.com> escreveu:
> > =20
> >> Hi Mauro,
> >>
> >> afaik the last communication about submission of this driver was about
> >> two months ago.
> >>
> >> This driver is important to me, because I own several TurboSight cards
> >> that are saa716x based. I want to submit a patch that supports my card=
s.
> >> Of course I can only do so when you accept this driver in the first pl=
ace.
> >>
> >> Any chance you and S=C3=B6ren agree about how to proceed about this dr=
iver
> >> anytime soon? =20
> > If we can reach an agreement about what should be done for the driver
> > to be promoted from staging some day, I'll merge it. Otherwise,
> > it can be kept maintained out of tree. This driver has been maintained
> > OOT for a very long time, and it seems that people were happy with
> > that, as only at the second half of this year someone is requesting
> > to merge it.
> >
> > So, while I agree that the best is to merge it upstream and
> > address the issues that made it OOT for a long time, we shouldn't
> > rush it with the risk of doing more harm than good.
> >
> > Thanks,
> > Mauro =20
>=20
> Would I be correct in thinking the main blocker to this is the *_ff featu=
res
> used by the S2-6400 card? There's plenty of other cards using this chipset
> that don't need that part.
>=20
> Would a solution for now to be a driver with the ff components stripped o=
ut,
> and then the ff API work can be done later when / if there's any interest?

Works for me. In such case (and provided that the driver without *_ff are
in good shape), we could merge it under drivers/media (instead of merging
it on staging).

> I guess a problem would be finding a maintainer, I'm happy to put together
> a stripped down driver just supporting the TBS card I use (I already have
> one I use with dkms), but I'm not sure I have the time or knowledge of th=
is
> chipset to be a maintainer.

As we're talking more about touching at uAPI, probably it doesn't require
chipsed knowledge. Only time and interest on doing it.

Please sync with Soeren. Perhaps if you both could help on it, it would
make the task easier.

> Unfortunately my workplace is phasing out
> these cards otherwise I'd try and get them to sponsor me rather than do it
> on my own time!

Yeah, getting sponsored to do it would make things easier.

Thanks,
Mauro
