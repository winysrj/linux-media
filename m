Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:63867 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbZKVCtz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 21:49:55 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org
In-Reply-To: <200911220303.36715.liplianin@me.by>
References: <4B0459B1.50600@fechner.net> <4B081F0B.1060204@fechner.net>
	 <1258836102.1794.7.camel@localhost>  <200911220303.36715.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Nov 2009 21:48:22 -0500
Message-Id: <1258858102.3072.14.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-11-22 at 03:03 +0200, Igor M. Liplianin wrote:
> On 21 ноября 2009 22:41:42 Andy Walls wrote:
> > On Sat, 2009-11-21 at 18:10 +0100, Matthias Fechner wrote:
> > > Hi,
> > >
> > > Matthias Fechner schrieb:
> > > > I bought some days ago a Tevii S470 DVB-S2 (PCI-E) card and got it
> > > > running with the driver from:
> > > > http://mercurial.intuxication.org/hg/s2-liplianin
> > > >
> > > > But I was not successfull in got the IR receiver working.
> > > > It seems that it is not supported yet by the driver.
> > > >
> > > > Is there maybe some code available to get the IR receiver with evdev
> > > > running?
> >
> > What bridge chip does the TeVii S470 use: a CX23885, CX23887, or
> > CX23888?
> >
> > Does the TeVii S470 have a separate microcontroller chip for IR
> > somewhere on the board, or does it not have one?  (If you can't tell,
> > just provide a list of the chip markings on the board.)
> >
> >
> > If the card is using the built in IR controller of the CX23888 than that
> > should be pretty easy to get working, we'll just need you to do some
> > experimentation with a patch.
> >
> > If the card is using the built in IR controller in the CX23885, then
> > you'll have to wait until I port my CX23888 IR controller changes to
> > work with the IR controller in the CX23885.  That should be somewhat
> > straightforward, but will take time.  Then we'll still need you to
> > experiment with a patch.
> >
> > If the card is using a separate IR microcontroller, I'm not sure where
> > to begin.... :P
> >
> > Regards,
> > Andy
> >
> It's cx23885 definitely.
> Remote uses NEC codes.

OK.  Things I have to do:

1. Add v4l2_subdev_ir_ops for the CX23885 to the cx25840 module.  Much
of this code will look like the cx23885/cx23888-ir.[ch] code, except a
little nicer when accessing I2C bus registers.

2. Add NEC pulse decoding to cx23885/cx23885-input.c.  This will be new
work, as right now the cx23885 driver only performs RC-5 decoding.

3. Add IR intiialization for the TeVii S470 into the cx23885 driver.
This will be easy, except for filling out the v4l2_subdev_ir_parameters
in cx23885/cx23885-input.c:cx23885_input_ir_start() ; I will need
someone with hardware to experiment.

> In any case I can test.

Thank you.  I will probably need you for testing when ready.


I was planning to do step 1 above for HVR-1800 IR anyway.

I will estimate that I may have something ready by about Christmas (25
December 2009), unless work becomes very busy.

Regards,
Andy

