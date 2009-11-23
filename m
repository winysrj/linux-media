Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:57452 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZKWIyc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 03:54:32 -0500
Date: Mon, 23 Nov 2009 09:54:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@wilsonet.com>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: Re: IR Receiver on an Tevii S470
Message-ID: <20091123095435.310fcdf3@hyperion.delvare>
In-Reply-To: <1258935479.1896.29.camel@localhost>
References: <4B0459B1.50600@fechner.net>
	<4B081F0B.1060204@fechner.net>
	<1258836102.1794.7.camel@localhost>
	<200911220303.36715.liplianin@me.by>
	<1258858102.3072.14.camel@palomino.walls.org>
	<4B097E37.10402@fechner.net>
	<1258920707.4201.16.camel@palomino.walls.org>
	<4B099E37.5070405@fechner.net>
	<20091122213230.38650f8d@hyperion.delvare>
	<1258935479.1896.29.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 22 Nov 2009 19:17:59 -0500, Andy Walls wrote:
> On Sun, 2009-11-22 at 21:32 +0100, Jean Delvare wrote:
> > The fact that 0x30-0x37 and 0x50-0x5f all reply suggest that the bus
> > driver erroneously returns success to "SMBus receive byte" transactions
> > even when no device acks. This is a bug which should get fixed. If you
> > point me to the I2C adapter driver code, I can take a look.
> 
> Although Igor's information makes the original need for this moot, here
> is the i2c adapter driver code:
> 
> http://linuxtv.org/hg/v4l-dvb/file/8bff7e6c44d4/linux/drivers/media/video/cx23885/cx23885-i2c.c

The results are not surprising: i2c_slave_did_ack() is only called for
zero-length transactions. For all other transactions, no check is done.
This is incorrect.

I have written 3 patches for cx23885-i2c.c, the second one should fix
this particular issue. The other two are cleanups. Patches are there if
you want to take a look / give them a try:
http://khali.linux-fr.org/devel/misc/cx23885/

These are totally untested, and I don't know anything about the
hardware, so they might need some more work. But at least you should
get the idea of what's missing.

> Note the CX2388[578] chips have 3 I2C masters, 2 for external buses, and
> 1 internal "on silicon" bus which the driver sets up as the 3rd bus.
> The internal bus should at least have devices at 0x44 and 0x4c as
> confirmed above.  I'll note the comment in this file, that indicates the
> "on silicon" I2C bus runs at 1.95 MHz:
> 
> http://linuxtv.org/hg/v4l-dvb/file/8bff7e6c44d4/linux/drivers/media/video/cx23885/cx23885-core.c

This is strange. For one thing, 1.95 MHz wouldn't be standard I2C but
high-speed mode I2C. But more importantly, I fail to see how you could
reach such speeds with a software-driven, byte-by-byte implementation.
You need hardware buffers to reach high speeds on I2C.

> The TeVii S470 card had what looked like at serial I2C EEPROM with the
> A0, A1, and A2 pins all grounded, so I assume it is at 0x50 on one of
> the CX23885's external I2C buses.

Probably. Hopefully my patches will show you where it is.

-- 
Jean Delvare
