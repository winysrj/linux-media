Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:39736 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754816AbZD1Wlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 18:41:42 -0400
Subject: Re: [PATCH v2] Enabling of the Winfast TV2000 XP Global TV capture
	card remote control
From: hermann pitton <hermann-pitton@arcor.de>
To: Pieter Van Schaik <vansterpc@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Vasiliy Temnikov <vaka@newmail.ru>, linux-media@vger.kernel.org
In-Reply-To: <faf98b150904281220v425bfffv1dd29ba7a56b1133@mail.gmail.com>
References: <faf98b150904232135l7593612dr68b7ed9cac9af385@mail.gmail.com>
	 <1240712951.3714.13.camel@pc07.localdom.local>
	 <20090428155853.03a9c6e8@pedra.chehab.org>
	 <faf98b150904281220v425bfffv1dd29ba7a56b1133@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 00:37:09 +0200
Message-Id: <1240958229.3731.111.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Am Dienstag, den 28.04.2009, 21:20 +0200 schrieb Pieter Van Schaik:
> Mauro,
> 
> I apologize for my ignorance, I am not sure what an SOB is, could you
> possibly elaborate?
> 
> Thank you
> 
> Regards
> Pieter van Schaik

Pieter,

just like you had it on your prior patches from April 6, 8 and 20,
which did not make it into "patchwork".

Signed-off-by: your name and email

Mauro, I advised Peter just to take my version with the indentation
fixes and try again.

> On Tue, Apr 28, 2009 at 8:58 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > On Sun, 26 Apr 2009 04:29:11 +0200
> > hermann pitton <hermann-pitton@arcor.de> wrote:
> >
> >>
> >> Am Freitag, den 24.04.2009, 06:35 +0200 schrieb Pieter Van Schaik:
> >> > This patch is for supporting the remote control of the Winfast TV2000
> >> > XP Global TV capture card. A case statement was added in order to
> >> > initialize the GPIO data structures as well as a case statement for
> >> > handling the keys correctly when pressed.
> >> >
> >> > Thanks to Hermann for all his help
> >> >
> >> > Regards
> >> > Pieter van Schaik
> >
> >
> > Pieter,
> >
> > You forgot your SOB on your v2 patch. Could you please send a v3 with it enclosed?
> >
> >> Mauro,
> >>
> >> please give some further comments, how to proceed within this
> >> "patchwork" stuff.
> >>
> >> For what I can see, you get some of out of sync patches so far?
> >>
> >> Do you do the sync and can I ignore such remaining efforts, or do you
> >> prefer people are waiting until this is somehow properly lined up again?
> >
> > Hermann,
> >
> > Sorry, but I didn't understand what you're meaning.

It looks like there are saa7134 patches at patchwork, which might not
apply cleanly, since there are for example changes on saa7134-input and
saa7134-cards.c.

> > I generally run some scripts that read the patchwork patches based on the
> > internal patchwork numbering representation (in general, it is from the oldest
> > to the newest one).

It is more about how patchwork works for you.

The newer patches don't care about changes older ones did already on the
same file and both are waiting there.

If I create some more based on current mercurial v4l-dvb and they go to
patchwork too, they won't apply cleanly or not at all, since they don't
care for changes you might pull in from patchwork prior to them and so
on.

Usually I did wait until prior patches are in mercurial v4l-dvb.

Now with patchwork, do I just create them based on current v4l-dvb and
don't have to care if they might create merge conflicts and manual work?

> > However, sometimes I skip patches or I update they manually at web interface,
> > due to a countless number of reasons (duplicated patches, obsoleted patches,
> > patches that generate more discusions, etc...).

It was also not clear to me, what happens with patches becoming an RFC
flag. Now it seems they should be send again with new version v2, v3
etc.

What do we do with that patch over Andrew and the new AverMedia Studio
505 which is marked Under Review? 

We can just drop the Secam change in saa7134-core.c. Vasiliy,in CC now,
did send his SOB later, but it seems you need it in patckwork.
Also that LINE2 for external audio in still makes me wonder. 

> > So, don't expect that I'll apply the patches on any particular order. If you
> > really need patches to be applied sequentially, please number they with [PATCH x/y].

Yes, that is unchanged.

> > In this specific case, should I need to apply a patch before this one for it to work?

No, sorry for abusing it for patchwork questions.

> >>
> >> I have nothing important and nobody cared about the oops on the Compro
> >> T750F stuff, on which I was not involved, but I would like to have a
> >> warning in for the Asus 3in1 not to use a rotor with it.
> >
> > I dunno what patches are you referring. Could you please point their patchwork
> > numbers?

They don't exist yet, but if no other advise, I base them on current
mercurial v4l-dvb.

Cheers,
Hermann

----------------------
Sorry for dual mails, lost-linux-media :(




