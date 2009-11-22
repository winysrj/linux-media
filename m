Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:63619 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbZKVU0k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 15:26:40 -0500
Date: Sun, 22 Nov 2009 21:26:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, Matthias Fechner <idefix@fechner.net>,
	Jarod Wilson <jarod@wilsonet.com>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: Re: IR Receiver on an Tevii S470
Message-ID: <20091122212644.301b7e63@hyperion.delvare>
In-Reply-To: <1258920707.4201.16.camel@palomino.walls.org>
References: <4B0459B1.50600@fechner.net>
	<4B081F0B.1060204@fechner.net>
	<1258836102.1794.7.camel@localhost>
	<200911220303.36715.liplianin@me.by>
	<1258858102.3072.14.camel@palomino.walls.org>
	<4B097E37.10402@fechner.net>
	<1258920707.4201.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Sun, 22 Nov 2009 15:11:47 -0500, Andy Walls wrote:
> On Sun, 2009-11-22 at 19:08 +0100, Matthias Fechner wrote:
> > thanks a lot for your answer.
> > I uploaded two pictures I did from the card, you can find it here:
> > http://fechner.net/tevii-s470/
> > 
> > It is a CX23885.
> > The driver I use is the ds3000.
> > lspci says:
> [snip]
> 
> Thanks for the pictures.  OK so of the two other interesting chips on
> the S470:
> 
> U4 is an I2C connected EEPROM - we don't care about that for IR.
> 
> U10 appears to perhaps be a Silicon Labs C8051F300 microcontroller or
> similar:
> 
> http://www.silabs.com/products/mcu/smallmcu/Pages/C8051F30x.aspx
> 
> Since the 'F300 has an A/D convertor and has an SMBus interface
> (compatable with the I2C bus), I suspect this chip could be the IR
> controller on the TeVii S470.
> 
> Could you as root:
> 
> # modprobe cx23885
> # modprobe i2c-dev
> # i2c-detect -l
> (to list all the i2c buses, including cx23885 mastered i2c buses)
> # i2c-detect -y N
> (to show the addresses in use on bus # N: only query the cx23885 buses)
> 
> 
> i2c-detect was in the lm-sensors package last I checked.  (Jean can
> correct me if I'm wrong.)

It is actually named "i2cdetect" (no dash). It used to live in the
lm-sensors package (up to 2.10.x) but is now in i2c-tools:

http://www.lm-sensors.org/wiki/I2CTools

> With that information, I should be able to figure out what I2C address
> that microcontroller is listening to.

-- 
Jean Delvare
