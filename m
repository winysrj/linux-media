Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:50670 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759723AbZJGR1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2009 13:27:34 -0400
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV M116 for newer kernels
Date: Wed, 7 Oct 2009 19:26:23 +0200
Cc: Andy Walls <awalls@radix.net>, Jean Delvare <khali@linux-fr.org>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
References: <1254584660.3169.25.camel@palomino.walls.org> <1254707677.9896.10.camel@palomino.walls.org> <20091005085031.GA17431@moon>
In-Reply-To: <20091005085031.GA17431@moon>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910071926.29736.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 of October 2009 at 10:50:31, Aleksandr V. Piskunov wrote:
> > > Basicly during the I2C operation that reads scancode, controller seems
> > > to stop processing input from IR sensor, resulting a loss of keypress.
> > >
> > > So the solution(?) I found was to decrease the udelay in
> > > ivtv_i2c_algo_template from 10 to 5. Guess it just doubles the
> > > frequency of ivtv i2c bus or something like that. Problem went away, IR
> > > controller is now working as expected.
> >
> > That's a long standing error in the ivtv driver.  It ran the I2C bus at
> > 1/(2*10 usec) = 50 kHz instead of the standard 100 kHz.
> >
> > Technically any I2C device should be able to handle clock rates down to
> > about DC IIRC; so there must be a bug in the IR microcontroller
> > implementation.
> >
> > Also the CX23416 errantly marks its PCI register space as cacheable
> > which is probably wrong (see lspci output).  This may also be
> > interfering with proper I2C operation with i2c_algo_bit depedning on the
> > PCI bridges in your system.
> >
> > > So question is:
> > > 1) Is it ok to decrease udelay for this board?
> >
> > Sure, I think.  It would actually run the ivtv I2C bus at the nominal
> > clock rate specified by the I2C specification.
> >
> > I never had any reason to change it, as I feared causing regressions in
> > many well tested boards.
> >
> > > 2) If yes, how to do it right?
> >
> > Try:
> >
> > # modprobe ivtv newi2c=1
> >
> > to see if that works first.
>
> udelay=10, newi2c=0  => BAD
> udelay=10, newi2c=1  => BAD
> udelay=5,  newi2c=0  => OK
> udelay=5,  newi2c=1  => BAD
>
>
> newi2c=1 also throws some log messages, not sure if its ok or not.

Hi Aleksandr,

I had a look at the ivtv newi2c implementation and it doesn't have any good 
timing source. The only delay there is 5 times read of the clock line (SCL) 
and waiting for the clock/data line to go high or low.

The implementation assumes that the slave is generating sufficient clock line 
slow-down (by holding the clock line down) and that it is enough to have data 
line stable for very short time (5 times read of the clock line).

I'm not surprised that with newi2c=1 you see "Slave did not ack", because the 
clock just isn't correct. The generic i2c-algo-bit is doing much better job 
here.

Regards,
Oldrich.


> Oct  5 11:41:16 moon kernel: [45430.916449] ivtv: Start initialization,
> version 1.4.1 Oct  5 11:41:16 moon kernel: [45430.916618] ivtv0:
> Initializing card 0 Oct  5 11:41:16 moon kernel: [45430.916628] ivtv0:
> Autodetected AVerTV MCE 116 Plus card (cx23416 based) Oct  5 11:41:16 moon
> kernel: [45430.918887] ivtv 0000:03:06.0: PCI INT A -> GSI 20 (level, low)
> -> IRQ 20 Oct  5 11:41:16 moon kernel: [45430.919229] ivtv0:  i2c: i2c init
> Oct  5 11:41:16 moon kernel: [45430.919234] ivtv0:  i2c: setting scl and
> sda to 1 Oct  5 11:41:16 moon kernel: [45430.937745] cx25840 0-0044:
> cx25843-23 found @ 0x88 (ivtv i2c driver #0) Oct  5 11:41:16 moon kernel:
> [45430.949145] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45430.951628] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45430.954191] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45430.956724] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45430.959211] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45430.961749] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45430.964236] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45430.966722] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45430.966786] ivtv0:  i2c: i2c write to 43 failed Oct  5 11:41:16 moon
> kernel: [45430.971106] tuner 0-0061: chip found @ 0xc2 (ivtv i2c driver #0)
> Oct  5 11:41:16 moon kernel: [45430.974404] wm8739 0-001a: chip found @
> 0x34 (ivtv i2c driver #0) Oct  5 11:41:16 moon kernel: [45430.986328]
> ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel: [45430.988871]
> ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel: [45430.991355]
> ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel: [45430.993904]
> ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel: [45430.996427]
> ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel: [45430.998938]
> ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel: [45431.001477]
> ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel: [45431.003968]
> ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel: [45431.004053]
> ivtv0:  i2c: i2c write to 18 failed Oct  5 11:41:16 moon kernel:
> [45431.011333] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45431.013883] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45431.016418] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45431.018911] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45431.021463] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45431.023937] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45431.026478] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45431.028998] ivtv0:  i2c: Slave did not ack Oct  5 11:41:16 moon kernel:
> [45431.029063] ivtv0:  i2c: i2c write to 71 failed Oct  5 11:41:16 moon
> kernel: [45431.031468] ivtv0:  i2c: Slave did not ack ....


