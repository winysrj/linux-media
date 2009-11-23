Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50253 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbZKWATc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 19:19:32 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@wilsonet.com>,
	"Igor M. Liplianin" <liplianin@me.by>
In-Reply-To: <20091122213230.38650f8d@hyperion.delvare>
References: <4B0459B1.50600@fechner.net> <4B081F0B.1060204@fechner.net>
	 <1258836102.1794.7.camel@localhost> <200911220303.36715.liplianin@me.by>
	 <1258858102.3072.14.camel@palomino.walls.org> <4B097E37.10402@fechner.net>
	 <1258920707.4201.16.camel@palomino.walls.org>
	 <4B099E37.5070405@fechner.net>  <20091122213230.38650f8d@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Nov 2009 19:17:59 -0500
Message-Id: <1258935479.1896.29.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-11-22 at 21:32 +0100, Jean Delvare wrote:
> On Sun, 22 Nov 2009 21:25:27 +0100, Matthias Fechner wrote:
> > Hi Andy,
> > 
> > Andy Walls wrote:
> > >
> > > # modprobe cx23885
> > > # modprobe i2c-dev
> > > # i2c-detect -l
> > > (to list all the i2c buses, including cx23885 mastered i2c buses)
> > >   
> > i2c-0    smbus         SMBus nForce2 adapter at 4d00       SMBus adapter
> > i2c-1    i2c           cx23885[0]                          I2C adapter
> > i2c-2    i2c           cx23885[0]                          I2C adapter
> > i2c-3    i2c           cx23885[0]                          I2C adapter
> > i2c-4    i2c           NVIDIA i2c adapter                  I2C adapter
> > i2c-5    i2c           NVIDIA i2c adapter                  I2C adapter
> > i2c-6    i2c           NVIDIA i2c adapter                  I2C adapter
> > 
> > > # i2c-detect -y N
> > > (to show the addresses in use on bus # N: only query the cx23885 buses)
> > >
> > >   
> > vdrhd1 ~ # i2cdetect -y 1
> >      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> > 00:          -- -- -- -- -- -- -- -- -- -- -- -- --
> > 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> > 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> > 30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
> > 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> > 50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
> > 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> > 70: -- -- -- -- -- -- -- --                        
> > vdrhd1 ~ # i2cdetect -y 2
> >      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> > 00:          -- -- -- -- -- -- -- -- -- -- -- -- --
> > 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> > 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> > 30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
> > 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> > 50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
> > 60: -- -- -- -- -- -- -- -- 68 -- -- -- -- -- -- --
> > 70: -- -- -- -- -- -- -- --                        
> > vdrhd1 ~ # i2cdetect -y 3
> >      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> > 00:          -- -- -- -- -- -- -- -- -- -- -- -- --
> > 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> > 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> > 30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
> > 40: -- -- -- -- 44 -- -- -- -- -- -- -- 4c -- -- --
> > 50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
> > 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> > 70: -- -- -- -- -- -- -- --                        
> 
> The fact that 0x30-0x37 and 0x50-0x5f all reply suggest that the bus
> driver erroneously returns success to "SMBus receive byte" transactions
> even when no device acks. This is a bug which should get fixed. If you
> point me to the I2C adapter driver code, I can take a look.

Jean,

Although Igor's information makes the original need for this moot, here
is the i2c adapter driver code:

http://linuxtv.org/hg/v4l-dvb/file/8bff7e6c44d4/linux/drivers/media/video/cx23885/cx23885-i2c.c

Note the CX2388[578] chips have 3 I2C masters, 2 for external buses, and
1 internal "on silicon" bus which the driver sets up as the 3rd bus.
The internal bus should at least have devices at 0x44 and 0x4c as
confirmed above.  I'll note the comment in this file, that indicates the
"on silicon" I2C bus runs at 1.95 MHz:

http://linuxtv.org/hg/v4l-dvb/file/8bff7e6c44d4/linux/drivers/media/video/cx23885/cx23885-core.c


The TeVii S470 card had what looked like at serial I2C EEPROM with the
A0, A1, and A2 pins all grounded, so I assume it is at 0x50 on one of
the CX23885's external I2C buses.

Regards,
Andy


> In the meantime, you can try i2cdetect -q to force i2cdetect to use
> "SMBus quick" commands for all the addresses. Beware though that some
> chips are known to not like it at all (in particular the infamous
> AT24RF08... not that I expect to ever see one on a TV adapter but you
> never know.)
> 
> At least the above scan has already found 3 chips.
> 


