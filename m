Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40309 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933376AbZKYA0m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 19:26:42 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@wilsonet.com>,
	"Igor M. Liplianin" <liplianin@me.by>, stoth@kernellabs.com
In-Reply-To: <20091123095435.310fcdf3@hyperion.delvare>
References: <4B0459B1.50600@fechner.net> <4B081F0B.1060204@fechner.net>
	 <1258836102.1794.7.camel@localhost> <200911220303.36715.liplianin@me.by>
	 <1258858102.3072.14.camel@palomino.walls.org> <4B097E37.10402@fechner.net>
	 <1258920707.4201.16.camel@palomino.walls.org>
	 <4B099E37.5070405@fechner.net> <20091122213230.38650f8d@hyperion.delvare>
	 <1258935479.1896.29.camel@localhost>
	 <20091123095435.310fcdf3@hyperion.delvare>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 19:25:24 -0500
Message-Id: <1259108724.3069.22.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-11-23 at 09:54 +0100, Jean Delvare wrote:
> On Sun, 22 Nov 2009 19:17:59 -0500, Andy Walls wrote:
> > On Sun, 2009-11-22 at 21:32 +0100, Jean Delvare wrote:
> > > The fact that 0x30-0x37 and 0x50-0x5f all reply suggest that the bus
> > > driver erroneously returns success to "SMBus receive byte" transactions
> > > even when no device acks. This is a bug which should get fixed. If you
> > > point me to the I2C adapter driver code, I can take a look.
> > 
> > Although Igor's information makes the original need for this moot, here
> > is the i2c adapter driver code:
> > 
> > http://linuxtv.org/hg/v4l-dvb/file/8bff7e6c44d4/linux/drivers/media/video/cx23885/cx23885-i2c.c
> 
> The results are not surprising: i2c_slave_did_ack() is only called for
> zero-length transactions. For all other transactions, no check is done.
> This is incorrect.
> 
> I have written 3 patches for cx23885-i2c.c, the second one should fix
> this particular issue. The other two are cleanups. Patches are there if
> you want to take a look / give them a try:
> http://khali.linux-fr.org/devel/misc/cx23885/
> 
> These are totally untested, and I don't know anything about the
> hardware, so they might need some more work. But at least you should
> get the idea of what's missing.

Jean,

(adding Steven Toth to the Cc: list)

Thanks!

I will inspect and test these with my HVR-1850 (CX23888) loaner board
this weekend (hopefully).

Regards,
Andy

