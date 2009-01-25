Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:39342 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZAYWCl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 17:02:41 -0500
Date: Sun, 25 Jan 2009 13:49:33 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: CityK <cityk@rogers.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Krufky <mkrufky@linuxtv.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
In-Reply-To: <497CAB2F.7080700@rogers.com>
Message-ID: <Pine.LNX.4.58.0901251322320.17971@shell2.speakeasy.net>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
 <200901182241.10047.hverkuil@xs4all.nl> <4973BD03.4060702@rogers.com>
 <200901190853.19327.hverkuil@xs4all.nl> <497CAB2F.7080700@rogers.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 25 Jan 2009, CityK wrote:
> Hans Verkuil wrote:
> > card. Does someone know if there is something special about this? And how
> > do you manage to make analog TV work if the tda9887 isn't found? That's
> > rather peculiar.

The tda9887 is a simple device with just three registers.  If they are set
to the right value when the driver loads, which wouldn't be unexpected,
then it isn't necessary to actually do anything to the chip.  If you had a
multistandard tuner (and had access to broadcasts in multiple standards!)
then I expect switching standards wouldn't work without the tda9887 driver.
Verifying both TV and radio tuning works is probably the most realistic way
to check.

> > saa7133[1]: i2c xfer: < c2 30 90 >
> > saa7134[3]: i2c xfer: < c2 >
> > saa7134[3]: i2c xfer: < c2 0b dc 9c 60 >
> > saa7134[3]: i2c xfer: < c2 0b dc 86 54 >
> >
> > Exactly here, when the buffers are sent the second time the tda9887
> > becomes the first time visible on the bus. According to Hartmut the
> > modification of buffer[3] from 0x60 to 0x54 is that hidden switch,
> > IIRC.
> >
>
> I believe Mauro is correct in regards to the tda9887 in that, within the
> Philips TUV1236D NIM, it is behind the Nxt2004's i2c gate.  After
> re-reading what Michael mentioned previously:

Address 0xc2 is the PLL, not the NXT2004.  Why would the PLL control an I2C
gate on the nxt2004?  I think what I said before about a gpio line on the
PLL being used to hold the analog demod in reset when not in use is more
likely to be correct.

> > The i2c command to enable the tuner is sent to nxt200x. If there are any
> > ATSC110 variant with a different demod (maybe a different version of nxt200x?),
> > then the users may experience different behaviors.

That command sequence is sent to the PLL, not the nxt2004, so this is
wrong.  There is another command sent to the nxt2004 (which is at address
0x0a) from code in saa7134-cards.c to "enables tuner" as well.
