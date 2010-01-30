Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:37328 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339Ab0A3Ar6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 19:47:58 -0500
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135
 variants
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
In-Reply-To: <4B630179.3080006@redhat.com>
References: <20100127120211.2d022375@hyperion.delvare>
	 <4B630179.3080006@redhat.com>
Content-Type: text/plain
Date: Sat, 30 Jan 2010 01:47:41 +0100
Message-Id: <1264812461.16350.90.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 29.01.2010, 13:40 -0200 schrieb Mauro Carvalho Chehab:
> Jean Delvare wrote:
> > From: Jean Delvare <khali@linux-fr.org>
> > Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants
> > 
> > Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
> > Analog (card=146). However, by the time we find out, some
> > card-specific initialization is missed. In particular, the fact that
> > the IR is GPIO-based. Set it when we change the card type.
> > 
> > We also have to move the initialization of IR until after the card
> > number has been changed. I hope that this won't cause any problem.
> 
> Hi Jean,
> 
> Moving the initialization will likely cause regressions. The reason why there
> are two init codes there were due to the way the old i2c code used to work.
> This got fixed after the i2c rework, but it caused regressions on that time.
> 
> The proper way would be to just muve the IR initialization on this board
> from init1 to init2, instead of changing it for all other devices.
> 
> cheers,
> Mauro

Mauro, I do agree with you that it is likely better to go a way with
minimum chances for regressions, also given the current testing base and
that only this single card is involved..

Do we end up with something card specific in core code here?
After all, we know this is a no go.

Hartmut and me thought back and forth on how to deal with it for quite
some while, unfortunately Hartmut is not present currently on the list,
but he voted for to have a separate entry for that card finally too.

What we seem to have now is:

1. We don't know, if Jean's patch really would cause regressions,
   but it is likely hard to get all the testing done. No problems with a
   FlyVideo3000 gpio remote at the time Roman suggested it, but I had
   not any i2c remote that time ...

2. The previous situation was, that this analog only card did use the
   entry of the Ausus P7131 Dual forcing card=78 without problems,
   but getting fake support for DVB-T announced and printing results
   of some fall through.

3. If we agree, that unique PCI subsystems should have highest priority
   for auto detection, in such a case, we likely could also set the
   PC-39 remote for the older card with USB remote. IIRC, that should
   survive the later change of the card caused by the work around
   eeprom detection later, and disable IR based on eeprom for the older
   then.

To be honest, as pointed to already in the other thread around this, we
should not try to become better than all others on m$ previously for
some very small gain.

We are already much, much better than drivers there, excluding each
others, don't follow Philips/NXP eeprom rules and so on.

We could just print something like use card=number to get the remote up
too, if people, not reading the lists ;), hope to rely on auto detection
in vain ...

About all the LNA and IR mess we have for other manufactures, nobody
talks about anymore ...

Given what is also in the cruft for bttv, I would not care too much for
that single card on that now also ancient driver, just print what the
user can do to escape and any google would find it quickly too. For Asus
it is a unique problem on that driver so far.

I should have some time on Sunday afternoon for testing, if we should go
that way.

Cheers,
Hermann





 




