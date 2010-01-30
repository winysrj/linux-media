Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:55322 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab0A3K4f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2010 05:56:35 -0500
Date: Sat, 30 Jan 2010 11:56:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135
 variants
Message-ID: <20100130115632.03da7e1b@hyperion.delvare>
In-Reply-To: <1264812461.16350.90.camel@localhost>
References: <20100127120211.2d022375@hyperion.delvare>
 <4B630179.3080006@redhat.com>
 <1264812461.16350.90.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Hermann,

On Sat, 30 Jan 2010 01:47:41 +0100, hermann pitton wrote:
> Am Freitag, den 29.01.2010, 13:40 -0200 schrieb Mauro Carvalho Chehab:
> > Jean Delvare wrote:
> > > From: Jean Delvare <khali@linux-fr.org>
> > > Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants
> > > 
> > > Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
> > > Analog (card=146). However, by the time we find out, some
> > > card-specific initialization is missed. In particular, the fact that
> > > the IR is GPIO-based. Set it when we change the card type.
> > > 
> > > We also have to move the initialization of IR until after the card
> > > number has been changed. I hope that this won't cause any problem.
> > 
> > Hi Jean,
> > 
> > Moving the initialization will likely cause regressions. The reason why there
> > are two init codes there were due to the way the old i2c code used to work.
> > This got fixed after the i2c rework, but it caused regressions on that time.

I don't think there is any problem with having two init sequences. You
need the EEPROM to identify some devices, you need I2C support to
access the EEPROM, and you need some initialization to get I2C
operational.

This doesn't mean that some adjustments to the exact sequence aren't
possible. In particular, I don't see what else can depend on IR being
initialized, so I can't really see what harm can be done in moving IR
init code _later_ in the sequence. Looking at saa7134_input_init1(), I
see that it is essentially setting up software parameters in the
saa7134_dev structure, there is almost no hardware access. Only for a
few cards, we change a couple bits in registers GPIO_GPMODE* and
GPIO_GPSTATUS*. I honestly can't see how doing this _later_ in the init
sequence could be a problem.

> > The proper way would be to just muve the IR initialization on this board
> > from init1 to init2, instead of changing it for all other devices.

Hmm, OK. I think it's wrong, but I'm not the one to decide. Patch below.

> Mauro, I do agree with you that it is likely better to go a way with
> minimum chances for regressions, also given the current testing base and
> that only this single card is involved..

I admit I am very surprised that we apparently can't get anyone to test
changes to a driver that supports 176 different models of TV cards :(

> Do we end up with something card specific in core code here?
> After all, we know this is a no go.
> 
> Hartmut and me thought back and forth on how to deal with it for quite
> some while, unfortunately Hartmut is not present currently on the list,
> but he voted for to have a separate entry for that card finally too.
> 
> What we seem to have now is:
> 
> 1. We don't know, if Jean's patch really would cause regressions,
>    but it is likely hard to get all the testing done. No problems with a
>    FlyVideo3000 gpio remote at the time Roman suggested it, but I had
>    not any i2c remote that time ...

I doubt it matters, given that saa7134_input_init1() only cares about
GPIO-based IR:

int saa7134_input_init1(struct saa7134_dev *dev)
{
	(...)
	if (dev->has_remote != SAA7134_REMOTE_GPIO)
		return -ENODEV;

So the moving the call to this function should have no effect on boards
with I2C-based IR.

> (...)
> Given what is also in the cruft for bttv, I would not care too much for
> that single card on that now also ancient driver, just print what the
> user can do to escape and any google would find it quickly too. For Asus
> it is a unique problem on that driver so far.

This isn't how we're going to make Linux popular.

> I should have some time on Sunday afternoon for testing, if we should go
> that way.

Any testing you can provide is very welcome, thanks.

* * * * *

From: Jean Delvare <khali@linux-fr.org>
Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants

Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
Analog (card=146). However, by the time we find out, some
card-specific initialization is missed. In particular, the fact that
the IR is GPIO-based. Set it when we change the card type, and run
saa7134_input_init1().

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Daro <ghost-rider@aster.pl>
Cc: Roman Kellner <muzungu@gmx.net>
---
 linux/drivers/media/video/saa7134/saa7134-cards.c |    5 +++++
 1 file changed, 5 insertions(+)

--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-30 10:56:50.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-30 11:52:18.000000000 +0100
@@ -7299,6 +7299,11 @@ int saa7134_board_init2(struct saa7134_d
 		       printk(KERN_INFO "%s: P7131 analog only, using "
 						       "entry of %s\n",
 		       dev->name, saa7134_boards[dev->board].name);
+
+			/* IR init has already happened for other cards, so
+			 * we have to catch up. */
+			dev->has_remote = SAA7134_REMOTE_GPIO;
+			saa7134_input_init1(dev);
 	       }
 	       break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1150:


-- 
Jean Delvare
